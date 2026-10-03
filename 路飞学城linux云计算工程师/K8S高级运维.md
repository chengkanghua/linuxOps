# K8S高级运维

<http://book.luffycity.com/linux-book/index.html>

账号：luffy-linux

密码：luffycity

# 01走进Docker的世界

介绍docker的前世今生，了解docker的实现原理，以Django项目为例，带大家如何编写最佳的Dockerfile构建镜像。通过本章的学习，大家会知道docker的概念及基本操作，并学会构建自己的业务镜像，并通过抓包的方式掌握Docker最常用的bridge网络模式的通信。

#### 认识docker

* why
* what
* how

###### 为什么出现docker

需要一种轻量、高效的虚拟化能力

<!-- OCR_START -->
- App
- Bin/Library
- OperatingSystem
- Virtual Machine
- Container
- Hypervisor
- Container Runtime
- Hardware
- TraditionalDeployment
- VirtualizedDeployment
- ContainerDeployment
<!-- OCR_END -->

Docker 公司位于旧金山,原名dotCloud，底层利用了Linux容器技术（LXC）（在操作系统中实现资源隔离与限制）。为了方便创建和管理这些容器，dotCloud 开发了一套内部工具，之后被命名为“Docker”。Docker就是这样诞生的。

Hypervisor： 一种运行在基础物理服务器和操作系统之间的中间软件层，可允许多个操作系统和应用共享硬件 。常见的VMware的 Workstation 、ESXi、微软的Hyper-V或者思杰的XenServer。

Container Runtime：通过Linux内核虚拟化能力管理多个容器，多个容器共享一套操作系统内核。因此摘掉了内核占用的空间及运行所需要的耗时，使得容器极其轻量与快速。

###### 什么是docker

基于操作系统内核，提供轻量级虚拟化功能的CS架构的软件产品。

<!-- OCR_START -->
- container
- image
- manages
- Cllient
- docker CLI
- network
- data volumes
- REST API
- server
- docker daemon
<!-- OCR_END -->

基于轻量的特性，解决软件交付过程中的环境依赖

<!-- OCR_START -->
- Dev 开发人员
- Ops 运维人员
- 1.code代码
- Deploy...
- 2. war
- 交付
- 1.代码不一致
- lib1 v1
- 3. jar
- 2.软件配置
- lib2 v2
- 4. bin
- 3.软件依赖环境不一
- lib3缺失或者版本不-
- 镜像
- lib3 v3
- 容器
- 线上生产环境
- 本地开发环境
- 软件付流程
<!-- OCR_END -->

###### docker能做什么

* 可以把应用程序代码及运行依赖环境打包成镜像，作为交付介质，在各环境部署
* 可以将镜像（image）启动成为容器(container)，并且提供多容器的生命周期进行管理（启、停、删）
* container容器之间相互隔离，且每个容器可以设置资源限额
* 提供轻量级虚拟化功能，容器就是在宿主机中的一个个的虚拟的空间，彼此相互隔离，完全独立

###### 版本管理

* Docker 引擎主要有两个版本：企业版（EE）和社区版（CE）
* 每个季度(1-3,4-6,7-9,10-12)，企业版和社区版都会发布一个稳定版本(Stable)。社区版本会提供 4 个月的支持，而企业版本会提供 12 个月的支持
* 每个月社区版还会通过 Edge 方式发布月度版
* 从 2017 年第一季度开始，Docker 版本号遵循 YY.MM-xx 格式，类似于 Ubuntu 等项目。例如，2018 年 6 月第一次发布的社区版本为 18.06.0-ce

<!-- OCR_START -->
- v17.03
- v17.04
- v17.05
- v17.06
- v17.07
- v17.08
- v17.09
- v17.10
- Edge
- Stable
- EE
- Released quarterly
- Each version
- supported for 1 year
<!-- OCR_END -->

###### 发展史

13年成立，15年开始，迎来了飞速发展。

<!-- OCR_START -->
- Pulls
- LinuxKit
- 12,000,000,000
- containerd
- 11,000,000,000
- InfraKit
- 10,000,000,000
- SwarmKit
- 9,000,000,000
- HyperKit, VPNKit, DataKit
- 8,000,000,000
- 2017
- 7,000,000,000
- 2016
- 12B
- 2015
- 2014
- 6B
- 6,000,000,000
- 1B
- 1M
- 5,000,000,000
- Notary
- 4,000,000,000
- runc
- 3,000,000,000
- libnetwork
- 2,000,000,000
- libcontainer
- 2013
<!-- OCR_END -->

Docker 1.8之前，使用[LXC](https://linuxcontainers.org/fr/lxc/introduction/)，Docker在上层做了封装， 把LXC复杂的容器创建与使用方式简化为自己的一套命令体系。

之后，为了实现跨平台等复杂的场景，Docker抽出了libcontainer项目，把对namespace、cgroup的操作封装在libcontainer项目里，支持不同的平台类型。

2015 年 6 月，Docker 牵头成立 **OCI（Open Container Initiative，开放容器计划）**，目的是建立围绕容器的通用标准。该标准不受上层结构绑定——不限于特定操作系统、硬件、CPU 架构或公有云，任何人遵循它都能开发容器技术，为容器技术带来更广阔的发展空间。

OCI 成立后，libcontainer 交由 OCI 维护。由于 libcontainer 只包含与 kernel 交互的库，后来又加入了 CLI 工具，项目改名为 **runC**（<https://github.com/opencontainers/runc>），如今已成为功能强大的 runtime 工具。

Docker 也做了架构调整：把容器运行时相关程序从 docker daemon 剥离出来，形成 **containerd**。

* **向上**：为 Docker Daemon 提供 gRPC 接口，屏蔽下层结构变化，保证接口向下兼容
* **向下**：通过 containerd-shim 结合 runC，使引擎可独立升级——避免了以往 Docker Daemon 升级导致所有容器不可用的问题

<!-- OCR_START -->
- Docker Engine
- containerd
- containerd-shim
- runc
<!-- OCR_END -->

也就是说

* runC（libcontainer）是符合OCI标准的一个实现，与底层系统交互
* containerd是实现了OCI之上的容器的高级功能，比如镜像管理、容器执行的调用等
* Dockerd目前是最上层与CLI交互的进程，接收cli的请求并与containerd协作

###### 小结

1. 为了提供一种更加轻量的虚拟化技术，docker出现了
2. 借助于docker容器的轻、快等特性，解决了软件交付过程中的环境依赖问题，使得docker得以快速发展
3. Docker是一种CS架构的软件产品，可以把代码及依赖打包成镜像，作为交付介质，并且把镜像启动成为容器，提供容器生命周期的管理
4. docker-ce，每季度发布stable版本。18.06，18.09，19.03
5. 发展至今，docker已经通过制定OCI标准对最初的项目做了拆分，其中runC和containerd是docker的核心项目，理解docker整个请求的流程，对我们深入理解docker有很大的帮助

#### 安装

###### 配置宿主机网卡转发

```plain
## 若未配置，需要执行如下
$ cat <<EOF >  /etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
EOF
$ sysctl -p /etc/sysctl.d/docker.conf
```

###### Yum安装配置docker

```plain
## 下载阿里源repo文件
$ curl -o /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
$ curl -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

$ yum clean all && yum makecache
## yum安装
$ yum install docker-ce-20.10.6 -y
## 查看源中可用版本
$ yum list docker-ce --showduplicates | sort -r
## 安装旧版本
##yum install -y docker-ce-18.09.9

## 配置源加速
## https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors
mkdir -p /etc/docker
vi /etc/docker/daemon.json
{
  "registry-mirrors" : [
    "https://8xpk5wnt.mirror.aliyuncs.com"
  ]
}

## 设置开机自启
systemctl enable docker  
systemctl daemon-reload

## 启动docker
systemctl start docker 

## 查看docker信息
docker info

## docker-client
which docker
## docker daemon
ps aux |grep docker
## containerd
ps aux|grep containerd
systemctl status containerd
```

#### 核心要素及常用操作详解

<!-- OCR_START -->
- Client
- DOCKER_HOST
- Registry
- docker build
- Docker daemon
- docker
- pull
- Containers
- Images
- NGINX
<!-- OCR_END -->

三大核心要素：镜像(Image)、容器(Container)、仓库(Registry)

###### 镜像（Image）

打包了业务代码及运行环境的包，是静态的文件，不能直接对外提供服务。

###### 容器（Container）

镜像的运行时，可以对外提供服务。

###### 仓库（Registry）

存放镜像的地方

* 公有仓库，Docker Hub，阿里，网易...
* 私有仓库，企业内部搭建
  * Docker Registry，Docker官方提供的镜像仓库存储服务
  * Harbor, 是Docker Registry的更高级封装，它除了提供友好的Web UI界面，角色和用户权限管理，用户操作审计等功能
* 镜像访问地址形式 registry.devops.com/demo/hello:latest,若没有前面的url地址，则默认寻找Docker Hub中的镜像，若没有tag标签，则使用latest作为标签。 比如，docker pull nginx，会被解析成docker.io/library/nginx:latest
* 公有的仓库中，一般存在这么几类镜像
  * 操作系统基础镜像（centos，ubuntu，suse，alpine）
  * 中间件（nginx，redis，mysql，tomcat）
  * 语言编译环境（python，java，golang）
  * 业务镜像（django-demo...）

容器和仓库不会直接交互，都是以镜像为载体来操作。

1. 查看镜像列表

```plain
$ docker images

```

如何获取镜像

* 从远程仓库拉取

```plain
$ docker pull nginx:alpine
$ docker images
```

  使用tag命令

```plain
$ docker tag nginx:alpine 172.21.51.143:5000/nginx:alpine
$ docker images
```

本地构建

```plain
$ docker build . -t my-nginx:ubuntu -f Dockerfile

```

2. 如何通过镜像启动容器

   

```plain
$ docker run --name my-nginx-alpine -d nginx:alpine

```

4. 如何知道容器内部运行了什么程序？

```plain
# 进入容器内部,分配一个tty终端
$ docker exec -ti my-nginx-alpine /bin/sh
# ps aux
```

5. docker怎么知道容器启动后该执行什么命令？

通过docker build来模拟构建一个nginx的镜像，

* 创建Dockerfile

```plain
# 告诉docker使用哪个基础镜像作为模板，后续命令都以这个镜像为基础 
FROM ubuntu

# RUN命令会在上面指定的镜像里执行命令 
RUN apt-get update && apt install -y nginx

#告诉docker，启动容器时执行如下命令
CMD ["/usr/sbin/nginx", "-g","daemon off;"]
```

构建本地镜像

```plain
$ docker build . -t my-nginx:ubuntu -f Dockerfile

```

6. 使用新镜像启动容器

```plain
   $ docker run --name my-nginx-ubuntu -d my-nginx:ubuntu

```

7. 进入容器查看进程

```plain
   $ docker exec -ti my-nginx-ubuntu /bin/sh
   # ps aux
```

8. 如何访问容器内服务

```plain
# 进入容器内部
$ docker exec -ti my-nginx-alpine /bin/sh
# ps aux|grep nginx
# curl localhost:80
```

9. 宿主机中如何访问容器服务

```plain
# 删掉旧服务,重新启动
$ docker rm -f my-nginx-alpine
$ docker run --name my-nginx-alpine -d -p 8080:80 nginx:alpine
$ curl 172.21.51.143:8080
```

10. docker client如何与daemon通信

```plain
# /var/run/docker.sock
$ docker run --name portainer -d -p 9001:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
```

###### 操作演示

<!-- OCR_START -->
- DockerCommandsDiagram
- images
- commit
- Container
- xrmi
- create
- start
- tag
- history
- Running
- unpause
- files/
- cp
- folders
- pause
- Host
- wait
- logs
- inspect
- attach
- =port
- Hdiff
- ps
- p，g
- top
- xrm
- exec
- import
- export
- filesystem
- load
- Tar files
- save
- build
- Dockerfile
- version
- oinfo
- events
- pull
- Qsearch
- Registry
- login
- logout
- Engine
- push
<!-- OCR_END -->

1. 查看所有镜像：

```plain
$ docker images

```

1. 拉取镜像:

```plain
$ docker pull nginx:alpine

```

1. 如何唯一确定镜像:
2. image_id
3. repository:tag

```plain
$ docker images
REPOSITORY    TAG                 IMAGE ID            CREATED             SIZE
nginx         alpine              377c0837328f        2 weeks ago         19.7MB
```

导出镜像到文件中

```plain
$ docker save -o nginx-alpine.tar nginx:alpine

```

从文件中加载镜像

```plain
$ docker load -i nginx-alpine.tar

```

部署镜像仓库

<https://docs.docker.com/registry/>

```plain
## 使用docker镜像启动镜像仓库服务
$ docker run -d -p 5000:5000 --restart always --name registry registry:2

## 默认仓库不带认证，若需要认证，参考https://docs.docker.com/registry/deploying/#restricting-access
```

推送本地镜像到镜像仓库中

```plain
$ docker tag nginx:alpine localhost:5000/nginx:alpine
$ docker push localhost:5000/nginx:alpine

## 查看仓库内元数据
$ curl -X GET http://172.21.51.143:5000/v2/_catalog
$ curl -X GET http://172.21.51.143:5000/v2/nginx/tags/list

## 镜像仓库给外部访问，不能通过localhost，尝试使用内网地址172.21.51.143:5000/nginx:alpine
$ docker tag nginx:alpine 172.21.51.143:5000/nginx:alpine
$ docker push 172.21.51.143:5000/nginx:alpine
The push refers to repository [172.21.51.143:5000/nginx]
Get https://172.21.51.143:5000/v2/: http: server gave HTTP response to HTTPS client
## docker默认不允许向http的仓库地址推送，如何做成https的，参考：https://docs.docker.com/registry/deploying/#run-an-externally-accessible-registry
## 我们没有可信证书机构颁发的证书和域名，自签名证书需要在每个节点中拷贝证书文件，比较麻烦，因此我们通过配置daemon的方式，来跳过证书的验证：
$ cat /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://8xpk5wnt.mirror.aliyuncs.com"
  ],
  "insecure-registries": [
     "172.21.51.143:5000"
  ]
}
$ systemctl restart docker
$ docker push 172.21.51.143:5000/nginx:alpine
$ docker images    # IMAGE ID相同，等于起别名或者加快捷方式
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
172.21.51.143:5000/nginx   alpine              377c0837328f        4 weeks ago         
nginx                    alpine              377c0837328f        4 weeks ago         
localhost:5000/nginx     alpine              377c0837328f        4 weeks ago         
registry                 2                   708bc6af7e5e        2 months ago
```

删除镜像

```plain
docker rmi nginx:alpine

```

查看容器列表

```plain
## 查看运行状态的容器列表
$ docker ps

## 查看全部状态的容器列表
$ docker ps -a
```

启动容器

```plain
## 后台启动
$ docker run --name nginx -d nginx:alpine

## 映射端口,把容器的端口映射到宿主机中,-p <host_port>:<container_port>
$ docker run --name nginx -d -p 8080:80 nginx:alpine

## 资源限制,最大可用内存500M
$ docker run --memory=500m nginx:alpine
```

容器数据持久化

```plain
 ## 挂载主机目录
 $ docker run --name nginx -d  -v /opt:/opt  nginx:alpine
 $ docker run --name mysql -e MYSQL_ROOT_PASSWORD=123456  -d -v /opt/mysql/:/var/lib/mysql mysql:5.7
```

进入容器或者执行容器内的命令

```plain
 $ docker exec -ti <container_id_or_name> /bin/sh
 $ docker exec <container_id_or_name> hostname
```

主机与容器之间拷贝数据

```plain
 ## 主机拷贝到容器
 $ echo '123'>/tmp/test.txt
 $ docker cp /tmp/test.txt nginx:/tmp
 $ docker exec -ti nginx cat /tmp/test.txt
 123

 ## 容器拷贝到主机
 $ docker cp nginx:/tmp/test.txt ./
```

挂载已有的数据，重新创建镜像仓库容器

```plain
 ## 解压离线镜像文件
 $ tar zxf registry.tar.gz -C /opt

 ## 删除当前镜像仓库容器
 $ docker rm -f registry
 ## 使用docker镜像启动镜像仓库服务
 $ docker run -d -p 5000:5000 --restart always -v /opt/registry:/var/lib/registry --name registry registry:2
```

假设启动镜像仓库服务的主机地址为172.21.51.143，该目录中已存在的镜像列表：

```plain
| 现镜像仓库地址                                               | 原镜像仓库地址                                              | 
| ------------------------------------------------------------ |------------------------------------------------------------ | 
| 172.21.51.143:5000/coreos/flannel:v0.11.0-amd64              | quay.io/coreos/flannel:v0.11.0-amd64                        | 
| 172.21.51.143:5000/mysql:5.7                                 | mysql:5.7                                                   | 
| 172.21.51.143:5000/nginx:alpine                              | nginx:alpine                                                | 
| 172.21.51.143:5000/centos:centos7.5.1804                     | centos:centos7.5.1804                                       | 
| 172.21.51.143:5000/elasticsearch/elasticsearch:7.4.2         |docker.elastic.co/elasticsearch/elasticsearch:7.4.2          | 
| 172.21.51.143:5000/fluentd-es-root:v1.6.2-1.0                | quay.io/fluentd_elasticsearch/fluentd:v2.5.2                | 
| 172.21.51.143:5000/kibana/kibana:7.4.2                       | docker.elastic.co/kibana/kibana:7.4.2                       | 
| 172.21.51.143:5000/kubernetesui/dashboard:v2.0.0-beta5       | kubernetesui/dashboard:v2.0.0-beta5                         | 
| 172.21.51.143:5000/kubernetesui/metrics-scraper:v1.0.1       | kubernetesui/metrics-scraper:v1.0.1                         | 
| 172.21.51.143:5000/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0 | quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0 | 
| 172.21.51.143:5000/jenkinsci/blueocean:latest                | jenkinsci/blueocean:latest                                  | 
| 172.21.51.143:5000/sonarqube:7.9-community                   | sonarqube:7.9-community                                     | 
| 172.21.51.143:5000/postgres:11.4                             | postgres:11.4                                               |
```

1 查看容器日志

```plain
 ## 查看全部日志
 $ docker logs nginx

 ## 实时查看最新日志
 $ docker logs -f nginx

 ## 从最新的100条开始查看
 $ docker logs --tail=100 -f nginx
```

2 停止或者删除容器

```plain
 ## 停止运行中的容器
 $ docker stop nginx

 ## 启动退出容器
 $ docker start nginx

 ## 删除非运行中状态的容器
 $ docker rm nginx

 ## 删除运行中的容器
 $ docker rm -f nginx
```

  
3 查看容器或者镜像的明细

```plain
 ## 查看容器详细信息，包括容器IP地址等
 $ docker inspect nginx

 ## 查看镜像的明细信息
 $ docker inspect nginx:alpine
```

  
**Dockerfile使用**

```plain
$ docker build . -t ImageName:ImageTag -f Dockerfile

```

Dockerfile是一堆指令，在docker build的时候，按照该指令进行操作，最终生成我们期望的镜像

* FROM 指定基础镜像，必须为第一个命令

```plain
格式：
    FROM <image>
    FROM <image>:<tag>
示例：
    FROM mysql:5.7
注意：
    tag是可选的，如果不使用tag时，会使用latest版本的基础镜像
```

MAINTAINER 镜像维护者的信息

```plain
格式：
    MAINTAINER <name>
示例：
    MAINTAINER Yongxin Li
    MAINTAINER inspur_lyx@hotmail.com
    MAINTAINER Yongxin Li <inspur_lyx@hotmail.com>
```

COPY|ADD 添加本地文件到镜像中

```plain
格式：
    COPY <src>... <dest>
示例：
    ADD hom* /mydir/          # 添加所有以"hom"开头的文件
    ADD test relativeDir/     # 添加 "test" 到 `WORKDIR`/relativeDir/
    ADD test /absoluteDir/    # 添加 "test" 到 /absoluteDir/
```

WORKDIR 工作目录

```plain
格式：
    WORKDIR /path/to/workdir
示例：
    WORKDIR /a  (这时工作目录为/a)
注意：
    通过WORKDIR设置工作目录后，Dockerfile中其后的命令RUN、CMD、ENTRYPOINT、ADD、COPY等命令都会在该目录下执行
```

RUN 构建镜像过程中执行命令

```plain
格式：
    RUN <command>
示例：
    RUN yum install nginx
    RUN pip install django
    RUN mkdir test && rm -rf /var/lib/unusedfiles
注意：
    RUN指令创建的中间镜像会被缓存，并会在下次构建中使用。如果不想使用这些缓存镜像，可以在构建时指定--no-cache参数，如：docker build --no-cache
```

CMD 构建容器后调用，也就是在容器启动时才进行调用

```plain
格式：
    CMD ["executable","param1","param2"] (执行可执行文件，优先)
    CMD ["param1","param2"] (设置了ENTRYPOINT，则直接调用ENTRYPOINT添加参数)
    CMD command param1 param2 (执行shell内部命令)
示例：
    CMD ["/usr/bin/wc","--help"]
    CMD ping www.baidu.com
注意：
    CMD不同于RUN，CMD用于指定在容器启动时所要执行的命令，而RUN用于指定镜像构建时所要执行的命令。
```

ENTRYPOINT 设置容器初始化命令，使其可执行化

```plain
格式：
    ENTRYPOINT ["executable", "param1", "param2"] (可执行文件, 优先)
    ENTRYPOINT command param1 param2 (shell内部命令)
示例：
    ENTRYPOINT ["/usr/bin/wc","--help"]
注意：
    ENTRYPOINT与CMD非常类似，不同的是通过docker run执行的命令不会覆盖ENTRYPOINT，而docker run命令中指定的任何参数，都会被当做参数再次传递给ENTRYPOINT。Dockerfile中只允许有一个ENTRYPOINT命令，多指定时会覆盖前面的设置，而只执行最后的ENTRYPOINT指令
```

ENV

```plain
格式：
    ENV <key> <value>
    ENV <key>=<value>
示例：
    ENV myName John
    ENV myCat=fluffy
```

EXPOSE

```plain
格式：
    EXPOSE <port> [<port>...]
示例：
    EXPOSE 80 443
    EXPOSE 8080
    EXPOSE 11211/tcp 11211/udp
注意：
    EXPOSE并不会让容器的端口访问到主机。要使其可访问，需要在docker run运行容器时通过-p来发布这些端口，或通过-P参数来发布EXPOSE导出的所有端口
```

<!-- OCR_START -->
- FROM
- 它的妈妈是谁（基础镜像）
- MAINTAINER
- 告诉别人，你创造了它（维护者信息）
- 你想让它干啥（把命令前面加上RUN）
- ADD
- 往它肚子里放点文件（COPY文件，会自动解压）
- WORKDIR
- 我是cd，今天刚化了妆（当前工作目录）
- VOLUME
- 给我一个存放行李的地方（目录挂载）
- EXPOSE
- 我要打开的门是啥（端口）
- 奔跑吧，兄弟！（进程要一直运行下去）
<!-- OCR_END -->

\
基础环境镜像

```plain
FROM java:8-alpine

RUN apk add --update ca-certificates && rm -rf /var/cache/apk/* && \
  find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
  -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts -storepass changeit -noprompt \
  -file {} -alias {} \; && \
  keytool -list -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts --storepass changeit

ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
```

前端镜像

```plain
FROM nginx:1.19.0-alpine

LABEL maintainer="mritd <mritd@linux.com>"

ARG TZ='Asia/Shanghai'
ENV TZ ${TZ}

RUN apk upgrade --update \
    && apk add bash tzdata curl wget ca-certificates \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /usr/share/nginx/html /var/cache/apk/*

COPY landscape-animation-experiment /usr/share/nginx/html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
```

  
java镜像

```plain
FROM java:8u111

ENV JAVA_OPTS "\
-Xmx4096m \
-XX:MetaspaceSize=256m \
-XX:MaxMetaspaceSize=256m"
ENV JAVA_HOME /usr/java/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin

COPY target/myapp.jar myapp.jar

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

EXPOSE 9000
CMD java ${JAVA_OPTS} -jar myapp.jar
```

* golang镜像
* 多阶段构建

###### 多阶构建

<https://gitee.com/agagin/href-counter.git>

原始构建：

```plain
FROM golang:1.13

WORKDIR /go/src/github.com/alexellis/href-counter/

COPY vendor vendor
COPY app.go .
ENV GOPROXY https://goproxy.cn
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
```

```plain
$ docker build . -t href-counter:v1 -f Dockerfile

```

多阶构建：

```plain
FROM golang:1.13 AS builder

WORKDIR /go/src/github.com/alexellis/href-counter/

COPY vendor vendor
COPY app.go    .
ENV GOPROXY https://goproxy.cn

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:3.10
RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder  /go/src/github.com/alexellis/href-counter/app    .

CMD ["./app"]
```

  

```plain
$ docker build . -t href-counter:v2 -f Dockerfile.multi

```

原则：

* 不必要的内容不要放在镜像中
* 减少不必要的层文件
* 减少网络传输操作
* 可以适当的包含一些调试命令

###### 通过1号进程理解容器的本质

```plain
$ docker exec -ti my-nginx-alpine /bin/sh
#/ ps aux
```

容器启动的时候可以通过命令去覆盖默认的CMD

```plain
$ docker run -d --name xxx nginx:alpine <自定义命令>
# <自定义命令>会覆盖镜像中指定的CMD指令，作为容器的1号进程启动。

$ docker run -d --name test-3 nginx:alpine echo 123

$ docker run -d --name test-4 nginx:alpine ping www.luffycity.com
```

本质上讲容器是利用namespace和cgroup等技术在宿主机中创建的独立的虚拟空间，这个空间内的网络、进程、挂载等资源都是隔离的。\

```plain
$ docker exec -ti my-nginx /bin/sh
#/ ip addr
#/ ls -l /
#/ apt install xxx
#/ #安装的软件对宿主机和其他容器没有任何影响，和虚拟机不同的是，容器间共享一个内核，所以容器内没法升级内核
```

#### Django应用容器化实践

###### django项目介绍

* 项目地址：<https://gitee.com/agagin/python-demo.git>
* python3 + django + uwsgi + nginx + mysql
* 内部服务端口8002

###### 容器化Django项目

*dockerfiles/myblog/Dockerfile*

```plain
# This my first django Dockerfile
# Version 1.0

# Base images 基础镜像
FROM centos:centos7.5.1804

#MAINTAINER 维护者信息
LABEL maintainer="inspur_lyx@hotmail.com"

#ENV 设置环境变量
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#RUN 执行以下命令
RUN curl -so /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo && rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y  python36 python3-devel gcc pcre-devel zlib-devel make net-tools nginx

#工作目录
WORKDIR /opt/myblog

#拷贝文件至工作目录
COPY . .

# 拷贝nginx配置文件
COPY myblog.conf /etc/nginx

#安装依赖的插件
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt

RUN chmod +x run.sh && rm -rf ~/.cache/pip

#EXPOSE 映射端口
EXPOSE 8002

#容器启动时执行命令
CMD ["./run.sh"]
```

执行构建：

```plain
$ docker build . -t myblog:v1 -f Dockerfile

```

###### 运行mysql

```plain
$ docker run -d -p 3306:3306 --name mysql  -v /opt/mysql:/var/lib/mysql -e MYSQL_DATABASE=myblog -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

## 参数传递
## 查看数据库
$ docker exec -ti mysql bash
#/ mysql -uroot -p123456
#/ show databases;

## navicator连接
```

###### 启动Django应用

```plain
## 启动容器
$ docker run -d -p 8002:8002 --name myblog -e MYSQL_HOST=172.21.51.143 -e MYSQL_USER=root -e MYSQL_PASSWD=123456  myblog:v1 

## migrate
$ docker exec -ti myblog bash
#/ python3 manage.py makemigrations
#/ python3 manage.py migrate
#/ python3 manage.py createsuperuser

## 创建超级用户
$ docker exec -ti myblog python3 manage.py createsuperuser

## 收集静态文件
## $ docker exec -ti myblog python3 manage.py collectstatic
```

访问172.21.51.143:8002/admin

#### 实现原理

docker优势：

* 轻量级的虚拟化
* 容器快速启停

虚拟化核心需要解决的问题：资源隔离与资源限制

* 虚拟机硬件虚拟化技术， 通过一个 hypervisor 层实现对资源的彻底隔离。
* 容器则是操作系统级别的虚拟化，利用的是内核的 Cgroup 和 Namespace 特性，此功能完全通过软件实现。

###### Namespace 资源隔离

命名空间是全局资源的一种抽象，将资源放到不同的命名空间中，各个命名空间中的资源是相互隔离的。

| **分类** | **系统调用参数** | **相关内核版本** |
| --- | --- | --- |
| Mount namespaces | CLONE_NEWNS | [Linux 2.4.19](http://lwn.net/2001/0301/a/namespaces.php3) |
| UTS namespaces | CLONE_NEWUTS | [Linux 2.6.19](http://lwn.net/Articles/179345/) |
| IPC namespaces | CLONE_NEWIPC | [Linux 2.6.19](http://lwn.net/Articles/187274/) |
| PID namespaces | CLONE_NEWPID | [Linux 2.6.24](http://lwn.net/Articles/259217/) |
| Network namespaces | CLONE_NEWNET | [始于Linux 2.6.24 完成于 Linux 2.6.29](http://lwn.net/Articles/219794/) |
| User namespaces | CLONE_NEWUSER | [始于 Linux 2.6.23 完成于 Linux 3.8](http://lwn.net/Articles/528078/) |

我们知道，docker容器对于操作系统来讲其实是一个进程，我们可以通过原始的方式来模拟一下容器实现资源隔离的基本原理：

linux系统中，通常可以通过clone()实现进程创建的系统调用 ，原型如下：\

```plain
int clone(int (*child_func)(void *), void *child_stack, int flags, void *arg);

```

* **child_func** : 传入子进程运行的程序主函数。
* **child_stack** : 传入子进程使用的栈空间。
* **flags** : 表示使用哪些 CLONE\_\* 标志位。
* **args** : 用于传入用户参数。

示例一：实现进程独立的UTS空间\

```plain
#define _GNU_SOURCE
#include <sys/mount.h> 
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>
#define STACK_SIZE (1024 * 1024)
static char container_stack[STACK_SIZE];
char* const container_args[] = {
  "/bin/bash",
  NULL
};

int container_main(void* arg)
{
  printf("Container - inside the container!\n");
  sethostname("container",10); /* 设置hostname */
  execv(container_args[0], container_args);
  printf("Something's wrong!\n");
  return 1;
}

int main()
{
  printf("Parent - start a container!\n");
  int container_pid = clone(container_main, container_stack+STACK_SIZE, CLONE_NEWUTS | SIGCHLD , NULL);
  waitpid(container_pid, NULL, 0);
  printf("Parent - container stopped!\n");
  return 0;
}
```

执行编译并测试：

```plain
$ gcc -o ns_uts ns_uts.c
$ ./ns_uts
$ hostname
```

示例二：实现容器独立的进程空间

```plain
#define _GNU_SOURCE
#include <sys/mount.h> 
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>
#define STACK_SIZE (1024 * 1024)
static char container_stack[STACK_SIZE];
char* const container_args[] = {
  "/bin/bash",
  NULL
};

int container_main(void* arg)
{
  printf("Container [%5d] - inside the container!\n", getpid());
  sethostname("container",10); /* 设置hostname */
  execv(container_args[0], container_args);
  printf("Something's wrong!\n");
  return 1;
}

int main()
{
  printf("Parent [%5d] - start a container!\n", getpid());
  int container_pid = clone(container_main, container_stack+STACK_SIZE, CLONE_NEWUTS | CLONE_NEWPID | SIGCHLD , NULL);
  waitpid(container_pid, NULL, 0);
  printf("Parent - container stopped!\n");
  return 0;
}
```

执行编译并测试：

```plain
$ gcc -o ns_pid ns_pid.c
$ ./ns_pid
$ echo $$
```

如何确定进程是否属于同一个namespace：

```plain
$ ./ns_pid
Parent [ 8061] - start a container!
$ pstree -p 8061
pid1(8061)───bash(8062)───pstree(8816)
$ ls -l /proc/8061/ns
lrwxrwxrwx 1 root root 0 Jun 24 12:51 ipc -> ipc:[4026531839]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 mnt -> mnt:[4026531840]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 net -> net:[4026531968]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 pid -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 user -> user:[4026531837]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 uts -> uts:[4026531838]
$ ls -l /proc/8062/ns
lrwxrwxrwx 1 root root 0 Jun 24 12:51 ipc -> ipc:[4026531839]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 mnt -> mnt:[4026531840]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 net -> net:[4026531968]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 pid -> pid:[4026534845]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 user -> user:[4026531837]
lrwxrwxrwx 1 root root 0 Jun 24 12:51 uts -> uts:[4026534844]

## 发现pid和uts是和父进程使用了不同的ns，其他的则是继承了父进程的命名空间
```

综上：通俗来讲，docker在启动一个容器的时候，会调用Linux Kernel Namespace的接口，来创建一块虚拟空间，创建的时候，可以支持设置下面这几种（可以随意选择）,docker默认都设置。

* pid：用于进程隔离（PID：进程ID）
* net：管理网络接口（NET：网络）
* ipc：管理对 IPC 资源的访问（IPC：进程间通信（信号量、消息队列和共享内存））
* mnt：管理文件系统挂载点（MNT：挂载）
* uts：隔离主机名和域名
* user：隔离用户和用户组

###### CGroup 资源限制

namespace 解决了容器之间的**隔离**问题，但无法控制每个容器能占用多少资源：若某个容器执行 CPU 密集型任务，就会抢占资源、影响其他容器的性能。因此，在解决隔离之后，**如何限制资源使用**成为下一个主要问题——这就是 CGroups 的作用。

<!-- OCR_START -->
- DOCKER SHARED RESOURCES
- CPU
- MEMORY
- CONTAINER
<!-- OCR_END -->

Control Groups（简称 CGroups）

cgroups是Linux内核提供的一种机制，这种机制可以根据需求吧一系列系统任务及其子任务整合(或分隔)到按资源划分等级的不同组中，从而为系统资源管理提供一个统一的框架。

CGroups能够隔离宿主机器上的物理资源，例如 CPU、内存、磁盘 I/O 。每一个 CGroup 都是一组被相同的标准和参数限制的进程。而我们需要做的，其实就是把容器这个进程加入到指定的Cgroup中。深入理解CGroup，请\[点此]\(http://book.luffycity.com/linux-book/K8S%E9%AB%98%E7%BA%A7%E8%BF%90%E7%BB%B4/week1/)。

###### UnionFS 联合文件系统

Linux namespace和cgroup分别解决了容器的资源隔离与资源限制，那么容器是很轻量的，通常每台机器中可以运行几十上百个容器， 这些个容器是共用一个image，还是各自将这个image复制了一份，然后各自独立运行呢？ 如果每个容器之间都是全量的文件系统拷贝，那么会导致至少如下问题：

* 运行容器的速度会变慢
* 容器和镜像对宿主机的磁盘空间的压力

怎么解决这个问题------Docker的存储驱动

* 镜像分层存储
* UnionFS

Docker 镜像是由一系列的层组成的，每层代表 Dockerfile 中的一条指令，比如下面的 Dockerfile 文件：\

```plain
FROM ubuntu:15.04
COPY . /app
RUN make /app
CMD python /app/app.py
```

这里的 Dockerfile 包含4条命令，其中每一行就创建了一层，下面显示了上述Dockerfile构建出来的镜像运行的容器层的结构：

<!-- OCR_START -->
- ThinR/Wlayer
- Containerlayer
- 91e54dfb1179
- OB
- d74508fb6632
- 1.895KB
- Imagelayers(R/o)
- c22013c84729
- 194.5KB
- d3a1f33e8a5a
- 188.1MB
- ubuntu:15.04
- Container
- （basedonubuntu:15.04image)
<!-- OCR_END -->

镜像就是由这些层一层一层堆叠起来的，镜像中的这些层都是只读的，当我们运行容器的时候，就可以在这些基础层至上添加新的可写层，也就是我们通常说的容器层，对于运行中的容器所做的所有更改（比如写入新文件、修改现有文件、删除文件）都将写入这个容器层。

容器层主要利用了**写时复制（CoW，copy-on-write）**技术：只在需要写的时候才去复制，针对的是已有文件的修改场景。

要点：

* 所有容器**共享 image 的文件系统**，数据都从 image 读取
* 只有要对文件**写入**时，才把该文件从 image 复制到自己的文件系统再修改
* 因此无论多少个容器共享同一个 image，写操作都只作用在各自的副本上，**不会修改 image 源文件**，容器之间互不影响

CoW 有效提高了磁盘利用率。

<!-- OCR_START -->
- docker
- ThinR/Wlayer.
- 91e54dfb1179
- OB
- d74508fb6632
- 1.895KB
- c22013c84729
- 194.5KB
- d3a1f33e8a5a
- 188.1MB
- ubuntu:15.04lmage
<!-- OCR_END -->

**镜像中每一层的文件都是分散在不同的目录中的，如何把这些不同目录的文件整合到一起呢？**

UnionFS 其实是一种为 Linux 操作系统设计的用于把多个文件系统联合到同一个挂载点的文件系统服务。 它能够将不同文件夹中的层联合（Union）到了同一个文件夹中，整个联合的过程被称为联合挂载（Union Mount）。

<!-- OCR_START -->
- DOCKER AUFS
- UNION MOUNT
- /var/lib/docker/aufs/mnt/..
- UNION MOUNT POINT
- 0ed1134904cc
- /var/lib/docker/aufs/diff/..
- CONTAINER LAYER
- 2c477f7b6b39
- f9d15e8f78ff
- IMAGE LAYER
- da64ec3a99b4
- a934ca1e169d
<!-- OCR_END -->

上图是AUFS的实现，AUFS是作为Docker存储驱动的一种实现，Docker 还支持了不同的存储驱动，包括 aufs、devicemapper、overlay2、zfs 和 Btrfs 等等，在最新的 Docker 中，overlay2 取代了 aufs 成为了推荐的存储驱动，但是在没有 overlay2 驱动的机器上仍然会使用 aufs 作为 Docker 的默认驱动。

#### Docker网络

docker容器是一块具有隔离性的虚拟系统，容器内可以有自己独立的网络空间，

* 多个容器之间是如何实现通信的呢？
* 容器和宿主机之间又是如何实现的通信呢？
* 使用-p参数是怎么实现的端口映射?

带着这些问题，我们来学习一下docker的网络模型，最后我会通过抓包的方式，给大家演示一下数据包在容器和宿主机之间的转换过程。

##### 网络模式

我们在使用docker run创建Docker容器时，可以用--net选项指定容器的网络模式，Docker有以下4种网络模式：

* bridge模式，使用--net=bridge指定，默认设置
* host模式，使用--net=host指定，容器内部网络空间共享宿主机的空间，效果类似直接在宿主机上启动一个进程，端口信息和宿主机共用
* container模式，使用--net=container:NAME_or_ID指定指定容器与特定容器共享网络命名空间
* none模式，使用--net=none指定网络模式为空，即仅保留网络命名空间，但是不做任何网络相关的配置(网卡、IP、路由等)

##### bridge模式

那我们之前在演示创建docker容器的时候其实是没有指定的网络模式的，如果不指定的话默认就会使用bridge模式，bridge本意是桥的意思，其实就是网桥模式。

那我们怎么理解网桥，如果需要做类比的话，我们可以把网桥看成一个二层的交换机设备，我们来看下这张图：

交换机通信简图

![]()

交换机网络通信流程：

![]()

网桥模式示意图

<!-- OCR_START -->
- 英特网
- 调制解调器
- 路由器
- Linux主机
- 192.168.1.1
- 主机网络接口
- 192.168.1.10 : 24
- etho
- SNAT
- DNAT-
- NAT
- 网络地址转换
- dockero
- 虚拟网桥
- vetho
- veth0
- 172.17.0.1
- veth pair
- veth1
- 虚拟网络接口对
- 容器1
- 容器2
- 容器n
- 172.17.0.4
- 172.17.0.5
- 172.17.0.n : 24
<!-- OCR_END -->

Linux 中，能够起到**虚拟交换机作用**的网络设备，是网桥（Bridge）。它是一个工作在**数据链路层**（Data Link）的设备，主要功能是**根据 MAC 地址将数据包转发到网桥的不同端口上**。 网桥在哪，查看网桥

```plain
$ yum install -y bridge-utils
$ brctl show
bridge name     bridge id               STP enabled     interfaces
docker0         8000.0242b5fbe57b       no              veth3a496ed
```

有了网桥之后，那我们看下docker在启动一个容器的时候做了哪些事情才能实现容器间的互联互通

Docker 创建一个容器的时候，会执行如下操作：

* 创建一对虚拟接口/网卡，也就是veth pair；
* veth pair的一端桥接 到默认的 docker0 或指定网桥上，并具有一个唯一的名字，如 vethxxxxxx；
* veth paid的另一端放到新启动的容器内部，并修改名字作为 eth0，这个网卡/接口只在容器的命名空间可见；
* 从网桥可用地址段中（也就是与该bridge对应的network）获取一个空闲地址分配给容器的 eth0
* 配置容器的默认路由

那整个过程其实是docker自动帮我们完成的，清理掉所有容器，来验证。\

```plain
## 清掉所有容器
$ docker rm -f `docker ps -aq`
$ docker ps
$ brctl show # 查看网桥中的接口，目前没有

## 创建测试容器test1
$ docker run -d --name test1 nginx:alpine
$ brctl show # 查看网桥中的接口，已经把test1的veth端接入到网桥中
$ ip a |grep veth # 已在宿主机中可以查看到
$ docker exec -ti test1 sh 
/ # ifconfig  # 查看容器的eth0网卡及分配的容器ip

# 再来启动一个测试容器，测试容器间的通信
$ docker run -d --name test2 nginx:alpine
$ docker exec -ti test2 sh
/ # sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
/ # apk add curl
/ # curl 172.17.0.8:80

## 为啥可以通信？
/ # route -n  # 
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.17.0.1      0.0.0.0         UG    0      0        0 eth0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth0

# eth0 网卡是这个容器里的默认路由设备；所有对 172.17.0.0/16 网段的请求，也会被交给 eth0 来处理（第二条 172.17.0.0 路由规则），这条路由规则的网关（Gateway）是 0.0.0.0，这就意味着这是一条直连规则，即：凡是匹配到这条规则的 IP 包，应该经过本机的 eth0 网卡，通过二层网络(数据链路层)直接发往目的主机。

# 而要通过二层网络到达 test1 容器，就需要有 172.17.0.8 这个 IP 地址对应的 MAC 地址。所以test2容器的网络协议栈，就需要通过 eth0 网卡发送一个 ARP 广播，来通过 IP 地址查找对应的 MAC 地址。

#这个 eth0 网卡，是一个 Veth Pair，它的一端在这个 test2 容器的 Network Namespace 里，而另一端则位于宿主机上（Host Namespace），并且被“插”在了宿主机的 docker0 网桥上。网桥设备的一个特点是插在桥上的网卡都会被当成桥上的一个端口来处理，而端口的唯一作用就是接收流入的数据包，然后把这些数据包的“生杀大权”（比如转发或者丢弃），全部交给对应的网桥设备处理。

# 因此ARP的广播请求也会由docker0来负责转发，这样网桥就维护了一份端口与mac的信息表，因此针对test2的eth0拿到mac地址后发出的各类请求，同样走到docker0网桥中由网桥负责转发到对应的容器中。

# 网桥会维护一份mac映射表，我们可以大概通过命令来看一下，
$ brctl showmacs docker0
## 这些mac地址是主机端的veth网卡对应的mac，可以查看一下
$ ip a
```

<!-- OCR_START -->
- etho
- 10.168.0.2
- dockero
- 172.17.0.1
- eth9c02e56
- vethb49631
- 172.17.0.2
- 172.17.0.3
- Container 1
- Container 2
- Node
<!-- OCR_END -->

我们如何知道网桥上的这些虚拟网卡与容器端是如何对应？

通过ifindex，网卡索引号

```plain
## 查看test1容器的网卡索引
$ docker exec -ti test1 cat /sys/class/net/eth0/ifindex

## 主机中找到虚拟网卡后面这个@ifxx的值，如果是同一个值，说明这个虚拟网卡和这个容器的eth0网卡是配对的。
$ ip a |grep @if
```

整理脚本，快速查看对应：

```plain
for container in $(docker ps -q); do
    iflink=`docker exec -it $container sh -c 'cat /sys/class/net/eth0/iflink'`
    iflink=`echo $iflink|tr -d '\r'`
    veth=`grep -l $iflink /sys/class/net/veth*/ifindex`
    veth=`echo $veth|sed -e 's;^.*net/\(.*\)/ifindex$;\1;'`
    echo $container:$veth
done
```

上面我们讲解了容器之间的通信，那么容器与宿主机的通信是如何做的？

添加端口映射：

```plain
## 启动容器的时候通过-p参数添加宿主机端口与容器内部服务端口的映射
$ docker run --name test -d -p 8088:80 nginx:alpine
$ curl localhost:8088
```

<!-- OCR_START -->
- 英特网
- 调制解调器
- 路由器
- Linux主机
- 192.168.1.1
- 主机网络接口
- 192.168.1.10 : 24
- etho
- SNAT
- DNAT-
- NAT
- 网络地址转换
- dockero
- 虚拟网桥
- vetho
- veth0
- 172.17.0.1
- veth pair
- veth1
- 虚拟网络接口对
- 容器1
- 容器2
- 容器n
- 172.17.0.4
- 172.17.0.5
- 172.17.0.n : 24
<!-- OCR_END -->

端口映射如何实现的？先来回顾iptables链表图

<!-- OCR_START -->
- 上层协议栈
- 路由判断
- mangle
- raw
- INPUT
- centos6中INPUT链的规则不能存在于nat表中
- nat
- filter
- 所以此处使用灰色标注，表示根据情况而定。
- 数据进入流向
- 数据发出流向
- 数据包入口
- 数据包出口
- PREROUTING
- FORWARD
- POSTROUTING
- 数据转发流向
<!-- OCR_END -->

访问本机 8088 端口时，数据包从流入方向进入本机，会经过 PREROUTING 和 INPUT 链。由于我们做了宿主机与容器之间的**端口映射**，必然涉及端口转换——负责维护网络地址转换信息的是 **nat 表**。查看 PREROUTING 链的 nat 表：

```plain
$ iptables -t nat -nvL PREROUTING
Chain PREROUTING (policy ACCEPT 159 packets, 20790 bytes)
 pkts bytes target     prot opt in     out     source               destination
    3   156 DOCKER     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL
```

规则利用了iptables的addrtype拓展，匹配网络类型为本地的包，如何确定哪些是匹配本地，

```plain
$ ip route show table local type local
127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1
127.0.0.1 dev lo proto kernel scope host src 127.0.0.1
172.17.0.1 dev docker0 proto kernel scope host src 172.17.0.1
172.21.51.143 dev eth0 proto kernel scope host src 172.21.51.143
```

匹配到目标地址类型的数据包会被转发到 TARGET。TARGET 表示对符合规则的数据包执行的**动作**，最常见的是 ACCEPT 或 DROP。

此处 TARGET 是 `DOCKER`——它并不是标准动作，而是一条**自定义链**。通常我们会把某类规则放进自定义链，再把自定义链绑定到标准链上。下面来看 DOCKER 这条自定义链上的规则。

```plain
$ iptables -t nat -nvL DOCKER
Chain DOCKER (2 references)                                                                                                
 pkts bytes target     prot opt in     out     source               destination                                            
    0     0 RETURN     all  --  docker0 *       0.0.0.0/0            0.0.0.0/0                                             
    0     0 DNAT       tcp  --  !docker0 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:8088 to:172.17.0.2:80
```

这条规则对主机收到的、目的端口为 8088 的 TCP 流量做 **DNAT 转换**，把流量发往 `172.17.0.2:80`——这个地址正是上面创建的 Docker 容器 IP。流量到达网桥后由网桥转发即可。

因此外界只需访问 `172.21.51.143:8088` 就能访问容器中的服务。

数据包在出口方向走POSTROUTING链，我们查看一下规则：

```plain
$ iptables -t nat -nvL POSTROUTING
Chain POSTROUTING (policy ACCEPT 1099 packets, 67268 bytes)
 pkts bytes target     prot opt in     out     source               destination
   86  5438 MASQUERADE  all  --  *      !docker0  172.17.0.0/16        0.0.0.0/0
    0     0 MASQUERADE  tcp  --  *      *       172.17.0.4           172.17.0.4           tcp dpt:80
```

大家注意MASQUERADE这个动作是什么意思，其实是一种更灵活的SNAT，把源地址转换成主机的出口ip地址，那解释一下这条规则的意思:

这条规则对**源地址为 `172.17.0.0/16`**（即从 Docker 容器产生）且不是从 docker0 网卡发出的包做**源地址转换（SNAT）**，转换成主机网卡的地址。

大致过程：容器发出的 ACK 包 → 路由到网桥 docker0 → 按宿主机路由规则转给宿主机网卡 eth0 → 包从 docker0 转到 eth0 并发出时，该规则生效，把源地址换成 eth0 的 IP。

注意一下，刚才这个过程涉及到了网卡间包的传递，那一定要打开主机的ip_forward转发服务，要不然包转不了，服务肯定访问不到。

###### 抓包演示

我们先想一下，我们要抓哪个网卡的包

* 首先访问宿主机的8088端口，我们抓一下宿主机的eth0

```plain
$ tcpdump -i eth0 port 8088 -w host.cap

```

然后最终包会流入容器内，那我们抓一下容器内的eth0网卡

```plain
# 容器内安装一下tcpdump
$ sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
$ apk add tcpdump
$ tcpdump -i eth0 port 80 -w container.cap
```

到另一台机器访问一下，

```plain
$ curl 172.21.51.143:8088/

```

停止抓包，拷贝容器内的包到宿主机

```plain
$ docker cp test:/root/container.cap /root/

```

把抓到的内容拷贝到本地，使用wireshark进行分析。

```plain
$ scp root@172.21.51.143:/root/*.cap /d/packages

```

（wireshark合并包进行分析）

<!-- OCR_START -->
- Internet
- DNAT
- Container
- HTTP Request
- Dst:192.168.1.10:24
- Dst:172.17.0.n:24
- Src:192.168.1.32
<!-- OCR_END -->

<!-- OCR_START -->
- Container
- SNAT
- Intemet
- HTTPRequest
- Dst:192.168.1.32
- Dst:193.168.1.32
- Src: 172.17.0.n:24
- Src:192.168.1.10:24
<!-- OCR_END -->

进到容器内的包做DNAT，出去的包做SNAT，这样对外面来讲，根本就不知道机器内部是谁提供服务，其实这就和一个内网多个机器公用一个外网IP地址上网的效果是一样的，那这也属于NAT功能的一个常见的应用场景。

##### Host模式

容器内部不会创建网络空间，共享宿主机的网络空间。比如直接通过host模式创建mysql容器：

```plain
$ docker run --net host -d --name mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7

```

容器启动后，会默认监听3306端口，由于网络模式是host，因为可以直接通过宿主机的3306端口进行访问服务，效果等同于在宿主机中直接启动mysqld的进程。

##### Conatiner模式

该模式让新建容器与**已存在的某个容器**共享 Network Namespace（而非与宿主机共享）。新容器不会创建自己的网卡和 IP，而是与指定容器共享 IP、端口范围等。

除网络外，文件系统、进程列表等仍然相互隔离。两个容器的进程可通过 `lo` 网卡设备通信。

<!-- OCR_START -->
- host
- docker1
- docker2
- 172.17.0.2/24
- etho
- veth*
- dockero
- 172.17.0.1/24
- ipforwarding
- 10.11.55.5/24
<!-- OCR_END -->

\

```plain
## 启动测试容器，共享mysql的网络空间
$ docker run -ti --rm --net=container:mysql busybox sh
/ # ip a
/ # netstat -tlp|grep 3306
/ # telnet localhost 3306
```

在一些特殊的场景中非常有用，例如，kubernetes的pod，kubernetes为pod创建一个基础设施容器，同一pod下的其他容器都以container模式共享这个基础设施容器的网络命名空间，相互之间以localhost访问，构成一个统一的整体。

##### None模式

只会创建对应的网络空间，不会配置网络堆栈（网卡、路由等）。\

```plain
# 创建none的容器
$ docker run -it  --name=network-none --net=none nginx:alpine sh
# ifconfig
```

在宿主机中操作：

```plain

# 创建虚拟网卡对
$ ip link add A type veth peer name B
# A端插入到docker0网桥
$ brctl addif docker0 A
$ ip link set A up

# B端插入到network-none容器中，需要借助ip netns,因此需要显示的创建命名network namespace
$ PID=$(docker inspect -f '{{.State.Pid}}' network-none)
$ mkdir -p /var/run/netns
$ ln -s /proc/$PID/ns/net /var/run/netns/$PID

# B端放到容器的命名空间
$ ip link set B netns $PID
$ ip netns exec $PID ip link set dev B name eth0  # 修改设备名称为eth0，和docker默认行为一致
$ ip netns exec $PID ip link set eth0 up

# 设置ip
$ ip netns exec $PID ip addr add 172.17.0.100/16 dev eth0
# 添加默认路由，指定给docker0网桥
$ ip netns exec $PID ip route add default via 172.17.0.1

# 测试容器间通信
```

前置知识

```plain
前置知识：

-  ip netns 命令用来管理 network namespace。它可以创建命名的 network namespace，然后通过名字来引用 network namespace 
-  network namespace 在逻辑上是网络堆栈的一个副本，它有自己的路由、防火墙规则和网络设备。
   默认情况下，子进程继承其父进程的 network namespace。也就是说，如果不显式创建新的 network namespace，所有进程都从 init 进程继承相同的默认 network namespace。
-  根据约定，命名的 network namespace 是可以打开的 **/var/run/netns/** 目录下的一个对象。比如有一个名称为 net1 的 network namespace 对象，则可以由打开 /var/run/netns/net1 对象产生的文件描述符引用 network namespace net1。通过引用该文件描述符，可以修改进程的 network namespace。
```

#### 实用技巧

1. 清理主机上所有退出的容器

```plain
$ docker rm  $(docker ps -aq)

```

2 调试或者排查容器启动错误

```plain
## 若有时遇到容器启动失败的情况，可以先使用相同的镜像启动一个临时容器，先进入容器
$ docker run --rm -ti <image_id> sh
## 进入容器后，手动执行该容器对应的ENTRYPOINT或者CMD命令，这样即使出错，容器也不会退出，因为bash作为1号进程，我们只要不退出容器，该容器就不会自动退出
```

#### 本章小结

1. 为了解决软件交付过程中的环境依赖，同时提供一种更加轻量的虚拟化技术，Docker出现了。
2. 2013年诞生，15年开始迅速发展，从17.03月开始，使用时间日期管理版本，稳定版以每季度为准。
3. Docker是一种CS架构的软件产品，可以把代码及依赖打包成镜像，作为交付介质，并且把镜像启动成为容器，提供容器生命周期的管理。
4. 使用yum部署docker，启动后通过操作docker这个命令行，自动调用docker daemon完成容器相关操作。
5. 常用操作，围绕镜像|容器|仓库三大核心要素
   * systemctl start|stop|restart docker
   * docker build | pull -> docker tag -> docker push
   * docker run --name my-demo -d -p 8080:80 -v /opt/data:/data demo:v20200327 ping xx.com
   * docker cp /path/a.txt mycontainer:/opt
   * docker exec -ti mycontainer /bin/sh
   * docker logs -f --tail=100 mycontainer
6. 用 Dockerfile 构建业务镜像：先基于一个**基础镜像**，再通过一系列指令把业务应用所需的运行环境和依赖打包进镜像，最后用 `CMD` 或 `ENTRYPOINT` 指定镜像的启动入口，即完成封装。

类比：先找来一个集装箱模板（基础镜像）→ 把项目依赖的服务都装进集装箱 → 设置好启动入口 → 关上箱门，业务镜像就做好了。
7. 容器的实现依赖于内核模块提供的namespace和control-group的功能，通过namespace创建一块虚拟空间，空间内实现了各类资源(进程、网络、文件系统)的隔离，提供control-group实现了对隔离的空间的资源使用的限制。
8. docker镜像使用分层的方式进行存储，根据主机的存储驱动的不同，实现方式会不同，kernel在3.10.0-514以上自动支持overlay2 存储驱动，也是目前Docker推荐的方式。
9. 得益于分层存储的模式，多个容器可以通过copy-on-write的策略，在镜像的最上层加一个可写层，同时利用存储驱动的UnionFS的能力，实现一个镜像快速启动多个容器的场景。
10. Docker 的网络模式共 4 种，最常用的是 **bridge** 和 **host**：

* **bridge 模式**：通过 docker0 网桥实现。启动容器时创建一对虚拟网卡，把容器连到网桥上，并维护虚拟网卡与网桥端口的对应关系，从而实现容器间通信
* **容器与宿主机通信**：通过 iptables 端口映射。Docker 利用 iptables 的 PREROUTING 与 POSTROUTING nat 功能实现 SNAT 与 DNAT，使容器内部服务被很好地保护起来
11. 本章重点内容是docker的核心要素及基础的操作，实现原理以及docker的网络模式为选修包，目的为了帮助有docker基础及经验的同学更好的进一步理解docker。

# 02_Kubernetes落地实践之旅

本章学习kubernetes的架构及工作流程，重点介绍如何使用Workload管理业务应用的生命周期，实现服务不中断的滚动更新，通过服务发现和集群内负载均衡来实现集群内部的服务间访问，并通过ingress实现外部使用域名访问集群内部的服务。

学习过程中会逐步对Django项目做k8s改造，从零开始编写所需的资源文件。通过本章的学习，学员会掌握高可用k8s集群的搭建，同时Django demo项目已经可以利用k8s的控制器、服务发现、负载均衡、配置管理等特性来实现生命周期的管理。

#### 纯容器模式的问题

1. 业务容器数量庞大，哪些容器部署在哪些节点，使用了哪些端口，如何记录、管理，需要登录到每台机器去管理？
2. 跨主机通信，多个机器中的容器之间相互调用如何做，iptables规则手动维护？
3. 跨主机容器间互相调用，配置如何写？写死固定IP+端口？
4. 如何实现业务高可用？多个容器对外提供服务如何实现负载均衡？
5. 容器的业务中断了，如何可以感知到，感知到以后，如何自动启动新的容器?
6. 如何实现滚动升级保证业务的连续性？
7. ......

#### 容器调度管理平台

Docker Swarm Mesos Google Kubernetes

2017年开始Kubernetes凭借强大的容器集群管理功能, 逐步占据市场,目前在容器编排领域一枝独秀

<https://kubernetes.io/>

#### 架构图

分布式系统，两类角色：管理节点和工作节点

<!-- OCR_START -->
- Interne
- Firewall
- kubectl (user commands)
- Node
- Proxy
- kubelet
- docker
- Pod
- authentication
- APIS
- authorization
- cAdvisor
- container
- scheduling
- REST
- (pods, services,
- actuator
- rep.controllers)
- Scheduler
- controllermanager
- (replicationcontrolleretc.)
- Mastercomponents
- Distributed
- Colocated,or spread across machines,
- Watchable
- as dictated by cluster size.
- Storage
- (implemented via etcd)
<!-- OCR_END -->

#### 核心组件

* ETCD：分布式高性能键值数据库,存储整个集群的所有元数据
* ApiServer: API服务器,集群资源访问控制入口,提供restAPI及安全访问控制
* Scheduler：调度器,负责把业务容器调度到最合适的Node节点
* Controller Manager：控制器管理,确保集群资源按照期望的方式运行
  * Replication Controller
  * Node controller
  * ResourceQuota Controller
  * Namespace Controller
  * ServiceAccount Controller
  * Token Controller
  * Service Controller
  * Endpoints Controller
* kubelet：运行在每个节点上的主要的“节点代理”，脏活累活
  * pod 管理：kubelet 定期从所监听的数据源获取节点上 pod/container 的期望状态（运行什么容器、运行的副本数量、网络或者存储如何配置等等），并调用对应的容器平台接口达到这个状态。
  * 容器健康检查：kubelet 创建了容器之后还要查看容器是否正常运行，如果容器运行出错，就要根据 pod 设置的重启策略进行处理.
  * 容器监控：kubelet 会监控所在节点的资源使用情况，并定时向 master 报告，资源使用数据都是通过 cAdvisor 获取的。知道整个集群所有节点的资源情况，对于 pod 的调度和正常运行至关重要
* kube-proxy：维护节点中的iptables或者ipvs规则
* kubectl: 命令行接口，用于对 Kubernetes 集群运行命令 <https://kubernetes.io/zh/docs/reference/kubectl/>

#### 工作流程

<!-- OCR_START -->
- APIServer
- etcd
- Scheduler
- Kubelet
- Docker
- createPod
- write
- watch(newpod)
- bindpod
- watch(boundpod)
- dockerrun
- updatepodstatus
<!-- OCR_END -->

1. 用户准备一个资源文件（记录了业务应用的名称、镜像地址等信息），通过调用APIServer执行创建Pod
2. APIServer收到用户的Pod创建请求，将Pod信息写入到etcd中
3. 调度器通过list-watch的方式，发现有新的pod数据，但是这个pod还没有绑定到某一个节点中
4. 调度器通过调度算法，计算出最适合该pod运行的节点，并调用APIServer，把信息更新到etcd中
5. kubelet同样通过list-watch方式，发现有新的pod调度到本机的节点了，因此调用容器运行时，去根据pod的描述信息，拉取镜像，启动容器，同时生成事件信息
6. 同时，把容器的信息、事件及状态也通过APIServer写入到etcd中

#### 架构设计的几点思考

1. 系统各个组件分工明确(APIServer是所有请求入口，CM是控制中枢，Scheduler主管调度，而Kubelet负责运行)，配合流畅，整个运行机制一气呵成。
2. 除了配置管理和持久化组件ETCD，其他组件并不保存数据。意味除ETCD外其他组件都是无状态的。因此从架构设计上对kubernetes系统高可用部署提供了支撑。
3. 同时因为组件无状态，组件的升级，重启，故障等并不影响集群最终状态，只要组件恢复后就可以从中断处继续运行。
4. 各个组件和kube-apiserver之间的数据推送都是通过list-watch机制来实现。

#### 实践--集群安装

###### k8s集群主流安装方式对比分析

* minikube
* 二进制安装
* kubeadm等安装工具

kubeadm <https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm/>

《Kubernetes安装手册（非高可用版）》

###### 核心组件

静态Pod的方式：

```plain
## etcd、apiserver、controller-manager、kube-scheduler
$ kubectl -n kube-system get po
```

systemd服务方式：

```plain
$ systemctl status kubelet

```

kubectl：二进制命令行工具

###### 理解集群资源

组件是为了支撑k8s平台的运行，安装好的软件。

资源是如何去使用k8s的能力的定义。比如，k8s可以使用Pod来管理业务应用，那么Pod就是k8s集群中的一类资源，集群中的所有资源可以提供如下方式查看：\

```plain
$ kubectl api-resources

```

如何理解namespace：

命名空间，集群内一个虚拟的概念，类似于资源池的概念，一个池子里可以有各种资源类型，绝大多数的资源都必须属于某一个namespace。集群初始化安装好之后，会默认有如下几个namespace：\

```plain
$ kubectl get namespaces
NAME                   STATUS   AGE
default                Active   84m
kube-node-lease        Active   84m
kube-public            Active   84m
kube-system            Active   84m
kubernetes-dashboard   Active   71m
```

* 所有NAMESPACED的资源，在创建的时候都需要指定namespace，若不指定，默认会在default命名空间下
* 相同namespace下的同类资源不可以重名，不同类型的资源可以重名
* 不同namespace下的同类资源可以重名
* 通常在项目使用的时候，我们会创建带有业务含义的namespace来做逻辑上的整合

###### kubectl的使用

类似于docker，kubectl是命令行工具，用于与APIServer交互，内置了丰富的子命令，功能极其强大。 <https://kubernetes.io/docs/reference/kubectl/overview/>\

```plain
$ kubectl -h
$ kubectl get -h
$ kubectl create -h
$ kubectl create namespace -h
```

#### 实践--使用k8s管理业务应用

##### 最小调度单元 Pod

docker调度的是容器，在k8s集群中，最小的调度单元是Pod（豆荚）



<!-- OCR_START -->
> 容器
> Pod
<!-- OCR_END -->



###### 为什么引入Pod

* 与容器引擎解耦Docker、Rkt。平台设计与引擎的具体的实现解耦
* 多容器共享网络|存储|进程 空间, 支持的业务场景更加灵活

###### 使用yaml格式定义Pod

*myblog/one-pod/pod.yaml*\

```plain
apiVersion: v1
kind: Pod
metadata:
  name: myblog
  namespace: luffy
  labels:
    component: myblog
spec:
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog:v1
    env:
    - name: MYSQL_HOST   #  指定root用户的用户名
      value: "127.0.0.1"
    - name: MYSQL_PASSWD
      value: "123456"
    ports:
    - containerPort: 8002
  - name: mysql
    image: 172.21.51.67:5000/mysql:5.7-utf8
    ports:
    - containerPort: 3306
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "123456"
    - name: MYSQL_DATABASE
      value: "myblog"
```

```plain
{
    "apiVersion": "v1",        
    "kind": "Pod",
    "metadata": {
        "name": "myblog",
        "namespace": "luffy",
        "labels": {
            "component": "myblog"
        }
    },
    "spec": {
        "containers": [
            {
                "name": "myblog",
                "image": "172.21.51.67:5000/myblog",
                "env": [
                    {
                        "name": "MYSQL_HOST",
                        "value": "127.0.0.1"
                    },
                    {
                        "name": "MYSQL_PASSWD",
                        "value": "123456"
                    }
                ],
                "ports": [
                    {
                        "containerPort": 8002
                    }
                ]
            },
            {
                "name": "mysql",
                ...
            }
        ]
    }
}
```

| **apiVersion** | **含义** |
| :--- | :--- |
| alpha | 进入K8s功能的早期候选版本，可能包含Bug，最终不一定进入K8s |
| beta | 已经过测试的版本，最终会进入K8s，但功能、对象定义可能会发生变更。 |
| stable | 可安全使用的稳定版本 |
| v1 | stable 版本之后的首个版本，包含了更多的核心对象 |
| apps/v1 | 使用最广泛的版本，像Deployment、ReplicaSets都已进入该版本 |

资源类型与apiVersion对照表

| **Kind** | **apiVersion** |
| :--- | :--- |
| ClusterRoleBinding | rbac.authorization.k8s.io/v1 |
| ClusterRole | rbac.authorization.k8s.io/v1 |
| ConfigMap | v1 |
| CronJob | batch/v1beta1 |
| DaemonSet | extensions/v1beta1 |
| Node | v1 |
| Namespace | v1 |
| Secret | v1 |
| PersistentVolume | v1 |
| PersistentVolumeClaim | v1 |
| Pod | v1 |
| Deployment | v1、apps/v1、apps/v1beta1、apps/v1beta2 |
| Service | v1 |
| Ingress | extensions/v1beta1 |
| ReplicaSet | apps/v1、apps/v1beta2 |
| Job | batch/v1 |
| StatefulSet | apps/v1、apps/v1beta1、apps/v1beta2 |

快速获得资源和版本

```plain
$ kubectl explain pod
$ kubectl explain Pod.apiVersion
```

###### 创建和访问Pod

```plain
## 创建namespace, namespace是逻辑上的资源池
$ kubectl create namespace luffy

## 使用指定文件创建Pod
$ kubectl create -f pod.yaml

## 查看pod，可以简写po
## 所有的操作都需要指定namespace，如果是在default命名空间下，则可以省略
$ kubectl -n luffy get pods -o wide
NAME     READY   STATUS    RESTARTS   AGE    IP             NODE
myblog   2/2     Running   0          3m     10.244.1.146   k8s-slave1

## 使用Pod Ip访问服务,3306和8002
$ curl 10.244.1.146:8002/blog/index/

## 进入容器,执行初始化, 不必到对应的主机执行docker exec
$ kubectl -n luffy exec -ti myblog -c myblog bash
/ # env
/ # python3 manage.py migrate
$ kubectl -n luffy exec -ti myblog -c mysql bash
/ # mysql -p123456

## 再次访问服务,3306和8002
$ curl 10.244.1.146:8002/blog/index/
```

###### Infra容器

登录k8s-slave1节点\

```plain
$ docker ps -a |grep myblog  ## 发现有三个容器
## 其中包含mysql和myblog程序以及Infra容器
## 为了实现Pod内部的容器可以通过localhost通信，每个Pod都会启动Infra容器，然后Pod内部的其他容器的网络空间会共享该Infra容器的网络空间(Docker网络的container模式)，Infra容器只需要hang住网络空间，不需要额外的功能，因此资源消耗极低。

## 登录master节点，查看pod内部的容器ip均相同，为pod ip
$ kubectl -n luffy exec -ti myblog -c myblog bash
/ # ifconfig
$ kubectl -n luffy exec -ti myblog -c mysql bash
/ # ifconfig
```

pod容器命名: k8s\_\<container_name>*\<pod_name>*<namespace>\_\<random_string>

###### 查看pod详细信息

```plain
## 查看pod调度节点及pod_ip
$ kubectl -n luffy get pods -o wide
## 查看完整的yaml
$ kubectl -n luffy get po myblog -o yaml
## 查看pod的明细信息及事件
$ kubectl -n luffy describe pod myblog
```

###### Troubleshooting and Debugging

```plain
#进入Pod内的容器
$ kubectl -n <namespace> exec <pod_name> -c <container_name> -ti /bin/sh

#查看Pod内容器日志,显示标准或者错误输出日志
$ kubectl -n <namespace> logs -f <pod_name> -c <container_name>
```

###### 更新服务版本

```plain
$ kubectl apply -f demo-pod.yaml

```

###### 删除Pod服务

```plain
#根据文件删除
$ kubectl delete -f demo-pod.yaml

#根据pod_name删除
$ kubectl -n <namespace> delete pod <pod_name>
```

###### Pod数据持久化

若删除了Pod，由于mysql的数据都在容器内部，会造成数据丢失，因此需要数据进行持久化。

* 定点使用hostpath挂载，nodeSelector定点

myblog/one-pod/pod-with-volume.yaml

```yaml
apiVersion: v1
kind: Pod
metadata: 
	name: myblog 
	namespace: luffy 
labels:
	component: myblog
spec: volumes:
	name: mysql-data hostPath: 
	path: /opt/mysql/data 
nodeSelector: # 使用节点选择器将Pod调度到指定label的节点 
	component: mysql 
containers:
	name: myblog 
	image: 172.21.51.67:5000/myblog:v1 
env:
	name: MYSQL_HOST # 指定root用户的用户名 
	value: "127.0.0.1"
	name: MYSQL_PASSWD 
	value: "123456" 
ports:
	containerPort: 8002
	name: mysql 
image: 172.21.51.67:5000/mysql:5.7-utf8 
ports:
	containerPort: 3306 
env:
	name: MYSQL_ROOT_PASSWORD 
	value: "123456"
	name: MYSQL_DATABASE 
	value: "myblog" 
volumeMounts:
	name: mysql-data 
	mountPath: /var/lib/mysql
```

保存文件为`pod-with-volume.yaml`，执行创建

```bash
## 若存在旧的同名服务，先删除掉，后创建
$ kubectl -n luffy delete pod myblog
## 创建
$ kubectl create -f pod-with-volume.yaml

## 此时pod状态Pending
$ kubectl -n luffy get po
NAME     READY   STATUS    RESTARTS   AGE
myblog   0/2     Pending   0          32s

## 查看原因，提示调度失败，因为节点不满足node selector
$ kubectl -n luffy describe po myblog
Events:
Type     Reason            Age                From               Message
----     ------            ----               ----               -------
Warning  FailedScheduling  12s (x2 over 12s)  default-scheduler  0/3 nodes are available: 3 node(s) didn't match node selector.

## 为节点打标签
$ kubectl label node k8s-slave1 component=mysql

## 再次查看，已经运行成功
$ kubectl -n luffy get po
NAME     READY   STATUS    RESTARTS   AGE     IP             NODE
myblog   2/2     Running   0          3m54s   10.244.1.150   k8s-slave1

## 到k8s-slave1节点，查看/opt/mysql/data
$ ll /opt/mysql/data/
total 188484
-rw-r----- 1 polkitd input       56 Mar 29 09:20 auto.cnf
-rw------- 1 polkitd input     1676 Mar 29 09:20 ca-key.pem
-rw-r--r-- 1 polkitd input     1112 Mar 29 09:20 ca.pem
drwxr-x--- 2 polkitd input     8192 Mar 29 09:20 sys
...

## 执行migrate，创建数据库表，然后删掉pod，再次创建后验证数据是否存在
$ kubectl -n luffy exec -ti myblog python3 manage.py migrate

## 访问服务，正常
$ curl 10.244.1.150:8002/blog/index/ 

## 删除pod
$ kubectl delete -f pod-with-volume.yaml

## 再次创建Pod
$ kubectl create -f pod-with-volume.yaml

## 查看pod ip并访问服务
$ kubectl -n luffy get po -o wide
NAME     READY   STATUS    RESTARTS   AGE   IP             NODE  
myblog   2/2     Running   0          7s    10.244.1.151   k8s-slave1

## 未重新做migrate，服务正常
$ curl 10.244.1.151:8002/blog/index/
```

* 使用PV+PVC连接分布式存储解决方案
  * ceph
  * glusterfs
  * nfs

###### 服务健康检查

检测容器服务是否健康的手段，若不健康，会根据设置的重启策略（restartPolicy）进行操作，两种检测机制可以分别单独设置，若不设置，默认认为Pod是健康的。

两种机制：

* LivenessProbe探针 存活性探测：用于判断容器是否存活，即Pod是否为running状态，如果LivenessProbe探针探测到容器不健康，则kubelet将kill掉容器，并根据容器的重启策略是否重启，如果一个容器不包含LivenessProbe探针，则Kubelet认为容器的LivenessProbe探针的返回值永远成功。

```bash
...
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog:v1
    livenessProbe:
      httpGet:
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 10     # 执行探测的频率
      timeoutSeconds: 2        # 探测超时时间
...
```

  
![1671679315891-77e6787d-9ade-4218-9ec3-e589d09dd736.gif](img/K8S高级运维/image24.gif)  
 ReadinessProbe探针 可用性探测：用于判断容器是否正常提供服务，即容器的Ready是否为True，是否可以接收请求，如果ReadinessProbe探测失败，则容器的Ready将为False， Endpoint Controller 控制器将此Pod的Endpoint从对应的service的Endpoint列表中移除，不再将任何请求调度此Pod上，直到下次探测成功。（剔除此pod不参与接收请求不会将流量转发给此Pod）。

```bash
...
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog:v1
    readinessProbe: 
      httpGet: 
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10 
      timeoutSeconds: 2
      periodSeconds: 10
...
```

![1671679359607-635c443e-d44b-4d45-a1d8-a827478462b4.gif](img/K8S高级运维/image25.gif)

三种类型：

* exec：通过执行命令来检查服务是否正常，返回值为0则表示容器健康
* httpGet方式：通过发送http请求检查服务是否正常，返回200-399状态码则表明容器健康
* tcpSocket：通过容器的IP和Port执行TCP检查，如果能够建立TCP连接，则表明容器健康

示例：

完整文件路径 myblog/one-pod/pod-with-healthcheck.yaml

```yaml
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog:v1
    env:
    - name: MYSQL_HOST   #  指定root用户的用户名
      value: "127.0.0.1"
    - name: MYSQL_PASSWD
      value: "123456"
    ports:
    - containerPort: 8002
    livenessProbe:
      httpGet:
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 10     # 执行探测的频率
      timeoutSeconds: 2        # 探测超时时间
    readinessProbe: 
      httpGet: 
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10 
      timeoutSeconds: 2
      periodSeconds: 10
```

* initialDelaySeconds：容器启动后第一次执行探测时需要等待多少秒。
* periodSeconds：执行探测的频率。默认是10秒，最小1秒。
* timeoutSeconds：探测超时时间。默认1秒，最小1秒。
* successThreshold：探测失败后，最少连续探测成功多少次才被认定为成功。默认是1。
* failureThreshold：探测成功后，最少连续探测失败多少次才被认定为失败。默认是3，最小值是1。

K8S将在Pod开始**启动10s(initialDelaySeconds)后**利用HTTP访问8002端口的/blog/index/，如果**超过2s**或者返回码不在200~399内，则健康检查失败

###### 重启策略

Pod的重启策略（RestartPolicy）应用于Pod内的所有容器，并且仅在Pod所处的Node上由kubelet进行判断和重启操作。当某个容器异常退出或者健康检查失败时，kubelet将根据RestartPolicy的设置来进行相应的操作。 Pod的重启策略包括Always、OnFailure和Never，默认值为Always。

* Always：当容器进程退出后，由kubelet自动重启该容器；
* OnFailure：当容器终止运行且退出码不为0时，由kubelet自动重启该容器；
* Never：不论容器运行状态如何，kubelet都不会重启该容器。

演示重启策略：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-restart-policy
spec:
  restartPolicy: OnFailure
  containers:
  - name: busybox
    image: busybox
    args:
    - /bin/sh
    - -c
    - sleep 10 && exit 0
```

1. 使用默认的重启策略，即 restartPolicy: Always ，无论容器是否是正常退出，都会自动重启容器
2. 使用OnFailure的策略时
   * 如果把exit 1，去掉，即让容器的进程正常退出的话，则不会重启
   * 只有非正常退出状态才会重启
3. 使用Never时，退出了就不再重启

可以看出，若容器正常退出，Pod的状态会是Completed，非正常退出，状态为CrashLoopBackOff

###### 镜像拉取策略

```yaml
spec:
  containers:
  - name: myblog
    image: 172.21.51.67:5000/demo/myblog
    imagePullPolicy: IfNotPresent
```

设置镜像的拉取策略，默认为IfNotPresent

* Always，总是拉取镜像，即使本地有镜像也从仓库拉取
* IfNotPresent ，本地有则使用本地镜像，本地没有则去仓库拉取
* Never，只使用本地镜像，本地没有则报错

###### Pod资源限制

为了保证充分利用集群资源，且确保重要容器在运行周期内能够分配到足够的资源稳定运行，因此平台需要具备

Pod的资源限制的能力。 对于一个pod来说，资源最基础的2个的指标就是：CPU和内存。

Kubernetes提供了个采用requests和limits 两种类型参数对资源进行预分配和使用限制。

完整文件路径：myblog/one-pod/pod-with-resourcelimits.yaml

```yaml
...
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog
    env:
    - name: MYSQL_HOST   #  指定root用户的用户名
      value: "127.0.0.1"
    - name: MYSQL_PASSWD
      value: "123456"
    ports:
    - containerPort: 8002
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 500Mi
        cpu: 100m
...
```

requests：

* 容器使用的最小资源需求,作用于schedule阶段，作为容器调度时资源分配的判断依赖
* 只有当前节点上可分配的资源量 >= request 时才允许将容器调度到该节点
* request参数不限制容器的最大可使用资源
* requests.cpu被转成docker的--cpu-shares参数，与cgroup cpu.shares功能相同 (无论宿主机有多少个cpu或者内核，--cpu-shares选项都会按照比例分配cpu资源）
* requests.memory没有对应的docker参数，仅作为k8s调度依据

limits：

* 容器能使用资源的最大值
* 设置为0表示对使用的资源不做限制, 可无限的使用
* 当pod 内存超过limit时，会被oom
* 当cpu超过limit时，不会被kill，但是会限制不超过limit值
* limits.cpu会被转换成docker的–cpu-quota参数。与cgroup cpu.cfs_quota_us功能相同
* limits.memory会被转换成docker的–memory参数。用来限制容器使用的最大内存对于 CPU，我们知道计算机里 CPU 的资源是按“时间片”的方式来进行分配的，系统里的每一个操作都需要 CPU 的处理，所以，哪个任务要是申请的 CPU 时间片越多，那么它得到的 CPU 资源就越多。

然后还需要了解下 CGroup 里面对于 CPU 资源的单位换算：

```yaml
1 CPU =  1000 millicpu（1 Core = 1000m）

```

这里的 m 就是毫、毫核的意思，Kubernetes 集群中的每一个节点可以通过操作系统的命令来确认本节点的 CPU 内核数量，然后将这个数量乘以1000，得到的就是节点总 CPU 总毫数。比如一个节点有四核，那么该节点的 CPU 总毫量为 4000m。

docker run命令和 CPU 限制相关的所有选项如下：

| **选项** | **描述** |
| --- | --- |
| --cpuset-cpus="" | 允许使用的 CPU 集，值可以为 0-3,0,1 |
| -c,--cpu-shares=0 | CPU 共享权值（相对权重） |
| cpu-period=0 | 限制 CPU CFS 的周期，范围从 100ms~1s，即\[1000, 1000000] |
| --cpu-quota=0 | 限制 CPU CFS 配额，必须不小于1ms，即 >= 1000，绝对限制 |

docker run -it --cpu-period=50000 --cpu-quota=25000 ubuntu:16.04 /bin/bash 

将 CFS 调度的周期设为 50000，将容器在每个周期内的 CPU 配额设置为 25000，表示该容器每 50ms 可以得到 50% 的 CPU 运行时间。

注意：若内存使用超出限制，会引发系统的OOM机制，因CPU是可压缩资源，不会引发Pod退出或重建

###### yaml优化

目前完善后的yaml，myblog/one-pod/pod-completed.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myblog
  namespace: luffy
  labels:
    component: myblog
spec:
  volumes: 
  - name: mysql-data
    hostPath: 
      path: /opt/mysql/data
  nodeSelector:   # 使用节点选择器将Pod调度到指定label的节点
    component: mysql
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog:v1
    env:
    - name: MYSQL_HOST   #  指定root用户的用户名
      value: "127.0.0.1"
    - name: MYSQL_PASSWD
      value: "123456"
    ports:
    - containerPort: 8002
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 500Mi
        cpu: 100m
    livenessProbe:
      httpGet:
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 15     # 执行探测的频率
      timeoutSeconds: 2        # 探测超时时间
    readinessProbe: 
      httpGet: 
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10 
      timeoutSeconds: 2
      periodSeconds: 15
  - name: mysql
    image: 172.21.51.67:5000/mysql:5.7-utf8
    ports:
    - containerPort: 3306
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "123456"
    - name: MYSQL_DATABASE
      value: "myblog"
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 500Mi
        cpu: 100m
    readinessProbe:
      tcpSocket:
        port: 3306
      initialDelaySeconds: 5
      periodSeconds: 10
    livenessProbe:
      tcpSocket:
        port: 3306
      initialDelaySeconds: 15
      periodSeconds: 20
    volumeMounts:
    - name: mysql-data
      mountPath: /var/lib/mysql
```

为什么要优化

* 考虑真实的使用场景，像数据库这类中间件，是作为公共资源，为多个项目提供服务，不适合和业务容器绑定在同一个Pod中，因为业务容器是经常变更的，而数据库不需要频繁迭代
* yaml的环境变量中存在敏感信息（账号、密码），存在安全隐患

解决问题一，需要拆分yaml

myblog/two-pod/mysql.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql
  namespace: luffy
  labels:
    component: mysql
spec:
  hostNetwork: true    # 声明pod的网络模式为host模式，效果同docker run --net=host
  volumes: 
  - name: mysql-data
    hostPath: 
      path: /opt/mysql/data
  nodeSelector:   # 使用节点选择器将Pod调度到指定label的节点
    component: mysql
  containers:
  - name: mysql
    image: 172.21.51.67:5000/mysql:5.7-utf8
    ports:
    - containerPort: 3306
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "123456"
    - name: MYSQL_DATABASE
      value: "myblog"
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 500Mi
        cpu: 100m
    readinessProbe:
      tcpSocket:
        port: 3306
      initialDelaySeconds: 5
      periodSeconds: 10
    livenessProbe:
      tcpSocket:
        port: 3306
      initialDelaySeconds: 15
      periodSeconds: 20
    volumeMounts:
    - name: mysql-data
      mountPath: /var/lib/mysql
```

myblog.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myblog
  namespace: luffy
  labels:
    component: myblog
spec:
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog:v1
    imagePullPolicy: IfNotPresent
    env:
    - name: MYSQL_HOST   #  指定root用户的用户名
      value: "172.21.51.68"
    - name: MYSQL_PASSWD
      value: "123456"
    ports:
    - containerPort: 8002
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 500Mi
        cpu: 100m
    livenessProbe:
      httpGet:
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 15     # 执行探测的频率
      timeoutSeconds: 2        # 探测超时时间
    readinessProbe: 
      httpGet: 
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10 
      timeoutSeconds: 2
      periodSeconds: 15
```

创建测试

```yaml
## 先删除旧pod
$ kubectl -n luffy delete po myblog

## 分别创建mysql和myblog
$ kubectl create -f mysql.yaml
$ kubectl create -f myblog.yaml

## 查看pod，注意mysqlIP为宿主机IP，因为网络模式为host
$ kubectl -n luffy get po -o wide 
NAME     READY   STATUS    RESTARTS   AGE   IP                NODE
myblog   1/1     Running   0          41s   10.244.1.152      k8s-slave1
mysql    1/1     Running   0          52s   172.21.51.68   k8s-slave1

## 访问myblog服务正常
$ curl 10.244.1.152:8002/blog/index/
```

解决问题二，环境变量中敏感信息带来的安全隐患

为什么要统一管理环境变量

* 环境变量中有很多敏感的信息，比如账号密码，直接暴漏在yaml文件中存在安全性问题
* 团队内部一般存在多个项目，这些项目直接存在配置相同环境变量的情况，因此可以统一维护管理
* 对于开发、测试、生产环境，由于配置均不同，每套环境部署的时候都要修改yaml，带来额外的开销

k8s提供两类资源，configMap和Secret，可以用来实现业务配置的统一管理， 允许将配置文件与镜像文件分离，以使容器化的应用程序具有可移植性 。

<!-- OCR_START -->
- ConfigMaps created
- fromdifferentmanifests
- Namespace:development
- Namespace:production
- ConfigMap:
- app-config
- Pod(s)
- (contains
- development
- production
- values)
- Podscreatedfrom the
- samepodmanifests
<!-- OCR_END -->

* configMap，通常用来管理应用的配置文件或者环境变量,

myblog/two-pod/configmap.yaml

```yaml
apiVersion: v1 
kind: ConfigMap 
metadata: 
	name: myblog 
namespace: luffy 
data: 
	MYSQL_HOST: "172.21.51.68" 
	MYSQL_PORT: "3306"

```

```yaml
 创建并查看configMap：
  $ kubectl create -f configmap.yaml
  $ kubectl -n luffy get cm myblog -oyaml
```

或者可以使用命令的方式，从文件中创建，比如：

configmap.txt

```yaml
  $ cat configmap.txt
  MYSQL_HOST=172.21.51.68
  MYSQL_PORT=3306
  $ kubectl create configmap myblog --from-env-file=configmap.txt
```

Secret，管理敏感类的信息，默认会base64编码存储，有三种类型

* Service Account ：用来访问Kubernetes API，由Kubernetes自动创建，并且会自动挂载到Pod的/run/secrets/kubernetes.io/serviceaccount目录中；创建ServiceAccount后，Pod中指定serviceAccount后，自动创建该ServiceAccount对应的secret；
* Opaque ： base64编码格式的Secret，用来存储密码、密钥等；
* kubernetes.io/dockerconfigjson ：用来存储私有docker registry的认证信息。

myblog/two-pod/secret.yaml\

```yaml
apiVersion: v1
kind: Secret
metadata:
	name: myblog
namespace: luffy 
type: Opaque 
data: 
	MYSQL_USER: cm9vdA== #注意加-n参数， echo -n root|base64 MYSQL_PASSWD: MTIzNDU2
```

```yaml
 创建并查看：
  $ kubectl create -f secret.yaml
  $ kubectl -n luffy get secret
```

如果不习惯这种方式，可以通过如下方式：

```yaml
  $ cat secret.txt
  MYSQL_USER=root
  MYSQL_PASSWD=123456
  $ kubectl -n luffy create secret generic myblog --from-env-file=secret.txt
```

修改后的mysql的yaml，资源路径：myblog/two-pod/mysql-with-config.yaml

```yaml
...
spec:
  containers:
  - name: mysql
    image: 172.21.51.67:5000/mysql:5.7-utf8
    env:
    - name: MYSQL_USER
      valueFrom:
        secretKeyRef:
          name: myblog
          key: MYSQL_USER
    - name: MYSQL_ROOT_PASSWORD
      valueFrom:
        secretKeyRef:
          name: myblog
          key: MYSQL_PASSWD
    - name: MYSQL_DATABASE
      value: "myblog"
...
```

整体修改后的myblog的yaml，资源路径：myblog/two-pod/myblog-with-config.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myblog
  namespace: luffy
  labels:
    component: myblog
spec:
  containers:
  - name: myblog
    image: 172.21.51.67:5000/myblog:v1
    imagePullPolicy: IfNotPresent
    env:
    - name: MYSQL_HOST
      valueFrom:
        configMapKeyRef:
          name: myblog
          key: MYSQL_HOST
    - name: MYSQL_PORT
      valueFrom:
        configMapKeyRef:
          name: myblog
          key: MYSQL_PORT
    - name: MYSQL_USER
      valueFrom:
        secretKeyRef:
          name: myblog
          key: MYSQL_USER
    - name: MYSQL_PASSWD
      valueFrom:
        secretKeyRef:
          name: myblog
          key: MYSQL_PASSWD
    ports:
    - containerPort: 8002
    resources:
      requests:
        memory: 100Mi
        cpu: 50m
      limits:
        memory: 500Mi
        cpu: 100m
    livenessProbe:
      httpGet:
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
      periodSeconds: 15     # 执行探测的频率
      timeoutSeconds: 2        # 探测超时时间
    readinessProbe: 
      httpGet: 
        path: /blog/index/
        port: 8002
        scheme: HTTP
      initialDelaySeconds: 10 
      timeoutSeconds: 2
      periodSeconds: 15
```

  
在部署不同的环境时，pod的yaml无须再变化，只需要在每套环境中维护一套ConfigMap和Secret即可。但是注意configmap和secret不能跨namespace使用，且更新后，pod内的env不会自动更新，重建后方可更新。

###### 如何编写资源yaml

1. 拿来主义，从机器中已有的资源中拿

```yaml
$ kubectl -n kube-system get po,deployment,ds

```

2. 学会在官网查找， <https://kubernetes.io/docs/home/>
3. 从kubernetes-api文档中查找， <https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#pod-v1-core>
4. kubectl explain 查看具体字段含义

###### pod状态与生命周期

Pod的状态如下表所示：

| **状态值** | **描述** | |
| --- | --- | --- |
| Pending | API Server已经创建该Pod，等待调度器调度 | |
| ContainerCreating | 拉取镜像启动容器中 | |
| Running | Pod内容器均已创建，且至少有一个容器处于运行状态、正在启动状态或正在重启状态 | |
| Succeeded\ | Completed | Pod内所有容器均已成功执行退出，且不再重启 |
| Failed\ | Error | Pod内所有容器均已退出，但至少有一个容器退出为失败状态 |
| CrashLoopBackOff | Pod内有容器启动失败，比如配置文件丢失导致主进程启动失败 | |
| Unknown | 由于某种原因无法获取该Pod的状态，可能由于网络通信不畅导致 | |

生命周期示意图：

<!-- OCR_START -->
- Atleast one
- All containers
- Accept by Kube
- containerisrunning
- teeminated with0
- Pending
- Running
- Succeed
- After Restart,
- At least one container
- terminated with non-
- again
- zero exitcode
- Failed
<!-- OCR_END -->

启动和关闭示意：

<!-- OCR_START -->
| 名称 | 名称 | 名称 | 名称 | 排名 | 排名(上年) |
| --- | --- | --- | --- | --- | --- |
| pod | liveness | post start | main | pre stop | readiness |
| infra | init | pod | livenessprobe | readiness probe | post start hook |
| pre stop hook | main container | init container | O | 1 | 2 |
| 3 | 4 | 5 | 6 | 7 | 8 |
| 9 | 10 | 11 | 12 | 13 | 314 |
<!-- OCR_END -->

初始化容器：

* 验证业务应用依赖的组件是否均已启动
* 修改目录的权限
* 调整系统参数

```yaml
...
      initContainers:
      - command:
        - /sbin/sysctl
        - -w
        - vm.max_map_count=262144
        image: alpine:3.6
        imagePullPolicy: IfNotPresent
        name: elasticsearch-logging-init
        resources: {}
        securityContext:
          privileged: true
      - name: fix-permissions
        image: alpine:3.6
        command: ["sh", "-c", "chown -R 1000:1000 /usr/share/elasticsearch/data"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: elasticsearch-logging
          mountPath: /usr/share/elasticsearch/data
...
```

验证Pod生命周期：\

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-start-stop
  namespace: luffy
  labels:
    component: demo-start-stop
spec:
  initContainers:
  - name: init
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): INIT >> /loap/timing']
    volumeMounts:
    - mountPath: /loap
      name: timing
  containers:
  - name: main
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): START >> /loap/timing;
sleep 10; echo $(date +%s): END >> /loap/timing;']
    volumeMounts:
    - mountPath: /loap 
      name: timing
    livenessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): LIVENESS >> /loap/timing']
    readinessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): READINESS >> /loap/timing']
    lifecycle:
      postStart:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): POST-START >> /loap/timing']
      preStop:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): PRE-STOP >> /loap/timing']
  volumes:
  - name: timing
    hostPath:
      path: /tmp/loap
```

创建pod测试：\

```yaml
$ kubectl create -f demo-pod-start.yaml

## 查看demo状态
$ kubectl -n luffy get po -o wide -w

## 查看调度节点的/tmp/loap/timing
$ cat /tmp/loap/timing
1585424708: INIT
1585424746: START
1585424746: POST-START
1585424754: READINESS
1585424756: LIVENESS
1585424756: END
```

须主动杀掉 Pod 才会触发 pre-stop hook，如果是 Pod 自己 Down 掉，则不会执行 pre-stop hook

###### 小结

1. 实现k8s平台与特定的容器运行时解耦，提供更加灵活的业务部署方式，引入了Pod概念
2. k8s使用yaml格式定义资源文件，yaml中Map与List的语法，与json做类比
3. 通过kubectl create | get | exec | logs | delete 等操作k8s资源，必须指定namespace
4. 每启动一个Pod，为了实现网络空间共享，会先创建Infra容器，并把其他容器网络加入该容器
5. 通过livenessProbe和readinessProbe实现Pod的存活性和就绪健康检查
6. 通过requests和limit分别限定容器初始资源申请与最高上限资源申请
7. Pod通过initContainer和lifecycle分别来执行初始化、pod启动和删除时候的操作，使得功能更加全面和灵活
8. 编写yaml讲究方法，学习k8s，养成从官方网站查询知识的习惯

做了哪些工作：

1. 定义Pod.yaml，将myblog和mysql打包在同一个Pod中，使用myblog使用localhost访问mysql
2. mysql数据持久化，为myblog业务应用添加了健康检查和资源限制
3. 将myblog与mysql拆分，使用独立的Pod管理
4. yaml文件中的环境变量存在账号密码明文等敏感信息，使用configMap和Secret来统一配置，优化部署

只使用Pod, 面临的问题:

1. 业务应用启动多个副本
2. Pod重建后IP会变化，外部如何访问Pod服务
3. 运行业务Pod的某个节点挂了，可以自动帮我把Pod转移到集群中的可用节点启动起来
4. 我的业务应用功能是收集节点监控数据,需要把Pod运行在k8集群的各个节点上

##### Pod控制器

###### Workload (工作负载)

控制器又称工作负载是用于实现管理pod的中间层，确保pod资源符合预期的状态，pod的资源出现故障时，会尝试 进行重启，当根据重启策略无效，则会重新新建pod的资源。

<!-- OCR_START -->
- Pod
- 工作负载
- (workload)
<!-- OCR_END -->

* ReplicaSet: 代用户创建指定数量的pod副本数量，确保pod副本数量符合预期状态，并且支持滚动式自动扩容和缩容功能
* Deployment：工作在ReplicaSet之上，用于管理无状态应用，目前来说最好的控制器。支持滚动更新和回滚功能，提供声明式配置
* DaemonSet：用于确保集群中的每一个节点只运行特定的pod副本，通常用于实现系统级后台任务。比如EFK服务
* Job：只要完成就立即退出，不需要重启或重建
* Cronjob：周期性任务控制，不需要持续后台运行
* StatefulSet：管理有状态应用

###### Deployment

myblog/deployment/deploy-mysql.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: luffy
spec:
  replicas: 1    #指定Pod副本数
  selector:        #指定Pod的选择器
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:    #给Pod打label
        app: mysql
    spec:
      volumes: 
      - name: mysql-data
        hostPath: 
          path: /opt/mysql/data
      nodeSelector:   # 使用节点选择器将Pod调度到指定label的节点
        component: mysql
      containers:
      - name: mysql
        image: 172.21.51.67:5000/mysql:5.7-utf8
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_USER
          valueFrom:
            secretKeyRef:
              name: myblog
              key: MYSQL_USER
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: myblog
              key: MYSQL_PASSWD
        - name: MYSQL_DATABASE
          value: "myblog"
        resources:
          requests:
            memory: 100Mi
            cpu: 50m
          limits:
            memory: 500Mi
            cpu: 100m
        readinessProbe:
          tcpSocket:
            port: 3306
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: 3306
          initialDelaySeconds: 15
          periodSeconds: 20
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
```

deploy-myblog.yaml:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myblog
  namespace: luffy
spec:
  replicas: 1    #指定Pod副本数
  selector:        #指定Pod的选择器
    matchLabels:
      app: myblog
  template:
    metadata:
      labels:    #给Pod打label
        app: myblog
    spec:
      containers:
      - name: myblog
        image: 172.21.51.67:5000/myblog:v1
        imagePullPolicy: IfNotPresent
        env:
        - name: MYSQL_HOST
          valueFrom:
            configMapKeyRef:
              name: myblog
              key: MYSQL_HOST
        - name: MYSQL_PORT
          valueFrom:
            configMapKeyRef:
              name: myblog
              key: MYSQL_PORT
        - name: MYSQL_USER
          valueFrom:
            secretKeyRef:
              name: myblog
              key: MYSQL_USER
        - name: MYSQL_PASSWD
          valueFrom:
            secretKeyRef:
              name: myblog
              key: MYSQL_PASSWD
        ports:
        - containerPort: 8002
        resources:
          requests:
            memory: 100Mi
            cpu: 50m
          limits:
            memory: 500Mi
            cpu: 100m
        livenessProbe:
          httpGet:
            path: /blog/index/
            port: 8002
            scheme: HTTP
          initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
          periodSeconds: 15     # 执行探测的频率
          timeoutSeconds: 2        # 探测超时时间
        readinessProbe: 
          httpGet: 
            path: /blog/index/
            port: 8002
            scheme: HTTP
          initialDelaySeconds: 10 
          timeoutSeconds: 2
          periodSeconds: 15
```

###### 创建Deployment

```yaml
$ kubectl create -f deploy.yaml

```

###### 查看Deployment

```yaml
# kubectl api-resources
$ kubectl -n luffy get deploy
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
myblog   1/1     1            1           2m22s
mysql    1/1     1            1           2d11h

  * `NAME` 列出了集群中 Deployments 的名称。
  * `READY`显示当前正在运行的副本数/期望的副本数。
  * `UP-TO-DATE`显示已更新以实现期望状态的副本数。
  * `AVAILABLE`显示应用程序可供用户使用的副本数。
  * `AGE` 显示应用程序运行的时间量。

# 查看pod
$ kubectl -n luffy get po
NAME                      READY   STATUS    RESTARTS   AGE
myblog-7c96c9f76b-qbbg7   1/1     Running   0          109s
mysql-85f4f65f99-w6jkj    1/1     Running   0          2m28s

# 查看replicaSet
$ kubectl -n luffy get rs
```

###### 副本保障机制

controller实时检测pod状态，并保障副本数一直处于期望的值。\

```yaml
## 删除pod，观察pod状态变化
$ kubectl -n luffy delete pod myblog-7c96c9f76b-qbbg7

# 观察pod
$ kubectl get pods -o wide

## 设置两个副本, 或者通过kubectl -n luffy edit deploy myblog的方式，最好通过修改文件，然后apply的方式，这样yaml文件可以保持同步
$ kubectl -n luffy scale deploy myblog --replicas=2
deployment.extensions/myblog scaled

# 观察pod
$ kubectl get pods -o wide
NAME                      READY   STATUS    RESTARTS   AGE
myblog-7c96c9f76b-qbbg7   1/1     Running   0          11m
myblog-7c96c9f76b-s6brm   1/1     Running   0          55s
mysql-85f4f65f99-w6jkj    1/1     Running   0          11m
```

  

###### Pod驱逐策略

K8S 有个特色功能叫 pod eviction，它在某些场景下如节点 NotReady，或者资源不足时，把 pod 驱逐至其它节点，这也是出于业务保护的角度去考虑的。

1. Kube-controller-manager: 周期性检查所有节点状态，当节点处于 NotReady 状态超过一段时间后，驱逐该节点上所有 pod。
2. pod-eviction-timeout：NotReady 状态节点超过该时间后，执行驱逐，默认 5 min，适用于k8s 1.13版本之前
   * 1.13版本后，集群开启TaintBasedEvictions 与TaintNodesByCondition 功能，即[taint-based-evictions](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)，即节点若失联或者出现各种异常情况，k8s会自动为node打上污点，同时为pod默认添加如下容忍设置：

```yaml
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
```

```
- <font style="color:rgb(51, 51, 51);">即各pod可以独立设置驱逐容忍时间。</font>
```

1. Kubelet: 周期性检查本节点资源，当资源不足时，按照优先级驱逐部分 pod
   * memory.available：节点可用内存
   * nodefs.available：节点根盘可用存储空间
   * nodefs.inodesFree：节点inodes可用数量
   * imagefs.available：镜像存储盘的可用空间
   * imagefs.inodesFree：镜像存储盘的inodes可用数量

###### 服务更新

修改服务，重新打tag模拟服务更新。

更新方式：

1. 修改yaml文件，使用kubectl apply -f deploy-myblog.yaml来应用更新
2. kubectl -n luffy edit deploy myblog在线更新
3. kubectl -n luffy set image deploy myblog myblog=172.21.51.67:5000/myblog:v2 --record

修改文件测试：

```yaml
$ vi mybolg/blog/template/index.html

$ docker build . -t 172.21.51.67:5000/myblog:v2 -f Dockerfile
$ docker push 172.21.51.67:5000/myblog:v2
```

**更新策略**

```yaml
...
spec:
  replicas: 2    #指定Pod副本数
  selector:        #指定Pod的选择器
    matchLabels:
      app: myblog
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 25%
    type: RollingUpdate        #指定更新方式为滚动更新，默认策略，通过get deploy yaml查看
    ...
```

<!-- OCR_START -->
- Deployment
- RS(old)
- RS(new)
- app
- v1
- v2
<!-- OCR_END -->

\
策略控制：

* maxSurge：最大激增数, 指更新过程中, 最多可以比replicas预先设定值多出的pod数量, 可以为固定值或百分比,默认为desired Pods数的25%。计算时向上取整(比如3.4，取4)，更新过程中最多会有replicas + maxSurge个pod
* maxUnavailable： 指更新过程中, 最多有几个pod处于无法服务状态 , 可以为固定值或百分比，默认为desired Pods数的25%。计算时向下取整(比如3.6，取3)

*在Deployment rollout时，需要保证Available(Ready) Pods数不低于 desired pods number - maxUnavailable; 保证所有的非异常状态Pods数不多于 desired pods number + maxSurge*。

replicas=3

running状态pod最大不超过3+1=4个，

running状态的Pod数不低于3-0=3个

1. 先新增一个v2版本的pod，目前3个v1版本+1个v2版本，共4个pod
2. 删掉一个v1版本的pod，目前2个v1版本+1个v2版本，共3个pod
3. 先新增一个v2版本的pod，目前2个v1版本+2个v2版本，共4个pod
4. 删掉一个v1版本的pod，目前1个v1版本+2个v2版本，共3个pod
5. 先新增一个v2版本的pod，目前1个v1版本+3个v2版本，共4个pod
6. 删掉一个v1版本的pod，目前0个v1版本+3个v2版本，共3个pod

以myblog为例，使用默认的策略，更新过程:

1. maxSurge 25%，2个实例，向上取整，则maxSurge为1，意味着最多可以有2+1=3个Pod，那么此时会新创建1个ReplicaSet，RS-new，把副本数置为1，此时呢，副本控制器就去创建这个新的Pod
2. 同时 `maxUnavailable` 为 25%：副本数 2 × 25% 向下取整为 **0**，意味着滚动更新过程中不能少于 2 个可用 Pod。

因此旧的 ReplicaSet（RS-old）先保持不变，等 RS-new 管理的 Pod 状态变为 Ready 后，此时已有 3 个 Ready 状态的 Pod。由于只需保证 2 个可用，RS-old 的副本数就从 2 变为 1，即删掉一个旧 Pod。
3. 删掉旧的Pod的时候，由于总的Pod数量又变成2个了，因此，距离最大的3个还有1个Pod可以创建，所以，RS-new把管理的副本数由1改成2，此时又会创建1个新的Pod，等RS-new管理了2个Pod都ready后，那么就可以把RS-old的副本数由1置为0了，这样就完成了滚动更新

```yaml
#查看滚动更新事件
$ kubectl -n luffy describe deploy myblog
...
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  11s   deployment-controller  Scaled up replica set myblog-6cf56fc848 to 1
  Normal  ScalingReplicaSet  11s   deployment-controller  Scaled down replica set myblog-6fdcf98f9 to 1
  Normal  ScalingReplicaSet  11s   deployment-controller  Scaled up replica set myblog-6cf56fc848 to 2
  Normal  ScalingReplicaSet  6s    deployment-controller  Scaled down replica set myblog-6fdcf98f9 to 0
$ kubectl get rs
NAME                     DESIRED   CURRENT   READY   AGE
myblog-6cf56fc848   2         2         2       16h
myblog-6fdcf98f9    0         0         0       16h
```

###### 服务回滚

通过滚动升级的策略可以平滑的升级Deployment，若升级出现问题，需要最快且最好的方式回退到上一次能够提供正常工作的版本。为此K8S提供了回滚机制。

**revision**：更新应用时，K8S都会记录当前的版本号，即为revision，当升级出现问题时，可通过回滚到某个特定的revision，默认配置下，K8S只会保留最近的几个revision，可以通过Deployment配置文件中的spec.revisionHistoryLimit属性增加revision数量，默认是10。

查看当前：

```yaml
$ kubectl -n luffy rollout history deploy myblog ##CHANGE-CAUSE为空
$ kubectl delete -f deploy-myblog.yaml    ## 方便演示到具体效果，删掉已有deployment
```

记录回滚：

```yaml
$ kubectl create -f deploy-myblog.yaml --record

$ kubectl -n luffy set image deploy myblog myblog=172.21.51.67:5000/myblog:v2 --record=true
```

查看deployment更新历史：

```yaml
$ kubectl -n luffy rollout history deploy myblog
deployment.extensions/myblog
REVISION  CHANGE-CAUSE
1         kubectl create --filename=deploy-myblog.yaml --record=true
2         kubectl set image deploy myblog myblog=172.21.51.67:5000/demo/myblog:v1 --record=true
```

回滚到具体的REVISION:

```yaml
$ kubectl -n luffy rollout undo deploy myblog --to-revision=1
deployment.extensions/myblog rolled back

# 访问应用测试
```

##### Kubernetes服务访问之Service

通过以前的学习，我们已经能够通过Deployment来创建一组Pod来提供具有高可用性的服务。虽然每个Pod都会分配一个单独的Pod IP，然而却存在如下两个问题：

* Pod IP仅仅是集群内可见的虚拟IP，外部无法访问。
* Pod IP会随着Pod的销毁而消失，当ReplicaSet对Pod进行动态伸缩时，Pod IP可能随时随地都会变化，这样对于我们访问这个服务带来了难度。

###### Service 负载均衡之Cluster IP

service是一组pod的服务抽象，相当于一组pod的LB，负责将请求分发给对应的pod。service会为这个LB提供一个IP，一般称为cluster IP 。使用Service对象，通过selector进行标签选择，找到对应的Pod:

myblog/deployment/svc-myblog.yaml\

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myblog
  namespace: luffy
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8002
  selector:
    app: myblog
  type: ClusterIP
```

操作演示：

```yaml
## 别名
$ alias kd='kubectl -n luffy'

## 创建服务
$ kd create -f svc-myblog.yaml
$ kd get po --show-labels
NAME                      READY   STATUS    RESTARTS   AGE    LABELS
myblog-5c97d79cdb-jn7km   1/1     Running   0          6m5s   app=myblog
mysql-85f4f65f99-w6jkj    1/1     Running   0          176m   app=mysql

$ kd get svc
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
myblog   ClusterIP   10.99.174.93   <none>        80/TCP    7m50s

$ kd describe svc myblog
Name:              myblog
Namespace:         demo
Labels:            <none>
Annotations:       <none>
Selector:          app=myblog
Type:              ClusterIP
IP:                10.99.174.93
Port:              <unset>  80/TCP
TargetPort:        8002/TCP
Endpoints:         10.244.0.68:8002
Session Affinity:  None
Events:            <none>

## 扩容myblog服务
$ kd scale deploy myblog --replicas=2
deployment.extensions/myblog scaled

## 再次查看
$ kd describe svc myblog
Name:              myblog
Namespace:         demo
Labels:            <none>
Annotations:       <none>
Selector:          app=myblog
Type:              ClusterIP
IP:                10.99.174.93
Port:              <unset>  80/TCP
TargetPort:        8002/TCP
Endpoints:         10.244.0.68:8002,10.244.1.158:8002
Session Affinity:  None
Events:            <none>
```

Service与Pod如何关联:

service对象创建的同时，会创建同名的endpoints对象，若服务设置了readinessProbe, 当readinessProbe检测失败时，endpoints列表中会剔除掉对应的pod_ip，这样流量就不会分发到健康检测失败的Pod中\

```yaml
$ kd get endpoints myblog
NAME     ENDPOINTS                            AGE
myblog   10.244.0.68:8002,10.244.1.158:8002   7m
```

Service Cluster-IP如何访问:

```yaml
$ kd get svc myblog
NAME   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
myblog   ClusterIP   10.99.174.93   <none>        80/TCP    13m
$ curl 10.99.174.93/blog/index/
```

为mysql服务创建service：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: luffy
spec:
  ports:
  - port: 3306
    protocol: TCP
    targetPort: 3306
  selector:
    app: mysql
  type: ClusterIP
```

访问mysql：

```yaml
$ kd get svc mysql
mysql    ClusterIP   10.108.214.84   <none>        3306/TCP   3s
$ curl 10.108.214.84:3306
```

  
目前使用hostNetwork部署，通过宿主机ip+port访问，弊端：

* 服务使用hostNetwork，使得宿主机的端口大量暴漏，存在安全隐患
* 容易引发端口冲突

服务均属于k8s集群，尽可能使用k8s的网络访问，因此可以对目前myblog访问mysql的方式做改造：

* 为mysql创建一个固定clusterIp的Service，把clusterIp配置在myblog的环境变量中
* 利用集群服务发现的能力，组件之间通过service name来访问

###### 服务发现

在k8s集群中，组件之间可以通过定义的Service名称实现通信。

演示服务发现：\

```yaml
## 演示思路：在myblog的容器中直接通过service名称访问服务，观察是否可以访问通

# 先查看服务
$ kd get svc
NAME     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
myblog   ClusterIP   10.99.174.93    <none>        80/TCP     59m
mysql    ClusterIP   10.108.214.84   <none>        3306/TCP   35m

# 进入myblog容器
$ kd exec -ti myblog-5c97d79cdb-j485f bash
[root@myblog-5c97d79cdb-j485f myblog]# curl mysql:3306
5.7.29 )→  (mysql_native_password ot packets out of order
[root@myblog-5c97d79cdb-j485f myblog]# curl myblog/blog/index/
我的博客列表
```

虽然podip和clusterip都不固定，但是service name是固定的，而且具有完全的跨集群可移植性，因此组件之间调用的同时，完全可以通过service name去通信，这样避免了大量的ip维护成本，使得服务的yaml模板更加简单。因此可以对mysql和myblog的部署进行优化改造：

1. mysql可以去掉hostNetwork部署，使得服务只暴漏在k8s集群内部网络
2. configMap中数据库地址可以换成Service名称，这样跨环境的时候，配置内容基本上可以保持不用变化

修改deploy-mysql.yaml\

```yaml
    spec:
      hostNetwork: true    # 去掉此行
      volumes: 
      - name: mysql-data
        hostPath: 
          path: /opt/mysql/data
```

修改configmap.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myblog
  namespace: luffy
data:
  MYSQL_HOST: "mysql"    # 此处替换为mysql
  MYSQL_PORT: "3306"
```

应用修改：

```yaml
$ kubectl delete -f deployment-mysql.yaml

## myblog不用动，会自动因健康检测不过而重启
```

服务发现实现：

CoreDNS是一个Go语言实现的链式插件DNS服务端，是CNCF成员，是一个高性能、易扩展的DNS服务端。\

```yaml
$ kubectl -n kube-system get po -o wide|grep dns
coredns-d4475785-2w4hk             1/1     Running   0          4d22h   10.244.0.64       
coredns-d4475785-s49hq             1/1     Running   0          4d22h   10.244.0.65

# 查看myblog的pod解析配置
$ kubectl -n luffy exec -ti myblog-5c97d79cdb-j485f bash
[root@myblog-5c97d79cdb-j485f myblog]# cat /etc/resolv.conf
nameserver 10.96.0.10
search luffy.svc.cluster.local svc.cluster.local cluster.local
options ndots:5

## 10.96.0.10 从哪来
$ kubectl -n kube-system get svc
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)         AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP   51d

## 启动pod的时候，会把kube-dns服务的cluster-ip地址注入到pod的resolve解析配置中，同时添加对应的namespace的search域。 因此跨namespace通过service name访问的话，需要添加对应的namespace名称，
service_name.namespace
$ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   26h
```

###### Service负载均衡之NodePort

cluster-ip为虚拟地址，只能在k8s集群内部进行访问，集群外部如果访问内部服务，实现方式之一为使用NodePort方式。NodePort会默认在 30000-32767 ，不指定的会随机使用其中一个。

myblog/deployment/svc-myblog-nodeport.yaml\

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myblog-np
  namespace: luffy
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8002
  selector:
    app: myblog
  type: NodePort
```

查看并访问服务：\

```yaml
$ kd create -f svc-myblog-nodeport.yaml
service/myblog-np created
$ kd get svc
NAME        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
myblog      ClusterIP   10.99.174.93     <none>        80/TCP         102m
myblog-np   NodePort    10.105.228.101   <none>        80:30647/TCP   4s
mysql       ClusterIP   10.108.214.84    <none>        3306/TCP       77m

#集群内每个节点的NodePort端口都会进行监听
$ curl 172.21.51.67:30647/blog/index/
我的博客列表
$ curl 172.21.51.68:30647/blog/index/
我的博客列表
## 浏览器访问
```

  
思考：

1. NodePort的端口监听如何转发到对应的Pod服务？
2. CLUSTER-IP为虚拟IP，集群内如何通过虚拟IP访问到具体的Pod服务？

###### kube-proxy

运行在每个节点上，监听 API Server 中服务对象的变化，再通过创建流量路由规则来实现网络的转发。[参照](https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies)

有三种模式：

* User space, 让 Kube-Proxy 在用户空间监听一个端口，所有的 Service 都转发到这个端口，然后 Kube-Proxy 在内部应用层对其进行转发 ， 所有报文都走一遍用户态，性能不高，k8s v1.2版本后废弃。
* Iptables， 当前默认模式，完全由 IPtables 来实现， 通过各个node节点上的iptables规则来实现service的负载均衡，但是随着service数量的增大，iptables模式由于线性查找匹配、全量更新等特点，其性能会显著下降。
* IPVS， 与iptables同样基于Netfilter，但是采用的hash表，因此当service数量达到一定规模时，hash查表的速度优势就会显现出来，从而提高service的服务性能。 k8s 1.8版本开始引入，1.11版本开始稳定，需要开启宿主机的ipvs模块。IPtables模式示意图：

<!-- OCR_START -->
- apiserver
- client
- kube-proxy
- clusterIP
- (iptables)
- Node
- Backend
- Pod
- labels: app=MyApplabels: app=MyApplabels: app=MyAp
- port:
- 9376
<!-- OCR_END -->

```yaml
$ iptables-save |grep -v myblog-np|grep  "luffy/myblog"
-A KUBE-SERVICES ! -s 10.244.0.0/16 -d 10.99.174.93/32 -p tcp -m comment --comment "demo/myblog: cluster IP" -m tcp --dport 80 -j KUBE-MARK-MASQ
-A KUBE-SERVICES -d 10.99.174.93/32 -p tcp -m comment --comment "demo/myblog: cluster IP" -m tcp --dport 80 -j KUBE-SVC-WQNGJ7YFZKCTKPZK

$ iptables-save |grep KUBE-SVC-WQNGJ7YFZKCTKPZK
-A KUBE-SVC-WQNGJ7YFZKCTKPZK -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-GB5GNOM5CZH7ICXZ
-A KUBE-SVC-WQNGJ7YFZKCTKPZK -j KUBE-SEP-7GWC3FN2JI5KLE47

$  iptables-save |grep KUBE-SEP-GB5GNOM5CZH7ICXZ
-A KUBE-SEP-GB5GNOM5CZH7ICXZ -p tcp -m tcp -j DNAT --to-destination 10.244.1.158:8002

$ iptables-save |grep KUBE-SEP-7GWC3FN2JI5KLE47
-A KUBE-SEP-7GWC3FN2JI5KLE47 -p tcp -m tcp -j DNAT --to-destination 10.244.1.159:8002
```

##### Kubernetes服务访问之Ingress

对于Kubernetes的Service，无论是Cluster-Ip和NodePort均是四层的负载，集群内的服务如何实现七层的负载均衡，这就需要借助于Ingress，Ingress控制器的实现方式有很多，比如nginx, Contour, Haproxy, trafik, Istio。几种常用的ingress功能对比和选型可以参考[这里](https://www.kubernetes.org.cn/5948.html)

Ingress-nginx是7层的负载均衡器 ，负责统一管理外部对k8s cluster中Service的请求。主要包含：

* ingress-nginx-controller：根据用户编写的ingress规则（创建的ingress的yaml文件），动态的去更改nginx服务的配置文件，并且reload重载使其生效（是自动化的，通过lua脚本来实现）；
* Ingress资源对象：将Nginx的配置抽象成一个Ingress对象

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: simple-example
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /
        backend:
          serviceName: service1
          servicePort: 8080
```

###### 示意图：

<!-- OCR_START -->
- Traffic
- Ingress
- tea.foo.bar.com
- foo.bar.com/coffee
- other
- Service
- Service tea
- Service coffee
- Pod
<!-- OCR_END -->

###### 实现逻辑

Ingress controller 的工作流程：

1. 通过与 Kubernetes API 交互，**动态感知**集群中 ingress 规则的变化
2. 读取 ingress 规则（规则指明了哪个域名对应哪个 service），按自定义规则**生成一段 nginx 配置**
3. 把配置写入 nginx-ingress-controller 这个 Pod——该 Pod 里运行着 Nginx 服务，控制器将生成的配置写入 `/etc/nginx/nginx.conf`
4. 最后 **reload** 使配置生效

这样就实现了域名配置的动态更新。

###### 安装

[官方文档](https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md)

```yaml
$ wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
## 或者使用myblog/deployment/ingress/mandatory.yaml
## 修改部署节点
$ grep -n5 nodeSelector mandatory.yaml
212-    spec:
213-      hostNetwork: true #添加为host模式
214-      # wait up to five minutes for the drain of connections
215-      terminationGracePeriodSeconds: 300
216-      serviceAccountName: nginx-ingress-serviceaccount
217:      nodeSelector:
218-        ingress: "true"        #替换此处，来决定将ingress部署在哪些机器
219-      containers:
220-        - name: nginx-ingress-controller
221-          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0
222-          args:
```

创建ingress

```yaml
# 为k8s-master节点添加label
$ kubectl label node k8s-master ingress=true

$ kubectl create -f mandatory.yaml
```

使用示例：myblog/deployment/ingress.yaml\

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: myblog
  namespace: luffy
spec:
  rules:
  - host: myblog.luffy.com
    http:
      paths:
      - path: /
        backend:
          serviceName: myblog
          servicePort: 80
```

ingress-nginx动态生成upstream配置：

```yaml
...
                server_name myblog.luffy.com ;

                listen 80  ;
                listen [::]:80  ;
                listen 443  ssl http2 ;
                listen [::]:443  ssl http2 ;

                set $proxy_upstream_name "-";

                ssl_certificate_by_lua_block {
                        certificate.call()
                }

                location / {

                        set $namespace      "luffy";
                        set $ingress_name   "myblog";
 ...
```

###### 访问

域名解析服务，将 myblog.luffy.com解析到ingress的地址上。ingress是支持多副本的，高可用的情况下，生产的配置是使用lb服务（内网F5设备，公网elb、slb、clb，解析到各ingress的机器，如何域名指向lb地址）

本机，添加如下hosts记录来演示效果。

```yaml
172.21.51.67 myblog.luffy.com

```

然后，访问 <http://myblog.luffy.com/blog/index/>

HTTPS访问：

```yaml
#自签名证书
$ openssl req -x509 -nodes -days 2920 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=*.luffy.com/O=ingress-nginx"

# 证书信息保存到secret对象中，ingress-nginx会读取secret对象解析出证书加载到nginx配置中
$ kubectl -n luffy create secret tls https-secret --key tls.key --cert tls.crt
```

修改yaml

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: myblog-tls
  namespace: luffy
spec:
  rules:
  - host: myblog.luffy.com
    http:
      paths:
      - path: /
        backend:
          serviceName: myblog
          servicePort: 80
  tls:
  - hosts:
    - myblog.luffy.com
    secretName: https-secret
```

然后，访问 <https://myblog.luffy.com/blog/index/>

###### 多路径转发及重写的实现

1. 多path转发示例：目标：

```yaml
myblog.luffy.com -> 172.21.51.67 -> /foo   service1:4200
                                      /bar   service2:8080
                                      /         myblog:80
```

实现：

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: simple-fanout-example
  namespace: luffy
spec:
  rules:
  - host: myblog.luffy.com
    http:
      paths:
      - path: /foo
        backend:
          serviceName: service1
          servicePort: 4200
      - path: /bar
        backend:
          serviceName: service2
          servicePort: 8080
      - path: /
        backend:
          serviceName: myblog
          servicePort: 80
```

1. nginx的URL重写

目标：

```yaml
myblog.luffy.com -> 172.21.51.67 -> /foo/    myblog:80/admin/

```

实现：

```yaml
   apiVersion: networking.k8s.io/v1beta1
   kind: Ingress
   metadata:
     name: rewrite-path
     namespace: luffy
     annotations:
       nginx.ingress.kubernetes.io/rewrite-target: /admin/$1
   spec:
     rules:
     - host: myblog.luffy.com
       http:
         paths:
         - path: /foo/(.*)
           backend:
             serviceName: myblog
             servicePort: 80
```

#### 小结

1. 核心讲如何通过k8s管理业务应用
2. 介绍k8s的架构、核心组件和工作流程，使用kubeadm快速安装k8s集群
3. 定义Pod.yaml，将myblog和mysql打包在同一个Pod中，myblog使用localhost访问mysql
4. mysql数据持久化，为myblog业务应用添加了健康检查和资源限制
5. 将myblog与mysql拆分，使用独立的Pod管理
6. yaml文件中的环境变量存在账号密码明文等敏感信息，使用configMap和Secret来统一配置，优化部署
7. 只用Pod去直接管理业务应用，对于多副本的需求，很难实现，因此使用Deployment Workload
8. 有了多副本，多个Pod如何去实现LB入口，因此引入了Service的资源类型，有CLusterIp和NodePort
9. ClusterIP是四层的IP地址，不固定，不具备跨环境迁移，因此利用coredns实现集群内服务发现，组件之间直接通过Service名称通信，实现配置的去IP化
10. 对Django应用做改造，django直接使用mysql:3306实现数据库访问
11. 为了实现在集群外部对集群内服务的访问，因此创建NodePort类型的Service
12. 介绍了Service的实现原理，通过kube-proxy利用iptables或者ipvs维护服务访问规则，实现虚拟IP转发到具体Pod的需求
13. 为了实现集群外使用域名访问myblog，因此引入Ingress资源，通过定义访问规则，实现七层代理
14. 考虑真实的场景，对Ingress的使用做了拓展，介绍多path转发及nginx URL重写的实现

# 03_Kubernetes进阶实践

本章介绍Kubernetes的进阶内容，包含Kubernetes集群调度、CNI插件、认证授权安全体系、分布式存储的对接、Helm的使用等，让学员可以更加深入的学习Kubernetes的核心内容。

* ETCD数据的访问
* kube-scheduler调度策略实践
  * 预选与优选流程
  * 生产中常用的调度配置实践
* k8s集群网络模型
  * CNI介绍及集群网络选型
  * Flannel网络模型的实现
    * vxlan Backend
    * hostgw Backend
* 集群认证与授权
  * APIServer安全控制模型
  * Kubectl的认证授权
  * RBAC
  * kubelet的认证授权
  * Service Account
* 使用Helm管理复杂应用的部署
  * Helm工作原理详解
  * Helm的模板开发
  * 实战：使用Helm部署Harbor仓库
* kubernetes对接分部式存储
  * pv、pvc介绍
  * k8s集群如何使用cephfs作为分布式存储后端
  * 利用storageClass实现动态存储卷的管理
  * 实战：使用分部署存储实现有状态应用的部署
* 本章知识梳理及回顾

#### ETCD常用操作

拷贝etcdctl命令行工具：

```yaml
$ docker exec -ti  etcd_container which etcdctl
$ docker cp etcd_container:/usr/local/bin/etcdctl /usr/bin/etcdctl
```

查看etcd集群的成员节点：

```yaml
$ export ETCDCTL_API=3
$ etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key member list -w table

$ alias etcdctl='etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key'

$ etcdctl member list -w table
```

查看etcd集群节点状态：

```yaml
$ etcdctl endpoint status -w table

$ etcdctl endpoint health -w table
```

设置key值:

```yaml
$ etcdctl put luffy 1
$ etcdctl get luffy
```

查看所有key值：

```yaml
$  etcdctl get / --prefix --keys-only

```

查看具体的key对应的数据：

```yaml
$ etcdctl get /registry/pods/jenkins/sonar-postgres-7fc5d748b6-gtmsb

```

添加定时任务做数据快照（重要！）

```yaml
$ etcdctl snapshot save `hostname`-etcd_`date +%Y%m%d%H%M`.db

```

恢复快照：

1. 停止etcd和apiserver
2. 移走当前数据目录

```yaml
$ mv /var/lib/etcd/ /tmp

```

3. 恢复快照

```yaml
$ etcdctl snapshot restore `hostname`-etcd_`date +%Y%m%d%H%M`.db --data-dir=/var/lib/etcd/

```

  

1. 集群恢复<https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md>

#### Kubernetes调度

###### 为何要控制Pod应该如何调度

* 集群中有些机器的配置高（SSD，更好的内存等），我们希望核心的服务（比如说数据库）运行在上面
* 某两个服务的网络传输很频繁，我们希望它们最好在同一台机器上
* ......

Kubernetes Scheduler 的作用是将待调度的 Pod 按照一定的调度算法和策略绑定到集群中一个合适的 Worker Node 上，并将绑定信息写入到 etcd 中，之后目标 Node 中 kubelet 服务通过 API Server 监听到 Scheduler 产生的 Pod 绑定事件获取 Pod 信息，然后下载镜像启动容器。

<!-- OCR_START -->
- Master
- Scheduler
- etcd
- PodQueue:
- binding
- 调度算法
- 调度策略
- APIServer
- NodeList:
- Node
- Kubelet
<!-- OCR_END -->

###### 调度的过程

Scheduler 提供的调度流程分为预选 (Predicates) 和优选 (Priorities) 两个步骤：

* 预选，K8S会遍历当前集群中的所有 Node，筛选出其中符合要求的 Node 作为候选
* 优选，K8S将对候选的 Node 进行打分

经过预选筛选和优选打分之后，K8S选择分数最高的 Node 来运行 Pod，如果最终有多个 Node 的分数最高，那么 Scheduler 将从当中随机选择一个 Node 来运行 Pod。

<!-- OCR_START -->
- AllClusterNodes
- Node 1
- Node 2
- Node3
- Node 4
- Node5
- Node60
- PredicatesPolicies
- Nodes
- "kind" : "Policy",
- <=16worker
- "apiVersion" :"v1",
- PredicatedNodes
- "predicates" : [
- {"name” : "PodFitsPorts"},
- {("name" : "PodFitsResources"),
- {"name" : "NoDiskConflict"),
- knock out
- {"name":"NoVolumeZoneConflict"},
- {"name" : "MatchNodeSelector"),
- {"name" : "HostName"}
- "priorities" : [
- {"name”: "LeastRequestedPriority","weight": 1},
- {"name" : "BalancedResourceAllocation", "weight" : 1},
- {"name”: "ServiceSpreadingPriority", "weight": 1},
- {"name”: "EqualPriority","weight": 1}
- Priorities Policies
- Prioritied Nodes
- scoreNode1:5
- scoreNode2:6
- scoreNode4:7
- scoreNode60:8
- thebestnode
<!-- OCR_END -->

预选：

<!-- OCR_START -->
- 名称
- 描述
- 默认
- MatchlnterPodAffinity
- 检查Pod和其他Pod是否符合亲和性规则
- CheckVolumeBinding
- 检查PVC和PV是否符合要求
- CheckNodeCondition
- 检查Node是否Ready、网络是否可用、是否OutOfDisk
- GeneralPredicates
- 检查Pod数量上限、CPU、内存、GPU等资源是否符合要求
- HostName
- 检查Node名称是否和Pod中指定的nodeName一致
- 检查Pod内每一个容器所需的HostPort是否已被其它容器
- PodFitsHostPorts
- 占用
- MatchNodeSelector
- 检查Node是否包含Pod标签选择器指定的标签
- PodFitsResources
- 检查Node的CPU和内存是否满足Pod需求
- 检查Pod的Volume和Node上每个Pod的Volume是否
- NoDiskConflict
- 冲突
- PodToleratesNodeTaints
- 检查Pod的Tolerations是否与Node的Taints匹配
- CheckNodeUnschedulable
- 检查Node是否是可调度的
- PodToleratesNodeNo
- Pod是否容忍Node上有NoExecute污点
- ExecuteTaints
- CheckNodeLabelPresence
- 检查Node中是否有Scheduler配置的标签
- 检查Node是否包含策略指定的标签，或待调度Pod在同
- CheckServiceAffinity
- 一个Service和Namespace下的其它Pod的标签的亲和性
- MaxCSIVolumeCount
- 检查挂载了多少CSI卷，是否超过限制
- 检查给定Zone限制前提下，Node是否和待调度Pod存在
- NoVolumeZoneConflict
- 卷冲突
- CheckNodeMemory
- 检查Node是否内存过载，只有QoS是Best-effort的Pod
- Pressure
- 需要检查
- CheckNodeDiskPressure
- 检查Node是否硬盘过载
- CheckNodePIDPressure
- 检查Node的PID数量是否压力过大
<!-- OCR_END -->

优选：

<!-- OCR_START -->
- 名称
- 描述
- 默认
- 默认权重
- EqualPriority
- 所有节点标记相同的分数
- 1
- MostRequestedPriority
- 计算Node的CPU和内存利用率
- RequestedToCapacity
- 将NodeCPU和内存利用率映射成分数
- 1-10
- RatioPriority
- 利用率为0则计10分，利用率为100则计0分
- 属于相同Service或者RC的Pod在Node
- SelectorSpreadPriority
- 上均匀分布
- ServiceSpreadingPriority
- 属于相同Service的Pod在Node上均匀分布
- InterPodAffinityPriority
- 根据Affinity和Anti-Affhinity进行加分减分
- 计算Pod需要的CPU和内存占当前节点可用
- LeastRequestedPriority
- 资源的百分比，百分比最小的最优
- BalancedResourceAllocation
- 计算NodeCPU和内存使用率最均衡的最优
- 根据Node的Annotationscheduleralpha
- kubernetesio/preferAvoidPods，这个
- NodePreferAvoidPodsPriority
- 10000
- Annotation会禁止RC或者ReplicaSet的
- Pod调度在该Node上
- NodeAffinityPriority
- 根据Affinity计分
- TaintTolerationPriority
- 根据Toleration和Taints是否匹配计分
- ImageLocalityPriority
- 根据Node是否具备Pod运行的环境来计分
- ResourceLimitsPriority
- 根据Pod的资源限制进行计分
<!-- OCR_END -->

###### Cordon

```yaml
$ kubectl cordon k8s-slave2
$ kubectl drain k8s-slave2
```

###### NodeSelector

label是kubernetes中一个非常重要的概念，用户可以非常灵活的利用 label 来管理集群中的资源，POD 的调度可以根据节点的 label 进行特定的部署。

查看节点的label：\

```yaml
$ kubectl get nodes --show-labels

```

为节点打label：

```yaml
$ kubectl label node k8s-master disktype=ssd

```

当 node 被打上了相关标签后，在调度的时候就可以使用这些标签了，只需要在spec 字段中添加nodeSelector字段，里面是我们需要被调度的节点的 label。\

```yaml
...
spec:
  hostNetwork: true    # 声明pod的网络模式为host模式，效果通docker run --net=host
  volumes: 
  - name: mysql-data
    hostPath: 
      path: /opt/mysql/data
  nodeSelector:   # 使用节点选择器将Pod调度到指定label的节点
    component: mysql
  containers:
  - name: mysql
      image: 192.168.136.10:5000/demo/mysql:5.7
...
```

###### nodeAffinity

节点亲和性 ， 比上面的nodeSelector更加灵活，它可以进行一些简单的逻辑组合，不只是简单的相等匹配 。分为两种，硬策略和软策略。

requiredDuringSchedulingIgnoredDuringExecution ： 硬策略，如果没有满足条件的节点的话，就不断重试直到满足条件为止，简单说就是你必须满足我的要求，不然我就不会调度Pod。

preferredDuringSchedulingIgnoredDuringExecution：软策略，如果你没有满足调度要求的节点的话，Pod就会忽略这条规则，继续完成调度过程，说白了就是满足条件最好了，没有满足就忽略掉的策略。\

```yaml
#要求 Pod 不能运行在128和132两个节点上，如果有节点满足disktype=ssd或者sas的话就优先调度到这类节点上
...
spec:
      containers:
      - name: demo
        image: 192.168.136.10:5000/demo/myblog:v1
        ports:
        - containerPort: 8002
      affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                    - key: kubernetes.io/hostname
                      operator: NotIn
                      values:
                        - 172.21.51.698
                        - 192.168.136.132

            preferredDuringSchedulingIgnoredDuringExecution:
                - weight: 1
                  preference:
                    matchExpressions:
                    - key: disktype
                      operator: In
                      values:
                        - ssd
                        - sas
...
```

这里的匹配逻辑是 label 的值在某个列表中，现在Kubernetes提供的操作符有下面的几种：

* In：label 的值在某个列表中
* NotIn：label 的值不在某个列表中
* Gt：label 的值大于某个值
* Lt：label 的值小于某个值
* Exists：某个 label 存在
* DoesNotExist：某个 label 不存在

*如果nodeSelectorTerms下面有多个选项的话，满足任何一个条件就可以了；如果matchExpressions有多个选项的话，则必须同时满足这些条件才能正常调度 Pod*

###### 污点（Taints）与容忍（tolerations）

对于nodeAffinity无论是硬策略还是软策略方式，都是调度 Pod 到预期节点上，而Taints恰好与之相反，如果一个节点标记为 Taints ，除非 Pod 也被标识为可以容忍污点节点，否则该 Taints 节点不会被调度Pod。

**Taints（污点）**是 Node 的属性。Node 打了污点后，Kubernetes 默认不会把 Pod 调度到该节点上。

于是 Kubernetes 又给 Pod 设置了 **Tolerations（容忍）** 属性：只要 Pod 能容忍该 Node 上的污点，Kubernetes 就会忽略这个污点，**可以**（注意不是"必须"）把 Pod 调度过去。

简单记：**污点是 Node 拒绝 Pod 的规则，容忍是 Pod 绕过该规则的通行证。**

场景一：私有云服务中，某业务使用GPU进行大规模并行计算。为保证性能，希望确保该业务对服务器的专属性，避免将普通业务调度到部署GPU的服务器。

场景二：用户希望把 Master 节点保留给 Kubernetes 系统组件使用，或者把一组具有特殊资源预留给某些 Pod，则污点就很有用了，Pod 不会再被调度到 taint 标记过的节点。taint 标记节点举例如下：

设置污点：

```yaml
$ kubectl taint node [node_name] key=value:[effect]   
      其中[effect] 可取值： [ NoSchedule | PreferNoSchedule | NoExecute ]
       NoSchedule：一定不能被调度。
       PreferNoSchedule：尽量不要调度。
       NoExecute：不仅不会调度，还会驱逐Node上已有的Pod。
  示例：kubectl taint node k8s-slave1 smoke=true:NoSchedule
```

去除污点：

```yaml
去除指定key及其effect：
     kubectl taint nodes [node_name] key:[effect]-    #这里的key不用指定value

 去除指定key所有的effect: 
     kubectl taint nodes node_name key-

 示例：
     kubectl taint node k8s-master smoke=true:NoSchedule
     kubectl taint node k8s-master smoke:NoExecute-
     kubectl taint node k8s-master smoke-
```

污点演示：

```yaml
## 给k8s-slave1打上污点，smoke=true:NoSchedule
$ kubectl taint node k8s-slave1 smoke=true:NoSchedule
$ kubectl taint node k8s-slave2 drunk=true:NoSchedule

## 扩容myblog的Pod，观察新Pod的调度情况
$ kuebctl -n luffy scale deploy myblog --replicas=3
$ kubectl -n luffy get po -w    ## pending
```

Pod容忍污点示例：myblog/deployment/deploy-myblog-taint.yaml

```yaml
...
spec:
      containers:
      - name: demo
        image: 192.168.136.10:5000/demo/myblog:v1
      tolerations: #设置容忍性
      - key: "smoke" 
        operator: "Equal"  #如果操作符为Exists，那么value属性可省略,不指定operator，默认为Equal
        value: "true"
        effect: "NoSchedule"
      - key: "drunk" 
        operator: "Exists"  #如果操作符为Exists，那么value属性可省略,不指定operator，默认为Equal
      #意思是这个Pod要容忍的有污点的Node的key是smoke Equal true,效果是NoSchedule，
      #tolerations属性下各值必须使用引号，容忍的值都是设置Node的taints时给的值。
```

  

```yaml
$ kubectl apply -f deploy-myblog-taint.yaml

```

```yaml
spec:
      containers:
      - name: demo
        image: 192.168.136.10:5000/demo/myblog
      tolerations:
        - operator: "Exists"
```

验证NoExecute效果

#### Kubernetes集群的网络实现

##### CNI介绍及集群网络选型,

CSI

容器网络接口（Container Network Interface），实现kubernetes集群的Pod网络通信及管理。包括：

* CNI Plugin负责给容器配置网络，它包括两个基本的接口： 配置网络: AddNetwork(net NetworkConfig, rt RuntimeConf) (types.Result, error) 清理网络: DelNetwork(net NetworkConfig, rt RuntimeConf) error
* IPAM Plugin负责给容器分配IP地址，主要实现包括host-local和dhcp。

以上两种插件的支持，使得k8s的网络可以支持各式各样的管理模式，当前在业界也出现了大量的支持方案，其中比较流行的比如flannel、calico等。

kubernetes配置了cni网络插件后，其容器网络创建流程为：

* kubelet先创建pause容器生成对应的network namespace
* 调用网络driver，因为配置的是CNI，所以会调用CNI相关代码，识别CNI的配置目录为/etc/cni/net.d
* CNI driver根据配置调用具体的CNI插件，二进制调用，可执行文件目录为/opt/cni/bin,[项目](https://github.com/containernetworking/plugins)
* CNI插件给pause容器配置正确的网络，pod中其他的容器都是用pause的网络可以在此查看社区中的CNI实现，<https://github.com/containernetworking/cni>

通用类型：flannel、calico等，部署使用简单

其他：根据具体的网络环境及网络需求选择，比如

* 公有云机器，可以选择厂商与网络插件的定制Backend，如AWS、阿里、腾讯针对flannel均有自己的插件，也有AWS ECS CNI
* 私有云厂商，比如Vmware NSX-T等
* 网络性能等，MacVlan

##### Flannel网络模型实现剖析

flannel实现overlay，underlay网络通常有多种实现：

* udp
* vxlan
* host-gw
* ...

不特殊指定的话，默认会使用vxlan技术作为Backend，可以通过如下查看：\

```yaml
$ kubectl -n kube-system exec  kube-flannel-ds-amd64-cb7hs cat /etc/kube-flannel/net-conf.json
{
  "Network": "10.244.0.0/16",
  "Backend": {
    "Type": "vxlan"
  }
}
```

###### vxlan介绍及点对点通信的实现

VXLAN 全称是虚拟可扩展的局域网（ Virtual eXtensible Local Area Network），它是一种 overlay 技术，通过三层的网络来搭建虚拟的二层网络。

<!-- OCR_START -->
- 转发设备
- IP网络
- VTEP
- VXLAN游道
- 服务器
- 虚拟化
- VM
- VNI 5000
- *.......
- VNI6000
- ........
- ..+......
- VNI 7000
<!-- OCR_END -->

它创建在原来的 IP 网络（三层）上，只要是三层可达（能够通过 IP 互相通信）的网络就能部署 vxlan。在每个端点上都有一个 vtep 负责 vxlan 协议报文的封包和解包，也就是在虚拟报文上封装 vtep 通信的报文头部。物理网络上可以创建多个 vxlan 网络，这些 vxlan 网络可以认为是一个隧道，不同节点的虚拟机能够通过隧道直连。每个 vxlan 网络由唯一的 VNI 标识，不同的 vxlan 可以不相互影响。

* VTEP（VXLAN Tunnel Endpoints）：vxlan 网络的边缘设备，用来进行 vxlan 报文的处理（封包和解包）。vtep 可以是网络设备（比如交换机），也可以是一台机器（比如虚拟化集群中的宿主机）
* VNI（VXLAN Network Identifier）：VNI 是每个 vxlan 的标识，一共有 2^24 = 16,777,216，一般每个 VNI 对应一个租户，也就是说使用 vxlan 搭建的公有云可以理论上可以支撑千万级别的租户

演示：在k8s-slave1和k8s-slave2两台机器间，利用vxlan的点对点能力，实现虚拟二层网络的通信

<!-- OCR_START -->
- k8s-slave1
- k8s-slave2
- 10.0.136.12
- 10.0.136.11
- vxlan20
- ens33
- 192.168.136.11
- 192.168.136.12
<!-- OCR_END -->

k8s-slave1节点：\

```yaml
# 创建vTEP设备，对端指向k8s-slave2节点，指定VNI及underlay网络使用的网卡
$ ip link add vxlan20 type vxlan id 20 remote 172.21.51.69 dstport 4789 dev eth0

$ ip -d link show vxlan20

# 启动设备
$ ip link set vxlan20 up 

# 设置ip地址
 ip addr add 10.0.136.11/24 dev vxlan20
```

k8s-slave2节点：

```yaml
# 创建VTEP设备，对端指向k8s-slave1节点，指定VNI及underlay网络使用的网卡
$ ip link add vxlan20 type vxlan id 20 remote 172.21.51.68 dstport 4789 dev eth0

# 启动设备
$ ip link set vxlan20 up 

# 设置ip地址
$ ip addr add 10.0.136.12/24 dev vxlan20
```

在k8s-slave1节点：\

```yaml
$ ping 10.0.136.12

```

<!-- OCR_START -->
- k8s-slave1
- k8s-slave2
- 10.0.136.0/24
- 10.0.136.12
- 10.0.136.11
- Vxlan Tunnel
- vxlan20
- ens33
- 192.168.136.12
- 192.168.136.11
<!-- OCR_END -->

\
隧道是一个逻辑上的概念，在 vxlan 模型中并没有具体的物理实体想对应。隧道可以看做是一种虚拟通道，vxlan 通信双方（图中的虚拟机）认为自己是在直接通信，并不知道底层网络的存在。从整体来说，每个 vxlan 网络像是为通信的虚拟机搭建了一个单独的通信通道，也就是隧道。

实现的过程：

虚拟机的报文通过 vtep 添加上 vxlan 以及外部的报文层，然后发送出去，对方 vtep 收到之后拆除 vxlan 头部然后根据 VNI 把原始报文发送到目的虚拟机。\

```yaml
# 查看k8s-slave1主机路由
$ route -n
10.0.136.0      0.0.0.0         255.255.255.0   U     0      0        0 vxlan20

# 到了vxlan的设备后，
$ ip -d link show vxlan20
    vxlan id 20 remote 172.21.51.69 dev eth0 srcport 0 0 dstport 4789 ...

# 查看fdb地址表，主要由MAC地址、VLAN号、端口号和一些标志域等信息组成,vtep 对端地址为 172.21.51.69，换句话说，如果接收到的报文添加上 vxlan 头部之后都会发到 172.21.51.69
$ bridge fdb show|grep vxlan20
00:00:00:00:00:00 dev vxlan20 dst 172.21.51.69 via eth0 self permanent
```

在k8s-slave2机器抓包，查看vxlan封装后的包:\

```yaml
# 在k8s-slave2机器执行
$ tcpdump -i eth0 host 172.21.51.68 -w vxlan.cap

# 在k8s-slave1机器执行
$ ping 10.0.136.12
```

使用wireshark分析ICMP类型的数据包

###### 跨主机容器网络的通信

<!-- OCR_START -->
- 容器A
- 容器B
- Vxlan Tunnel
- 172.17.0.10
- 172.17.0.3
- 容器C
- 容器D
- k8s-slave1
- k8s-slave2
<!-- OCR_END -->

思考：容器网络模式下，vxlan设备该接在哪里？

基本的保证：目的容器的流量要通过vtep设备进行转发！

<!-- OCR_START -->
- 容器
- 172.18.0.2
- 172.18.0.3
- bridge docker0
- ens33
<!-- OCR_END -->

演示：利用vxlan实现跨主机容器网络通信

为了不影响已有的网络，因此创建一个新的网桥，创建容器接入到新的网桥来演示效果

在k8s-slave1节点：\

```yaml
$ docker network ls

# 创建新网桥，指定cidr段
$ docker network create --subnet 172.18.0.0/16  network-luffy
$ docker network ls

# 新建容器，接入到新网桥
$ docker run -d --name vxlan-test --net network-luffy --ip 172.18.0.2 nginx:alpine

$ docker exec vxlan-test ifconfig

$ brctl show network-luffy
```

在k8s-slave2节点：

```yaml
# 创建新网桥，指定cidr段
$ docker network create --subnet 172.18.0.0/16  network-luffy

# 新建容器，接入到新网桥
$ docker run -d --name vxlan-test --net network-luffy --ip 172.18.0.3 nginx:alpine
```

此时执行ping测试：\

```yaml
$ docker exec vxlan-test ping 172.18.0.3

```

  
分析：数据到了网桥后，出不去。结合前面的示例，因此应该将流量由vtep设备转发，联想到网桥的特性，接入到桥中的端口，会由网桥负责转发数据，因此，相当于所有容器发出的数据都会经过到vxlan的端口，vxlan将流量转到对端的vtep端点，再次由网桥负责转到容器中。

<!-- OCR_START -->
- 容器
- 172.18.0.2
- 172.18.0.3
- bridge docker0
- vxlan20
- ens33
<!-- OCR_END -->

k8s-slave1节点：\

```yaml
# 删除旧的vtep
$ ip link del vxlan20

# 新建vtep
$ ip link add vxlan_docker type vxlan id 100 remote 172.21.51.69 dstport 4789 dev eth0
$ ip link set vxlan_docker up
# 不用设置ip，因为目标是可以转发容器的数据即可

# 接入到网桥中
$ brctl addif br-904603a72dcd vxlan_docker
```

k8s-slave2节点：

```yaml
# 删除旧的vtep
$ ip link del vxlan20

# 新建vtep
$ ip link add vxlan_docker type vxlan id 100 remote 172.21.51.68 dstport 4789 dev eth0
$ ip link set vxlan_docker up
# 不用设置ip，因为目标是可以转发容器的数据即可

# 接入到网桥中
$ brctl addif br-c6660fe2dc53 vxlan_docker
```

再次执行ping测试：

```yaml
$ docker exec vxlan-test ping 172.18.0.3

```

###### Flannel的vxlan实现精讲

思考：k8s集群的网络环境和手动实现的跨主机的容器通信有哪些差别？

1. CNI要求，集群中的每个Pod都必须分配唯一的Pod IP
2. k8s集群内的通信不是vxlan点对点通信，因为集群内的所有节点之间都需要互联
   * 没法创建点对点的vxlan模型

<!-- OCR_START -->
- CoreOSMachine
- Pod
- Web AppFrontend1
- vetho
- MAC
- cachelcontainer
- 10.1.15.2/24
- Outer
- source: 192.168.0.100
- app1container
- IP
- dest: 192.168.0.200
- 91/0000
- UDP
- flanneld
- Inner
- source:10.1.15.2
- dest: 10.1.20.3
- Web App Frontend2
- packet
- veth1
- 10.1.15.3/24
- app2container
- BackendServicel
- backend1container
- 10.1.20.2/24
- backuplcontainer
- 90/0000
- backend2container
- 10.1.20.3/24
<!-- OCR_END -->

flannel如何为每个节点分配Pod地址段：\

```yaml
$ kubectl -n kube-system exec kube-flannel-ds-amd64-cb7hs cat /etc/kube-flannel/net-conf.json
{
  "Network": "10.244.0.0/16",
  "Backend": {
    "Type": "vxlan"
  }
}

#查看节点的pod ip
[root@k8s-master bin]# kd get po -o wide
NAME                      READY   STATUS    RESTARTS   AGE     IP            NODE        
myblog-5d9ff54d4b-4rftt   1/1     Running   1          33h     10.244.2.19   k8s-slave2  
myblog-5d9ff54d4b-n447p   1/1     Running   1          33h     10.244.1.32   k8s-slave1

#查看k8s-slave1主机分配的地址段
$ cat /run/flannel/subnet.env
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.1.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true

# kubelet启动容器的时候就可以按照本机的网段配置来为pod设置IP地址
```

vtep的设备在哪：

```yaml
$ ip -d link show flannel.1
# 没有remote ip，非点对点
```

Pod的流量如何转到vtep设备中\

```yaml
$ brctl show cni0

# 每个Pod都会使用Veth pair来实现流量转到cni0网桥

$ route -n
10.244.0.0      10.244.0.0      255.255.255.0   UG    0      0        0 flannel.1
10.244.1.0      0.0.0.0         255.255.255.0   U     0      0        0 cni0
10.244.2.0      10.244.2.0      255.255.255.0   UG    0      0        0 flannel.1
```

vtep封包的时候，如何拿到目的vetp端的IP及MAC信息

```yaml
# flanneld启动的时候会需要配置--iface=eth0,通过该配置可以将网卡的ip及Mac信息存储到ETCD中，
# 这样，flannel就知道所有的节点分配的IP段及vtep设备的IP和MAC信息，而且所有节点的flanneld都可以感知到节点的添加和删除操作，就可以动态的更新本机的转发配置
```

演示跨主机Pod通信的流量详细过程：

```yaml
$ kubectl -n luffy get po -o wide
myblog-5d9ff54d4b-4rftt   1/1     Running   1          25h    10.244.2.19   k8s-slave2
myblog-5d9ff54d4b-n447p   1/1     Running   1          25h    10.244.1.32   k8s-slave1

$ kubectl -n luffy exec myblog-5d9ff54d4b-n447p -- ping 10.244.2.19 -c 2
PING 10.244.2.19 (10.244.2.19) 56(84) bytes of data.
64 bytes from 10.244.2.19: icmp_seq=1 ttl=62 time=0.480 ms
64 bytes from 10.244.2.19: icmp_seq=2 ttl=62 time=1.44 ms

--- 10.244.2.19 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.480/0.961/1.443/0.482 ms

# 查看路由
$ kubectl -n luffy exec myblog-5d9ff54d4b-n447p -- route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.244.1.1      0.0.0.0         UG    0      0        0 eth0
10.244.0.0      10.244.1.1      255.255.0.0     UG    0      0        0 eth0
10.244.1.0      0.0.0.0         255.255.255.0   U     0      0        0 eth0

# 查看k8s-slave1 的veth pair 和网桥
$ brctl show
bridge name     bridge id               STP enabled     interfaces
cni0            8000.6a9a0b341d88       no              veth048cc253
                                                        veth76f8e4ce
                                                        vetha4c972e1
# 流量到了cni0后，查看slave1节点的route
$ route -n
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.136.2   0.0.0.0         UG    100    0        0 eth0
10.0.136.0      0.0.0.0         255.255.255.0   U     0      0        0 vxlan20
10.244.0.0      10.244.0.0      255.255.255.0   UG    0      0        0 flannel.1
10.244.1.0      0.0.0.0         255.255.255.0   U     0      0        0 cni0
10.244.2.0      10.244.2.0      255.255.255.0   UG    0      0        0 flannel.1
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
192.168.136.0   0.0.0.0         255.255.255.0   U     100    0        0 eth0

# 流量转发到了flannel.1网卡，查看该网卡，其实是vtep设备
$ ip -d link show flannel.1
4: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN mode DEFAULT group default
    link/ether 8a:2a:89:4d:b0:31 brd ff:ff:ff:ff:ff:ff promiscuity 0
    vxlan id 1 local 172.21.51.68 dev eth0 srcport 0 0 dstport 8472 nolearning ageing 300 noudpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

# 该转发到哪里，通过etcd查询数据，然后本地缓存，流量不用走多播发送
$ bridge fdb show dev flannel.1
a6:64:a0:a5:83:55 dst 192.168.136.10 self permanent
86:c2:ad:4e:47:20 dst 172.21.51.69 self permanent

# 对端的vtep设备接收到请求后做解包，取出源payload内容，查看k8s-slave2的路由
$ route -n
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.136.2   0.0.0.0         UG    100    0        0 eth0
10.0.136.0      0.0.0.0         255.255.255.0   U     0      0        0 vxlan20
10.244.0.0      10.244.0.0      255.255.255.0   UG    0      0        0 flannel.1
10.244.1.0      10.244.1.0      255.255.255.0   UG    0      0        0 flannel.1
10.244.2.0      0.0.0.0         255.255.255.0   U     0      0        0 cni0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
192.168.136.0   0.0.0.0         255.255.255.0   U     100    0        0 eth0

#根据路由规则转发到cni0网桥,然后由网桥转到具体的Pod中
```

实际的请求图：

<!-- OCR_START -->
- k8s-node
- POD
- Container 01
- Container 02
- --net=container:id
- Pause-amd64 Container (Network NameSpace)
- veth-pair
- Bridge - cni0
- Routing
- Flannel.1
- -VXLAN Tunnel-
- ens33
- 4
<!-- OCR_END -->

* k8s-slave1 节点中的 pod-a（10.244.2.19）当中的 IP 包通过 pod-a 内的路由表被发送到eth0，进一步通过veth pair转到宿主机中的网桥 cni0
* 到达 cni0 当中的 IP 包通过匹配节点 k8s-slave1 的路由表发现通往 10.244.2.19 的 IP 包应该交给 flannel.1 接口
* flannel.1 作为一个 VTEP 设备，收到报文后将按照 VTEP 的配置进行封包，第一次会查询ETCD，知道10.244.2.19的vtep设备是k8s-slave2机器，IP地址是172.21.51.69，拿到MAC 地址进行 VXLAN 封包。
* 通过节点 k8s-slave2 跟 k8s-slave1之间的网络连接，VXLAN 包到达 k8s-slave2 的 eth0 接口
* 通过端口 8472，VXLAN 包被转发给 VTEP 设备 flannel.1 进行解包
* 解封装后的 IP 包匹配节点 k8s-slave2 当中的路由表（10.244.2.0），内核将 IP 包转发给cni0
* cni0将 IP 包转发给连接在 cni0 上的 pod-b

###### 利用host-gw模式提升集群网络性能

vxlan模式适用于三层可达的网络环境，对集群的网络要求很宽松，但是同时由于会通过VTEP设备进行额外封包和解包，因此给性能带来了额外的开销。

网络插件的目的其实就是将本机的cni0网桥的流量送到目的主机的cni0网桥。实际上有很多集群是部署在同一二层网络环境下的，可以直接利用二层的主机当作流量转发的网关。这样的话，可以不用进行封包解包，直接通过路由表去转发流量。

<!-- OCR_START -->
- k8s-node
- POD
- Container 01
- Container 02
- --net=container:id
- Pause-amd64 Container (Network NameSpace)
- veth-pair
- Bridge - cni0
- Rputing
- Routing
- ens33
- 4
<!-- OCR_END -->

为什么三层可达的网络不直接利用网关转发流量？\

```yaml
内核当中的路由规则，网关必须在跟主机当中至少一个 IP 处于同一网段。
由于k8s集群内部各节点均需要实现Pod互通，因此，也就意味着host-gw模式需要整个集群节点都在同一二层网络内。
```

修改flannel的网络后端：

```yaml
$ kubectl edit cm kube-flannel-cfg -n kube-system
...
net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "host-gw"
      }
    }
kind: ConfigMap
...
```

重建Flannel的Pod

```yaml
$ kubectl -n kube-system get po |grep flannel
kube-flannel-ds-amd64-5dgb8          1/1     Running   0          15m
kube-flannel-ds-amd64-c2gdc          1/1     Running   0          14m
kube-flannel-ds-amd64-t2jdd          1/1     Running   0          15m

$ kubectl -n kube-system delete po kube-flannel-ds-amd64-5dgb8 kube-flannel-ds-amd64-c2gdc kube-flannel-ds-amd64-t2jdd

# 等待Pod新启动后，查看日志，出现Backend type: host-gw字样
$  kubectl -n kube-system logs -f kube-flannel-ds-amd64-4hjdw
I0704 01:18:11.916374       1 kube.go:126] Waiting 10m0s for node controller to sync
I0704 01:18:11.916579       1 kube.go:309] Starting kube subnet manager
I0704 01:18:12.917339       1 kube.go:133] Node controller sync successful
I0704 01:18:12.917848       1 main.go:247] Installing signal handlers
I0704 01:18:12.918569       1 main.go:386] Found network config - Backend type: host-gw
I0704 01:18:13.017841       1 main.go:317] Wrote subnet file to /run/flannel/subnet.env
```

查看节点路由表：

```yaml
$ route -n 
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.136.2   0.0.0.0         UG    100    0        0 eth0
10.244.0.0      0.0.0.0         255.255.255.0   U     0      0        0 cni0
10.244.1.0      172.21.51.68  255.255.255.0   UG    0      0        0 eth0
10.244.2.0      172.21.51.69  255.255.255.0   UG    0      0        0 eth0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
192.168.136.0   0.0.0.0         255.255.255.0   U     100    0        0 eth0
```

  

* k8s-slave1 节点中的 pod-a（10.244.2.19）当中的 IP 包通过 pod-a 内的路由表被发送到eth0，进一步通过veth pair转到宿主机中的网桥 cni0
* 到达 cni0 当中的 IP 包通过匹配节点 k8s-slave1 的路由表发现通往 10.244.2.19 的 IP 包应该使用172.21.51.69这个网关进行转发
* 包到达k8s-slave2节点（172.21.51.69）节点的eth0网卡，根据该节点的路由规则，转发给cni0网卡
* cni0将 IP 包转发给连接在 cni0 上的 pod-b

#### Kubernetes认证与授权

###### APIServer安全控制

![]()

* Authentication：身份认证
  1. 这个环节它面对的输入是整个http request，负责对来自client的请求进行身份校验，支持的方法包括:
     * basic auth
     * client证书验证（https双向验证）
     * jwt token(用于serviceaccount)
  2. APIServer启动时，可以指定一种Authentication方法，也可以指定多种方法。如果指定了多种方法，那么APIServer将会逐个使用这些方法对客户端请求进行验证， 只要请求数据通过其中一种方法的验证，APIServer就会认为Authentication成功；
  3. 使用kubeadm引导启动的k8s集群，apiserver的初始配置中，默认支持client证书验证和serviceaccount两种身份验证方式。 证书认证通过设置--client-ca-file根证书以及--tls-cert-file和--tls-private-key-file来开启。
  4. 在这个环节，apiserver会通过client证书或 http header中的字段(比如serviceaccount的jwt token)来识别出请求的用户身份，包括”user”、”group”等，这些信息将在后面的authorization环节用到。
* Authorization：鉴权，你可以访问哪些资源
  1. 这个环节面对的输入是http request context中的各种属性，包括：user、group、request path（比如：/api/v1、/healthz、/version等）、 request verb(比如：get、list、create等)。
  2. APIServer会将这些属性值与事先配置好的访问策略(access policy）相比较。APIServer支持多种authorization mode，包括Node、RBAC、Webhook等。
  3. APIServer启动时，可以指定一种authorization mode，也可以指定多种authorization mode，如果是后者，只要Request通过了其中一种mode的授权， 那么该环节的最终结果就是授权成功。在较新版本kubeadm引导启动的k8s集群的apiserver初始配置中，authorization-mode的默认配置是”Node,RBAC”。
* Admission Control：[准入控制](http://docs.kubernetes.org.cn/144.html)，一个控制链(层层关卡)，用于拦截请求的一种方式。偏集群安全控制、管理方面。
  * 为什么需要？认证与授权获取 http 请求 header 以及证书，无法通过body内容做校验。Admission 运行在 API Server 的增删改查 handler 中，可以自然地操作 API resource
  * 举个栗子
    * 以NamespaceLifecycle为例， 该插件确保处于Termination状态的Namespace不再接收新的对象创建请求，并拒绝请求不存在的Namespace。该插件还可以防止删除系统保留的Namespace:default，kube-system，kube-public。
    * LimitRanger，若集群的命名空间设置了LimitRange对象，若Pod声明时未设置资源值，则按照LimitRange的定义来未Pod添加默认值

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
  namespace: luffy
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
---
apiVersion: v1
kind: Pod
metadata:
  name: default-mem-demo-2
spec:
  containers:
  - name: default-mem-demo-2-ctr
    image: nginx:alpine
```

  

```
    * <font style="color:rgb(51, 51, 51);">NodeRestriction， 此插件限制kubelet修改Node和Pod对象，这样的kubelets只允许修改绑定到Node的Pod API对象，以后版本可能会增加额外的限制 。开启Node授权策略后，默认会打开该项</font>
- <font style="color:rgb(51, 51, 51);">怎么用？</font><font style="color:rgb(51, 51, 51);">APIServer启动时通过</font><font style="color:rgb(51, 51, 51);"> </font><font style="background-color:rgb(247, 247, 247);">--enable-admission-plugins --disable-admission-plugins</font><font style="color:rgb(51, 51, 51);"> </font><font style="color:rgb(51, 51, 51);">指定需要打开或者关闭的 Admission Controller</font>
- <font style="color:rgb(51, 51, 51);">场景</font>
    * <font style="color:rgb(51, 51, 51);">自动注入sidecar容器或者initContainer容器</font>
    * <font style="color:rgb(51, 51, 51);">webhook admission，实现业务自定义的控制需求</font>
```

###### kubectl的认证授权

kubectl的日志调试级别：

| **信息** | **描述** |
| :--- | :--- |
| v=0 | 通常，这对操作者来说总是可见的。 |
| v=1 | 当您不想要很详细的输出时，这个是一个合理的默认日志级别。 |
| v=2 | 有关服务和重要日志消息的有用稳定状态信息，这些信息可能与系统中的重大更改相关。这是大多数系统推荐的默认日志级别。 |
| v=3 | 关于更改的扩展信息。 |
| v=4 | 调试级别信息。 |
| v=6 | 显示请求资源。 |
| v=7 | 显示 HTTP 请求头。 |
| v=8 | 显示 HTTP 请求内容。 |
| v=9 | 显示 HTTP 请求内容，并且不截断内容。 |

```yaml
$ kubectl get nodes -v=7
I0329 20:20:08.633065    3979 loader.go:359] Config loaded from file /root/.kube/config
I0329 20:20:08.633797    3979 round_trippers.go:416] GET https://192.168.136.10:6443/api/v1/nodes?limit=500
```

kubeadm init启动完master节点后，会默认输出类似下面的提示内容：

```yaml
... ...
Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
... ...
```

这些信息是在告知我们如何配置kubeconfig文件。按照上述命令配置后，master节点上的kubectl就可以直接使用$HOME/.kube/config的信息访问k8s cluster了。 并且，通过这种配置方式，kubectl也拥有了整个集群的管理员(root)权限。

很多K8s初学者在这里都会有疑问：

* 当kubectl使用这种kubeconfig方式访问集群时，Kubernetes的kube-apiserver是如何对来自kubectl的访问进行身份验证(authentication)和授权(authorization)的呢？
* 为什么来自kubectl的请求拥有最高的管理员权限呢？

查看/root/.kube/config文件：

前面提到过apiserver的authentication支持通过tls client certificate、basic auth、token等方式对客户端发起的请求进行身份校验， 从kubeconfig信息来看，kubectl显然在请求中使用了tls client certificate的方式，即客户端的证书。

证书base64解码：

```yaml
$ echo xxxxxxxxxxxxxx |base64 -d > kubectl.crt

```

说明在认证阶段，apiserver会首先使用--client-ca-file配置的CA证书去验证kubectl提供的证书的有效性,基本的方式 ：\

```yaml
$  openssl verify -CAfile /etc/kubernetes/pki/ca.crt kubectl.crt
kubectl.crt: OK
```

除了认证身份，还会取出必要的信息供授权阶段使用，文本形式查看证书内容：

```yaml
$ openssl x509 -in kubectl.crt -text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 4736260165981664452 (0x41ba9386f52b74c4)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=kubernetes
        Validity
            Not Before: Feb 10 07:33:39 2020 GMT
            Not After : Feb  9 07:33:40 2021 GMT
        Subject: O=system:masters, CN=kubernetes-admin
        ...
```

认证通过后，提取出签发证书时指定的CN(Common Name),kubernetes-admin，作为请求的用户名 (User Name), 从证书中提取O(Organization)字段作为请求用户所属的组 (Group)，group = system:masters，然后传递给后面的授权模块。

kubeadm在init初始引导集群启动过程中，创建了许多默认的RBAC规则， 在k8s有关RBAC的官方文档中，我们看到下面一些default clusterrole列表:

其中第一条 `cluster-admin` 这个 cluster role binding 绑定了 `system:masters` group，这与认证环节传递过来的身份信息正好对应。顺着这条绑定关系，就能理清整个授权链路。

我们查看一下这一binding：\

```yaml
$ kubectl describe clusterrolebinding cluster-admin
Name:         cluster-admin
Labels:       kubernetes.io/bootstrapping=rbac-defaults
Annotations:  rbac.authorization.kubernetes.io/autoupdate: true
Role:
  Kind:  ClusterRole
  Name:  cluster-admin
Subjects:
  Kind   Name            Namespace
  ----   ----            ---------
  Group  system:masters
```

我们看到在kube-system名字空间中，一个名为cluster-admin的clusterrolebinding将cluster-admin cluster role与system:masters Group绑定到了一起， 赋予了所有归属于system:masters Group中用户cluster-admin角色所拥有的权限。

我们再来查看一下cluster-admin这个role的具体权限信息：\

```yaml
$ kubectl describe clusterrole cluster-admin
Name:         cluster-admin
Labels:       kubernetes.io/bootstrapping=rbac-defaults
Annotations:  rbac.authorization.kubernetes.io/autoupdate: true
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  *.*        []                 []              [*]
             [*]                []              [*]
```

非资源类，如查看集群健康状态。

<!-- OCR_START -->
- Kubernetes 1.10.3:Kube-apiserver
- authorization
- ClusterRole:
- Kubectl
- authentication
- (RBAC)
- Group=
- cluster-admin
- client-certiflcate
- system:masters
- KUBECONFIG
- (admin.conf)
<!-- OCR_END -->

###### RBAC

Role-Based Access Control，基于角色的访问控制， apiserver启动参数添加--authorization-mode=RBAC 来启用RBAC认证模式，kubeadm安装的集群默认已开启。[官方介绍](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

查看开启：\

```yaml
# master节点查看apiserver进程
$ ps aux |grep apiserver
```

RBAC模式引入了4个资源类型：

* Role，角色
* 一个Role只能授权访问单个namespace

```yaml
## 示例定义一个名为pod-reader的角色，该角色具有读取default这个命名空间下的pods的权限
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

## apiGroups: "","apps", "autoscaling", "batch", kubectl api-versions
## resources: "services", "pods","deployments"... kubectl api-resources
## verbs: "get", "list", "watch", "create", "update", "patch", "delete", "exec"

## https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/
```

* ClusterRole

一个ClusterRole能够授予和Role一样的权限，但是它是集群范围内的。\

```yaml
## 定义一个集群角色，名为secret-reader，该角色可以读取所有的namespace中的secret资源
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  # "namespace" omitted since ClusterRoles are not namespaced
  name: secret-reader
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list"]

# User,Group,ServiceAccount
```

* Rolebinding

将role中定义的权限分配给用户和用户组。RoleBinding包含主题（users,groups,或service accounts）和授予角色的引用。对于namespace内的授权使用RoleBinding，集群范围内使用ClusterRoleBinding。

```yaml
定义一个角色绑定，将pod-reader这个role的权限授予给jane这个User，使得jane可以在读取default这个命名空间下的所有的pod数据
kind: RoleBinding 
apiVersion: rbac.authorization.k8s.io/v1 
metadata: 
	name: read-pods 
namespace: default 
subjects:
	kind: User #这里可以是User,Group,ServiceAccount 
name: jane 
apiGroup: rbac.authorization.k8s.io 
roleRef: 
kind: Role#这里可以是Role或者ClusterRole,若是ClusterRole，则权限也仅限于rolebinding的内部 
name: pod-reader # match the name of the Role or ClusterRole you wish to bind to 
apiGroup: rbac.authorization.k8s.io

  *注意：rolebinding既可以绑定role，也可以绑定clusterrole，当绑定clusterrole的时候，subject的权限也会被限定于rolebinding定义的namespace内部，若想跨namespace，需要使用clusterrolebinding*

```

```yaml
## 定义一个角色绑定，将dave这个用户和secret-reader这个集群角色绑定，虽然secret-reader是集群角色，但是因为是使用rolebinding绑定的，因此dave的权限也会被限制在development这个命名空间内
apiVersion: rbac.authorization.k8s.io/v1
# This role binding allows "dave" to read secrets in the "development" namespace.
# You need to already have a ClusterRole named "secret-reader".
kind: RoleBinding
metadata:
  name: read-secrets
    #
    # The namespace of the RoleBinding determines where the permissions are granted.
    # This only grants permissions within the "development" namespace.
  namespace: development
subjects:
- kind: User
  name: dave # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
- kind: ServiceAccount
  name: dave # Name is case sensitive
  namespace: luffy
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

考虑一个场景： 如果集群中有多个namespace分配给不同的管理员，每个namespace的权限是一样的，就可以只定义一个clusterrole，然后通过rolebinding将不同的namespace绑定到管理员身上，否则就需要每个namespace定义一个Role，然后做一次rolebinding。

* ClusterRolebingding允许跨namespace进行授权

```yaml
apiVersion: rbac.authorization.k8s.io/v1

This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
kind: ClusterRoleBinding 
metadata: name: read-secrets-global 
subjects:
	kind: Group 
	name: manager # Name is case sensitive 
apiGroup: rbac.authorization.k8s.io 
roleRef: 
	kind: ClusterRole 
	name: secret-reader 
apiGroup: rbac.authorization.k8s.io
```

###### kubelet的认证授权

查看kubelet进程

```yaml
$ systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
   Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
  Drop-In: /usr/lib/systemd/system/kubelet.service.d
           └─10-kubeadm.conf
   Active: active (running) since Sun 2020-07-05 19:33:36 EDT; 1 day 12h ago
     Docs: https://kubernetes.io/docs/
 Main PID: 10622 (kubelet)
    Tasks: 24
   Memory: 60.5M
   CGroup: /system.slice/kubelet.service
           └─851 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf
```

查看/etc/kubernetes/kubelet.conf，解析证书：

```yaml
$ echo xxxxx |base64 -d >kubelet.crt
$ openssl x509 -in kubelet.crt -text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 9059794385454520113 (0x7dbadafe23185731)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=kubernetes
        Validity
            Not Before: Feb 10 07:33:39 2020 GMT
            Not After : Feb  9 07:33:40 2021 GMT
        Subject: O=system:nodes, CN=system:node:master-1
```

得到我们期望的内容：

```yaml
Subject: O=system:nodes, CN=system:node:k8s-master

```

我们知道，k8s会把O作为Group来进行请求，因此如果有权限绑定给这个组，肯定在clusterrolebinding的定义中可以找得到。因此尝试去找一下绑定了system:nodes组的clusterrolebinding\

```yaml
$ kubectl get clusterrolebinding|awk 'NR>1{print $1}'|xargs kubectl get clusterrolebinding -oyaml|grep -n10 system:nodes
98-  roleRef:
99-    apiGroup: rbac.authorization.k8s.io
100-    kind: ClusterRole
101-    name: system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
102-  subjects:
103-  - apiGroup: rbac.authorization.k8s.io
104-    kind: Group
105:    name: system:nodes
106-- apiVersion: rbac.authorization.k8s.io/v1
107-  kind: ClusterRoleBinding
108-  metadata:
109-    creationTimestamp: "2020-02-10T07:34:02Z"
110-    name: kubeadm:node-proxier
111-    resourceVersion: "213"
112-    selfLink: /apis/rbac.authorization.k8s.io/v1/clusterrolebindings/kubeadm%3Anode-proxier

$ kubectl describe clusterrole system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
Name:         system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
Labels:       kubernetes.io/bootstrapping=rbac-defaults
Annotations:  rbac.authorization.kubernetes.io/autoupdate: true
PolicyRule:
  Resources                                                      Non-Resource URLs  Resource Names  Verbs
  ---------                                                      -----------------  --------------  -----
  certificatesigningrequests.certificates.k8s.io/selfnodeclient  []                 []              [create]
```

结局有点意外，除了system:certificates.k8s.io:certificatesigningrequests:selfnodeclient外，没有找到system相关的rolebindings，显然和我们的理解不一样。 尝试去找[资料](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#core-component-roles)，发现了这么一段 :

| **Default ClusterRole** | **Default ClusterRoleBinding** | **Description** |
| :--- | :--- | :--- |
| system:kube-scheduler | system:kube-scheduler user | Allows access to the resources required by the [scheduler](https://kubernetes.io/docs/reference/generated/kube-scheduler/)component. |
| system:volume-scheduler | system:kube-scheduler user | Allows access to the volume resources required by the kube-scheduler component. |
| system:kube-controller-manager | system:kube-controller-manager user | Allows access to the resources required by the [controller manager](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/) component. The permissions required by individual controllers are detailed in the [controller roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#controller-roles). |
| system:node | None | Allows access to resources required by the kubelet, **including read access to all secrets, and write access to all pod status objects**. You should use the [Node authorizer](https://kubernetes.io/docs/reference/access-authn-authz/node/) and [NodeRestriction admission plugin](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#noderestriction) instead of the system:node role, and allow granting API access to kubelets based on the Pods scheduled to run on them. The system:node role only exists for compatibility with Kubernetes clusters upgraded from versions prior to v1.8. |
| system:node-proxier | system:kube-proxy user | Allows access to the resources required by the [kube-proxy](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)component. |

大致意思是说：之前会定义system:node这个角色，目的是为了kubelet可以访问到必要的资源，包括所有secret的读权限及更新pod状态的写权限。如果1.8版本后，是建议使用 [Node authorizer](https://kubernetes.io/docs/reference/access-authn-authz/node/) and [NodeRestriction admission plugin](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#noderestriction) 来代替这个角色的。

我们目前使用1.16，查看一下授权策略：\

```yaml
$ ps axu|grep apiserver
kube-apiserver --authorization-mode=Node,RBAC  --enable-admission-plugins=NodeRestriction
```

查看一下官网对Node authorizer的介绍：

*Node authorization is a special-purpose authorization mode that specifically authorizes API requests made by kubelets.*

*In future releases, the node authorizer may add or remove permissions to ensure kubelets have the minimal set of permissions required to operate correctly.*

*In order to be authorized by the Node authorizer, kubelets must use a credential that identifies them as being in the** **system:nodes** **group, with a username of** **system:node:<nodeName>*

###### Service Account及K8S Api调用

前面说，认证可以通过证书，也可以通过使用ServiceAccount（服务账户）的方式来做认证。大多数时候，我们在基于k8s做二次开发时都是选择通过ServiceAccount + RBAC 的方式。我们之前访问dashboard的时候，是如何做的？

```yaml
## 新建一个名为admin的serviceaccount，并且把名为cluster-admin的这个集群角色的权限授予新建的
#serviceaccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: kubernetes-dashboard
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: admin
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: admin
  namespace: kubernetes-dashboard
```

我们查看一下：

```yaml
$ kubectl -n kubernetes-dashboard get sa admin -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2020-04-01T11:59:21Z"
  name: admin
  namespace: kubernetes-dashboard
  resourceVersion: "1988878"
  selfLink: /api/v1/namespaces/kubernetes-dashboard/serviceaccounts/admin
  uid: 639ecc3e-74d9-11ea-a59b-000c29dfd73f
secrets:
- name: admin-token-lfsrf
```

注意到serviceaccount上默认绑定了一个名为admin-token-lfsrf的secret，我们查看一下secret\

```yaml
$ kubectl -n kubernetes-dashboard describe secret admin-token-lfsrf
Name:         admin-token-lfsrf
Namespace:    kubernetes-dashboard
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: admin
              kubernetes.io/service-account.uid: 639ecc3e-74d9-11ea-a59b-000c29dfd73f

Type:  kubernetes.io/service-account-token
Data
====
ca.crt:     1025 bytes
namespace:  4 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZW1vIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImFkbWluLXRva2VuLWxmc3JmIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNjM5ZWNjM2UtNzRkOS0xMWVhLWE1OWItMDAwYzI5ZGZkNzNmIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlbW86YWRtaW4ifQ.ffGCU4L5LxTsMx3NcNixpjT6nLBi-pmstb4I-W61nLOzNaMmYSEIwAaugKMzNR-2VwM14WbuG04dOeO67niJeP6n8-ALkl-vineoYCsUjrzJ09qpM3TNUPatHFqyjcqJ87h4VKZEqk2qCCmLxB6AGbEHpVFkoge40vHs56cIymFGZLe53JZkhu3pwYuS4jpXytV30Ad-HwmQDUu_Xqcifni6tDYPCfKz2CZlcOfwqHeGIHJjDGVBKqhEeo8PhStoofBU6Y4OjObP7HGuTY-Foo4QindNnpp0QU6vSb7kiOiQ4twpayybH8PTf73dtdFt46UF6mGjskWgevgolvmO8A
```

演示role的权限：

```yaml
$ cat test-sa.yaml
serviceaccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test
  namespace: kubernetes-dashboard

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: test
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: test
  namespace: kubernetes-dashboard
```

curl演示

```yaml
$ curl -k  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InhXcmtaSG5ZODF1TVJ6dUcycnRLT2c4U3ZncVdoVjlLaVRxNG1wZ0pqVmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi10b2tlbi1xNXBueiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJhZG1pbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImViZDg2ODZjLWZkYzAtNDRlZC04NmZlLTY5ZmE0ZTE1YjBmMCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbiJ9.iEIVMWg2mHPD88GQ2i4uc_60K4o17e39tN0VI_Q_s3TrRS8hmpi0pkEaN88igEKZm95Qf1qcN9J5W5eqOmcK2SN83Dd9dyGAGxuNAdEwi0i73weFHHsjDqokl9_4RGbHT5lRY46BbIGADIphcTeVbCggI6T_V9zBbtl8dcmsd-lD_6c6uC2INtPyIfz1FplynkjEVLapp_45aXZ9IMy76ljNSA8Uc061Uys6PD3IXsUD5JJfdm7lAt0F7rn9SdX1q10F2lIHYCMcCcfEpLr4Vkymxb4IU4RCR8BsMOPIO_yfRVeYZkG4gU2C47KwxpLsJRrTUcUXJktSEPdeYYXf9w" https://192.168.136.10:6443/api/v1/namespaces/luffy/pods?limit=500

```

#### 通过HPA实现业务应用的动态扩缩容

##### HPA控制器介绍

当系统资源过高的时候，我们可以使用如下命令来实现 Pod 的扩缩容功能\

```yaml
$ kubectl -n luffy scale deployment myblog --replicas=2

```

但上面是手动操作。实际项目中需要**自动感知负载并自动扩容**，Kubernetes 为此提供了资源对象 **HPA（Horizontal Pod Autoscaling，Pod 水平自动伸缩）**（[文档](https://v1-14.docs.kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)）。

<!-- OCR_START -->
- Pod 1
- Pod 2
- Pod N
- RC / Deployment
- Scale
- Horizontal
- Pod
- Autoscaler
- nttphtpist0glogchsdetneift9nh0908
<!-- OCR_END -->

基本原理：HPA 通过监控分析控制器控制的所有 Pod 的负载变化情况来确定是否需要调整 Pod 的副本数量

HPA的实现有两个版本：

* autoscaling/v1，只包含了根据CPU指标的检测，稳定版本
* autoscaling/v2beta1，支持根据memory或者用户自定义指标进行伸缩

如何获取Pod的监控数据？

* k8s 1.8以下：使用heapster，1.11版本完全废弃
* k8s 1.8以上：使用metric-server

思考：为什么之前用 heapster ，现在废弃了项目，改用 metric-server ？

heapster时代，apiserver 会直接将metric请求通过apiserver proxy 的方式转发给集群内的 hepaster 服务，采用这种 proxy 方式是有问题的：\

```yaml
http://kubernetes_master_address/api/v1/namespaces/namespace_name/services/service_name[:port_name]/proxy

```

* proxy只是代理请求，一般用于问题排查，不够稳定，且版本不可控
* heapster的接口不能像apiserver一样有完整的鉴权以及client集成
* pod 的监控数据是核心指标（HPA调度），应该和 pod 本身拥有同等地位，即 metric应该作为一种资源存在，如metrics.k8s.io 的形式，称之为 Metric Api

于是官方从 1.8 版本开始逐步废弃 heapster，并提出了上边 Metric api 的概念，而 metrics-server 就是这种概念下官方的一种实现，用于从 kubelet获取指标，替换掉之前的 heapster。

Metrics Server 可以通过标准的 Kubernetes API 把监控数据暴露出来，比如获取某一Pod的监控数据：

```yaml
https://192.168.136.10:6443/apis/metrics.k8s.io/v1beta1/namespaces/<namespace-name>/pods/<pod-name>

# https://192.168.136.10:6443/api/v1/namespaces/luffy/pods?limit=500
```

目前的采集流程：

<!-- OCR_START -->
- HPA
- metrics.k8s.io/v1beta1
- MetricsAPI
- MetricsServer
- kubernetes.summary_api
- Kubelet
<!-- OCR_END -->

##### Metric Server

[官方介绍](https://v1-14.docs.kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/#metrics-server)

```yaml
...
Metric server collects metrics from the Summary API, exposed by Kubelet on each node.

Metrics Server registered in the main API server through Kubernetes aggregator, which was introduced in Kubernetes 1.7
...
```

###### 安装

官方代码仓库地址：<https://github.com/kubernetes-sigs/metrics-server>

Depending on your cluster setup, you may also need to change flags passed to the Metrics Server container. Most useful flags:

* --kubelet-preferred-address-types - The priority of node address types used when determining an address for connecting to a particular node (default \[Hostname,InternalDNS,InternalIP,ExternalDNS,ExternalIP])
* --kubelet-insecure-tls - Do not verify the CA of serving certificates presented by Kubelets. For testing purposes only.
* --requestheader-client-ca-file - Specify a root certificate bundle for verifying client certificates on incoming requests.

```yaml
$ wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml

```

修改args参数：

```yaml
...
 84       containers:
 85       - name: metrics-server
 86         image: registry.aliyuncs.com/google_containers/metrics-server-amd64:v0.3.6
 87         imagePullPolicy: IfNotPresent
 88         args:
 89           - --cert-dir=/tmp
 90           - --secure-port=4443
 91           - --kubelet-insecure-tls
 92           - --kubelet-preferred-address-types=InternalIP
...
```

执行安装：

```yaml
$ kubectl create -f components.yaml

$ kubectl -n kube-system get pods

$ kubectl top nodes
```

###### kubelet的指标采集

无论是 heapster还是 metric-server，都只是数据的中转和聚合，两者都是调用的 kubelet 的 api 接口获取的数据，而 kubelet 代码中实际采集指标的是 cadvisor 模块，你可以在 node 节点访问 10250 端口获取监控数据：

* Kubelet Summary metrics: [https://127.0.0.1:10250/metrics，暴露](https://127.0.0.1:10250/metrics%EF%BC%8C%E6%9A%B4%E9%9C%B2) node、pod 汇总数据
* Cadvisor metrics: [https://127.0.0.1:10250/metrics/cadvisor，暴露](https://127.0.0.1:10250/metrics/cadvisor%EF%BC%8C%E6%9A%B4%E9%9C%B2) container 维度数据

调用示例：\

```yaml
$ curl -k  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InhXcmtaSG5ZODF1TVJ6dUcycnRLT2c4U3ZncVdoVjlLaVRxNG1wZ0pqVmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi10b2tlbi1xNXBueiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJhZG1pbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImViZDg2ODZjLWZkYzAtNDRlZC04NmZlLTY5ZmE0ZTE1YjBmMCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbiJ9.iEIVMWg2mHPD88GQ2i4uc_60K4o17e39tN0VI_Q_s3TrRS8hmpi0pkEaN88igEKZm95Qf1qcN9J5W5eqOmcK2SN83Dd9dyGAGxuNAdEwi0i73weFHHsjDqokl9_4RGbHT5lRY46BbIGADIphcTeVbCggI6T_V9zBbtl8dcmsd-lD_6c6uC2INtPyIfz1FplynkjEVLapp_45aXZ9IMy76ljNSA8Uc061Uys6PD3IXsUD5JJfdm7lAt0F7rn9SdX1q10F2lIHYCMcCcfEpLr4Vkymxb4IU4RCR8BsMOPIO_yfRVeYZkG4gU2C47KwxpLsJRrTUcUXJktSEPdeYYXf9w" https://localhost:10250/metrics

```

kubelet虽然提供了 metric 接口，但实际监控逻辑由内置的cAdvisor模块负责，早期的时候，cadvisor是单独的组件，从k8s 1.12开始，cadvisor 监听的端口在k8s中被删除，所有监控数据统一由Kubelet的API提供。

cadvisor获取指标时实际调用的是 runc/libcontainer库，而libcontainer是对 cgroup文件 的封装，即 cadvsior也只是个转发者，它的数据来自于cgroup文件。

cgroup文件中的值是监控数据的最终来源，如

* mem usage的值，
  * 对于docker容器来讲，来源于/sys/fs/cgroup/memory/docker/\[containerId]/memory.usage_in_bytes
  * 对于pod来讲，/sys/fs/cgroup/memory/kubepods/besteffort/pod\[podId]/memory.usage_in_bytes或者/sys/fs/cgroup/memory/kubepods/burstable/pod\[podId]/memory.usage_in_bytes
* 如果没限制内存，Limit = machine_mem，否则来自于 /sys/fs/cgroup/memory/docker/\[id]/memory.limit_in_bytes
* 内存使用率 = memory.usage_in_bytes/memory.limit_in_bytes

Metrics数据流：

<!-- OCR_START -->
- kubectl
- k8sdashboard
- heapster
- apiserver
- kubelet(cadvisor)
- cgroup
- metric-server
- scheduler
- WWw.xuyasong co11
<!-- OCR_END -->

思考：

Metrics Server是独立的一个服务，只能服务内部实现自己的api，是如何做到通过标准的kubernetes 的API格式暴露出去的？

[kube-aggregator](https://github.com/kubernetes/kube-aggregator)

###### kube-aggregator聚合器及Metric-Server的实现

kube-aggregator是对 apiserver 的api的一种拓展机制，它允许开发人员编写一个自己的服务，并把这个服务注册到k8s的api里面，即扩展 API 。

<!-- OCR_START -->
pluggableAPl 1
pluggableAPl2
StandardResources
APiServer
www.xuryasong.com
<!-- OCR_END -->

定义一个APIService对象：

```yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta1.luffy.k8s.io
spec:
  group: luffy.k8s.io
  groupPriorityMinimum: 100
  insecureSkipTLSVerify: true
  service:
    name: service-A       # 必须https访问
    namespace: luffy
    port: 443   
  version: v1beta1
  versionPriority: 100
```

k8s会自动帮我们代理如下url的请求：

```yaml
proxyPath := "/apis/" + apiService.Spec.Group + "/" + apiService.Spec.Version

```

即：[https://192.168.136.10:6443/apis/luffy.k8s.io/v1beta1/xxxx转到我们的service-A服务中，service-A中只需要实现](https://192.168.136.10:6443/apis/luffy.k8s.io/v1beta1/xxxx%E8%BD%AC%E5%88%B0%E6%88%91%E4%BB%AC%E7%9A%84service-A%E6%9C%8D%E5%8A%A1%E4%B8%AD%EF%BC%8Cservice-A%E4%B8%AD%E5%8F%AA%E9%9C%80%E8%A6%81%E5%AE%9E%E7%8E%B0) https://service-A/luffy.k8s.io/v1beta1/xxxx 即可。

看下metric-server的实现：

```yaml
$ kubectl get apiservice 
NAME                       SERVICE                      AVAILABLE                      
v1beta1.metrics.k8s.io   kube-system/metrics-server        True

$ kubectl get apiservice v1beta1.metrics.k8s.io -oyaml
...
spec:
  group: metrics.k8s.io
  groupPriorityMinimum: 100
  insecureSkipTLSVerify: true
  service:
    name: metrics-server
    namespace: kube-system
    port: 443
  version: v1beta1
  versionPriority: 100
...

$ kubectl -n kube-system get svc metrics-server
NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
metrics-server   ClusterIP   10.110.111.146   <none>        443/TCP   11h

$ curl -k  -H "Authorization: Bearer xxxx" https://10.110.111.146
{
  "paths": [
    "/apis",
    "/apis/metrics.k8s.io",
    "/apis/metrics.k8s.io/v1beta1",
    "/healthz",
    "/healthz/healthz",
    "/healthz/log",
    "/healthz/ping",
    "/healthz/poststarthook/generic-apiserver-start-informers",
    "/metrics",
    "/openapi/v2",
    "/version"
  ]

# https://192.168.136.10:6443/apis/metrics.k8s.io/v1beta1/namespaces/<namespace-name>/pods/<pod-name>
# 
$ curl -k  -H "Authorization: Bearer xxxx" https://10.110.111.146/apis/metrics.k8s.io/v1beta1/namespaces/luffy/pods/myblog-5d9ff54d4b-4rftt

$ curl -k  -H "Authorization: Bearer xxxx" https://192.168.136.10:6443/apis/metrics.k8s.io/v1beta1/namespaces/luffy/pods/myblog-5d9ff54d4b-4rftt
```

##### HPA实践

###### 基于CPU的动态伸缩

<!-- OCR_START -->
- Pod 1
- Pod 2
- Pod N
- RC / Deployment
- Scale
- Horizontal
- Pod
- Autoscaler
- nttphtpist0glogchsdetneift9nh0908
<!-- OCR_END -->

创建hpa对象：

```yaml
# 方式一
$ cat hpa-myblog.yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-myblog-cpu
  namespace: luffy
spec:
  maxReplicas: 3
  minReplicas: 1
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myblog
  targetCPUUtilizationPercentage: 10

# 方式二
$ kubectl -n luffy autoscale deployment myblog --cpu-percent=10 --min=1 --max=3
```

Deployment对象必须配置requests的参数，不然无法获取监控数据，也无法通过HPA进行动态伸缩

验证：

```yaml
$ yum -y install httpd-tools
$ kubectl -n luffy get svc myblog
myblog   ClusterIP   10.104.245.225   <none>        80/TCP    6d18h

# 为了更快看到效果，先调整副本数为1
$ kubectl -n luffy scale deploy myblog --replicas=1

# 模拟1000个用户并发访问页面10万次
$ ab -n 100000 -c 1000 http://10.104.245.225/blog/index/

$ kubectl get hpa
$ kubectl -n luffy get pods
```

压力降下来后，会有默认5分钟的scaledown的时间，可以通过controller-manager的如下参数设置：

```yaml
--horizontal-pod-autoscaler-downscale-stabilization

The value for this option is a duration that specifies how long the autoscaler has to wait before another downscale operation can be performed after the current one has completed. The default value is 5 minutes (5m0s).
```

是一个逐步的过程，当前的缩放完成后，下次缩放的时间间隔，比如从3个副本降低到1个副本，中间大概会等待2\*5min = 10分钟

###### 基于内存的动态伸缩

创建hpa对象

```yaml
$ cat hpa-demo-mem.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-demo-mem
  namespace: luffy
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa-demo-mem
  minReplicas: 1
  maxReplicas: 3
  metrics:
  - type: Resource
    resource:
      name: memory
      targetAverageUtilization: 30
```

加压演示脚本：

```yaml
$ cat increase-mem-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: increase-mem-config
  namespace: luffy
data:
  increase-mem.sh: |
    #!/bin/bash  
    mkdir /tmp/memory  
    mount -t tmpfs -o size=40M tmpfs /tmp/memory  
    dd if=/dev/zero of=/tmp/memory/block  
    sleep 60 
    rm /tmp/memory/block  
    umount /tmp/memory  
    rmdir /tmp/memory
```

测试deployment：

```yaml
$ cat hpa-demo-mem-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hpa-demo-mem
  namespace: luffy
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      volumes:
      - name: increase-mem-script
        configMap:
          name: increase-mem-config
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: increase-mem-script
          mountPath: /etc/script
        resources:
          requests:
            memory: 50Mi
            cpu: 50m
        securityContext:
          privileged: true
```

测试：

```yaml
$ kubectl create -f increase-mem-config.yaml
$ kubectl create -f hpa-demo-mem.yaml
$ kubectl create -f hpa-demo-mem-deploy.yaml

$ kubectl -n luffy exec -ti hpa-demo-mem-7fc75bf5c8-xx424 sh
#/ sh /etc/script/increase-mem.sh

# 观察hpa及pod
$ kubectl -n luffy get hpa
$ kubectl -n luffy get po
```

###### 基于自定义指标的动态伸缩

除了基于 CPU 和内存来进行自动扩缩容之外，我们还可以根据自定义的监控指标来进行。这个我们就需要使用 Prometheus Adapter，Prometheus 用于监控应用的负载和集群本身的各种指标，Prometheus Adapter 可以帮我们使用 Prometheus 收集的指标并使用它们来制定扩展策略，这些指标都是通过 APIServer 暴露的，而且 HPA 资源对象也可以很轻易的直接使用。

<!-- OCR_START -->
- ResourceMetrics
- hpa
- CustomMetrics
- kubelet
- prometheus
- metricserver
- prometheus-adapter
- ww.xuyasong.com
<!-- OCR_END -->

架构图：

<!-- OCR_START -->
- Metrics
- HorizontalPodAutoscaler
- aggregator
- server
- Deployment
- Prometheus
- cAdvisor
- adapter
- kubelet
- ReplicaSet
- Pod
- s://blog.csdn.net/fly910905
<!-- OCR_END -->

#### kubernetes对接分部式存储

##### PV与PVC快速入门

k8s存储的目的就是保证Pod重建后，数据不丢失。简单的数据持久化的下述方式：

* emptyDir

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: k8s.gcr.io/test-webserver
    name: webserver
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
  - image: k8s.gcr.io/test-redis
    name: redis
    volumeMounts:
    - mountPath: /data
      name: cache-volume
volumes:
  - name: cache-volume
    emptyDir: {}
```

```
- <font style="color:rgb(51, 51, 51);">Pod内的容器共享卷的数据</font>
- <font style="color:rgb(51, 51, 51);">存在于Pod的生命周期，Pod销毁，数据丢失</font>
- <font style="color:rgb(51, 51, 51);">Pod内的容器自动重建后，数据不会丢失</font>
```

* hostPath

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: k8s.gcr.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-pd
      name: test-volume
  volumes:
  - name: test-volume
    hostPath:
      # directory location on host
      path: /data
      # this field is optional
      type: Directory
```

* 通常配合nodeSelector使用
* nfs存储

```yaml
...
  volumes:
  - name: redisdata             #卷名称
    nfs:                        #使用NFS网络存储卷
      server: 192.168.31.241    #NFS服务器地址
      path: /data/redis         #NFS服务器共享的目录
      readOnly: false           #是否为只读
...
```

volume 支持的种类众多（[参考](https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes)），每种对应不同的存储后端实现。为了**屏蔽后端存储细节**、让 Pod 使用存储时更简洁规范，K8s 引入了两个新资源类型：**PV** 和 **PVC**。

PersistentVolume（持久化卷），是对底层的存储的一种抽象，它和具体的底层的共享存储技术的实现方式有关，比如 Ceph、GlusterFS、NFS 等，都是通过插件机制完成与共享存储的对接。如使用PV对接NFS存储：\

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity: 
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  nfs:
    path: /data/k8s
    server: 121.204.157.52
```

* capacity，存储能力， 目前只支持存储空间的设置， 就是我们这里的 storage=1Gi，不过未来可能会加入 IOPS、吞吐量等指标的配置。
* accessModes，访问模式， 是用来对 PV 进行访问模式的设置，用于描述用户应用对存储资源的访问权限，访问权限包括下面几种方式：
  * ReadWriteOnce（RWO）：读写权限，但是只能被单个节点挂载
  * ReadOnlyMany（ROX）：只读权限，可以被多个节点挂载
  * ReadWriteMany（RWX）：读写权限，可以被多个节点挂载

<!-- OCR_START -->
- VolumePlugin
- ReadWriteOnce
- ReadOnlyMany
- ReadWriteMany
- AWSElasticBlockStore
- AzureFile
- AzureDisk
- CephFS
- Cinder
- FC
- FlexVolume
- Flocker
- GCEPersistentDisk
- Glusterfs
- HostPath
- iSCSI
- Quobyte
- NFS
- RBD
- VsphereVolume
- （workswhenpods arecollocated)
- PortworxVolume
- Scalelo
- StorageOs
<!-- OCR_END -->

* persistentVolumeReclaimPolicy，pv的回收策略, 目前只有 NFS 和 HostPath 两种类型支持回收策略
  * Retain（保留）- 保留数据，需要管理员手工清理数据
  * Recycle（回收）- 清除 PV 中的数据，效果相当于执行 rm -rf /thevolume/\*
  * Delete（删除）- 与 PV 相连的后端存储完成 volume 的删除操作，当然这常见于云服务商的存储服务，比如 ASW EBS。

因为PV是直接对接底层存储的，就像集群中的Node可以为Pod提供计算资源（CPU和内存）一样，PV可以为Pod提供存储资源。因此PV不是namespaced的资源，属于集群层面可用的资源。Pod如果想使用该PV，需要通过创建PVC挂载到Pod中。

PVC全写是PersistentVolumeClaim（持久化卷声明），PVC 是用户存储的一种声明，创建完成后，可以和PV实现一对一绑定。对于真正使用存储的用户不需要关心底层的存储实现细节，只需要直接使用 PVC 即可。\

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs
  namespace: default
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

然后Pod中通过如下方式去使用：

```yaml
...
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: web
        volumeMounts:                        #挂载容器中的目录到pvc nfs中的目录
        - name: www
          mountPath: /usr/share/nginx/html
      volumes:
      - name: www
        persistentVolumeClaim:              #指定pvc
          claimName: pvc-nfs
...
```

##### PV与PVC管理NFS存储卷实践

###### 环境准备

服务端：121.204.157.52\

```yaml
$ yum -y install nfs-utils rpcbind

# 共享目录
$ mkdir -p /data/k8s && chmod 755 /data/k8s

$ echo '/data/k8s  *(insecure,rw,sync,no_root_squash)'>>/etc/exports

$ systemctl enable rpcbind && systemctl start rpcbind
$ systemctl enable nfs && systemctl start nfs
```

客户端：k8s集群slave节点

```yaml
$ yum -y install nfs-utils rpcbind
$ mkdir /nfsdata
$ mount -t nfs 121.204.157.52:/data/k8s /nfsdata
```

###### PV与PVC演示

```yaml
$ cat pv-nfs.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity: 
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  nfs:
    path: /data/k8s
    server: 121.204.157.52

$ kubectl create -f pv-nfs.yaml

$ kubectl get pv
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS  
nfs-pv   1Gi        RWO            Retain           Available
```

一个 PV 的生命周期中，可能会处于4中不同的阶段：

* Available（可用）：表示可用状态，还未被任何 PVC 绑定
* Bound（已绑定）：表示 PV 已经被 PVC 绑定
* Released（已释放）：PVC 被删除，但是资源还未被集群重新声明
* Failed（失败）： 表示该 PV 的自动回收失败

```yaml
$ cat pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs
  namespace: default
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

$ kubectl create -f pvc.yaml
$ kubectl get pvc
NAME      STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-nfs   Bound    nfs-pv   1Gi        RWO                           3s
$ kubectl get pv
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             
nfs-pv   1Gi        RWO            Retain           Bound    default/pvc-nfs             

#访问模式，storage大小（pvc大小需要小于pv大小），以及 PV 和 PVC 的 storageClassName 字段必须一样，这样才能够进行绑定。

#PersistentVolumeController会不断地循环去查看每一个 PVC，是不是已经处于 Bound（已绑定）状态。如果不是，那它就会遍历所有的、可用的 PV，并尝试将其与未绑定的 PVC 进行绑定，这样，Kubernetes 就可以保证用户提交的每一个 PVC，只要有合适的 PV 出现，它就能够很快进入绑定状态。而所谓将一个 PV 与 PVC 进行“绑定”，其实就是将这个 PV 对象的名字，填在了 PVC 对象的 spec.volumeName 字段上。

# 查看nfs数据目录
$ ls /nfsdata
```

创建Pod挂载pvc

```yaml
$ cat deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-pvc
spec:
  replicas: 1
  selector:        #指定Pod的选择器
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: web
        volumeMounts:                        #挂载容器中的目录到pvc nfs中的目录
        - name: www
          mountPath: /usr/share/nginx/html
      volumes:
      - name: www
        persistentVolumeClaim:              #指定pvc
          claimName: pvc-nfs

$ kubectl create -f deployment.yaml

# 查看容器/usr/share/nginx/html目录
```

###### storageClass实现动态挂载

创建pv及pvc过程是手动，且pv与pvc一一对应，手动创建很繁琐。因此，通过storageClass + provisioner的方式来实现通过PVC自动创建并绑定PV。

<!-- OCR_START -->
- Pod
- 6）用户创建
- 使用PVC的Pod
- 7）使用PVC存储数据
- PVC
- 2）用户创建持久化存
- 储卷声明
- 3）通知系统使
- 用存储类创建PV
- 4）获取存储类
- 1）管理员预先
- 创建存储类
- 型信息
- 8）PVC使用PV存储书籍
- StorageClass
- kubernetes
- 5）基于存储类
- 创建PV
- PV
<!-- OCR_END -->

部署： <https://github.com/kubernetes-retired/external-storage>

provisioner.yaml\

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-client-provisioner
  labels:
    app: nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nfs-client-provisioner
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nfs-client-provisioner
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: quay.io/external_storage/nfs-client-provisioner:latest
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes
          env:
            - name: PROVISIONER_NAME
              value: luffy.com/nfs
            - name: NFS_SERVER
              value: 172.21.51.55
            - name: NFS_PATH  
              value: /data/k8s
      volumes:
        - name: nfs-client-root
          nfs:
            server: 172.21.51.55
            path: /data/k8s
```

rbac.yaml

```yaml
kind: ServiceAccount
apiVersion: v1
metadata:
  name: nfs-client-provisioner
  namespace: nfs-provisioner
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-client-provisioner-runner
  namespace: nfs-provisioner
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: run-nfs-client-provisioner
  namespace: nfs-provisioner
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    namespace: nfs-provisioner
roleRef:
  kind: ClusterRole
  name: nfs-client-provisioner-runner
  apiGroup: rbac.authorization.k8s.io
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: nfs-provisioner
rules:
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: nfs-provisioner
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    # replace with namespace where provisioner is deployed
    namespace: nfs-provisioner
roleRef:
  kind: Role
  name: leader-locking-nfs-client-provisioner
  apiGroup: rbac.authorization.k8s.io
```

storage-class.yaml

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs
provisioner: luffy.com/nfs
```

pvc.yaml

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim2
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
  storageClassName: nfs
```

##### 对接Ceph存储实践

ceph的安装及使用参考 <http://docs.ceph.org.cn/start/intro/>

<!-- OCR_START -->
- APP
- HOST/VM
- CLIENT
- RADOSGW
- RBD
- CEPH FS
- LIBRADOS
- Abucket-based
- A reliable and fully-
- APOSIX-compliant
- A libraryallowing
- REST gateway,
- distributedblock
- distributed file
- appstodirectly
- compatiblewithS3
- device, with a Linux
- system, with a
- accessRADOS
- and Swift
- kernelclientanda
- Linux kernel client
- withsupportfor
- QEMU/KVMdriver
- and supportfor
- C,C++,Java,
- FUSE
- Python, Ruby,
- andPHP
- RADOS
- Areliable,autonomous,distributedobjectstorecomprisedofself-healing,self-managing,
- intelligentstoragenodes
<!-- OCR_END -->

\

```yaml
# CephFS需要使用两个Pool来分别存储数据和元数据
ceph osd pool create cephfs_data 128
ceph osd pool create cephfs_meta 128
ceph osd lspools

# 创建一个CephFS
ceph fs new cephfs cephfs_meta cephfs_data

# 查看
ceph fs ls

#
rados -p cephfs_meta ls
```

  

###### storageClass实现动态挂载

创建pv及pvc过程是手动，且pv与pvc一一对应，手动创建很繁琐。因此，通过storageClass + provisioner的方式来实现通过PVC自动创建并绑定PV。

<!-- OCR_START -->
- Pod
- 6）用户创建
- 使用PVC的Pod
- 7）使用PVC存储数据
- PVC
- 2）用户创建持久化存
- 储卷声明
- 3）通知系统使
- 用存储类创建PV
- 4）获取存储类
- 1）管理员预先
- 创建存储类
- 型信息
- 8）PVC使用PV存储书籍
- StorageClass
- kubernetes
- 5）基于存储类
- 创建PV
- PV
<!-- OCR_END -->

比如，针对cephfs，可以创建如下类型的storageclass：\

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: dynamic-cephfs
provisioner: ceph.com/cephfs
parameters:
    monitors: 121.204.157.52:6789
    adminId: admin
    adminSecretName: ceph-admin-secret
    adminSecretNamespace: "kube-system"
    claimRoot: /volumes/kubernetes
```

NFS，ceph-rbd，cephfs均提供了对应的provisioner

部署cephfs-provisioner

```yaml
$ cat external-storage-cephfs-provisioner.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cephfs-provisioner
  namespace: kube-system
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: cephfs-provisioner
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["create", "get", "delete"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: cephfs-provisioner
subjects:
  - kind: ServiceAccount
    name: cephfs-provisioner
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cephfs-provisioner
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: cephfs-provisioner
  namespace: kube-system
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["create", "get", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: cephfs-provisioner
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: cephfs-provisioner
subjects:
- kind: ServiceAccount
  name: cephfs-provisioner
  namespace: kube-system

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cephfs-provisioner
  namespace: kube-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cephfs-provisioner
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: cephfs-provisioner
    spec:
      containers:
      - name: cephfs-provisioner
        image: "quay.io/external_storage/cephfs-provisioner:latest"
        env:
        - name: PROVISIONER_NAME
          value: ceph.com/cephfs
        imagePullPolicy: IfNotPresent
        command:
        - "/usr/local/bin/cephfs-provisioner"
        args:
        - "-id=cephfs-provisioner-1"
        - "-disable-ceph-namespace-isolation=true"
      serviceAccount: cephfs-provisioner
```

在ceph monitor机器中查看admin账户的key

```yaml
$ ceph auth ls
$ ceph auth get-key client.admin
AQAejeJbowvgMhAAsuloUOvepcj/TXEIoSrd7A==
```

创建secret

```yaml
$ echo -n AQAejeJbowvgMhAAsuloUOvepcj/TXEIoSrd7A==|base64
QVFBZWplSmJvd3ZnTWhBQXN1bG9VT3ZlcGNqL1RYRUlvU3JkN0E9PQ==
$ cat ceph-admin-secret.yaml
apiVersion: v1
data:
  key: QVFBZWplSmJvd3ZnTWhBQXN1bG9VT3ZlcGNqL1RYRUlvU3JkN0E9PQ==
kind: Secret
metadata:
  name: ceph-admin-secret
  namespace: kube-system
type: Opaque
```

创建storageclass

```yaml
$ cat cephfs-storage-class.yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: dynamic-cephfs
provisioner: ceph.com/cephfs
parameters:
    monitors: 36.111.140.31:6789
    adminId: admin
    adminSecretName: ceph-admin-secret
    adminSecretNamespace: "kube-system"
    claimRoot: /volumes/kubernetes
```

###### 动态pvc验证及实现分析

使用流程： 创建pvc，指定storageclass和存储大小，即可实现动态存储。

创建pvc测试自动生成pv\

```yaml
$ cat cephfs-pvc-test.yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: cephfs-claim
spec:
  accessModes:     
    - ReadWriteOnce
  storageClassName: dynamic-cephfs
  resources:
    requests:
      storage: 2Gi

$ kubectl create -f cephfs-pvc-test.yaml

$ kubectl get pv
pvc-2abe427e-7568-442d-939f-2c273695c3db   2Gi        RWO            Delete           Bound      default/cephfs-claim   dynamic-cephfs            1s
```

创建Pod使用pvc挂载cephfs数据盘

```yaml
$ cat test-pvc-cephfs.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    name: nginx-pod
spec:
  containers:
  - name: nginx-pod
    image: nginx:alpine
    ports:
    - name: web
      containerPort: 80
    volumeMounts:
    - name: cephfs
      mountPath: /usr/share/nginx/html
  volumes:
  - name: cephfs
    persistentVolumeClaim:
      claimName: cephfs-claim

$ kubectl create -f test-pvc-cephfs.yaml
```

我们所说的容器的持久化，实际上应该理解为宿主机中volume的持久化，因为Pod是支持销毁重建的，所以只能通过宿主机volume持久化，然后挂载到Pod内部来实现Pod的数据持久化。

宿主机上的volume持久化，因为要支持数据漂移，所以通常是数据存储在分布式存储中，宿主机本地挂载远程存储（NFS，Ceph，OSS），这样即使Pod漂移也不影响数据。

k8s的pod的挂载盘通常的格式为：\

```yaml
/var/lib/kubelet/pods/<Pod的ID>/volumes/kubernetes.io~<Volume类型>/<Volume名字>

```

查看nginx-pod的挂载盘，

```yaml
$ df -TH
/var/lib/kubelet/pods/61ba43c5-d2e9-4274-ac8c-008854e4fa8e/volumes/kubernetes.io~cephfs/pvc-2abe427e-7568-442d-939f-2c273695c3db/

$ findmnt /var/lib/kubelet/pods/61ba43c5-d2e9-4274-ac8c-008854e4fa8e/volumes/kubernetes.io~cephfs/pvc-2abe427e-7568-442d-939f-2c273695c3db/

36.111.140.31:6789:/volumes/kubernetes/kubernetes/kubernetes-dynamic-pvc-ffe3d84d-c433-11ea-b347-6acc3cf3c15f
```

  

#### 使用Helm3管理复杂应用的部署

##### 认识Helm

1. 为什么有helm？
2. Helm是什么？kubernetes的包管理器，“可以将Helm看作Linux系统下的apt-get/yum”。除此以外，Helm还提供了kubernetes上的软件部署，删除，升级，回滚应用的强大功能。
   * 对于应用发布者而言，可以通过Helm打包应用，管理应用依赖关系，管理应用版本并发布应用到软件仓库。
   * 对于使用者而言，使用Helm后不用需要了解Kubernetes的Yaml语法并编写应用部署文件，可以通过Helm下载并在kubernetes上安装需要的应用。
3. Helm的版本
   * helm2

<!-- OCR_START -->
- Helm
- gRPC
- Kube
- Tiller
- Client
- API
- Kubernetes
<!-- OCR_END -->

C/S架构，helm通过Tiller与k8s交互
   * helm3

<!-- OCR_START -->
- HelmClient
- Chart
- (helm)
- Repository
- Helmchart
- Kubernetes
- APIServer
- KubernetesCluster
<!-- OCR_END -->

     * 从安全性和易用性方面考虑，移除了Tiller服务端，helm3直接使用kubeconfig文件鉴权访问APIServer服务器
     * 由二路合并升级成为三路合并补丁策略（ 旧的配置，线上状态，新的配置 ）

```yaml
helm install very_important_app ./very_important_app

```

这个应用的副本数量设置为 3 。现在，如果有人不小心执行了 kubectl edit 或：

```yaml
kubectl scale -replicas=0 deployment/very_important_app

```

然后，团队中的某个人发现 very_important_app 莫名其妙宕机了，尝试执行命令：

```yaml
helm rollback very_important_app

```

```
    * <font style="color:rgb(51, 51, 51);">在 Helm 2 中，这个操作将比较旧的配置与新的配置，然后生成一个更新补丁。由于，误操作的人仅修改了应用的线上状态（旧的配置并未更新）。Helm 在回滚时，什么事情也不会做。因为旧的配置与新的配置没有差别（都是 3 个副本）。然后，Helm 不执行回滚，副本数继续保持为 0</font>
    * <font style="color:rgb(51, 51, 51);">移除了helm serve本地repo仓库</font>
    * <font style="color:rgb(51, 51, 51);">创建应用时必须指定名字（或者--generate-name随机生成）</font>
```

1. Helm的重要概念
   * chart，应用的信息集合，包括各种对象的配置模板、参数定义、依赖关系、文档说明等
   * Repoistory，chart仓库，存储chart的地方，并且提供了一个该 Repository 的 Chart 包的清单文件以供查询。Helm 可以同时管理多个不同的 Repository。
   * release， 当 chart 被安装到 kubernetes 集群，就生成了一个 release ， 是 chart 的运行实例，代表了一个正在运行的应用

helm 是包管理工具，包就是指 chart，helm 能够：

* 从零创建chart
* 与仓库交互，拉取、保存、更新 chart
* 在kubernetes集群中安装、卸载 release
* 更新、回滚、测试 release

##### 安装与快速入门实践

下载最新的稳定版本：<https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz>

更多版本可以参考： <https://github.com/helm/helm/releases>

```yaml
# k8s-master节点
$ wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
$ tar -zxf helm-v3.2.4-linux-amd64.tar.gz

$ cp linux-amd64/helm /usr/local/bin/

# 验证安装
$ helm version
version.BuildInfo{Version:"v3.2.4", GitCommit:"0ad800ef43d3b826f31a5ad8dfbb4fe05d143688", GitTreeState:"clean", GoVersion:"go1.13.12"}
$ helm env

# 添加仓库
$ helm repo add stable http://mirror.azure.cn/kubernetes/charts/
# 同步最新charts信息到本地
$ helm repo update
```

  
快速入门实践：

示例一：使用helm安装mysql应用\

```yaml
# helm 搜索chart包
$ helm search repo mysql

# 从仓库安装
$ helm install mysql stable/mysql

$ helm ls
$ kubectl get all 

# 从chart仓库中把chart包下载到本地
$ helm pull stable/mysql
$ tree mysql
```

示例二：新建nginx的chart并安装\

```yaml
$ helm create nginx

# 从本地安装
$ helm install nginx ./nginx

# 安装到别的命名空间luffy
$ helm -n luffy install ./nginx

# 查看
$ helm ls
$ helm -n luffy ls

#
$ kubectl get all 
$ kubectl -n luffy get all
```

  

##### Chart的模板语法及开发

###### nginx的chart实现分析

格式：\

```yaml
$ tree nginx/
nginx/
├── charts                        # 存放子chart
├── Chart.yaml                    # 该chart的全局定义信息
├── templates                    # chart运行所需的资源清单模板，用于和values做渲染
│   ├── deployment.yaml
│   ├── _helpers.tpl            # 定义全局的命名模板，方便在其他模板中引入使用
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt                # helm安装完成后终端的提示信息
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml                    # 模板使用的默认值信息
```

很明显，资源清单都在templates中，数据来源于values.yaml，安装的过程就是将模板与数据融合成k8s可识别的资源清单，然后部署到k8s环境中。

分析模板文件的实现：

* 引用命名模板并传递作用域

```yaml
{% raw %}
{{ include "nginx.fullname" . }}
include从_helpers.tpl中引用命名模板，并传递顶级作用域.
{% raw %}
- 内置对象
```

.Values

.Release.Name

{% raw %}

* Release：该对象描述了 release 本身的相关信息，它内部有几个对象：
  * Release.Name：release 名称
  * Release.Namespace：release 安装到的命名空间
  * Release.IsUpgrade：如果当前操作是升级或回滚，则该值为 true
  * Release.IsInstall：如果当前操作是安装，则将其设置为 true
  * Release.Revision：release 的 revision 版本号，在安装的时候，值为1，每次升级或回滚都会增加
  * Reelase.Service：渲染当前模板的服务，在 Helm 上，实际上该值始终为 Helm
* Values：从 values.yaml 文件和用户提供的 values 文件传递到模板的 Values 值
* Chart：获取 Chart.yaml 文件的内容，该文件中的任何数据都可以访问，例如 {{ .Chart.Name }}-{{ .Chart.Version}} 可以渲染成 mychart-0.1.0 {% endraw %}
  * 模板定义

```yaml
{{- define "nginx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}
```

* {{- 去掉左边的空格及换行，-}} 去掉右侧的空格及换行
* 示例

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
  drink: {{ .Values.favorite.drink | default "tea" | quote }}
  food: {{ .Values.favorite.food | upper | quote }}
  {{ if eq .Values.favorite.drink "coffee" }}
  mug: true
  {{ end }}
```

渲染完后是：

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mychart-1575971172-configmap
data:
  myvalue: "Hello World"
  drink: "coffee"
  food: "PIZZA"

  mug: true
```

管道及方法

* trunc表示字符串截取，63作为参数传递给trunc方法，trimSuffix表示去掉-后缀

```yaml
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}

```

* nindent表示前面的空格数

```yaml
  selector:
    matchLabels:
      {{- include "nginx.selectorLabels" . | nindent 6 }}
```

lower表示将内容小写，quote表示用双引号引起来

```yaml
value: {{ include "mytpl" . | lower | quote }}

```

* 条件判断语句每个if对应一个end

  

```yaml
{{- if .Values.fullnameOverride }}
...
{{- else }}
...
{{- end }}
```

通常用来根据values.yaml中定义的开关来控制模板中的显示：\

```yaml
{{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
{{- end }}
```

* 定义变量，模板中可以通过变量名字去引用

```yaml
{{- $name := default .Chart.Name .Values.nameOverride }}

```

* 遍历values的数据

```yaml
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
```

toYaml处理值中的转义及特殊字符， "kubernetes.io/role"=master ， name="value1,value2" 类似的情况

* default设置默认值

```yaml
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"

```

Helm template

hpa.yaml

```yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "nginx.fullname" . }}
  labels:
    {{- include "nginx.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "nginx.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
  {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
  {{- end }}
  {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        targetAverageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
  {{- end }}
{{- end }}
```

  

###### 创建应用的时候赋值

* set的方式

```yaml
# 改变副本数和resource值
$ helm install nginx-2 ./nginx --set replicaCount=2 --set resources.limits.cpu=200m --set resources.limits.memory=256Mi
```

value文件的方式

```yaml
$ cat nginx-values.yaml
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 80
ingress:
  enabled: true
  hosts:
    - host: chart-example.luffy.com
      paths:
      - /

$ helm install -f nginx-values.yaml nginx-3 ./nginx
```

更多语法参考：

<https://helm.sh/docs/topics/charts/>

部署mysql失败的问题

##### 实战：使用Helm部署Harbor镜像及chart仓库

###### harbor踩坑部署

架构 <https://github.com/goharbor/harbor/wiki/Architecture-Overview-of-Harbor>

<!-- OCR_START -->
- Consumers
- Web Portal
- kubelet
- Helm
- docker/notary client
- ORAS Oras(OCI compatible clients)
- Scan Providers
- Proxy (API Routing)
- CentOs/Clair
- IdentityProviders
- Core
- Aqua/Trivy
- AD/LDAP
- Middleware
- SCANI
- Authentication & Authorizations
- API Server
- API Handlers
- anchorAnchore/Engine
- OIDC
- DoSec
- API Controllers
- Traffic
- Replicated Registry
- Namespace
- Chart
- Notification
- OCI Artifact Manager
- Configuration
- Quota
- Signature
- Retention
- Replication
- Proxy(/v2)
- Providers
- Manager
- Controller
- Scan Manager
- (V2 Chart)
- (webhook)
- Distribution
- Registry Driver
- DockerHub
- ARTI
- Huawei SWR
- Chart Museum
- Notary
- Docker Distribution
- GC Controller
- (3rd party)
- Log Collector
- JobService
- Amazon ECR
- Google GCR
- Data Access Layer
- k-v storage
- Local/RemoteStorage
- Azure ACR
- (block,file,object)
- SQL Database
- Ali ACR
- Quay
- Artifactory
- Name
- Gitlab
<!-- OCR_END -->

* Core，核心组件
  * API Server，接收处理用户请求
  * Config Manager ：所有系统的配置，比如认证、邮件、证书配置等
  * Project Manager：项目管理
  * Quota Manager ：配额管理
  * Chart Controller：chart管理
  * Replication Controller ：镜像副本控制器，可以与不同类型的仓库实现镜像同步
    * Distribution (docker registry)
    * Docker Hub
    * ...
  * Scan Manager ：扫描管理，引入第三方组件，进行镜像安全扫描
  * Registry Driver ：镜像仓库驱动，目前使用docker registry
* Job Service，执行异步任务，如同步镜像信息
* Log Collector，统一日志收集器，收集各模块日志
* GC Controller
* Chart Museum，chart仓库服务，第三方
* Docker Registry，镜像仓库服务
* kv-storage，redis缓存服务，job service使用，存储job metadata
* local/remote storage，存储服务，比较镜像存储
* SQL Database，postgresl，存储用户、项目等元数据

通常用作企业级镜像仓库服务，实际功能强大很多。

组件众多，因此使用helm部署

```yaml
# 添加harbor chart仓库
$ helm repo add harbor https://helm.goharbor.io

# 搜索harbor的chart
$ helm search repo harbor

# 不知道如何部署，因此拉到本地
$ helm pull harbor/harbor --version 1.4.1
```

创建pvc

```yaml
$ kubectl create namespace harbor
$ cat harbor-pvc.yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: harbor-pvc
  namespace: harbor
spec:
  accessModes:     
    - ReadWriteOnce
  storageClassName: dynamic-cephfs
  resources:
    requests:
      storage: 20Gi
```

修改harbor配置：

* 开启ingress访问
* externalURL，web访问入口，和ingress的域名相同
* 持久化，使用PVC对接的cephfs
* harborAdminPassword: "Harbor12345"，管理员默认账户 admin/Harbor12345
* 开启chartmuseum
* clair和trivy漏洞扫描组件，暂不启用

helm创建：\

```yaml
# 使用本地chart安装
$ helm install harbor ./harbor -n harbor
```

踩坑一：redis持久化数据目录权限导致无法登录

redis数据目录，/var/lib/redis，需要设置redis的用户及用户组权限\

```yaml
      initContainers:
      - name: "change-permission-of-directory"
        image: {{ .Values.redis.internal.image.repository }}:{{ .Values.redis.internal.image.tag }}
        imagePullPolicy: {{ .Values.imagePullPolicy }}
        command: ["/bin/sh"]
        args: ["-c", "chown -R 999:999 /var/lib/redis"]
        securityContext:
          runAsUser: 0
        volumeMounts:
        - name: data
          mountPath: /var/lib/redis
          subPath: {{ $redis.subPath }}
```

踩坑二：registry组件的镜像存储目录权限导致镜像推送失败

registry的镜像存储目录，需要设置registry用户的用户及用户组，不然镜像推送失败\

```yaml
      initContainers:
      - name: "change-permission-of-directory"
        securityContext:
          runAsUser: 0
        image: {{ .Values.registry.registry.image.repository }}:{{ .Values.registry.registry.image.tag }}
        imagePullPolicy: {{ .Values.imagePullPolicy }}
        command: ["/bin/sh"]
        args: ["-c", "chown -R 10000:10000 {{ .Values.persistence.imageChartStorage.filesystem.rootdirectory }}"]
        volumeMounts:
        - name: registry-data
          mountPath: {{ .Values.persistence.imageChartStorage.filesystem.rootdirectory }}
          subPath: {{ .Values.persistence.persistentVolumeClaim.registry.subPath }}
```

踩坑三：chartmuseum存储目录权限，导致chart推送失败

```yaml
      initContainers:
      - name: "change-permission-of-directory"
        image: {{ .Values.chartmuseum.image.repository }}:{{ .Values.chartmuseum.image.tag }}
        imagePullPolicy: {{ .Values.imagePullPolicy }}
        command: ["/bin/sh"]
        args: ["-c", "chown -R 10000:10000 /chart_storage"]
        securityContext:
          runAsUser: 0
        volumeMounts:
        - name: chartmuseum-data
          mountPath: /chart_storage
          subPath: {{ .Values.persistence.persistentVolumeClaim.chartmuseum.subPath }}
```

更新内容后，执行更新release\

```yaml
$ helm upgrade harbor -n harbor ./

```

###### 推送镜像到Harbor仓库

配置hosts及docker非安全仓库：\

```yaml
$ cat /etc/hosts
...
192.168.136.10 k8s-master core.harbor.domain
...

$ cat /etc/docker/daemon.json
{                                            
  "insecure-registries": [                   
    "192.168.136.10:5000",                   
    "core.harbor.domain"                     
  ],                                         
  "registry-mirrors" : [                     
    "https://8xpk5wnt.mirror.aliyuncs.com"   
  ]                                          
}                           

#
$ systemctl restart docker

# 使用账户密码登录admin/Harbor12345
$ docker login core.harbor.domain

$ docker tag nginx:alpine core.harbor.domain/library/nginx:alpine
$ docker push core.harbor.domain/library/nginx:alpine
```

###### 推送chart到Harbor仓库

helm3默认没有安装helm push插件，需要手动安装。插件地址 <https://github.com/chartmuseum/helm-push>

安装插件：

```yaml
$ helm plugin install https://github.com/chartmuseum/helm-push

```

离线安装：

```yaml
$ helm plugin install ./helm-push

```

添加repo

```yaml
$ helm repo add myharbor https://core.harbor.domain/chartrepo/library 
# x509错误

# 添加证书信任，根证书为配置给ingress使用的证书
$ kubectl get secret harbor-harbor-ingress -n harbor -o jsonpath="{.data.ca\.crt}" | base64 -d >harbor.ca.crt

$ cp harbor.ca.crt /etc/pki/ca-trust/source/anchors
$ update-ca-trust enable; update-ca-trust extract

# 再次添加
$ helm repo add myharbor https://core.harbor.domain/chartrepo/library --ca-file=harbor.ca.crt

$ helm repo ls
```

推送chart到仓库：

```yaml
$ helm push harbor myharbor --ca-file=harbor.ca.crt -u admin -p Harbor12345

```

查看harbor仓库的chart

#### 课程小结

使用k8s的进阶内容。

1. 学习k8s在etcd中数据的存储，掌握etcd的基本操作命令
2. 理解k8s调度的过程，预选及优先。影响调度策略的设置
<!-- OCR_START -->
- AllClusterNodes
- Node 1
- Node 2
- Node3
- Node 4
- Node5
- Node60
- PredicatesPolicies
- Nodes
- "kind" : "Policy",
- <=16worker
- "apiVersion" :"v1",
- PredicatedNodes
- "predicates" : [
- {"name” : "PodFitsPorts"},
- {("name" : "PodFitsResources"),
- {"name" : "NoDiskConflict"),
- knock out
- {"name":"NoVolumeZoneConflict"},
- {"name" : "MatchNodeSelector"),
- {"name" : "HostName"}
- "priorities" : [
- {"name”: "LeastRequestedPriority","weight": 1},
- {"name" : "BalancedResourceAllocation", "weight" : 1},
- {"name”: "ServiceSpreadingPriority", "weight": 1},
- {"name”: "EqualPriority","weight": 1}
- Priorities Policies
- Prioritied Nodes
- scoreNode1:5
- scoreNode2:6
- scoreNode4:7
- scoreNode60:8
- thebestnode
<!-- OCR_END -->

3. Flannel网络的原理学习，了解网络的流向，帮助定位问题
<!-- OCR_START -->
- k8s-node
- POD
- Container 01
- Container 02
- --net=container:id
- Pause-amd64 Container (Network NameSpace)
- veth-pair
- Bridge - cni0
- Routing
- Flannel.1
- -VXLAN Tunnel-
- ens33
- 4
<!-- OCR_END -->

4. 认证与授权，掌握kubectl、kubelet、rbac及二次开发如何调度API

<!-- OCR_START -->
- user1
- user2
- user3
- 名称空间B
- 名称空间C
- Rolebinding
- Clusterrole
- binding
- role
- Cluster
- 名称空间A
- 集群A
- 集群B
- 集群C
- K8s集群
- Designed by Smbands
<!-- OCR_END -->

5. 利用HPA进行业务动态扩缩容，通过metrics-server了解整个k8s的监控体系

<!-- OCR_START -->
- Metrics
- HorizontalPodAutoscaler
- aggregator
- server
- Deployment
- Prometheus
- cAdvisor
- adapter
- kubelet
- ReplicaSet
- Pod
- s://blog.csdn.net/fly910905
<!-- OCR_END -->

6. PV + PVC

<!-- OCR_START -->
- Pod
- 6）用户创建
- 使用PVC的Pod
- 7）使用PVC存储数据
- PVC
- 2）用户创建持久化存
- 储卷声明
- 3）通知系统使
- 用存储类创建PV
- 4）获取存储类
- 1）管理员预先
- 创建存储类
- 型信息
- 8）PVC使用PV存储书籍
- StorageClass
- kubernetes
- 5）基于存储类
- 创建PV
- PV
<!-- OCR_END -->

7. Helm

<!-- OCR_START -->
- HelmClient
- Chart
- (helm)
- Repository
- Helmchart
- Kubernetes
- APIServer
- KubernetesCluster
<!-- OCR_END -->

{% endraw %}

# 04_Kubernetes集群的日志及监控

#### k8s日志收集架构

<https://kubernetes.io/docs/concepts/cluster-administration/logging/>

总体分为三种方式：

* 使用在每个节点上运行的节点级日志记录代理。
* 在应用程序的 pod 中，包含专门记录日志的 sidecar 容器。
* 将日志直接从应用程序中推送到日志记录后端。

##### 使用节点级日志代理

<!-- OCR_START -->
- my-pod
- app-container
- Logging
- Backend
- stdout
- stderr
- log-file.log
- logging-agent-pod
- logging-agent
- logrotate
<!-- OCR_END -->

容器日志驱动：

<https://docs.docker.com/config/containers/logging/configure/>

查看当前的docker主机的驱动：

```yaml
$ docker info --format '{{.LoggingDriver}}'

```

json-file格式，docker会默认将标准和错误输出保存为宿主机的文件，路径为：

/var/lib/docker/containers/<container-id>/<container-id>-json.log

并且可以设置日志轮转：

```yaml
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "production_status",
    "env": "os,customer"
  }
}
```

优势：

* 部署方便，使用DaemonSet类型控制器来部署agent即可
* 对业务应用的影响最小，没有侵入性

劣势:

* 只能收集标准和错误输出，对于容器内的文件日志，暂时收集不到

##### 使用 sidecar 容器和日志代理

###### 方式一：sidecar 容器将应用程序日志传送到自己的标准输出。

* 思路：在pod中启动一个sidecar容器，把容器内的日志文件吐到标准输出，由宿主机中的日志收集agent进行采集。

<!-- OCR_START -->
- my-pod
- app-container
- Logging
- Backend
- streaming
- container
- stdout
- stderf
- logging-agent-pod
- log-file.log
- logging-agent
<!-- OCR_END -->

```yaml
$ cat count-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: counter
spec:
  containers:
  - name: count
    image: busybox
    args:
    - /bin/sh
    - -c
    - >
      i=0;
      while true;
      do
        echo "$i: $(date)" >> /var/log/1.log;
        echo "$(date) INFO $i" >> /var/log/2.log;
        i=$((i+1));
        sleep 1;
      done
    volumeMounts:
    - name: varlog
      mountPath: /var/log
  - name: count-log-1
    image: busybox
    args: [/bin/sh, -c, 'tail -n+1 -f /var/log/1.log']
    volumeMounts:
    - name: varlog
      mountPath: /var/log
  - name: count-log-2
    image: busybox
    args: [/bin/sh, -c, 'tail -n+1 -f /var/log/2.log']
    volumeMounts:
    - name: varlog
      mountPath: /var/log
  volumes:
  - name: varlog
    emptyDir: {}

$ kubectl create -f counter-pod.yaml
$ kubectl logs -f counter -c count-log-1
```

  

* 优势：劣势：
  * 可以实现容器内部日志收集
  * 对业务应用的侵入性不大
  * 每个业务pod都需要做一次改造
  * 增加了一次日志的写入，对磁盘使用率有一定影响
* 

<!-- OCR_START -->
- my-pod
- Logging
- Backend
- app-container
- logging-agent
<!-- OCR_END -->

思路：直接在业务Pod中使用sidecar的方式启动一个日志收集的组件（比如fluentd），这样日志收集可以将容器内的日志当成本地文件来进行收取。优势：不用往宿主机存储日志，本地日志完全可以收集劣势：每个业务应用额外启动一个日志agent，带来额外的资源损耗

###### 方式二：sidecar 容器运行一个日志代理，配置该日志代理以便从应用容器收集日志。

##### 从应用中直接暴露日志目录

<!-- OCR_START -->
- my-pod
- Logging
- Backend
- app-container
<!-- OCR_END -->

##### 企业日志方案选型

目前来讲，最建议的是采用节点级的日志代理。

方案一：自研方案，实现一个自研的日志收集agent，大致思路：

* 针对容器的标准输出及错误输出，使用常规的方式，监听宿主机中的容器输出路径即可
* 针对容器内部的日志文件
  * 在容器内配置统一的环境变量，比如LOG_COLLECT_FILES，指定好容器内待收集的日志目录及文件
  * agent启动的时候挂载docker.sock文件及磁盘的根路径
  * 监听docker的容器新建、删除事件，通过docker的api，查出容器的存储、环境变量、k8s属性等信息
  * 配置了LOG_COLLECT_FILES环境变量的容器，根据env中的日志路径找到主机中对应的文件路径，然后生成收集的配置文件
  * agent与开源日志收集工具（Fluentd或者filebeat等）配合，agent负责下发配置到收集工具中并对进程做reload

方案二：日志使用开源的Agent进行收集（EFK方案），适用范围广，可以满足绝大多数日志收集、展示的需求。

#### 实践使用EFK实现业务日志收集

##### EFK架构工作流程

<!-- OCR_START -->
- Kubernetes cluster
- Node
- Microservice
- fluentd
- kibana
- Docker logs
- elasticsearch
<!-- OCR_END -->

* Elasticsearch一个开源的分布式、Restful 风格的搜索和数据分析引擎，它的底层是开源库Apache Lucene。它可以被下面这样准确地形容：
  * 一个分布式的实时文档存储，每个字段可以被索引与搜索；
  * 一个分布式实时分析搜索引擎；
  * 能胜任上百个服务节点的扩展，并支持 PB 级别的结构化或者非结构化数据。
* KibanaKibana是一个开源的分析和可视化平台，设计用于和Elasticsearch一起工作。可以通过Kibana来搜索，查看，并和存储在Elasticsearch索引中的数据进行交互。也可以轻松地执行高级数据分析，并且以各种图标、表格和地图的形式可视化数据。
* [Fluentd](https://docs.fluentd.org/)一个针对日志的收集、处理、转发系统。通过丰富的插件系统，可以收集来自于各种系统或应用的日志，转化为用户指定的格式后，转发到用户所指定的日志存储系统之中。

<!-- OCR_START -->
- Sources
- FluentdRulebasedRouting
- Destinations
- Logfiles
- -LogData-
- s1
- d1
- ElasticSearch
- RESTendpoint
- HTTPData-
- S2
- fluehtd
- d2
- ObjectStore
- -EventData-
- s3
<!-- OCR_END -->

Fluentd 通过一组给定的数据源抓取日志数据，处理后（转换成结构化的数据格式）将它们转发给其他服务，比如 Elasticsearch、对象存储、kafka等等。Fluentd 支持超过300个日志存储和分析服务，所以在这方面是非常灵活的。主要运行步骤如下
  1. 首先 Fluentd 从多个日志源获取数据
  2. 结构化并且标记这些数据
  3. 然后根据匹配的标签将数据发送到多个目标服务

##### Fluentd精讲

###### Fluentd架构

<!-- OCR_START -->
- Access logs
- Alerting
- rsync
- mongoDB
- Apache
- Nagios
- server
- App logs
- sckipt to
- Analysis
- LogFiles
- Adat
- Frontend
- Backend
- weel
- hadoop
- MySQL
- HOFS
- fluentd
- System logs
- syslog-ng
- elasticsearch.
- syslogd
- Archiving
- filter/buffer/routing
- script to
- amazon
- Databases
- AmazonS3
- parse data
- rorjob-for
- webservices"
- After Fluentd
- Before Fluentd
<!-- OCR_END -->

为什么推荐使用fluentd作为k8s体系的日志收集工具？

* 云原生：<https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch>
* 将日志文件JSON化

<!-- OCR_START -->
127.0.0.1 - - [05/Feb/2012:17:11:55 +0000]
"GET / HTTP/1.i" 200 140 "_" "Mozilla/5.0...
"host":"127.0.0.1"
"user":"_"
"method":"GET"
"agent":"Mozilla/5.0 (windows.
<!-- OCR_END -->

* 可插拔架构设计
<!-- OCR_START -->
- Pluggable
- Input
- >rewrite
- Engine
- 4
- Buffer
- >Forward
- >HTTP
- >File
- >File tail
- >Memory
- >dstat
- >MongoDB
- 7
<!-- OCR_END -->

* 极小的资源占用基于C和Ruby语言， 30-40MB，13,000 events/second/core
<!-- OCR_START -->
- SECOND EDITION
- Ruby
- THE
- PROGRAMMING
- LANGUAGE
- BRIAN W KERNIGHAN
- DENNIS M.RITCHIE
<!-- OCR_END -->

* 极强的可靠性
  * 基于内存和本地文件的缓存
  * 强大的故障转移

###### fluentd事件流的生命周期及指令配置

<https://docs.fluentd.org/v/0.12/quickstart/life-of-a-fluentd-event>

```yaml
Input -> filter 1 -> ... -> filter N -> Buffer -> Output

```

启动命令

```yaml
$ fluentd -c fluent.conf

```

指令介绍：

* [source](https://docs.fluentd.org/v/0.12/input) ，数据源，对应Input 通过使用 source 指令，来选择和配置所需的输入插件来启用 Fluentd 输入源， source 把事件提交到 fluentd 的路由引擎中。使用type来区分不同类型的数据源。如下配置可以监听指定文件的追加输入：

```yaml
<source>
  @type tail
  path /var/log/httpd-access.log
  pos_file /var/log/td-agent/httpd-access.log.pos
  tag myapp.access
  format apache2
</source>
```

* filter，Event processing pipeline（事件处理流）

filter 可以串联成 pipeline，对数据进行串行处理，最终再交给 match 输出。 如下可以对事件内容进行处理：\

```yaml
<source>
  @type http
  port 9880
</source>

<filter myapp.access>
  @type record_transformer
  <record>
    host_param “#{Socket.gethostname}”
  </record>
</filter>
```

filter 获取数据后，调用内置的 @type record_transformer 插件，在事件的 record 里插入了新的字段 host_param，然后再交给 match 输出。

* label指令

可以在 source 里指定 @label，这个 source 所触发的事件就会被发送给指定的 label 所包含的任务，而不会被后续的其他任务获取到。

```yaml
<source>
  @type forward
</source>

<source>
### 这个任务指定了 label 为 @SYSTEM
### 会被发送给 <label @SYSTEM>
### 而不会被发送给下面紧跟的 filter 和 match
  @type tail
  @label @SYSTEM
  path /var/log/httpd-access.log
  pos_file /var/log/td-agent/httpd-access.log.pos
  tag myapp.access
  format apache2
</source>

<filter access.**>
  @type record_transformer
  <record>
  # …
  </record>
</filter>

<match **>
  @type elasticsearch
  # …
</match>

<label @SYSTEM>
  ### 将会接收到上面 @type tail 的 source event
  <filter var.log.middleware.**>
    @type grep
    # …
  </filter>

  <match **>
    @type s3
    # …
  </match>
</label>
```

* match，匹配输出

查找匹配 “tags” 的事件，并处理它们。match 命令的最常见用法是将事件输出到其他系统（因此，与 match 命令对应的插件称为 “输出插件”）

```yaml
<source>
  @type http
  port 9880
</source>

<filter myapp.access>
  @type record_transformer
  <record>
    host_param “#{Socket.gethostname}”
  </record>
</filter>

<match myapp.access>
  @type file
  path /var/log/fluent/access
</match>
```

事件的结构：

time：事件的处理时间

tag：事件的来源，在fluentd.conf中配置

record：真实的日志内容，json对象

比如，下面这条原始日志：

```yaml
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777

```

经过fluentd 引擎处理完后的样子可能是：

```yaml
2020-07-16 08:40:35 +0000 apache.access: {"user":"-","method":"GET","code":200,"size":777,"host":"192.168.0.1","path":"/"}

```

###### fluentd的buffer事件缓冲模型

```yaml
Input -> filter 1 -> ... -> filter N -> Buffer -> Output

```

<!-- OCR_START -->
- Input/Filter
- Buffer
- time
- emit
- key:foo
- tag
- Router
- record
- enqueue:exceedflush_interval
- chunk
- orbuffer_chunk_limit
- Queue
- Key pattern:
- key:bar
- -BufferedOutput
- emptystringorspecifiedkey
- -ObjectBufferedOutput
- -TimeSlicedOutput
- time slice
- key:baz
- buffer_chunk_limit
- buffer_queue_limit
- Output'swrite
<!-- OCR_END -->

因为每个事件数据量通常很小，考虑数据传输效率、稳定性等方面的原因，所以基本不会每条事件处理完后都会立马写入到output端，因此fluentd建立了缓冲模型，模型中主要有两个概念：

* buffer_chunk：事件缓冲块，用来存储本地已经处理完待发送至目的端的事件，可以设置每个块的大小。
* buffer_queue：存储chunk的队列，可以设置长度

可以设置的参数，主要有：

* buffer_type，缓冲类型，可以设置file或者memory
* buffer_chunk_limit，每个chunk块的大小，默认8MB
* buffer_queue_limit ，chunk块队列的最大长度，默认256
* flush_interval ，flush一个chunk的时间间隔
* retry_limit ，chunk块发送失败重试次数，默认17次，之后就丢弃该chunk数据
* retry_wait ，重试发送chunk数据的时间间隔，默认1s，第2次失败再发送的话，间隔2s，下次4秒，以此类推

大致的过程为：

随着fluentd事件的不断生成并写入chunk，缓存块持变大，当缓存块满足buffer_chunk_limit大小或者新的缓存块诞生超过flush_interval时间间隔后，会推入缓存queue队列尾部，该队列大小由buffer_queue_limit决定。

每次有新的chunk入列，位于队列最前部的chunk块会立即写入配置的存储后端，比如配置的是kafka，则立即把数据推入kafka中。

比较理想的情况是每次有新的缓存块进入缓存队列，则立马会被写入到后端，同时，新缓存块也持续入列，但是入列的速度不会快于出列的速度，这样基本上缓存队列处于空的状态，队列中最多只有一个缓存块。

但是实际情况考虑网络等因素，往往缓存块被写入后端存储的时候会出现延迟或者写入失败的情况，当缓存块写入后端失败时，该缓存块还会留在队列中，等retry_wait时间后重试发送，当retry的次数达到retry_limit后，该缓存块被销毁（数据被丢弃）。

此时缓存队列持续有新的缓存块进来，如果队列中存在很多未及时写入到后端存储的缓存块的话，当队列长度达到buffer_queue_limit大小，则新的事件被拒绝，fluentd报错，error_class=Fluent::Plugin::Buffer::BufferOverflowError error="buffer space has too many data"。

还有一种情况是网络传输缓慢的情况，若每3秒钟会产生一个新块，但是写入到后端时间却达到了30s钟，队列长度为100，那么每个块出列的时间内，又有新的10个块进来，那么队列很快就会被占满，导致异常出现。

###### 实践一：实现业务应用日志的收集及字段解析

目标：收集容器内的nginx应用的access.log日志，并解析日志字段为JSON格式，原始日志的格式为：\

```yaml
$ tail -f access.log
...
53.49.146.149 1561620585.973 0.005 502 [27/Jun/2019:15:29:45 +0800] 178.73.215.171 33337 GET https
```

收集并处理成：

```yaml
{
    "serverIp": "53.49.146.149",
    "timestamp": "1561620585.973",
    "respondTime": "0.005",
    "httpCode": "502",
    "eventTime": "27/Jun/2019:15:29:45 +0800",
    "clientIp": "178.73.215.171",
    "clientPort": "33337",
    "method": "GET",
    "protocol": "https"
}
```

思路：

* 配置fluent.conf
  * 使用@tail插件通过监听access.log文件
  * 用filter实现对nginx日志格式解析
* 启动fluentd服务
* 手动追加内容至access.log文件
* 观察本地输出内容是否符合预期

fluent.conf\

```yaml
<source>
    @type tail
    @label @nginx_access
    path /fluentd/access.log
    pos_file /fluentd/nginx_access.posg
    tag nginx_access
    format none
    @log_level trace
</source>
<label @nginx_access>
   <filter  nginx_access>
       @type parser
       key_name message
       format  /(?<serverIp>[^ ]*) (?<timestamp>[^ ]*) (?<respondTime>[^ ]*) (?<httpCode>[^ ]*) \[(?<eventTime>[^\]]*)\] (?<clientIp>[^ ]*) (?<clientPort>[^ ]*) (?<method>[^ ]*) (?<protocol>[^ ]*)/
   </filter>
   <match  nginx_access>
     @type stdout
   </match>
</label>
```

启动服务，追加文件内容：\

```yaml
$ docker run -u root --rm -ti 172.21.51.67:5000/fluentd_elasticsearch/fluentd:v2.5.2 sh
/ # cd /fluentd/
/ # touch access.log
/ # fluentd -c /fluentd/etc/fluent.conf
/ # echo '53.49.146.149 1561620585.973 0.005 502 [27/Jun/2019:15:29:45 +0800] 178.73.215.171 33337 GET https' >>/fluentd/access.log
```

使用该网站进行正则校验： [http://fluentular.herokuapp.com](http://fluentular.herokuapp.com/)

###### 实践二：使用ruby实现日志字段的转换及自定义处理

```yaml
<source>
    @type tail
    @label @nginx_access
    path /fluentd/access.log
    pos_file /fluentd/nginx_access.posg
    tag nginx_access
    format none
    @log_level trace
</source>
<label @nginx_access>
   <filter  nginx_access>
       @type parser
       key_name message
       format  /(?<serverIp>[^ ]*) (?<timestamp>[^ ]*) (?<respondTime>[^ ]*) (?<httpCode>[^ ]*) \[(?<eventTime>[^\]]*)\] (?<clientIp>[^ ]*) (?<clientPort>[^ ]*) (?<method>[^ ]*) (?<protocol>[^ ]*)/
   </filter>
   <filter  nginx_access>   
       @type record_transformer
       enable_ruby
       <record>
        host_name "#{Socket.gethostname}"
        my_key  "my_val"
        tls ${record["protocol"].index("https") ? "true" : "false"}
       </record>
   </filter>
   <match  nginx_access>
     @type stdout
   </match>
</label>
```

##### ConfigMap的配置文件挂载使用场景

开始之前，我们先来回顾一下，configmap的常用的挂载场景。

###### 场景一：单文件挂载到空目录

假如业务应用有一个配置文件，名为 application-1.conf，如果想将此配置挂载到pod的/etc/application/目录中。

application-1.conf的内容为：

```yaml
$ cat application-1.conf
name: "application"
platform: "linux"
purpose: "demo"
company: "luffy"
version: "v2.1.0"
```

该配置文件在k8s中可以通过configmap来管理，通常我们有如下两种方式来管理配置文件：

* 通过kubectl命令行来生成configmap

```yaml
# 通过文件直接创建
$ kubectl -n default create configmap application-config --from-file=application-1.conf

# 会生成配置文件，查看内容，configmap的key为文件名字
$ kubectl -n default get cm application-config -oyaml
```

* 通过yaml文件直接创建

```yaml
$ cat application-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: application-config
  namespace: default
data:
  application-1.conf: |
    name: "application"
    platform: "linux"
    purpose: "demo"
    company: "luffy"
    version: "v2.1.0"

# 创建configmap
$ kubectl create -f application-config.yaml
```

准备一个demo-deployment.yaml文件，挂载上述configmap到/etc/application/中

```yaml
$ cat demo-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  namespace: default
spec:
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      volumes:
      - configMap:
          name: application-config
        name: config
      containers:
      - name: nginx
        image: nginx:alpine
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - mountPath: "/etc/application"
          name: config
```

创建并查看：

```yaml
$ kubectl create -f demo-deployment.yaml

```

修改configmap文件的内容，观察pod中是否自动感知变化：

```yaml
$ kubectl edit cm application-config

```

整个configmap文件直接挂载到pod中，若configmap变化，pod会自动感知并拉取到pod内部。

但是pod内的进程不会自动重启，所以很多服务会实现一个内部的reload接口，用来加载最新的配置文件到进程中。

###### 场景二：多文件挂载

假如有多个配置文件，都需要挂载到pod内部，且都在一个目录中\

```yaml
$ cat application-1.conf
name: "application-1"
platform: "linux"
purpose: "demo"
company: "luffy"
version: "v2.1.0"
$ cat application-2.conf
name: "application-2"
platform: "linux"
purpose: "demo"
company: "luffy"
version: "v2.1.0"
```

同样可以使用两种方式创建：

```yaml
$ kubectl delete cm application-config

$ kubectl create cm application-config --from-file=application-1.conf --from-file=application-2.conf

$ kubectl get cm application-config -oyaml
```

观察Pod已经自动获取到最新的变化

```yaml
$ kubectl exec demo-55c649865b-gpkgk ls /etc/application/
application-1.conf
application-2.conf
```

此时，是挂载到pod内的空目录中/etc/application，假如想挂载到pod已存在的目录中，比如：

```yaml
$  kubectl exec   demo-55c649865b-gpkgk ls /etc/profile.d
color_prompt
locale
```

更改deployment的挂载目录：

```yaml
$ cat demo-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  namespace: default
spec:
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      volumes:
      - configMap:
          name: application-config
        name: config
      containers:
      - name: nginx
        image: nginx:alpine
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - mountPath: "/etc/profile.d"
          name: config
```

重建pod

```yaml
$ kubectl apply -f demo-deployment.yaml

# 查看pod内的/etc/profile.d目录，发现已有文件被覆盖
$ kubectl exec demo-77d685b9f7-68qz7 ls /etc/profile.d
application-1.conf
application-2.conf
```

###### 场景三 挂载子路径

实现多个配置文件，可以挂载到pod内的不同的目录中。比如：

* application-1.conf挂载到/etc/application/
* application-2.conf挂载到/etc/profile.d

configmap保持不变，修改deployment文件：\

```yaml
$ cat demo-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  namespace: default
spec:
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      volumes:
      - name: config
        configMap:
          name: application-config
          items:
          - key: application-1.conf
            path: application1
          - key: application-2.conf
            path: application2
      containers:
      - name: nginx
        image: nginx:alpine
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - mountPath: "/etc/application/application-1.conf"
          name: config
          subPath: application1
        - mountPath: "/etc/profile.d/application-2.conf"
          name: config
          subPath: application2
```

测试挂载：

```yaml
$ kubectl apply -f demo-deployment.yaml

$ kubectl exec demo-78489c754-shjhz ls /etc/application
application-1.conf

$ kubectl exec demo-78489c754-shjhz ls /etc/profile.d/
application-2.conf
color_prompt
locale
```

使用subPath挂载到Pod内部的文件，不会自动感知原有ConfigMap的变更

##### 部署es服务

###### 部署分析

1. es生产环境是部署es集群，通常会使用statefulset进行部署
2. es默认使用elasticsearch用户启动进程，es的数据目录是通过宿主机的路径挂载，因此目录权限被主机的目录权限覆盖，因此可以利用initContainer容器在es进程启动之前把目录的权限修改掉，注意init container要用特权模式启动。
3. 若希望使用helm部署，参考 <https://github.com/helm/charts/tree/master/stable/elasticsearch>

###### 使用StatefulSet管理有状态服务

使用Deployment创建多副本的pod的情况：\

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: default
  labels:
    app: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-deployment
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```

使用StatefulSet创建多副本pod的情况：

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx-statefulset
  namespace: default
  labels:
    app: nginx-sts
spec:
  replicas: 3
  serviceName: "nginx"
  selector:
    matchLabels:
      app: nginx-sts
  template:
    metadata:
      labels:
        app: nginx-sts
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```

无头服务Headless Service

```yaml
kind: Service
apiVersion: v1
metadata:
  name: nginx
  namespace: default
spec:
  selector:
    app: nginx-sts
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  clusterIP: None
```

```yaml
$ kubectl -n default exec  -ti nginx-statefulset-0 sh
/ # curl nginx-statefulset-2.nginx
```

  

###### 部署并验证

es-config.yaml\

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: es-config
  namespace: logging
data:
  elasticsearch.yml: |
    cluster.name: "luffy-elasticsearch"
    node.name: "${POD_NAME}"
    network.host: 0.0.0.0
    discovery.seed_hosts: "es-svc-headless"
    cluster.initial_master_nodes: "elasticsearch-0,elasticsearch-1,elasticsearch-2"
```

  
es-svc-headless.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: es-svc-headless
  namespace: logging
  labels:
    k8s-app: elasticsearch
spec:
  selector:
    k8s-app: elasticsearch
  clusterIP: None
  ports:
  - name: in
    port: 9300
    protocol: TCP
```

es-statefulset.yaml

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: elasticsearch
  namespace: logging
  labels:
    k8s-app: elasticsearch
spec:
  replicas: 3
  serviceName: es-svc-headless
  selector:
    matchLabels:
      k8s-app: elasticsearch
  template:
    metadata:
      labels:
        k8s-app: elasticsearch
    spec:
      initContainers:
      - command:
        - /sbin/sysctl
        - -w
        - vm.max_map_count=262144
        image: alpine:3.6
        imagePullPolicy: IfNotPresent
        name: elasticsearch-logging-init
        resources: {}
        securityContext:
          privileged: true
      - name: fix-permissions
        image: alpine:3.6
        command: ["sh", "-c", "chown -R 1000:1000 /usr/share/elasticsearch/data"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: es-data-volume
          mountPath: /usr/share/elasticsearch/data
      containers:
      - name: elasticsearch
        image: 172.21.51.67:5000/elasticsearch/elasticsearch:7.4.2
        env:
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
        resources:
          limits:
            cpu: '1'
            memory: 2Gi
          requests:
            cpu: '1'
            memory: 2Gi
        ports:
        - containerPort: 9200
          name: db
          protocol: TCP
        - containerPort: 9300
          name: transport
          protocol: TCP
        volumeMounts:
          - name: es-config-volume
            mountPath: /usr/share/elasticsearch/config/elasticsearch.yml
            subPath: elasticsearch.yml
          - name: es-data-volume
            mountPath: /usr/share/elasticsearch/data
      volumes:
        - name: es-config-volume
          configMap:
            name: es-config
            items:
            - key: elasticsearch.yml
              path: elasticsearch.yml
  volumeClaimTemplates:
  - metadata:
      name: es-data-volume
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: "nfs"
      resources:
        requests:
          storage: 5Gi
```

es-svc.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: es-svc
  namespace: logging
  labels:
    k8s-app: elasticsearch
spec:
  selector:
    k8s-app: elasticsearch
  ports:
  - name: out
    port: 9200
    protocol: TCP
```

```yaml
$ kubectl create namespace logging

## 部署服务
$ kubectl create -f es-config.yaml
$ kubectl create -f es-svc-headless.yaml
$ kubectl create -f es-sts.yaml
$ kubectl create -f es-svc.yaml

## 等待片刻，查看一下es的pod部署到了k8s-slave1节点，状态变为running
$ kubectl -n logging get po -o wide  
NAME              READY   STATUS    RESTARTS   AGE   IP  
elasticsearch-0   1/1     Running   0          15m   10.244.0.126 
elasticsearch-1   1/1     Running   0          15m   10.244.0.127
elasticsearch-2   1/1     Running   0          15m   10.244.0.128
# 然后通过curl命令访问一下服务，验证es是否部署成功
$ kubectl -n logging get svc  
es-svc            ClusterIP   10.104.226.175   <none>        9200/TCP   2s
es-svc-headless   ClusterIP   None             <none>        9300/TCP   32m 
$ curl 10.104.226.175:9200
{
  "name" : "elasticsearch-2",
  "cluster_name" : "luffy-elasticsearch",
  "cluster_uuid" : "7FDIACx9T-2ajYcB5qp4hQ",
  "version" : {
    "number" : "7.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "2f90bbf7b93631e52bafb59b3b049cb44ec25e96",
    "build_date" : "2019-10-28T20:40:44.881551Z",
    "build_snapshot" : false,
    "lucene_version" : "8.2.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
```

  

##### 部署kibana

###### 部署分析

1. kibana需要暴露web页面给前端使用，因此使用ingress配置域名来实现对kibana的访问
2. kibana为无状态应用，直接使用Deployment来启动
3. kibana需要访问es，直接利用k8s服务发现访问此地址即可，[http://es-svc:9200](http://es-svc:9200/)

###### 部署并验证

efk/kibana.yaml\

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kibana
  namespace: logging
  labels:
    app: kibana
spec:
  selector:
    matchLabels:
      app: "kibana"
  template:
    metadata:
      labels:
        app: kibana
    spec:
      containers:
      - name: kibana
        image: 172.21.51.67:5000/kibana/kibana:7.4.2
        resources:
          limits:
            cpu: 1000m
          requests:
            cpu: 100m
        env:
          - name: ELASTICSEARCH_HOSTS
            value: http://es-svc:9200
          - name: SERVER_NAME
            value: kibana-logging
          - name: SERVER_REWRITEBASEPATH
            value: "false"
        ports:
        - containerPort: 5601
---
apiVersion: v1
kind: Service
metadata:
  name: kibana
  namespace: logging
  labels:
    app: kibana
spec:
  ports:
  - port: 5601
    protocol: TCP
    targetPort: 5601
  type: ClusterIP
  selector:
    app: kibana
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: kibana
  namespace: logging
spec:
  rules:
  - host: kibana.luffy.com
    http:
      paths:
      - path: /
        backend:
          serviceName: kibana
          servicePort: 5601
```

  

```yaml
$ kubectl create -f kibana.yaml  
deployment.apps/kibana created
service/kibana created  
ingress/kibana created

## 配置域名解析 kibana.luffy.com，并访问服务进行验证，若可以访问，说明连接es成功
```

  

##### Fluentd服务部署

###### 部署分析

1. fluentd为日志采集服务，kubernetes集群的每个业务节点都有日志产生，因此需要使用daemonset的模式进行部署
2. 为进一步控制资源，会为daemonset指定一个选择标签，fluentd=true来做进一步过滤，只有带有此标签的节点才会部署fluentd
3. 日志采集，需要采集哪些目录下的日志，采集后发送到es端，因此需要配置的内容比较多，我们选择使用configmap的方式把配置文件整个挂载出来

###### 部署服务

efk/fluentd-es-config-main.yaml\

```yaml
apiVersion: v1
data:
  fluent.conf: |-
    # This is the root config file, which only includes components of the actual configuration
    #
    #  Do not collect fluentd's own logs to avoid infinite loops.
    <match fluent.**>
    @type null
    </match>

    @include /fluentd/etc/config.d/*.conf
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
  name: fluentd-es-config-main
  namespace: logging
```

  
配置文件，fluentd-config.yaml，注意点：

1. 数据源source的配置，k8s会默认把容器的标准和错误输出日志重定向到宿主机中
2. 默认集成了 [kubernetes_metadata_filter](https://github.com/fabric8io/fluent-plugin-kubernetes_metadata_filter) 插件，来解析日志格式，得到k8s相关的元数据，raw.kubernetes
3. match输出到es端的flush配置

efk/fluentd-configmap.yaml

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: fluentd-config
  namespace: logging
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
data:
  containers.input.conf: |-
    <source>
      @id fluentd-containers.log
      @type tail
      path /var/log/containers/*.log
      pos_file /var/log/es-containers.log.pos
      time_format %Y-%m-%dT%H:%M:%S.%NZ
      localtime
      tag raw.kubernetes.*
      format json
      read_from_head false
    </source>
    # Detect exceptions in the log output and forward them as one log entry.
    # https://github.com/GoogleCloudPlatform/fluent-plugin-detect-exceptions 
    <match raw.kubernetes.**>
      @id raw.kubernetes
      @type detect_exceptions
      remove_tag_prefix raw
      message log
      stream stream
      multiline_flush_interval 5
      max_bytes 500000
      max_lines 1000
    </match>
  output.conf: |-
    # Enriches records with Kubernetes metadata
    <filter kubernetes.**>
      @type kubernetes_metadata
    </filter>
    <match **>
      @id elasticsearch
      @type elasticsearch
      @log_level info
      include_tag_key true
      hosts elasticsearch-0.es-svc-headless:9200,elasticsearch-1.es-svc-headless:9200,elasticsearch-2.es-svc-headless:9200
      #port 9200
      logstash_format true
      #index_name kubernetes-%Y.%m.%d
      request_timeout    30s
      <buffer>
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_thread_count 2
        flush_interval 5s
        retry_forever
        retry_max_interval 30
        chunk_limit_size 2M
        queue_limit_length 8
        overflow_action block
      </buffer>
    </match>
```

  
daemonset定义文件，fluentd.yaml，注意点：

1. 需要配置rbac规则，因为需要访问k8s api去根据日志查询元数据
2. 需要将/var/log/containers/目录挂载到容器中
3. 需要将fluentd的configmap中的配置文件挂载到容器内
4. 想要部署fluentd的节点，需要添加fluentd=true的标签

efk/fluentd.yaml

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: fluentd-es
  namespace: logging
  labels:
    k8s-app: fluentd-es
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: fluentd-es
  labels:
    k8s-app: fluentd-es
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
rules:
- apiGroups:
  - ""
  resources:
  - "namespaces"
  - "pods"
  verbs:
  - "get"
  - "watch"
  - "list"
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: fluentd-es
  labels:
    k8s-app: fluentd-es
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
subjects:
- kind: ServiceAccount
  name: fluentd-es
  namespace: logging
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: fluentd-es
  apiGroup: ""
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
    k8s-app: fluentd-es
  name: fluentd-es
  namespace: logging
spec:
  selector:
    matchLabels:
      k8s-app: fluentd-es
  template:
    metadata:
      labels:
        k8s-app: fluentd-es
    spec:
      containers:
      - env:
        - name: FLUENTD_ARGS
          value: --no-supervisor -q
        image: 172.21.51.67:5000/fluentd_elasticsearch/fluentd:v2.5.2
        imagePullPolicy: IfNotPresent
        name: fluentd-es
        resources:
          limits:
            memory: 500Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - mountPath: /var/log
          name: varlog
        - mountPath: /var/lib/docker/containers
          name: varlibdockercontainers
          readOnly: true
        - mountPath: /fluentd/etc/config.d
          name: config-volume
        - mountPath: /fluentd/etc/fluent.conf
          name: config-volume-main
          subPath: fluent.conf
      nodeSelector:
        fluentd: "true"
      securityContext: {}
      serviceAccount: fluentd-es
      serviceAccountName: fluentd-es
      volumes:
      - hostPath:
          path: /var/log
          type: ""
        name: varlog
      - hostPath:
          path: /var/lib/docker/containers
          type: ""
        name: varlibdockercontainers
      - configMap:
          defaultMode: 420
          name: fluentd-config
        name: config-volume
      - configMap:
          defaultMode: 420
          items:
          - key: fluent.conf
            path: fluent.conf
          name: fluentd-es-config-main
        name: config-volume-main
```

```yaml
## 给slave1打上标签，进行部署fluentd日志采集服务
$ kubectl label node k8s-slave1 fluentd=true  
$ kubectl label node k8s-slave2 fluentd=true

# 创建服务
$ kubectl create -f fluentd-es-config-main.yaml  
configmap/fluentd-es-config-main created  
$ kubectl create -f fluentd-configmap.yaml  
configmap/fluentd-config created  
$ kubectl create -f fluentd.yaml  
serviceaccount/fluentd-es created  
clusterrole.rbac.authorization.k8s.io/fluentd-es created  
clusterrolebinding.rbac.authorization.k8s.io/fluentd-es created  
daemonset.extensions/fluentd-es created 

## 然后查看一下pod是否已经在k8s-slave1
$ kubectl -n logging get po -o wide
NAME                      READY   STATUS    RESTARTS   AGE  
elasticsearch-logging-0   1/1     Running   0          123m  
fluentd-es-246pl             1/1     Running   0          2m2s  
kibana-944c57766-ftlcw    1/1     Running   0          50m
```

上述是简化版的k8s日志部署收集的配置，完全版的可以提供 <https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch> 来查看。

##### EFK功能验证

###### 验证思路

在slave节点中启动服务，同时往标准输出中打印测试日志，到kibana中查看是否可以收集

###### 创建测试容器

efk/test-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: counter
spec:
  nodeSelector:
    fluentd: "true"
  containers:
  - name: count
    image: alpine:3.6
    args: [/bin/sh, -c,
            'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 1; done']
```

```yaml
$ kubectl get po  
NAME                          READY   STATUS    RESTARTS   AGE  
counter                       1/1     Running   0          6s
```

###### 配置kibana

登录kibana界面，按照截图的顺序操作：

<!-- OCR_START -->
Management / Index patterns/Create index pattern
Elst点击图标进入本截图界面
Index Management
Create index pattern
Index Lifecycle Policies
Kibana uses index patterns to retrieve data from Elasticsearch indices for things like visualizations.
× Include system indices
Rollup Jobs
Cross-Cluster Replication
Remote Clusters
Step 1 of 2: Define index pattern
输入logstash-*
Snapshot and Restore
2.
License Management
Index Patterns
3.点击netx step
8.0 Upgrade Assistant
logstash-*
Kibana
You can use a * as a wildcard in your index pattern.
Next step
You can't use spaces or the characters I,I,?,", <, >, l.
V Success! Your index pattern matches 1 index.
Saved Objects
Spaces
logstash-2020.02.23
Reporting
Advanced Settings
Rows per page: 10
<!-- OCR_END -->

<!-- OCR_START -->
Management/ Index patterns/Create indexpattern
Elasticsearch
Create index pattern
Index Management
Index Lifecycle Policies
Kibana uses index patterns to retrieve data from Elasticsearch indices for things like visualizations.
× Include system indices
Rollup Jobs
Cross-Cluster Replication
Remote Clusters
Step 2 of 2: Configure settings
Snapshot and Restore
License Management
8.0 Upgrade Assistant
Time Filter field name Refresh
Kibana
@timestamp
Index Patterns
The Time Filter will use this field to filter your data by time.
Saved Objects
You can choose not to have a time field, but you will not be able to
narrow down your data by a time range.
Spaces
2.1
创建index
Reporting
Show advanced options
Advanced Settings
<Back
<!-- OCR_END -->

<!-- OCR_START -->
- Management / Index patterns / logstash-*
- Index Management
- logstash-*
- Index Lifecycle Policies
- Time Filter field name: @timestamp
- fault
- Rollup Jobs
- Cross-Cluster Replication
- This page lists every field in the
- ogstash-* index and the field's associated core type as recorded by Elasticsearch. To
- lusters
- change a field type, use the Elasti
- licsearch Mapping API
- mt
- Snapshot and Restore
- License Management
- Fields (50)
- Scripted
- ields (0)
- Source filters (0)
- 8.0 Upgrade Assistant
- Q Filter
- All field types
- Kibana
- Index Patterns
- Name
- Type
- Format
- Searchable
- Aggregatable
- Excluded
- Saved Objects
- Spaces
- @timestamp ①
- date
- Reporting
- _id
- string
- Advanced Settings
- _index
- number
- _score
- _source
<!-- OCR_END -->

<!-- OCR_START -->
Discover
? _source
30
Available fields
20
@timestamp
10
_id
_index
15:15:00
15:16:00
15:17:00
15:18:00
15:19:00
15:20:00
15:21:00
15:22:0015:23:00
15:24:0015:25:00
15:26:0015:27:00
15:28:00
15:29:00
@timestampper 30seconds
_score
-type
Time
docker.container_id
Feb 23，2020 @ 15:29:1.@Q
kubernetes.pod_name :
counter 1og: 7760: Sun Feb 23 07:29:11 UTC 2020 stream: stdout
kubernetes.containe...
docker.container_id:a48cc736438b461ae009c723e58471223a657ffed58eaa40e7935cf98f45c361
kubernetes.container_name: count kubernetes.namespace_name: default
kubernetes.container_image: busybox:latest kubernetes.container_image_id: docker-
pullab1e://busybox@sha256:6915be4043561d64e0ab0f8f098dc2ac48e077fe23f488ac24b665166898115a
kubernetes.host
Feb 23，2020 @ 15:29:10.599
counter
1log:7759: Sun Feb 23 07:29:10 UTC 2020 stream: stdout
kubernetes.labels.co...
<!-- OCR_END -->

也可以通过其他元数据来过滤日志数据，比如可以单击任何日志条目以查看其他元数据，如容器名称，Kubernetes 节点，命名空间等，比如kubernetes.pod_name : counter

到这里，我们就在 Kubernetes 集群上成功部署了 EFK ，要了解如何使用 Kibana 进行日志数据分析，可以参考 Kibana 用户指南文档：<https://www.elastic.co/guide/en/kibana/current/index.html>

#### Prometheus实现k8s集群的服务监控

Prometheus 是一个开源监控系统，它本身已经成为了云原生中指标监控的事实标准 。

##### k8s集群监控体系演变史

第一版本：**Cadvisor+InfluxDB+Grafana**

只能从主机维度进行采集，没有Namespace、Pod等维度的汇聚功能

第二版本： **Heapster+InfluxDB+Grafana**

heapster负责调用各node中的cadvisor接口，对数据进行汇总，然后导到InfluxDB ， 可以从cluster，node，pod的各个层面提供详细的资源使用情况。

<!-- OCR_START -->
- k8s-Master
- 界面
- 获取Pod列表
- grafana
- influxdb
- heapster
- Kubelet
- cAdvisor
- Node
- //b1og
<!-- OCR_END -->

第三版本：Metrics-Server + Prometheus

<!-- OCR_START -->
- ResourceMetrics
- hpa
- Custom Metrics
- kubelet
- prometheus
- metricserver
- prometheus-adapter
- www.xuyasong.com
<!-- OCR_END -->

k8s对监控接口进行了标准化，主要分了三类：

* Resource Metrics对应的接口是 metrics.k8s.io，主要的实现就是 metrics-server，它提供的是资源的监控，比较常见的是节点级别、pod 级别、namespace 级别、class 级别。这类的监控指标都可以通过 metrics.k8s.io 这个接口获取到
* Custom Metrics对应的接口是 custom.metrics.k8s.io，主要的实现是 Prometheus， 它提供的是资源监控和自定义监控，资源监控和上面的资源监控其实是有覆盖关系的。自定义监控指的是：比如应用上面想暴露一个类似像在线人数，或者说调用后面的这个数据库的 MySQL 的慢查询。这些其实都是可以在应用层做自己的定义的，然后并通过标准的 Prometheus 的 client，暴露出相应的 metrics，然后再被 Prometheus 进行采集
* External Metrics对应的接口是 external.metrics.k8s.io。主要的实现厂商就是各个云厂商的 provider，通过这个 provider 可以通过云资源的监控指标

##### Prometheus架构

<!-- OCR_START -->
- Short-lived jobs
- Service Discovery
- PagerDuty
- Email
- DNS
- Kubernetes
- Consul
- notify
- Pushgateway
- Custom integration
- find
- Alertmanager
- targets
- Prometheus Server
- push alerts
- pull metrics
- Retrieval
- Storage
- PromQL
- Web UI
- Grafana
- API clients
- Node
- HDD / SSD
- Jobs/Exporters
<!-- OCR_END -->

* Prometheus Server ，监控、告警平台核心，抓取目标端监控数据，生成聚合数据，存储时间序列数据
* exporter，由被监控的对象提供，提供API暴漏监控对象的指标，供prometheus 抓取
  * node-exporter
  * blackbox-exporter
  * redis-exporter
  * mysql-exporter
  * custom-exporter
  * ...
* pushgateway，提供一个网关地址，外部数据可以推送到该网关，prometheus也会从该网关拉取数据
* Alertmanager，接收Prometheus发送的告警并对于告警进行一系列的处理后发送给指定的目标
* Grafana：配置数据源，图标方式展示数据

##### Prometheus安装

基于go开发， <https://github.com/prometheus/prometheus>

若使用docker部署直接启动镜像即可：

```yaml
$ docker run --name prometheus -d -p 127.0.0.1:9090:9090 prom/prometheus

```

我们想制作Prometheus的yaml文件，可以先启动容器进去看一下默认的启动命令：

```yaml
$ docker run -d --name tmp -p 127.0.0.1:9090:9090 prom/prometheus:v2.19.2
$ docker exec -ti tmp sh
#/ ps aux
#/ cat /etc/prometheus/prometheus.yml
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself. exporter
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']
```

本例中，使用k8s来部署，所需的资源清单如下：

```yaml
# 创建新的命名空间 monitor，存储prometheus相关资源
$ cat prometheus-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitor

# 需要准备配置文件，因此使用configmap的形式保存
$ cat prometheus-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitor
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    scrape_configs:
    - job_name: 'prometheus'
      static_configs:
      - targets: ['localhost:9090']

# prometheus的资源文件
# 出现Prometheus数据存储权限问题，因为Prometheus内部使用nobody启动进程，挂载数据目录后权限为root，因此使用initContainer进行目录权限修复：
$ cat prometheus-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitor
  labels:
    app: prometheus
spec:
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      serviceAccountName: prometheus
      nodeSelector:
        app: prometheus
      initContainers:
      - name: "change-permission-of-directory"
        image: busybox
        command: ["/bin/sh"]
        args: ["-c", "chown -R 65534:65534 /prometheus"]
        securityContext:
          privileged: true
        volumeMounts:
        - mountPath: "/etc/prometheus"
          name: config-volume
        - mountPath: "/prometheus"
          name: data
      containers:
      - image: prom/prometheus:v2.19.2
        name: prometheus
        args:
        - "--config.file=/etc/prometheus/prometheus.yml"
        - "--storage.tsdb.path=/prometheus"  # 指定tsdb数据路径
        - "--web.enable-lifecycle"  # 支持热更新，直接执行localhost:9090/-/reload立即生效
        - "--web.console.libraries=/usr/share/prometheus/console_libraries"
        - "--web.console.templates=/usr/share/prometheus/consoles"
        ports:
        - containerPort: 9090
          name: http
        volumeMounts:
        - mountPath: "/etc/prometheus"
          name: config-volume
        - mountPath: "/prometheus"
          name: data
        resources:
          requests:
            cpu: 100m
            memory: 512Mi
          limits:
            cpu: 100m
            memory: 512Mi
      volumes:
      - name: data
        hostPath:
          path: /data/prometheus/
      - configMap:
          name: prometheus-config
        name: config-volume

# rbac,prometheus会调用k8s api做服务发现进行抓取指标
$ cat prometheus-rbac.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitor
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  - services
  - endpoints
  - pods
  - nodes/proxy
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - "extensions"
  resources:
    - ingresses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - configmaps
  - nodes/metrics
  verbs:
  - get
- nonResourceURLs:
  - /metrics
  verbs:
  - get
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: monitor

# 提供Service，为Ingress使用
$ cat prometheus-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitor
  labels:
    app: prometheus
spec:
  selector:
    app: prometheus
  type: ClusterIP
  ports:
    - name: web
      port: 9090
      targetPort: http

$ cat prometheus-ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: prometheus
  namespace: monitor
spec:
  rules:
  - host: prometheus.luffy.com
    http:
      paths:
      - path: /
        backend:
          serviceName: prometheus
          servicePort: 9090
```

部署上述资源：

```yaml
# 命名空间
$ kubectl create prometheus-namespace.yaml

# 给node打上label
$ kubectl label node k8s-slave1 app=prometheus

#部署configmap
$ kubectl create -f prometheus-configmap.yaml

# rbac
$ kubectl create -f prometheus-rbac.yaml

# deployment
$ kubectl create -f prometheus-deployment.yaml

# service
$ kubectl create -f prometheus-svc.yaml

# ingress
$ kubectl create -f prometheus-ingress.yaml

# 访问测试
$ kubectl -n monitor get ingress
```

##### 理解时间序列数据库（TSDB）

```yaml

# http://localhost:9090/metrics
$ kubectl -n monitor get po -o wide
prometheus-dcb499cbf-fxttx   1/1     Running   0          13h   10.244.1.132   k8s-slave1 

$ curl http://10.244.1.132:9090/metrics
...
# HELP promhttp_metric_handler_requests_total Total number of scrapes by HTTP status code.
# TYPE promhttp_metric_handler_requests_total counter
promhttp_metric_handler_requests_total{code="200"} 149
promhttp_metric_handler_requests_total{code="500"} 0
promhttp_metric_handler_requests_total{code="503"} 0
```

tsdb（Time Series Database）

其中#号开头的两行分别为：

* HELP开头说明该行为指标的帮助信息，通常解释指标的含义
* TYPE开头是指明了指标的类型
  * counter 计数器
  * guage 测量器
  * histogram 柱状图
  * summary 采样点分位图统计

其中非#开头的每一行表示当前采集到的一个监控样本：

* promhttp_metric_handler_requests_total表明了当前指标的名称
* 大括号中的标签则反映了当前样本的一些特征和维度
* 浮点数则是该监控样本的具体值。

每次采集到的数据都会被Prometheus以time-series（时间序列）的方式保存到内存中，定期刷新到硬盘。如下所示，可以将time-series理解为一个以时间为X轴的数字矩阵：\

```yaml
  ^
  │   . . . . . . . . . . . . . . . . .   . .   node_cpu{cpu="cpu0",mode="idle"}
  │     . . . . . . . . . . . . . . . . . . .   node_cpu{cpu="cpu0",mode="system"}
  │     . . . . . . . . . .   . . . . . . . .   node_load1{}
  │     . . . . . . . . . . . . . . . .   . .  
  v
    <------------------ 时间 ---------------->
```

在time-series中的每一个点称为一个样本（sample），样本由以下三部分组成：

* 指标(metric)：metric name和描述当前样本特征的labelsets;
* 时间戳(timestamp)：一个精确到毫秒的时间戳;
* 样本值(value)： 一个float64的浮点型数据表示当前样本的值。

在形式上，所有的指标(Metric)都通过如下格式标示：\

```yaml
<metric name>{<label name>=<label value>, ...}

```

* 指标的名称(metric name)可以反映被监控样本的含义（比如，http_request_total - 表示当前系统接收到的HTTP请求总量）。
* 标签(label)反映了当前样本的特征维度，通过这些维度Prometheus可以对样本数据进行过滤，聚合等。

Prometheus：定期去Tragets列表拉取监控数据，存储到TSDB中，并且提供指标查询、分析的语句和接口。

##### 添加监控目标

无论是业务应用还是k8s系统组件，只要提供了metrics api，并且该api返回的数据格式满足标准的Prometheus数据格式要求即可。

其实，很多组件已经为了适配Prometheus采集指标，添加了对应的/metrics api，比如

CoreDNS：\

```yaml
$ kubectl -n kube-system get po -owide|grep coredns
coredns-58cc8c89f4-nshx2             1/1     Running   6          22d   10.244.0.20  
coredns-58cc8c89f4-t9h2r             1/1     Running   7          22d   10.244.0.21

$ curl 10.244.0.20:9153/metrics
```

修改target配置：

```yaml
$ cat prometheus-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitor
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      scrape_timeout: 15s
    scrape_configs:
    - job_name: 'prometheus'
      static_configs:
      - targets: ['localhost:9090']
    - job_name: 'coredns'
      static_configs:
      - targets: ['10.96.0.10:9153']

$ kubectl apply -f prometheus-configmap.yaml

# 重建pod生效
$ kubectl -n monitor delete po prometheus-dcb499cbf-fxttx
```

##### 常用监控对象的指标采集

对于集群的监控一般我们需要考虑以下几个方面：

* 内部系统组件的状态：比如 kube-apiserver、kube-scheduler、kube-controller-manager、kubedns/coredns 等组件的详细运行状态
* Kubernetes 节点的监控：比如节点的 cpu、load、disk、memory 等指标
* 业务容器指标的监控（容器CPU、内存、磁盘等）
* 编排级的 metrics：比如 Deployment 的状态、资源请求、调度和 API 延迟等数据指标

###### 监控kube-apiserver

apiserver自身也提供了/metrics 的api来提供监控数据，\

```yaml
$ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   23d

$ curl -k  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InhXcmtaSG5ZODF1TVJ6dUcycnRLT2c4U3ZncVdoVjlLaVRxNG1wZ0pqVmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi10b2tlbi1xNXBueiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJhZG1pbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImViZDg2ODZjLWZkYzAtNDRlZC04NmZlLTY5ZmE0ZTE1YjBmMCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbiJ9.iEIVMWg2mHPD88GQ2i4uc_60K4o17e39tN0VI_Q_s3TrRS8hmpi0pkEaN88igEKZm95Qf1qcN9J5W5eqOmcK2SN83Dd9dyGAGxuNAdEwi0i73weFHHsjDqokl9_4RGbHT5lRY46BbIGADIphcTeVbCggI6T_V9zBbtl8dcmsd-lD_6c6uC2INtPyIfz1FplynkjEVLapp_45aXZ9IMy76ljNSA8Uc061Uys6PD3IXsUD5JJfdm7lAt0F7rn9SdX1q10F2lIHYCMcCcfEpLr4Vkymxb4IU4RCR8BsMOPIO_yfRVeYZkG4gU2C47KwxpLsJRrTUcUXJktSEPdeYYXf9w" https://172.21.51.67:6443/metrics
```

可以通过手动配置如下job来试下对apiserver服务的监控，

```yaml
$ cat prometheus-configmap.yaml
...
    - job_name: 'kubernetes-apiserver'
      static_configs:
      - targets: ['10.96.0.1']
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
```

###### 监控集群节点基础指标

node_exporter <https://github.com/prometheus/node_exporter>

分析：

* 每个节点都需要监控，因此可以使用DaemonSet类型来管理node_exporter
* 添加节点的容忍配置
* 挂载宿主机中的系统文件信息

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: monitor
  labels:
    app: node-exporter
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      hostPID: true
      hostIPC: true
      hostNetwork: true
      nodeSelector:
        kubernetes.io/os: linux
      containers:
      - name: node-exporter
        image: prom/node-exporter:v1.0.1
        args:
        - --web.listen-address=$(HOSTIP):9100
        - --path.procfs=/host/proc
        - --path.sysfs=/host/sys
        - --path.rootfs=/host/root
        - --collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+)($|/)
        - --collector.filesystem.ignored-fs-types=^(autofs|binfmt_misc|cgroup|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|mqueue|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|sysfs|tracefs)$
        ports:
        - containerPort: 9100
        env:
        - name: HOSTIP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        resources:
          requests:
            cpu: 150m
            memory: 180Mi
          limits:
            cpu: 150m
            memory: 180Mi
        securityContext:
          runAsNonRoot: true
          runAsUser: 65534
        volumeMounts:
        - name: proc
          mountPath: /host/proc
        - name: sys
          mountPath: /host/sys
        - name: root
          mountPath: /host/root
          mountPropagation: HostToContainer
          readOnly: true
      tolerations:
      - operator: "Exists"
      volumes:
      - name: proc
        hostPath:
          path: /proc
      - name: dev
        hostPath:
          path: /dev
      - name: sys
        hostPath:
          path: /sys
      - name: root
        hostPath:
          path: /
```

创建node-exporter服务

```yaml
$ kubectl create -f node-exporter.yaml

$ kubectl -n monitor get po
```

问题来了，如何添加到Prometheus的target中？

* 配置一个Service，后端挂载node-exporter的服务，把Service的地址配置到target中
  * 带来新的问题，target中无法直观的看到各节点node-exporter的状态
* 把每个node-exporter的服务都添加到target列表中
  * 带来新的问题，集群节点的增删，都需要手动维护列表
  * target列表维护量随着集群规模增加

###### Prometheus的服务发现与Relabeling

之前已经给Prometheus配置了RBAC，有读取node的权限，因此Prometheus可以去调用Kubernetes API获取node信息，所以Prometheus通过与 Kubernetes API 集成，提供了内置的服务发现分别是：Node、Service、Pod、Endpoints、Ingress

配置job即可：\

```yaml
    - job_name: 'kubernetes-sd-node-exporter'
      kubernetes_sd_configs:
        - role: node
```

重建查看效果：

```yaml
$ kubectl apply -f prometheus-configmap.yaml
$ kubectl -n monitor delete po prometheus-dcb499cbf-6cwlg
```

<!-- OCR_START -->
All
Unhealthy
coredns1 (1/1 up)
Scrape
Endpoint
State
Labels
Last Scrape
Duration Error
http://10.96.0.10:9153/metrics
UP
13.653s ago
nce="10.96.0.10:9153"job="coredns1"
2.741ms
kubernetes-sd-nodes (0/3 up)
http://192.168.136.10:10250/metrics
DOWn
instance="k8s-master" job="kubernetes-sd-nodes"
5.199s ago
1.739ms
server returned HTTP status 400 Bad Request
http://192.168.136.11:10250/metrics
instance="k8s-slave1"job="kubermetes-sd-nodes
14.998s ago
713.3us
http://192.168.136.12:10250/metrics
6.33s ago
1.796ms
prometheus (1/1 up)
showless
http:/ocalhost:9090/metrics
instance="localhost:9090"job="pro
netheus"
5.009s ago
5.287ms
<!-- OCR_END -->

\
默认访问的地址是[http://node-ip/10250/metrics，10250是kubelet](http://node-ip/10250/metrics%EF%BC%8C10250%E6%98%AFkubelet) API的服务端口，说明Prometheus的node类型的服务发现模式，默认是和kubelet的10250绑定的，而我们是期望使用node-exporter作为采集的指标来源，因此需要把访问的endpoint替换成[http://node-ip:9100/metrics。](http://node-ip:9100/metrics%E3%80%82)

<!-- OCR_START -->
- Load Targets
- Relabeling
- Scrape Sampels
<!-- OCR_END -->

在真正抓取数据前，Prometheus提供了relabeling的能力。怎么理解？

查看Target的Label列，可以发现，每个target对应会有很多Before Relabeling的标签，这些__开头的label是系统内部使用，不会存储到样本的数据里，但是，我们在查看数据的时候，可以发现，每个数据都有两个默认的label，即：\

```yaml
prometheus_notifications_dropped_total{instance="localhost:9090",job="prometheus"}

```

instance的值其实则取自于**address**

这种发生在采集样本数据之前，对Target实例的标签进行重写的机制在Prometheus被称为Relabeling。

因此，利用relabeling的能力，只需要将**address**替换成node_exporter的服务地址即可。\

```yaml
    - job_name: 'kubernetes-sd-node-exporter'
      kubernetes_sd_configs:
        - role: node
      relabel_configs:
      - source_labels: [__address__]
        regex: '(.*):10250'
        replacement: '${1}:9100'
        target_label: __address__
        action: replace
```

再次更新Prometheus服务后，查看targets列表及node-exporter提供的指标，node_load1

###### 使用cadvisor实现容器监控指标的采集（废弃）

cAdvisor 指标访问路径为 https://10.96.0.1/api/v1/nodes/\<node_name>/proxy/metrics/cadvisor

```yaml
https://10.96.0.1/api/v1/nodes/k8s-master/proxy/metrics/cadvisor
https://10.96.0.1/api/v1/nodes/k8s-slave1/proxy/metrics/cadvisor
https://10.96.0.1/api/v1/nodes/k8s-slave2/proxy/metrics/cadvisor
```

分析：

* 每个节点都需要做替换，可以利用Prometheus服务发现中 node这种role

```yaml
    - job_name: 'kubernetes-sd-cadvisor'
      kubernetes_sd_configs:
        - role: node
```

默认添加的target列表为：**schema**://**address** **metrics_path**

```yaml
http://172.21.51.67:10250/metrics
http://172.21.51.68:10250/metrics
http://172.21.51.69:10250/metrics
```

* 抓取的地址是相同的，可以用10.96.0.1做固定值进行替换**address**

```yaml
    - job_name: 'kubernetes-sd-cadvisor'
      kubernetes_sd_configs:
        - role: node
      relabel_configs:
      - target_label: __address__
        replacement: 10.96.0.1
        action: replace
```

目前为止，替换后的样子：

```yaml
http://10.96.0.1/metrics
http://10.96.0.1/metrics
http://10.96.0.1/metrics
```

* 需要把找到node-name，来做动态替换**metrics_path**

```yaml
    - job_name: 'kubernetes-sd-cadvisor'
      kubernetes_sd_configs:
        - role: node
      relabel_configs:
      - target_label: __address__
        replacement: 10.96.0.1
        action: replace
      - source_labels: [__meta_kubernetes_node_name]
        regex: (.+)
        target_label: __metrics_path__
        replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
```

目前为止，替换后的样子：

```yaml
http://10.96.0.1/api/v1/nodes/k8s-master/proxy/metrics/cadvisor
http://10.96.0.1/api/v1/nodes/k8s-slave1/proxy/metrics/cadvisor
http://10.96.0.1/api/v1/nodes/k8s-slave2/proxy/metrics/cadvisor
```

加上api-server的认证信息

```yaml
    - job_name: 'kubernetes-sd-cadvisor'
      kubernetes_sd_configs:
        - role: node
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      relabel_configs:
      - target_label: __address__
        replacement: 10.96.0.1
      - source_labels: [__meta_kubernetes_node_name]
        regex: (.+)
        target_label: __metrics_path__
        replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
```

重新应用配置，然后重建Prometheus的pod。查看targets列表，查看cadvisor指标，比如container_cpu_system_seconds_total，container_memory_usage_bytes

综上，利用node类型，可以实现对daemonset类型服务的目标自动发现以及监控数据抓取。

###### 使用cadvisor实现容器指标的采集（新）

目前cAdvisor集成到了kubelet组件内 ，因此可以通过kubelet的接口实现容器指标的采集，具体的API为:\

```yaml
https://<node-ip>:10250/metrics/cadvisor    # node上的cadvisor采集到的容器指标
https://<node-ip>:10250/metrics             # node上的kubelet的指标数据

# 可以通过curl -k  -H "Authorization: Bearer xxxx" https://xxxx/xx查看
```

  

因此，针对容器指标来讲，我们期望的采集target是：

```plain
https://172.21.51.67:10250/metrics/cadvisor
 https://172.21.51.68:10250/metrics/cadvisor
 https://172.21.51.69:10250/metrics/cadvisor
```

即每个node节点都需要去采集数据，联想到prometheus的服务发现中的node类型，因此，配置：

```plain
- job_name: 'kubernetes-sd-cadvisor'
       kubernetes_sd_configs:
         - role: node
```

默认添加的target列表为：**schema**://**address** **metrics_path**

```plain
http://172.21.51.67:10250/metrics
 http://172.21.51.68:10250/metrics
 http://172.21.51.69:10250/metrics
```

和期望值不同的是**schema**和**metrics_path**，针对**metrics_path**可以使用relabel修改：

```plain
relabel_configs:
       - target_label: __metrics_path__
         replacement: /metrics/cadvisor
```

针对**schema**：

```plain
- job_name: 'kubernetes-sd-cadvisor'
       kubernetes_sd_configs:
         - role: node
       scheme: https
       tls_config:
         ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
         insecure_skip_verify: true
       bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
       relabel_configs:
       - target_label: __metrics_path__
         replacement: /metrics/cadvisor
```

重新应用配置，然后重建Prometheus的pod。查看targets列表，查看cadvisor指标，比如container_cpu_system_seconds_total，container_memory_usage_bytes

综上，利用node类型，可以实现对daemonset类型服务的目标自动发现以及监控数据抓取。

补充：

若想采集kubelet的指标：

```plain
- job_name: 'kubernetes-sd-kubelet'
       kubernetes_sd_configs:
         - role: node
       scheme: https
       tls_config:
         ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
         insecure_skip_verify: true
       bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
```

###### 集群Service服务的监控指标采集

比如集群中存在100个业务应用，每个业务应用都需要被Prometheus监控。

每个服务是不是都需要手动添加配置？有没有更好的方式？

```plain
- job_name: 'kubernetes-sd-endpoints'
       kubernetes_sd_configs:
         - role: endpoints
```

添加到Prometheus配置中进行测试：

```plain
$ kubectl apply -f prometheus-configmap.yaml
 $ kubectl -n monitor delete po prometheus-dcb499cbf-4h9qj
```

此使的Target列表中，kubernetes-sd-endpoints下出现了N多条数据，

<!-- OCR_START -->
kubernetes-sd-services(3/7up)
show less
Scrape
Endpoint
State
Labels
Last Scrape
Duration Error
http://10.244.0.20:53/metrics
DOWN
instance="10.244.0.20:53
5.265s ago
2.003s
Get "http://10.244.0.20:53/metrics": EOF
job="kubernetes-sd-services"
http://10.244.0.20:9153/metrics
UP
instance="10.244.0.20:9153"
6.196s ago
2.758ms
http://10.244.0.21:53/metrics
instance="10.244.0.21:53"
10.863s ago
2.002s
Get "http://10.244.0.21:53/metrics": EOF
http://10.244.0.21:9153/metrics
instance="10.244.0.21:9153"
3.791s ago
8.343ms
http://10.244.1.125:8000/metrics
instance="10.244.1.125:8000"
7.878s ago
518.4us
strconv.ParseFloat: parsing "/metrics": invalid synta
http://10.244.1.140:9090/metrics
instance="10.244.1.140:9090"
3.581s ago
114.4ms
http://192.168.136.10:6443/metrics
instance="192.168.136.10:6443"
7.946s ago
3.633ms
server returned HTTP status 400 Bad Request
<!-- OCR_END -->

可以发现，实际上endpoint这个类型，目标是去抓取整个集群中所有的命名空间的Endpoint列表，然后使用默认的/metrics进行数据抓取，我们可以通过查看集群中的所有ep列表来做对比：

$ kubectl get endpoints --all-namespaces

但是实际上并不是每个服务都已经实现了/metrics监控的，也不是每个实现了/metrics接口的服务都需要注册到Prometheus中，因此，我们需要一种方式对需要采集的服务实现自主可控。这就需要利用relabeling中的keep功能。

<!-- OCR_START -->
- Load Targets
- Relabeling
- Scrape Sampels
<!-- OCR_END -->

我们知道，relabel的作用对象是target的Before Relabling标签，比如说，假如通过如下定义:

```plain
- job_name: 'kubernetes-sd-endpoints'
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels: [__keep_this_service__]
    action: keep
    regex: “true”
```

那么就可以实现target的Before Relabling中若存在**keep_this_service**，且值为true的话，则会加入到kubernetes-endpoints这个target中，否则就会被删除。

因此可以为我们期望被采集的服务，加上对应的Prometheus的label即可。

问题来了，怎么加？

查看coredns的metrics类型Before Relabling中的值，可以发现，存在如下类型的Prometheus的标签：

```plain
__meta_kubernetes_service_annotation_prometheus_io_scrape="true"
__meta_kubernetes_service_annotation_prometheus_io_port="9153"
```

这些内容是如何生成的呢，查看coredns对应的服务属性：

```plain
$ kubectl -n kube-system get service kube-dns -oyaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/port: "9153"
    prometheus.io/scrape: "true"
  creationTimestamp: "2020-06-28T17:05:35Z"
  labels:
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: KubeDNS
  name: kube-dns
  namespace: kube-system
  ...
```

发现存在annotations声明，因此，可以联想到二者存在对应关系，Service的定义中的annotations里的特殊字符会被转换成Prometheus中的label中的下划线。

我们即可以使用如下配置，来定义服务是否要被抓取监控数据。

```plain
- job_name: 'kubernetes-sd-endpoints'
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
    action: keep
    regex: true
```

这样的话，我们只需要为服务定义上如下的声明，即可实现Prometheus自动采集数据

```plain
annotations:
    prometheus.io/scrape: "true"
```

有些时候，我们业务应用提供监控数据的path地址并不一定是/metrics，如何实现兼容？

同样的思路，我们知道，Prometheus会默认使用Before Relabling中的\_\_metrics_path作为采集路径，因此，我们再自定义一个annotation，prometheus.io/path

```plain
annotations:
    prometheus.io/scrape: "true"
    prometheus.io/path: "/path/to/metrics"
```

这样，Prometheus端会自动生成如下标签：

\_\_meta_kubernetes_service_annotation_prometheus_io_path="/path/to/metrics"

我们只需要在relabel\*configs中用该标签的值，去重写\*\_metrics_path\*\*的值即可。因此：

```plain
- job_name: 'kubernetes-sd-endpoints'
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
```

有些时候，业务服务的metrics是独立的端口，比如coredns，业务端口是53，监控指标采集端口是9153，这种情况，如何处理？

很自然的，我们会想到通过自定义annotation来处理，

```plain
annotations:
    prometheus.io/scrape: "true"
    prometheus.io/path: "/path/to/metrics"
    prometheus.io/port: "9153"
```

如何去替换？

我们知道Prometheus默认使用Before Relabeling中的**address**进行作为服务指标采集的地址，但是该地址的格式通常是这样的

```plain
__address__="10.244.0.20:53"
__address__="10.244.0.21"
```

我们的目标是将如下两部分拼接在一起：

* 10.244.0.20
* prometheus.io/port定义的值，即\_\_meta_kubernetes_service_annotation_prometheus_io_port的值

因此，需要使用正则规则取出上述两部分：

```plain
- source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
    action: replace
    target_label: __address__
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
```

需要注意的几点：

* **address**中的:53有可能不存在，因此，使用()?的匹配方式进行
* 表达式中，三段()我们只需要第一和第三段，不需要中间括号部分的内容，因此使用?:的方式来做非获取匹配，即可以匹配内容，但是不会被记录到$1,$2这种变量中
* 多个source_labels中间默认使用;号分割，因此匹配的时候需要注意添加;号

此外，还可以将before relabeling 中的更多常用的字段取出来添加到目标的label中，比如：

```plain
- source_labels: [__meta_kubernetes_namespace]
    action: replace
    target_label: kubernetes_namespace
  - source_labels: [__meta_kubernetes_service_name]
    action: replace
    target_label: kubernetes_name
  - source_labels: [__meta_kubernetes_pod_name]
    action: replace
    target_label: kubernetes_pod_name
```

因此，目前的relabel的配置如下：

```plain
- job_name: 'kubernetes-sd-endpoints'
       kubernetes_sd_configs:
       - role: endpoints
       relabel_configs:
       - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
         action: keep
         regex: true
       - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
         action: replace
         target_label: __metrics_path__
         regex: (.+)
       - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
         action: replace
         target_label: __address__
         regex: ([^:]+)(?::\d+)?;(\d+)
         replacement: $1:$2    
       - source_labels: [__meta_kubernetes_namespace]
         action: replace
         target_label: kubernetes_namespace
       - source_labels: [__meta_kubernetes_service_name]
         action: replace
         target_label: kubernetes_name
       - source_labels: [__meta_kubernetes_pod_name]
         action: replace
         target_label: kubernetes_pod_name
```

验证一下：

更新configmap并重启Prometheus服务，查看target列表。

###### kube-state-metrics监控

已经有了cadvisor，容器运行的指标已经可以获取到，但是下面这种情况却无能为力：

* 我调度了多少个replicas？现在可用的有几个？
* 多少个Pod是running/stopped/terminated状态？
* Pod重启了多少次？

而这些则是kube-state-metrics提供的内容，它基于client-go开发，轮询Kubernetes API，并将Kubernetes的结构化信息转换为metrics。因此，需要借助于kube-state-metrics来实现。

指标类别包括：

* CronJob Metrics
* DaemonSet Metrics
* Deployment Metrics
* Job Metrics
* LimitRange Metrics
* Node Metrics
* PersistentVolume Metrics
* PersistentVolumeClaim Metrics
* Pod Metrics
  * kube_pod_info
  * kube_pod_owner
  * kube_pod_status_phase
  * kube_pod_status_ready
  * kube_pod_status_scheduled
  * kube_pod_container_status_waiting
  * kube_pod_container_status_terminated_reason
  * ...
* Pod Disruption Budget Metrics
* ReplicaSet Metrics
* ReplicationController Metrics
* ResourceQuota Metrics
* Service Metrics
* StatefulSet Metrics
* Namespace Metrics
* Horizontal Pod Autoscaler Metrics
* Endpoint Metrics
* Secret Metrics
* ConfigMap Metrics

部署： <https://github.com/kubernetes/kube-state-metrics#kubernetes-deployment>

```plain
$ wget https://github.com/kubernetes/kube-state-metrics/archive/v1.9.7.tar.gz
 
 $ tar zxf v1.9.7.tar.gz
 $ cp -r  kube-state-metrics-1.9.7/examples/standard/ .
 
 $ ll standard/
 total 20
 -rw-r--r-- 1 root root  377 Jul 24 06:12 cluster-role-binding.yaml
 -rw-r--r-- 1 root root 1651 Jul 24 06:12 cluster-role.yaml
 -rw-r--r-- 1 root root 1069 Jul 24 06:12 deployment.yaml
 -rw-r--r-- 1 root root  193 Jul 24 06:12 service-account.yaml
 -rw-r--r-- 1 root root  406 Jul 24 06:12 service.yaml
 
 # 替换namespace为monitor
 $ sed -i 's/namespace: kube-system/namespace: monitor/g' standard/*
 
 $ kubectl create -f standard/
 clusterrolebinding.rbac.authorization.k8s.io/kube-state-metrics created
 clusterrole.rbac.authorization.k8s.io/kube-state-metrics created
 deployment.apps/kube-state-metrics created
 serviceaccount/kube-state-metrics created
 service/kube-state-metrics created
```

如何添加到Prometheus监控target中？

```plain
$ cat standard/service.yaml
 apiVersion: v1
 kind: Service
 metadata:
   annotations:
     prometheus.io/scrape: "true"
     prometheus.io/port: "8080"
   labels:
     app.kubernetes.io/name: kube-state-metrics
     app.kubernetes.io/version: v1.9.7
   name: kube-state-metrics
   namespace: monitor
 spec:
   clusterIP: None
   ports:
   - name: http-metrics
     port: 8080
     targetPort: http-metrics
   - name: telemetry
     port: 8081
     targetPort: telemetry
   selector:
     app.kubernetes.io/name: kube-state-metrics
 
 $ kubectl apply -f standard/service.yaml
```

查看target列表，观察是否存在kube-state-metrics的target。

kube_pod_container_status_running

kube_deployment_status_replicas

##### Grafana

可视化面板，功能齐全的度量仪表盘和图形编辑器，支持 Graphite、zabbix、InfluxDB、Prometheus、OpenTSDB、Elasticsearch 等作为数据源，比 Prometheus 自带的图表展示功能强大太多，更加灵活，有丰富的插件，功能更加强大。

###### 安装

注意点：

* 使用最新版本的镜像 <https://github.com/grafana/grafana>
* 通过环境变量设置管理员账户密码
  * GF_SECURITY_ADMIN_USER
  * GF_SECURITY_ADMIN_PASSWORD
* 通过设置securityContext的方式让grafana进程使用root启动
* 数据挂载到本地
* 配置ingress暴露访问入口

```plain
$ cat grafana-all.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: grafana
   namespace: monitor
 spec:
   selector:
     matchLabels:
       app: grafana
   template:
     metadata:
       labels:
         app: grafana
     spec:
       volumes:
       - name: storage
         hostPath:
           path: /data/grafana/
       nodeSelector:
         app: prometheus
       securityContext:
         runAsUser: 0
       containers:
       - name: grafana
         image: grafana/grafana:7.1.1
         imagePullPolicy: IfNotPresent
         ports:
         - containerPort: 3000
           name: grafana
         env:
         - name: GF_SECURITY_ADMIN_USER
           value: admin
         - name: GF_SECURITY_ADMIN_PASSWORD
           value: admin
         readinessProbe:
           failureThreshold: 10
           httpGet:
             path: /api/health
             port: 3000
             scheme: HTTP
           initialDelaySeconds: 60
           periodSeconds: 10
           successThreshold: 1
           timeoutSeconds: 30
         livenessProbe:
           failureThreshold: 3
           httpGet:
             path: /api/health
             port: 3000
             scheme: HTTP
           periodSeconds: 10
           successThreshold: 1
           timeoutSeconds: 1
         resources:
           limits:
             cpu: 150m
             memory: 512Mi
           requests:
             cpu: 150m
             memory: 512Mi
         volumeMounts:
         - mountPath: /var/lib/grafana
           name: storage
 ---
 apiVersion: v1
 kind: Service
 metadata:
   name: grafana
   namespace: monitor
 spec:
   type: ClusterIP
   ports:
     - port: 3000
   selector:
     app: grafana
 
 ---
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: grafana
   namespace: monitor
 spec:
   rules:
   - host: grafana.luffy.com
     http:
       paths:
       - path: /
         backend:
           serviceName: grafana
           servicePort: 3000
```

配置数据源：

* URL：[http://prometheus:9090](http://prometheus:9090/)

如何丰富Grafana监控面板：

* 导入dashboard
* 安装相应的插件
* 自定义监控面板

###### 导入Dashboard的配置

dashboard： <https://grafana.com/grafana/dashboards>

* Node Exporter <https://grafana.com/grafana/dashboards/8919>
* Prometheus： <https://grafana.com/grafana/dashboards/8588>

###### DevOpsProdigy KubeGraf插件的使用

除了直接导入Dashboard，我们还可以通过安装插件的方式获得，Configuration -> Plugins可以查看已安装的插件，通过 [官方插件列表](https://grafana.com/grafana/plugins?utm_source=grafana_plugin_list) 我们可以获取更多可用插件。

Kubernetes相关的插件：

* [grafana-kubernetes-app](https://grafana.com/grafana/plugins/grafana-kubernetes-app)
* [devopsprodigy-kubegraf-app](https://grafana.com/grafana/plugins/devopsprodigy-kubegraf-app)

[DevOpsProdigy KubeGraf](https://grafana.com/grafana/plugins/devopsprodigy-kubegraf-app) 是一个非常优秀的 Grafana Kubernetes 插件，是 Grafana 官方的 Kubernetes 插件的升级版本，该插件可以用来可视化和分析 Kubernetes 集群的性能，通过各种图形直观的展示了 Kubernetes 集群的主要服务的指标和特征，还可以用于检查应用程序的生命周期和错误日志。

```plain
# 进入grafana容器内部执行安装
 $ kubectl -n monitor exec -ti grafana-594f447d6c-jmjsw bash
 bash-5.0# grafana-cli plugins install devopsprodigy-kubegraf-app 1.4.1
 installing devopsprodigy-kubegraf-app @ 1.4.1
 from: https://grafana.com/api/plugins/devopsprodigy-kubegraf-app/versions/1.4.1/download
 into: /var/lib/grafana/plugins
 
 ✔ Installed devopsprodigy-kubegraf-app successfully
 
 Restart grafana after installing plugins . <service grafana-server restart>
 
 bash-5.0# grafana-cli plugins install grafana-piechart-panel
 installing grafana-piechart-panel @ 1.5.0
 from: https://grafana.com/api/plugins/grafana-piechart-panel/versions/1.5.0/download
 into: /var/lib/grafana/plugins
 
 ✔ Installed grafana-piechart-panel successfully
 
 Restart grafana after installing plugins . <service grafana-server restart>
 
 # 也可以下载离线包进行安装
 
 # 重建pod生效
 $ kubectl -n monitor delete po grafana-594f447d6c-jmjsw
```

登录grafana界面，Configuration -> Plugins 中找到安装的插件，点击插件进入插件详情页面，点击 \[Enable]按钮启用插件，点击 Set up your first k8s-cluster 创建一个新的 Kubernetes 集群:

* Name：luffy-k8s
* URL：[https://kubernetes.default:443](https://kubernetes.default/)
* Access：使用默认的Server(default)
* Skip TLS Verify：勾选，跳过证书合法性校验
* Auth：勾选TLS Client Auth以及With CA Cert，勾选后会下面有三块证书内容需要填写，内容均来自~/.kube/config文件，需要对文件中的内容做一次base64 解码
  * CA Cert：使用config文件中的certificate-authority-data对应的内容
  * Client Cert：使用config文件中的client-certificate-data对应的内容
  * Client Key：使用config文件中的client-key-data对应的内容

###### 自定义监控面板

通用的监控需求基本上都可以使用第三方的Dashboard来解决，对于业务应用自己实现的指标的监控面板，则需要我们手动进行创建。

调试Panel：直接输入Metrics，查询数据。

如，输入node_load1来查看集群节点最近1分钟的平均负载，直接保存即可生成一个panel

如何根据字段过滤，实现联动效果？

比如想实现根据集群节点名称进行过滤，可以通过如下方式：

* 设置 -> Variables -> Add Variable，添加一个变量node，
  * Name：node
  * Label：选择节点
  * Data Source：Prometheus
  * Query：kube_node_info，可以在页面下方的Preview of values查看到当前变量的可选值
  * Regex：/.*node="(.+?)".*/
  * Refresh：On Dashboard Load
  * Multi-value：true
  * Include All Options：true
* 修改Metrics，$node和变量名字保持一致，意思为自动读取当前设置的节点的名字 node_load1{instance=~"$node"}

再添加一个面板，使用如下的表达式：

 100-avg(irate(node_cpu_seconds_total{mode="idle",instance=~"$node"}\[5m])) by (instance)\*100

###### Metrics指标类型与PromQL

TSDB的样本分布示意图：

```plain
^
   │   . . . . . . . . . . . . . . . . .   . .   node_cpu{cpu="cpu0",mode="idle"}
   │     . . . . . . . . . . . . . . . . . . .   node_cpu{cpu="cpu0",mode="system"}
   │     . . . . . . . . . .   . . . . . . . .   node_load1{}
   │     . . . . . . . . . . . . . . . .   . .   node_cpu_seconds_total{...}
   v
     <------------------ 时间 ---------------->
```

Guage类型：

```plain
$ kubectl -n monitor get po -o wide |grep k8s-master
 node-exporter-ld6sq    1/1     Running   0          4d3h    172.21.51.67   k8s-master
 $ curl -s  172.21.51.67:9100/metrics |grep node_load1
 # HELP node_load1 1m load average.
 # TYPE node_load1 gauge
 node_load1 0.18
 # HELP node_load15 15m load average.
 # TYPE node_load15 gauge
 node_load15 0.37
```

Gauge类型的指标侧重于反应系统的当前状态。

* 这类指标的样本数据可增可减。
* 常见指标如：node_memory_MemAvailable_bytes（可用内存大小）、node_load1（系统平均负载）

Guage类型的数据，通常直接查询就会有比较直观的业务含义，比如：

* node_load5
* node_memory_MemAvailable_bytes

我们也会对这类数据做简单的处理，比如：

* 过滤其中某些节点
* 对指标进行数学运算

这就是PromQL提供的能力，可以对收集到的数据做聚合、计算等处理。

PromQL（ Prometheus Query Language ）是Prometheus自定义的一套强大的数据查询语言，除了使用监控指标作为查询关键字以为，还内置了大量的函数，帮助用户进一步对时序数据进行处理。

比如：

* 只显示k8s-master节点的平均负载 node_load1{instance="k8s-master"}
* 显示除了k8s-master节点外的其他节点的平均负载 node_load1{instance!="k8s-master"}
* 正则匹配 node_load1{instance=~"k8s-master|k8s-slave1"}
* 集群各节点系统内存使用率 (node_memory_MemTotal_bytes - node_memory_MemFree_bytes) / node_memory_MemTotal_bytes

counter类型：

```plain
$ curl -s  172.21.51.67:9100/metrics |grep node_cpu_seconds_total
 # HELP node_cpu_seconds_total Seconds the cpus spent in each mode.
 # TYPE node_cpu_seconds_total counter
 node_cpu_seconds_total{cpu="0",mode="idle"} 294341.02
 node_cpu_seconds_total{cpu="0",mode="iowait"} 120.78
 node_cpu_seconds_total{cpu="0",mode="irq"} 0
 node_cpu_seconds_total{cpu="0",mode="nice"} 0.13
 node_cpu_seconds_total{cpu="0",mode="softirq"} 1263.29
```

counter类型的指标其工作方式和计数器一样，只增不减（除非系统发生重置）。常见的监控指标，如http_requests_total，node_cpu_seconds_total都是Counter类型的监控指标。

通常计数器类型的指标，名称后面都以\_total结尾。我们通过理解CPU利用率的PromQL表达式来讲解Counter指标类型的使用。

各节点CPU的平均使用率表达式：

 (1- sum(increase(node_cpu_seconds_total{mode="idle"}\[2m])) by (instance) / sum(increase(node_cpu_seconds_total{}\[2m])) by (instance)) \* 100

分析：

node_cpu_seconds_total的指标含义是统计系统运行以来，CPU资源分配的时间总数，单位为秒，是累加的值。比如，直接运行该指标：

```plain
node_cpu_seconds_total
 # 显示的是所有节点、所有CPU核心、在各种工作模式下分配的时间总和
```

其中mode的值和我们平常在系统中执行top命令看到的CPU显示的信息一致：

每个mode对应的含义如下：

* user(us) 表示用户态空间或者说是用户进程(running user space processes)使用CPU所耗费的时间。这是日常我们部署的应用所在的层面，最常见常用。
* system(sy) 表示内核态层级使用CPU所耗费的时间。分配内存、IO操作、创建子进程……都是内核操作。这也表明，当IO操作频繁时，System参数会很高。
* steal(st) 当运行在虚拟化环境中，花费在其它 OS 中的时间（基于虚拟机监视器 hypervisor 的调度）；可以理解成由于虚拟机调度器将 cpu 时间用于其它 OS 了，故当前 OS 无法使用 CPU 的时间。
* softirq(si) 从系统启动开始，累计到当前时刻，软中断时间
* irq(hi) 从系统启动开始，累计到当前时刻，硬中断时间
* nice(ni) 从系统启动开始，累计到当前时刻， 低优先级(低优先级意味着进程 nice 值小于 0)用户态的进程所占用的CPU时间
* iowait(wa) 从系统启动开始，累计到当前时刻，IO等待时间
* idle(id) 从系统启动开始，累计到当前时刻，除IO等待时间以外的其它等待时间，亦即空闲时间

我们通过指标拿到的各核心cpu分配的总时长数据，都是瞬时的数据，如何转换成 CPU的利用率？

先来考虑如何我们如何计算CPU利用率，假如我的k8s-master节点是4核CPU，我们来考虑如下场景：

* 过去1分钟内每个CPU核心处于idle状态的时长，假如分别为 :
  * cpu0：20s
  * cpu1：30s
  * cpu2：50s
  * cpu3：40s
* 则四个核心总共可分配的时长是 4\*60=240s
* 实际空闲状态的总时长为20+30+50+40=140s
* 那么我们可以计算出过去1分钟k8s-master节点的CPU利用率为 (1- 140/240) \* 100 = 41.7%

因此，我们只需要使用PromQL取出上述过程中的值即可：

```plain
# 过滤出当前时间点idle的时长
 node_cpu_seconds_total{mode="idle"}
 
 # 使用[1m]取出1分钟区间内的样本值,注意，1m区间要大于prometheus设置的抓取周期，此处会将周期内所以的样本值取出
 node_cpu_seconds_total{mode="idle"}[1m]
 
 # 使用increase方法，获取该区间内idle状态的增量值,即1分钟内，mode="idle"状态增加的时长
 increase(node_cpu_seconds_total{mode="idle"}[1m])
 
 # 由于是多个cpu核心，因此需要做累加，使用sum函数
 sum(increase(node_cpu_seconds_total{mode="idle"}[1m]))
 
 # 由于是多台机器，因此，需要按照instance的值进行分组累加，使用by关键字做分组,这样就获得了1分钟内，每个节点上 所有CPU核心idle状态的增量时长，即前面示例中的”20+30+50+40=140s“
 sum(increase(node_cpu_seconds_total{mode="idle"}[1m])) by (instance)
 
 # 去掉mode=idle的过滤条件，即可获取1分钟内，所有状态的cpu获得的增量总时长，即4*60=240s
 sum(increase(node_cpu_seconds_total{}[1m])) by (instance)
 
 # 最终的语句
 (1- sum(increase(node_cpu_seconds_total{mode="idle"}[1m])) by (instance) / sum(increase(node_cpu_seconds_total{}[1m])) by (instance)) * 100
```

除此之外，还会经常看到irate和rate方法的使用：

irate() 是基于最后两个数据点计算一个时序指标在一个范围内的每秒递增率 ，举个例子：

```plain
# 1min内，k8s-master节点的idle状态的cpu分配时长增量值
 increase(node_cpu_seconds_total{instance="k8s-master",mode="idle"}[1m])
 
 {cpu="0",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    56.5
 {cpu="1",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    56.04
 {cpu="2",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    56.6
 {cpu="3",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    56.5
 
 #以第一条数据为例，说明过去的1分钟，k8s-master节点的第一个CPU核心，有56.5秒的时长是出于idle状态的
 
 # 1min内，k8s-master节点的idle状态的cpu分配每秒的速率
 irate(node_cpu_seconds_total{instance="k8s-master",mode="idle"}[1m])
 {cpu="0",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.934
 {cpu="1",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.932
 {cpu="2",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.933
 {cpu="3",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.936
 # 该值如何计算的？
 # irate会取出样本中的最后两个点来作为增长依据，然后做差值计算，并且除以两个样本间的数据时长，也就是说，我们设置2m,5m取出来的值是一样的，因为只会计算最后两个样本差。
 # 以第一条数据为例，表示用irate计算出来的结果是，过去的两分钟内，cpu平均每秒钟有0.934秒的时间是处于idle状态的
 
 
 # rate会1min内第一个和最后一个样本值为依据，计算方式和irate保持一致
 rate(node_cpu_seconds_total{instance="k8s-master",mode="idle"}[1m])
 {cpu="0",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.933
 {cpu="1",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.940
 {cpu="2",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.935
 {cpu="3",instance="k8s-master",job="kubernetes-sd-node-exporter",mode="idle"}    0.937
```

因此rate的值，相对来讲更平滑，因为计算的是时间段内的平均，更适合于用作告警。

##### Alertmanager

Alertmanager是一个独立的告警模块。

* 接收Prometheus等客户端发来的警报
* 通过分组、删除重复等处理，并将它们通过路由发送给正确的接收器；
* 告警方式可以按照不同的规则发送给不同的模块负责人。Alertmanager支持Email, Slack，等告警方式, 也可以通过webhook接入钉钉等国内IM工具。

<!-- OCR_START -->
- prometheus server
- Alertmanager
- wechat
- 监控规则
- Router
- email
- push
- webhook
- notify
- 告警
- alerts
- Receiver
<!-- OCR_END -->

如果集群主机的内存使用率超过80%，且该现象持续了2分钟？想实现这样的监控告警，如何做？

从上图可得知设置警报和通知的主要步骤是：

* 安装和配置 Alertmanager
* 配置Prometheus与Alertmanager对话
* 在Prometheus中创建警报规则

###### 安装

Alertmanager， <https://github.com/prometheus/alertmanager#install>

 ./alertmanager --config.file=config.yml

alertmanager.yml配置文件格式：

```plain
$ cat alertmanager-config.yml
 apiVersion: v1
 data:
   config.yml: |
     global:
       # 当alertmanager持续多长时间未接收到告警后标记告警状态为 resolved
       resolve_timeout: 5m
       # 配置邮件发送信息
       smtp_smarthost: 'smtp.163.com:25'
       smtp_from: 'earlene163@163.com'
       smtp_auth_username: 'earlene163@163.com'
       smtp_auth_password: 'qzpm10'
       smtp_require_tls: false
     # 所有报警信息进入后的根路由，用来设置报警的分发策略
     route:
       # 接收到的报警信息里面有许多alertname=NodeLoadHigh 这样的标签的报警信息将会批量被聚合到一个分组里面
       group_by: ['alertname']
       # 当一个新的报警分组被创建后，需要等待至少 group_wait 时间来初始化通知，如果在等待时间内当前group接收到了新的告警，这些告警将会合并为一个通知向receiver发送
       group_wait: 30s
 
       # 相同的group发送告警通知的时间间隔
       group_interval: 30s
       # 如果一个报警信息已经发送成功了，等待 repeat_interval 时间来重新发送
       repeat_interval: 1m
 
       # 默认的receiver：如果一个报警没有被一个route匹配，则发送给默认的接收器
       receiver: default
 
       # 上面所有的属性都由所有子路由继承，并且可以在每个子路由上进行覆盖。
       routes:
       - {}
     # 配置告警接收者的信息
     receivers:
     - name: 'default'
       email_configs:
       - to: '654147123@qq.com'
         send_resolved: true  # 接受告警恢复的通知
 kind: ConfigMap
 metadata:
   name: alertmanager
   namespace: monitor
```

主要配置的作用：

* [global](https://prometheus.io/docs/alerting/configuration/#configuration-file): 全局配置，包括报警解决后的超时时间、SMTP 相关配置、各种渠道通知的 API 地址等等。
* [route](https://prometheus.io/docs/alerting/configuration/#route): 用来设置报警的分发策略，它是一个树状结构，按照深度优先从左向右的顺序进行匹配。
* [receivers](https://prometheus.io/docs/alerting/configuration/#receiver): 配置告警消息接受者信息，例如常用的 email、wechat、slack、webhook 等消息通知方式。

配置文件：

 $ kubectl create -f  alertmanager-config.yml

其他资源清单文件:

```plain
$ cat alertmanager-all.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: alertmanager
   namespace: monitor
   labels:
     app: alertmanager
 spec:
   selector:
     matchLabels:
       app: alertmanager
   template:
     metadata:
       labels:
         app: alertmanager
     spec:
       volumes:
       - name: config
         configMap:
           name: alertmanager
       containers:
       - name: alertmanager
         image: prom/alertmanager:v0.21.0
         imagePullPolicy: IfNotPresent
         args:
         - "--config.file=/etc/alertmanager/config.yml"
         - "--log.level=debug"
         ports:
         - containerPort: 9093
           name: http
         volumeMounts:
         - mountPath: "/etc/alertmanager"
           name: config
         resources:
           requests:
             cpu: 100m
             memory: 256Mi
           limits:
             cpu: 100m
             memory: 256Mi
 ---
 apiVersion: v1
 kind: Service
 metadata:
   name: alertmanager
   namespace: monitor
 spec:
   type: ClusterIP
   ports:
     - port: 9093
   selector:
     app: alertmanager
 
 ---
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: alertmanager
   namespace: monitor
 spec:
   rules:
   - host: alertmanager.luffy.com
     http:
       paths:
       - path: /
         backend:
           serviceName: alertmanager
           servicePort: 9093
```

###### 配置Prometheus与Alertmanager对话

<!-- OCR_START -->
- prometheus server
- Alertmanager
- wechat
- 监控规则
- Router
- email
- push
- webhook
- notify
- 告警
- alerts
- Receiver
<!-- OCR_END -->

是否告警是由Prometheus进行判断的，若有告警产生，Prometheus会将告警push到Alertmanager，因此，需要在Prometheus端配置alertmanager的地址：

```plain
alerting:
       alertmanagers:
       - static_configs:
         - targets:
           - alertmanager:9093
```

因此，修改Prometheus的配置文件，然后重新加载pod

```plain
# 编辑prometheus-configmap.yaml配置，添加alertmanager内容
 $ vim prometheus-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: prometheus-config
   namespace: monitor
 data:
   prometheus.yml: |
     global:
       scrape_interval: 30s
       evaluation_interval: 30s
     alerting:
       alertmanagers:
       - static_configs:
         - targets:
           - alertmanager:9093
 ...
 
 
 $ kubectl apply -f prometheus-configmap.yaml
 
 # 现在已经有监控数据了，因此使用prometheus提供的reload的接口，进行服务重启
 
 # 查看配置文件是否已经自动加载到pod中
 $ kubectl -n monitor get po -o wide
 prometheus-dcb499cbf-pljfn            1/1     Running   0          47h    10.244.1.167  
 
 $ kubectl -n monitor exec -ti prometheus-dcb499cbf-pljfn cat /etc/prometheus/prometheus.yml |grep alertmanager
 
 # 使用软加载的方式，
 $ curl -X POST 10.244.1.167:9090/-/reload
```

###### 配置报警规则

目前Prometheus与Alertmanager已经连通，接下来我们可以针对收集到的各类指标配置报警规则，一旦满足报警规则的设置，则Prometheus将报警信息推送给Alertmanager，进而转发到我们配置的邮件中。

在哪里配置？同样是在prometheus-configmap中：

```plain
$ vim prometheus-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: prometheus-config
   namespace: monitor
 data:
   prometheus.yml: |
     global:
       scrape_interval: 30s
       evaluation_interval: 30s
     alerting:
       alertmanagers:
       - static_configs:
         - targets:
           - alertmanager:9093
     # Load rules once and periodically evaluate them according to the global  'evaluation_interval'.
     rule_files:
       - /etc/prometheus/alert_rules.yml
       # - "first_rules.yml"
       # - "second_rules.yml"
     scrape_configs:
     - job_name: 'prometheus'
       static_configs:
       - targets: ['localhost:9090']
 ...
```

rules.yml我们同样使用configmap的方式挂载到prometheus容器内部，因此只需要在已有的configmap中加一个数据项目

```plain
$ vim prometheus-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: prometheus-config
   namespace: monitor
 data:
   prometheus.yml: |
     global:
       scrape_interval: 30s
       evaluation_interval: 30s
     alerting:
       alertmanagers:
       - static_configs:
         - targets:
           - alertmanager:9093
     # Load rules once and periodically evaluate them according to the global  'evaluation_interval'.
     rule_files:
       - /etc/prometheus/alert_rules.yml
       # - "first_rules.yml"
       # - "second_rules.yml"
     scrape_configs:
     - job_name: 'prometheus'
       static_configs:
       - targets: ['localhost:9090']
 ... # 省略中间部分
   alert_rules.yml: |
     groups:
     - name: node_metrics
       rules:
       - alert: NodeLoad
         expr: node_load15 < 1
         for: 2m
         annotations:
           summary: "{{$labels.instance}}: Low node load detected"
           description: "{{$labels.instance}}: node load is below 1 (current value is: {{ $value }}"
```

告警规则的几个要素：

* group.name：告警分组的名称，一个组下可以配置一类告警规则，比如都是物理节点相关的告警
* alert：告警规则的名称
* expr：是用于进行报警规则 PromQL 查询语句，expr通常是布尔表达式，可以让Prometheus根据计算的指标值做 true or false 的判断
* for：评估等待时间（Pending Duration），用于表示只有当触发条件持续一段时间后才发送告警，在等待期间新产生的告警状态为pending，屏蔽掉瞬时的问题，把焦点放在真正有持续影响的问题上
* labels：自定义标签，允许用户指定额外的标签列表，把它们附加在告警上，可以用于后面做路由判断，通知到不同的终端，通常被用于添加告警级别的标签
* annotations：指定了另一组标签，它们不被当做告警实例的身份标识，它们经常用于存储一些额外的信息，用于报警信息的展示之类的

规则配置中，支持模板的方式，其中：

* {{$labels}}可以获取当前指标的所有标签，支持{{$labels.instance}}或者{{$labels.job}}这种形式
* {{ $value }}可以获取当前计算出的指标值

更新配置并软重启，并查看Prometheus报警规则。

一个报警信息在生命周期内有下面3种状态：

* inactive: 表示当前报警信息处于非活动状态，即不满足报警条件
* pending: 表示在设置的阈值时间范围内被激活了，即满足报警条件，但是还在观察期内
* firing: 表示超过设置的阈值时间被激活了，即满足报警条件，且报警触发时间超过了观察期，会发送到Alertmanager端

对于已经 pending 或者 firing 的告警，Prometheus 也会将它们存储到时间序列ALERTS{}中。当然我们也可以通过表达式去查询告警实例：

` ALERTS{}`

查看Alertmanager日志：

```yaml
level=warn ts=2020-07-28T13:43:59.430Z caller=notify.go:674 component=dispatcher receiver=email integration=email[0] msg="Notify attempt failed, will retry later" attempts=1 err="*email.loginAuth auth: 550 User has no permission"

```

说明告警已经推送到Alertmanager端了，但是邮箱登录的时候报错，这是因为邮箱默认没有开启第三方客户端登录。因此需要登录163邮箱设置SMTP服务允许客户端登录。

###### 自定义webhook实现告警消息的推送

目前官方内置的第三方通知集成包括：邮件、 即时通讯软件（如Slack、Hipchat）、移动应用消息推送(如Pushover)和自动化运维工具（例如：Pagerduty、Opsgenie、Victorops）。可以在alertmanager的管理界面中查看到。

每一个receiver具有一个全局唯一的名称，并且对应一个或者多个通知方式：

```plain
name: <string>
 email_configs:
   [ - <email_config>, ... ]
 hipchat_configs:
   [ - <hipchat_config>, ... ]
 slack_configs:
   [ - <slack_config>, ... ]
 opsgenie_configs:
   [ - <opsgenie_config>, ... ]
 webhook_configs:
   [ - <webhook_config>, ... ]
```

如果想实现告警消息推送给企业常用的即时聊天工具，如钉钉或者企业微信，如何配置？

Alertmanager的通知方式中还可以支持Webhook，通过这种方式开发者可以实现更多个性化的扩展支持。

```plain
# 警报接收者
 receivers:
 #ops 
 - name: 'demo-webhook'
   webhook_configs:
   - send_resolved: true
     url: http://demo-webhook/alert/send
```

当我们配置了上述webhook地址，则当告警路由到demo-webhook时，alertmanager端会向webhook地址推送POST请求：

```plain
$ curl -X POST -d"$demoAlerts"  http://demo-webhook/alert/send
 $ echo $demoAlerts
 {
   "version": "4",
   "groupKey": <string>, alerts (e.g. to deduplicate) ,
   "status": "<resolved|firing>", 
   "receiver": <string>, 
   "groupLabels": <object>, 
   "commonLabels": <object>, 
   "commonAnnotations": <object>, 
   "externalURL": <string>, // backlink to the Alertmanager. 
   "alerts": 
    [{ 
      "labels": <object>, 
       "annotations": <object>, 
       "startsAt": "<rfc3339>", 
       "endsAt": "<rfc3339>" 
    }] 
 }
```

因此，假如我们想把报警消息自动推送到钉钉群聊，只需要：

* 实现一个webhook，部署到k8s集群
  * 接收POST请求，将Alertmanager传过来的数据做解析，调用dingtalk的API，实现消息推送
* 配置alertmanager的receiver为webhook地址

如何给钉钉群聊发送消息？ 钉钉机器人

钉钉群聊机器人设置：

每个群聊机器人在创建的时候都会生成唯一的一个访问地址：

```yaml
https://oapi.dingtalk.com/robot/send?access_token=e54f616718798e32d1e2ff1af5b095c37501878f816bdab2daf66d390633843a

```

这样，我们就可以使用如下方式来模拟给群聊机器人发送请求，实现消息的推送：

```plain
curl 'https://oapi.dingtalk.com/robot/send?access_token=e54f616718798e32d1e2ff1af5b095c37501878f816bdab2daf66d390633843a' \
    -H 'Content-Type: application/json' \
    -d '{"msgtype": "text","text": {"content": "我就是我, 是不一样的烟火"}}'
```

<https://gitee.com/agagin/prometheus-webhook-dingtalk>

镜像地址：timonwong/prometheus-webhook-dingtalk:master

二进制运行：

```yaml
$ ./prometheus-webhook-dingtalk --config.file=config.yml

```

假如使用如下配置：

```plain
targets:
   webhook_dev:
     url: https://oapi.dingtalk.com/robot/send?access_token=e54f616718798e32d1e2ff1af5b095c37501878f816bdab2daf66d390633843a
   webhook_ops:
     url: https://oapi.dingtalk.com/robot/send?access_token=d4e7b72eab6d1b2245bc0869d674f627dc187577a3ad485d9c1d131b7d67b15b
```

则prometheus-webhook-dingtalk启动后会自动支持如下API的POST访问：

```plain
http://locahost:8060/dingtalk/webhook_dev/send
 http://localhost:8060/dingtalk/webhook_ops/send
```

这样可以使用一个prometheus-webhook-dingtalk来实现多个钉钉群的webhook地址

部署prometheus-webhook-dingtalk，从Dockerfile可以得知需要注意的点：

* 默认使用配置文件/etc/prometheus-webhook-dingtalk/config.yml，可以通过configmap挂载
* 该目录下还有模板文件，因此需要使用subpath的方式挂载
* 部署Service，作为Alertmanager的默认访问，服务端口默认8060

配置文件：

```plain
$ cat webhook-dingtalk-configmap.yaml
 apiVersion: v1
 data:
   config.yml: |
     targets:
       webhook_dev:
         url: https://oapi.dingtalk.com/robot/send?access_token=e54f616718798e32d1e2ff1af5b095c37501878f816bdab2daf66d390633843a
 kind: ConfigMap
 metadata:
   name: webhook-dingtalk-config
   namespace: monitor
```

Deployment和Service

```plain
$ cat webhook-dingtalk-deploy.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: webhook-dingtalk
   namespace: monitor
 spec:
   selector:
     matchLabels:
       app: webhook-dingtalk
   template:
     metadata:
       labels:
         app: webhook-dingtalk
     spec:
       containers:
       - name: webhook-dingtalk
         image: timonwong/prometheus-webhook-dingtalk:master
         imagePullPolicy: IfNotPresent
         volumeMounts:
         - mountPath: "/etc/prometheus-webhook-dingtalk/config.yml"
           name: config
           subPath: config.yml
         ports:
         - containerPort: 8060
           name: http
         resources:
           requests:
             cpu: 50m
             memory: 100Mi
           limits:
             cpu: 50m
             memory: 100Mi
       volumes:
       - name: config
         configMap:
           name: webhook-dingtalk-config
           items:
           - key: config.yml
             path: config.yml
 ---
 apiVersion: v1
 kind: Service
 metadata:
   name: webhook-dingtalk
   namespace: monitor
 spec:
   selector:
     app: webhook-dingtalk
   ports:
   - name: hook
     port: 8060
     targetPort: http
```

创建：

```plain
$ kubectl create -f webhook-dingtalk-configmap.yaml
 $ kubectl create -f webhook-dingtalk-deploy.yaml
 
 # 查看日志，可以得知当前的可用webhook日志
 $ kubectl -n monitor logs -f webhook-dingtalk-f7f5589c9-qglkd
 ...
 file=/etc/prometheus-webhook-dingtalk/config.yml msg="Completed loading of configuration file"
 level=info ts=2020-07-30T14:05:40.963Z caller=main.go:117 component=configuration msg="Loading templates" templates=
 ts=2020-07-30T14:05:40.963Z caller=main.go:133 component=configuration msg="Webhook urls for prometheus alertmanager" urls="http://localhost:8060/dingtalk/webhook_dev/send http://localhost:8060/dingtalk/webhook_ops/send"
 level=info ts=2020-07-30T14:05:40.963Z caller=web.go:210 component=web msg="Start listening for connections" address=:8060
```

修改Alertmanager路由及webhook配置：

```plain
$ cat alertmanager-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: alertmanager
   namespace: monitor
 data:
   config.yml: |-
     global:
       # 当alertmanager持续多长时间未接收到告警后标记告警状态为 resolved
       resolve_timeout: 5m
       # 配置邮件发送信息
       smtp_smarthost: 'smtp.163.com:25'
       smtp_from: 'earlene163@163.com'
       smtp_auth_username: 'earlene163@163.com'
       # 注意这里不是邮箱密码，是邮箱开启第三方客户端登录后的授权码
       smtp_auth_password: 'GXIWNXKMMEVMNHAJ'
       smtp_require_tls: false
     # 所有报警信息进入后的根路由，用来设置报警的分发策略
     route:
       # 按照告警名称分组
       group_by: ['alertname']
       # 当一个新的报警分组被创建后，需要等待至少 group_wait 时间来初始化通知，这种方式可以确保您能有足够的时间为同一分组来获取多个警报，然后一起触发这个报警信息。
       group_wait: 30s
 
       # 相同的group之间发送告警通知的时间间隔
       group_interval: 30s
 
       # 如果一个报警信息已经发送成功了，等待 repeat_interval 时间来重新发送他们，不同类型告警发送频率需要具体配置
       repeat_interval: 10m
 
       # 默认的receiver：如果一个报警没有被一个route匹配，则发送给默认的接收器
       receiver: default
 
       # 路由树，默认继承global中的配置，并且可以在每个子路由上进行覆盖。
       routes:
       - {}
     receivers:
     - name: 'default'
       email_configs:
       - to: '654147123@qq.com'
         send_resolved: true  # 接受告警恢复的通知
       webhook_configs:
       - send_resolved: true
         url: http://webhook-dingtalk:8060/dingtalk/webhook_dev/send
```

验证钉钉消息是否正常收到。

###### 基于Label的动态告警处理

真实的场景中，我们往往期望可以给告警设置级别，而且可以实现不同的报警级别可以由不同的receiver接收告警消息。

Alertmanager中路由负责对告警信息进行分组匹配，并向告警接收器发送通知。告警接收器可以通过以下形式进行配置：

```plain
routes:
 - receiver: ops
   group_wait: 10s
   match:
     severity: critical
 - receiver: dev
   group_wait: 10s
   match_re:
     severity: normal|middle
 receivers:
   - ops
     ...
   - dev
     ...
   - <receiver> ...
```

因此可以为了更全面的感受报警的逻辑，我们再添加两个报警规则：

```plain
alert_rules.yml: |
     groups:
     - name: node_metrics
       rules:
       - alert: NodeLoad
         expr: node_load15 < 1
         for: 2m
         labels:
           severity: normal
         annotations:
           summary: "{{$labels.instance}}: Low node load detected"
           description: "{{$labels.instance}}: node load is below 1 (current value is: {{ $value }}"
       - alert: NodeMemoryUsage
         expr: (node_memory_MemTotal_bytes - (node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes)) / node_memory_MemTotal_bytes * 100 > 40
         for: 2m
         labels:
           severity: critical
         annotations:
           summary: "{{$labels.instance}}: High Memory usage detected"
           description: "{{$labels.instance}}: Memory usage is above 40% (current value is: {{ $value }}"
     - name: targets_status
       rules:
       - alert: TargetStatus
         expr: up == 0
         for: 1m
         labels:
           severity: critical
         annotations:
           summary: "{{$labels.instance}}: prometheus target down"
           description: "{{$labels.instance}}: prometheus target down，job is {{$labels.job}}"
```

我们为不同的报警规则设置了不同的标签，如severity: critical，针对规则中的label，来配置alertmanager路由规则，实现转发给不同的接收者。

```plain
$ cat alertmanager-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: alertmanager
   namespace: monitor
 data:
   config.yml: |-
     global:
       # 当alertmanager持续多长时间未接收到告警后标记告警状态为 resolved
       resolve_timeout: 5m
       # 配置邮件发送信息
       smtp_smarthost: 'smtp.163.com:25'
       smtp_from: 'earlene163@163.com'
       smtp_auth_username: 'earlene163@163.com'
       # 注意这里不是邮箱密码，是邮箱开启第三方客户端登录后的授权码
       smtp_auth_password: 'RMAOPQVHKLPYFVHZ'
       smtp_require_tls: false
     # 所有报警信息进入后的根路由，用来设置报警的分发策略
     route:
       # 按照告警名称分组
       group_by: ['alertname']
       # 当一个新的报警分组被创建后，需要等待至少 group_wait 时间来初始化通知，这种方式可以确保您能有足够的时间为同一分组来获取多个警报，然后一起触发这个报警信息。
       group_wait: 30s
 
       # 相同的group之间发送告警通知的时间间隔
       group_interval: 30s
 
       # 如果一个报警信息已经发送成功了，等待 repeat_interval 时间来重新发送他们，不同类型告警发送频率需要具体配置
       repeat_interval: 1m
 
       # 默认的receiver：如果一个报警没有被一个route匹配，则发送给默认的接收器
       receiver: default
 
       # 路由树，默认继承global中的配置，并且可以在每个子路由上进行覆盖。
       routes:
       - receiver: critical_alerts
         group_wait: 10s
         match:
           severity: critical
       - receiver: normal_alerts
         group_wait: 10s
         match_re:
           severity: normal|middle
     receivers:
     - name: 'default'
       email_configs:
       - to: '654147123@qq.com'
         send_resolved: true  # 接受告警恢复的通知
     - name: 'critical_alerts'
       webhook_configs:
       - send_resolved: true
         url: http://webhook-dingtalk:8060/dingtalk/webhook_ops/send
     - name: 'normal_alerts'
       webhook_configs:
       - send_resolved: true
         url: http://webhook-dingtalk:8060/dingtalk/webhook_dev/send
```

再配置一个钉钉机器人，修改webhook-dingtalk的配置，添加webhook_ops的配置：

```plain
$ cat webhook-dingtalk-configmap.yaml
 apiVersion: v1
 data:
   config.yml: |
     targets:
       webhook_dev:
         url: https://oapi.dingtalk.com/robot/send?access_token=e54f616718798e32d1e2ff1af5b095c37501878f816bdab2daf66d390633843a
       webhook_ops:
         url: https://oapi.dingtalk.com/robot/send?access_token=5a68888fbecde75b1832ff024d7374e51f2babd33f1078e5311cdbb8e2c00c3a
 kind: ConfigMap
 metadata:
   name: webhook-dingtalk-config
   namespace: monitor
```

设置webhook-dingtalk开启lifecycle

分别更新Prometheus和Alertmanager配置，查看报警的发送。

###### 抑制和静默

前面我们知道，告警的group(分组)功能通过把多条告警数据聚合，有效的减少告警的频繁发送。除此之外，Alertmanager还支持Inhibition(抑制) 和 Silences(静默)，帮助我们抑制或者屏蔽报警。

* Inhibition 抑制抑制是当出现其它告警的时候压制当前告警的通知，可以有效的防止告警风暴。比如当机房出现网络故障时，所有服务都将不可用而产生大量服务不可用告警，但这些警告并不能反映真实问题在哪，真正需要发出的应该是网络故障告警。当出现网络故障告警的时候，应当抑制服务不可用告警的通知。在Alertmanager配置文件中，使用inhibit_rules定义一组告警的抑制规则：

```plain
inhibit_rules:
   [ - <inhibit_rule> ... ]
```

每一条抑制规则的具体配置如下：

当已经发送的告警通知匹配到target_match或者target_match_re规则，当有新的告警规则如果满足source_match或者定义的匹配规则，并且已发送的告警与新产生的告警中equal定义的标签完全相同，则启动抑制机制，新的告警不会发送。

例如，定义如下抑制规则：

如当集群中的某一个主机节点异常宕机导致告警NodeDown被触发，同时在告警规则中定义了告警级别severity=critical。由于主机异常宕机，该主机上部署的所有服务，中间件会不可用并触发报警。根据抑制规则的定义，如果有新的告警级别为severity=critical，并且告警中标签node的值与NodeDown告警的相同，则说明新的告警是由NodeDown导致的，则启动抑制机制停止向接收器发送通知。

演示：实现如果 NodeMemoryUsage 报警触发，则抑制NodeLoad指标规则引起的报警。

* Silences： 静默简单直接的在指定时段关闭告警。静默通过匹配器（Matcher）来配置，类似于路由树。警告进入系统的时候会检查它是否匹配某条静默规则，如果是则该警告的通知将忽略。 静默规则在Alertmanager的 Web 界面里配置。

一条告警产生后，还要经过 Alertmanager 的分组、抑制处理、静默处理、去重处理和降噪处理最后再发送给接收者。这个过程中可能会因为各种原因会导致告警产生了却最终没有进行通知，可以通过下图了解整个告警的生命周期：

<!-- OCR_START -->
- 警报
- AlertGroup
- Firing
- 定时产生通知
- Pending
- Inhibitor
- Alert
- Silence
- Router
- Inactive
- Dedup
- 40s80s120s160s200s240s
- 280s320s_360s
- Send
- 该规则每 40 秒计算一次，预设的 Pending 时间为 60 秒
- 通知处理管线
- 上图中有一个警报对象，时间范围是[160s，360s]
<!-- OCR_END -->

<https://github.com/liyongxin/prometheus-webhook-wechat>

##### 自定义指标实现业务伸缩

###### Kubernetes Metrics API体系回顾

前面章节，我们讲过基于CPU和内存的HPA，即利用metrics-server及HPA，可以实现业务服务可以根据pod的cpu和内存进行弹性伸缩。

<!-- OCR_START -->
- Metrics
- HorizontalPodAutoscaler
- aggregator
- server
- Deployment
- Prometheus
- cAdvisor
- adapter
- kubelet
- ReplicaSet
- Pod
- s://blog.csdn.net/fly910905
<!-- OCR_END -->

k8s对监控接口进行了标准化：

* Resource Metrics对应的接口是 metrics.k8s.io，主要的实现就是 metrics-server
* Custom Metrics对应的接口是 custom.metrics.k8s.io，主要的实现是 Prometheus， 它提供的是资源监控和自定义监控

安装完metrics-server后，利用kube-aggregator的功能，实现了metrics api的注册。可以通过如下命令

```plain
$ kubectl api-versions
 ...
 metrics.k8s.io/v1beta1
```

HPA通过使用该API获取监控的CPU和内存资源：

```plain
# 查询nodes节点的cpu和内存数据
 $ kubectl get --raw="/apis/metrics.k8s.io/v1beta1/nodes"|jq
 
 $ kubectl get --raw="/apis/metrics.k8s.io/v1beta1/pods"|jq
 
 # 若本机没有安装jq命令，可以参考如下方式进行安装
 $ wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
 $ rpm -ivh epel-release-latest-7.noarch.rpm
 $ yum install -y jq
```

同样，为了实现通用指标的采集，需要部署Prometheus Adapter，来提供custom.metrics.k8s.io，作为HPA获取通用指标的入口。

###### Adapter安装对接

项目地址为： <https://github.com/DirectXMan12/k8s-prometheus-adapter>

```plain
$ git clone https://github.com/DirectXMan12/k8s-prometheus-adapter.git
 
 # 最新release版本v0.7.0，代码切换到v0.7.0分支
 $ git checkout v0.7.0
```

查看部署说明 <https://github.com/DirectXMan12/k8s-prometheus-adapter/tree/v0.7.0/deploy>

1. 镜像使用官方提供的v0.7.0最新版 <https://hub.docker.com/r/directxman12/k8s-prometheus-adapter/tags>
2. 准备证书

```plain
$ export PURPOSE=serving
 $ openssl req -x509 -sha256 -new -nodes -days 365 -newkey rsa:2048 -keyout ${PURPOSE}.key -out ${PURPOSE}.crt -subj "/CN=ca"
 
 $ kubectl -n monitor create secret generic cm-adapter-serving-certs --from-file=./serving.crt --from-file=./serving.key 
 
 # 查看证书
 $ kubectl -n monitor describe secret cm-adapter-serving-certs
```

1. 准备资源清单

```plain
$ mkdir yamls
 $ cp manifests/custom-metrics-apiserver-deployment.yaml yamls/
 $ cp manifests/custom-metrics-apiserver-service.yaml yamls/
 $ cp manifests/custom-metrics-apiservice.yaml yamls/
 
 $ cd yamls
 # 新建rbac文件
 $ vi custom-metrics-apiserver-rbac.yaml
 kind: ServiceAccount
 apiVersion: v1
 metadata:
   name: custom-metrics-apiserver
   namespace: monitor
 ---
 apiVersion: rbac.authorization.k8s.io/v1
 kind: ClusterRoleBinding
 metadata:
   name: custom-metrics-resource-cluster-admin
 roleRef:
   apiGroup: rbac.authorization.k8s.io
   kind: ClusterRole
   name: cluster-admin
 subjects:
 - kind: ServiceAccount
   name: custom-metrics-apiserver
   namespace: monitor
 
 # 新建配置文件
 $ vi custom-metrics-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: adapter-config
   namespace: monitor
 data:
   config.yaml: |
     rules:
     - {}
```

2. 替换命名空间

```plain
# 资源清单文件默认用的命名空间是custom-metrics，替换为本例中使用的monitor
 $ sed -i 's/namespace: custom-metrics/namespace: monitor/g' yamls/*
```

3. 配置adapter对接的Prometheus地址

```plain
# 由于adapter会和Prometheus交互，因此需要配置对接的Prometheus地址
 # 替换掉28行：yamls/custom-metrics-apiserver-deployment.yaml 中的--prometheus-url
 $ vim yamls/custom-metrics-apiserver-deployment.yaml
 ...
      18     spec:
      19       serviceAccountName: custom-metrics-apiserver
      20       containers:
      21       - name: custom-metrics-apiserver
      22         image: directxman12/k8s-prometheus-adapter-amd64
      23         args:
      24         - --secure-port=6443
      25         - --tls-cert-file=/var/run/serving-cert/serving.crt
      26         - --tls-private-key-file=/var/run/serving-cert/serving.key
      27         - --logtostderr=true
      28         - --prometheus-url=http://prometheus:9090/
      29         - --metrics-relist-interval=1m
      30         - --v=10
      31         - --config=/etc/adapter/config.yaml
 ...
```

1. 部署服务 

```yaml
$ kubectl create -f yamls/
```

验证一下：

```plain
$ kubectl api-versions 
 custom.metrics.k8s.io/v1beta1
 
 $ kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1 |jq
 {                                                    
   "kind": "APIResourceList",                         
   "apiVersion": "v1",                                
   "groupVersion": "custom.metrics.k8s.io/v1beta1",   
   "resources": []                                    
 }
```

###### 通用指标示例程序部署

<!-- OCR_START -->
- Metrics
- HorizontalPodAutoscaler
- aggregator
- server
- Deployment
- Prometheus
- cAdvisor
- adapter
- kubelet
- ReplicaSet
- Pod
- s://blog.csdn.net/fly910905
<!-- OCR_END -->

为了演示效果，我们新建一个deployment来模拟业务应用。

```plain
$ cat custom-metrics-demo.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: custom-metrics-demo
 spec:
   selector:
     matchLabels:
       app: custom-metrics-demo
   template:
     metadata:
       labels:
         app: custom-metrics-demo
     spec:
       containers:
       - name: custom-metrics-demo
         image: cnych/nginx-vts:v1.0
         resources:
           limits:
             cpu: 50m
           requests:
             cpu: 50m
         ports:
         - containerPort: 80
           name: http
```

部署：

```plain
$ kubectl create -f custom-metrics-demo.yaml
 
 $ kubectl get po -o wide
 custom-metrics-demo-95b5bc949-xpppl   1/1     Running   0          65s   10.244.1.194
 
 $ curl 10.244.1.194/status/format/prometheus
 ...
 nginx_vts_server_requests_total{host="*",code="1xx"} 0
 nginx_vts_server_requests_total{host="*",code="2xx"} 8
 nginx_vts_server_requests_total{host="*",code="3xx"} 0
 nginx_vts_server_requests_total{host="*",code="4xx"} 0
 nginx_vts_server_requests_total{host="*",code="5xx"} 0
 nginx_vts_server_requests_total{host="*",code="total"} 8
 ...
```

注册为Prometheus的target：

```plain
$ cat custom-metrics-demo-svc.yaml
 apiVersion: v1
 kind: Service
 metadata:
   name: custom-metrics-demo
   annotations:
     prometheus.io/scrape: "true"
     prometheus.io/port: "80"
     prometheus.io/path: "/status/format/prometheus"
 spec:
   ports:
   - port: 80
     targetPort: 80
     name: http
   selector:
     app: custom-metrics-demo
   type: ClusterIP
```

自动注册为Prometheus的采集Targets。

通常web类的应用，会把每秒钟的请求数作为业务伸缩的指标依据。

实践：

使用案例应用custom-metrics-demo，如果custom-metrics-demo最近2分钟内每秒钟的请求数超过10次，则自动扩充业务应用的副本数。

* 配置自定义指标告诉Adapter去采集转换哪些指标，Adapter支持转换的指标，才可以作为HPA的依据
* 配置HPA规则

```plain
apiVersion: autoscaling/v2beta1
 kind: HorizontalPodAutoscaler
 metadata:
   name: nginx-custom-hpa
   namespace: default
 spec:
   scaleTargetRef:
     apiVersion: apps/v1
     kind: Deployment
     name: custom-metrics-demo
   minReplicas: 1
   maxReplicas: 3
   metrics:
   - type: Pods
     pods:
       metricName: nginx_vts_server_requests_per_second
       targetAverageValue: 10
```

###### Adapter配置自定义指标

<!-- OCR_START -->
- HPA
- custom/metrics.k8s.io/v1beta1
- Custom Metrics
- API
- Prometheus
- /metrics
- Pods
- nttps://blog.csdn.net/weixin_39961559
<!-- OCR_END -->

思考：

前面讲CPU的平均使用率的采集，其实是通过node_cpu_seconds_total指标计算得到的。

```plain
^
   │   . . . . . . . . . . . . . . . . .   . .   node_cpu{cpu="cpu0",mode="idle"}
   │     . . . . . . . . . . . . . . . . . . .   node_cpu{cpu="cpu0",mode="system"}
   │     . . . . . . . . . .   . . . . . . . .   node_load1{}
   │     . . . . . . . . . . . . . . . .   . .   node_cpu_seconds_total{...}
   v
     <------------------ 时间 ---------------->
```

同样，如果想获得每个业务应用最近2分钟内每秒的访问次数，也是根据总数来做计算，因此，需要使用业务自定义指标nginx_vts_server_requests_total，配合rate方法即可获取每秒钟的请求数。

```plain
rate(nginx_vts_server_requests_total[2m])
 
 # 如查询有多条数据，需做汇聚，需要使用sum
 sum(rate(nginx_vts_server_requests_total[2m])) by(kubernetes_pod_name)
```

1. 自定义指标可以配置多个，因此，需要将规则使用数组来配置

```plain
rules:
 - {}
```

2. 告诉Adapter，哪些自定义指标可以使用

```plain
rules:
 - seriesQuery: 'nginx_vts_server_requests_total{host="*",code="total"}'
```

seriesQuery是PromQL语句，和直接用nginx_vts_server_requests_total查询到的结果一样，凡是seriesQuery可以查询到的指标，都可以用作自定义指标

3. 告诉Adapter，指标中的标签和k8s中的资源对象的关联关系

```plain
rules:
 - seriesQuery: 'nginx_vts_server_requests_total{host="*",code="total"}'
   resources:
     overrides:
       kubernetes_namespace: {resource: "namespace"}
       kubernetes_pod_name: {resource: "pod"}
```

我们查询到的可用指标格式为：

```yaml
nginx_vts_server_requests_total{code="1xx",host="*",instance="10.244.1.194:80",job="kubernetes-sd-endpoints",kubernetes_name="custom-metrics-demo",kubernetes_namespace="default",kubernetes_pod_name="custom-metrics-demo-95b5bc949-xpppl"}

```

由于HPA在调用Adapter接口的时候，告诉Adapter的是查询哪个命名空间下的哪个Pod的指标，因此，Adapter在去查询的时候，需要做一层适配转换（因为并不是每个prometheus查询到的结果中都是叫做kubernetes_namespace和kubernetes_pod_name）

4. 指定自定义的指标名称，供HPA配置使用

```plain
rules:
 - seriesQuery: 'nginx_vts_server_requests_total{host="*",code="total"}'
   resources:
     overrides:
       kubernetes_namespace: {resource: "namespace"}
       kubernetes_pod_name: {resource: "pods"}
   name:
     matches: "^(.*)_total"
     as: "${1}_per_second"
```

因为Adapter转换完之后的指标含义为：每秒钟的请求数。因此提供指标名称，该配置根据正则表达式做了匹配替换，转换完后的指标名称为：nginx_vts_server_requests_per_second，HPA规则中可以直接配置该名称。

5. 告诉Adapter如何获取最终的自定义指标值

```plain
rules:
 - seriesQuery: 'nginx_vts_server_requests_total{host="*",code="total"}'
   resources:
     overrides:
       kubernetes_namespace: {resource: "namespace"}
       kubernetes_pod_name: {resource: "pod"}
   name:
     matches: "^(.*)_total"
     as: "${1}_per_second"
   metricsQuery: 'sum(rate(<<.Series>>{<<.LabelMatchers>>}[2m])) by (<<.GroupBy>>)'
```

我们最终期望的写法可能是这样：

```yaml
sum(rate(nginx_vts_server_requests_total{host="*",code="total",kubernetes_namespace="default"}[2m])) by (kubernetes_pod_name)

```

但是Adapter提供了更简单的写法：

```yaml
sum(rate(<<.Series>>{<<.LabelMatchers>>}[2m])) by (<<.GroupBy>>)

```

```
- <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Series</font><font style="color:rgb(52, 73, 94);">: 指标名称</font>
- <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">LabelMatchers</font><font style="color:rgb(52, 73, 94);">: 指标查询的label</font>
- <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">GroupBy</font><font style="color:rgb(52, 73, 94);">: 结果分组，针对HPA过来的查询，都会匹配成</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">kubernetes_pod_name</font>
```

更新Adapter的配置：

```plain
$ vi custom-metrics-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: adapter-config
   namespace: monitor
 data:
   config.yaml: |
     rules:
     - seriesQuery: 'nginx_vts_server_requests_total{host="*",code="total"}'
       seriesFilters: []
       resources:
         overrides:
           kubernetes_namespace: {resource: "namespace"}
           kubernetes_pod_name: {resource: "pod"}
       name:
         matches: "^(.*)_total"
         as: "${1}_per_second"
       metricsQuery: (sum(rate(<<.Series>>{<<.LabelMatchers>>}[1m])) by (<<.GroupBy>>))
```

需要更新configmap并重启adapter服务：

```plain
$ kubectl apply -f custom-metrics-configmap.yaml
 
 $ kubectl -n monitor delete po custom-metrics-apiserver-c689ff947-zp8gq
```

再次查看可用的指标数据：

```plain
$ kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1 |jq
 {
   "kind": "APIResourceList",
   "apiVersion": "v1",
   "groupVersion": "custom.metrics.k8s.io/v1beta1",
   "resources": [
     {
       "name": "namespaces/nginx_vts_server_requests_per_second",
       "singularName": "",
       "namespaced": false,
       "kind": "MetricValueList",
       "verbs": [
         "get"
       ]
     },
     {
       "name": "pods/nginx_vts_server_requests_per_second",
       "singularName": "",
       "namespaced": true,
       "kind": "MetricValueList",
       "verbs": [
         "get"
       ]
     }
   ]
 }
```

我们发现有两个可用的resources，引用官方的一段解释：

```plain
Notice that we get an entry for both "pods" and "namespaces" -- the adapter exposes the metric on each resource that we've associated the metric with (and all namespaced resources must be associated with a namespace), and will fill in the <<.GroupBy>> section with the appropriate label depending on which we ask for.
 
 We can now connect to $KUBERNETES/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/*/nginx_vts_server_requests_per_second, and we should see
 $ kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/*/nginx_vts_server_requests_per_second" | jq 
 {
   "kind": "MetricValueList",
   "apiVersion": "custom.metrics.k8s.io/v1beta1",
   "metadata": {
     "selfLink": "/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/%2A/nginx_vts_server_requests_per_second"
   },
   "items": [
     {
       "describedObject": {
         "kind": "Pod",
         "namespace": "default",
         "name": "custom-metrics-demo-95b5bc949-xpppl",
         "apiVersion": "/v1"
       },
       "metricName": "nginx_vts_server_requests_per_second",
       "timestamp": "2020-08-02T04:07:06Z",
       "value": "133m",
       "selector": null
     }
   ]
 }
```

其中133m等于0.133，即当前指标查询每秒钟请求数为0.133次

<https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/config-walkthrough.md>

<https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/config.md>

###### 配置HPA实现自定义指标的业务伸缩

```plain
$ cat hpa-custom-metrics.yaml
 apiVersion: autoscaling/v2beta1
 kind: HorizontalPodAutoscaler
 metadata:
   name: nginx-custom-hpa
 spec:
   scaleTargetRef:
     apiVersion: apps/v1
     kind: Deployment
     name: custom-metrics-demo
   minReplicas: 1
   maxReplicas: 3
   metrics:
   - type: Pods
     pods:
       metricName: nginx_vts_server_requests_per_second
       targetAverageValue: 10
 
 $ kubectl create -f hpa-custom-metrics.yaml
 
 $ kubectl get hpa
```

注意metricName为自定义的指标名称。

使用ab命令压测custom-metrics-demo服务，观察hpa的变化：

```plain
$ kubectl get svc -o wide
 custom-metrics-demo   ClusterIP   10.104.110.245   <none>        80/TCP    16h
 
 $ ab -n1000 -c 5 http://10.104.110.245:80/
```

观察hpa变化:

 $ kubectl describe hpa nginx-custom-hpa

查看adapter日志：

```plain
$ kubectl -n monitor logs --tail=100 -f custom-metrics-apiserver-c689ff947-m5vlr
 ...
 I0802 04:43:58.404559       1 httplog.go:90] GET /apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/%2A/nginx_vts_server_requests_per_second?labelSelector=app%3Dcustom-metrics-demo: (20.713209ms) 200 [kube-controller-manager/v1.16.0 (linux/amd64) kubernetes/2bd9643/system:serviceaccount:kube-system:horizontal-pod-autoscaler 172.21.51.67:60626]
```

实际的请求：

```plain
http://prometheus:9090/api/v1/query?query=%28sum%28rate%28nginx_vts_server_requests_per_second%7Bkubernetes_namespace%3D%22default%22%2Ckubernetes_pod_name%3D~%22custom-metrics-demo-95b5bc949-9vd8q%7Ccustom-metrics-demo-95b5bc949-qrpnp%22%2Cjob%3D%22kubernetes-sd-endpoints%22%7D%5B1m%5D%29%29+by+%28kubernetes_pod_name
 
 I1028 08:56:05.289421       1 api.go:74] GET http://prometheus:9090/api/v1/query?query=%28sum%28rate%28nginx_vts_server_requests_total%7Bkubernetes_namespace%3D%22default%22%2Ckubernetes_pod_name%3D~%22custom-metrics-demo-95b5bc949-9vd8q%7Ccustom-metrics-demo-95b5bc949-qrpnp%22%7D%5B1m%5D%29%29+by+%28kubernetes_pod_name%29%29&time=1603875365.284 200 OK
```

补充：coredns通用指标的hpa

添加指标：

```plain
$ cat custom-metrics-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: adapter-config
   namespace: monitor
 data:
   config.yaml: |
     rules:
     - seriesQuery: 'nginx_vts_server_requests_total{host="*",code="total"}'
       seriesFilters: []
       resources:
         overrides:
           kubernetes_namespace: {resource: "namespace"}
           kubernetes_pod_name: {resource: "pod"}
       name:
         as: "nginx_vts_server_requests_per_second"
       metricsQuery: (sum(rate(<<.Series>>{<<.LabelMatchers>>}[1m])) by (<<.GroupBy>>))
     - seriesQuery: 'coredns_dns_request_count_total{job="kubernetes-sd-endpoints"}'
       seriesFilters: []
       resources:
         overrides:
           kubernetes_namespace: {resource: "namespace"}
           kubernetes_pod_name: {resource: "pod"}
       name:
         as: "coredns_dns_request_count_total_1minute"
       metricsQuery: (sum(rate(<<.Series>>{<<.LabelMatchers>>,job="kubernetes-sd-endpoints"}[1m])) by (<<.GroupBy>>))
```

coredns的hpa文件：

```plain
$ cat coredns-hpa.yaml
 apiVersion: autoscaling/v2beta1
 kind: HorizontalPodAutoscaler
 metadata:
   name: coredns-hpa
   namespace: kube-system
 spec:
   scaleTargetRef:
     apiVersion: apps/v1
     kind: Deployment
     name: coredns
   minReplicas: 2
   maxReplicas: 3
   metrics:
   - type: Pods
     pods:
       metricName: coredns_dns_request_count_total_1minute
       targetAverageValue: 1
```

hpa会拿pod、namespace去通过adaptor提供的api查询指标数据：

 

```yaml
sum(rate(coredns_dns_request_count_total{kubernetes_namespace="default",kubernetes_pod_name=~"custom-metrics-demo-95b5bc949-9vd8q|custom-metrics-demo-95b5bc949-qrpnp",job="kubernetes-sd-endpoints"}[1m])) by (kubernetes_pod_name)

```

追加：Adapter查询数据和直接查询Prometheus数据不一致（相差4倍）的问题。

```plain
$ vi custom-metrics-configmap.yaml
 apiVersion: v1
 kind: ConfigMap
 metadata:
   name: adapter-config
   namespace: monitor
 data:
   config.yaml: |
     rules:
     - seriesQuery: 'nginx_vts_server_requests_total{host="*",code="total"}'
       seriesFilters: []
       resources:
         overrides:
           kubernetes_namespace: {resource: "namespace"}
           kubernetes_pod_name: {resource: "pod"}
       name:
         matches: "^(.*)_total"
         as: "${1}_per_second"
       metricsQuery: (sum(rate(<<.Series>>{<<.LabelMatchers>>,host="*",code="total"}[1m])) by (<<.GroupBy>>))
```

查询验证：

```plain
$ kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/*/nginx_vts_server_requests_per_second" | jq 
 {
   "kind": "MetricValueList",
   "apiVersion": "custom.metrics.k8s.io/v1beta1",
   "metadata": {
     "selfLink": "/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/%2A/nginx_vts_server_requests_per_second"
   },
   "items": [
     {
       "describedObject": {
         "kind": "Pod",
         "namespace": "default",
         "name": "custom-metrics-demo-95b5bc949-xpppl",
         "apiVersion": "/v1"
       },
       "metricName": "nginx_vts_server_requests_per_second",
       "timestamp": "2020-08-02T04:07:06Z",
       "value": "133m",
       "selector": null
     }
   ]
 }
```

# 05_K8S集成jenkins

### 基于Kubernetes的DevOps平台实践

持续集成工具：

* Jenkins
* gitlabci
* Tekton

本章基于k8s集群部署gitlab、sonarQube、Jenkins等工具，并把上述工具集成到Jenkins中，以Django项目和SpringBoot项目为例，通过多分支流水线及Jenkinsfile实现项目代码提交到不同的仓库分支，实现自动代码扫描、单元测试、docker容器构建、k8s服务的自动部署。

* DevOps、CI、CD介绍
* Jenkins、sonarQube、gitlab的快速部署
* Jenkins初体验
* 流水线入门及Jenkinsfile使用
* Jenkins与Kubernetes的集成
* sonarQube代码扫描与Jenkins的集成
* 实践Django项目的基于Jenkinsfile实现开发、测试环境的CI/CD

#### DevOps、CI、CD介绍

Continuous Integration (*CI*) / Continuous Delivery (*CD*)

软件交付流程

<!-- OCR_START -->
- Plan
- Code
- Build
- Test
- Release
- Deploy
- Operate
- 规划
- 代码
- 构建
- 测试
- 发布
- 部署
- 维护
- 软件开发工程师
- 软件测试工程师
- 软件运维工程师
<!-- OCR_END -->

一个软件从零开始到最终交付，大概包括以下几个阶段：规划、编码、构建、测试、发布、部署和维护，基于这些阶段，我们的软件交付模型大致经历了几个阶段：

##### 瀑布式流程



<!-- OCR_START -->
> 瀑布式开发：
> 设计
> 开发
> 测试
> 部署
<!-- OCR_END -->



前期需求确立之后，软件开发人员花费数周和数月编写代码，把所有需求一次性开发完，然后将代码交给QA（质量保障）团队进行测试，然后将最终的发布版交给运维团队去部署。瀑布模型，简单来说，就是等一个阶段所有工作完成之后，再进入下一个阶段。这种模式的问题也很明显，产品迭代周期长，灵活性差。一个周期动辄几周几个月，适应不了当下产品需要快速迭代的场景。

##### 敏捷开发

<!-- OCR_START -->
- 瀑布式开发：
- 敏捷开发：
- 设计
- 开发
- 测试
- 部署
<!-- OCR_END -->

任务由大拆小，开发、测试协同工作，注重开发敏捷，不重视交付敏捷

##### DevOps

<!-- OCR_START -->
- 瀑布式开发：
- 敏捷开发：
- DevOps:
- 设计
- 开发
- 测试
- 部署
<!-- OCR_END -->

开发、测试、运维协同工作, 持续开发+持续交付。

我们是否可以认为DevOps = 提倡开发、测试、运维协同工作来实现持续开发、持续交付的一种软件交付模式？

大家想一下为什么最初的开发模式没有直接进入DevOps的时代？

原因是：沟通成本。

各角色人员去沟通协作的时候都是手动去做，交流靠嘴，靠人去指挥，很显然会出大问题。所以说不能认为DevOps就是一种交付模式，因为解决不了沟通协作成本，这种模式就不具备可落地性。

那DevOps时代如何解决角色之间的成本问题？DevOps的核心就是自动化。自动化的能力靠什么来支撑，工具和技术。

DevOps工具链

<!-- OCR_START -->
- PivotalTracker
- asana
- TeamCity
- sshippable
- HashiCorp
- amazon
- box
- Lucidchart
- draw.io
- Jenkins
- *planio
- TravisCI
- Microsoft
- ANSIBLE
- flowdock
- buddybuild
- circleci
- Azure
- Wrike
- CODESHIP
- Google Cloud Platform
- GoogleDrive
- split
- XL)RELEASE
- office
- GoogleDocs
- XLDEPLOY
- smartsheet
- gliffy
- puppet
- CHEF
- Basecamp
- DEPL
- ON
- rackspace
- mTrello
- OpsGeniE
- 米zoominfo
- CO
- VictorOps
- (x)matters
- pagerduty
- slack
- Blueleans
- CODECLIMATE
- BUILD
- ONewRelic.
- snyk
- 7
- git
- bugsnag
- Nagios'
- GitLab
- salesforce
- splunk>
- LOGGLY
- JFrog
- ZABBIX
- SAUCELABS
- -RAYGUN
- CFitNesse
- servicenow
- TestFairy
- Drunnable
- Jasmine
- SENTRY
- node
- zendesk
- dynatrace
- GitHub
- DATADOG
- bigpanda
- kubernetes
- docker
- INTERCOM
- ZOHCRM
- cucumber
- Z-PHYR
- Rollbar
- APPDYNAMICS
- VisualStudio
- 8
- Sonatype
- freshdesk
- BrowserStack
- TeamFoundationServer
- QMETRY
- nstebug
- OMNIDESK
- [:]SourceClear
- nat/ssagai890
<!-- OCR_END -->

靠这些工具和技术，才实现了自动化流程，进而解决了协作成本，使得devops具备了可落地性。因此我们可以大致给devops一个定义：

devops = 提倡开发、测试、运维协同工作来实现持续开发、持续交付的一种软件交付模式 + 基于工具和技术支撑的自动化流程的落地实践。

因此devops不是某一个具体的技术，而是一种思想+自动化能力，来使得构建、测试、发布软件能够更加地便捷、频繁和可靠的落地实践。本次课程核心内容就是要教会大家如何利用工具和技术来实现完整的DevOps平台的建设。我们主要使用的工具有：

1. gitlab，代码仓库，企业内部使用最多的代码版本管理工具。
2. Jenkins， 一个可扩展的持续集成引擎，用于自动化各种任务，包括构建、测试和部署软件。
3. robotFramework， 基于Python的自动化测试框架
4. sonarqube，代码质量管理平台
5. maven，java包构建管理工具
6. Kubernetes
7. Docker

#### Jenkins初体验

##### Kubernetes环境中部署jenkins

[其他部署方式](https://jenkins.io/zh/doc/book/installing/)

注意点：

1. 第一次启动很慢
2. 因为后面Jenkins会与kubernetes集群进行集成，会需要调用kubernetes集群的api，因此安装的时候创建了ServiceAccount并赋予了cluster-admin的权限
3. 默认部署到jenkins=true的节点
4. 初始化容器来设置权限
5. ingress来外部访问
6. 数据存储通过hostpath挂载到宿主机中

```plain
jenkins/jenkins-all.yaml
 apiVersion: v1
 kind: Namespace
 metadata:
   name: jenkins
 ---
 apiVersion: v1
 kind: ServiceAccount
 metadata:
   name: jenkins
   namespace: jenkins
 ---
 apiVersion: rbac.authorization.k8s.io/v1beta1
 kind: ClusterRoleBinding
 metadata:
   name: jenkins-crb
 roleRef:
   apiGroup: rbac.authorization.k8s.io
   kind: ClusterRole
   name: cluster-admin
 subjects:
 - kind: ServiceAccount
   name: jenkins
   namespace: jenkins
 ---
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: jenkins-master
   namespace: jenkins
 spec:
   replicas: 1
   selector:
     matchLabels:
       devops: jenkins-master
   template:
     metadata:
       labels:
         devops: jenkins-master
     spec:
       nodeSelector:
         jenkins: "true"
       serviceAccount: jenkins #Pod 需要使用的服务账号
       initContainers:
       - name: fix-permissions
         image: busybox
         command: ["sh", "-c", "chown -R 1000:1000 /var/jenkins_home"]
         securityContext:
           privileged: true
         volumeMounts:
         - name: jenkinshome
           mountPath: /var/jenkins_home
       containers:
       - name: jenkins
         image: jenkinsci/blueocean:1.23.2
         imagePullPolicy: IfNotPresent
         ports:
         - name: http #Jenkins Master Web 服务端口
           containerPort: 8080
         - name: slavelistener #Jenkins Master 供未来 Slave 连接的端口
           containerPort: 50000
         volumeMounts:
         - name: jenkinshome
           mountPath: /var/jenkins_home
         env:
         - name: JAVA_OPTS
           value: "-Xms4096m -Xmx5120m -Duser.timezone=Asia/Shanghai -Dhudson.model.DirectoryBrowserSupport.CSP="
       volumes:
       - name: jenkinshome
         hostPath:
           path: /var/jenkins_home/
 ---
 apiVersion: v1
 kind: Service
 metadata:
   name: jenkins
   namespace: jenkins
 spec:
   ports:
   - name: http
     port: 8080
     targetPort: 8080
   - name: slavelistener
     port: 50000
     targetPort: 50000
   type: ClusterIP
   selector:
     devops: jenkins-master
 ---
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: jenkins-web
   namespace: jenkins
 spec:
   rules:
   - host: jenkins.luffy.com
     http:
       paths:
       - backend:
           serviceName: jenkins
           servicePort: 8080
         path: /
```

创建服务：

```plain
## 为k8s-slave1打标签，将jenkins-master部署在k8s-slave1节点
 $ kubectl label node k8s-slave1 jenkins=true
 ## 部署服务
 $ kubectl create -f jenkins-all.yaml
 ## 查看服务
 $ kubectl -n jenkins get po
 NAME                              READY   STATUS    RESTARTS   AGE
 jenkins-master-767df9b574-lgdr5   1/1     Running   0          20s
 
 # 查看日志，第一次启动提示需要完成初始化设置
 $ kubectl -n jenkins logs -f jenkins-master-767df9b574-lgdr5
 ......
 *************************************************************
 
 Jenkins initial setup is required. An admin user has been created and a password generated.
 Please use the following password to proceed to installation:
 
 5396b4e1c395450f8360efd8ee641b18
 
 This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
 
 *************************************************************
```

访问服务：

配置hosts解析，172.21.51.67 jenkins.luffy.com，然后使用浏览器域名访问服务。第一次访问需要大概几分钟的初始化时间。

<!-- OCR_START -->
- 入门
- 解锁Jenkins
- 为了确保管理员安全地安装Jenkins，密码已写入到日志中（不知道在哪里？）该文件在
- 服务器上：
- /var/jenkins_home/secrets/initialAdminPassword
- 请从本地复制密码并粘贴到下面。
- 管理员密码
- 继续
<!-- OCR_END -->

使用jenkins启动日志中的密码，或者执行下面的命令获取解锁的管理员密码：

```plain
$ kubectl -n jenkins exec jenkins-master-767df9b574-lgdr5 bash 
 / # cat /var/jenkins_home/secrets/initialAdminPassword
 35b083de1d25409eaef57255e0da481a
```

点击叉号，跳过选择安装推荐的插件环节，直接进入Jenkins。由于默认的插件地址安装非常慢，我们可以替换成国内清华的源，进入 jenkins 工作目录，目录下面有一个 updates 的目录，下面有一个 default.json 文件，我们执行下面的命令替换插件地址：

```plain
$ cd /var/jenkins_home/updates
 $ sed -i 's/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json 
 $ sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' default.json
```

暂时先不用重新启动pod，汉化后一起重启。

选择右上角admin->configure->password重新设置管理员密码，设置完后，会退出要求重新登录，使用admin/xxxxxx(新密码)，登录即可。

<!-- OCR_START -->
- Jenkins
- search
- [2
- admin
- log out
- monitors
- Builds
- refresh
- Configure
- New Item
- description
- My Views
- Welcome to Jenkins!
- People
- 凭据
- Build History
- Please create new jobs to get started.
- Manage Jenkins
- 打开 Blue Ocean
- New View
- Build Queue
- No builds in the queue.
- Build Executor Status
- 1 Idle
- 2 Idle
- jenkins.devops.cn/user/admin/configure
<!-- OCR_END -->

##### 安装汉化插件

Jenkins -> manage Jenkins -> Plugin Manager -> Avaliable，搜索 chinese关键字

<!-- OCR_START -->
- chinese
- Updates
- Available
- Installed
- Advanced
- Install 1 Name
- Version
- Released
- Localization: Chinese (Simplified)
- localization
- 1.0.17
- 15 days ago
- JenkinsCore及其插件的简体中文语言包，由Jenkins中文社区维护
- Install without restart
- Download now and install after restart
- Update information obtained: 8 min 55 sec ago
- Check now
<!-- OCR_END -->

选中后，选择\[Install without restart]，等待下载完成，然后点击\[ Restart Jenkins when installation is complete and no jobs are running ]，让Jenkins自动重启

启动后，界面默认变成中文。

##### Jenkins基本使用演示

###### 演示目标

* 代码提交gitlab，自动触发Jenkins任务
* Jenkins任务完成后发送钉钉消息通知

###### 演示准备

*gitlab代码仓库搭建*

<https://github.com/sameersbn/docker-gitlab>

```plain
## 全量部署的组件
 $ gitlab-ctl status
 run: alertmanager: (pid 1987) 27s; run: log: (pid 1986) 27s
 run: gitaly: (pid 1950) 28s; run: log: (pid 1949) 28s
 run: gitlab-exporter: (pid 1985) 27s; run: log: (pid 1984) 27s
 run: gitlab-workhorse: (pid 1956) 28s; run: log: (pid 1955) 28s
 run: logrotate: (pid 1960) 28s; run: log: (pid 1959) 28s
 run: nginx: (pid 2439) 1s; run: log: (pid 1990) 27s
 run: node-exporter: (pid 1963) 28s; run: log: (pid 1962) 28s
 run: postgres-exporter: (pid 1989) 27s; run: log: (pid 1988) 27s
 run: postgresql: (pid 1945) 28s; run: log: (pid 1944) 28s
 run: prometheus: (pid 1973) 28s; run: log: (pid 1972) 28s
 run: puma: (pid 1968) 28s; run: log: (pid 1966) 28s
 run: redis: (pid 1952) 28s; run: log: (pid 1951) 28s
 run: redis-exporter: (pid 1971) 28s; run: log: (pid 1964) 28s
 run: sidekiq: (pid 1969) 28s; run: log: (pid 1967) 28s
```

部署分析：

1. 依赖postgres
2. 依赖redis

使用k8s部署：

1. 准备secret文件

```plain
$ cat gitlab-secret.txt
 postgres.user.root=root
 postgres.pwd.root=1qaz2wsx
 
 $ kubectl -n jenkins create secret generic gitlab-secret --from-env-file=gitlab-secret.txt
```

2. 部署postgres注意点：
   * 使用secret来引用账户密码
   * 使用postgres=true来指定节点

```yaml
$ cat postgres.yaml
apiVersion: v1 
kind: Service 
metadata: 
	name: postgres 
labels:
app: postgres
namespace: jenkins spec: 
ports:
	 - name: server port: 5432 
	 - targetPort: 5432 
	 - protocol: TCP 
	 - selector: 
	 - 		app: postgres

------
apiVersion: apps/v1
kind: Deployment 
metadata: 
namespace: jenkins 
name: postgres 
labels:
		app: postgres
		spec: replicas: 1 selector:
matchLabels:
  	app: postgres
template:
metadata:
  labels:
    app: postgres
spec:
  nodeSelector:
    postgres: "true"
  tolerations:
  - operator: "Exists"
  containers:
  - name: postgres
    image:  172.21.51.67:5000/postgres:11.4 #若本地没有启动该仓库，换成postgres:11.4
    imagePullPolicy: "IfNotPresent"
    ports:
    - containerPort: 5432
    env:
    - name: POSTGRES_USER           #PostgreSQL 用户名
      valueFrom:
        secretKeyRef:
          name: gitlab-secret
          key: postgres.user.root
    - name: POSTGRES_PASSWORD       #PostgreSQL 密码
      valueFrom:
        secretKeyRef:
          name: gitlab-secret
          key: postgres.pwd.root
    resources:
      limits:
        cpu: 1000m
        memory: 2048Mi
      requests:
        cpu: 50m
        memory: 100Mi
    volumeMounts:
    - mountPath: /var/lib/postgresql/data
      name: postgredb
  volumes:
  - name: postgredb
    hostPath:
      path: /var/lib/postgres/
```

```yaml
# 部署到k8s-slave2节点

`$ kubectl label node k8s-slave2 postgres=true` 

# 创建postgres

$ kubectl create -f postgres.yaml

# 创建数据库gitlab,为后面部署gitlab组件使用

$ kubectl -n jenkins exec -ti postgres-7ff9b49f4c-nt8zh bash 
root@postgres-7ff9b49f4c-nt8zh:/# psql 
root=# create database gitlab; CREATE DATABASE
```

3. 部署redis

```plain

    $ cat redis.yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: redis
      labels:
        app: redis
      namespace: jenkins
    spec:
      ports:
      - name: server
        port: 6379
        targetPort: 6379
        protocol: TCP
      selector:
        app: redis
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      namespace: jenkins
      name: redis
      labels:
        app: redis
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: redis
      template:
        metadata:
          labels:
            app: redis
        spec:
          tolerations:
          - operator: "Exists"
          containers:
          - name: redis
            image:  sameersbn/redis:4.0.9-2
            imagePullPolicy: "IfNotPresent"
            ports:
            - containerPort: 6379
            resources:
              limits:
                cpu: 1000m
                memory: 2048Mi
              requests:
                cpu: 50m
                memory: 100Mi
 

```

    创建

```plain
  $ kubectl create -f redis.yaml
```

1. 部署gitlab注意点：
   * 使用ingress暴漏服务
   * 添加annotation，指定nginx端上传大小限制，否则推送代码时会默认被限制1m大小，相当于给nginx设置client_max_body_size的限制大小
   * 使用gitlab=true来选择节点
   * 使用服务发现地址来访问postgres和redis
   * 在secret中引用数据库账户和密码
   * 数据库名称为gitlab

```plain
$ cat gitlab.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: gitlab
   namespace: jenkins
   annotations:
     nginx.ingress.kubernetes.io/proxy-body-size: "50m"
 spec:
   rules:
   - host: gitlab.luffy.com
     http:
       paths:
       - backend:
           serviceName: gitlab
           servicePort: 80
         path: /
 ---
 apiVersion: v1
 kind: Service
 metadata:
   name: gitlab
   labels:
     app: gitlab
   namespace: jenkins
 spec:
   ports:
   - name: server
     port: 80
     targetPort: 80
     protocol: TCP
   selector:
     app: gitlab
 ---
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   namespace: jenkins
   name: gitlab
   labels:
     app: gitlab
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: gitlab
   template:
     metadata:
       labels:
         app: gitlab
     spec:
       nodeSelector:
         gitlab: "true"
       tolerations:
       - operator: "Exists"
       containers:
       - name: gitlab
         image:  sameersbn/gitlab:13.2.2
         imagePullPolicy: "IfNotPresent"
         env:
         - name: GITLAB_HOST
           value: "gitlab.luffy.com"
         - name: GITLAB_PORT
           value: "80"
         - name: GITLAB_SECRETS_DB_KEY_BASE
           value: "long-and-random-alpha-numeric-string"
         - name: GITLAB_SECRETS_DB_KEY_BASE
           value: "long-and-random-alpha-numeric-string"
         - name: GITLAB_SECRETS_SECRET_KEY_BASE
           value: "long-and-random-alpha-numeric-string"
         - name: GITLAB_SECRETS_OTP_KEY_BASE
           value: "long-and-random-alpha-numeric-string"
         - name: DB_HOST
           value: "postgres"
         - name: DB_NAME
           value: "gitlab"
         - name: DB_USER
           valueFrom:
             secretKeyRef:
               name: gitlab-secret
               key: postgres.user.root
         - name: DB_PASS
           valueFrom:
             secretKeyRef:
               name: gitlab-secret
               key: postgres.pwd.root
         - name: REDIS_HOST
           value: "redis"
         - name: REDIS_PORT
           value: "6379"
         ports:
         - containerPort: 80
         resources:
           limits:
             cpu: 2000m
             memory: 5048Mi
           requests:
             cpu: 100m
             memory: 500Mi
         volumeMounts:
         - mountPath: /home/git/data
           name: data
       volumes:
       - name: data
         hostPath:
           path: /var/lib/gitlab/
 
 #部署到k8s-slave2节点
 $ kubectl label node k8s-slave2 gitlab=true
 
 # 创建
 $ kubectl create -f gitlab.yaml
```

配置hosts解析：

 172.21.51.67 gitlab.luffy.com

*设置root密码*

访问[http://gitlab.luffy.com，设置管理员密码](http://gitlab.luffy.xn--com%2C-ov1gp70btl5b8wgswi88jvk9a/)

*配置k8s-master节点的hosts*

 $ echo "172.21.51.67 gitlab.luffy.com" >>/etc/hosts

*myblog项目推送到gitlab*

```plain
mkdir demo
 cp -r myblog demo/
 cd demo/myblog
 git remote rename origin old-origin
 git remote add origin http://gitlab.luffy.com/root/myblog.git
 git push -u origin --all
 git push -u origin --tags
```

*钉钉推送*

[官方文档](https://ding-doc.dingtalk.com/doc#/serverapi2/qf2nxq)

* 配置机器人
* 试验发送消息

```plain
$ curl 'https://oapi.dingtalk.com/robot/send?access_token=67e81175c6ebacb1307e83f62680f36fbcf4524e8f43971cf2fb2049bc58723d' \
    -H 'Content-Type: application/json' \
    -d '{"msgtype": "text", 
         "text": {
              "content": "我就是我, 是不一样的烟火"
         }
       }'
```

###### 演示过程

流程示意图：

<!-- OCR_START -->
- 在gitlab中找到项目-->setting-->Integrations配置
- 3
- 填写链接：
- gitlab生成Api token
- gitlab项目中增加webhook
- ①URL: http://192.168.56.12:8080/project/php-dep1oy
- ②Secret Token:3f199086a22c54957579966e34ad120a
- ③点击Addwebhook
- 配置
- git push origin master
- gitlab
- 程序猿
- web1
- 监测push event
- jenkins
- 触发构建
- Excute Shell
- 发布
- web2
- web3
- 2
- 4
- 5
- 安装插件gitlabplugin
- 配置gitlab认证
- 系统配置gitlab链接
- 任务配置
- 步骤
- 1、填写连接名
- 1、勾选Buildwhenachange
- 1、Kind选择GitlabAPItoken
- 2、其中APItoken填写gitlab中有库权限的账号
- 2、填写gitlab访问URL
- 2、选择pushevents事件触发构建
- 3、选择gitlab认证
- 3、选择分支过滤
- 3、ID填写用户账号
- 3、测试连接
- 4、secrettoken需要填入gitlab项目中的webhook
- @51CTO博客
<!-- OCR_END -->

1. 安装gitlab plugin插件中心搜索并安装gitlab，直接安装即可
2. 配置Gitlab系统管理->系统配置->Gitlab，其中的API Token，需要从下个步骤中获取

<!-- OCR_START -->
- Gitlab
- Enable authentication for '/project' end-point
- GitLab connections
- Connection name
- A name for the connection
- Gitlab host URL
- http://gitlab.luffy.com/
- The complete URL to the Gitlab server (e.g. http://gitlab.mydomain.com)
- Credentials
- GitLab APl token
- 添加
- API Token for accessing Gitlab
- 高级...
- Test Connection
- 删除
<!-- OCR_END -->

3. 获取AccessToken登录gitlab，选择user->Settings->access tokens新建一个访问token
4. 配置host解析由于我们的Jenkins和gitlab域名是本地解析，因此需要让gitlab和Jenkins服务可以解析到对方的域名。两种方式：
   * 在容器内配置hosts
   * 配置coredns的静态解析
5. 创建自由风格项目
   * gitlab connection 选择为刚创建的gitlab
   * 源码管理选择Git，填项项目地址
   * 新建一个 Credentials 认证，使用用户名密码方式，配置gitlab的用户和密码
   * 构建触发器选择 Build when a change is pushed to GitLab
   * 生成一个Secret token
   * 保存
6. 到gitlab配置webhook
   * 进入项目下settings->Integrations
   * URL： <http://jenkins.luffy.com/project/free>
   * Secret Token 填入在Jenkins端生成的token
   * Add webhook
   * test push events，报错：Requests to the local network are not allowed
7. 设置gitlab允许向本地网络发送webhook请求访问 Admin Aera -> Settings -> Network ，展开Outbound requestsCollapse，勾选第一项即可。再次test push events，成功。

8. 配置free项目，增加构建步骤，执行shell，将发送钉钉消息的shell保存
9. 提交代码到gitlab仓库，查看构建是否自动执行

```plain
hosts {
             172.21.51.67 jenkins.luffy.com  gitlab.luffy.com
             fallthrough
         }
```

##### Master-Slaves（agent）模式

上面演示的任务，默认都是在master节点执行的，多个任务都在master节点执行，对master节点的性能会造成一定影响，如何将任务分散到不同的节点，做成多slave的方式？

1. 添加slave节点

<!-- OCR_START -->
- 名字
- 172.21.51.68
- 描述
- 执行器数量
- 5
- 远程工作目录
- /opt/jenkins_jobs
- 标签
- 用法
- 尽可能的使用这个节点
- 启动方式
- 通过JavaWeb启动代理
- 禁用工作目录
- 自定义工作目录
- 内部数据目录
- remoting
- 当工作目录缺失时失败
- Use WebSocket
<!-- OCR_END -->

   * 系统管理 -> 节点管理 -> 新建节点
   * 比如添加172.21.51.68，选择固定节点，保存
   * 远程工作目录/opt/jenkins_jobs
   * 标签为任务选择节点的依据，如172.21.51.68
   * 启动方式选择通过java web启动代理，代理是运行jar包，通过JNLP（是一种允许客户端启动托管在远程Web服务器上的应用程序的协议 ）启动连接到master节点服务中
2. 执行java命令启动agent服务
3. 查看Jenkins节点列表，新节点已经处于可用状态

<!-- OCR_START -->
- 名称↓
- 架构
- 时钟差异
- 剩余磁盘空间
- 剩余交换空间
- 剩余临时空间
- 响应时间
- 172.21.51.68
- Linux (amd64)
- 已同步
- 35.27 GB
- O·B
- 68ms
- master
- 48.63 GB
- 87.59 GB
- 0ms
- 获取到的数据
- 2分44秒
<!-- OCR_END -->

4. 测试使用新节点执行任务
   * 配置free项目
   * 限制项目的运行节点 ，标签表达式选择172.21.51.68
   * 立即构建
   * 查看构建日志

```plain
## 登录172.21.51.68，下载agent.jar
 $ wget http://jenkins.luffy.com/jnlpJars/agent.jar
 ## 会提示找不到agent错误，因为没有配置地址解析，由于连接jenkins master会通过50000端口，直接使用cluster-ip
 $ kubectl -n jenkins get svc #在master节点执行查询cluster-ip地址
 NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)              AGE
 jenkins   ClusterIP   10.99.204.208   <none>        8080/TCP,50000/TCP   4h8m
 
 ## 再次回到68节点
 $ wget 10.99.204.208:8080/jnlpJars/agent.jar
 $ java -jar agent.jar -jnlpUrl http://10.99.204.208:8080/computer/172.21.51.68/slave-agent.jnlp -secret 4be4d164f861d2830835653567867a1e695b30c320d35eca2be9f5624f8712c8 -workDir "/opt/jenkins_jobs"
 ...
 INFO: Remoting server accepts the following protocols: [JNLP4-connect, Ping]
 Apr 01, 2020 7:03:51 PM hudson.remoting.jnlp.Main$CuiListener status
 INFO: Agent discovery successful
   Agent address: 10.99.204.208
   Agent port:    50000
   Identity:      e4:46:3a:de:86:24:8e:15:09:13:3d:a7:4e:07:04:37
 Apr 01, 2020 7:03:51 PM hudson.remoting.jnlp.Main$CuiListener status
 INFO: Handshaking
 Apr 01, 2020 7:03:51 PM hudson.remoting.jnlp.Main$CuiListener status
 INFO: Connecting to 10.99.204.208:50000
 Apr 01, 2020 7:03:51 PM hudson.remoting.jnlp.Main$CuiListener status
 INFO: Trying protocol: JNLP4-connect
 Apr 01, 2020 7:04:02 PM hudson.remoting.jnlp.Main$CuiListener status
 INFO: Remote identity confirmed: e4:46:3a:de:86:24:8e:15:09:13:3d:a7:4e:07:04:37
 Apr 01, 2020 7:04:03 PM hudson.remoting.jnlp.Main$CuiListener status
 INFO: Connected
```

若出现如下错误:

可以选择： 配置从节点 -> 高级 -> Tunnel连接位置，参考下图进行设置:

<!-- OCR_START -->
- 远程上作目录
- /opt/jenkins_jobs
- 标签
- 172.21.51.68
- 用法
- 尽可能的使用这个节点
- 启动方式
- 通过JavaWeb启动代理
- 禁用工作目录
- 自定义工作目录
- 内部数据目录
- remoting
- 当工作目录缺失时失败
- Use WebSocket
- jenkins-master的Service的Cluster-IP:50000
- Tunnel 连接位置
- 10.111.4.131:50000
- JVM 选项
<!-- OCR_END -->

```plain
Started by user admin
 Running as SYSTEM
 Building remotely on 172.21.51.68 in workspace /opt/jenkins_jobs/workspace/free-demo
 using credential gitlab-user
 Cloning the remote Git repository
 Cloning repository http://gitlab.luffy.com/root/myblog.git
  > git init /opt/jenkins_jobs/workspace/free-demo # timeout=10
  ...
```

##### Jenkins定制化容器

由于每次新部署Jenkins环境，均需要安装很多必要的插件，因此考虑把插件提前做到镜像中

*Dockerfile*

```plain
FROM jenkinsci/blueocean:1.23.2
 LABEL maintainer="inspur_lyx@hotmail.com"
 
 ## 用最新的插件列表文件替换默认插件文件
 COPY plugins.txt /usr/share/jenkins/ref/
 
 ## 执行插件安装
 RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
```

*plugins.txt*

```plain
ace-editor:1.1
 allure-jenkins-plugin:2.28.1
 ant:1.10
 antisamy-markup-formatter:1.6
 apache-httpcomponents-client-4-api:4.5.10-1.0
 authentication-tokens:1.3
 ...
```

*get_plugin.sh*

admin:123456@localhost 需要替换成Jenkins的用户名、密码及访问地址

```plain
#!/usr/bin/env bash
 curl -sSL  "http://admin:123456@localhost:8080/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1:\2\n/g'|sed 's/ /:/' > plugins.txt
 ## 执行构建，定制jenkins容器
 $ docker build . -t 172.21.51.67:5000/jenkins:v20200414 -f Dockerfile
 $ docker push 172.21.51.67:5000/jenkins:v20200414
```

至此，我们可以使用定制化的镜像启动jenkins服务

```plain
## 删掉当前服务
 $ kubectl delete -f jenkins-all.yaml
 
 ## 删掉已挂载的数据
 $ rm -rf /var/jenkins_home
 
 ## 替换使用定制化镜像
 $ sed -i 's#jenkinsci/blueocean#172.21.51.67:5000/jenkins:v20200404#g' jenkins-all.yaml
 
 ## 重新创建服务
 $ kubectl create -f jenkins-all.yaml
```

##### 本章小结

自由风格项目弊端：

* 任务的完成需要在Jenkins端维护大量的配置
* 没法做版本控制
* 可读性、可移植性很差，不够优雅

#### 流水线入门

![1671690463507-025f4271-cf44-40f8-87bb-e66f1854a86b.jpeg](img/K8S高级运维/image109.jpeg)

[官方文档](https://jenkins.io/zh/doc/book/pipeline/getting-started/)

<!-- OCR_START -->
- Start
- SCM Commit
- Repo &
- catch/finally
- build-
- Branch
- report.html
- Nam
- Stage
- Workflow
- SCM Checkout
- Build/Launch
- (Docker)
- Test
- Deploy
- Workflow End
- Development
- Production
- Collect
- Dependenf
- Integration Tes
- Module 1
- Test Res
- ...
- Module N
- Dependency N
- Smoke Test
- End-to-End
<!-- OCR_END -->

为什么叫做流水线，和工厂产品的生产线类似，pipeline是从源码到发布到线上环境。关于流水线，需要知道的几个点：

* 重要的功能插件，帮助Jenkins定义了一套工作流框架；
* Pipeline 的实现方式是一套 Groovy DSL（ 领域专用语言 ），所有的发布流程都可以表述为一段 Groovy 脚本；
* 将WebUI上需要定义的任务，以脚本代码的方式表述出来；
* 帮助jenkins实现持续集成CI（Continue Integration）和持续部署CD（Continue Deliver）的重要手段；

##### 流水线基础语法

[官方文档](https://jenkins.io/zh/doc/book/pipeline/syntax/)

两种语法类型：

* Scripted Pipeline，脚本式流水线，最初支持的类型
* Declarative Pipeline，声明式流水线，为Pipeline plugin在2.5版本之后新增的一种脚本类型，后续Open Blue Ocean所支持的类型。与原先的Scripted Pipeline一样，都可以用来编写脚本。Declarative Pipeline 是后续Open Blue Ocean所支持的类型，写法简单，支持内嵌Scripted Pipeline代码

*为与BlueOcean脚本编辑器兼容，通常建议使用Declarative Pipeline的方式进行编写,从jenkins社区的动向来看，很明显这种语法结构也会是未来的趋势。*

###### 脚本示例

```plain
pipeline { 
     agent {label '172.21.51.68'}
     environment { 
         PROJECT = 'myblog'
     }
     stages {
         stage('Checkout') { 
             steps { 
                 checkout scm 
             }
         }
         stage('Build') { 
             steps { 
                 sh 'make' 
             }
         }
         stage('Test'){
             steps {
                 sh 'make check'
                 junit 'reports/**/*.xml' 
             }
         }
         stage('Deploy') {
             steps {
                 sh 'make publish'
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
         }
         failure { 
             echo 'Oh no!'
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

###### 脚本解释：

* checkout步骤为检出代码; scm是一个特殊变量，指示checkout步骤克隆触发此Pipeline运行的特定修订
* agent：指明使用哪个agent节点来执行任务，定义于pipeline顶层或者stage内部
  * any，可以使用任意可用的agent来执行
  * label，在提供了标签的 Jenkins 环境中可用的代理上执行流水线或阶段。 例如: agent { label 'my-defined-label' }，最常见的使用方式
  * none，当在 pipeline 块的顶部没有全局代理， 该参数将会被分配到整个流水线的运行中并且每个 stage 部分都需要包含他自己的 agent 部分。比如: agent none
  * docker， 使用给定的容器执行流水线或阶段。 在指定的节点中，通过运行容器来执行任务
* options: 允许从流水线内部配置特定于流水线的选项。
  * buildDiscarder , 为最近的流水线运行的特定数量保存组件和控制台输出。例如: options { buildDiscarder(logRotator(numToKeepStr: '10')) }
  * disableConcurrentBuilds ,不允许同时执行流水线。 可被用来防止同时访问共享资源等。 例如: options { disableConcurrentBuilds() }
  * timeout ,设置流水线运行的超时时间, 在此之后，Jenkins将中止流水线。例如: options { timeout(time: 1, unit: 'HOURS') }
  * retry，在失败时, 重新尝试整个流水线的指定次数。 For example: options { retry(3) }
* environment: 指令制定一个 键-值对序列，该序列将被定义为所有步骤的环境变量
* stages: 包含一系列一个或多个 [stage](https://jenkins.io/zh/doc/book/pipeline/syntax/#stage)指令, stages 部分是流水线描述的大部分"work" 的位置。 建议 stages 至少包含一个 [stage](https://jenkins.io/zh/doc/book/pipeline/syntax/#stage) 指令用于连续交付过程的每个离散部分,比如构建, 测试, 和部署。
* steps: 在给定的 stage 指令中执行的定义了一系列的一个或多个[steps](https://jenkins.io/zh/doc/book/pipeline/syntax/#declarative-steps)。
* post: 定义一个或多个[steps](https://jenkins.io/zh/doc/book/pipeline/syntax/#declarative-steps) ，这些阶段根据流水线或阶段的完成情况而运行post 支持以下 [post-condition](https://jenkins.io/zh/doc/book/pipeline/syntax/#post-conditions) 块中的其中之一: always, changed, failure, success, unstable, 和 aborted。
  * always, 无论流水线或阶段的完成状态如何，都允许在 post 部分运行该步骤
  * changed, 当前流水线或阶段的完成状态与它之前的运行不同时，才允许在 post 部分运行该步骤
  * failure, 当前流水线或阶段的完成状态为"failure"，才允许在 post 部分运行该步骤, 通常web UI是红色
  * success, 当前流水线或阶段的完成状态为"success"，才允许在 post 部分运行该步骤, 通常web UI是蓝色或绿色
  * unstable, 当前流水线或阶段的完成状态为"unstable"，才允许在 post 部分运行该步骤, 通常由于测试失败,代码违规等造成。通常web UI是黄色
  * aborted， 只有当前流水线或阶段的完成状态为"aborted"，才允许在 post 部分运行该步骤, 通常由于流水线被手动的aborted。通常web UI是灰色

```plain
agent {
     docker {
         image 'maven:3-alpine'
         label 'my-defined-label'
         args  '-v /tmp:/tmp'
     }
 }
```

```plain
pipeline {
     agent any
     stages { 
         stage('Example') {
             steps {
                 echo 'Hello World'
             }
         }
     }
 }
```

创建pipeline示意：

新建任务 -> 流水线

```plain
jenkins/pipelines/p1.yaml
 pipeline {
    agent {label '172.21.51.68'}
    environment { 
       PROJECT = 'myblog'
    }
    stages {
       stage('printenv') {
          steps {
             echo 'Hello World'
             sh 'printenv'
          }
       }
       stage('check') {
          steps {
             checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'gitlab-user', url: 'http://gitlab.luffy.com/root/myblog.git']]])
          }
       }
       stage('build-image') {
          steps {
             sh 'docker build . -t myblog:latest -f Dockerfile'
          }
       }
       stage('send-msg') {
          steps {
             sh """
             curl 'https://oapi.dingtalk.com/robot/send?access_token=67e81175c6ebacb1307e83f62680f36fbcf4524e8f43971cf2fb2049bc58723d' \
    -H 'Content-Type: application/json' \
    -d '{"msgtype": "text", 
         "text": {
              "content": "我就是我, 是不一样的烟火"
         }
       }'
       """
          }
       }
    }
 }
```

点击“立即构建”，同样的，我们可以配置触发器，使用webhook的方式接收项目的push事件，

* 构建触发器选择 Build when a change is pushed to GitLab.
* 生成 Secret token
* 配置gitlab，创建webhook，发送test push events测试

###### Blue Ocean:

[官方文档](https://jenkins.io/zh/doc/book/blueocean/getting-started/)

我们需要知道的几点：

* 是一个插件， 旨在为Pipeline提供丰富的体验 ；
* 连续交付（CD）Pipeline的复杂可视化，允许快速和直观地了解Pipeline的状态；
* 目前支持的类型仅针对于Pipeline，尚不能替代Jenkins 经典版UI

思考：

1. 每个项目都把大量的pipeline脚本写在Jenkins端，对于谁去维护及维护成本是一个问题
2. 没法做版本控制

##### Jenkinsflie

Jenkins Pipeline 提供了一套可扩展的工具，用于将“简单到复杂”的交付流程实现为“持续交付即代码”。Jenkins Pipeline 的定义通常被写入到一个文本文件（称为 Jenkinsfile ）中，该文件可以被放入项目的源代码控制库中。

###### 演示1：使用Jenkinsfile管理**pipeline**

* 在项目中新建Jenkinsfile文件，拷贝已有script内容
* 配置pipeline任务，流水线定义为Pipeline Script from SCM
* 执行push 代码测试

Jenkinsfile:

```plain
jenkins/pipelines/p2.yaml
 pipeline {
    agent { label '172.21.51.68'}
 
    stages {
       stage('printenv') {
          steps {
             echo 'Hello World'
             sh 'printenv'
          }
       }
       stage('check') {
          steps {
             checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'gitlab-user', url: 'http://gitlab.luffy.com/root/myblog.git']]])
          }
       }
       stage('build-image') {
          steps {
             retry(2) { sh 'docker build . -t myblog:latest'}
          }
       }
       stage('send-msg') {
          steps {
             sh """
             curl 'https://oapi.dingtalk.com/robot/send?access_token=67e81175c6ebacb1307e83f62680f36fbcf4524e8f43971cf2fb2049bc58723d' \
    -H 'Content-Type: application/json' \
    -d '{"msgtype": "text", 
         "text": {
              "content": "我就是我, 是不一样的烟火"
         }
       }'
       """
          }
       }
    }
 }
```

###### 演示2：优化及丰富流水线内容

* 优化代码检出阶段由于目前已经配置了使用git仓库地址，且使用SCM来检测项目，因此代码检出阶段完全没有必要再去指定一次
* 构建镜像的tag使用git的commit id
* 增加post阶段的消息通知，丰富通知内容
* 配置webhook，实现myblog代码推送后，触发Jenkinsfile任务执行

```plain
jenkins/pipelines/p3.yaml
 pipeline {
     agent { label '172.21.51.68'}
 
     stages {
         stage('printenv') {
             steps {
             echo 'Hello World'
             sh 'printenv'
             }
         }
         stage('check') {
             steps {
                 checkout scm
             }
         }
         stage('build-image') {
             steps {
                 retry(2) { sh 'docker build . -t myblog:${GIT_COMMIT}'}
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=67e81175c6ebacb1307e83f62680f36fbcf4524e8f43971cf2fb2049bc58723d' \
                     -H 'Content-Type: application/json' \
                     -d '{"msgtype": "text", 
                             "text": {
                                 "content": "😄👍构建成功👍😄\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                         }
                 }'
             """
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=67e81175c6ebacb1307e83f62680f36fbcf4524e8f43971cf2fb2049bc58723d' \
                     -H 'Content-Type: application/json' \
                     -d '{"msgtype": "text", 
                             "text": {
                                 "content": "😖❌构建失败❌😖\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                         }
                 }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

###### 演示3：使用k8s部署服务

* 新建deploy目录，将k8s所需的文件放到deploy目录中
* 将镜像地址改成模板，在pipeline中使用新构建的镜像进行替换
* 执行kubectl apply -f deploy应用更改，需要配置kubectl认证 $ scp -r k8s-master:/root/.kube /root

```plain
jenkins/pipelines/p4.yaml
 pipeline {
     agent { label '172.21.51.68'}
 
     environment {
         IMAGE_REPO = "172.21.51.67:5000/myblog"
     }
 
     stages {
         stage('printenv') {
             steps {
               echo 'Hello World'
               sh 'printenv'
             }
         }
         stage('check') {
             steps {
                 checkout scm
             }
         }
         stage('build-image') {
             steps {
                 retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
             }
         }
         stage('push-image') {
             steps {
                 retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
             }
         }
         stage('deploy') {
             steps {
                 sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' deploy/*"
                 timeout(time: 1, unit: 'MINUTES') {
                     sh "kubectl apply -f deploy/"
                 }
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=67e81175c6ebacb1307e83f62680f36fbcf4524e8f43971cf2fb2049bc58723d' \
                     -H 'Content-Type: application/json' \
                     -d '{"msgtype": "text", 
                             "text": {
                                 "content": "😄👍构建成功👍😄\n 关键字：myblog\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                         }
                 }'
             """
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=67e81175c6ebacb1307e83f62680f36fbcf4524e8f43971cf2fb2049bc58723d' \
                     -H 'Content-Type: application/json' \
                     -d '{"msgtype": "text", 
                             "text": {
                                 "content": "😖❌构建失败❌😖\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                         }
                 }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

###### 演示4：使用凭据管理敏感信息

上述Jenkinsfile中存在的问题是敏感信息使用明文，暴漏在代码中，如何管理流水线中的敏感信息（包含账号密码），之前我们在对接gitlab的时候，需要账号密码，已经使用过凭据来管理这类敏感信息，同样的，我们可以使用凭据来存储钉钉的token信息，那么，创建好凭据后，如何在Jenkinsfile中获取已有凭据的内容？

Jenkins 的声明式流水线语法有一个 credentials() 辅助方法（在[environment](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/#../syntax#environment) 指令中使用），它支持 [secret 文本](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/##secret-text)，[带密码的用户名](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/##usernames-and-passwords)，以及 [secret 文件](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/##secret-files)凭据。

下面的流水线代码片段展示了如何创建一个使用带密码的用户名凭据的环境变量的流水线。

在该示例中，带密码的用户名凭据被分配了环境变量，用来使你的组织或团队以一个公用账户访问 Bitbucket 仓库；这些凭据已在 Jenkins 中配置了凭据 ID jenkins-bitbucket-common-creds。

当在 [environment](https://jenkins.io/zh/doc/book/pipeline/jenkinsfile/#../syntax#environment) 指令中设置凭据环境变量时：

```plain
environment {
     BITBUCKET_COMMON_CREDS = credentials('jenkins-bitbucket-common-creds')
 }
```

这实际设置了下面的三个环境变量：

* BITBUCKET_COMMON_CREDS - 包含一个以冒号分隔的用户名和密码，格式为 username:password。
* BITBUCKET_COMMON_CREDS_USR - 附加的一个仅包含用户名部分的变量。
* BITBUCKET_COMMON_CREDS_PSW - 附加的一个仅包含密码部分的变量。

```plain
pipeline {
     agent {
         // 此处定义 agent 的细节
     }
     environment {
         //顶层流水线块中使用的 environment 指令将适用于流水线中的所有步骤。 
         BITBUCKET_COMMON_CREDS = credentials('jenkins-bitbucket-common-creds')
     }
     stages {
         stage('Example stage 1') {
              //在一个 stage 中定义的 environment 指令只会将给定的环境变量应用于 stage 中的步骤。
             environment {
                 BITBUCKET_COMMON_CREDS = credentials('another-credential-id')
             }
             steps {
                 // 
             }
         }
         stage('Example stage 2') {
             steps {
                 // 
             }
         }
     }
 }
```

因此对Jenkinsfile做改造：

```plain
jenkins/pipelines/p5.yaml
 pipeline {
     agent { label '172.21.51.68'}
 
     environment {
         IMAGE_REPO = "172.21.51.67:5000/myblog"
         DINGTALK_CREDS = credentials('dingTalk')
     }
 
     stages {
         stage('printenv') {
             steps {
             echo 'Hello World'
             sh 'printenv'
             }
         }
         stage('check') {
             steps {
                 checkout scm
             }
         }
         stage('build-image') {
             steps {
                 retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
             }
         }
         stage('push-image') {
             steps {
                 retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
             }
         }
         stage('deploy') {
             steps {
                 sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' deploy/*"
                 timeout(time: 1, unit: 'MINUTES') {
                     sh "kubectl apply -f deploy/"
                 }
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{"msgtype": "text", 
                             "text": {
                                 "content": "😄👍构建成功👍😄\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                         }
                 }'
             """
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{"msgtype": "text", 
                             "text": {
                                 "content": "😖❌构建失败❌😖\n 关键字：luffy\n 项目名称: ${JOB_BASE_NAME}\n Commit Id: ${GIT_COMMIT}\n 构建地址：${RUN_DISPLAY_URL}"
                         }
                 }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

###### 本章小结

上面我们已经通过Jenkinsfile完成了最简单的项目的构建和部署，那么我们来思考目前的方式：

1. 目前都是在项目的单一分支下进行操作，企业内一般会使用feature、develop、release、master等多个分支来管理整个代码提交流程，如何根据不同的分支来做构建？
2. 构建视图中如何区分不同的分支?
3. 如何不配置webhook的方式实现构建？
4. 如何根据不同的分支选择发布到不同的环境(开发、测试、生产)？

##### 多分支流水线

[官方示例](https://jenkins.io/zh/doc/tutorials/build-a-multibranch-pipeline-project/)

我们简化一下流程，假如使用develop分支作为开发分支，master分支作为集成测试分支，看一下如何使用多分支流水线来管理。

###### 演示1：多分支流水线的使用

1. 提交develop分支：

```plain
$ git checkout -b develop
 $ git push --set-upstream origin develop
```

1. 禁用pipeline项目
2. Jenkins端创建多分支流水线项目
   * 增加git分支源
   * 发现标签
   * 根据名称过滤，develop|master|v.\*
   * 高级克隆，设置浅克隆

保存后，会自动检索项目中所有存在Jenkinsfile文件的分支和标签，若匹配我们设置的过滤正则表达式，则会添加到多分支的构建视图中。所有添加到视图中的分支和标签，会默认执行一次构建任务。

###### 演示2：美化消息通知内容

* 添加构建阶段记录
* 使用markdown格式，添加构建分支消息

```plain
jenkins/pipelines/p6.yaml
 pipeline {
     agent { label '172.21.51.68'}
 
     environment {
         IMAGE_REPO = "172.21.51.67:5000/myblog"
         DINGTALK_CREDS = credentials('dingTalk')
         TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
     }
 
     stages {
         stage('printenv') {
             steps {
                 script{
                     sh "git log --oneline -n 1 > gitlog.file"
                     env.GIT_LOG = readFile("gitlog.file").trim()
                 }
                 sh 'printenv'
             }
         }
         stage('checkout') {
             steps {
                 checkout scm
                 script{
                     env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('build-image') {
             steps {
                 retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('push-image') {
             steps {
                 retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('deploy') {
             steps {
                 sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' deploy/*"
                 timeout(time: 1, unit: 'MINUTES') {
                     sh "kubectl apply -f deploy/"
                 }
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${GIT_BRANCH}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """ 
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${GIT_BRANCH}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

###### 演示3：通知gitlab构建状态

Jenkins端做了构建，可以通过gitlab通过的api将构建状态通知过去，作为开发人员发起Merge Request或者合并Merge Request的依据之一。

*注意一定要指定gitLabConnection('gitlab')，不然没法认证到Gitlab端*

```plain
jenkins/pipelines/p7.yaml
 pipeline {
     agent { label '172.21.51.68'}
 
     options {
         buildDiscarder(logRotator(numToKeepStr: '10'))
         disableConcurrentBuilds()
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
 
     environment {
         IMAGE_REPO = "172.21.51.67:5000/demo/myblog"
         DINGTALK_CREDS = credentials('dingTalk')
         TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
     }
 
     stages {
         stage('printenv') {
             steps {
                 script{
                     sh "git log --oneline -n 1 > gitlog.file"
                     env.GIT_LOG = readFile("gitlog.file").trim()
                 }
                 sh 'printenv'
             }
         }
         stage('checkout') {
             steps {
                 checkout scm
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('build-image') {
             steps {
                 retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('push-image') {
             steps {
                 retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('deploy') {
             steps {
                 sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' deploy/*"
                 timeout(time: 1, unit: 'MINUTES') {
                     sh "kubectl apply -f deploy/"
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """ 
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

我们可以访问gitlab，然后找到commit记录，查看同步状态

<!-- OCR_START -->
- GitLab
- Projects
- Groups v
- More v
- ±~
- Search or jump to...
- ?：
- myblog
- add update gitlab status
- Project overview
- -0 parent 9ca0f97c Pdevelop
- Repository
- Files
- Commits
- Pipeline #3 passed with stage
- Branches
- Changes 1
- Pipelines 1
- Tags
- Contributors
- Status
- Pipeline
- Triggerer
- Commit
- Stages
- Graph
- #3
- -o- d95d36f3
- 曲 4 days ago
- Compare
- latest
- Charts
- build-image
- O Issues
- checkout
- 《 Collapse sidebar
- deploy
<!-- OCR_END -->

提交merge request，也可以查看到相关的任务状态，可以作为项目owner合并代码的依据之一：

<!-- OCR_START -->
- GitLab
- Projects v
- Groups v
- More v
- Search or jump to...
- 3
- myblog
- Merge options
- Delete source branch when merge request is accepted.
- Squash commits when merge request is accepted. ①
- Project overview
- Repository
- Submit merge request
- Cancel
- O Issues
- Commits 11
- Pipelines  2
- Changes 1
- N Merge Requests
- Status
- Pipeline
- Triggerer
- Commit
- Stages
- CI/ CD
- Operations
- -o d95d36f3
- 曲 4 days ago
- latest
- add update gitlab status
- wiki
- % Snippets
- 0 9ca0f97c
- #2
- add gitlog
- α Settings
- 《 Collapse sidebar
<!-- OCR_END -->

###### 本章小节

优势:

* 根据分支展示, 视图人性化
* 自动检测各分支的变更

思考：

* Jenkins的slave端，没有任务的时候处于闲置状态，slave节点多的话造成资源浪费
* 是否可以利用kubernetes的Pod来启动slave，动态slave pod来执行构建任务

#### 工具集成与Jenkinsfile实践篇

1. Jenkins如何对接kubernetes集群
2. 使用kubernetes的Pod-Template来作为动态的agent执行Jenkins任务
3. 如何制作agent容器实现不同类型的业务的集成
4. 集成代码扫描、docker镜像自动构建、k8s服务部署、自动化测试

##### 集成Kubernetes

###### 插件安装及配置

[插件官方文档](https://plugins.jenkins.io/kubernetes/)

1. \[系统管理] -> \[插件管理] -> \[搜索kubernetes]->直接安装若安装失败，请先更新[bouncycastle API Plugin](https://plugins.jenkins.io/bouncycastle-api)并重新启动Jenkins
2. \[系统管理] -> \[系统配置] -> \[Add a new cloud]
3. 配置地址信息
   * Kubernetes 地址: \[<https://kubernetes.default>（或者<https://172.21.51.67:6443>）]\(\[https://kubernetes.xn--default(https-bs9zf893a//172.21.51.67:6443]\(https://kubernetes.xn--default(https-bs9zf893a//172.21.51.67:6443)）)
   * Kubernetes 命名空间：jenkins
   * 服务证书不用写（我们在安装Jenkins的时候已经指定过serviceAccount），均使用默认
   * 连接测试，成功会提示：Connection test successful
   * Jenkins地址：[http://jenkins:8080](http://jenkins:8080/)
   * Jenkins 通道 ：jenkins:50000
4. 配置Pod Template
   * 名称：jnlp-slave
   * 命名空间：jenkins
   * 标签列表：jnlp-slave，作为agent的label选择用
   * 连接 Jenkins 的超时时间（秒） ：300，设置连接jenkins超时时间
   * 节点选择器：agent=true
   * 工作空间卷：选择hostpath，设置/opt/jenkins_jobs/,注意需要设置chown -R 1000:1000 /opt/jenkins_jobs/权限，否则Pod没有权限

###### 演示动态slave pod

```plain
# 为准备运行jnlp-slave-agent的pod的节点打上label
 $ kubectl label node k8s-slave1 agent=true
 
 ### 回放一次多分支流水线develop分支
 agent { label 'jnlp-slave'}
```

执行任务，会下载默认的jnlp-slave镜像，地址为jenkins/inbound-agent:4.3-4，我们可以先在k8s-master节点拉取下来该镜像：

 $ docker pull jenkins/inbound-agent:4.3-4

保存jenkinsfile提交后，会出现报错，因为我们的agent已经不再是宿主机，而是Pod中的容器内，报错如下：

<!-- OCR_START -->
build-image-<1s
V docker build .-t $[IMAGE_REPO]:$[GIT_COMMIT}-Shell Script
+dockerbui1d.-t 192.168.136.128:60080/demo/myblog:d95d36f32fc0f3cba8d04a1f61e7f34fab145b2a
/home/jenkins/agent/workspace/multi-branch-myblog_develop@tmp/durable-3a0d8e8e/script.sh: 1ine 1: docker: not found
scriptreturnedexitcode127
<!-- OCR_END -->

因此我们需要将用到的命令行工具集成到Pod的容器内，但是思考如下问题：

* 目前是用的jnlp的容器，是java的环境，我们在此基础上需要集成很多工具，能不能创建一个新的容器，让新容器来做具体的任务，jnlp-slave容器只用来负责连接jenkins-master
* 针对不同的构建环境（java、python、go、nodejs），可以制作不同的容器，来执行对应的任务

###### Pod-Template中容器镜像的制作

为解决上述问题，我们制作一个tools镜像，集成常用的工具，来完成常见的构建任务，需要注意的几点：

* 使用alpine基础镜像，自身体积比较小
* 替换国内安装源
* 为了使用docker，安装了docker
* 为了克隆代码，安装git
* 为了后续做python的测试等任务，安装python环境
* 为了在容器中调用kubectl的命令，拷贝了kubectl的二进制文件
* 为了认证kubectl，需要在容器内部生成.kube目录及config文件

```plain
$ mkdir tools;
 $ cd tools;
 $ cp `which kubectl` .
 $ cp ~/.kube/config .
```

*Dockerfile*

```plain
jenkins/custom-images/tools/Dockerfile
 FROM alpine
 LABEL maintainer="inspur_lyx@hotmail.com"
 USER root
 
 RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
     apk update && \
     apk add  --no-cache openrc docker git curl tar gcc g++ make \
     bash shadow openjdk8 python2 python2-dev py-pip python3-dev openssl-dev libffi-dev \
     libstdc++ harfbuzz nss freetype ttf-freefont && \
     mkdir -p /root/.kube && \
     usermod -a -G docker root
 
 COPY config /root/.kube/
 
 RUN rm -rf /var/cache/apk/* 
 #-----------------安装 kubectl--------------------#
 COPY kubectl /usr/local/bin/
 RUN chmod +x /usr/local/bin/kubectl
 # ------------------------------------------------#
```

执行镜像构建并推送到仓库中：

```plain
$ docker build . -t 172.21.51.67:5000/devops/tools:v1
 $ docker push 172.21.51.67:5000/devops/tools:v1
```

我们可以直接使用该镜像做测试：

```plain
## 启动临时镜像做测试
 $ docker run --rm -ti 172.21.51.67:5000/devops/tools:v1 bash
 # / git clone http://xxxxxx.git
 # / kubectl get no
 # / python3
 #/ docker
 
 ## 重新挂载docker的sock文件
 docker run -v /var/run/docker.sock:/var/run/docker.sock --rm -ti 172.21.51.67:5000/devops/tools:v1 bash
```

###### 实践通过Jenkinsfile实现demo项目自动发布到kubenetes环境

更新Jenkins中的PodTemplate，添加tools镜像，注意同时要先添加名为jnlp的container，因为我们是使用自定义的PodTemplate覆盖掉默认的模板：

<!-- OCR_START -->
- 容器列表
- Container Template
- 名称
- jnlp
- Docker 镜像
- jenkins/inbound-agent:4.3-
- 总是拉取镜像
- 工作目录
- /home/jenkins/agent
- 运行的命令
- /bin/sh -c
- 命令参数
- jenkins-agent
- 分配伪终端
- Environment Variables
- 添加环境变量
- 设置到Pod节点中的环境变量列
<!-- OCR_END -->

在卷栏目，添加卷，Host Path Volume，不然在容器中使用docker会提示docker服务未启动

<!-- OCR_START -->
- 该Pod中所有容器的环境变量
- Host Path Volume
- 主机路径
- /var/run/docker.sock
- 挂载路径
- 删除卷
<!-- OCR_END -->

tools容器做好后，我们需要对Jenkinsfile做如下调整：

```plain
jenkins/pipelines/p8.yaml
 pipeline {
     agent { label 'jnlp-slave'}
 
     options {
         buildDiscarder(logRotator(numToKeepStr: '10'))
         disableConcurrentBuilds()
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
 
     environment {
         IMAGE_REPO = "172.21.51.67:5000/myblog"
         DINGTALK_CREDS = credentials('dingTalk')
         TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
     }
 
     stages {
         stage('printenv') {
             steps {
                 script{
                     sh "git log --oneline -n 1 > gitlog.file"
                     env.GIT_LOG = readFile("gitlog.file").trim()
                 }
                 sh 'printenv'
             }
         }
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('build-image') {
             steps {
                 container('tools') {
                     retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('push-image') {
             steps {
                 container('tools') {
                     retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' deploy/*"
                     timeout(time: 1, unit: 'MINUTES') {
                         sh "kubectl apply -f deploy/"
                     }
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """ 
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

##### 集成sonarQube实现代码扫描

Sonar可以从以下七个维度检测代码质量，而作为开发人员至少需要处理前5种代码质量问题。

1. 不遵循代码标准 sonar可以通过PMD,CheckStyle,Findbugs等等代码规则检测工具规范代码编写。
2. 潜在的缺陷 sonar可以通过PMD,CheckStyle,Findbugs等等代码规则检测工具检 测出潜在的缺陷。
3. 糟糕的复杂度分布 文件、类、方法等，如果复杂度过高将难以改变，这会使得开发人员 难以理解它们, 且如果没有自动化的单元测试，对于程序中的任何组件的改变都将可能导致需要全面的回归测试。
4. 重复 显然程序中包含大量复制粘贴的代码是质量低下的，sonar可以展示 源码中重复严重的地方。
5. 注释不足或者过多 没有注释将使代码可读性变差，特别是当不可避免地出现人员变动 时，程序的可读性将大幅下降 而过多的注释又会使得开发人员将精力过多地花费在阅读注释上，亦违背初衷。
6. 缺乏单元测试 sonar可以很方便地统计并展示单元测试覆盖率。
7. 糟糕的设计 通过sonar可以找出循环，展示包与包、类与类之间的相互依赖关系，可以检测自定义的架构规则 通过sonar可以管理第三方的jar包，可以利用LCOM4检测单个任务规则的应用情况， 检测耦合。

###### sonarqube架构简介

<!-- OCR_START -->
- SonarQubeServer
- ComputeEngine
- WebServer
- Code Analysis with
- SonarQube Scanners
- SonarQube Datcbase
- Javo, C#,
- VB.NET,C/C++
- Objective-C,
- SonarQube Scanner for MSBuild
- Oracle
- PostgreSQL
- Swift, PHP,JS
- SonarQube Scanner for Maven
- CSS,HTML,
- SonarQube Scanner for Ant
- +SonarQube Plugins
- MySQL
- MS SQL
- Grocvy. ABAP,
- COBOL,
- SonarQube Scanner for Gradle
- Languoge Plugin
- SCM Plugin
- SearchServer
- Integrotion Plugin
- elastic
- and more ...
<!-- OCR_END -->

1. CS架构
   * sonarqube scanner
   * sonarqube server
2. SonarQube Scanner 扫描仪在本地执行代码扫描任务
3. 执行完后，将分析报告被发送到SonarQube服务器进行处理
4. SonarQube服务器处理和存储分析报告导致SonarQube数据库，并显示结果在UI中

###### sonarqube on kubernetes环境搭建

1. 资源文件准备

 sonar/sonar.yaml

* 和gitlab共享postgres数据库
* 使用ingress地址 sonar.luffy.com 进行访问
* 使用initContainers进行系统参数调整

```plain
apiVersion: v1
 kind: Service
 metadata:
   name: sonarqube
   namespace: jenkins
   labels:
     app: sonarqube
 spec:
   ports:
   - name: sonarqube
     port: 9000
     targetPort: 9000
     protocol: TCP
   selector:
     app: sonarqube
 ---
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   namespace: jenkins
   name: sonarqube
   labels:
     app: sonarqube
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: sonarqube
   template:
     metadata:
       labels:
         app: sonarqube
     spec:
       nodeSelector:
         sonar: "true"
       initContainers:
       - command:
         - /sbin/sysctl
         - -w
         - vm.max_map_count=262144
         image: alpine:3.6
         imagePullPolicy: IfNotPresent
         name: elasticsearch-logging-init
         resources: {}
         securityContext:
           privileged: true
       containers:
       - name: sonarqube
         image: 172.21.51.67:5000/sonarqube:7.9-community
         ports:
         - containerPort: 9000
         env:
         - name: SONARQUBE_JDBC_USERNAME
           valueFrom:
             secretKeyRef:
               name: gitlab-secret
               key: postgres.user.root
         - name: SONARQUBE_JDBC_PASSWORD
           valueFrom:
             secretKeyRef:
               name: gitlab-secret
               key: postgres.pwd.root
         - name: SONARQUBE_JDBC_URL
           value: "jdbc:postgresql://postgres:5432/sonar"
         livenessProbe:
           httpGet:
             path: /sessions/new
             port: 9000
           initialDelaySeconds: 60
           periodSeconds: 30
         readinessProbe:
           httpGet:
             path: /sessions/new
             port: 9000
           initialDelaySeconds: 60
           periodSeconds: 30
           failureThreshold: 6
         resources:
           limits:
             cpu: 2000m
             memory: 4096Mi
           requests:
             cpu: 300m
             memory: 512Mi
 ---
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: sonarqube
   namespace: jenkins
 spec:
   rules:
   - host: sonar.luffy.com
     http:
       paths:
       - backend:
           serviceName: sonarqube
           servicePort: 9000
         path: /
 status:
   loadBalancer: {}
```

1. sonarqube服务端安装
2. sonar-scanner的安装下载地址： <https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip>。该地址比较慢，可以在网盘下载（<https://pan.baidu.com/s/1SiEhWyHikTiKl5lEMX1tJg> 提取码: tqb9）。
3. 演示sonar代码扫描功能
   * 在项目根目录中准备配置文件 **sonar-project.properties**
   * 配置sonarqube服务器地址由于sonar-scanner需要将扫描结果上报给sonarqube服务器做质量分析，因此我们需要在sonar-scanner中配置sonarqube的服务器地址：在集群宿主机中测试，先配置一下hosts文件，然后配置sonar的地址：
4. 为了使所有的pod都可以通过sonar.luffy.com访问，可以配置coredns的静态解析

```plain
# 创建sonar数据库
$ kubectl -n jenkins exec -ti postgres-5859dc6f58-mgqz9 bash
#/ psql 
# create database sonar;

## 创建sonarqube服务器
$ kubectl create -f sonar.yaml

## 配置本地hosts解析
172.21.51.67 sonar.luffy.com

## 访问sonarqube，初始用户名密码为 admin/admin
$ curl http://sonar.luffy.com
```

```plain
sonar.projectKey=myblog
sonar.projectName=myblog
# if you want disabled the DTD verification for a proxy problem for example, true by default
sonar.coverage.dtdVerification=false
# JUnit like test report, default value is test.xml
sonar.sources=blog,myblog
```

```plain
$ cat /etc/hosts
172.21.51.67  sonar.luffy.com

$ cat sonar-scanner/conf/sonar-scanner.properties
#----- Default SonarQube server
#sonar.host.url=http://localhost:9000
sonar.host.url=http://sonar.luffy.com
#----- Default source code encoding
#sonar.sourceEncoding=UTF-8
```

\`\`\`

```plain
hosts {
               172.21.51.67 jenkins.luffy.com gitlab.luffy.com sonar.luffy.com
               fallthrough
        }
```

```
- <font style="color:rgb(52, 73, 94);">执行扫描</font>
- <font style="color:rgb(52, 73, 94);">sonarqube界面查看结果</font><font style="color:rgb(52, 73, 94);">登录sonarqube界面查看结果，Quality Gates说明</font>
```

```plain
## 在项目的根目录下执行
 $ /opt/sonar-scanner-4.0.0.1744-linux/bin/sonar-scanner  -X
```

###### 插件安装及配置

1. 集成到tools容器中由于我们的代码拉取、构建任务均是在tools容器中进行，因此我们需要把scanner集成到我们的tools容器中，又因为scanner是一个cli客户端，因此我们直接把包解压好，拷贝到tools容器内部，配置一下PATH路径即可，注意两点：
   * 直接在在tools镜像中配置http://sonar.luffy.com
   * 由于tools已经集成了java环境，因此可以直接剔除scanner自带的jre
     * 删掉sonar-scanner/jre目录
     * 修改sonar-scanner/bin/sonar-scanneruse_embedded_jre=false

```plain
$ cd tools
 $ cp -r /opt/sonar-scanner-4.0.0.1744-linux/ sonar-scanner
 ## sonar配置，由于我们是在Pod中使用，也可以直接配置：sonar.host.url=http://sonarqube:9000
 $ cat sonar-scanner/conf/sonar-scanner.properties
 #----- Default SonarQube server
 sonar.host.url=http://sonar.luffy.com
 
 #----- Default source code encoding
 #sonar.sourceEncoding=UTF-8
 
 $ rm -rf sonar-scanner/jre
 $ vi sonar-scanner/bin/sonar-scanner
 ...
 use_embedded_jre=false
 ...
```

*Dockerfile*

jenkins/custom-images/tools/Dockerfile2

```dockerfile
FROM alpine LABEL maintainer="inspur_lyx@hotmail.com" USER root
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
apk update && \
apk add  --no-cache openrc docker git curl tar gcc g++ make \
bash shadow openjdk8 python2 python2-dev py-pip python3-dev openssl-dev libffi-dev \
libstdc++ harfbuzz nss freetype ttf-freefont && \
mkdir -p /root/.kube && \
usermod -a -G docker root
COPY config /root/.kube/
RUN rm -rf /var/cache/apk/*
# -----------------安装 kubectl--------------------
COPY kubectl /usr/local/bin/ RUN chmod +x /usr/local/bin/kubectl
# ------------------------------------------------
# ---------------安装 sonar-scanner-----------------
COPY sonar-scanner /usr/lib/sonar-scanner RUN ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && chmod +x /usr/local/bin/sonar-scanner ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
# ------------------------------------------------
```

重新构建镜像，并推送到仓库：

```plain

$ docker build . -t 172.21.51.67:5000/devops/tools:v2
$ docker push 172.21.51.67:5000/devops/tools:v2
```

1. 修改Jenkins PodTemplate为了在新的构建任务中可以拉取v2版本的tools镜像，需要更新PodTemplate
2. 安装并配置sonar插件由于sonarqube的扫描的结果需要进行Quality Gates的检测，那么我们在容器中执行完代码扫描任务后，如何知道本次扫描是否通过了Quality Gates，那么就需要借助于sonarqube实现的jenkins的插件。
   * 安装插件插件中心搜索sonarqube，直接安装
   * 配置插件系统管理->系统配置-> **SonarQube servers** ->Add SonarQube
     * Name：sonarqube
     * Server URL：[http://sonar.luffy.com](http://sonar.luffy.com/)
     * Server authentication token① 登录sonarqube -> My Account -> Security -> Generate Token② 登录Jenkins，添加全局凭据，类型为Secret text
   * 如何在jenkinsfile中使用我们在 <https://jenkins.io/doc/pipeline/steps/sonar/> 官方介绍中可以看到：

###### Jenkinsfile集成sonarqube演示

```plain
jenkins/pipelines/p9.yaml
 pipeline {
     agent { label 'jnlp-slave'}
 
     options {
         buildDiscarder(logRotator(numToKeepStr: '10'))
         disableConcurrentBuilds()
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
 
     environment {
         IMAGE_REPO = "172.21.51.67:5000/myblog"
         DINGTALK_CREDS = credentials('dingTalk')
         TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
     }
 
     stages {
         stage('git-log') {
             steps {
                 script{
                     sh "git log --oneline -n 1 > gitlog.file"
                     env.GIT_LOG = readFile("gitlog.file").trim()
                 }
                 sh 'printenv'
             }
         }        
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('CI'){
             failFast true
             parallel {
                 stage('Unit Test') {
                     steps {
                         echo "Unit Test Stage Skip..."
                     }
                 }
                 stage('Code Scan') {
                     steps {
                         container('tools') {
                             withSonarQubeEnv('sonarqube') {
                                 sh 'sonar-scanner -X'
                                 sleep 3
                             }
                             script {
                                 timeout(1) {
                                     def qg = waitForQualityGate('sonarqube')
                                     if (qg.status != 'OK') {
                                         error "未通过Sonarqube的代码质量阈检查，请及时修改！failure: ${qg.status}"
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
         }
         stage('build-image') {
             steps {
                 container('tools') {
                     retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('push-image') {
             steps {
                 container('tools') {
                     retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' deploy/*"
                     timeout(time: 1, unit: 'MINUTES') {
                         sh "kubectl apply -f deploy/"
                     }
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """ 
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

##### 集成RobotFramework实现验收测试

一个基于Python语言，用于验收测试和验收测试驱动开发（ATDD）的通用测试自动化框架，提供了一套特定的语法，并且有非常丰富的测试库 。

###### robot用例简介

```plain
robot/robot.txt
 *** Settings ***
 Library           RequestsLibrary
 Library           SeleniumLibrary
 
 *** Variables ***
 ${demo_url}       http://myblog.luffy/admin
 
 *** Test Cases ***
 api
     [Tags]  critical
     Create Session    api    ${demo_url}
     ${alarm_system_info}    RequestsLibrary.Get Request    api    /
     log    ${alarm_system_info.status_code}
     log    ${alarm_system_info.content}
     should be true    ${alarm_system_info.status_code} == 200
 
 ui
     [Tags]  critical
     ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
     Call Method    ${chrome_options}   add_argument    headless
     Call Method    ${chrome_options}   add_argument    no-sandbox
     ${options}=     Call Method     ${chrome_options}    to_capabilities
     Open Browser    ${demo_url}/    browser=chrome       desired_capabilities=${options}
     sleep    2s
     Capture Page Screenshot
     Page Should Contain    Django
     close browser
 # 使用tools镜像启动容器，来验证手动使用robotframework来做验收测试
 $ docker run --rm -ti 172.21.51.67:5000/devops/tools:v2 bash
 bash-5.0# apk add chromium chromium-chromedriver
 $ cat requirements.txt
 robotframework
 robotframework-seleniumlibrary
 robotframework-databaselibrary
 robotframework-requests
 
 #pip安装必要的软件包
 $ pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt 
 
 #使用robot命令做测试
 $ robot -d artifacts/ robot.txt
```

###### 与tools工具镜像集成

```plain
FROM alpine
 LABEL maintainer="inspur_lyx@hotmail.com"
 USER root
 
 RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
     apk update && \
     apk add  --no-cache openrc docker git curl tar gcc g++ make \
     bash shadow openjdk8 python2 python2-dev py-pip python3-dev openssl-dev libffi-dev \
     libstdc++ harfbuzz nss freetype ttf-freefont chromium chromium-chromedriver && \
     mkdir -p /root/.kube && \
     usermod -a -G docker root
 
 
 COPY config /root/.kube/
 
 COPY requirements.txt /
 
 RUN pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt 
 
 
 RUN rm -rf /var/cache/apk/* && \
     rm -rf ~/.cache/pip
 
 #-----------------安装 kubectl--------------------#
 COPY kubectl /usr/local/bin/
 RUN chmod +x /usr/local/bin/kubectl
 # ------------------------------------------------#
 
 #---------------安装 sonar-scanner-----------------#
 COPY sonar-scanner /usr/lib/sonar-scanner
 RUN ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && chmod +x /usr/local/bin/sonar-scanner
 ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
 # ------------------------------------------------#
 $ docker build . -t 172.21.51.67:5000/devops/tools:v3
 
 $ docker push 172.21.51.67:5000/devops/tools:v3
```

更新Jenkins中kubernetes中的containers template

###### 插件安装及配置

为什么要安装robot插件？

1. 安装robotFramework
   * 插件中心搜索robotframework，直接安装
   * tools集成robot命令（之前已经安装）
2. 与jenkinsfile的集成

```plain
container('tools') {
         sh 'robot -i critical  -d artifacts/ robot.txt || echo ok'
         echo "R ${currentBuild.result}"
         step([
             $class : 'RobotPublisher',
             outputPath: 'artifacts/',
             outputFileName : "output.xml",
             disableArchiveOutput : false,
             passThreshold : 80,
             unstableThreshold: 20.0,
             onlyCritical : true,
             otherFiles : "*.png"
         ])
         echo "R ${currentBuild.result}"
         archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
     }
```

###### 实践通过Jenkinsfile实现demo项目的验收测试

python-demo项目添加robot.txt文件：

```plain
jenkins/pipelines/p10.yaml
 pipeline {
     agent { label 'jnlp-slave'}
 
     options {
         buildDiscarder(logRotator(numToKeepStr: '10'))
         disableConcurrentBuilds()
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
 
     environment {
         IMAGE_REPO = "172.21.51.67:5000/myblog"
         DINGTALK_CREDS = credentials('dingTalk')
         TAB_STR = "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
     }
 
     stages {
         stage('git-log') {
             steps {
                 script{
                     sh "git log --oneline -n 1 > gitlog.file"
                     env.GIT_LOG = readFile("gitlog.file").trim()
                 }
                 sh 'printenv'
             }
         }        
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS = env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('CI'){
             failFast true
             parallel {
                 stage('Unit Test') {
                     steps {
                         echo "Unit Test Stage Skip..."
                     }
                 }
                 stage('Code Scan') {
                     steps {
                         container('tools') {
                             withSonarQubeEnv('sonarqube') {
                                 sh 'sonar-scanner -X'
                                 sleep 3
                             }
                             script {
                                 timeout(1) {
                                     def qg = waitForQualityGate('sonarqube')
                                     if (qg.status != 'OK') {
                                         error "未通过Sonarqube的代码质量阈检查，请及时修改！failure: ${qg.status}"
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
         }
         stage('build-image') {
             steps {
                 container('tools') {
                     retry(2) { sh 'docker build . -t ${IMAGE_REPO}:${GIT_COMMIT}'}
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('push-image') {
             steps {
                 container('tools') {
                     retry(2) { sh 'docker push ${IMAGE_REPO}:${GIT_COMMIT}'}
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     sh "sed -i 's#{{IMAGE_URL}}#${IMAGE_REPO}:${GIT_COMMIT}#g' deploy/*"
                     timeout(time: 1, unit: 'MINUTES') {
                         sh "kubectl apply -f deploy/;sleep 20;"
                     }
                 }
                 updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                 script{
                     env.BUILD_TASKS += env.STAGE_NAME + "√..." + env.TAB_STR
                 }
             }
         }
         stage('Accept Test') {
             steps {
                     container('tools') {
                         sh 'robot -i critical  -d artifacts/ robot.txt|| echo ok'
                         echo "R ${currentBuild.result}"
                         step([
                             $class : 'RobotPublisher',
                             outputPath: 'artifacts/',
                             outputFileName : "output.xml",
                             disableArchiveOutput : false,
                             passThreshold : 80,
                             unstableThreshold: 20.0,
                             onlyCritical : true,
                             otherFiles : "*.png"
                         ])
                         echo "R ${currentBuild.result}"
                         archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
                     }
             }
         }
     }
     post {
         success { 
             echo 'Congratulations!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """ 
         }
         failure {
             echo 'Oh no!'
             sh """
                 curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                     -H 'Content-Type: application/json' \
                     -d '{
                         "msgtype": "markdown",
                         "markdown": {
                             "title":"myblog",
                             "text": "😖❌ 构建失败 ❌😖  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}  \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${BUILD_TASKS}"
                         }
                     }'
             """
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

在Jenkins中查看robot的构建结果。

#### 小结

思路：

1. 讲解最基础的Jenkins的使用
2. Pipeline流水线的使用
3. Jenkinsfile的使用
4. 多分支流水线的使用
5. 与Kubernetes集成，动态jnlp slave pod的使用
6. 与sonarqube集成，实现代码扫描
7. 与Robotframework集成，实现验收测试

问题：

1. Jenkinsfile过于冗长
2. 多个项目配置Jenkinsfile，存在很多重复内容
3. 没有实现根据不同分支来部署到不同的环境
4. Java项目的构建
5. k8s部署后，采用等待的方式执行后续步骤，不合理

  

# 06_基于sharedLibrary进行CI/CD流程的优化

由于公司内部项目众多，大量的项目使用同一套流程做CICD

* 那么势必会存在大量的重复代码
* 一旦某个公共的地方需要做调整，每个项目都需要修改

因此本章主要通过使用groovy实现Jenkins的sharedLibrary的开发，以提取项目在CICD实践过程中的公共逻辑，提供一系列的流程的接口供公司内各项目调用。

开发完成后，对项目进行Jenkinsfile的改造，最后仅需通过简单的Jenkinsfile的配置，即可优雅的完成CICD流程的整个过程，此方式已在大型企业内部落地应用。

##### Library工作模式

由于流水线被组织中越来越多的项目所采用，常见的模式很可能会出现。 在多个项目之间共享流水线有助于减少冗余并保持代码 "DRY"。

流水线支持引用 "共享库" ，可以在外部源代码控制仓库中定义并加载到现有的流水线中。

 @Library('my-shared-library') \_

在实际运行过程中，会把library中定义的groovy功能添加到构建目录中：

 /var/jenkins_home/jobs/test-maven-build/branches/feature-CDN-2904.cm507o/builds/2/libs/my-shared-library/vars/devops.groovy

使用library后，Jenkinsfile大致的样子如下：

```plain
@Library('my-shared-library') _
 
 ...
   stages {
     stage('build image') {
       steps {
          container('tools') {
            devops.buildImage("Dockerfile","172.21.51.67:5000/demo:latest")
          }
       }
     }
   }
 
   post {
     success {
       script {
           container('tools') {
               devops.notificationSuccess("dingTalk")
           }
       }
     }
   }
 ...
```

##### 开发环境搭建

补录章节：Groovy及SpringBoot、SpringCloud都会使用

* java
* groovy
* intelliJ idea

###### 下载安装包

链接：<https://pan.baidu.com/s/1B-bg2_IsB8dU7_62IEtnTg> 提取码：wx6j

###### 安装java

安装路径：D:\software\jdk

环境变量：

* JAVA_HOME D:\software\jdk
* CLASSPATH .;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;
* PATH %JAVA_HOME%\bin

###### 安装groovy

解压路径：D:\software\groovy-3.0.2

环境变量：

* GROOVY_PATH D:\software\groovy-3.0.2
* PATH D:\software\groovy-3.0.2\bin

###### 安装idea

安装路径：D:\software\IntelliJ IDEA 2019.2.3

新建项目测试

##### Library代码结构介绍

共享库的目录结构如下:

```plain
(root)
 +- src                     # Groovy source files
 |   +- org
 |       +- foo
 |           +- Bar.groovy  # for org.foo.Bar class
 +- vars
 |   +- foo.groovy          # for global 'foo' variable
 |   +- foo.txt             # help for 'foo' variable
```

src 目录应该看起来像标准的 Java 源目录结构。当执行流水线时，该目录被添加到类路径下。

vars 目录定义可从流水线访问的全局变量的脚本。 每个 \*.groovy 文件的基名应该是一个 Groovy (~ Java) 标识符, 通常是 camelCased。

##### Groovy基本语法介绍

新建Groovy项目

* 变量使用数据类型的本地语法，或者使用def关键字
* 方法
  * 调用本地方法
  * 调用类中的方法\`\`\`powershellpackage demodef sayHi(String content) { return ("hi, " + content)}

##### Hello.groovy

```plain
// Defining a variable in lowercase  
 int x = 5;
 
 // Defining a variable in uppercase  
 int X = 6; 
 
 // Defining a variable with the underscore in it's name 
 def _Name = "Joe"; 
 
 println(x); 
 println(X); 
 println(_Name);
```

```plain
def sum(int a, int b){
     return a + b
 }
 
 println(sum(1,2))
```

````plain
# Demo.groovy
 import demo.Hello
 
 def demo() {
     return new Hello().sayHi("devops")
 }
 println(demo())
 
 
 
 # 级联调用
 # Hello.groovy
 package demo
 
 def init(String content) {
     this.content = content
     return this
 }
 
 def sayHi() {
     println("hi, " + this.content)
     return this
 }
 
 def sayBye() {
     println("bye " + this.content)
 }
 
 
 # Demo.groovy
 import demo.Hello
 
 def demo() {
     new Hello().init("devops").sayHi().sayBye()
 }
 
 demo()
 
 ```
````

* <font style="color:rgb(52, 73, 94);">异常捕获</font>
* <font style="color:rgb(52, 73, 94);">计时器与循环</font><font style="color:rgb(52, 73, 94);">\`</font><font style="color:rgb(52, 73, 94);">\`\`groovy import groovy.time.TimeCategory</font>

```plain
def exceptionDemo(){
     try {
         def val = 10 / 0
         println(val)
     }catch(Exception e) {
         println(e.toString())
         throw e
     }
 }
 exceptionDemo()
```

<font style="color:rgb(52, 73, 94);">use( TimeCategory ) { def endTime = TimeCategory.plus(new Date(), TimeCategory.getSeconds(15)) def counter = 0 while(true) { println(counter++) sleep(1000) if (new Date() >= endTime) { println("done") break } } }</font>

````plain
- 解析yaml文件
 
   ```powershell
   import org.yaml.snakeyaml.Yaml
 
   def readYaml(){
       def content = new File('myblog.yaml').text
       Yaml parser = new Yaml()
       def data = parser.load(content)
       def kind = data["kind"]
       def name = data["metadata"]["name"]
       println(kind)
       println(name)
   }
   readYaml()
````

##### library与Jenkins集成

先来看一下如何使用shared library实现最简单的helloworld输出功能，来理清楚使用shared library的流程。

###### Hello.groovy

```plain
package com.luffy.devops
 
 /**
 * @author Yongxin
 * @version v0.1
  */
 
 /**
  * say hello
  * @param content
  */
 def hello(String content) {
     this.content = content
     return this
 }
 
 
 def sayHi() {
     echo "Hi, ${this.content},how are you?"
     return this
 }
 
 def answer() {
     echo "${this.content}: fine, thank you, and you?"
     return this
 }
 
 def sayBye() {
     echo "i am fine too , ${this.content}, Bye!"
     return this
 }
```

在gitlab创建项目，把library代码推送到镜像仓库。

###### 配置Jenkins

\[系统管理] -> \[系统设置] -> \[ **Global Pipeline Libraries** ]

* Library Name：luffy-devops
* Default Version：master
* Source Code Management：Git

###### Jenkinsfile中引用

```plain
jenkins/pipelines/p11.yaml
 @Library('luffy-devops') _
 
 pipeline {
     agent { label 'jnlp-slave'}
 
     stages {
         stage('hello-devops') {
             steps {
                 script {
                     devops.hello("树哥").sayHi().answer().sayBye()
                 }
             }
         } 
     }
     post {
         success { 
             echo 'Congratulations!'
         }
         failure {
             echo 'Oh no!'
         }
         always { 
             echo 'I will always say Hello again!'
         }
     }
 }
```

创建vars/devops.groovy

```plain
import com.luffy.devops.Hello

def hello(String content) {
    return new Hello().hello(content)
}
```

##### library集成镜像构建及推送

需要实现的逻辑点：

* docker build，docker push，docker login
* 账户密码，jenkins凭据，（library中获取凭据内容），
* docker login 172.21.51.67:5000
* try catch

###### 镜像构建逻辑实现

```plain
devops.groovy
/**
 *
 * @param repo, 172.21.51.67:5000/demo/myblog/xxx/
 * @param tag, v1.0
 * @param dockerfile
 * @param credentialsId
 * @param context
 */
def docker(String repo, String tag, String credentialsId, String dockerfile="Dockerfile", String context=".") {
    return new Docker().docker(repo, tag, credentialsId, dockerfile, context)
}
Docker.groovy
```

逻辑中需要注意的点：

* 构建和推送镜像，需要登录仓库（需要认证）
* 构建成功或者失败，需要将结果推给gitlab端
* 为了将构建过程推送到钉钉消息中，需要将构建信息统一收集

```plain
package com.luffy.devops

/**
 *
 * @param repo
 * @param tag
 * @param credentialsId
 * @param dockerfile
 * @param context
 * @return
 */
def docker(String repo, String tag, String credentialsId, String dockerfile="Dockerfile", String context="."){
    this.repo = repo
    this.tag = tag
    this.dockerfile = dockerfile
    this.credentialsId = credentialsId
    this.context = context
    this.fullAddress = "${this.repo}:${this.tag}"
    this.isLoggedIn = false
    return this
}

/**
 * build image
 * @return
 */
def build() {
    this.login()
    retry(3) {
        try {
            sh "docker build ${this.context} -t ${this.fullAddress} -f ${this.dockerfile} "
        }catch (Exception exc) {
            throw exc
        }
        return this
    }
}

/**
 * push image
 * @return
 */
def push() {
    this.login()
    retry(3) {
        try {
            sh "docker push ${this.fullAddress}"
        }catch (Exception exc) {
            throw exc
        }
    }
    return this
}

/**
 * docker registry login
 * @return
 */
def login() {
    if(this.isLoggedIn || credentialsId == ""){
        return this
    }
    // docker login
    withCredentials([usernamePassword(credentialsId: this.credentialsId, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        def regs = this.getRegistry()
        retry(3) {
            try {
                sh "docker login ${regs} -u $USERNAME -p $PASSWORD"
            } catch (Exception exc) {
                echo "docker login err, " + exc.toString()
            }
        }
    }
    this.isLoggedIn = true;
    return this;
}

/**
 * get registry server
 * @return
 */
def getRegistry(){
    def sp = this.repo.split("/")
    if (sp.size() > 1) {
        return sp[0]
    }
    return this.repo
}
Jenkinsfile
```

需要先在Jenkins端创建仓库登录凭据credential-registry

```plain
@Library('luffy-devops') _

pipeline {
    agent { label 'jnlp-slave'}
    options {
        timeout(time: 20, unit: 'MINUTES')
        gitLabConnection('gitlab')
    }
    environment {
        IMAGE_REPO = "172.21.51.67:5000/demo/myblog"
        IMAGE_CREDENTIAL = "credential-registry"
    }
    stages {
        stage('checkout') {
            steps {
                container('tools') {
                    checkout scm
                }
            }
        }
        stage('docker-image') {
            steps {
                container('tools') {
                    script{
                        devops.docker(
                            "${IMAGE_REPO}",
                            "${GIT_COMMIT}",
                            IMAGE_CREDENTIAL                          
                        ).build().push()
                    }
                }
            }
        }
    }
    post {
        success { 
            echo 'Congratulations!'
        }
        failure {
            echo 'Oh no!'
        }
    }
}
```

###### 丰富构建通知逻辑

目前的构建镜像逻辑中缺少如下内容：

* try逻辑中，若发生异常，是否该把异常抛出
  * 若直接抛出异常可能会导致多次重复的异常信息
  * 若不抛出，则如果未构建成功镜像，流水线感知不到错误
* 通知gitlab端构建任务及状态
* 构建通知格式

需要针对上述问题，做出优化

1. 优化try逻辑

```plain
def build() {
    this.login()
    def isSuccess = false
    def errMsg
    retry(3) {
        try {
            sh "docker build ${this.context} -t ${this.fullAddress} -f ${this.dockerfile}"
            isSuccess = true
        }catch (Exception err) {
            //ignore
            errMsg = err.toString()
        }
        // check if build success
        if(isSuccess){
            //todo
        }else {
            // throw exception，aborted pipeline
            error errMsg
        }
        return this
    }
}
```

1. 通知gitlab端构建任务及状态

```plain
def build() {
    this.login()
    def isSuccess = false
    def errMsg = ""
    retry(3) {
        try {
            sh "docker build ${this.context} -t ${this.fullAddress} -f ${this.dockerfile} "
            isSuccess = true
        }catch (Exception err) {
            //ignore
            errMsg = err.toString()
        }
        // check if build success
        def stage = env.STAGE_NAME + '-build'
        if(isSuccess){
            updateGitlabCommitStatus(name: '${stage}', state: 'success')
        }else {
            updateGitlabCommitStatus(name: '${stage}', state: 'failed')
            // throw exception，aborted pipeline
            error errMsg
        }

        return this
    }
}
```

1. 钉钉消息通知格式由于每个stage都需要构建通知任务，因此抽成公共的逻辑，为各stage调用BuildMessage.groovy

```plain
package com.luffy.devops

def updateBuildMessage(String source, String add) {
    if(!source){
        source = ""
    }
    env.BUILD_TASKS = source + add + "\n                    \n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    return env.BUILD_TASKS
}
```

Docker.groovy 中调用

\`\`\`powershell def getObject(String repo, String tag, String credentialsId, String dockerfile="Dockerfile", String context="."){

}

...

def build() { ... // check if build success def stage = env.STAGE_NAME + '-build' if(isSuccess){ updateGitlabCommitStatus(name: '${stage}', state: 'success') this.msg.updateBuildMessage(env.BUILD_TASKS, "${stage} OK... √") }else { updateGitlabCommitStatus(name: '${stage}', state: 'failed') this.msg.updateBuildMessage(env.BUILD_TASKS, "${stage} Failed... x") // throw exception，aborted pipeline error errMsg }

```plain
return this
   }
```

}

````plain
使用`Jenkinsfile`来验证上述修改是否正确：

```groovy
@Library('luffy-devops') _

pipeline {
    agent { label 'jnlp-slave'}
    options {
        timeout(time: 20, unit: 'MINUTES')
        gitLabConnection('gitlab')
    }
    environment {
        IMAGE_REPO = "172.21.51.67:5000/demo/myblog"
        IMAGE_CREDENTIAL = "credential-registry"
        DINGTALK_CREDS = credentials('dingTalk')
    }
    stages {
        stage('checkout') {
            steps {
                container('tools') {
                    checkout scm
                }
            }
        }
        stage('git-log') {
            steps {
                script{
                    sh "git log --oneline -n 1 > gitlog.file"
                    env.GIT_LOG = readFile("gitlog.file").trim()
                }
                sh 'printenv'
            }
        } 
        stage('build-image') {
            steps {
                container('tools') {
                    script{
                        devops.docker(
                            "${IMAGE_REPO}",
                            "${GIT_COMMIT}",
                            IMAGE_CREDENTIAL                          
                        ).build().push()
                    }
                }
            }
        }
    }
    post {
        success { 
            sh """
                curl 'https://oapi.dingtalk.com/robot/send?access_token=${DINGTALK_CREDS_PSW}' \
                    -H 'Content-Type: application/json' \
                    -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title":"myblog",
                            "text": "😄👍 构建成功 👍😄  \n**项目名称**：luffy  \n**Git log**: ${GIT_LOG}   \n**构建分支**: ${BRANCH_NAME}   \n**构建地址**：${RUN_DISPLAY_URL}  \n**构建任务**：${env.BUILD_TASKS}"
                        }
                    }'
            """ 
        }
        failure {
            echo 'Oh no!'
        }
    }
}
````

<font style="color:rgb(52, 73, 94);">接下来需要将</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">push</font><font style="color:rgb(52, 73, 94);">和</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">login</font><font style="color:rgb(52, 73, 94);">方法做同样的改造</font>

<font style="color:rgb(52, 73, 94);">最终的Docker.groovy文件为：</font>

```plain
package com.luffy.devops

/**
 *
 * @param repo
 * @param tag
 * @param credentialsId
 * @param dockerfile
 * @param context
 * @return
 */
def docker(String repo, String tag, String credentialsId, String dockerfile="Dockerfile", String context="."){
    this.repo = repo
    this.tag = tag
    this.dockerfile = dockerfile
    this.credentialsId = credentialsId
    this.context = context
    this.fullAddress = "${this.repo}:${this.tag}"
    this.isLoggedIn = false
    this.msg = new BuildMessage()
    return this
}

/**
 * build image
 * @return
 */
def build() {
    this.login()
    def isSuccess = false
    def errMsg = ""
    retry(3) {
        try {
            sh "docker build ${this.context} -t ${this.fullAddress} -f ${this.dockerfile} "
            isSuccess = true
        }catch (Exception err) {
            //ignore
            errMsg = err.toString()
        }
        // check if build success
        def stage = env.STAGE_NAME + '-build'
        if(isSuccess){
            updateGitlabCommitStatus(name: "${stage}", state: 'success')
            this.msg.updateBuildMessage(env.BUILD_TASKS, "${stage} OK...  √")
        }else {
            updateGitlabCommitStatus(name: "${stage}", state: 'failed')
            this.msg.updateBuildMessage(env.BUILD_TASKS, "${stage} Failed...  x")
            // throw exception，aborted pipeline
            error errMsg
        }

        return this
    }
}

/**
 * push image
 * @return
 */
def push() {
    this.login()
    def isSuccess = false
    def errMsg = ""
    retry(3) {
        try {
            sh "docker push ${this.fullAddress}"
            isSuccess = true
        }catch (Exception err) {
            //ignore
            errMsg = err.toString()
        }
    }
    // check if build success
    def stage = env.STAGE_NAME + '-push'
    if(isSuccess){
        updateGitlabCommitStatus(name: "${stage}", state: 'success')
        this.msg.updateBuildMessage(env.BUILD_TASKS, "${stage} OK...  √")
    }else {
        updateGitlabCommitStatus(name: "${stage}", state: 'failed')
        this.msg.updateBuildMessage(env.BUILD_TASKS, "${stage} Failed...  x")
        // throw exception，aborted pipeline
        error errMsg
    }
    return this
}

/**
 * docker registry login
 * @return
 */
def login() {
    if(this.isLoggedIn || credentialsId == ""){
        return this
    }
    // docker login
    withCredentials([usernamePassword(credentialsId: this.credentialsId, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        def regs = this.getRegistry()
        retry(3) {
            try {
                sh "docker login ${regs} -u $USERNAME -p $PASSWORD"
            } catch (Exception ignored) {
                echo "docker login err, ${ignored.toString()}"
            }
        }
    }
    this.isLoggedIn = true;
    return this;
}

/**
 * get registry server
 * @return
 */
def getRegistry(){
    def sp = this.repo.split("/")
    if (sp.size() > 1) {
        return sp[0]
    }
    return this.repo
}
```

<font style="color:rgb(52, 73, 94);">再次测试构建</font>

##### <font style="color:rgb(52, 73, 94);">library集成k8s服务部署</font>

###### <font style="color:rgb(119, 119, 119);">library实现部署简单版</font>

```plain
devops.groovy
/**
 * kubernetes deployer
 * @param resourcePath
 */
def deploy(String resourcePath){
    return new Deploy().init(resourcePath)
}
```

<font style="color:rgb(52, 73, 94);">新增</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Deploy.groovy</font>

```plain
package com.luffy.devops

def init(String resourcePath){
    this.resourcePath = resourcePath
    this.msg = new BuildMessage()
    return this
}

def start(){
    try{
        //env.CURRENT_IMAGE用来存储当前构建的镜像地址，需要在Docker.groovy中设置值
        sh "sed -i 's#{{IMAGE_URL}}#${env.CURRENT_IMAGE}#g' ${this.resourcePath}/*"
        sh "kubectl apply -f ${this.resourcePath}"
        updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
        this.msg.updateBuildMessage(env.BUILD_TASKS, "${env.stage_name} OK...  √")
    } catch (Exception exc){
        updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'failed')
        this.msg.updateBuildMessage(env.BUILD_TASKS, "${env.stage_name} fail...  √")
        throw exc
    }
}
```

<font style="color:rgb(52, 73, 94);">修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Docker.groovy</font>

```plain
def push() {
    this.login()
    def isSuccess = false
    def errMsg = ""
    retry(3) {
        try {
            sh "docker push ${this.fullAddress}"
            //把当前推送的镜像地址记录在环境变量中
            env.CURRENT_IMAGE = this.fullAddress
            isSuccess = true
        }catch (Exception err) {
            //ignore
            errMsg = err.toString()
        }
```

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Jenkinsfile</font><font style="color:rgb(52, 73, 94);"> 中添加如下部分：</font>

```plain
stage('deploy') {
            steps {
                container('tools') {
                    script{
                        devops.deploy("deploy").start()
                    }
                }
            }
        }
```

###### <font style="color:rgb(119, 119, 119);">library实现自动部署优化版</font>

<font style="color:rgb(52, 73, 94);">简单版本最明显的问题就是无法检测部署后的Pod状态，如果想做集成测试，通常要等到最新版本的Pod启动后再开始。因此有必要在部署的时候检测Pod是否正常运行。</font>

<font style="color:rgb(52, 73, 94);">比如要去检查myblog应用的pod是否部署正常，人工检查的大致步骤：</font>

1. <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">kubectl -n luffy get pod</font><font style="color:rgb(52, 73, 94);">，查看pod列表</font>
2. <font style="color:rgb(52, 73, 94);">找到列表中带有myblog关键字的running的pod</font>
3. <font style="color:rgb(52, 73, 94);">查看上述running pod数，是否和myblog的deployment中定义的replicas副本数一致</font>
4. <font style="color:rgb(52, 73, 94);">若一致，则检查结束，若不一致，可能稍等几秒钟，再次执行相同的检查操作</font>
5. <font style="color:rgb(52, 73, 94);">如果5分钟了还没有检查通过，则大概率是pod有问题，通过查看日志进一步排查</font>

<font style="color:rgb(52, 73, 94);">如何通过library代码实现上述过程：</font>

1. <font style="color:rgb(52, 73, 94);">library如何获取myblog的pod列表？</font>
   * <font style="color:rgb(52, 73, 94);">首先要知道本次部署的是哪个workload，因此需要调用者传递workload的yaml文件路径</font>
   * <font style="color:rgb(52, 73, 94);">library解析workload.yaml文件，找到如下值：</font>
     * <font style="color:rgb(52, 73, 94);">pod所在的namespace</font>
     * <font style="color:rgb(52, 73, 94);">pod中使用的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">labels</font><font style="color:rgb(52, 73, 94);">标签</font>
   * <font style="color:rgb(52, 73, 94);">使用如下命令查找该workload关联的pod</font>
2. <font style="color:rgb(52, 73, 94);">如何确定步骤1中的pod的状态？</font>
3. <font style="color:rgb(52, 73, 94);">如何检测所有的副本数都是正常的？</font>

```plain
$ kubectl -n <namespace> get po -l <key1=value1> -l <key2=value2>

# 如查找myblog的pod
$ kubectl -n luffy get po -l app=myblog
```

```plain
# 或者可以直接进行提取状态
$ kubectl -n luffy get po -l app=myblog -ojsonpath='{.items[0].status.phase}'

# 以json数组的形式存储
$ kubectl -n luffy get po -l app=myblog -o json
```

```plain
# 以json数组的形式存储
$ kubectl -n luffy get po -l app=myblog -o json

# 遍历数组，检测每一个pod查看是否均正常（terminating和evicted除外）
```

1. <font style="color:rgb(52, 73, 94);">如何实现在5分钟的时间内，若pod状态符合预期，则退出检测循环，若不符合预期则继续检测</font>

```plain
use( TimeCategory ) {
  def endTime = TimeCategory.plus(new Date(), TimeCategory.getMinutes(timeoutMinutes,5))
  while (true) {
    if (new Date() >= endTime) {
        //超时了，则宣告pod状态不对
        updateGitlabCommitStatus(name: 'deploy', state: 'failed')
        throw new Exception("deployment timed out...")
    }
    //循环检测当前deployment下的pod的状态
    try {
      if (this.isDeploymentReady()) {
          readyCount++
          if(readyCount > 5){
            updateGitlabCommitStatus(name: 'deploy', state: 'success')
            break;
          }
      }else {
          readyCount = 0
      }catch (Exception exc){
          echo exc.toString()
      }
      //每次检测若不满足所有pod均正常，则sleep 5秒钟后继续检测
      sleep(5)
    }
  }
```

devops.groovy

<font style="color:rgb(52, 73, 94);">通过添加参数 watch来控制是否在pipeline中观察pod的运行状态</font>

```plain
/**
 * 
 * @param resourcePath
 * @param watch
 * @param workloadFilePath
 * @return
 */
def deploy(String resourcePath, Boolean watch = true, String workloadFilePath){
    return new Deploy().init(resourcePath, watch, workloadFilePath)
}
```

<font style="color:rgb(52, 73, 94);">完整版的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Deploy.groovy</font>

```plain
package com.luffy.devops

import org.yaml.snakeyaml.Yaml
import groovy.json.JsonSlurperClassic
import groovy.time.TimeCategory

def init(String resourcePath, Boolean watch, String workloadFilePath) {
    this.resourcePath = resourcePath
    this.msg = new BuildMessage()
    this.watch = watch
    this.workloadFilePath = workloadFilePath
    if(!resourcePath && !workloadFilePath){
        throw Exception("illegal resource path")
    }
    return this
}

def start(){
    try{
        sh "sed -i 's#{{IMAGE_URL}}#${env.CURRENT_IMAGE}#g' ${this.resourcePath}/*"
        sh "kubectl apply -f ${this.resourcePath}"
    } catch (Exception exc){
        updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'failed')
        this.msg.updateBuildMessage(env.BUILD_TASKS, "${env.stage_name} fail...  √")
        throw exc
    }

    if (this.watch) {

        // 初始化workload文件
        initWorkload()
        String namespace = this.workloadNamespace
        String name = env.workloadName
        if(env.workloadType.toLowerCase() == "deployment"){
            echo "begin watch pod status from deployment ${env.workloadName}..."
            monitorDeployment(namespace, name)
        }else {
            //todo
            echo "workload type ${env.workloadType} does not support for now..."
        }

    }else {
        updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
        this.msg.updateBuildMessage(env.BUILD_TASKS, "${env.STAGE_NAME} OK...  √")
    }

}

def initWorkload() {
    try {
        def content = readFile this.workloadFilePath
        Yaml parser = new Yaml()
        def data = parser.load(content)
        def kind = data["kind"]
        if (!kind) {
            throw Exception("workload file ${kind} illegal, will exit pipeline!")
        }
        env.workloadType = kind
        echo "${data}"
        this.workloadNamespace = data["metadata"]["namespace"]
        if (!this.workloadNamespace){
            this.workloadNamespace = "default"
        }
        env.workloadName = data["metadata"]["name"]

    } catch (Exception exc) {
        echo "failed to readFile ${this.workloadFilePath},exception: ${exc}."
        throw exc
    }
}

/**
 *
 * @param namespace
 * @param name
 * @param timeoutMinutes
 * @param sleepTime
 * @return
 */
def monitorDeployment(String namespace, String name, int timeoutMinutes = 5, sleepTime = 3) {
    def readyCount = 0
    def readyTarget = 3
    use( TimeCategory ) {
        def endTime = TimeCategory.plus(new Date(), TimeCategory.getMinutes(timeoutMinutes))
        def lastRolling
        while (true) {
            // checking timeout
            if (new Date() >= endTime) {
                echo "timeout, printing logs..."
                this.printContainerLogs(lastRolling)
                updateGitlabCommitStatus(name: 'deploy', state: 'failed')
                this.msg.updateBuildMessage(env.BUILD_TASKS, "${env.STAGE_NAME} Failed...  x")
                throw new Exception("deployment timed out...")
            }
            // checking deployment status
            try {
                def rolling = this.getResource(namespace, name, "deployment")
                lastRolling = rolling
                if (this.isDeploymentReady(rolling)) {
                    readyCount++
                    echo "ready total count: ${readyCount}"
                    if (readyCount >= readyTarget) {
                        updateGitlabCommitStatus(name: env.STAGE_NAME, state: 'success')
                        this.msg.updateBuildMessage(env.BUILD_TASKS, "${env.STAGE_NAME} OK...  √")
                        break
                    }

                } else {
                    readyCount = 0
                    echo "reseting ready total count: ${readyCount}，print pods event logs"
                    this.printContainerLogs(lastRolling)
                    sh "kubectl get pod -n ${namespace} -o wide"
                }
            } catch (Exception exc) {
                updateGitlabCommitStatus(name: 'deploy', state: 'failed')
                this.msg.updateBuildMessage(env.BUILD_RESULT, "${env.STAGE_NAME} Failed...  ×")
                echo "error: ${exc}"
            }
            sleep(sleepTime)
        }
    }
    return this
}

def getResource(String namespace = "default", String name, String kind="deployment") {
    sh "kubectl get ${kind} -n ${namespace} ${name} -o json > ${namespace}-${name}-yaml.yml"
    def jsonStr = readFile "${namespace}-${name}-yaml.yml"
    def jsonSlurper = new JsonSlurperClassic()
    def jsonObj = jsonSlurper.parseText(jsonStr)
    return jsonObj
}

def printContainerLogs(deployJson) {
    if (deployJson == null) {
        return;
    }
    def namespace = deployJson.metadata.namespace
    def name = deployJson.metadata.name
    def labels=""
    deployJson.spec.template.metadata.labels.each { k, v ->
        labels = "${labels} -l=${k}=${v}"
    }
    sh "kubectl describe pods -n ${namespace} ${labels}"
}

def isDeploymentReady(deployJson) {
    def status = deployJson.status
    def replicas = status.replicas
    def unavailable = status['unavailableReplicas']
    def ready = status['readyReplicas']
    if (unavailable != null) {
        return false
    }
    def deployReady = (ready != null && ready == replicas)
    // get pod information
    if (deployJson.spec.template.metadata != null && deployReady) {
        if (deployJson.spec.template.metadata.labels != null) {
            def labels=""
            def namespace = deployJson.metadata.namespace
            def name = deployJson.metadata.name
            deployJson.spec.template.metadata.labels.each { k, v ->
                labels = "${labels} -l=${k}=${v}"
            }
            if (labels != "") {
                sh "kubectl get pods -n ${namespace} ${labels} -o json > ${namespace}-${name}-json.json"
                def jsonStr = readFile "${namespace}-${name}-json.json"
                def jsonSlurper = new JsonSlurperClassic()
                def jsonObj = jsonSlurper.parseText(jsonStr)
                def totalCount = 0
                def readyCount = 0
                jsonObj.items.each { k, v ->
                    echo "pod phase ${k.status.phase}"
                    if (k.status.phase != "Terminating" && k.status.phase != "Evicted") {
                        totalCount++;
                        if (k.status.phase == "Running") {
                            readyCount++;
                        }
                    }
                }
                echo "Pod running count ${totalCount} == ${readyCount}"
                return totalCount > 0 && totalCount == readyCount
            }
        }
    }
    return deployReady
}
```

<font style="color:rgb(52, 73, 94);">修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Jenkinsfile</font><font style="color:rgb(52, 73, 94);"> 调用部分：</font>

```plain
stage('deploy') {
            steps {
                container('tools') {
                    script{
                        devops.deploy("deploy", true, "deploy/deployment.yaml").start()
                    }
                }
            }
        }
```

##### <font style="color:rgb(52, 73, 94);">library实现即时消息推送</font>

###### <font style="color:rgb(119, 119, 119);">实现消息通知</font>

<font style="color:rgb(52, 73, 94);">由于发送消息通知属于通用的功能，因此有必要把消息通知抽象成为通用的功能。</font>

```plain
devops.groovy
/**
 * notificationSuccess
 * @param project
 * @param receiver
 * @param credentialsId
 * @param title
 * @return
 */
def notificationSuccess(String project, String receiver="dingTalk", String credentialsId="dingTalk", String title=""){
    new Notification().getObject(project, receiver, credentialsId, title).notification("success")
}

/**
 * notificationFailed
 * @param project
 * @param receiver
 * @param credentialsId
 * @param title
 * @return
 */
def notificationFailed(String project, String receiver="dingTalk", String credentialsId="dingTalk", String title=""){
    new Notification().getObject(project, receiver, credentialsId, title).notification("failure")
}
```

<font style="color:rgb(52, 73, 94);">新建</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Notification.groovy</font><font style="color:rgb(52, 73, 94);">文件：</font>

```plain
package com.luffy.devops
 
 /**
  *
  * @param type
  * @param credentialsId
  * @param title
  * @return
  */
 def getObject(String project, String receiver, String credentialsId, String title) {
     this.project = project
     this.receiver = receiver
     this.credentialsId = credentialsId
     this.title = title
     return this
 }
 
 
 def notification(String type){
     String msg ="😄👍 ${this.title} 👍😄"
 
     if (this.title == "") {
         msg = "😄👍 流水线成功啦 👍😄"
     }
     // failed
     if (type == "failure") {
         msg ="😖❌ ${this.title} ❌😖"
         if (this.title == "") {
             msg = "😖❌ 流水线失败了 ❌😖"
         }
     }
     String title = msg
     // rich notify msg
     msg = genNotificationMessage(msg)
     if( this.receiver == "dingTalk") {
         try {
             //new DingTalk().markDown(title, msg, this.credentialsId)
         } catch (Exception ignored) {}
     }else if(this.receiver == "wechat") {
         //todo
     }else if (this.receiver == "email"){
         //todo
     }else{
         error "no support notify type!"
     }
 }
 
 
 /**
  * get notification msg
  * @param msg
  * @return
  */
 def genNotificationMessage(msg) {
     // project
     msg = "${msg}  \n  **项目名称**: ${this.project}"
     // get git log
     def gitlog = ""
     try {
         sh "git log --oneline -n 1 > gitlog.file"
         gitlog = readFile "gitlog.file"
     } catch (Exception ignored) {}
 
     if (gitlog != null && gitlog != "") {
         msg = "${msg}  \n  **Git log**: ${gitlog}"
     }
     // get git branch
     def gitbranch = env.BRANCH_NAME
     if (gitbranch != null && gitbranch != "") {
         msg = "${msg}  \n  **Git branch**: ${gitbranch}"
     }
     // build tasks
     msg = "${msg}  \n  **Build Tasks**: ${env.BUILD_TASKS}"
 
     // get buttons
     msg = msg + getButtonMsg()
     return msg
 }
 def getButtonMsg(){
     String res = ""
     def  buttons = [
             [
                     "title": "查看流水线",
                     "actionURL": "${env.RUN_DISPLAY_URL}"
             ],
             [
                     "title": "代码扫描结果",
                     "actionURL": "http://sonar.luffy.com/dashboard?id=${this.project}"
             ]
     ]
     buttons.each() {
         if(res == ""){
             res = "   \n >"
         }
         res = "${res} --- ["+it["title"]+"]("+it["actionURL"]+") "
     }
     return res
 }
```

<font style="color:rgb(52, 73, 94);">新建</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">DingTalk.groovy</font><font style="color:rgb(52, 73, 94);">文件：</font>

```plain
package com.luffy.devops
 
 import groovy.json.JsonOutput
 
 
 def sendRequest(method, data, credentialsId, Boolean verbose=false, codes="100:399") {
     def reqBody = new JsonOutput().toJson(data)
     withCredentials([usernamePassword(credentialsId: credentialsId, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
         def response = httpRequest(
                 httpMode:method,
                 url: "https://oapi.dingtalk.com/robot/send?access_token=${PASSWORD}",
                 requestBody:reqBody,
                 validResponseCodes: codes,
                 contentType: "APPLICATION_JSON",
                 quiet: !verbose
         )
     }
 }
 
 def markDown(String title, String text, String credentialsId, Boolean verbose=false) {
     def data = [
             "msgtype": "markdown",
             "markdown": [
                     "title": title,
                     "text": text
             ]
     ]
     this.sendRequest("POST", data, credentialsId, verbose)
 }
```

<font style="color:rgb(52, 73, 94);">需要用到Http Request来发送消息，安装一下插件：http_request</font>

###### <font style="color:rgb(119, 119, 119);">jenkinsfile调用</font>

```plain
@Library('luffy-devops') _
 
 pipeline {
     agent { label 'jnlp-slave'}
     options {
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
     environment {
         IMAGE_REPO = "172.21.51.67:5000/demo/myblog"
         IMAGE_CREDENTIAL = "credential-registry"
         DINGTALK_CREDS = credentials('dingTalk')
     }
     stages {
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
             }
         }
         stage('docker-image') {
             steps {
                 container('tools') {
                     script{
                         devops.docker(
                             "${IMAGE_REPO}",
                             "${GIT_COMMIT}",
                             IMAGE_CREDENTIAL                          
                         ).build().push()
                     }
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     script{
                         devops.deploy("deploy",true,"deploy/deployment.yaml").start()
                     }
                 }
             }
         }
     }
     post {
         success { 
             script{
                 devops.notificationSuccess("myblog","dingTalk")
             }
         }
         failure {
             script{
                 devops.notificationFailure("myblog","dingTalk")
             }
         }
     }
 }
```

##### <font style="color:rgb(52, 73, 94);">library集成代码扫描</font>

<font style="color:rgb(52, 73, 94);">sonarqube代码扫描作为通用功能，同样可以使用library实现。</font>

```plain
devops.groovy
 /**
  * sonarqube scanner
  * @param projectVersion
  * @param waitScan
  * @return
  */
 def scan(String projectVersion="", Boolean waitScan = true) {
     return new Sonar().init(projectVersion, waitScan)
 }
```

<font style="color:rgb(52, 73, 94);">新建</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Sonar.groovy</font>

* <font style="color:rgb(52, 73, 94);">可以传递projectVersion作为sonarqube的扫描版本</font>
* <font style="color:rgb(52, 73, 94);">参数waitScan来设置是否等待本次扫描是否通过</font>

```plain
package com.luffy.devops
 
 
 def init(String projectVersion="", Boolean waitScan = true) {
     this.waitScan = waitScan
     this.msg = new BuildMessage()
     if (projectVersion == ""){
         projectVersion = sh(returnStdout: true, script: 'git log --oneline -n 1|cut -d " " -f 1')
     }
     sh "echo '\nsonar.projectVersion=${projectVersion}' >> sonar-project.properties"
     sh "cat sonar-project.properties"
     return this
 }
 
 def start() {
     try {
         this.startToSonar()
     }
     catch (Exception exc) {
         throw exc
     }
     return this
 }
 
 def startToSonar() {
     withSonarQubeEnv('sonarqube') {
         sh "sonar-scanner -X;"
         sleep 5
     }
     if(this.waitScan){
         //wait 3min
         timeout(time: 3, unit: 'MINUTES') {
             def qg = waitForQualityGate()
             String stage = "${env.stage_name}"
             if (qg.status != 'OK') {
                 this.msg.updateBuildMessage(env.BUILD_TASKS, "${stage} Failed...  ×")
                 updateGitlabCommitStatus(name: "${stage}", state: 'failed')
                 error "Pipeline aborted due to quality gate failure: ${qg.status}"
             }else{
                 this.msg.updateBuildMessage(env.BUILD_RESULT, "${stage} OK...  √")
                 updateGitlabCommitStatus(name: "${stage}", state: 'success')
             }
         }
     }else{
         echo "skip waitScan"
     }
     return this
 }
```

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Jenkinsfile</font><font style="color:rgb(52, 73, 94);">新增如下部分：</font>

```plain
stage('CI'){
            failFast true
            parallel {
                stage('Unit Test') {
                    steps {
                        echo "Unit Test Stage Skip..."
                    }
                }
                stage('Code Scan') {
                    steps {
                        container('tools') {
                            script {
                               devops.scan().start()
                            }
                        }
                    }
                }
            }
        }
```

##### <font style="color:rgb(52, 73, 94);">集成robot自动化测试</font>

<font style="color:rgb(52, 73, 94);">关于集成测试，我们需要知道的几点:</font>

* <font style="color:rgb(52, 73, 94);">测试人员进行编写</font>
* <font style="color:rgb(52, 73, 94);">侧重于不同模块的接口调用，对新加的功能进行验证</font>
* <font style="color:rgb(52, 73, 94);">注重新版本对以前的集成用例进行回归</font>

<font style="color:rgb(52, 73, 94);">因此，更多的应该是跨模块去测试，而且测试用例是测试人员去维护，因此不适合把代码放在开发的git仓库中。</font>

<font style="color:rgb(52, 73, 94);">本节要实现的工作：</font>

1. <font style="color:rgb(52, 73, 94);">创建新的git仓库</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">robot-cases</font><font style="color:rgb(52, 73, 94);">，用于存放robot测试用例</font>
2. <font style="color:rgb(52, 73, 94);">为</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">robot-cases</font><font style="color:rgb(52, 73, 94);">项目创建Jenkinsfile</font>
3. <font style="color:rgb(52, 73, 94);">配置Jenkins任务，实现该项目的自动化执行</font>
4. <font style="color:rgb(52, 73, 94);">在myblog模块的流水线中，对该流水线项目进行调用</font>

###### <font style="color:rgb(119, 119, 119);">初始化robot-cases项目</font>

1. <font style="color:rgb(52, 73, 94);">新建gitlab项目，名称为</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">robot-cases</font>
2. <font style="color:rgb(52, 73, 94);">clone到本地</font>
3. <font style="color:rgb(52, 73, 94);">本地拷贝myblog项目的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">robot.txt</font>

```plain
robot-cases/
└── myblog
    └── robot.txt
```

###### <font style="color:rgb(119, 119, 119);">配置Jenkinsfile及自动化任务</font>

```plain
robot-cases/
├── Jenkinsfile
└── myblog
    └── robot.txt
Jenkinsfile
```

<font style="color:rgb(52, 73, 94);">多个业务项目的测试用例都在一个仓库中，因此需要根据参数设置来决定执行哪个项目的用例</font>

```plain
pipeline {
    agent {
        label 'jnlp-slave'
    }

    options {
        timeout(time: 20, unit: 'MINUTES')
        gitLabConnection('gitlab')
    }
    stages {
        stage('checkout') {
            steps {
                container('tools') {
                    checkout scm
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    container('tools'){
                        switch(env.comp){
                            case "myblog":
                                env.testDir = "myblog"
                                break
                            case "business1":
                                env.testDir = "business1"
                                break
                            default:
                                env.testDir = "all"
                                break
                        }
                        sh 'robot -d artifacts/ ${testDir}/*'
                        step([
                            $class : 'RobotPublisher',
                            outputPath: 'artifacts/',
                            outputFileName : "output.xml",
                            disableArchiveOutput : false,
                            passThreshold : 100,
                            unstableThreshold: 80.0,
                            onlyCritical : true,
                            otherFiles : "*.png"
                        ])
                        archiveArtifacts artifacts: 'artifacts/*', fingerprint: true
                    }
                }
            }
        }
    }
}
```

<font style="color:rgb(52, 73, 94);">如何实现将</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">env.comp</font><font style="color:rgb(52, 73, 94);"> 传递进去？</font>

<font style="color:rgb(52, 73, 94);">配置流水线的参数化构建任务并验证参数化构建</font>

###### <font style="color:rgb(119, 119, 119);">library集成触发任务</font>

<font style="color:rgb(52, 73, 94);">由于多个项目均需要触发自动构建，因此可以在library中抽象方法，实现接收comp参数，并在library中实现对</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">robot-cases</font><font style="color:rgb(52, 73, 94);">项目的触发。</font>

<!-- OCR_START -->
- - sharedlibrary
- - myblog
- - trigger robot-cases
- - robot-cases
- - 自动化任务
- - businessA
- - busines
<!-- OCR_END -->

```plain
devops.groovy
/**
 * 
 * @param comp
 * @return
 */
def robotTest(String comp=""){
    new Robot().acceptanceTest(comp)
}
```

<font style="color:rgb(52, 73, 94);">新建</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Robot.groovy</font><font style="color:rgb(52, 73, 94);">文件</font>

```plain
package com.luffy.devops

def acceptanceTest(comp) {
    try{
        echo "Trigger to execute Acceptance Testing"
        def rf = build job: 'robot-cases',
                parameters: [
                        string(name: 'comp', value: comp)
                ],
                wait: true,
                propagate: false
        def result = rf.getResult()
        def msg = "${env.STAGE_NAME}... "
        if (result == "SUCCESS"){
            msg += "√ success"
        }else if(result == "UNSTABLE"){
            msg += "⚠ unstable"
        }else{
            msg += "× failure"
        }
        echo rf.getAbsoluteUrl()
        env.ROBOT_TEST_URL = rf.getAbsoluteUrl()
        new BuildMessage().updateBuildMessage(env.BUILD_TASKS, msg)
    } catch (Exception exc) {
        echo "trigger  execute Acceptance Testing exception: ${exc}"
        new BuildMessage().updateBuildMessage(env.BUILD_RESULT, msg)
    }
}
```

<font style="color:rgb(52, 73, 94);">修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Jenkinsfile</font><font style="color:rgb(52, 73, 94);">测试调用</font>

```plain
stage('integration test') {
            steps {
                container('tools') {
                    script{
                        devops.robotTest("myblog")
                    }
                }
            }
        }
```

##### <font style="color:rgb(52, 73, 94);">多环境的CICD自动化实现</font>

###### <font style="color:rgb(119, 119, 119);">实现目标及效果</font>

<font style="color:rgb(52, 73, 94);">目前项目存在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">develop</font><font style="color:rgb(52, 73, 94);">和</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">master</font><font style="color:rgb(52, 73, 94);">两个分支，Jenkinsfile中配置的都是构建部署到相同的环境，实际的场景中，代码仓库的项目往往不同的分支有不同的作用，我们可以抽象出一个工作流程：</font>

<!-- OCR_START -->
- - 1.开发人员自测
- - 2.使用blog-dev.luffy.com访问
- - 192.168.136.10:5000/
- - myblog:0e7ca4f6
- - 开发环境
- - develop分支
- - push
- - 单元测试
- - 合并代码
- - 镜像构建
- - k8s部署
- - 代码扫描
- - tag
- - V2.3.0
- - robot集成测试
- - master分支
- - myblog:v2.3.0
- - 集成测试
- - 环境
- - 1.测试人员自测
- - 2.使用blog-test.luffy.com访问
<!-- OCR_END -->

* <font style="color:rgb(52, 73, 94);">开发人员提交代码到develop分支</font>
* <font style="color:rgb(52, 73, 94);">Jenkins自动使用develop分支做单测、代码扫描、镜像构建（以commit id为镜像tag）、服务部署到开发环境</font>
* <font style="color:rgb(52, 73, 94);">开发人员使用开发环境自测</font>
* <font style="color:rgb(52, 73, 94);">测试完成后，在gitlab提交merge request请求，将代码合并至master分支</font>
* <font style="color:rgb(52, 73, 94);">需要发版时，在gitlab端基于master分支创建tag（v2.3.0）</font>
* <font style="color:rgb(52, 73, 94);">Jenkins自动检测到tag，拉取tag关联的代码做单测、代码扫描、镜像构建（以代码的tag为镜像的tag）、服务部署到测试环境、执行集成测试用例，输出测试报告</font>
* <font style="color:rgb(52, 73, 94);">测试人员进行手动测试</font>
* <font style="color:rgb(52, 73, 94);">上线</font>

###### <font style="color:rgb(119, 119, 119);">实现思路</font>

<font style="color:rgb(52, 73, 94);">以myblog项目为例，目前已经具备的是develop分支代码提交后，可以自动实现：</font>

* <font style="color:rgb(52, 73, 94);">单元测试、代码扫描</font>
* <font style="color:rgb(52, 73, 94);">镜像构建</font>
* <font style="color:rgb(52, 73, 94);">k8s服务部署</font>
* <font style="color:rgb(52, 73, 94);">robot集成用例测试</font>

<font style="color:rgb(52, 73, 94);">和上述目标相比，差异点：</font>

1. <font style="color:rgb(52, 73, 94);">myblog应用目前只有一套环境，在luffy命名空间中。我们新建两个命名空间：</font>
   * <font style="color:rgb(52, 73, 94);">dev，用作部署开发环境</font>
   * <font style="color:rgb(52, 73, 94);">test，用作部署集成测试环境</font>
2. <font style="color:rgb(52, 73, 94);">需要根据不同的分支来执行不同的任务，有两种方案实现：</font>
   * <font style="color:rgb(52, 73, 94);">develop和master分支使用不同的Jenkinsfile</font>
     * <font style="color:rgb(52, 73, 94);">可行性很差，因为代码合并工作很繁琐</font>
     * <font style="color:rgb(52, 73, 94);">维护成本高，多个分支需要维护多个Jenkinsfile</font>
   * <font style="color:rgb(52, 73, 94);">使用同一套Jenkinsfile，配合library和模板来实现一套Jenkinsfile适配多套环境</font>
     * <font style="color:rgb(52, 73, 94);">改造Jenkinsfile，实现根据分支来选择任务</font>
     * <font style="color:rgb(52, 73, 94);">需要将deploy目录中所有和特定环境绑定的内容模板化</font>
     * <font style="color:rgb(52, 73, 94);">在library中实现根据不同的分支，来替换模板中的内容</font>

###### <font style="color:rgb(119, 119, 119);">Jenkinsfile根据分支选择任务</font>

<font style="color:rgb(52, 73, 94);">使用when关键字，配合正则表达式，实现分支的过滤选择：</font>

```plain
pipeline {
     agent any
     stages {
         stage('Example Build') {
             steps {
                 echo 'Hello World'
             }
         }
         stage('Example Deploy') {
             when {
                 expression { BRANCH_NAME ==~ "develop" }
             }
             steps {
                 echo 'Deploying to develop env'
             }
         }
     }
 }
```

<font style="color:rgb(52, 73, 94);">分别在develop和master分支进行验证。</font>

<font style="color:rgb(52, 73, 94);">针对本例，可以对Jenkinsfile做如下调整：</font>

```plain
...
         stage('integration test') {
             when {
                 expression { BRANCH_NAME ==~ /v.*/ }
             }
             steps {
                 container('tools') {
                     script{
                         devops.robotTest(PROJECT)
                     }
                 }
             }
         }
 ...
```

###### <font style="color:rgb(119, 119, 119);">模板化k8s的资源清单</font>

<font style="color:rgb(52, 73, 94);">因为需要使用同一套模板和Jenkinsfile来部署到不同的环境，因此势必要对资源清单进行模板化，前面的内容中只将</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">deployment.yaml</font><font style="color:rgb(52, 73, 94);">放到了项目的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">deploy</font><font style="color:rgb(52, 73, 94);">清单目录，此处将部署myblog用到的资源清单均补充进去，包含：</font>

* <font style="color:rgb(52, 73, 94);">deployment.yaml</font>
* <font style="color:rgb(52, 73, 94);">service.yaml</font>
* <font style="color:rgb(52, 73, 94);">ingress.yaml</font>
* <font style="color:rgb(52, 73, 94);">configmap.yaml</font>
* <font style="color:rgb(52, 73, 94);">secret.yaml</font>

<font style="color:rgb(52, 73, 94);">涉及到需要进行模板化的内容包括：</font>

* <font style="color:rgb(52, 73, 94);">镜像地址</font>
* <font style="color:rgb(52, 73, 94);">命名空间</font>
* <font style="color:rgb(52, 73, 94);">ingress的域名信息</font>

<font style="color:rgb(52, 73, 94);">模板化后的文件：</font>

```plain
$ cat deployment.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: myblog
   namespace: {{NAMESPACE}}
 spec:
   replicas: 1   #指定Pod副本数
   selector:             #指定Pod的选择器
     matchLabels:
       app: myblog
   template:
     metadata:
       labels:   #给Pod打label
         app: myblog
     spec:
       containers:
- name: myblog
         image: {{IMAGE_URL}}
         imagePullPolicy: IfNotPresent
         env:
- name: MYSQL_HOST
           valueFrom:
             configMapKeyRef:
               name: myblog
               key: MYSQL_HOST
- name: MYSQL_PORT
           valueFrom:
             configMapKeyRef:
               name: myblog
               key: MYSQL_PORT
- name: MYSQL_USER
           valueFrom:
             secretKeyRef:
               name: myblog
               key: MYSQL_USER
- name: MYSQL_PASSWD
           valueFrom:
             secretKeyRef:
               name: myblog
               key: MYSQL_PASSWD
         ports:
- containerPort: 8002
         resources:
           requests:
             memory: 100Mi
             cpu: 50m
           limits:
             memory: 500Mi
             cpu: 100m
         livenessProbe:
           httpGet:
             path: /blog/index/
             port: 8002
             scheme: HTTP
           initialDelaySeconds: 10  # 容器启动后第一次执行探测是需要等待多少秒
           periodSeconds: 15     # 执行探测的频率
           timeoutSeconds: 2             # 探测超时时间
         readinessProbe: 
           httpGet: 
             path: /blog/index/
             port: 8002
             scheme: HTTP
           initialDelaySeconds: 10 
           timeoutSeconds: 2
           periodSeconds: 15
 
 $ cat configmap.yaml
 apiVersion: v1
 data:
   MYSQL_HOST: mysql
   MYSQL_PORT: "3306"
 kind: ConfigMap
 metadata:
   name: myblog
   namespace: {{NAMESPACE}}
 
 $ cat secret.yaml
 apiVersion: v1
 data:
   MYSQL_PASSWD: MTIzNDU2
   MYSQL_USER: cm9vdA==
 kind: Secret
 metadata:
   name: myblog
   namespace: {{NAMESPACE}}
 type: Opaque
 
 $ cat service.yaml
 apiVersion: v1
 kind: Service
 metadata:
   name: myblog
   namespace: {{NAMESPACE}}
 spec:
   ports:
- port: 80
     protocol: TCP
     targetPort: 8002
   selector:
     app: myblog
   sessionAffinity: None
   type: ClusterIP
 status:
   loadBalancer: {}
 
 $ cat ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: myblog
   namespace: {{NAMESPACE}}
 spec:
   rules:
- host: {{INGRESS_MYBLOG}}
     http:
       paths:
- backend:
           serviceName: myblog
           servicePort: 80
         path: /
 status:
   loadBalancer: {}
```

###### <font style="color:rgb(119, 119, 119);">实现library配置替换逻辑</font>

<font style="color:rgb(52, 73, 94);">我们需要实现使用相同的模板，做到如下事情：</font>

* <font style="color:rgb(52, 73, 94);">根据代码分支来部署到不同的命名空间</font>
  * <font style="color:rgb(52, 73, 94);">develop分支部署到开发环境，使用命名空间 dev</font>
  * <font style="color:rgb(52, 73, 94);">v.\*部署到测试环境，使用命名空间 test</font>
* <font style="color:rgb(52, 73, 94);">不同环境使用不同的ingress地址来访问</font>
  * <font style="color:rgb(52, 73, 94);">开发环境，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">blog-dev.luffy.com</font>
  * <font style="color:rgb(52, 73, 94);">测试环境，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">blog-test.luffy.com</font>

<font style="color:rgb(52, 73, 94);">如何实现？sharedlibrary</font>

<font style="color:rgb(52, 73, 94);">所有的逻辑都会经过library这一层，我们具有完全可控权。</font>

<font style="color:rgb(52, 73, 94);">前面已经替换过镜像地址了，我们只需要实现如下逻辑：</font>

* <font style="color:rgb(52, 73, 94);">检测当前代码分支，替换命名空间</font>
* <font style="color:rgb(52, 73, 94);">检测当前代码分支，替换Ingress地址</font>

<font style="color:rgb(52, 73, 94);">问题来了，如何检测构建的触发是develop分支还是tag分支？</font>

<font style="color:rgb(52, 73, 94);">答案是：env.TAG_NAME，由tag分支触发的构建，环境变量中会带有TAG_NAME，且值为gitlab中的tag名称。</font>

<font style="color:rgb(52, 73, 94);">做个演示：</font>

<font style="color:rgb(52, 73, 94);">使用如下的Jenkinsfile，查看由master分支触发和由tag分支触发，printenv的值有什么不同</font>

```plain
pipeline {
     agent any
     stages {
         stage('Example Build') {
             steps {
                 echo 'Hello World'
                 sh 'printenv'
             }
         }
         stage('Example Deploy') {
             when {
                 expression { BRANCH_NAME ==~ "develop" }
             }
             steps {
                 echo 'Deploying to develop env'
             }
         }
     }
 }
```

<font style="color:rgb(52, 73, 94);">我们可以选择和替换image镜像地址一样，来执行替换：</font>

```plain
def tplHandler(){
     sh "sed -i 's#{{IMAGE_URL}}#${env.CURRENT_IMAGE}#g' ${this.resourcePath}/*"
     String namespace = "dev"
     String ingress = "blog-dev.luffy.com"
     if(env.TAG_NAME){
         namespace = "test"
         ingress = "blog-test.luffy.com"
     }
     sh "sed -i 's#{{NAMESPACE}}#${namespace}#g' ${this.resourcePath}/*"
     sh "sed -i 's#{{INGRESS_MYBLOG}}#${ingress}#g' ${this.resourcePath}/*"
 }
```

<font style="color:rgb(52, 73, 94);">但是我们的library是要为多个项目提供服务的，如果采用上述方式，则每加入一个项目，都需要对library做改动，形成了强依赖。因此需要想一种更优雅的方式来进行替换。</font>

<font style="color:rgb(52, 73, 94);">思路：</font>

1. <font style="color:rgb(52, 73, 94);">开发环境和集成测试环境里准备一个configmap，取名为 </font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">devops-config</font>
2. <font style="color:rgb(52, 73, 94);">configmap的内容大致如下：</font>
   * <font style="color:rgb(52, 73, 94);">开发环境</font>
   * <font style="color:rgb(52, 73, 94);">测试环境</font>
3. <font style="color:rgb(52, 73, 94);">约定：configmap的key值，拼接{{KEY}}则为代码中需要替换的模板部分，configmap的该key对应的value，则为该模板要被替换的值的内容。比如：</font>
4. <font style="color:rgb(52, 73, 94);">在library的逻辑中，实现读取触发当前构建的代码分支所关联的namespace下的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">devops-config</font><font style="color:rgb(52, 73, 94);">这个configmap，然后遍历里面的值进行模板替换即可。</font>

```plain
NAMESPACE=dev
 INGRESS_MYBLOG=blog-dev.luffy.com
```

```plain
NAMESPACE=test
 INGRESS_MYBLOG=blog-test.luffy.com
```

```plain
NAMESPACE=dev
 INGRESS_MYBLOG=blog-dev.luffy.com
 {{NAMESPACE}} => dev
 {{INGRESS_MYBLOG}} -> blog-dev.luffy.com
```

<font style="color:rgb(52, 73, 94);">意思是约定项目的deploy的资源清单中：</font>

```
- 所有的{{NAMESPACE}}被替换为dev
- 所有的{{INGRESS_MYBLOG}}被替换为blog-dev.luffy.com
```

<font style="color:rgb(52, 73, 94);">这样，则以后再有新增的项目，则只需要维护</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">devops-config</font><font style="color:rgb(52, 73, 94);">配置文件即可，shared-library则不需要随着项目的增加而进行修改，通过这种方式实现library和具体的项目解耦。</font>

```plain
def tplHandler(){
     sh "sed -i 's#{{IMAGE_URL}}#${env.CURRENT_IMAGE}#g' ${this.resourcePath}/*"
     String namespace = "dev"
     if(env.TAG_NAME){
         namespace = "test"
     }
     try {
         def configMapData = this.getResource(namespace, "devops-config", "configmap")["data"]
         configMapData.each { k, v ->
             echo "key is ${k}, val is ${v}"
             sh "sed -i 's#{{${k}}}#${v}#g' ${this.resourcePath}/*"
         }
     }catch (Exception exc) {
         echo "failed to get devops-config data,exception: ${exc}."
         throw exc
     }
 }
```

###### <font style="color:rgb(119, 119, 119);">准备多环境</font>

1. <font style="color:rgb(52, 73, 94);">创建开发和测试环境的命名空间</font>
2. <font style="color:rgb(52, 73, 94);">分别在dev和test命名空间准备mysql数据库。演示功能，因此mysql未作持久化</font>

```plain
# 
 $ kubectl create namespace dev
 $ kubectl create namespace test
```

```plain
$ cat mysql-all.yaml
 apiVersion: v1
 kind: Service
 metadata:
   name: mysql
   namespace: dev
 spec:
   ports:
- port: 3306
     protocol: TCP
     targetPort: 3306
   selector:
     app: mysql
   type: ClusterIP
 ---
 apiVersion: v1
 kind: Secret
 metadata:
   name: myblog
   namespace: dev
 type: Opaque
 data:
   MYSQL_USER: cm9vdA==
   MYSQL_PASSWD: MTIzNDU2
 ---
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: mysql
   namespace: dev
 spec:
   replicas: 1   #指定Pod副本数
   selector:             #指定Pod的选择器
     matchLabels:
       app: mysql
   template:
     metadata:
       labels:   #给Pod打label
         app: mysql
     spec:
       containers:
- name: mysql
         image: 172.21.51.67:5000/mysql:5.7-utf8
         ports:
- containerPort: 3306
         env:
- name: MYSQL_USER
           valueFrom:
             secretKeyRef:
               name: myblog
               key: MYSQL_USER
- name: MYSQL_ROOT_PASSWORD
           valueFrom:
             secretKeyRef:
               name: myblog
               key: MYSQL_PASSWD
- name: MYSQL_DATABASE
           value: "myblog"
         resources:
           requests:
             memory: 100Mi
             cpu: 50m
           limits:
             memory: 500Mi
             cpu: 100m
         readinessProbe:
           tcpSocket:
             port: 3306
           initialDelaySeconds: 5
           periodSeconds: 10
 
 # 创建开发环境的数据库
 $ kubectl create -f mysql-all.yaml
 
 # 替换dev命名空间，创建测试环境的数据库
 $ sed -i 's/namespace: dev/namespace: test/g' mysql-all.yaml
 $ kubectl create -f mysql-all.yaml
```

1. <font style="color:rgb(52, 73, 94);">对myblog项目的k8s资源清单模板化改造</font>
   * <font style="color:rgb(52, 73, 94);">{{NAMESPACE}}</font>
   * <font style="color:rgb(52, 73, 94);">{{INGRESS_MYBLOG}}</font>
   * <font style="color:rgb(52, 73, 94);">{{IMAGE_URL}}</font>
2. <font style="color:rgb(52, 73, 94);">初始化开发环境和测试环境的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">devops-config</font>
3. <font style="color:rgb(52, 73, 94);">提交最新的library代码</font>
4. <font style="color:rgb(52, 73, 94);">提交最新的python-demo项目代码</font>

```plain
# 开发环境
 $ cat devops-config-dev.txt
 NAMESPACE=dev
 INGRESS_MYBLOG=blog-dev.luffy.com
 
 $ kubectl -n dev create configmap devops-config --from-env-file=devops-config-dev.txt
 
 # 测试环境
 $ cat devops-config-test.txt
 NAMESPACE=test
 INGRESS_MYBLOG=blog-test.luffy.com
 
 $ kubectl -n test create configmap devops-config --from-env-file=devops-config-test.txt
```

```plain
@Library('luffy-devops') _
 
 pipeline {
     agent { label 'jnlp-slave'}
     options {
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
     environment {
         IMAGE_REPO = "172.21.51.67:5000/myblog"
         IMAGE_CREDENTIAL = "credential-registry"
         DINGTALK_CREDS = credentials('dingTalk')
         PROJECT = "myblog"
     }
     stages {
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
             }
         }
         stage('CI'){
             failFast true
             parallel {
                 stage('Unit Test') {
                     steps {
                         echo "Unit Test Stage Skip..."
                     }
                 }
                 stage('Code Scan') {
                     steps {
                         container('tools') {
                             script {
                                devops.scan().start()
                             }
                         }
                     }
                 }
             }
         }
         stage('docker-image') {
             steps {
                 container('tools') {
                     script{
                         devops.docker(
                             "${IMAGE_REPO}",
                             "${GIT_COMMIT}",
                             IMAGE_CREDENTIAL                          
                         ).build().push()
                     }
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     script{
                         devops.deploy("deploy",true,"deploy/deployment.yaml").start()
                     }
                 }
             }
         }
         stage('integration test') {
             when {
                 expression { BRANCH_NAME ==~ /v.*/ }
             }
             steps {
                 container('tools') {
                     script{
                         devops.robotTest(PROJECT)
                     }
                 }
             }
         }
     }
     post {
         success { 
             script{
                 devops.notificationSuccess(PROJECT,"dingTalk")
             }
         }
         failure {
             script{
                 devops.notificationFailure(PROJECT,"dingTalk")
             }
         }
     }
 }
```

###### <font style="color:rgb(119, 119, 119);">验证多环境自动部署</font>

<font style="color:rgb(52, 73, 94);">模拟如下流程：</font>

1. <font style="color:rgb(52, 73, 94);">提交代码到develop分支，观察是否部署到dev的命名空间中，注意，第一次部署，需要执行migrate操作：</font><font style="color:rgb(52, 73, 94);">  $ kubectl -n dev exec  myblog-9f9f7c8cd-k6tbj python3 manage.py migrate</font>
2. <font style="color:rgb(52, 73, 94);">配置hosts解析，测试使用</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http://blog-dev.luffy.com/blog/index/</font><font style="color:rgb(52, 73, 94);">进行访问到develop分支最新版本</font>
3. <font style="color:rgb(52, 73, 94);">合并代码至master分支</font>
4. <font style="color:rgb(52, 73, 94);">在gitlab中创建tag，观察是否自动部署至test的命名空间中，且使用</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">myblog-test.luffy.com/blog/index/</font><font style="color:rgb(52, 73, 94);">可以访问到最新版本</font>

###### <font style="color:rgb(119, 119, 119);">实现打tag后自动部署</font>

<font style="color:rgb(52, 73, 94);">我们发现，打了tag以后，多分支流水线中可以识别到该tag，但是并不会自动部署该tag的代码。因此，我们来使用一个新的插件：Basic Branch Build Strategies Plugin</font>

<font style="color:rgb(52, 73, 94);">安装并配置多分支流水线，注意Build strategies 设置：</font>

* <font style="color:rgb(52, 73, 94);">Regular branches</font>
* <font style="color:rgb(52, 73, 94);">Tags</font>
  * <font style="color:rgb(52, 73, 94);">Ignore tags newer than 可以不用设置，不然会默认不自动构建新打的tag</font>
  * <font style="color:rgb(52, 73, 94);">Ignore tags older than</font>

###### <font style="color:rgb(119, 119, 119);">优化镜像部署逻辑</font>

<font style="color:rgb(52, 73, 94);">针对部署到测试环境的代码，由于已经打了tag了，因此，我们期望构建出来的镜像地址可以直接使用代码的tag作为镜像的tag。</font>

<font style="color:rgb(52, 73, 94);">思路一：直接在Jenkinsfile调用</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">devops.docker</font><font style="color:rgb(52, 73, 94);">时传递tag名称</font>

<font style="color:rgb(52, 73, 94);">思路二：在shared-library中，根据</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">env.TAG_NAME</font><font style="color:rgb(52, 73, 94);">来判断当前是否是tag分支的构建，若TAG_NAME不为空，则可以在构建镜像时使用TAG_NAME作为镜像的tag</font>

<font style="color:rgb(52, 73, 94);">很明显我们更期望使用思路二的方式来实现，因此，需要调整如下逻辑：</font>

```plain
def docker(String repo, String tag, String credentialsId, String dockerfile="Dockerfile", String context="."){
     this.repo = repo
     this.tag = tag
     if(env.TAG_NAME){
         this.tag = env.TAG_NAME
     }
     this.dockerfile = dockerfile
     this.credentialsId = credentialsId
     this.context = context
     this.fullAddress = "${this.repo}:${this.tag}"
     this.isLoggedIn = false
     this.msg = new BuildMessage()
     return this
 }
```

<font style="color:rgb(52, 73, 94);">提交代码，并进行测试，观察是否使用tag作为镜像标签进行部署。</font>

##### <font style="color:rgb(52, 73, 94);">小结</font>

<font style="color:rgb(52, 73, 94);">Jenkins-shared-library的代码地址： </font><https://gitee.com/agagin/jenkins-shared-library>

<font style="color:rgb(52, 73, 94);">目标：让devops流程更好用</font>

* <font style="color:rgb(52, 73, 94);">项目更简便的接入</font>
* <font style="color:rgb(52, 73, 94);">devops流程更方便维护</font>

<font style="color:rgb(52, 73, 94);">思路：把各项目中公用的逻辑，抽象成方法，放到独立的library项目中，在各项目中引入shared-library项目，调用library提供的方法。</font>

* <font style="color:rgb(52, 73, 94);">镜像构建、推送</font>
* <font style="color:rgb(52, 73, 94);">k8s服务部署、监控</font>
* <font style="color:rgb(52, 73, 94);">钉钉消息推送</font>
* <font style="color:rgb(52, 73, 94);">代码扫描</font>
* <font style="color:rgb(52, 73, 94);">robot集成测试</font>

<font style="color:rgb(52, 73, 94);">为了兼容多环境的CICD，因此采用模板与数据分离的方式，项目中的定义模板，shared-library中实现模板替换。为了实现shared-library与各项目解耦，使用configmap来维护模板与真实数据的值，思路是约定大于配置。</font><font style="color:rgb(51, 51, 51);">\
</font>

# <font style="color:rgb(52, 73, 94);">07_Spring Cloud微服务项目交付</font>

#### <font style="color:rgb(52, 73, 94);">微服务扫盲篇</font>

<font style="color:rgb(52, 73, 94);">微服务并没有一个官方的定义，想要直接描述微服务比较困难，我们可以通过对比传统WEB应用，来理解什么是微服务。</font>

###### <font style="color:rgb(119, 119, 119);">单体应用架构</font>

<font style="color:rgb(52, 73, 94);">如下是传统打车软件架构图：</font>

<!-- OCR_START -->
- - MYSQL
- - Monolithic
- - Architecture
- - ADAPTER
- - PASSENGER
- - REST
- - TWILIO
- - API
- - DRIVER
- - MANAGEMENT
- - BILLING
- - NOTIFICATION PAYMENTS
- - TRIP
- - MANAGEMENT MANAGEMENT
- - WEB
- - SENDGRID
- - UI
- - STRIPE
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">这种单体应用比较适合于小项目，优点是：</font>

* <font style="color:rgb(52, 73, 94);">开发简单直接，集中式管理</font>
* <font style="color:rgb(52, 73, 94);">基本不会重复开发</font>
* <font style="color:rgb(52, 73, 94);">功能都在本地，没有分布式的管理开销和调用开销</font>

<font style="color:rgb(52, 73, 94);">当然它的缺点也十分明显，特别对于互联网公司来说：</font>

* <font style="color:rgb(52, 73, 94);">开发效率低：所有的开发在一个项目改代码，递交代码相互等待，代码冲突不断</font>
* <font style="color:rgb(52, 73, 94);">代码维护难：代码功能耦合在一起，新人不知道何从下手</font>
* <font style="color:rgb(52, 73, 94);">部署不灵活：构建时间长，任何小修改必须重新构建整个项目，这个过程往往很长</font>
* <font style="color:rgb(52, 73, 94);">稳定性不高：一个微不足道的小问题，可以导致整个应用挂掉</font>
* <font style="color:rgb(52, 73, 94);">扩展性不够：无法满足高并发情况下的业务需求</font>

###### <font style="color:rgb(119, 119, 119);">微服务应用架构</font>

<font style="color:rgb(52, 73, 94);">微服务架构的设计思路不是开发一个巨大的单体式应用，而是将应用分解为小的、互相连接的微服务。一个微服务完成某个特定功能，比如乘客管理和下单管理等。每个微服务都有自己的业务逻辑和适配器。一些微服务还会提供API接口给其他微服务和应用客户端使用。</font>

<font style="color:rgb(52, 73, 94);">比如，前面描述的系统可被分解为：</font>

<!-- OCR_START -->
- - ADAPTER
- - STRIPE
- - API
- - REST
- - GATEWAY
- - AP1
- - PASSENGER
- - MANAGEMENT
- - BILLING
- - DRIVER
- - WEB UI
- - PAYMENTS
- - TWILO
- - TRIP
- - NOTIFICATION
- - SENDGRID
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">每个业务逻辑都被分解为一个微服务，微服务之间通过REST API通信。一些微服务也会向终端用户或客户端开发API接口。但通常情况下，这些客户端并不能直接访问后台微服务，而是通过API Gateway来传递请求。API Gateway一般负责服务路由、负载均衡、缓存、访问控制和鉴权等任务。</font>

<font style="color:rgb(52, 73, 94);">微服务架构优点：</font>

* <font style="color:rgb(52, 73, 94);">解决了复杂性问题。它将单体应用分解为一组服务。虽然功能总量不变，但应用程序已被分解为可管理的模块或服务</font>
* <font style="color:rgb(52, 73, 94);">体系结构使得每个服务都可以由专注于此服务的团队独立开发。只要符合服务API契约，开发人员可以自由选择开发技术。这就意味着开发人员可以采用新技术编写或重构服务，由于服务相对较小，所以这并不会对整体应用造成太大影响</font>
* <font style="color:rgb(52, 73, 94);">微服务架构可以使每个微服务独立部署。这些更改可以在测试通过后立即部署。所以微服务架构也使得CI／CD成为可能</font>

###### <font style="color:rgb(119, 119, 119);">微服务架构问题及挑战</font>

<font style="color:rgb(52, 73, 94);">微服务的一个主要缺点是微服务的分布式特点带来的复杂性。开发人员需要基于RPC或者消息实现微服务之间的调用和通信，而这就使得服务之间的发现、服务调用链的跟踪和质量问题变得的相当棘手。</font>

1. <font style="color:rgb(52, 73, 94);">微服务的一大挑战是跨多个服务的更改</font>
   * <font style="color:rgb(52, 73, 94);">比如在传统单体应用中，若有A、B、C三个服务需要更改，A依赖B，B依赖C。我们只需更改相应的模块，然后一次性部署即可。</font>
   * <font style="color:rgb(52, 73, 94);">在微服务架构中，我们需要仔细规划和协调每个服务的变更部署。我们需要先更新C，然后更新B，最后更新A。</font>
2. <font style="color:rgb(52, 73, 94);">部署基于微服务的应用也要复杂得多</font>
   * <font style="color:rgb(52, 73, 94);">单体应用可以简单的部署在一组相同的服务器上，然后前端使用负载均衡即可。</font>
   * <font style="color:rgb(52, 73, 94);">微服务由不同的大量服务构成。每种服务可能拥有自己的配置、应用实例数量以及基础服务地址。这里就需要不同的配置、部署、扩展和监控组件。此外，我们还需要服务发现机制，以便服务可以发现与其通信的其他服务的地址</font>

<font style="color:rgb(52, 73, 94);">以上问题和挑战可大体概括为：</font>

* <font style="color:rgb(52, 73, 94);">API Gateway</font>
* <font style="color:rgb(52, 73, 94);">服务间调用</font>
* <font style="color:rgb(52, 73, 94);">服务发现</font>
* <font style="color:rgb(52, 73, 94);">服务容错</font>
* <font style="color:rgb(52, 73, 94);">服务部署</font>
* <font style="color:rgb(52, 73, 94);">数据调用</font><https://www.kancloud.cn/owenwangwen/open-capacity-platform/1480155><font style="color:rgb(52, 73, 94);">，自助餐吃吃喝喝，竟然秒懂微服务</font>

##### <font style="color:rgb(52, 73, 94);">微服务框架</font>

<font style="color:rgb(52, 73, 94);">如何应对上述挑战，出现了如下微服务领域的框架：</font>

* <font style="color:rgb(52, 73, 94);">Spring Cloud（各个微服务基于Spring Boot实现）</font>
* <font style="color:rgb(52, 73, 94);">Dubbo</font>
* <font style="color:rgb(52, 73, 94);">Service Mesh</font>
  * <font style="color:rgb(52, 73, 94);">Linkerd</font>
  * <font style="color:rgb(52, 73, 94);">Envoy</font>
  * <font style="color:rgb(52, 73, 94);">Conduit</font>
  * <font style="color:rgb(52, 73, 94);">Istio</font>

<!-- OCR_START -->
- - 负载均衡
- - 服务注册与发现
- - 监控
- - 分布式配置管理
- - Api/网关
- - 分布式追踪
<!-- OCR_END -->

#### <font style="color:rgb(52, 73, 94);">了解Spring Cloud</font>

[https://spring.io](https://spring.io/)

##### <font style="color:rgb(52, 73, 94);">核心项目及组件</font>

<https://spring.io/projects>

##### <font style="color:rgb(52, 73, 94);">与Dubbo对比</font>

<font style="color:rgb(52, 73, 94);">做一个简单的功能对比：</font>

| **<font style="color:rgb(52, 73, 94);">核心要素</font>** | **<font style="color:rgb(52, 73, 94);">Dubbo</font>** | **<font style="color:rgb(52, 73, 94);">Spring Cloud</font>** |
| :--- | :--- | :--- |
| <font style="color:rgb(52, 73, 94);">服务注册中心</font> | <font style="color:rgb(52, 73, 94);">Zookeeper</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Netflix Eureka</font> |
| <font style="color:rgb(52, 73, 94);">服务调用方式</font> | <font style="color:rgb(52, 73, 94);">RPC</font> | <font style="color:rgb(52, 73, 94);">REST API</font> |
| <font style="color:rgb(52, 73, 94);">服务监控</font> | <font style="color:rgb(52, 73, 94);">Dubbo-monitor</font> | <font style="color:rgb(52, 73, 94);">Spring Boot Admin</font> |
| <font style="color:rgb(52, 73, 94);">断路器</font> | <font style="color:rgb(52, 73, 94);">不完善</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Netflix Hystrix</font> |
| <font style="color:rgb(52, 73, 94);">服务网关</font> | <font style="color:rgb(52, 73, 94);">无</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Netflix Zuul</font> |
| <font style="color:rgb(52, 73, 94);">分布式配置</font> | <font style="color:rgb(52, 73, 94);">无</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Config</font> |
| <font style="color:rgb(52, 73, 94);">服务跟踪</font> | <font style="color:rgb(52, 73, 94);">无</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Sleuth</font> |
| <font style="color:rgb(52, 73, 94);">消息总线</font> | <font style="color:rgb(52, 73, 94);">无</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Bus</font> |
| <font style="color:rgb(52, 73, 94);">数据流</font> | <font style="color:rgb(52, 73, 94);">无</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Stream</font> |
| <font style="color:rgb(52, 73, 94);">批量任务</font> | <font style="color:rgb(52, 73, 94);">无</font> | <font style="color:rgb(52, 73, 94);">Spring Cloud Task</font> |
| <font style="color:rgb(52, 73, 94);">……</font> | <font style="color:rgb(52, 73, 94);">……</font> | <font style="color:rgb(52, 73, 94);">……</font> |

**<font style="color:rgb(52, 73, 94);">从上图可以看出其实Dubbo的功能只是Spring Cloud体系的一部分。</font>**

<font style="color:rgb(52, 73, 94);">这样对比是不够公平的，首先</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Dubbo</font><font style="color:rgb(52, 73, 94);">是</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">SOA</font><font style="color:rgb(52, 73, 94);">时代的产物，它的关注点主要在于服务的调用，流量分发、流量监控和熔断。而</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spring Cloud</font><font style="color:rgb(52, 73, 94);">诞生于微服务架构时代，考虑的是微服务治理的方方面面，另外由于依托了</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spirng</font><font style="color:rgb(52, 73, 94);">、</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spirng Boot</font><font style="color:rgb(52, 73, 94);">的优势之上，两个框架在开始目标就不一致，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Dubbo</font><font style="color:rgb(52, 73, 94);">定位服务治理、</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spirng Cloud</font><font style="color:rgb(52, 73, 94);">是一个生态。</font>

#### <font style="color:rgb(52, 73, 94);">Spring Boot交付实践</font>

##### <font style="color:rgb(52, 73, 94);">从零开始创建Spring Boot项目</font>

<font style="color:rgb(52, 73, 94);">通过File > New > Project，新建工程，选择Spring Initializr</font>

<!-- OCR_START -->
- - New Project
- - Java
- - Project SDK:
- - 1.8 (java version "1.8.0_202")
- - New...
- - Java Enterprise
- - Choose Initializr Service URL
- - . JBoss
- - Clouds
- - Default: https://start.spring.io
- - O Custom:
- - Spring
- - Java FX
- - Make sure your network connection is active before continuing.
- - Android
- - Intellij Platform Plugin
- - Spring Initializr
- - m Maven
- - Gradle
- - Groovy
- - Grails
- - Application Forge
- - Kotlin
- - Static Web
- - Nodejs and NPM
- - Flash
- - Empty Project
- - Previous
- - Next
- - Cancel
- - Help
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">配置Project Metadata：</font>

<!-- OCR_START -->
- - New Project
- - Project Metadata
- - Group:
- - com.luffy
- - Artifact:
- - demo
- - Iype:
- - Maven Project (Generate a Maven based project archive.)
- - Language:
- - Java
- - Packaging:
- - Jar
- - Java Version:
- - 8
- - Version:
- - 0.0.1-SNAPSHOT
- - Name:
- - Description:
- - Demo project for Spring Boot
- - Package:
- - com.luffy.demo
- - Previous
- - Next
- - Cancel
- - Help
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">配置Dependencies依赖包：</font>

<font style="color:rgb(52, 73, 94);">选择：Web分类中的Spring web和Template Engines中的Thymeleaf</font>

<!-- OCR_START -->
- New Project
- Dependencies
- Spring Boot 2.3.3
- Selected Dependencies
- Developer Tools
- Spring Web
- Web
- Spring Reactive Web
- Template Engines
- Rest Repositories
- Security
- Spring Session
- SQL
- Thymeleaf
- Rest Repositories HAL Explorer
- NoSQL
- Rest Repositories HAL Browser
- Messaging
- 1/0
- Spring HATEOAS
- Ops
- Spring Web Services
- Observability
- Jersey
- Testing
- Vaadin
- Spring Cloud
- Spring Cloud Security
- Spring Cloud Tools
- Spring Cloud Config
- Spring Cloud Discovery
- Spring Cloud Routing
- Spring Cloud Circuit Breaker
- Spring Cloud Tracing
- Spring Cloud Messaging
- Pivotal Cloud Foundry
- Previous
- Next
- Cancel
- Help
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">配置maven settings.xml：</font>

<font style="color:rgb(52, 73, 94);">默认使用IDE自带的maven，换成自己下载的，下载地址：</font>

<font style="color:rgb(52, 73, 94);">链接: </font><https://pan.baidu.com/s/1z9dRGv_4bS1uxBtk5jsZ2Q><font style="color:rgb(52, 73, 94);"> 提取码: 3gva</font>

<font style="color:rgb(52, 73, 94);">解压后放到</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">D:\software\apache-maven-3.6.3</font><font style="color:rgb(52, 73, 94);">,修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">D:\software\apache-maven-3.6.3\conf\settings.xml</font><font style="color:rgb(52, 73, 94);"> 文件：</font>

```plain
<?xml version="1.0" encoding="UTF-8"?>
 <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
   <localRepository>D:\opt\maven-repo</localRepository>
 
   <pluginGroups>
   </pluginGroups>
 
   <proxies>
   </proxies>
 
   <servers>
   </servers>
 
   <mirrors>
         <mirror>
             <id>alimaven</id>
             <mirrorOf>central</mirrorOf>
             <name>aliyun maven</name>
             <url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
         </mirror>
         <mirror>
             <id>nexus-aliyun</id>
             <mirrorOf>*</mirrorOf>
             <name>Nexus aliyun</name>
             <url>http://maven.aliyun.com/nexus/content/groups/public</url>
         </mirror>
   </mirrors>
 
 </settings>
```

<!-- OCR_START -->
- IJ
- Settings
- Build, Execution, Deployment > Build Tools > Maven
- 咱 For current project
- Appearance & Behavior
- Work offline
- Keymap
- Use plugin registry
- Execute goals recursively
- Editor
- Plugins
- Print exception stack traces
- Always update snapshots
- Version Control
- Update indices on project open
- Build, Execution, Deployment
- ▼ Build Tools
- Output level:
- Info
- Maven
- Checksum policy:
- No Global Policy
- Gradle
- Multiproject build fail policy:
- Default
- Gant
- Compiler
- Plugin update policy:
- ignored by Maven 3+
- Thread count:
- -T option
- Remote Jar Repositories
- Deployment
- Maven home directory:
- Bundled (Maven 3)
- Arquillian Containers
- (Version: 3.6.1)
- Application Servers
- User settings file:
- C:\Users\liyongxin\.m2\settings.xml
- Override
- Clouds
- Local repository:
- D:lopt\maven-repo
- Coverage
- Docker
- Gradle-Android Compiler
- Instant Run
- Java Profiler
- OK
- Cancel
- Apply
<!-- OCR_END -->

<!-- OCR_START -->
- Settings
- Build, Execution, Deployment > Build Tools > Maven
- For current project
- Appearance & Behavior
- Work offline
- Keymap
- Use plugin registry
- Editor
- Execute goals recursively
- Plugins
- Print exception stack traces
- Always update snapshots
- Version Control
- Update indices on project open
- Build, Execution, Deployment
- ▼ Build Tools
- Output level:
- Info
- Maven
- Checksum policy:
- No Global Policy
- Gradle
- Multiproject build fail policy:
- Default
- Gant
- Compiler
- Plugin update policy:
- ignored by Maven 3+
- Thread count:
- -T option
- Remote Jar Repositories
- Deployment
- Maven home directory:
- D:/software/apache-maven-3.6.3
- Arquillian Containers
- (Version: 3.6.3)
- Application Servers
- User settings file:
- D:\software\apache-maven-3.6.3\conf\settings.xml
- Override
- Clouds
- Local repository:
- D:\opt\maven-repo-luffy
- Coverage
- Docker
- Gradle-Android Compiler
- Instant Run
- Java Profiler
- Required Plugins
- Languages & Frameworks
- OK
- Cancel
- Apply
<!-- OCR_END -->

<font style="color:rgb(119, 119, 119);">替换springboot版本为2.3.5.RELEASE</font>

<font style="color:rgb(52, 73, 94);">直接启动项目并访问本地服务：</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">localhost:8080</font>

##### <font style="color:rgb(52, 73, 94);">编写功能代码</font>

<font style="color:rgb(52, 73, 94);">创建controller包及</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">HelloController.java</font><font style="color:rgb(52, 73, 94);">文件</font>

```plain
package com.luffy.demo.controller;
 
 import org.springframework.web.bind.annotation.RequestMapping;
 import org.springframework.web.bind.annotation.RequestMethod;
 import org.springframework.web.bind.annotation.RestController;
 
 @RestController
 public class HelloController {
 
     @RequestMapping(value = "/hello", method = RequestMethod.GET)
     public String hello(String name) {
         return "Hello, " + name;
     }
```

<font style="color:rgb(52, 73, 94);">保存并在浏览器中访问</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">localhost:8080/hello?name=luffy</font>

<font style="color:rgb(52, 73, 94);">如果页面复杂，如何实现？</font>

<font style="color:rgb(52, 73, 94);">在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">resources/templates/</font><font style="color:rgb(52, 73, 94);">目录下新建</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">index.html</font>

```plain
<!DOCTYPE html>
 <html>
 <head>
     <title>Devops</title>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 </head>
 <body>
 
     <h3 th:text="${requestname}"></h3>
     <a id="rightaway" href="#" th:href="@{/rightaway}" >立即返回</a>
     <a id="sleep" href="#" th:href="@{/sleep}">延时返回</a>
 
 </body>
 </html>
```

<font style="color:rgb(52, 73, 94);">完善</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">HelloController.java</font><font style="color:rgb(52, 73, 94);">的内容：</font>

```plain
package com.luffy.demo.controller;
 
 import org.springframework.web.bind.annotation.RequestMapping;
 import org.springframework.web.bind.annotation.RequestMethod;
 import org.springframework.web.bind.annotation.RestController;
 import org.springframework.web.servlet.ModelAndView;
 
 @RestController
 public class HelloController {
 
     @RequestMapping(value = "/hello", method = RequestMethod.GET)
     public String hello(String name) {
         return "Hello, " + name;
     }
 
     @RequestMapping("/")
     public ModelAndView index(ModelAndView mv) {
         mv.setViewName("index");
         mv.addObject("requestname", "This is index");
         return mv;
     }
 
     @RequestMapping("/rightaway")
     public ModelAndView returnRightAway(ModelAndView mv) {
         mv.setViewName("index");
         mv.addObject("requestname","This request is RightawayApi");
         return mv;
     }
 
     @RequestMapping("/sleep")
     public ModelAndView returnSleep(ModelAndView mv) throws InterruptedException {
         Thread.sleep(2*1000);
         mv.setViewName("index");
         mv.addObject("requestname","This request is SleepApi"+",it will sleep 2s !");
         return mv;
     }
 }
```

##### <font style="color:rgb(52, 73, 94);">如何在java项目中使用maven</font>

###### <font style="color:rgb(119, 119, 119);">为什么需要maven</font>

<font style="color:rgb(52, 73, 94);">考虑一个常见的场景：以项目A为例，开发过程中，需要依赖B-2.0.jar的包，如果没有maven，那么正常做法是把B-2.0.jar拷贝到项目A中，但是如果B-2.0.jar还依赖C.jar，我们还需要去找到C.jar的包，因此，在开发阶段需要花费在项目依赖方面的精力会很大。</font>

<font style="color:rgb(52, 73, 94);">因此，开发人员需要找到一种方式，可以管理java包的依赖关系，并可以方便的引入到项目中。</font>

###### <font style="color:rgb(119, 119, 119);">maven如何工作</font>

<font style="color:rgb(52, 73, 94);">查看</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">pom.xml</font>

```plain
<dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-thymeleaf</artifactId>
         </dependency>
```

<font style="color:rgb(52, 73, 94);">可以直接在项目中添加上</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">dependency</font><font style="color:rgb(52, 73, 94);"> ，这样来指定项目的依赖包。</font>

<font style="color:rgb(52, 73, 94);">思考：如果</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">spring-boot-starter-thymeleaf</font><font style="color:rgb(52, 73, 94);">包依赖别的包，怎么办？</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">spring-boot-starter-thymeleaf</font><font style="color:rgb(52, 73, 94);">同时也是一个maven项目，也有自己的pom.xml</font>

<font style="color:rgb(52, 73, 94);">查看一下：</font>

```plain
<dependencies>
     <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter</artifactId>
       <version>2.3.3.RELEASE</version>
       <scope>compile</scope>
     </dependency>
     <dependency>
       <groupId>org.thymeleaf</groupId>
       <artifactId>thymeleaf-spring5</artifactId>
       <version>3.0.11.RELEASE</version>
       <scope>compile</scope>
     </dependency>
     <dependency>
       <groupId>org.thymeleaf.extras</groupId>
       <artifactId>thymeleaf-extras-java8time</artifactId>
       <version>3.0.4.RELEASE</version>
       <scope>compile</scope>
     </dependency>
   </dependencies>
```

<font style="color:rgb(52, 73, 94);">这样的话，使用maven的项目，只需要在自己的pom.xml中把所需的最直接的依赖包定义上，而不用关心这些被依赖的jar包自身是否还有别的依赖。剩下的都交给maven去搞定。</font>

<font style="color:rgb(52, 73, 94);">如何搞定？maven可以根据pom.xml中定义的依赖实现包的查找</font>

<font style="color:rgb(52, 73, 94);">去哪查找？maven仓库，存储jar包的地方。</font>

<font style="color:rgb(52, 73, 94);">当我们执行 Maven 构建命令时，Maven 开始按照以下顺序查找依赖的库：</font>

<!-- OCR_START -->
- - 本地仓库
- - 必须要配置了私服仓库，并且可以访问局域网
- - 私服仓库
- - 必须可以访问外网
- - Maven项目
- - 中央仓库
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">本地仓库：</font>

* <font style="color:rgb(52, 73, 94);">Maven 的本地仓库，在安装 Maven 后并不会创建，它是在第一次执行 maven 命令的时候才被创建。</font>
* <font style="color:rgb(52, 73, 94);">运行 Maven 的时候，Maven 所需要的任何包都是直接从本地仓库获取的。如果本地仓库没有，它会首先尝试从远程仓库下载构件至本地仓库，然后再使用本地仓库的包。</font>
* <font style="color:rgb(52, 73, 94);">默认情况下，不管Linux还是 Windows，每个用户在自己的用户目录下都有一个路径名为 .m2/respository/ 的仓库目录。</font>
* <font style="color:rgb(52, 73, 94);">Maven 本地仓库默认被创建在 %USER_HOME% 目录下。要修改默认位置，在 %M2_HOME%\conf 目录中的 Maven 的 settings.xml 文件中定义另一个路径。</font>

```plain
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>D:\opt\maven-repo</localRepository>
</settings>
```

<font style="color:rgb(52, 73, 94);">中央仓库：</font>

<font style="color:rgb(52, 73, 94);">Maven 中央仓库是由 Maven 社区提供的仓库，中央仓库包含了绝大多数流行的开源Java构件，以及源码、作者信息、SCM、信息、许可证信息等。一般来说，简单的Java项目依赖的构件都可以在这里下载到。</font>

<font style="color:rgb(52, 73, 94);">中央仓库的关键概念：</font>

* <font style="color:rgb(52, 73, 94);">这个仓库由 Maven 社区管理。</font>
* <font style="color:rgb(52, 73, 94);">不需要配置，maven中集成了地址 </font><http://repo1.maven.org/maven2>
* <font style="color:rgb(52, 73, 94);">需要通过网络才能访问。</font>

<font style="color:rgb(52, 73, 94);">私服仓库：</font>

<font style="color:rgb(52, 73, 94);">通常使用 sonatype Nexus来搭建私服仓库。搭建完成后，需要在 setting.xml中进行配置，比如：</font>

```plain
<profile>
    <id>localRepository</id>
    <repositories>
        <repository>
            <id>myRepository</id>
            <name>myRepository</name>
            <url>http://127.0.0.1:8081/nexus/content/repositories/myRepository/</url>
            <releases>
                <enabled>true</enabled>
            </releases>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
        </repository>
    </repositories>
</profile>
```

<font style="color:rgb(52, 73, 94);">方便起见，我们直接使用国内ali提供的仓库，修改 maven 根目录下的 conf 文件夹中的 setting.xml 文件，在 mirrors 节点上，添加内容如下：</font>

```plain
<mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
</mirrors>
```

<font style="color:rgb(52, 73, 94);">在执行构建的时候，maven会自动将所需的包下载到本地仓库中，所以第一次构建速度通常会慢一些，后面速度则很快。</font>

<font style="color:rgb(52, 73, 94);">那么maven是如何找到对应的jar包的？</font>

<font style="color:rgb(52, 73, 94);">我们可以访问 </font><https://mvnrepository.com/><font style="color:rgb(52, 73, 94);"> 查看在仓库中的jar包的样子。</font>

```plain
<!-- https://mvnrepository.com/artifact/commons-collections/commons-collections -->
 <dependency>
     <groupId>commons-collections</groupId>
     <artifactId>commons-collections</artifactId>
     <version>3.2.2</version>
 </dependency>
```

<font style="color:rgb(52, 73, 94);">刚才看到</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">spring-boot-starter-thymeleaf</font><font style="color:rgb(52, 73, 94);">的依赖同样有上述属性，因此maven就可以根据这三项属性，到对应的仓库中去查找到所需要的依赖包，并下载到本地。</font>

<font style="color:rgb(52, 73, 94);">其中</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">groupId、artifactId、version</font><font style="color:rgb(52, 73, 94);">共同保证了包在仓库中的唯一性，这也就是为什么maven项目的pom.xml中都先配置这几项的原因，因为项目最终发布到远程仓库中，供别人调用。</font>

<font style="color:rgb(52, 73, 94);">思考：我们项目的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">dependency</font><font style="color:rgb(52, 73, 94);">中为什么没有写</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">version</font><font style="color:rgb(52, 73, 94);"> ?</font>

<font style="color:rgb(52, 73, 94);">是因为sprintboot项目的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">上面有人</font><font style="color:rgb(52, 73, 94);">，来看一下项目</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">parent</font><font style="color:rgb(52, 73, 94);">的写法：</font>

```plain
<parent>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-starter-parent</artifactId>
         <version>2.3.3.RELEASE</version>
         <relativePath/> <!-- lookup parent from repository -->
     </parent>
```

<font style="color:rgb(52, 73, 94);">parent模块中定义过的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">dependencies</font><font style="color:rgb(52, 73, 94);">，在子项目中引用的话，不需要指定版本，这样可以保证所有的子项目都使用相同版本的依赖包。</font>

###### <font style="color:rgb(119, 119, 119);">生命周期及mvn命令实践</font>

<font style="color:rgb(52, 73, 94);">Maven有三套相互独立的生命周期，分别是clean、default和site。每个生命周期包含一些阶段（phase），阶段是有顺序的，后面的阶段依赖于前面的阶段。</font>

* <font style="color:rgb(52, 73, 94);">clean生命周期，清理项目</font>
  * <font style="color:rgb(52, 73, 94);">清理：mvn clean --删除target目录，也就是将class文件等删除</font>
* <font style="color:rgb(52, 73, 94);">default生命周期，项目的构建等核心阶段</font>
  * <font style="color:rgb(52, 73, 94);">编译：mvn compile --src/main/java目录java源码编译生成class （target目录下）</font>
  * <font style="color:rgb(52, 73, 94);">测试：mvn test --src/test/java 执行目录下的测试用例</font>
  * <font style="color:rgb(52, 73, 94);">打包：mvn package --生成压缩文件：java项目#jar包；web项目#war包，也是放在target目录下</font>
  * <font style="color:rgb(52, 73, 94);">安装：mvn install --将压缩文件(jar或者war)上传到本地仓库</font>
  * <font style="color:rgb(52, 73, 94);">部署|发布：mvn deploy --将压缩文件上传私服</font>
* <font style="color:rgb(52, 73, 94);">site生命周期，建立和发布项目站点</font>
  * <font style="color:rgb(52, 73, 94);">站点 : mvn site --生成项目站点文档</font>

<font style="color:rgb(52, 73, 94);">各个生命周期相互独立，一个生命周期的阶段前后依赖。 生命周期阶段需要绑定到某个插件的目标才能完成真正的工作，比如test阶段正是与maven-surefire-plugin的test目标相绑定了 。</font>

<font style="color:rgb(52, 73, 94);">举例如下：</font>

* <font style="color:rgb(52, 73, 94);">mvn clean</font><font style="color:rgb(52, 73, 94);">调用clean生命周期的clean阶段</font>
* <font style="color:rgb(52, 73, 94);">mvn test</font><font style="color:rgb(52, 73, 94);">调用default生命周期的test阶段，实际执行test以及之前所有阶段</font>
* <font style="color:rgb(52, 73, 94);">mvn clean install</font><font style="color:rgb(52, 73, 94);">调用clean生命周期的clean阶段和default的install阶段，实际执行clean，install以及之前所有阶段</font>

<font style="color:rgb(52, 73, 94);">在linux环境中演示：</font>

<font style="color:rgb(52, 73, 94);">创建gitlab组，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">luffy-spring-cloud</font><font style="color:rgb(52, 73, 94);">,在该组下创建项目</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">springboot-demo</font>

* <font style="color:rgb(52, 73, 94);">提交代码到git仓库</font>
* <font style="color:rgb(52, 73, 94);">使用tools容器来运行</font>

```plain
$ git init
$ git remote add origin http://gitlab.luffy.com/luffy-spring-cloud/springboot-demo.git
$ git add .
$ git commit -m "Initial commit"
$ git push -u origin master
```

```plain
$ docker run --rm -ti 172.21.51.67:5000/devops/tools:v3 bash
bash-5.0# mvn -v
bash: mvn: command not found
# 由于idea工具自带了maven，所以可以直接在ide中执行mvn命令。在tools容器中，需要安装mvn命令
```

<font style="color:rgb(52, 73, 94);">为tools镜像集成mvn：</font>

<font style="color:rgb(52, 73, 94);">将本地的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">apache-maven-3.6.3</font><font style="color:rgb(52, 73, 94);">放到</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">tools</font><font style="color:rgb(52, 73, 94);">项目中，修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">settings.xml</font><font style="color:rgb(52, 73, 94);">配置</font>

<font style="color:rgb(52, 73, 94);">然后修改Dockerfile，添加如下部分:</font>

```plain
#-----------------安装 maven--------------------#
  COPY apache-maven-3.6.3 /usr/lib/apache-maven-3.6.3
  RUN ln -s /usr/lib/apache-maven-3.6.3/bin/mvn /usr/local/bin/mvn && chmod +x /usr/local/bin/mvn
  ENV MAVEN_HOME=/usr/lib/apache-maven-3.6.3
  #------------------------------------------------#
```

<font style="color:rgb(52, 73, 94);">去master节点拉取最新代码，构建最新的tools镜像：</font>

```plain
# k8s-master节点
  $ git pull
  $ docker build . -t 172.21.51.67:5000/devops/tools:v4 -f Dockerfile
  $ docker push 172.21.51.67:5000/devops/tools:v4
```

<font style="color:rgb(52, 73, 94);">再次尝试mvn命令：</font>

```plain
$ docker run --rm -ti 172.21.51.67:5000/devops/tools:v4 bash
  bash-5.0# mvn -v
  bash-5.0# git clone http://gitlab.luffy.com/luffy-spring-cloud/springboot-demo.git
  bash-5.0# cd springboot-demo
  bash-5.0# mvn clean
  # 观察/opt/maven目录
  bash-5.0# mvn package
  # 多阶段组合
  bash-5.0# mvn clean package
```

<font style="color:rgb(52, 73, 94);">想系统学习maven，可以参考： </font><https://www.runoob.com/maven/maven-pom.html>

##### <font style="color:rgb(52, 73, 94);">Springboot服务镜像制作</font>

<font style="color:rgb(52, 73, 94);">通过</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">mvn package</font><font style="color:rgb(52, 73, 94);">命令拿到服务的jar包后，我们可以使用如下命令启动服务：</font>

 $ java -jar demo-0.0.1-SNAPSHOT.jar

<font style="color:rgb(52, 73, 94);">因此，需要准备Dockerfile来构建镜像：</font>

```plain
FROM openjdk:8-jdk-alpine
 COPY target/springboot-demo-0.0.1-SNAPSHOT.jar app.jar
 CMD [ "sh", "-c", "java -jar /app.jar" ]
```

<font style="color:rgb(52, 73, 94);">我们可以为构建出的镜像指定名称：</font>

```plain
<build>
         <finalName>${project.artifactId}</finalName><!--打jar包去掉版本号-->
     ...
```

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Dockerfile</font><font style="color:rgb(52, 73, 94);">对应修改：</font>

```plain
FROM openjdk:8-jdk-alpine
 COPY target/springboot-demo.jar app.jar
 CMD [ "sh", "-c", "java -jar /app.jar" ]
```

<font style="color:rgb(52, 73, 94);">执行镜像构建，验证服务启动是否正常：</font>

```plain
$ docker build . -t springboot-demo:v1 -f Dockerfile
 
 $ docker run -d --name springboot-demo -p 8080:8080 springboot-demo:v1
 
 $ curl localhost:8080
```

##### <font style="color:rgb(52, 73, 94);">接入CICD流程</font>

<font style="color:rgb(52, 73, 94);">之前已经实现了shared-library，并且把python项目接入到了CICD 流程中。因此，可以直接使用已有的流程，把spring boot项目接入进去。</font>

* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Jenkinsfile</font>
* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">sonar-project.properties</font>
* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">deploy/deployment.yaml</font>
* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">deploy/service.yaml</font>
* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">deploy/ingress.yaml</font>
* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">configmap/devops-config</font>

```plain
Jenkinsfile
 @Library('luffy-devops') _
 
 pipeline {
     agent { label 'jnlp-slave'}
     options {
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
     environment {
         IMAGE_REPO = "172.21.51.67:5000/demo/springboot-demo"
         IMAGE_CREDENTIAL = "credential-registry"
         DINGTALK_CREDS = credentials('dingTalk')
         PROJECT = "springboot-demo"
     }
     stages {
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
             }
         }
         stage('mvn-package') {
             steps {
                 container('tools') {
                     script{
                         sh 'mvn clean package'
                     }
                 }
             }
         }
         stage('CI'){
             failFast true
             parallel {
                 stage('Unit Test') {
                     steps {
                         echo "Unit Test Stage Skip..."
                     }
                 }
                 stage('Code Scan') {
                     steps {
                         container('tools') {
                             script {
                                devops.scan().start()
                             }
                         }
                     }
                 }
             }
         }
 
         stage('docker-image') {
             steps {
                 container('tools') {
                     script{
                         devops.docker(
                             "${IMAGE_REPO}",
                             "${GIT_COMMIT}",
                             IMAGE_CREDENTIAL
                         ).build().push()
                     }
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     script{
                         devops.deploy("deploy",true,"deploy/deployment.yaml").start()
                     }
                 }
             }
         }
     }
     post {
         success {
             script{
                 devops.notificationSuccess(PROJECT,"dingTalk")
             }
         }
         failure {
             script{
                 devops.notificationFailure(PROJECT,"dingTalk")
             }
         }
     }
 }
 sonar-project.properties
 sonar.projectKey=springboot-demo
 sonar.projectName=springboot-demo
 # if you want disabled the DTD verification for a proxy problem for example, true by default
 # JUnit like test report, default value is test.xml
 sonar.sources=src/main/java
 sonar.language=java
 sonar.tests=src/test/java
 sonar.java.binaries=target/classes
 deploy/deployment.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: springboot-demo
   namespace: {{NAMESPACE}}
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: springboot-demo
   template:
     metadata:
       labels:
         app: springboot-demo
     spec:
       containers:
- name: springboot-demo
           image: {{IMAGE_URL}}
           imagePullPolicy: IfNotPresent
           ports:
- containerPort: 8080
           resources:
             requests:
               memory: 100Mi
               cpu: 50m
             limits:
               memory: 500Mi
               cpu: 100m
           livenessProbe:
             httpGet:
               path: /
               port: 8080
               scheme: HTTP
             initialDelaySeconds: 120
             periodSeconds: 15
             timeoutSeconds: 3
           readinessProbe:
             httpGet:
               path: /
               port: 8080
               scheme: HTTP
             initialDelaySeconds: 120
             timeoutSeconds: 2
             periodSeconds: 15
 deploy/service.yaml
 apiVersion: v1
 kind: Service
 metadata:
   name: springboot-demo
   namespace: {{NAMESPACE}}
 spec:
   ports:
- port: 8080
       protocol: TCP
       targetPort: 8080
   selector:
     app: springboot-demo
   sessionAffinity: None
   type: ClusterIP
 status:
   loadBalancer: {}
 deploy/ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: springboot-demo
   namespace: {{NAMESPACE}}
 spec:
   rules:
- host: {{INGRESS_SPRINGBOOTDEMO}}
       http:
         paths:
- backend:
               serviceName: springboot-demo
               servicePort: 8080
             path: /
 status:
   loadBalancer: {}
```

<font style="color:rgb(52, 73, 94);">维护</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">devops-config</font><font style="color:rgb(52, 73, 94);">的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">configmap</font><font style="color:rgb(52, 73, 94);">，添加</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">INGRESS_SPRINGBOOTDEMO</font><font style="color:rgb(52, 73, 94);">配置项：</font>

```plain
$ kubectl -n dev edit cm devops-config
 ...
 data:
   INGRESS_MYBLOG: blog-dev.luffy.com
   INGRESS_SPRINGBOOTDEMO: springboot-dev.luffy.com
   NAMESPACE: dev
 ...
```

<font style="color:rgb(52, 73, 94);">更新Jenkins中的jnlp-slave-pod模板镜像：</font>

 172.21.51.67:5000/devops/tools:v4

<font style="color:rgb(52, 73, 94);">由于镜像中maven的目录是</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">/opt/maven-repo</font><font style="color:rgb(52, 73, 94);">，而slave-pod是执行完任务后会销毁，因此需要将maven的数据目录挂载出来，不然每次构建都会重新拉取所有依赖的jar包：</font>

<!-- OCR_START -->
- Host Path Volume
- 主机路径
- /var/run/docker.sock
- 挂载路径
- 删除卷
- /opt/maven-repo
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">配置Jenkins流水线：</font>

##### <font style="color:rgb(52, 73, 94);">添加单元测试覆盖率</font>

<font style="color:rgb(52, 73, 94);">单元测试这块内容一直没有把覆盖率统计到</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">sonarqube</font><font style="color:rgb(52, 73, 94);">端，本节看下怎么样将单元测试的结果及覆盖率展示到Jenkins及</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">sonarqube</font><font style="color:rgb(52, 73, 94);">平台中。</font>

<font style="color:rgb(52, 73, 94);">为了展示效果，我们先添加一个单元测试文件</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">HelloControllerTest</font><font style="color:rgb(52, 73, 94);">：</font>

```plain
package com.luffy.demo;
 
 import org.junit.jupiter.api.BeforeEach;
 import org.junit.jupiter.api.Test;
 import org.slf4j.Logger;
 import org.slf4j.LoggerFactory;
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.boot.test.context.SpringBootTest;
 import org.springframework.http.MediaType;
 import org.springframework.test.context.web.WebAppConfiguration;
 import org.springframework.test.web.servlet.MockMvc;
 import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
 import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
 import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
 import org.springframework.test.web.servlet.setup.MockMvcBuilders;
 import org.springframework.web.context.WebApplicationContext;
 
 @SpringBootTest
 @WebAppConfiguration
 public class HelloControllerTests {
 
     private static final Logger logger = LoggerFactory.getLogger(HelloControllerTests.class);
     @Autowired
     private WebApplicationContext webApplicationContext;
 
     private MockMvc mockMvc;
 
     @BeforeEach
     public void setMockMvc() {
         mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
     }
 
     @Test
     public void index(){
         try {
             mockMvc.perform(MockMvcRequestBuilders.post("/")
                     .contentType(MediaType.APPLICATION_JSON)
             ).andExpect(MockMvcResultMatchers.status().isOk())
                     .andDo(MockMvcResultHandlers.print());
         }catch (Exception e) {
             e.printStackTrace();
         }
 
     }
 
     @Test
     public void rightaway(){
         try {
             mockMvc.perform(MockMvcRequestBuilders.post("/rightaway")
                     .contentType(MediaType.APPLICATION_JSON)
             ).andExpect(MockMvcResultMatchers.status().isOk())
                     .andDo(MockMvcResultHandlers.print());
         }catch (Exception e) {
             e.printStackTrace();
         }
 
     }
 
     @Test
     public void sleep(){
         try {
             mockMvc.perform(MockMvcRequestBuilders.post("/sleep")
                     .contentType(MediaType.APPLICATION_JSON)
             ).andExpect(MockMvcResultMatchers.status().isOk())
                     .andDo(MockMvcResultHandlers.print());
         }catch (Exception e) {
             e.printStackTrace();
         }
 
     }
 }
```

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">jacoco</font><font style="color:rgb(52, 73, 94);">：监控JVM中的调用，生成监控结果（默认保存在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">jacoco.exec</font><font style="color:rgb(52, 73, 94);">文件中），然后分析此结果，配合源代码生成覆盖率报告。</font>

<font style="color:rgb(52, 73, 94);">如何引入</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">jacoco</font><font style="color:rgb(52, 73, 94);">测试：</font>

```plain
<plugin>
                 <groupId>org.jacoco</groupId>
                 <artifactId>jacoco-maven-plugin</artifactId>
                 <version>0.7.8</version>
                 <executions>
                     <execution>
                         <goals>
                             <goal>prepare-agent</goal>
                         </goals>
                         <configuration>
                             <destFile>${project.build.directory}/coverage-reports/jacoco.exec</destFile>
                         </configuration>
                     </execution>
                     <execution>
                         <id>default-report</id>
                         <phase>test</phase>
                         <goals>
                             <goal>report</goal>
                         </goals>
                         <configuration>
                             <dataFile>${project.build.directory}/coverage-reports/jacoco.exec</dataFile>
                             <outputDirectory>${project.reporting.outputDirectory}/jacoco</outputDirectory>
                         </configuration>
                     </execution>
                 </executions>
             </plugin>
```

<font style="color:rgb(52, 73, 94);">其中：</font>

* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">prepare-agent</font><font style="color:rgb(52, 73, 94);">，会把agent准备好，这样在执行用例的时候，就会使用agent检测到代码执行的过程，通常将结果保存在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">jacoco.exec</font><font style="color:rgb(52, 73, 94);">中</font>
* <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">report</font><font style="color:rgb(52, 73, 94);">，分析保存的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">jacoco.exec</font><font style="color:rgb(52, 73, 94);">文件，生成报告</font>

<font style="color:rgb(52, 73, 94);">在IDE中添加，观察插件的goal，执行</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">mvn test</font><font style="color:rgb(52, 73, 94);">，观察执行过程。</font>

<font style="color:rgb(52, 73, 94);">有了上述内容后，如何将结果发布到</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">sonarqube</font><font style="color:rgb(52, 73, 94);">中？</font>

<font style="color:rgb(52, 73, 94);">提交最新代码，查看</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">sonarqube</font><font style="color:rgb(52, 73, 94);">的分析结果。</font>

<!-- OCR_START -->
- Coverage Measures
- WActivity
- 80.0%
- Coverage on New Code
- Coverage
- Unit Tests ?
<!-- OCR_END -->

#### <font style="color:rgb(52, 73, 94);">Spring Cloud开发、交付实践</font>

<https://spring.io/projects/spring-cloud#overview>

<font style="color:rgb(52, 73, 94);">1、Netflix是一家做视频的网站，可以这么说该网站上的美剧应该是最火的。</font>

<font style="color:rgb(52, 73, 94);">2、Netflix是一家没有CTO的公司，正是这样的组织架构能使产品与技术无缝的沟通，从而能快速迭代出更优秀的产品。在当时软件敏捷开发中，Netflix的更新速度不亚于当年的微信后台变更，虽然微信比Netflix迟发展，但是当年微信的灰度发布和敏捷开发应该算是业界最猛的。</font>

<font style="color:rgb(52, 73, 94);">3、Netflix由于做视频的原因，访问量非常的大，从而促使其技术快速的发展在背后支撑着，也正是如此，Netflix开始把整体的系统往微服务上迁移。</font>

<font style="color:rgb(52, 73, 94);">4、Netflix的微服务做的不是最早的，但是确是最大规模的在生产级别微服务的尝试。也正是这种大规模的生产级别尝试，在服务器运维上依托AWS云。当然AWS云同样受益于Netflix的大规模业务不断的壮大。</font>

<font style="color:rgb(52, 73, 94);">5、Netflix的微服务大规模的应用，在技术上毫无保留的把一整套微服务架构核心技术栈开源了出来，叫做Netflix OSS，也正是如此，在技术上依靠开源社区的力量不断的壮大。</font>

<font style="color:rgb(52, 73, 94);">6、Spring Cloud是构建微服务的核心，而Spring Cloud是基于Spring Boot来开发的。</font>

<font style="color:rgb(52, 73, 94);">7、Pivotal在Netflix开源的一整套核心技术产品线的同时，做了一系列的封装，就变成了Spring Cloud；虽然Spring Cloud到现在为止不只有Netflix提供的方案可以集成，还有很多方案，但Netflix是最成熟的。</font>

<font style="color:rgb(119, 119, 119);">本课程基于SpringBoot 2.3.6.RELEASE 和Spring Cloud Hoxton.SR9版本</font>

#### <font style="color:rgb(52, 73, 94);">微服务场景</font>

<font style="color:rgb(52, 73, 94);">开发APP，提供个人的花呗账单管理。</font>

* <font style="color:rgb(52, 73, 94);">注册、登录、账单查询</font>
* <font style="color:rgb(52, 73, 94);">用户服务，账单管理服务</font>

<!-- OCR_START -->
- - 场景：APP，查询个人的花呗账单
- - -注册、登录、账单查询
- - -用户服务账单管理
- - Eureka注册中心
- - 注册
- - 用户服务
- - 账单服务
- - user-service
- - bill-service
<!-- OCR_END -->

<!-- OCR_START -->
- - hystrix异常处理
- - 服务0
- - ribbon
- - 服务a
- - 数据库
- - zul
- - server
- - request
- - 服务B
- - 服务注册获取config服务
- - 服务注册+获取服务地址
- - eureka-server
- - 从git仓库获取配置文件
- - 服务注册
- - config-server
- - git仓库
<!-- OCR_END -->

#### <font style="color:rgb(52, 73, 94);">Eureka服务注册中心</font>

<font style="color:rgb(52, 73, 94);">在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">SpringCloud</font><font style="color:rgb(52, 73, 94);">体系中，我们知道服务之间的调用是通过</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http</font><font style="color:rgb(52, 73, 94);">协议进行调用的。而注册中心的主要目的就是维护这些服务的服务列表。</font>

<https://docs.spring.io/spring-cloud-netflix/docs/2.2.5.RELEASE/reference/html/>

##### <font style="color:rgb(52, 73, 94);">新建项目</font>

<!-- OCR_START -->
- - New Project
- - Project Metadata
- - Group:
- - com.luffy
- - Artifact:
- - eureka
- - Type:
- - Maven Project (
- - Language:
- - Java
- - Packaging:
- - Jar
- - Java Version:
- - 8
- - Version:
- - 0.0.1-SNAPSHOT
- - Name:
- - Description:
- - Package:
- - com.luffy.eureka
- - Previous
- - Next
- - Cancel
- - Help
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">pom中引入spring-cloud的依赖：</font>

<https://spring.io/projects/spring-cloud#overview>

```plain
<properties>
    <spring.cloud-version>Hoxton.SR9</spring.cloud-version>
</properties>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>${spring.cloud-version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

<font style="color:rgb(52, 73, 94);">引入eureka-server的依赖：</font>

```plain
<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
```

##### <font style="color:rgb(52, 73, 94);">启动eureka服务</font>

<https://docs.spring.io/spring-cloud-netflix/docs/2.2.5.RELEASE/reference/html/#spring-cloud-eureka-server-standalone-mode>

<font style="color:rgb(52, 73, 94);">application.yml</font>

```plain
server:
  port: 8761

eureka:
  client:
    service-url:
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
    register-with-eureka: false
    fetch-registry: false
  instance:
    hostname: localhost
```

<font style="color:rgb(52, 73, 94);">启动类：</font>

```plain
package com.luffy.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}
```

<font style="color:rgb(52, 73, 94);">启动访问localhost:8761测试</font>

<font style="color:rgb(52, 73, 94);">创建spring cloud项目三部曲：</font>

* <font style="color:rgb(52, 73, 94);">引入依赖包</font>
* <font style="color:rgb(52, 73, 94);">修改application.yml配置文件</font>
* <font style="color:rgb(52, 73, 94);">启动类添加注解</font>

##### <font style="color:rgb(52, 73, 94);">eureka认证</font>

<font style="color:rgb(52, 73, 94);">没有认证，不安全，添加认证：</font>

```plain
<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
```

<font style="color:rgb(52, 73, 94);">application.yml</font>

```plain
server:
  port: 8761
eureka:
  client:
    service-url:
      defaultZone: http://${spring.security.user.name}:${spring.security.user.password}@${eureka.instance.hostname}:${server.port}/eureka/
    register-with-eureka: false
    fetch-registry: false
  instance:
    hostname: localhost
spring:
  security:
    user:
      name: ${EUREKA_USER:admin}
      password: ${EUREKA_PASS:admin}
```

##### <font style="color:rgb(52, 73, 94);">注册服务到eureka</font>

<font style="color:rgb(52, 73, 94);">新建项目，user-service（选择Spring Cloud依赖和SpringBoot Web依赖），用来提供用户查询功能。</font>

<font style="color:rgb(52, 73, 94);">三部曲：</font>

* <font style="color:rgb(52, 73, 94);">pom.xml，并添加依赖</font>
* <font style="color:rgb(52, 73, 94);">创建application.yml配置文件</font>
* <font style="color:rgb(52, 73, 94);">创建Springboot启动类，并配置注解</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">pom.xml</font><font style="color:rgb(52, 73, 94);">添加：</font>

```plain
<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
application.yml
server:
  port: 7000
eureka:
  client:
    serviceUrl:
      defaultZone: http://${EUREKA_USER:admin}:${EUREKA_PASS:admin}@localhost:8761/eureka/
```

<font style="color:rgb(52, 73, 94);">启动类：</font>

```plain
package com.luffy.user;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

//注意这里也可使用@EnableEurekaClient
//但由于springcloud是灵活的，注册中心支持eureka、consul、zookeeper等
//若写了具体的注册中心注解，则当替换成其他注册中心时，又需要替换成对应的注解了。
//所以 直接使用@EnableDiscoveryClient 启动发现。
//这样在替换注册中心时，只需要替换相关依赖即可。
@EnableDiscoveryClient
@SpringBootApplication
public class UserServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }
}
```

<font style="color:rgb(52, 73, 94);">报错：</font>

c.n.d.s.t.d.RetryableEurekaHttpClient    : Request execution failed with message: com.fasterxml.jackson.databind.exc.MismatchedInputException: Root name 'timestamp' does not match expected ('instance') for type \[simple type, class com.netflix.appinfo.InstanceInfo]

<font style="color:rgb(52, 73, 94);">新版本的security默认开启csrf了，关掉，在注册中心新建一个类，继承WebSecurityConfigurerAdapter来关闭 ,> 注意，是在eureka server端关闭。</font>

```plain
package com.luffy.eureka;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
@Configuration
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable(); //关闭csrf
        http.authorizeRequests().anyRequest().authenticated().and().httpBasic(); //开启认证
    }
}
```

<font style="color:rgb(52, 73, 94);">再次启动发现可以注册，但是地址是</font>

<font style="color:rgb(52, 73, 94);">application.yaml</font>

```plain
server:
  port: 7000
eureka:
  client:
    serviceUrl:
      defaultZone: http://${EUREKA_USER:admin}:${EUREKA_PASS:admin}@localhost:8761/eureka/
  instance:
    instance-id: ${eureka.instance.hostname}:${server.port}
    prefer-ip-address: true
    hostname: user-service
spring:
  application:
    name: user-service
```

<font style="color:rgb(52, 73, 94);">Eurake有一个配置参数eureka.server.renewalPercentThreshold，定义了renews 和renews threshold的比值，默认值为0.85。当server在15分钟内，比值低于percent，即少了15%的微服务心跳，server会进入自我保护状态</font>

<font style="color:rgb(52, 73, 94);">默认情况下，如果</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka Server</font><font style="color:rgb(52, 73, 94);">在一定时间内没有接收到某个微服务实例的心跳，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka Server</font><font style="color:rgb(52, 73, 94);">将会注销该实例（默认90秒）。但是当网络分区故障发生时，微服务与Eureka Server之间无法正常通信，这就可能变得非常危险了，因为微服务本身是健康的，此时本不应该注销这个微服务。</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka Server</font><font style="color:rgb(52, 73, 94);">通过“自我保护模式”来解决这个问题，当</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka Server</font><font style="color:rgb(52, 73, 94);">节点在短时间内丢失过多客户端时（可能发生了网络分区故障），那么这个节点就会进入自我保护模式。一旦进入该模式，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka Server</font><font style="color:rgb(52, 73, 94);">就会保护服务注册表中的信息，不再删除服务注册表中的数据（也就是不会注销任何微服务）。当网络故障恢复后，该</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka Server</font><font style="color:rgb(52, 73, 94);">节点会自动退出自我保护模式。</font>

**<font style="color:rgb(52, 73, 94);">自我保护模式是一种对网络异常的安全保护措施。使用自我保护模式，而让Eureka集群更加的健壮、稳定。</font>**

<font style="color:rgb(52, 73, 94);">开发阶段可以通过配置：</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">eureka.server.enable-self-preservation=false</font><font style="color:rgb(52, 73, 94);">关闭自我保护模式。</font>

**<font style="color:rgb(52, 73, 94);">生产阶段，理应以默认值进行配置。</font>**

<font style="color:rgb(52, 73, 94);">至于具体具体的配置参数，可至官网查看：</font><http://cloud.spring.io/spring-cloud-static/Finchley.RELEASE/single/spring-cloud.html#_appendix_compendium_of_configuration_properties>

##### <font style="color:rgb(52, 73, 94);">高可用</font>

<font style="color:rgb(52, 73, 94);">高可用：</font>

* <font style="color:rgb(52, 73, 94);">优先保证可用性</font>
* <font style="color:rgb(52, 73, 94);">各个节点都是平等的，1个节点挂掉不会影响正常节点的工作，剩余的节点依然可以提供注册和查询服务</font>
* <font style="color:rgb(52, 73, 94);">在向某个Eureka注册时如果发现连接失败，则会自动切换至其它节点，只要有一台Eureka还在，就能保证注册服务可用(保证可用性)</font>

<font style="color:rgb(52, 73, 94);">注意点：</font>

* <font style="color:rgb(52, 73, 94);">多实例的话eureka.instance.instance-id需要保持不一样，否则会当成同一个</font>
* <font style="color:rgb(52, 73, 94);">eureka.instance.hostname要与defaultZone里的地址保持一致</font>
* <font style="color:rgb(52, 73, 94);">各个eureka的spring.application.name相同</font>

<!-- OCR_START -->
- - peer1:8762
- - peer2:8763
- - ..registry"
- - Eureka-cluster
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">拷贝</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">eureka</font><font style="color:rgb(52, 73, 94);">服务，分别命名</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">eureka-ha-peer1</font><font style="color:rgb(52, 73, 94);">和</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">eureka-ha-peer2</font>

<font style="color:rgb(52, 73, 94);">修改模块的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">pom.xml</font>

<artifactId>eureka-ha-peer1</artifactId>

<font style="color:rgb(52, 73, 94);">修改配置文件</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">application.yml</font><font style="color:rgb(52, 73, 94);">，注意集群服务，需要各个eureka的spring.application.name相同</font>

```plain
server:
  port: ${EUREKA_PORT:8762}
eureka:
  client:
    service-url:
      defaultZone: ${EUREKA_SERVER:http://${spring.security.user.name}:${spring.security.user.password}@peer1:8762/eureka/,http://${spring.security.user.name}:${spring.security.user.password}@peer2:8763/eureka/}
    fetch-registry: true
  instance:
    instance-id: ${eureka.instance.hostname}:${server.port}
    hostname: peer1
spring:
  security:
    user:
      name: ${EUREKA_USER:admin}
      password: ${EUREKA_PASS:admin}
  application:
    name: eureka-cluster
```

<font style="color:rgb(52, 73, 94);">设置hosts文件</font>

127.0.0.1 peer1 peer2

<font style="color:rgb(52, 73, 94);">服务提供者若想连接高可用的eureka，需要修改：</font>

```
  defaultZone: http://${EUREKA_USER:admin}:${EUREKA_PASS:admin}@peer1:8762/eureka/,http://${EUREKA_USER:admin}:${EUREKA_PASS:admin}@peer2:8763/eureka/
```

##### <font style="color:rgb(52, 73, 94);">k8s交付</font>

<font style="color:rgb(52, 73, 94);">分析：</font>

<font style="color:rgb(52, 73, 94);">高可用互相注册，但是需要知道对方节点的地址。k8s中pod ip是不固定的，如何将高可用的eureka服务使用k8s交付？</font>

* <font style="color:rgb(52, 73, 94);">方案一：创建三个Deployment+三个Service</font>

<!-- OCR_START -->
- - Eureka-2
- - Eureka-3
- - Eureka-1
- - 10.244.2.3
- - 10.244.2.4
- - 10.244.1.8
- - SVC-
- - eureka-
- - 2
- - 3
<!-- OCR_END -->

* <font style="color:rgb(52, 73, 94);">方案二：使用statefulset管理</font>

<!-- OCR_START -->
eureka-sts
3副本
eureka-sts-O.eureka
http://eureka-sts-0.eureka:8761,http://eureka-sts-1.eureka:8761,http://eureka-sts-2.eureka:8761
<!-- OCR_END -->

```plain
eureka-statefulset.yaml
# eureka-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: eureka-cluster
  namespace: dev
spec:
  serviceName: "eureka"
  replicas: 3
  selector:
    matchLabels:
      app: eureka-cluster
  template:
    metadata:
      labels:
        app: eureka-cluster
    spec:
      containers:
- name: eureka
          image: 172.21.51.67:5000/spring-cloud/eureka-cluster:v1
          ports:
- containerPort: 8761
          resources:
            requests:
              memory: 400Mi
              cpu: 50m
            limits:
              memory: 2Gi
              cpu: 2000m
          env:
- name: MY_POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
- name: JAVA_OPTS
              value: -XX:+UnlockExperimentalVMOptions
                -XX:+UseCGroupMemoryLimitForHeap
                -XX:MaxRAMFraction=2
                -XX:CICompilerCount=8
                -XX:ActiveProcessorCount=8
                -XX:+UseG1GC
                -XX:+AggressiveOpts
                -XX:+UseFastAccessorMethods
                -XX:+UseStringDeduplication
                -XX:+UseCompressedOops
                -XX:+OptimizeStringConcat
- name: EUREKA_SERVER
              value: "http://admin:admin@eureka-cluster-0.eureka:8761/eureka/,http://admin:admin@eureka-cluster-1.eureka:8761/eureka/,http://admin:admin@eureka-cluster-2.eureka:8761/eureka/"
- name: EUREKA_INSTANCE_HOSTNAME
              value: ${MY_POD_NAME}.eureka
- name: EUREKA_PORT
              value: "8761"
eureka-headless-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: eureka
  namespace: dev
  labels:
    app: eureka
spec:
  ports:
- port: 8761
      name: eureka
  clusterIP: None
  selector:
    app: eureka-cluster
```

<font style="color:rgb(52, 73, 94);">想通过ingress访问eureka，需要使用有头服务</font>

```plain
apiVersion: v1
 kind: Service
 metadata:
   name: eureka-ingress
   namespace: dev
   labels:
     app: eureka-cluster
 spec:
   ports:
- port: 8761
       name: eureka-cluster
   selector:
     app: eureka-cluster
 ---
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: eureka-cluster
   namespace: dev
 spec:
   rules:
- host: eureka-cluster.luffy.com
       http:
         paths:
- backend:
               serviceName: eureka-ingress
               servicePort: 8761
             path: /
 status:
   loadBalancer: {}
```

##### <font style="color:rgb(52, 73, 94);">使用StatefulSet管理有状态服务</font>

<font style="color:rgb(52, 73, 94);">使用StatefulSet创建多副本pod的情况：</font>

```plain
apiVersion: apps/v1
 kind: StatefulSet
 metadata:
   name: nginx-statefulset
   labels:
     app: nginx-sts
 spec:
   replicas: 3
   serviceName: "nginx"
   selector:
     matchLabels:
       app: nginx-sts
   template:
     metadata:
       labels:
         app: nginx-sts
     spec:
       containers:
- name: nginx
         image: nginx:alpine
         ports:
- containerPort: 80
```

<font style="color:rgb(52, 73, 94);">无头服务Headless Service</font>

```plain
kind: Service
 apiVersion: v1
 metadata:
   name: nginx
 spec:
   selector:
     app: nginx-sts
   ports:
- protocol: TCP
     port: 80
     targetPort: 80
   clusterIP: None
 $ kubectl -n spring exec  -ti nginx-statefulset-0 sh
 / # curl nginx-statefulset-2.nginx
```

##### <font style="color:rgb(52, 73, 94);">接入CICD流程</font>

<font style="color:rgb(52, 73, 94);">所需的文件:</font>

* <font style="color:rgb(52, 73, 94);">在pom.xml中重写jar包名称：</font>

```plain
<finalName>${project.artifactId}</finalName>
 Dockerfile
 FROM openjdk:8-jdk-alpine
 ADD target/eureka.jar app.jar
 ENV JAVA_OPTS=""
 CMD [ "sh", "-c", "java $JAVA_OPTS -jar /app.jar" ]
 Jenkinsfile
 @Library('luffy-devops') _
 
 pipeline {
     agent { label 'jnlp-slave'}
     options {
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
     environment {
         IMAGE_REPO = "172.21.51.67:5000/spring-cloud/eureka-cluster"
         IMAGE_CREDENTIAL = "credential-registry"
         DINGTALK_CREDS = credentials('dingTalk')
         PROJECT = "eureka-cluster"
     }
     stages {
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
             }
         }
         stage('mvn-package') {
             steps {
                 container('tools') {
                     script{
                         sh 'mvn clean package'
                     }
                 }
             }
         }
         stage('CI'){
             failFast true
             parallel {
                 stage('Unit Test') {
                     steps {
                         echo "Unit Test Stage Skip..."
                     }
                 }
                 stage('Code Scan') {
                     steps {
                         container('tools') {
                             script {
                                devops.scan().start()
                             }
                         }
                     }
                 }
             }
         }
 
         stage('docker-image') {
             steps {
                 container('tools') {
                     script{
                         devops.docker(
                             "${IMAGE_REPO}",
                             "${GIT_COMMIT}",
                             IMAGE_CREDENTIAL
                         ).build().push()
                     }
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     script{
                         devops.deploy("deploy",false,"deploy/statefulset.yaml").start()
                     }
                 }
             }
         }
     }
     post {
         success {
             script{
                 devops.notificationSuccess(PROJECT,"dingTalk")
             }
         }
         failure {
             script{
                 devops.notificationFailure(PROJECT,"dingTalk")
             }
         }
     }
 }
 sonar-project.properties
 sonar.projectKey=eureka-cluster
 sonar.projectName=eureka-cluster
 # if you want disabled the DTD verification for a proxy problem for example, true by default
 # JUnit like test report, default value is test.xml
 sonar.sources=src/main/java
 sonar.language=java
 sonar.tests=src/test/java
 sonar.java.binaries=target/classes
```

<font style="color:rgb(52, 73, 94);">模板化k8s资源清单：</font>

```plain
# eureka-statefulset.yaml
 apiVersion: apps/v1
 kind: StatefulSet
 metadata:
   name: eureka-cluster
   namespace: {{NAMESPACE}}
 spec:
   serviceName: "eureka"
   replicas: 3
   selector:
     matchLabels:
       app: eureka-cluster
   template:
     metadata:
       labels:
         app: eureka-cluster
     spec:
       containers:
- name: eureka
           image: {{IMAGE_URL}}
 ...
```

<font style="color:rgb(52, 73, 94);">维护新组件的ingress:</font>

```plain
$ kubectl -n dev edit configmap devops-config
 ...
   INGRESS_EUREKA: eureka.luffy.com
 ...
```

<font style="color:rgb(52, 73, 94);">部署k8s集群时，将eureka的集群地址通过参数的形式传递到pod内部，因此本地开发时，直接按照单点模式进行：</font>

```plain
server:
   port: ${EUREKA_PORT:8761}
 eureka:
   client:
     service-url:
       defaultZone: ${EUREKA_SERVER:http://${spring.security.user.name}:${spring.security.user.password}@localhost:8761/eureka/}
     fetch-registry: true
     register-with-eureka: true
   instance:
     instance-id: ${eureka.instance.hostname}:${server.port}
     hostname: ${EUREKA_INSTANCE_HOSTNAME:localhost}
     prefer-ip-address: true
 spring:
   security:
     user:
       name: ${EUREKA_USER:admin}
       password: ${EUREKA_PASS:admin}
   application:
     name: eureka-cluster
```

<font style="color:rgb(52, 73, 94);">提交项目：</font>

<font style="color:rgb(52, 73, 94);">创建develop分支，CICD部署开发环境</font>

<font style="color:rgb(119, 119, 119);">停掉eureka-ha</font>

#### <font style="color:rgb(52, 73, 94);">微服务间调用</font>

##### <font style="color:rgb(52, 73, 94);">服务提供者</font>

<font style="color:rgb(52, 73, 94);">前面已经将用户服务注册到了eureka注册中心，但是还没有暴漏任何API给服务消费者调用。</font>

<font style="color:rgb(52, 73, 94);">新建controller类：</font>

```plain
package com.luffy.userservice.controller;

import com.luffy.userservice.entity.User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.Random;

@RestController
public class UserController {

    @GetMapping("/user")
    public String getUserService(){
        return "this is user-service";
    }

    @GetMapping("/user-nums")
    public Integer getUserNums(){
        return new Random().nextInt(100);
    }

    //{"id": 123, "name": "张三", "age": 20, "sex": "male"}
    @GetMapping("/user/{id}")
    public User getUserInfo(@PathVariable("id") int id){
        User user = new User();
        user.setId(id);
        user.setAge(20);
        user.setName("zhangsan");
        user.setSex("male");
        return user;
    }
}
```

<font style="color:rgb(52, 73, 94);">实体类User.java</font>

```plain
package com.luffy.userservice.entity;

public class User {
    private int id;
    private String name;
    private int age;
    private String sex;

    public int getAge() {
        return age;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getSex() {
        return sex;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }
}
application.yml
```

<font style="color:rgb(52, 73, 94);">增加从环境变量中读取</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">EUREKA_SERVER</font><font style="color:rgb(52, 73, 94);">和</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">EUREKA_INSTANCE_HOSTNAME</font><font style="color:rgb(52, 73, 94);">配置</font>

```plain
server:
   port: 7000
 eureka:
   client:
     serviceUrl:
       defaultZone: ${EUREKA_SERVER:http://admin:admin@localhost:8761/eureka/}
   instance:
     instance-id: ${eureka.instance.hostname}:${server.port}
     prefer-ip-address: true
     hostname: ${INSTANCE_HOSTNAME:user-service}
 spring:
   application:
     name: user-service
```

###### <font style="color:rgb(119, 119, 119);">CICD持续交付服务提供者</font>

```plain
deployment.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: user-service
   namespace: {{NAMESPACE}}
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: user-service
   template:
     metadata:
       labels:
         app: user-service
     spec:
       containers:
- name: user-service
           image: {{IMAGE_URL}}
           imagePullPolicy: IfNotPresent
           ports:
- containerPort: 7000
           resources:
             requests:
               memory: 400Mi
               cpu: 50m
             limits:
               memory: 2Gi
               cpu: 2000m
           env:
- name: JAVA_OPTS
               value: -XX:+UnlockExperimentalVMOptions
                 -XX:+UseCGroupMemoryLimitForHeap
                 -XX:MaxRAMFraction=2
                 -XX:CICompilerCount=8
                 -XX:ActiveProcessorCount=8
                 -XX:+UseG1GC
                 -XX:+AggressiveOpts
                 -XX:+UseFastAccessorMethods
                 -XX:+UseStringDeduplication
                 -XX:+UseCompressedOops
                 -XX:+OptimizeStringConcat
- name: EUREKA_SERVER
               value: "http://admin:admin@eureka-cluster-0.eureka:8761/eureka/,http://admin:admin@eureka-cluster-1.eureka:8761/eureka/,http://admin:admin@eureka-cluster-2.eureka:8761/eureka/"
- name: INSTANCE_HOSTNAME
               valueFrom:
                 fieldRef:
                   fieldPath: metadata.name
 service.yaml
 apiVersion: v1
 kind: Service
 metadata:
   name: user-service
   namespace: {{NAMESPACE}}
 spec:
   ports:
- port: 7000
       protocol: TCP
       targetPort: 7000
   selector:
     app: user-service
   sessionAffinity: None
   type: ClusterIP
 status:
   loadBalancer: {}
 ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: user-service
   namespace: {{NAMESPACE}}
 spec:
   rules:
- host: {{INGRESS_USER_SERVICE}}
       http:
         paths:
- backend:
               serviceName: user-service
               servicePort: 7000
             path: /
 status:
   loadBalancer: {}
```

<font style="color:rgb(52, 73, 94);">ingress配置：</font>

```plain
$ kubectl -n dev edit configmap devops-config
 ...
 data:
   INGRESS_MYBLOG: blog-dev.luffy.com
   INGRESS_SPRINGBOOTDEMO: springboot-dev.luffy.com
   INGRESS_USER_SERVICE: user-service-dev.luffy.com
   NAMESPACE: dev
 ...
 Jenkinsfile
 @Library('luffy-devops') _
 
 pipeline {
     agent { label 'jnlp-slave'}
     options {
         timeout(time: 20, unit: 'MINUTES')
         gitLabConnection('gitlab')
     }
     environment {
         IMAGE_REPO = "172.21.51.67:5000/spring-cloud/user-service"
         IMAGE_CREDENTIAL = "credential-registry"
         DINGTALK_CREDS = credentials('dingTalk')
         PROJECT = "user-service"
     }
     stages {
         stage('checkout') {
             steps {
                 container('tools') {
                     checkout scm
                 }
             }
         }
         stage('mvn-package') {
             steps {
                 container('tools') {
                     script{
                         sh 'mvn clean package'
                     }
                 }
             }
         }
         stage('CI'){
             failFast true
             parallel {
                 stage('Unit Test') {
                     steps {
                         echo "Unit Test Stage Skip..."
                     }
                 }
                 stage('Code Scan') {
                     steps {
                         container('tools') {
                             script {
                                devops.scan().start()
                             }
                         }
                     }
                 }
             }
         }
 
         stage('docker-image') {
             steps {
                 container('tools') {
                     script{
                         devops.docker(
                             "${IMAGE_REPO}",
                             "${GIT_COMMIT}",
                             IMAGE_CREDENTIAL
                         ).build().push()
                     }
                 }
             }
         }
         stage('deploy') {
             steps {
                 container('tools') {
                     script{
                         devops.deploy("deploy",true,"deploy/deployment.yaml").start()
                     }
                 }
             }
         }
     }
     post {
         success {
             script{
                 devops.notificationSuccess(PROJECT,"dingTalk")
             }
         }
         failure {
             script{
                 devops.notificationFailure(PROJECT,"dingTalk")
             }
         }
     }
 }
 pom.xml
 <finalName>${project.artifactId}</finalName>
 Dockerfile
 FROM openjdk:8-jdk-alpine
 COPY target/user-service.jar app.jar
 ENV JAVA_OPTS=""
 CMD [ "sh", "-c", "java $JAVA_OPTS -jar /app.jar" ]
 sonar-project.properties
 sonar.projectKey=user-service
 sonar.projectName=user-service
 # if you want disabled the DTD verification for a proxy problem for example, true by default
 # JUnit like test report, default value is test.xml
 sonar.sources=src/main/java
 sonar.language=java
 sonar.tests=src/test/java
 sonar.java.binaries=target/classes
```

<font style="color:rgb(52, 73, 94);">创建user-service项目，提交代码：</font>

```plain
git init
git remote add origin http://gitlab.luffy.com/luffy-spring-cloud/user-service.git
git add .
git commit -m "Initial commit"
git push -u origin master

# 提交到develop分支
git checkout -b develop
git push -u origin develop
```

<font style="color:rgb(52, 73, 94);">创建Jenkins任务，测试自动部署</font>

<font style="color:rgb(52, 73, 94);">访问</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http://user-service-dev.luffy.com/</font><font style="color:rgb(52, 73, 94);"> 验证</font>

##### <font style="color:rgb(52, 73, 94);">服务消费者</font>

###### <font style="color:rgb(119, 119, 119);">RestTemplate</font>

<font style="color:rgb(52, 73, 94);">在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spring</font><font style="color:rgb(52, 73, 94);">中，提供了</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">RestTemplate</font><font style="color:rgb(52, 73, 94);">。</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">RestTemplate</font><font style="color:rgb(52, 73, 94);">是</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spring</font><font style="color:rgb(52, 73, 94);">提供的用于访问Rest服务的客户端。而在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">SpringCloud</font><font style="color:rgb(52, 73, 94);">中也是使用此服务进行服务调用的。</font>

###### <font style="color:rgb(119, 119, 119);">创建bill-service模块</font>

<font style="color:rgb(52, 73, 94);">新的模块初始化三部曲：</font>

* <font style="color:rgb(52, 73, 94);">pom.xml</font>
* <font style="color:rgb(52, 73, 94);">启动类</font>
* <font style="color:rgb(52, 73, 94);">配置文件</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">pom.xml</font><font style="color:rgb(52, 73, 94);"> 添加如下内容:</font>

```plain
<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
```

<font style="color:rgb(52, 73, 94);">全量内容如下:</font>

```plain
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.6.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.luffy</groupId>
    <artifactId>bill-service</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>bill-service</name>
    <description>bill-service</description>

    <properties>
        <java.version>1.8</java.version>
        <spring-cloud.version>Hoxton.SR9</spring-cloud.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
            <exclusions>
                <exclusion>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <finalName>${project.artifactId}</finalName><!--打jar包去掉版本号-->
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
BillServiceApplication
package com.luffy.billservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class BillServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(BillService.class, args);
    }
}
```

<font style="color:rgb(52, 73, 94);">application.yml</font>

```plain
server:
   port: 7001
 eureka:
   client:
     serviceUrl:
       defaultZone: ${EUREKA_SERVER:http://admin:admin@localhost:8761/eureka/}
   instance:
     instance-id: ${eureka.instance.hostname}:${server.port}
     prefer-ip-address: true
     hostname: ${INSTANCE_HOSTNAME:bill-service}
 spring:
   application:
     name: bill-service
```

<font style="color:rgb(52, 73, 94);">BillController</font>

```plain
package com.luffy.billservice.controller;
 
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.context.annotation.Bean;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.RestController;
 import org.springframework.web.client.RestTemplate;
 
 @RestController
 public class BillController {
 
     @Bean
     public RestTemplate restTemplate() {
         return new RestTemplate();
     }
 
     @Autowired
     private RestTemplate restTemplate;
 
     @GetMapping("/bill/user")
     public String getUserInfo(){
         return restTemplate.getForObject("http://localhost:7000/user", String.class);
     }
 }
```

<font style="color:rgb(52, 73, 94);">问题：</font>

* <font style="color:rgb(52, 73, 94);">服务调用采用指定IP+Port方式，注册中心未使用</font>
* <font style="color:rgb(52, 73, 94);">多个服务负载均衡</font>

###### <font style="color:rgb(119, 119, 119);">使用注册中心实现服务调用</font>

<font style="color:rgb(52, 73, 94);">修改BillController</font>

```plain
package com.luffy.billservice.controller;
 
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.cloud.client.loadbalancer.LoadBalanced;
 import org.springframework.context.annotation.Bean;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.RestController;
 import org.springframework.web.client.RestTemplate;
 
 @RestController
 public class BillController {
 
     @Bean
     @LoadBalanced
     public RestTemplate restTemplate() {
         return new RestTemplate();
     }
 
     @Autowired
     private RestTemplate restTemplate;
 
     @GetMapping("/bill/user")
     public String getUserInfo(){
         return restTemplate.getForObject("http://user-service/user", String.class);
     }
 }
```

<font style="color:rgb(52, 73, 94);">访问测试</font>

**<font style="color:rgb(52, 73, 94);">总体来说，就是通过为加入</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">@LoadBalanced</font>****<font style="color:rgb(52, 73, 94);">注解的</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">RestTemplate</font>****<font style="color:rgb(52, 73, 94);">添加一个请求拦截器，在请求前通过拦截器获取真正的请求地址，最后进行服务调用。</font>**

**<font style="color:rgb(52, 73, 94);">友情提醒：若被</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">@LoadBalanced</font>****<font style="color:rgb(52, 73, 94);">注解的</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">RestTemplate</font>****<font style="color:rgb(52, 73, 94);">访问正常的服务地址，如</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http://127.0.0.1:8080/hello</font>****<font style="color:rgb(52, 73, 94);">时，是会提示无法找到此服务的。</font>**

<font style="color:rgb(52, 73, 94);">具体原因：</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">serverid</font><font style="color:rgb(52, 73, 94);">必须是我们访问的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">服务名称</font><font style="color:rgb(52, 73, 94);"> ，当我们直接输入</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">ip</font><font style="color:rgb(52, 73, 94);">的时候获取的</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">server</font><font style="color:rgb(52, 73, 94);">是</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">null</font><font style="color:rgb(52, 73, 94);">，就会抛出异常。</font>

<font style="color:rgb(52, 73, 94);">如果想继续调用，可以通过如下方式：</font>

```plain
package com.luffy.billservice.controller;
 
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.beans.factory.annotation.Qualifier;
 import org.springframework.cloud.client.loadbalancer.LoadBalanced;
 import org.springframework.context.annotation.Bean;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.RestController;
 import org.springframework.web.client.RestTemplate;
 
 @RestController
 public class BillController {
 
     @Bean
     @LoadBalanced
     public RestTemplate restTemplate() {
         return new RestTemplate();
     }
 
     @Autowired
     private RestTemplate restTemplate;
 
     @Bean("normalRestTemplate")
     public RestTemplate normalRestTemplate() {
         return new RestTemplate();
     }
 
     @Autowired
     @Qualifier("normalRestTemplate")
     RestTemplate normalRestTemplate;
 
 
     @GetMapping("/service/user")
     public String getUserInfo(){
         return restTemplate.getForObject("http://user-service/user", String.class);
     }
 
     @GetMapping("/normal")
     public String normal() {
         return normalRestTemplate.getForObject("http://localhost:7000/user", String.class);
     }
 }
```

###### <font style="color:rgb(119, 119, 119);">Ribbon 负载均衡</font>

<font style="color:rgb(52, 73, 94);">再启动一个user-service-instance2，复制user-service项目</font>

<font style="color:rgb(52, 73, 94);">修改user-service-instance2的application.yml的server.port</font>

```plain
server:
  port: 7002
eureka:
  client:
    serviceUrl:
      defaultZone: ${EUREKA_SERVER:http://admin:admin@peer1:8761/eureka/}
  instance:
    instance-id: ${eureka.instance.hostname}:${server.port}
    prefer-ip-address: true
    hostname: ${INSTANCE_HOSTNAME:user-service}
spring:
  application:
    name: user-service
```

<font style="color:rgb(52, 73, 94);">修改user-service-instance2的UserController.java，为了可以区分是哪个服务提供者的实例提供的服务</font>

```plain
package com.luffy.userservice.controller;
 
 
 import com.luffy.userservice.entity.User;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.PathVariable;
 import org.springframework.web.bind.annotation.RestController;
 
 import java.util.Random;
 
 @RestController
 public class UserController {
 
     @GetMapping("/user")
     public String getUserService(){
         return "this is user-service-instance2";
     }
 
     @GetMapping("/user-nums")
     public Integer getUserNums(){
         return new Random().nextInt(100);
     }
 
     //{"id": 123, "name": "张三", "age": 20, "sex": "male"}
     @GetMapping("/user/{id}")
     public User getUserInfo(@PathVariable("id") int id){
         User user = new User();
         user.setId(id);
         user.setAge(20);
         user.setName("zhangsan");
         user.setSex("male");
         return user;
     }
 }
```

<font style="color:rgb(52, 73, 94);">访问bill-service，查看调用结果（默认是轮询策略）</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spring Cloud Ribbon</font><font style="color:rgb(52, 73, 94);">是一个基于Http和TCP的客服端负载均衡工具，它是基于</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Netflix Ribbon</font><font style="color:rgb(52, 73, 94);">实现的。与</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka</font><font style="color:rgb(52, 73, 94);">配合使用时，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Ribbon</font><font style="color:rgb(52, 73, 94);">可自动从</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Eureka Server (注册中心)</font><font style="color:rgb(52, 73, 94);">获取服务提供者地址列表，并基于</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">负载均衡</font><font style="color:rgb(52, 73, 94);">算法，通过在客户端中配置</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">ribbonServerList</font><font style="color:rgb(52, 73, 94);">来设置服务端列表去轮询访问以达到均衡负载的作用。</font>

<font style="color:rgb(119, 119, 119);">eureka-client中包含了ribbon的包，所以不需要单独引入</font>

<!-- OCR_START -->
- - 服务提供者1
- - 注册
- - 服务提供者2
- - 注册中心
- - (Eureka)
- - 服务提供者3
- - 获取可用地址
- - 服务消费者
- - 负载均衡请求
- - (Ribbon)
<!-- OCR_END -->

<!-- OCR_START -->
- - 应用1
- - HTTP
- - 客户端
- - 应用2
- - Ribbon
- - 应用3
<!-- OCR_END -->

<!-- OCR_START -->
- - 应用1
- - HTTP
- - 负载均衡
- - 客户端
- - 应用2
- - Nginx
- - 应用3
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">如何修改调用策略？</font>

* <font style="color:rgb(52, 73, 94);">代码中指定rule的规则</font>
* <font style="color:rgb(52, 73, 94);">配置文件配置</font>

<font style="color:rgb(52, 73, 94);">在bill-service中新建package，com.luffy.rule，注意不能被springboot扫描到，不然规则就成了全局规则，所有的ribbonclient都会应用到该规则。</font>

```plain
package com.luffy.rule;

import com.netflix.loadbalancer.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RandomConfiguration {

    @Bean
    public IRule ribbonRule() {
        // new BestAvailableRule();
        // new WeightedResponseTimeRule();
        return new RandomRule();
    }
}
```

<font style="color:rgb(52, 73, 94);">修改BillController</font>

```plain
import com.luffy.rule.RandomConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.ribbon.RibbonClient;

@SpringBootApplication
@EnableDiscoveryClient
@RibbonClient(name = "user-service", configuration = RandomConfiguration.class)
public class BillServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(BillServiceApplication.class, args);
    }
}
```

<!-- OCR_START -->
√RoundRobinRule：轮询策略，Ribbon以轮询的方式选择服务器，这个是默认值。
√RandomRule：随机选择，也就是说Ribbon会随机从服务器列表中选择一个进行访问：
√BestAvailableRule：最大可用策略，即先过滤出故障服务器后，选择一个当前并发请求数最小的：
√WeightedResponseTimeRule：带有加权的轮询策略，对各个服务器响应时间进行加权处理，然后在采用轮询
的方式来获取相应的服务器：
√AvailabilitvFilteringRule：可用过滤策略，先过滤出故障的或并发请求大于國值一部分服务实例，然后再以线
性轮询的方式从过滤后的实例清单中选出一个
VZoneAvoidanceRule：区域感知策略，先使用主过滤条件（区域负载器，选择最优区域）对所有实例过滤并返
回过滤后的实例清单，依次使用次过滤条件列表中的过滤条件对主过滤条件的结果进行过滤，判断最小过滤数（
默认1）和最小过滤白分比（默认o），最后对满足条件的服务器则使用RoundRobinRule（轮询方式）选择一个
服务器实例。
可继承ClientConfigEnabledRoundRobinRule，来实现自己负载均衡策略。
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">配置文件方式： </font><https://docs.spring.io/spring-cloud-netflix/docs/2.2.5.RELEASE/reference/html/#customizing-the-ribbon-client-by-setting-properties>

<font style="color:rgb(52, 73, 94);">注释掉代码：</font>

```plain
package com.luffy.ticket;

import com.luffy.rule.RandomConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.ribbon.RibbonClient;

@SpringBootApplication
@EnableDiscoveryClient
//@RibbonClient(name = "USER-SERVICE", configuration = RandomConfiguration.class)
public class TicketApplication {
    public static void main(String[] args) {
        SpringApplication.run(TicketApplication.class, args);
    }
}
```

<font style="color:rgb(52, 73, 94);">修改配置文件：</font>

```plain
server:
   port: ${SERVER_PORT:9000}
 
 spring:
   application:
     name: bill-service
 
 eureka:
   client:
     service-url:
       defaultZone: ${EUREKA_SERVER:http://admin:admin@peer1:8762/eureka/,http://admin:admin@peer2:8763/eureka/}
   instance:
     prefer-ip-address: true
     instance-id: ${spring.cloud.client.ip-address}:${server.port}
 user-service:
   ribbon:
     NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule
```

###### <font style="color:rgb(119, 119, 119);">声明式服务Feign</font>

<font style="color:rgb(52, 73, 94);">从上一章节，我们知道，当我们要调用一个服务时，需要知道服务名和api地址，这样才能进行服务调用，服务少时，这样写觉得没有什么问题，但当服务一多，接口参数很多时，上面的写法就显得不够优雅了。所以，接下来，来说说一种更好更优雅的调用服务的方式：</font>**<font style="color:rgb(52, 73, 94);">Feign</font>**<font style="color:rgb(52, 73, 94);">。</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Feign</font><font style="color:rgb(119, 119, 119);">是</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Netflix</font><font style="color:rgb(119, 119, 119);">开发的声明式、模块化的HTTP客户端。</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Feign</font><font style="color:rgb(119, 119, 119);">可帮助我们更好更快的便捷、优雅地调用</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">HTTP API</font><font style="color:rgb(119, 119, 119);">。</font>

<font style="color:rgb(52, 73, 94);">在</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Spring Cloud</font><font style="color:rgb(52, 73, 94);">中，使用</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Feign</font><font style="color:rgb(52, 73, 94);">非常简单——创建一个接口，并在接口上添加一些注解。</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Feign</font><font style="color:rgb(52, 73, 94);">支持多种注释，例如Feign自带的注解或者JAX-RS注解等 Spring Cloud对Feign进行了增强，使Feign支持了Spring MVC注解，并整合了Ribbon和 Eureka,从而让Feign 的使用更加方便。</font>**<font style="color:rgb(52, 73, 94);">只需要通过创建接口并用注解来配置它既可完成对Web服务接口的绑定。</font>**

<https://github.com/OpenFeign/feign>

<font style="color:rgb(52, 73, 94);">对bill-service项目添加openfeign的依赖引入：</font>

```plain
<dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-openfeign</artifactId>
         </dependency>
```

<font style="color:rgb(52, 73, 94);">启动类中引入Feign注解：</font>

```plain
package com.luffy.billservice;
 
 import org.springframework.boot.SpringApplication;
 import org.springframework.boot.autoconfigure.SpringBootApplication;
 import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
 import org.springframework.cloud.openfeign.EnableFeignClients;
 
 @SpringBootApplication
 @EnableDiscoveryClient
 @EnableFeignClients
 public class BillServiceApplication {
 
     public static void main(String[] args) {
         SpringApplication.run(BillServiceApplication.class, args);
     }
 
 }
```

<font style="color:rgb(52, 73, 94);">建立interface</font>

```plain
package com.luffy.billservice.interfaces;
 
 import com.luffy.billservice.entity.User;
 import org.springframework.cloud.openfeign.FeignClient;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.PathVariable;
 
 @FeignClient(name="user-service")
 public interface UserServiceCli {
 
     @GetMapping("/user")
     public String getUserService();
 
     @GetMapping("/user/{id}")
     public User getUserInfo(@PathVariable("id") int id);
 }
```

<font style="color:rgb(52, 73, 94);">拷贝User类到当前项目：</font>

```plain
package com.luffy.billservice.entity;
 
 public class User {
     private int id;
     private String name;
     private int age;
     private String sex;
 
     public int getAge() {
         return age;
     }
 
     public int getId() {
         return id;
     }
 
     public String getName() {
         return name;
     }
 
     public String getSex() {
         return sex;
     }
 
     public void setAge(int age) {
         this.age = age;
     }
 
     public void setId(int id) {
         this.id = id;
     }
 
     public void setName(String name) {
         this.name = name;
     }
 
     public void setSex(String sex) {
         this.sex = sex;
     }
 }
```

<font style="color:rgb(52, 73, 94);">修改BillController</font>

```plain
package com.luffy.billservice.controller;
 
 import com.luffy.billservice.entity.User;
 import com.luffy.billservice.interfaces.UserServiceCli;
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.PathVariable;
 import org.springframework.web.bind.annotation.RestController;
 
 @RestController
 public class BillController {
 
     @Autowired
     private UserServiceCli userServiceCli;
 
 
     @GetMapping("/bill/user")
     public String getUserInfo(){
         return userServiceCli.getUserService();
     }
 
     @GetMapping("/bill/user/{id}")
     public User getUserInfo(@PathVariable("id") int id){
         return userServiceCli.getUserInfo(id);
         //return restTemplate.getForObject("http://USER-SERVICE/user/" + id, String.class);
     }
 }
```

###### <font style="color:rgb(119, 119, 119);">CICD持续交付服务消费者</font>

<font style="color:rgb(52, 73, 94);">拷贝user-service的交付文件，替换如下：</font>

* <font style="color:rgb(52, 73, 94);">user-service -> bill-service</font>
* <font style="color:rgb(52, 73, 94);">7000 -> 7001</font>
* <font style="color:rgb(52, 73, 94);">INGRESS_USER_SERVICE -> INGRESS_BILL_SERVICE</font>

```plain
$ kubectl -n dev edit configmap devops-config
 ...
 data:
   INGRESS_MYBLOG: blog-dev.luffy.com
   INGRESS_SPRINGBOOTDEMO: springboot-dev.luffy.com
   INGRESS_USER_SERVICE: user-service-dev.luffy.com
   INGRESS_BILL_SERVICE: user-service-dev.luffy.com
   NAMESPACE: dev
 ...
```

<font style="color:rgb(52, 73, 94);">创建develop分支，提交代码到gitlab仓库，验证持续交付</font>

<font style="color:rgb(52, 73, 94);">前面主要讲解了下服务消费者如何利用原生、ribbon、fegin三种方式进行服务调用的，其实每种调用方式都是使用</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">restTemplate</font><font style="color:rgb(52, 73, 94);">来进行调用的，只是有些进行了增强，目的是使用起来更简单高效。</font>

##### <font style="color:rgb(52, 73, 94);">Hystrix 断路器</font>

<font style="color:rgb(52, 73, 94);">为什么需要断路器？</font>

<!-- OCR_START -->
- - 正常
- - A不可用
- - 时间推移
- - AB不可用
- - 系统不可用
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">A作为服务提供者，B为A的服务消费者，C和D是B的服务消费者。A不可用引起了B的不可用，并将不可用像滚雪球一样放大到C和D时，雪崩效应就形成了。</font>

<font style="color:rgb(52, 73, 94);">因此，需要实现一种机制，可以做到自动监控服务状态并根据调用情况进行自动处理。</font>

* <font style="color:rgb(52, 73, 94);">记录时间周期内服务调用失败次数</font>
* <font style="color:rgb(52, 73, 94);">维护断路器的打开、关闭、半开三种状态</font>
* <font style="color:rgb(52, 73, 94);">提供fallback机制</font>

<!-- OCR_START -->
- - Browser
- - Mobile
- - API
- - Fallback
- - Service
<!-- OCR_END -->

<font style="color:rgb(52, 73, 94);">修改bill-service项目：</font>

<font style="color:rgb(52, 73, 94);">pom.xml</font>

```plain
<dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
         </dependency>
```

<font style="color:rgb(52, 73, 94);">application.xml</font>

```plain
feign:
   hystrix:
     enabled: true
```

<font style="color:rgb(52, 73, 94);">启动类添加注解</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">@EnableCircuitBreaker</font>

```plain
package com.luffy.billservice;
 
 import org.springframework.boot.SpringApplication;
 import org.springframework.boot.autoconfigure.SpringBootApplication;
 import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
 import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
 import org.springframework.cloud.openfeign.EnableFeignClients;
 
 @SpringBootApplication
 @EnableDiscoveryClient
 @EnableFeignClients
 @EnableCircuitBreaker
 public class BillServiceApplication {
 
     public static void main(String[] args) {
         SpringApplication.run(BillServiceApplication.class, args);
     }
 
 }
 UserServiceCli.java
 package com.luffy.bill.interfaces;
 
 import com.luffy.bill.entity.User;
 import org.springframework.cloud.openfeign.FeignClient;
 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.PathVariable;
 
 @FeignClient(name="user-service", fallback = UserServiceFallbackImpl.class)
 public interface UserServiceCli {
 
     @GetMapping("/user")
     public String getUserService();
 
     @GetMapping("/user/{id}")
     public User getUserInfo(@PathVariable("id") int id);
 }
 UserServiceFallbackImpl.java
 package com.luffy.billservice.interfaces;
 
 import com.luffy.billservice.entity.User;
 import org.springframework.stereotype.Component;
 
 @Component("fallback")
 public class UserServiceFallbackImpl implements UserServiceCli{
 
     @Override
     public String getUserService() {
         return "fallback user service";
     }
 
     @Override
     public User getUserInfo(int id) {
         User user = new User();
         user.setId(1);
         user.setName("feign-fallback");
         return user;
     }
 }
```

<font style="color:rgb(52, 73, 94);">停止user-service测试熔断及fallback。</font>

###### <font style="color:rgb(119, 119, 119);">Hystrix Dashboard</font>

<font style="color:rgb(52, 73, 94);">前面一章，我们讲解了如何整合</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix</font><font style="color:rgb(52, 73, 94);">。而在实际情况下，使用了</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix</font><font style="color:rgb(52, 73, 94);">的同时,还会对其进行实时的数据监控，反馈各类指标数据。今天我们就将讲解下</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix Dashboard</font><font style="color:rgb(52, 73, 94);">和</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Turbine</font><font style="color:rgb(52, 73, 94);">.其中</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix Dashboard</font><font style="color:rgb(52, 73, 94);">是一款针对</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix</font><font style="color:rgb(52, 73, 94);">进行实时监控的工具，通过</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix Dashboard</font><font style="color:rgb(52, 73, 94);">我们可以在直观地看到各</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix Command</font><font style="color:rgb(52, 73, 94);">的</font>**<font style="color:rgb(52, 73, 94);">请求响应时间</font>**<font style="color:rgb(52, 73, 94);">, </font>**<font style="color:rgb(52, 73, 94);">请求成功率</font>**<font style="color:rgb(52, 73, 94);">等数据,监控单个实例内的指标情况。后者</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Turbine</font><font style="color:rgb(52, 73, 94);">，能够将多个实例指标数据进行聚合的工具。</font>

<font style="color:rgb(52, 73, 94);">在eureka注册中心处访问</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">bill-service</font><font style="color:rgb(52, 73, 94);">的服务</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">actuator</font><font style="color:rgb(52, 73, 94);">地址: </font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http://192.168.136.1:7001/actuator/info</font>

<font style="color:rgb(52, 73, 94);">若访问不了,需要添加如下内容:</font>

* <font style="color:rgb(52, 73, 94);">为服务消费者bill-service的pom.xml添加依赖:</font>
* <font style="color:rgb(52, 73, 94);">修改application.yml配置:</font>

```plain
<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
```

```plain
management:
  endpoints:
    web:
      exposure:
        include: "*"
```

<font style="color:rgb(52, 73, 94);">访问</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http://localhost:9000/actuator/hystrix.stream</font><font style="color:rgb(52, 73, 94);"> 即可访问到断路器的执行状态，但是显示不太友好，因此需要dashboard。</font>

<font style="color:rgb(52, 73, 94);">新建项目，hystrix-dashboard</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix-dashboard(仪表盘)</font><font style="color:rgb(119, 119, 119);">是一款针对Hystrix进行实时监控的工具，通过</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix Dashboard</font><font style="color:rgb(119, 119, 119);">我们可以在直观地看到各</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Hystrix Command</font><font style="color:rgb(119, 119, 119);">的请求响应时间, 请求成功率等数据。</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">pom.xml</font><font style="color:rgb(52, 73, 94);">引入依赖包：</font>

```plain
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.6.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.luffy</groupId>
    <artifactId>hystrix-dashboard</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>hystrix-dashboard</name>
    <description>hystrxi dashboard</description>

    <properties>
        <java.version>1.8</java.version>
        <spring.cloud-version>Hoxton.SR9</spring.cloud-version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-hystrix-dashboard</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
            <exclusions>
                <exclusion>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring.cloud-version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

<font style="color:rgb(52, 73, 94);">启动类加上</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">@EnableHystrixDashboard</font><font style="color:rgb(52, 73, 94);">注解：</font>

```plain
package com.luffy.hystrixdashboard;
 
 import org.springframework.boot.SpringApplication;
 import org.springframework.boot.autoconfigure.SpringBootApplication;
 import org.springframework.cloud.netflix.hystrix.dashboard.EnableHystrixDashboard;
 
 @SpringBootApplication
 @EnableHystrixDashboard
 public class HystrixDashboardApplication {
 
     public static void main(String[] args) {
         SpringApplication.run(HystrixDashboardApplication.class, args);
     }
 
 }
```

<font style="color:rgb(52, 73, 94);">application.yml</font>

```plain
#应用名称
 server:
   port: 9696
 
 spring:
   application:
     name: hystrix-dashboard
 hystrix:
   dashboard:
     proxy-stream-allow-list: "*"
```

<font style="color:rgb(52, 73, 94);">访问</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">localhost:9696/hystrix</font>

* <font style="color:rgb(52, 73, 94);">实心圆：它有颜色和大小之分，分别代表实例的监控程度和流量大小。如上图所示，它的健康度从绿色、黄色、橙色、红色递减。通过该实心圆的展示，我们就可以在大量的实例中快速的发现故障实例和高压力实例。</font>
* <font style="color:rgb(52, 73, 94);">曲线：用来记录 2 分钟内流量的相对变化，我们可以通过它来观察到流量的上升和下降趋势。</font>
* <font style="color:rgb(52, 73, 94);">其他一些数量指标如下图所示</font>

<!-- OCR_START -->
- - 成功数
- - 2
- - 超时数
- - 短路/熔断数
- - 线程池拒绝数
- - 失败/异常数
- - helloKey
- - 最近10秒的
- - 4
- - 80.0 %
- - 错误比例
- - Host:0.5/s
- - 请求频率
- - Cluster:0.5/s
- - CircuitClosed
- - 断路器状态
- - 集群下的
- - Hosts
- - 1
- - 90th2002ms
- - Median1217ms
- - 99th2003ms
- - 百分位延迟统计
- - 主机报告
- - Mean1262ms99.5th2003ms
<!-- OCR_END -->

<font style="color:rgb(119, 119, 119);">提交代码到gitlab仓库</font>

###### <font style="color:rgb(119, 119, 119);">Turbine</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">hystrix</font><font style="color:rgb(52, 73, 94);">只能实现单个微服务的监控，可是一般项目中是微服务是以集群的形式搭建，一个一个的监控不现实。而</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">Turbine</font><font style="color:rgb(52, 73, 94);">的原理是，</font>**<font style="color:rgb(52, 73, 94);">建立一个</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">turbine</font>****<font style="color:rgb(52, 73, 94);">服务，并注册到</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">eureka</font>****<font style="color:rgb(52, 73, 94);">中，并发现</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">eureka</font>****<font style="color:rgb(52, 73, 94);">上的</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">hystrix</font>****<font style="color:rgb(52, 73, 94);">服务。通过配置</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">turbine</font>****<font style="color:rgb(52, 73, 94);">会自动收集所需</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">hystrix</font>****<font style="color:rgb(52, 73, 94);">的监控信息，最后通过</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">dashboard</font>****<font style="color:rgb(52, 73, 94);">展现，以达到集群监控的效果。</font>**

**<font style="color:rgb(52, 73, 94);">简单来说，就是通过注册到注册中心，发现其他服务的</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">hystrix</font>****<font style="color:rgb(52, 73, 94);">服务，然后进行聚合数据，最后通过自身的端点输出到仪表盘上进行个性化展示。这我们就监控一个</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">turbine</font>****<font style="color:rgb(52, 73, 94);">应用即可，当有新增的应用加入时，我们只需要配置下</font>****<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">turbine</font>****<font style="color:rgb(52, 73, 94);">参数即可。</font>**

##### <font style="color:rgb(52, 73, 94);">微服务网关</font>

###### <font style="color:rgb(119, 119, 119);">为什么需要网关</font>

<font style="color:rgb(52, 73, 94);">在微服务框架中，每个对外服务都是独立部署的，对外的api或者服务地址都不是不尽相同的。对于内部而言，很简单，通过注册中心自动感知即可。但我们大部分情况下，服务都是提供给外部系统进行调用的，不可能同享一个注册中心。同时一般上内部的微服务都是在内网的，和外界是不连通的。而且，就算我们每个微服务对外开放，对于调用者而言，调用不同的服务的地址或者参数也是不尽相同的，这样就会造成消费者客户端的复杂性，同时想想，可能微服务可能是不同的技术栈实现的，有的是</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http</font><font style="color:rgb(52, 73, 94);">、</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">rpc</font><font style="color:rgb(52, 73, 94);">或者</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">websocket</font><font style="color:rgb(52, 73, 94);">等等，也会进一步加大客户端的调用难度。所以，</font>**<font style="color:rgb(52, 73, 94);">一般上都有会有个api网关，根据请求的url不同，路由到不同的服务上去，同时入口统一了，还能进行统一的身份鉴权、日志记录、分流等操作</font>**<font style="color:rgb(52, 73, 94);">。</font>

<!-- OCR_START -->
- - 外部调用方
- - 负载均衡
- - Open$er
- - Open$ervice
- - Eureka Server
- - Servce
- - 服务注册中心
- - Service A
<!-- OCR_END -->

###### <font style="color:rgb(119, 119, 119);">网关的功能</font>

* <font style="color:rgb(52, 73, 94);">减少api请求次数</font>
* <font style="color:rgb(52, 73, 94);">限流</font>
* <font style="color:rgb(52, 73, 94);">缓存</font>
* <font style="color:rgb(52, 73, 94);">统一认证</font>
* <font style="color:rgb(52, 73, 94);">降低微服务的复杂度</font>
* <font style="color:rgb(52, 73, 94);">支持混合通信协议(前端只和api通信，其他的由网关调用)</font>
* <font style="color:rgb(52, 73, 94);">...</font>

<!-- OCR_START -->
- - Browser
- - somepage
- - EurekaServer
- - Zuul
- - SomeFilter
- - ServiceInstanceList
- - Service-1
- - Service-2
- - Service-N
- - some api
<!-- OCR_END -->

###### <font style="color:rgb(119, 119, 119);">Zuul实践</font>

<font style="color:rgb(52, 73, 94);">新建模块，gateway-zuul,(spring cloud)</font>

<font style="color:rgb(52, 73, 94);">pom.xml中需要引入zuul和eureka服务发现的依赖</font>

```plain
<dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
         </dependency>
         <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
         </dependency>
```

<font style="color:rgb(52, 73, 94);">启动类添加注解</font>

```plain
package com.luffy.gateway;
 
 import org.springframework.boot.SpringApplication;
 import org.springframework.boot.autoconfigure.SpringBootApplication;
 import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
 import org.springframework.cloud.netflix.zuul.EnableZuulProxy;
 
 @SpringBootApplication
 @EnableZuulProxy
 @EnableDiscoveryClient
 public class ZuulGatewayApplication {
     public static void main(String[] args) {
         SpringApplication.run(ZuulGatewayApplication.class, args);
     }
 }
```

<font style="color:rgb(52, 73, 94);">配置文件：</font>

```plain
server:
   port: 10000
 
 spring:
   application:
     name: gateway-zuul
 
 eureka:
   client:
     serviceUrl:
       defaultZone: ${EUREKA_SERVER:http://admin:admin@localhost:8761/eureka/}
   instance:
     instance-id: ${eureka.instance.hostname}:${server.port}
     prefer-ip-address: true
     hostname: ${INSTANCE_HOSTNAME:gateway-zuul}
```

<font style="color:rgb(52, 73, 94);">启动后，访问：</font>

<http://localhost:10000/bill-service/bill/user/1>

<http://localhost:10000/user-service/user>

<font style="color:rgb(52, 73, 94);">通过如下方式，配置短路径：</font>

```plain
zuul:
   routes:
     user-service: /users/**
     bill-service:
       path: /bill/**
       service-id: bill-service
 http://localhost:10000/users/user/1
                                                  --->  http://localhost:7000/user/2
 http://localhost:10000/user-service/user/1
 
 
 
 http://localhost:10000/bill/service/user/2 
                                                  --->http://localhost:7001/service/user/2
 http://localhost:10000/bill-service/service/user/2
```

<font style="color:rgb(52, 73, 94);">zuul如何指定对外暴漏api的path，如：</font>

<font style="color:rgb(52, 73, 94);">所有的api都是这样：</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http://zuul-host:zuul-port/apis/</font><font style="color:rgb(52, 73, 94);">，可以添加</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">zuul.prefix：/apis</font>

<font style="color:rgb(52, 73, 94);">配置一下配置文件</font>

```plain
management:
  endpoints:
    web:
      exposure:
        include: "*"
```

<font style="color:rgb(52, 73, 94);">可以访问到zuul的route列表， </font><http://localhost:10000/actuator/routes/><font style="color:rgb(52, 73, 94);"> ，添加details可以访问到详细信息</font>

```plain
{
"/apis/users/**": "user-service",
"/apis/bill/**": "bill-service",
"/apis/bill-service/**": "bill-service",
"/apis/user-service/**": "user-service"
}
```

<font style="color:rgb(119, 119, 119);">提交代码到代码仓库</font>

##### <font style="color:rgb(52, 73, 94);">集中配置中心</font>

<font style="color:rgb(52, 73, 94);">Spring Cloud Config 配置中心提供了一个中心化的外部配置，默认使用git存储配置信息，这样就可以对配置信息进行版本管理。</font>

<!-- OCR_START -->
- 微服务应用
- config-client-1
- 本地文件系统配置仓库
- configure-repo
- 指定配置文件的名称
- config-file1
- config-file2
- config-server
- config-file3
- config-client-2
- 决定使用本地文件系统的仓库
- 还是使用git远程配置仓库
- git远程配置仓库
- config-client-3
- SpringCloud Config结构图
- https://b1og.csdn.net/u011676300
<!-- OCR_END -->

###### <font style="color:rgb(119, 119, 119);">实践</font>

* <font style="color:rgb(52, 73, 94);">创建代码仓库</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">configure-repo</font><font style="color:rgb(52, 73, 94);">，用于集中存储配置文件</font>
* <font style="color:rgb(52, 73, 94);">创建项目</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">config-server</font><font style="color:rgb(52, 73, 94);">，用于接受各项目的连接，提供配置文件读取服务</font>
* <font style="color:rgb(52, 73, 94);">修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">user-service</font><font style="color:rgb(52, 73, 94);">服务，验证通过</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">config-server</font><font style="color:rgb(52, 73, 94);">读取集中配置库中的配置文件</font>

<font style="color:rgb(52, 73, 94);">代码仓库：</font>

* <font style="color:rgb(52, 73, 94);">新建gitlab项目，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">http://gitlab.luffy.com/luffy-spring-cloud/configure-repo.git</font>
* <font style="color:rgb(52, 73, 94);">准备配置文件</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">configs/common-dev.yml</font>
* <font style="color:rgb(52, 73, 94);">提交代码到master分支</font>

```plain
datasource:
   url: jdbc:mysql://mysql-dev:3306/
   driverClassName: com.mysql.jdbc.Driver
   username: xxx
   password: xxxxxx
 luffy: city
```

<font style="color:rgb(52, 73, 94);"> env: test</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">configs/user-service-dev.yml</font>

<font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">configs/common-test.yml</font>

<font style="color:rgb(52, 73, 94);">新建项目，</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">config-server</font>

<font style="color:rgb(52, 73, 94);">修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">pom.xml</font><font style="color:rgb(52, 73, 94);">（springboot和springcloud的版本）</font>

1. <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">springboot</font><font style="color:rgb(52, 73, 94);"> 版本</font><font style="color:rgb(52, 73, 94);"> <version>2.3.6.RELEASE</version></font>
2. <font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">spring-cloud</font><font style="color:rgb(52, 73, 94);"> 版本</font>
3. <font style="color:rgb(52, 73, 94);">添加</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">config-server</font><font style="color:rgb(52, 73, 94);"> 的依赖</font>

```plain
<properties>
         <java.version>1.8</java.version>
         <spring-cloud.version>Hoxton.SR9</spring-cloud.version>
     </properties>
```

```plain
<dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-config-server</artifactId>
         </dependency>
```

<font style="color:rgb(52, 73, 94);">修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">application.yml</font>

```plain
server:
   port: 8088
 
 spring:
   application:
     name: config-server
   profiles:
     active: git
   cloud:
     config:
       server:
         git:
           uri: http://gitlab.luffy.com/luffy-spring-cloud/configure-repo.git
           username: ${GIT_USER:root}
           password: ${GIT_PSW:1qaz2wsx}
           default-label: master
           search-paths: configs
         #native:
         #  searchLocations: classpath:/configs/{profile}
```

<font style="color:rgb(52, 73, 94);">修改启动类，添加注解</font>

```plain
package com.luffy.configserver;
 
 import org.springframework.boot.SpringApplication;
 import org.springframework.boot.autoconfigure.SpringBootApplication;
 import org.springframework.cloud.config.server.EnableConfigServer;
 
 @SpringBootApplication
 @EnableConfigServer
 public class ConfigServerApplication {
 
     public static void main(String[] args) {
         SpringApplication.run(ConfigServerApplication.class, args);
     }
 
 }
```

<font style="color:rgb(52, 73, 94);">启动config-server,访问:</font>

```plain
http://localhost:8088/common/dev
 http://localhost:8088/user-service/dev
```

<font style="color:rgb(52, 73, 94);">修改</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">user-service</font><font style="color:rgb(52, 73, 94);">服务，从</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">config-server</font><font style="color:rgb(52, 73, 94);">读取配置</font>

* <font style="color:rgb(52, 73, 94);">添加使用统一配置中心的依赖：</font>
* <font style="color:rgb(52, 73, 94);">新建</font><font style="color:rgb(233, 105, 0);background-color:rgb(248, 248, 248);">bootstrap.yml</font><font style="color:rgb(52, 73, 94);">，不能放在application.yml中，因为bootstrap的加载早于应用程序bean启动的加载，因此，删掉application.yml，直接使用bootstrap.yml</font><font style="color:rgb(52, 73, 94);">\`</font><font style="color:rgb(52, 73, 94);">\`\`yaml server: port: 7000</font>

```plain
<dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-config</artifactId>
         </dependency>
```

<font style="color:rgb(52, 73, 94);">eureka: client: serviceUrl: defaultZone: ${EUREKA_SERVER:</font><http://admin:admin@localhost:8761/eureka/><font style="color:rgb(52, 73, 94);">} instance: instance-id: ${eureka.instance.hostname}:${server.port} prefer-ip-address: true hostname: ${INSTANCE_HOSTNAME:user-service} spring: application: name: user-service cloud: config: uri: </font>[http://localhost:8088](http://localhost:8088/)<font style="color:rgb(52, 73, 94);"> profile: dev #当前读取dev环境的配置 name: user-service, common # 从user-service-dev.yml,common-dev.yml中读取</font>

````plain
- 新建`ValueController.java`
 
   ```java
   package com.luffy.userservice.controller;
 
   import org.springframework.beans.factory.annotation.Value;
   import org.springframework.cloud.context.config.annotation.RefreshScope;
   import org.springframework.web.bind.annotation.GetMapping;
   import org.springframework.web.bind.annotation.RestController;
 
   @RestController
   public class ValueController {
 
       @Value("${env}")
       private String env;
 
       @Value("${datasource.url}")
       private String datasource;
 
       @Value("${spring.application.name}")
       private String applicationName;
 
       @GetMapping("/value/env")
       public String getValueEnv(){
           return "current env is " + env;
       }
 
       @GetMapping("/value/application")
       public String getValueApplication(){
           return "current env is " + applicationName;
       }
 
       @GetMapping("/value/datasource")
       public Object getDatasource(){
           return datasource;
       }
 
   }
````

* 访问如下页面进行验证

```plain
$ localhost:7000/value/env
 $ localhost:7000/value/application
 $ localhost:7000/value/datasource
```

###### 高可用

config-server多个实例，如何配置客户端？

* config-server 作为服务提供者，注册到eureka服务注册中心
* user-service配置从注册中心获取config-server的服务

config-server注册到服务注册中心

* pom.xml添加eureka依赖包
* application.yml中连接服务注册中心
* 启动类添加注解 @EnableDiscoveryClient

```plain
<dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
         </dependency>
```

```plain
eureka:
   client:
     serviceUrl:
       defaultZone: ${EUREKA_SERVER:http://admin:admin@localhost:8761/eureka/}
   instance:
     instance-id: ${eureka.instance.hostname}:${server.port}
     prefer-ip-address: true
     hostname: ${INSTANCE_HOSTNAME:config-server}
```

修改user-service，从注册中心发现服务

* 修改bootstrap.yml

```plain
server:
   port: 7000
 
 spring:
   cloud:
     config:
       profile: dev
       discovery:
         enabled: true
         service-id: config-server
       name: user-service, common
 
 eureka:
   client:
     serviceUrl:
       defaultZone: ${EUREKA_SERVER:http://admin:admin@peer1:8761/eureka/}
   instance:
     instance-id: ${eureka.instance.hostname}:${server.port}
     prefer-ip-address: true
     hostname: ${INSTANCE_HOSTNAME:user-service}
```

###### 客户端配置刷新

配置中心的配置变动后，客户端如何获取最新的配置。

* 修改ValueController.java，添加注解
* 添加actuator包
* 开放显示所有管理接口
* 重启user-service
* 修改configure-repo中的配置并提交，访问http://localhost:7000/value/env
* 执行刷新 $ curl -XPOST http://localhost:7000/actuator/refresh
* 再次访问http://localhost:7000/value/env

```plain
@RestController
 @RefreshScope
 public class ValueController
```

```plain
<dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-actuator</artifactId>
         </dependency>
```

```plain
management:
   endpoints:
     web:
       exposure:
         include: "*"
```

##### 调用链路追踪

###### 介绍

服务追踪的追踪单元是从客户发起请求（request）抵达被追踪系统的边界开始，到被追踪系统向客户返回响应（response）为止的过程，称为一个 trace。每个 trace 中会调用若干个服务，为了记录调用了哪些服务，以及每次调用的消耗时间等信息，在每次调用服务时，埋入一个调用记录，称为一个 span。这样，若干个有序的 span 就组成了一个 trace。在系统向外界提供服务的过程中，会不断地有请求和响应发生，也就会不断生成 trace，把这些带有 span 的 trace 记录下来，就可以描绘出一幅系统的服务拓扑图。附带上 span 中的响应时间，以及请求成功与否等信息，就可以在发生问题的时候，找到异常的服务；根据历史数据，还可以从系统整体层面分析出哪里性能差，定位性能优化的目标。

<!-- OCR_START -->
- (user)
- Replyx
- Requestx
- (Frontend)
- rpc1
- rpc2
- (Middle Tier)
- rpc4
- rpc3
- (Backend)
<!-- OCR_END -->

Spring Cloud Sleuth 为服务之间调用提供链路追踪。通过 Sleuth 可以很清楚的了解到一个服务请求经过了哪些服务，每个服务处理花费了多长。从而让我们可以很方便的理清各微服务间的调用关系。此外 Sleuth 可以帮助我们：

* 耗时分析: 通过 Sleuth 可以很方便的了解到每个采样请求的耗时，从而分析出哪些服务调用比较耗时;
* 链路优化: 对于调用比较频繁的服务，可以针对这些服务实施一些优化措施。
* 可视化错误: 对于程序未捕捉的异常，可以通过集成 Zipkin 服务界面上看到; Spring Cloud Sleuth 可以结合 Zipkin，将信息发送到 Zipkin，利用 Zipkin 的存储来存储信息，利用 Zipkin UI 来展示数据。<https://zipkin.io/pages/quickstart>

###### 启动zipkin

```plain
apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: zipkin
   namespace: dev
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: zipkin
   template:
     metadata:
       labels:
         app: zipkin
     spec:
       containers:
         - name: zipkin
           image: openzipkin/zipkin:2.22
           imagePullPolicy: IfNotPresent
           ports:
             - containerPort: 9411
           resources:
             requests:
               memory: 400Mi
               cpu: 50m
             limits:
               memory: 2Gi
               cpu: 2000m
 ---
 apiVersion: v1
 kind: Service
 metadata:
   name: zipkin
   namespace: dev
 spec:
   ports:
     - port: 9411
       protocol: TCP
       targetPort: 9411
   selector:
     app: zipkin
   sessionAffinity: None
   type: ClusterIP
 status:
   loadBalancer: {}
 ---
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: zipkin
   namespace: dev
 spec:
   rules:
     - host: zipkin.luffy.com
       http:
         paths:
           - backend:
               serviceName: zipkin
               servicePort: 9411
             path: /
 status:
   loadBalancer: {}
```

###### 实践

分别对bill-service和user-service进行改造：

pom.xml中添加：

```plain
<dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-zipkin</artifactId>
         </dependency>
```

application.yml

```plain
spring:
   zipkin:
     base-url: http://zipkin.luffy.com  # zipkin服务器的地址
     sender:
       type: web  # 设置使用http的方式传输数据
   sleuth:
     sampler:
       probability: 1  # 设置抽样采集为100%，默认为0.1，即10%
 logging:
   level:
     org.springframework.cloud: debug
```

访问zuul网关的接口http://localhost:10000/apis/bill-service/bill/user/2

2020-11-14 19:28:49.274 DEBUG \[bill-service,949aa3570daa1031,43ea952f1e5e36eb,true] 36852 --- \[-user-service-6] c.s.i.w.c.f.TraceLoadBalancerFeignClient : Before send

 bill-service,949aa3570daa1031,43ea952f1e5e36eb,true

说明：

* bill-service： 服务名称
* 949aa3570daa1031： 是TranceId，一条链路中，只有一个TranceId
* 43ea952f1e5e36eb：则是spanId，链路中的基本工作单元id
* true：表示是否将数据输出到其他服务，true则会把信息输出到其他可视化的服务上观察

##### SpringBoot Admin监控

新建项目，springboot-admin

```plain
pom.xml
 <?xml version="1.0" encoding="UTF-8"?>
 <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
     <modelVersion>4.0.0</modelVersion>
     <parent>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-starter-parent</artifactId>
         <version>2.3.6.RELEASE</version>
         <relativePath/> <!-- lookup parent from repository -->
     </parent>
     <groupId>com.luffy</groupId>
     <artifactId>springboot-admin</artifactId>
     <version>0.0.1-SNAPSHOT</version>
     <name>springboot-admin</name>
     <description>Demo project for Spring Boot</description>
 
     <properties>
         <java.version>1.8</java.version>
         <spring-cloud.version>Hoxton.SR9</spring-cloud.version>
     </properties>
 
     <dependencies>
         <dependency>
             <groupId>de.codecentric</groupId>
             <artifactId>spring-boot-admin-starter-server</artifactId>
             <version>2.2.1</version>
         </dependency>
         <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
         </dependency>
 
         <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter</artifactId>
         </dependency>
 
         <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-test</artifactId>
             <scope>test</scope>
             <exclusions>
                 <exclusion>
                     <groupId>org.junit.vintage</groupId>
                     <artifactId>junit-vintage-engine</artifactId>
                 </exclusion>
             </exclusions>
         </dependency>
     </dependencies>
 
     <dependencyManagement>
         <dependencies>
             <dependency>
                 <groupId>org.springframework.cloud</groupId>
                 <artifactId>spring-cloud-dependencies</artifactId>
                 <version>${spring-cloud.version}</version>
                 <type>pom</type>
                 <scope>import</scope>
             </dependency>
         </dependencies>
     </dependencyManagement>
 
     <build>
         <plugins>
             <plugin>
                 <groupId>org.springframework.boot</groupId>
                 <artifactId>spring-boot-maven-plugin</artifactId>
             </plugin>
         </plugins>
     </build>
 
 </project>
```

配置文件

```plain
server:
   port: 8769
 
 spring:
   application:
     name: springboot-admin
 
 eureka:
   client:
     serviceUrl:
       defaultZone: ${EUREKA_SERVER:http://admin:admin@localhost:8761/eureka/}
   instance:
     instance-id: ${eureka.instance.hostname}:${server.port}
     prefer-ip-address: true
     hostname: ${INSTANCE_HOSTNAME:springboot-admin}
```

启动类

```plain
package com.luffy.springbootadmin;
 
 import de.codecentric.boot.admin.server.config.EnableAdminServer;
 import org.springframework.boot.SpringApplication;
 import org.springframework.boot.autoconfigure.SpringBootApplication;
 import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
 
 @SpringBootApplication
 @EnableDiscoveryClient
 @EnableAdminServer
 public class SpringbootAdminApplication {
 
     public static void main(String[] args) {
         SpringApplication.run(SpringbootAdminApplication.class, args);
     }
 
 }
```

客户端，所有注册到eureka的服务，添加依赖即可

```plain
<dependency>
             <groupId>de.codecentric</groupId>
             <artifactId>spring-boot-admin-starter-client</artifactId>
             <version>2.2.1</version>
         </dependency>
```

#### 小结

1. 伴随着业务场景复杂度的提高，单体架构应用弊端显现，微服务的思想逐步盛行，微服务架构带来诸多便捷的同时，也带来了很多问题，最主要的是多个微服务的服务治理（服务发现、调用、负载均衡、跟踪）
2. 为了解决服务治理问题，出现了微服务框架（Dubbo、Spring Cloud等）
3. Spring Cloud是一个大的生态，基于Java语言封装了一系列的工具，方便业务直接使用来解决上述服务治理相关的问题
4. Spring Cloud Netflix 体系下提供了eureka、ribbon、feign、hystrix、zuul等工具结合spring cloud sleuth合zipkin实现服务跟踪
5. SpringBoot是微服务的开发框架，通过maven与Spring Cloud生态中的组件集成，极大方便了java应用程序的交付

<!-- OCR_START -->
- hystrix异常处理
- 服务0
- ribbon
- 服务a
- 数据库
- zul
- server
- request
- 服务B
- 服务注册获取config服务
- 服务注册+获取服务地址
- eureka-server
- 从git仓库获取配置文件
- 服务注册
- config-server
- git仓库
<!-- OCR_END -->

<https://blog.csdn.net/smallsunl/article/details/78778790>

问题：

1. 无论是Dubbo还是SpringCloud，均属于Java语言体系下的产物，跨语言没法共用，同时，通过走了一遍内部集成的过程，可以清楚的发现，服务治理过程中，各模块的集成，均需要对原始业务逻辑形成侵入。
2. 在kubernetes的生态下，已经与生俱来带了很多好用的功能（自动服务发现与负载均衡）
3. 服务治理的根本其实是网络节点通信的治理，因此，以istio为代表的第二代服务治理平台开始逐步兴起

# 08_基于Istio实现微服务治理

微服务架构可谓是当前软件开发领域的技术热点，它在各种博客、社交媒体和会议演讲上的出镜率非常之高，无论是做基础架构还是做业务系统的工程师，对微服务都相当关注，而这个现象与热度到目前为止，已经持续了近 5 年之久。

尤其是近些年来，微服务架构逐渐发展成熟，从最初的星星之火到现在的大规模的落地与实践，几乎已经成为分布式环境下的首选架构。微服务成为时下技术热点，大量互联网公司都在做微服务架构的落地和推广。同时，也有很多传统企业基于微服务和容器，在做互联网技术转型。

而在这个技术转型中，国内有一个趋势，以 Spring Cloud 与 Dubbo 为代表的微服务开发框架非常普及和受欢迎。然而软件开发没有银弹，基于这些传统微服务框架构建的应用系统在享受其优势的同时，痛点也越加明显。这些痛点包括但不限于以下几点：

* **侵入性强**。想要集成 SDK 的能力，除了需要添加相关依赖，往往还需要在业务代码中增加一部分的代码、或注解、或配置；业务代码与治理层代码界限不清晰。
* **升级成本高**。每次升级都需要业务应用修改 SDK 版本，重新进行功能回归测试，并且对每一台机器进行部署上线，而这对于业务方来说，与业务的快速迭代开发是有冲突的，大多不愿意停下来做这些与业务目标不太相关的事情。
* **版本碎片化严重**。由于升级成本高，而中间件却不会停止向前发展的步伐，久而久之，就会导致线上不同服务引用的 SDK 版本不统一、能力参差不齐，造成很难统一治理。
* **中间件演变困难**。由于版本碎片化严重，导致中间件向前演进的过程中就需要在代码中兼容各种各样的老版本逻辑，带着 “枷锁” 前行，无法实现快速迭代。
* **内容多、门槛高**。Spring Cloud 被称为微服务治理的全家桶，包含大大小小几十个组件，内容相当之多，往往需要几年时间去熟悉其中的关键组件。而要想使用 Spring Cloud 作为完整的治理框架，则需要深入了解其中原理与实现，否则遇到问题还是很难定位。
* **治理功能不全**。不同于 RPC 框架，Spring Cloud 作为治理全家桶的典型，也不是万能的，诸如协议转换支持、多重授权机制、动态请求路由、故障注入、灰度发布等高级功能并没有覆盖到。而这些功能往往是企业大规模落地不可获缺的功能，因此公司往往还需要投入其它人力进行相关功能的自研或者调研其它组件作为补充。

#### Service Mesh 服务网格

##### 架构和概念

目的是解决系统架构微服务化后的服务间通信和治理问题。设计初衷是提供一种通用的服务治理方案。

<!-- OCR_START -->
- Service
- (client)
- 业务逻辑
- Sidecar
- 服务发现
- 负载均衡
- 熔断限流
- 服务路由
- +++
<!-- OCR_END -->

Sidecar 在软件系统架构中特指边车模式。这个模式的灵感来源于我们生活中的边三轮：即在两轮摩托车的旁边添加一个边车的方式扩展现有的服务和功能。

这个模式的精髓在于实现了数据面（业务逻辑）和控制面的解耦：原来两轮摩托车的驾驶者集中注意力跑赛道，边车上的领航员专注周围信息和地图，专注导航。

<!-- OCR_START -->
- 该sidecar proxy负责接管对应服务的入流量和出流量。并将微服务架构中以前有公共库.
- framework实现的熔断、限流、降级、服务发现、调用链分布式跟踪以及立体监控等功能从服务中
- 抽离到该proxy 中：
- 外部调用
- 服务访问
- Sidecar
- 服务注册
- 健康检查
- 服务发现
- 服务控制
- 流控熔断
- 系统
- 日志监视
- 协议适配
- 服务监视
- ......
- （日志、性能、跟踪）
- 应用服务
- 当该sidecar在微服务中大量部署时，这些sidecar节点自然就形成了一个网格：
- .net/xinyuan_java
<!-- OCR_END -->

Service Mesh 这个服务网络专注于处理服务和服务间的通讯。其主要负责构造一个稳定可靠的服务通讯的基础设施，并让整个架构更为的先进和 Cloud Native。在工程中，Service Mesh 基本来说是一组轻量级的与应用逻辑服务部署在一起的服务代理，并且对于应用服务是透明的。

##### 开源实现

###### 第一代服务网格 Linkerd和Envoy

Linkerd 使用Scala编写，是业界第一个开源的service mesh方案。作者 William Morgan 是 service mesh 的布道师和践行者。Envoy 基于C++ 11编写，无论是理论上还是实际上，后者性能都比 Linkderd 更好。这两个开源实现都是以 sidecar 为核心，绝大部分关注点都是如何做好proxy，并完成一些通用控制面的功能。 但是，当你在容器中大量部署 sidecar 以后，如何管理和控制这些 sidecar 本身就是一个不小的挑战。于是，第二代 Service Mesh 应运而生。

###### 第二代服务网格 Istio

Istio 是 Google 和 IBM 两位巨人联合 Lyft 的合作开源项目。是当前最主流的service mesh方案，也是事实上的第二代 service mesh 标准。

<!-- OCR_START -->
- Istio Mesh
- Service A
- Service B
- 数据平面
- 入口流量
- 1出口流量
- Proxy
- Mesh流量
- 服务发现、配置分发、证书配置
- 1
- 控制平面
- istiod
- Pilot
- Citadel
- Galley
<!-- OCR_END -->

#### 安装Istio

<https://istio.io/latest/docs/setup/getting-started/>

###### 下载 Istio

下载内容将包含：安装文件、示例和 [istioctl](https://istio.io/latest/zh/docs/reference/commands/istioctl/) 命令行工具。

1. 访问 [Istio release](https://github.com/istio/istio/releases/tag/1.7.3) 页面下载与您操作系统对应的安装文件。在 macOS 或 Linux 系统中，也可以通过以下命令下载最新版本的 Istio： $ wget https://github.com/istio/istio/releases/download/1.7.3/istio-1.7.3-linux-amd64.tar.gz
2. 解压并切换到 Istio 包所在目录下。例如：Istio 包名为 istio-1.7.3，则：
3. 将 istioctl 客户端拷贝到 path 环境变量中 $ cp bin/istioctl /bin/
4. 配置命令自动补全istioctl 自动补全的文件位于 tools 目录。通过复制 istioctl.bash 文件到您的 home 目录，然后添加下行内容到您的 .bashrc 文件执行 istioctl tab 补全文件：

```plain
$ tar zxf istio-1.7.3-linux-amd64.tar.gz
 $ ll istio-1.7.3
 drwxr-x---  2 root root    22 Sep 27 08:33 bin
 -rw-r--r--  1 root root 11348 Sep 27 08:33 LICENSE
 drwxr-xr-x  6 root root    66 Sep 27 08:33 manifests
 -rw-r-----  1 root root   756 Sep 27 08:33 manifest.yaml
 -rw-r--r--  1 root root  5756 Sep 27 08:33 README.md
 drwxr-xr-x 20 root root   330 Sep 27 08:33 samples
 drwxr-x---  3 root root   133 Sep 27 08:33 tools
```

```plain
$ cp tools/istioctl.bash ~
 $ source ~/istioctl.bash
```

###### 安装istio组件

<https://istio.io/latest/zh/docs/setup/install/istioctl/#display-the-configuration-of-a-profile>

使用istioctl直接安装：

```plain
$ istioctl install --set profile=demo
 ✔ Istio core installed
 ✔ Istiod installed
 ✔ Egress gateways installed
 ✔ Ingress gateways installed
 ✔ Installation complete
 
 $ kubectl -n istio-system get po
 NAME                                    READY   STATUS    RESTARTS   AGE
 istio-egressgateway-7bf76dd59-n9t5l     1/1     Running   0          77s
 istio-ingressgateway-586dbbc45d-xphjb   1/1     Running   0          77s
 istiod-6cc5758d8c-pz28m                 1/1     Running   0          84s
```

istio针对不同的环境，提供了几种不同的初始化部署的[profile](https://istio.io/latest/docs/setup/additional-setup/config-profiles/)

```plain
# 查看提供的profile类型
 $ istioctl profile list
 
 # 获取kubernetes的yaml：
 $ istioctl manifest generate --set profile=demo > istio-kubernetes-manifest.yaml
```

###### 卸载

 $ istioctl manifest generate --set profile=demo | kubectl delete -f -

#### 快速入门

##### 场景一

###### 模型图

<!-- OCR_START -->
- 前端UI
- 账单服务
- 账单Service
- Pod
- 前端UIv1版本
- Deployment
- 账单v1版本
<!-- OCR_END -->

###### 资源清单

```plain
front-tomcat-dpl-v1.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   labels:
     app: front-tomcat
     version: v1
   name: front-tomcat-v1
   namespace: istio-demo
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: front-tomcat
       version: v1
   template:
     metadata:
       labels:
         app: front-tomcat
         version: v1
     spec:
       containers:
       - image: consol/tomcat-7.0:latest
         name: front-tomcat
 bill-service-dpl-v1.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   labels:
     service: bill-service
     version: v1
   name: bill-service-v1
   namespace: istio-demo
 spec:
   replicas: 1
   selector:
     matchLabels:
       service: bill-service
       version: v1
   template:
     metadata:
       labels:
         service: bill-service
         version: v1
     spec:
       containers:
       - image: nginx:alpine
         name: bill-service
         command: ["/bin/sh", "-c", "echo 'this is bill-service-v1'>/usr/share/nginx/html/index.html;nginx -g 'daemon off;'"]
 bill-service-svc.yaml
 apiVersion: v1
 kind: Service
 metadata:
   labels:
     service: bill-service
   name: bill-service
   namespace: istio-demo
 spec:
   ports:
   - name: http
     port: 9999
     protocol: TCP
     targetPort: 80
   selector:
     service: bill-service
   type: ClusterIP
```

###### 操作

```plain
$ kubectl create namespace istio-demo
 $ kubectl apply -f front-tomcat-dpl-v1.yaml
 $ kubectl apply -f bill-service-dpl-v1.yaml
 $ kubectl apply -f bill-service-svc.yaml
 
 $ kubectl -n istio-demo exec front-tomcat-v1-548b46d488-r7wv8 -- curl -s bill-service
 this is bill-service-v1
```

##### 场景二

后台账单服务更新v2版本，前期规划90%的流量访问v1版本，导入10%的流量到v2版本

###### 模型图

<!-- OCR_START -->
| 占比 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- |
| 账单服务 | 账单v1版本 | pod | Deployment |
| 90% | 前端UI | Pod | 账单Service |
| 10% | 账单服务 | 账单v2版本 | pod |
<!-- OCR_END -->

###### 资源清单

新增bill-service-dpl-v2.yaml

```plain
apiVersion: apps/v1
 kind: Deployment
 metadata:
   labels:
     service: bill-service
     version: v2
   name: bill-service-v2
   namespace: istio-demo
 spec:
   replicas: 1
   selector:
     matchLabels:
       service: bill-service
       version: v2
   template:
     metadata:
       labels:
         service: bill-service
         version: v2
     spec:
       containers:
       - image: nginx:alpine
         name: bill-service
         command: ["/bin/sh", "-c", "echo 'hello, this is bill-service-v2'>/usr/share/nginx/html/index.html;nginx -g 'daemon off;'"]
```

此时，访问规则会按照v1和v2的pod各50%的流量分配。

```plain
$ kubectl apply -f bill-service-dpl-v2.yaml
 $ kubectl -n istio-demo exec front-tomcat-v1-548b46d488-r7wv8 --  curl -s bill-service:9999
```

<!-- OCR_START -->
| 占比 | 名称 | 名称 | 名称 |
| --- | --- | --- | --- |
| 账单服务 | 账单v1版本 | pod | Deployment |
| 50% | 前端UI | Pod | 账单Service |
| 50% | 账单服务 | 账单v2版本 | pod |
<!-- OCR_END -->

###### 使用Istio

注入：

```plain
$ istioctl kube-inject -f bill-service-dpl-v1.yaml|kubectl apply -f -
 $ istioctl kube-inject -f bill-service-dpl-v2.yaml|kubectl apply -f -
 $ istioctl kube-inject -f front-tomcat-dpl-v1.yaml|kubectl apply -f -
```

若想实现上述需求，需要解决如下两个问题：

* 让访问账单服务的流量按照我们期望的比例，其实是一条路由规则，如何定义这个规则
* 如何区分两个版本的服务

两个新的资源类型：VirtualService和DestinationRule

```plain
bill-service-destnation-rule.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: DestinationRule
 metadata:
   name: dest-bill-service
   namespace: istio-demo
 spec:
   host: bill-service
   subsets:
   - name: v1
     labels:
       version: v1
   - name: v2
     labels:
       version: v2
 bill-service-virtualservice.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: vs-bill-service
   namespace: istio-demo
 spec:
   hosts:
   - bill-service
   http:
   - name: bill-service-route
     route:
     - destination:
         host: bill-service
         subset: v1
       weight: 90
     - destination:
         host: bill-service
         subset: v2
       weight: 10
```

使用client验证流量分配是否生效。

```plain
$ kubectl apply -f bill-service-virtualservice.yaml
 $ kubectl apply -f bill-service-destnation-rule.yaml
 $ kubectl -n istio-demo exec front-tomcat-v1-78cf497978-ltxpf -c front-tomcat -- curl -s bill-service
```

##### 服务网格细节剖析

执行的操作：

* 使用istioctl为pod注入了sidecar
* 创建了virtualservice和destinationrule

如何最终影响到了pod的访问行为？

###### 宏观角度

nginx的配置中，可以提供类似如下的配置片段实现按照权重的转发：

<!-- OCR_START -->
- 33
- #gzip
- on;
- 4
- upstream backserver {
- 35
- server 127.0.0.1:8080
- weight=2;
- weight=2 设置权重 设置2:1以后 如果有丰次请求，前两次请求
- 36
- server 127.0.0.1:8081 weight=1;
- 会将请求转发给8080端口，一个请求转发结8081
- 7
- 38
- 9
- server {
- listen
- 80;
- 1
- server name
- www.jiahou.com;
- 2
- 3
- #charset koi8-r;
- 5
- #access_
- : 1og
- logs/host.access.log
- main;
- 6
- location / {
- 18
- proxy_pass
- http: //backserver:
- index
- index.html index.htm;
- 50
<!-- OCR_END -->

因为nginx是代理层，可以转发请求，istio也实现了流量转发的效果，肯定也有代理层，并且识别了前面创建的虚拟服务中定义的规则。

 $ istioctl kube-inject -f front-tomcat-dpl-v1.yaml

可以看到注入后yaml中增加了很多内容：

<!-- OCR_START -->
- 初始化容器，负
- 启动了两个进
- 责初始化pod的
- 程：piolot-
- iptables规则
- agent和envoy
- 执行完成后退出
- infra
- front-tomcat
- 主容器
- 容器
- istio-init
- istio-proxy
- front-tomcat-pod
<!-- OCR_END -->

pod被istio注入后，被纳入到服务网格中，每个pod都会添加一个名为istio-proxy的容器（常说的sidecar容器），istio-proxy容器中有两个进程，一个是piolot-agent，一个是envoy

<!-- OCR_START -->
- Kubernnetes集群
- kubectl create
- APIServer
- ETCD
- vs.yaml
- istiod
- 控制平面
- bill-service
- 容器
- infra
- 同步规则
- pilot-agent
- envoy
- 90%
- client容器
- 10%
<!-- OCR_END -->

```plain
$ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c istio-proxy bash
 # ps aux
```

目前已知：

* 在istio网格内，每个Pod都会被注入一个envoy代理
* envoy充当nginx的角色，做为proxy代理，负责接管pod的入口和出口流量

目前，还需要搞清楚几个问题：

* istio-init初始化容器作用是什么？
* istio-proxy如何接管业务服务的出入口流量？

###### 认识envoy

Envoy 是为云原生应用设计的代理。

可以和nginx做类比： <https://fuckcloudnative.io/posts/migrating-from-nginx-to-envoy/>

```plain
$ docker run -d --name envoy -v `pwd`/envoy.yaml:/etc/envoy/envoy.yaml -p 10000:10000 envoyproxy/envoy-alpine:v1.15.2
 
 $ curl localhost:10000
 envoy.yaml
 admin:
   access_log_path: /tmp/admin_access.log
   address:
     socket_address: { address: 127.0.0.1, port_value: 9901 }
 
 static_resources:
   listeners:
   - name: listener_0
     address:
       socket_address: { address: 0.0.0.0, port_value: 10000 }
     filter_chains:
     - filters:
       - name: envoy.http_connection_manager
         config:
           stat_prefix: ingress_http
           codec_type: AUTO
           route_config:
             name: local_route
             virtual_hosts:
             - name: local_service
               domains: ["*"]
               routes:
               - match: { prefix: "/" }
                 route: { cluster: some_service }
           http_filters:
           - name: envoy.router
   clusters:
   - name: some_service
     connect_timeout: 2s
     type: STATIC
     lb_policy: ROUND_ROBIN
     hosts: [{ socket_address: { address: 10.111.219.247, port_value: 9999 }}]
```

脑补一下网络代理程序的流程，比如作为一个代理，首先要能获取请求流量，通常是采用监听端口的方式实现；其次拿到请求数据后需要对其做微处理，例如附加 Header 或校验某个 Header 字段的内容等，这里针对来源数据的层次不同，可以分为 L3/L4/L7，然后将请求转发出去；转发这里又可以衍生出如果后端是一个集群，需要从中挑选一台机器，如何挑选又涉及到负载均衡等。

* listener : Envoy 的监听地址。Envoy 会暴露一个或多个 Listener 来监听客户端的请求。
* filter : 过滤器。在 Envoy 中指的是一些“可插拔”和可组合的逻辑处理层，是 Envoy 核心逻辑处理单元。
* route_config : 路由规则配置。即将请求路由到后端的哪个集群。
* cluster : 服务提供方集群。Envoy 通过服务发现定位集群成员并获取服务，具体路由到哪个集群成员由负载均衡策略决定。

###### envoy的xDS

Envoy的启动配置文件分为两种方式：静态配置和动态配置。

* 静态配置是将所有信息都放在配置文件中，启动的时候直接加载。
* 动态配置需要提供一个Envoy的服务端，用于动态生成Envoy需要的服务发现接口，这里叫XDS，通过发现服务来动态的调整配置信息，Istio就是实现了v2的API。

Envoy 接收到请求后，会先走 FilterChain，通过各种 L3/L4/L7 Filter 对请求进行微处理，然后再路由到指定的集群，并通过负载均衡获取一个目标地址，最后再转发出去。

其中每一个环节可以静态配置，也可以动态服务发现，也就是所谓的 xDS。这里的 x 是一个代词，类似云计算里的 XaaS 可以指代 IaaS、PaaS、SaaS 等。

所以，envoy的架构大致的样子如下：

<!-- OCR_START -->
- Envoy Proxy Architecture Diagram
- Listener
- Listenr filters
- Network filters
- HTTP connection manager
- HTTP Inspector
- Dubbo proxy
- Buffer
- Listener Filters
- Original Destination
- Mongo proxy
- DynamoDB
- Original Source
- MySQL proxy
- gRPC-JSON transcoder
- Proxy Protocol
- filter_chains
- gRPC-Web
- -TLS Inspector
- Envoy
- Endpoint
- Uptream
- Cluster 0
- Service 0
- Downstream
- Route
- send request
- Cluster 1
- Service 1
- request
- 2
- Client
- receive
- Service 2
- Cluster 2
- XDS
- Virtual Host
- Scoped Route
- Secret
- Runtime
- Aggregated
- Discovery
- Service
- https:// fuckcLoudnative.io
<!-- OCR_END -->

**Downstream**

下游（downstream）主机连接到 Envoy，发送请求并或获得响应。

**Upstream**

上游（upstream）主机获取来自 Envoy 的链接请求和响应。

**监听器**

* 除了过滤器链之外，还有一种过滤器叫**监听器过滤器**（Listener filters），它会在过滤器链之前执行，用于操纵连接的**元数据**。这样做的目的是，无需更改 Envoy 的核心代码就可以方便地集成更多功能。
* 每个监听器都可以配置多个过[滤器链（Filter Chains）](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/listener/v3/listener_components.proto#envoy-v3-api-msg-config-listener-v3-filterchain)，监听器会根据 filter_chain_match 中的[匹配条件](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/listener/v3/listener_components.proto#envoy-v3-api-msg-config-listener-v3-filterchainmatch)将流量转交到对应的过滤器链，其中每一个过滤器链都由一个或多个**网络过滤器**（Network filters）组成。这些过滤器用于执行不同的代理任务，如速率限制，TLS 客户端认证，HTTP 连接管理，MongoDB 嗅探，原始 TCP 代理等。

###### envoy在微服务治理中的工作环境

可以在服务旁运行，以平台无关的方式提供必要的特性，所有到服务的流量都通过 Envoy 代理，这里 Envoy 扮演的就是 Sidecar 的角色。

<!-- OCR_START -->
- Service
- Envoy
<!-- OCR_END -->

针对于k8s的pod来讲：

<!-- OCR_START -->
- Proxy
- docker
- CircuitBreaker
- Rate limiting
- Tracing
- Metrics
- Service A
- ServiceB
- php
- Business logic
- Java
<!-- OCR_END -->

在istio中，envoy的位置：

<!-- OCR_START -->
- Istio Mesh
- Service A
- Service B
- 数据平面
- 入口流量
- 1出口流量
- Proxy
- Mesh流量
- 服务发现、配置分发、证书配置
- 1
- 控制平面
- istiod
- Pilot
- Citadel
- Galley
<!-- OCR_END -->

很明显，istio中，envoy进行流量治理，更多的使用的是XDS进行配置更新，而我们知道，XDS需要有服务端来提供接口，istiod中的pilot组件则提供了xDS服务端接口的实现 。

###### 工作原理

目前为止，我们可以知道大致的工作流程：

* 用户端，通过创建服务治理的规则（VirtualService、DestinationRule等资源类型），存储到ETCD中
* istio控制平面中的Pilot服务监听上述规则，转换成envoy可读的规则配置，通过xDS接口同步给各envoy
* envoy通过xDS获取最新的配置后，动态reload，进而改变流量转发的策略

思考两个问题：

* istio中envoy的动态配置到底长什么样子？
* 在istio的网格内，front-tomcat访问到bill-service，流量的流向是怎么样的？

针对问题1：

每个envoy进程启动的时候，会在127.0.0.1启动监听15000端口

```plain
$ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c istio-proxy bash
 # netstat -nltp
 # curl localhost:15000/help
 # curl localhost:15000/config_dump
```

针对问题2：

```plain
$ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c front-tomcat bash
 # curl bill-service:9999
```

按照之前的认知，

<!-- OCR_START -->
- curl bill-service:9999
- coredns解析出cluster-ip
- route表解析到etho
- 宿主机iptables规则匹配
- iptables转发到pod-ip:port
- 流量转到宿主机
- cluster-ip
<!-- OCR_END -->

现在为什么流量分配由5：5 变成了9：1？流量经过envoy了的处理

<!-- OCR_START -->
- 初始化容器，负
- 启动了两个进
- 责初始化pod的
- 程：piolot-
- iptables规则，
- agent和envoy
- 执行完成后退出
- infra
- istio-proxy
- bill-service
- istio-init
- 90%
- bill-service-v1
- front-tomcat
- 主容器
- 容器
- 10%
- front-tomcat-pod
- bill-service-v2
<!-- OCR_END -->

envoy如何接管由front-tomcat容器发出的请求流量？（istio-init

回顾iptables：

<!-- OCR_START -->
- NETWORKCARD
- PREROUTING
- non-tunneled
- tunneled
- (ipip, gre,
- raw
- sit, ipsec)
- Tablelegend
- connection tracking
- filter
- QOS egress
- mangle
- NAT (IPv4 only!)
- POSTROUTING
- source NAT （*)
- destination NAT (*)
- QOS ingress
- FORWARD
- Routing(**
- INPUT
- (*) for ipv6 tunneled over ipv4,
- the nat table is traversed
- only when the first packet
- of the tunnel goes through.
- And packets going through
- the "lo" interface don't
- traverse the PREROUTING
- destination NAT box.
- (**) The real story is that packats
- are routed before OUTPUT, but
- they are rerouted here if the
- destination changes.
- by
- xkr47@outerspace.dyndns.org
- deepstar@ulyssis.org
- diegows@xtech.com.ar
- 31.10.2002
- (last updated 9.07.2008)
- LOCALPROCESS
<!-- OCR_END -->

Istio 给应用 Pod 注入的配置主要包括：

* Init 容器 istio-initIstio 在 pod 中注入的 Init 容器名为 istio-init，作用是为 pod 设置 iptables 端口转发。我们在上面 Istio 注入完成后的 YAML 文件中看到了该容器的启动命令是： istio-iptables -p 15001 -z 15006 -u 1337 -m REDIRECT -i '*' -x "" -b '*' -d 15090,15021,15020Init 容器的启动入口是 istio-iptables 命令行，该命令行工具的用法如下：

```plain
$ istio-iptables [flags]
   -p: 指定重定向所有 TCP 出站流量的 sidecar 端口（默认为 $ENVOY_PORT = 15001）
   -m: 指定入站连接重定向到 sidecar 的模式，“REDIRECT” 或 “TPROXY”（默认为 $ISTIO_INBOUND_INTERCEPTION_MODE)
   -b: 逗号分隔的入站端口列表，其流量将重定向到 Envoy（可选）。使用通配符 “*” 表示重定向所有端口。为空时表示禁用所有入站重定向（默认为 $ISTIO_INBOUND_PORTS）
   -d: 指定要从重定向到 sidecar 中排除的入站端口列表（可选），以逗号格式分隔。使用通配符“*” 表示重定向所有入站流量（默认为 $ISTIO_LOCAL_EXCLUDE_PORTS）
   -o：逗号分隔的出站端口列表，不包括重定向到 Envoy 的端口。
   -i: 指定重定向到 sidecar 的 IP 地址范围（可选），以逗号分隔的 CIDR 格式列表。使用通配符 “*” 表示重定向所有出站流量。空列表将禁用所有出站重定向（默认为 $ISTIO_SERVICE_CIDR）
   -x: 指定将从重定向中排除的 IP 地址范围，以逗号分隔的 CIDR 格式列表。使用通配符 “*” 表示重定向所有出站流量（默认为 $ISTIO_SERVICE_EXCLUDE_CIDR）。
   -k：逗号分隔的虚拟接口列表，其入站流量（来自虚拟机的）将被视为出站流量。
   -g：指定不应用重定向的用户的 GID。(默认值与 -u param 相同)
   -u：指定不应用重定向的用户的 UID。通常情况下，这是代理容器的 UID（默认值是 1337，即 istio-proxy 的 UID）。
   -z: 所有进入 pod/VM 的 TCP 流量应被重定向到的端口（默认 $INBOUND_CAPTURE_PORT = 15006）。
```

以上传入的参数都会重新组装成 [iptables](https://wangchujiang.com/linux-command/c/iptables.html)规则，关于 Istio 中端口用途请参考 [Istio 官方文档](https://istio.io/latest/docs/ops/deployment/requirements/)。

这条启动命令的作用是：

```
- <font style="color:rgb(52, 73, 94);">将应用容器的所有入站流量都转发到 envoy的 15006 端口（15090 端口（Envoy Prometheus telemetry）和 15020 端口（Ingress Gateway）除外，15021（sidecar健康检查）端口）</font>
- <font style="color:rgb(52, 73, 94);">将所有出站流量都重定向到 sidecar 代理（通过 15001 端口）</font>
- <font style="color:rgb(52, 73, 94);">上述规则对id为1337用户除外，因为1337是istio-proxy自身的流量</font>
```

该容器存在的意义就是让 sidecar 代理可以拦截pod所有的入站（inbound）流量以及出站（outbound）流量，这样就可以实现由sidecar容器来接管流量，进尔实现流量管控。

因为 Init 容器初始化完毕后就会自动终止，因为我们无法登陆到容器中查看 iptables 信息，但是 Init 容器初始化结果会保留到应用容器和 sidecar 容器中。

```plain
$ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c istio-proxy bash
 istio-proxy@front-tomcat-v1-78cf497978-ppwwk:/$ netstat -nltp
 Active Internet connections (only servers)
 Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
 tcp        0      0 127.0.0.1:15000         0.0.0.0:*               LISTEN      16/envoy
 tcp        0      0 0.0.0.0:15001           0.0.0.0:*               LISTEN      16/envoy
 tcp        0      0 0.0.0.0:15006           0.0.0.0:*               LISTEN      16/envoy
 tcp        0      0 127.0.0.1:8005          0.0.0.0:*               LISTEN      -
 tcp        0      0 0.0.0.0:8009            0.0.0.0:*               LISTEN      -
 tcp        0      0 0.0.0.0:8778            0.0.0.0:*               LISTEN      -
 tcp        0      0 0.0.0.0:15021           0.0.0.0:*               LISTEN      16/envoy
 tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      -
 tcp        0      0 0.0.0.0:15090           0.0.0.0:*               LISTEN      16/envoy
 tcp6       0      0 :::15020                :::*                    LISTEN      1/pilot-agent
```

说明pod内的出站流量请求被监听在15001端口的envoy的进程接收到，进而就走到了envoy的Listener -> route -> cluster -> endpoint 转发流程。

问题就转变为：如何查看envoy的配置，跟踪转发的过程？

###### 调试envoy

我们知道，envoy的配置非常复杂，直接在config_dump里去跟踪xDS的过程非常繁琐。因此istio提供了调试命令，方便查看envoy的流量处理流程。

 $ istioctl proxy-config -h

比如，通过如下命令可以查看envoy的监听器：

```plain
# 查看15001的监听
 $ istioctl proxy-config listener front-tomcat-v1-78cf497978-vv9wj.istio-demo --port 15001 -ojson
 # virtualOutbound的监听不做请求处理，hiddenEnvoyDeprecatedUseOriginalDst: true, 直接转到原始的请求对应的监听器中
 
 # 查看访问端口是9999的监听器
 $ istioctl proxy-config listener front-tomcat-v1-78cf497978-ppwwk.istio-demo --port 9999 -ojson
 ...
     {
         "name": "0.0.0.0_9999",
         "address": {
             "socketAddress": {
                 "address": "0.0.0.0",
                 "portValue": 9999
             }
         },
         "filterChains": [
             {
                 "filterChainMatch": {
                     "applicationProtocols": [
                         "http/1.0",
                         "http/1.1",
                         "h2c"
                     ]
                 },
                 "filters": [
                     {
                         "name": "envoy.filters.network.http_connection_manager",
                         "typedConfig": {
                             "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager",
                             "statPrefix": "outbound_0.0.0.0_9999",
                             "rds": {
                                 "configSource": {
                                     "ads": {},
                                     "resourceApiVersion": "V3"
                                 },
                                 "routeConfigName": "9999"
                             },
 ...
```

envoy收到请求后，会转给监听器进行处理请求，监听器先匹配address和port和socket都一致的Listener，如果没找到再找port一致，address==0.0.0.0的Listener

发现istio会为网格内的Service Port创建名为0.0.0.0\_<Port>的虚拟监听器，本例中为0.0.0.0_9999。

envoy的15001端口收到请求后，直接转到了0.0.0.0_9999，进而转到了"routeConfigName": "9999"，即9999这个route中。

下面，看下route的内容：

```plain
$ istioctl pc route front-tomcat-v1-78cf497978-ppwwk.istio-demo --name 9999
 NOTE: This output only contains routes loaded via RDS.
 NAME     DOMAINS          MATCH     VIRTUAL SERVICE
 9999     bill-service     /*        vs-bill-service.istio-demo
 
 # 发现了前面创建的virtual service
 $ istioctl pc route front-tomcat-v1-78cf497978-ppwwk.istio-demo --name 9999 -ojson
 [
     {
         "name": "9999",
         "virtualHosts": [
             {
                 "name": "allow_any",
                 "domains": [
                     "*"
                 ],
                 "routes": [
                     {
                         "name": "allow_any",
                         "match": {
                             "prefix": "/"
                         },
                         "route": {
                             "cluster": "PassthroughCluster",
                             "timeout": "0s",
                             "maxGrpcTimeout": "0s"
                         }
                     }
                 ],
                 "includeRequestAttemptCount": true
             },
             {
                 "name": "bill-service.istio-demo.svc.cluster.local:9999",
                 "domains": [
                     "bill-service.istio-demo.svc.cluster.local",
                     "bill-service.istio-demo.svc.cluster.local:9999",
                     "bill-service",
                     "bill-service:9999",
                     "bill-service.istio-demo.svc.cluster",
                     "bill-service.istio-demo.svc.cluster:9999",
                     "bill-service.istio-demo.svc",
                     "bill-service.istio-demo.svc:9999",
                     "bill-service.istio-demo",
                     "bill-service.istio-demo:9999",
                     "10.111.219.247",
                     "10.111.219.247:9999"
                 ],
                 "routes": [
                     {
                         "name": "bill-service-route",
                         "match": {
                             "prefix": "/"
                         },
                         "route": {
                             "weightedClusters": {
                                 "clusters": [
                                     {
                                         "name": "outbound|9999|v1|bill-service.istio-demo.svc.cluster.local",
                                         "weight": 90
                                     },
                                     {
                                         "name": "outbound|9999|v2|bill-service.istio-demo.svc.cluster.local",
                                         "weight": 10
                                     }
                                 ]
                             },
 ...
```

满足访问domains列表的会优先匹配到，我们访问的是10.111.219.247:9999，因此匹配bill-service.istio-demo.svc.cluster.local:9999这组虚拟hosts，进而使用到基于weight的集群配置。

<!-- OCR_START -->
- 初始化容器，负
- 启动了两个进
- 责初始化pod的
- 程：piolot-
- iptables规则，
- agent和envoy
- 执行完成后退出
- infra
- istio-proxy
- bill-service
- istio-init
- 90%
- bill-service-v1
- front-tomcat
- 主容器
- 容器
- 10%
- front-tomcat-pod
- bill-service-v2
<!-- OCR_END -->

我们看到，流量按照预期的配置进行了转发：

```plain
90% -> outbound|9999|v1|bill-service.istio-demo.svc.cluster.local
 10% -> outbound|9999|v2|bill-service.istio-demo.svc.cluster.local
```

下面，看一下cluster的具体内容：

```plain
$ istioctl pc cluster front-tomcat-v1-78cf497978-ppwwk.istio-demo --fqdn bill-service.istio-demo.svc.cluster.local -ojson
 ...
         "name": "outbound|9999|v1|bill-service.istio-demo.svc.cluster.local",
         "type": "EDS",
         "edsClusterConfig": {
             "edsConfig": {
                 "ads": {},
                 "resourceApiVersion": "V3"
             },
             "serviceName": "outbound|9999|v1|bill-service.istio-demo.svc.cluster.local"
         },
 ...
```

我们发现，endpoint列表是通过eds获取的，因此，查看endpoint信息：

```plain
$ istioctl pc endpoint front-tomcat-v1-78cf497978-ppwwk.istio-demo  --cluster 'outbound|9999|v1|bill-service.istio-demo.svc.cluster.local' -ojson
 [
     {
         "name": "outbound|9999|v1|bill-service.istio-demo.svc.cluster.local",
         "addedViaApi": true,
         "hostStatuses": [
             {
                 "address": {
                     "socketAddress": {
                         "address": "10.244.0.17",
                         "portValue": 80
                     }
                 },
 ...
```

目前为止，经过envoy的规则，流量从front-tomcat的pod中知道要发往10.244.0.7:80 这个pod地址。前面提到过，envoy不止接管出站流量，入站流量同样会接管。

<!-- OCR_START -->
- Proxy
- docker
- CircuitBreaker
- Rate limiting
- Tracing
- Metrics
- Service A
- ServiceB
- php
- Business logic
- Java
<!-- OCR_END -->

下面看下流量到达bill-service-v1的pod后的处理：

先回顾前面的iptables规则，除特殊情况以外，所有的出站流量被监听在15001端口的envoy进程拦截处理，同样的，分析bill-service-v1的iptables规则可以发现，监听在15006端口的envoy进程通过在PREROUTING链上添加规则，同样将进入pod的入站流量做了拦截。

```plain
# PREROUTING 链：用于目标地址转换（DNAT），将所有入站 TCP 流量跳转到 ISTIO_INBOUND 链上。
 Chain PREROUTING (policy ACCEPT 148 packets, 8880 bytes)
  pkts bytes target     prot opt in     out     source               destination
   148  8880 ISTIO_INBOUND  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0
 
 # INPUT 链：处理输入数据包，非 TCP 流量将继续 OUTPUT 链。
 Chain INPUT (policy ACCEPT 148 packets, 8880 bytes)
  pkts bytes target     prot opt in     out     source               destination
 
 # ISTIO_INBOUND 链：将所有入站流量重定向到 ISTIO_IN_REDIRECT 链上，目的地为 15090，15020，15021端口的流量除外，发送到以上两个端口的流量将返回 iptables 规则链的调用点，即 PREROUTING 链的后继 POSTROUTING。
 Chain ISTIO_INBOUND (1 references)
  pkts bytes target     prot opt in     out     source               destination
     0     0 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15008
     0     0 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
     0     0 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15090
   143  8580 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15021
     5   300 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15020
     0     0 ISTIO_IN_REDIRECT  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0
 
 # ISTIO_IN_REDIRECT 链：将所有入站流量跳转到本地的 15006 端口，至此成功的拦截了流量到sidecar中。
 Chain ISTIO_IN_REDIRECT (3 references)
  pkts bytes target     prot opt in     out     source               destination
     0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            redir ports 15006
```

15006端口是一个名为 virtualInbound虚拟入站监听器，

 $ istioctl pc l bill-service-v1-6c95ccb747-vwt2d.istio-demo --port 15006 -ojson>/tmp/15006.inbound.json

<!-- OCR_START -->
- 849
- 850
- "filterChainMatch":
- 851
- "destinationPort":
- 80
- 852
- 853
- "filters"
- 854
- 855
- "name":
- istio. metadata_exchange
- 856
- "typedConfig":
- {…·} // 3 items
- 863
- 1,
- 864
- 865
- "envoy. filters. network. http_connection_manager'
- 866
- 867
- "@type":
- "type. googleapis. com/envoy. extensions. filters. network. http_connection_manager. v3. HttpConnectionManager"
- 868
- 'statPrefix":
- "inbound_0. 0. 0. 0_80",
- 869
- "routeConfig":
- 870
- "inbound| 9999 http|bill-service. istio-demo. svc. cluster. local",
- 871
- "virtualHosts":
- 872
- 3
- 873
- "inbound|http|9999",
- 874
- "domains":
- 875
- “*”
- 876
- 877
- routes
- 878
- 879
- "default",
- 880
- "match":
- 881
- "prefix":
- 882
- 883
- "route":
- 884
- "cluster":
- 885
<!-- OCR_END -->

相比于VirtualOutbound， virtualInbound 不会再次转给别的虚拟监听器，而是直接由本监听器的filterChains处理，本例中我们可以发现本机目标地址为80的http请求，转发到了inbound|9999|http|bill-service.istio-demo.svc.cluster.local这个集群中。

查看该集群的信息：

```plain
$ istioctl pc cluster bill-service-v1-6c95ccb747-vwt2d.istio-demo -h
 $ istioctl pc cluster bill-service-v1-6c95ccb747-vwt2d.istio-demo --direction inbound -ojson
 [
     {
         "name": "inbound|9999|http|bill-service.istio-demo.svc.cluster.local",
         "type": "STATIC",
         "connectTimeout": "10s",
         "loadAssignment": {
             "clusterName": "inbound|9999|http|bill-service.istio-demo.svc.cluster.local",
             "endpoints": [
                 {
                     "lbEndpoints": [
                         {
                             "endpoint": {
                                 "address": {
                                     "socketAddress": {
                                         "address": "127.0.0.1",
                                         "portValue": 80
                                     }
                                 }
                             }
                         }
                     ]
                 }
             ]
         },
         "circuitBreakers": {
             "thresholds": [
                 {
                     "maxConnections": 4294967295,
                     "maxPendingRequests": 4294967295,
                     "maxRequests": 4294967295,
                     "maxRetries": 4294967295
                 }
             ]
         }
     }
 ]
```

###### 一点小知识

**同一个Pod，不同的表现**

```plain
$ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c front-tomcat bash
 # curl bill-service:9999
 
 $ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c istio-proxy bash
 # curl bill-service:9999
```

可以发现，在front-tomcat中的访问请求，是受到我们设置的 9：1的流量分配规则限制的，但是istio-proxy中的访问是不受限制的。

istio-proxy自身，发起的往10.244.0.17的请求，使用的用户是 uid=1337(istio-proxy)，因此不会被istio-init初始化的防火墙规则拦截，可以直接走pod的网络进行通信。

**istio服务网格内，流量请求完全绕过了kube-proxy组件**

通过上述流程调试，我们可以得知，front-tomcat中访问bill-service:9999，流量是没有用到kube-proxy维护的宿主机中的iptables规则的。

<!-- OCR_START -->
- Service Mesh
- Kubernetes原生
- 每个 pod 中部署一个 sidecar 的模式
- node
- pod
- proxy
- kube-proxy
- CNI
- 控制平面
- KubernetesAPI Server
<!-- OCR_END -->

验证一下：

```plain
# 停掉kube-proxy
 $ kubectl -n kube-system edit daemonset kube-proxy
 ...
       dnsPolicy: ClusterFirst                 
       hostNetwork: true                       
       nodeSelector:                           
         beta.kubernetes.io/os: linux1    #把此处修改一个不存在的label值     
       priorityClassName: system-node-critical 
 ...
 
 #清理iptables规则
 $ iptables -F -t nat
 
 # 访问测试
 $ kubectl -n istio-demo get  svc
 NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
 bill-service   ClusterIP   10.111.219.247   <none>        9999/TCP   2d18h
 $ curl 10.111.219.247:9999 
 
 # 进入front-tomcat容器进行访问
 $ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c front-tomcat bash
 # curl 10.111.219.247:9999 
 # curl bill-service:9999 会因为dns解析失败而访问失败，手动配置namespaceserver即可
 
 $ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c istio-proxy bash
 # curl curl 10.111.219.247:9999
```

**集群内的Service都相应的创建了虚拟出站监听器**

```plain
$ kubectl -n istio-demo exec -ti front-tomcat-v1-78cf497978-ppwwk -c front-tomcat bash
 # curl sonarqube.jenkins:9000
 
 $ istioctl pc l front-tomcat-v1-78cf497978-ppwwk.istio-demo --port 9000 
 ADDRESS      PORT MATCH     DESTINATION
 10.97.243.33 9000 App: HTTP Route: sonarqube.jenkins.svc.cluster.local:9000
 10.97.243.33 9000 ALL       Cluster: outbound|9000||sonarqube.jenkins.svc.cluster.local
 
 $ istioctl pc r front-tomcat-v1-78cf497978-ppwwk.istio-demo --name 'sonarqube.jenkins.svc.cluster.local:9000'
 
 $ istioctl pc ep front-tomcat-v1-78cf497978-ppwwk.istio-demo --cluster 'outbound|9000||sonarqube.jenkins.svc.cluster.local'
```

virtualOutBound 15001 --> virtial listener 10.97.243.33_9000 --> route sonarqube.jenkins.svc.cluster.local:9000 --> cluster outbound|9000||sonarqube.jenkins.svc.cluster.local --> 10.244.1.13:9000

##### 场景三

###### 模型图

<!-- OCR_START -->
| 占比 | 前端UIv1版本 | 前端UIv1版本 | 前端UIv1版本 | 前端UIv1版本 |
| --- | --- | --- | --- | --- |
| Pod | 账单服务 | 账单v1版本 | pod | Deployment |
| 90% | 90% | 账单Service | 前端UIService | 10% |
| 10% | 前端UI | Pod | 账单服务 | 账单v2版本 |
<!-- OCR_END -->

###### 资源清单

```plain
front-tomcat-service.yaml
 apiVersion: v1
 kind: Service
 metadata:
   labels:
     app: front-tomcat
   name: front-tomcat
   namespace: istio-demo
 spec:
   ports:
   - name: http
     port: 8080
     protocol: TCP
     targetPort: 8080
   selector:
     app: front-tomcat
   type: ClusterIP
 front-tomcat-v2-dpl.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   labels:
     app: front-tomcat
     version: v2
   name: front-tomcat-v2
   namespace: istio-demo
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: front-tomcat
       version: v2
   template:
     metadata:
       labels:
         app: front-tomcat
         version: v2
     spec:
       containers:
       - image: consol/tomcat-7.0:latest
         name: front-tomcat
         command: ["/bin/sh", "-c", "echo 'hello tomcat version2'>/opt/tomcat/webapps/ROOT/index.html;/opt/tomcat/bin/deploy-and-run.sh;"]
 front-tomcat-virtualservice.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: front-tomcat
   namespace: istio-demo
 spec:
   hosts:
   - front-tomcat
   http:
   - name: front-tomcat-route
     route:
     - destination:
         host: front-tomcat
         subset: v1
       weight: 90
     - destination:
         host: front-tomcat
         subset: v2
       weight: 10
 ---
 apiVersion: networking.istio.io/v1alpha3
 kind: DestinationRule
 metadata:
   name: front-tomcat
   namespace: istio-demo
 spec:
   host: front-tomcat
   subsets:
   - name: v1
     labels:
       version: v1
   - name: v2
     labels:
       version: v2
 $ kubectl apply -f front-tomcat-service.yaml
 $ kubectl apply -f <(istioctl kube-inject -f front-tomcat-v2-dpl.yaml)
 $ kubectl apply -f front-tomcat-virtualservice.yaml
```

##### 使用ingress来访问网格服务

```plain
front-tomcat-ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: front-tomcat
   namespace: istio-demo
 spec:
   rules:
   - host: tomcat.istio-demo.com
     http:
       paths:
       - backend:
           serviceName: front-tomcat
           servicePort: 8080
         path: /
 status:
   loadBalancer: {}
```

使用浏览器访问查看效果。

只有网格内部访问会遵从virtualservice的规则，在宿主机中直接访问Service的ClusterIP还是按照默认的规则转发。

Ingress：对接ingress controller，实现外部流量进入集群内部，只适用于 HTTP 流量，使用方式也很简单，只能对 service、port、HTTP 路径等有限字段匹配来路由流量，这导致它无法路由如 MySQL、Redis 和各种私有 RPC 等 TCP 流量。要想直接路由南北向的流量，只能使用 Service 的 LoadBalancer 或 NodePort，前者需要云厂商支持，后者需要进行额外的端口管理。有些 Ingress controller 支持暴露 TCP 和 UDP 服务，但是只能使用 Service 来暴露，Ingress 本身是不支持的，例如 nginx ingress controller，服务暴露的端口是通过创建 ConfigMap 的方式来配置的。

##### ingressgateway访问网格服务

对于入口流量管理，您可能会问： 为什么不直接使用 Kubernetes Ingress API ？ 原因是 Ingress API 无法表达 Istio 的路由需求。 Ingress 试图在不同的 HTTP 代理之间取一个公共的交集，因此只能支持最基本的 HTTP 路由，最终导致需要将代理的其他高级功能放入到注解（annotation）中，而注解的方式在多个代理之间是不兼容的，无法移植。

Istio Gateway 通过将 L4-L6 配置与 L7 配置分离的方式克服了 Ingress 的这些缺点。 Gateway 只用于配置 L4-L6 功能（例如，对外公开的端口，TLS 配置），所有主流的L7代理均以统一的方式实现了这些功能。 然后，通过在 Gateway 上绑定 VirtualService 的方式，可以使用标准的 Istio 规则来控制进入 Gateway 的 HTTP 和 TCP 流量。

```plain
front-tomcat-gateway.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: Gateway
 metadata:
   name: front-tomcat-gateway
   namespace: istio-demo
 spec:
   selector:
     istio: ingressgateway # use istio default controller
   servers:
   - port:
       number: 80
       name: http
       protocol: HTTP
     hosts:
     - tomcat.istio-demo.com
```

效果是在Istio的ingress网关上加了一条规则，允许\`tomcat.istio-demo.com 的外部http流量进入到网格中，但是只是接受访问和流量输入，当流量到达这个网关时，它还不知道发送到哪里去。

网关已准备好接收流量，我们必须告知它将收到的流量发往何处，这就用到了前面使用过的VirtualService。

要为进入上面的 Gateway 的流量配置相应的路由，必须为同一个 host 定义一个 VirtualService，并使用配置中的 gateways 字段绑定到前面定义的 Gateway 上

```plain
front-tomcat-gateway-virtualservice.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: gateway-front-tomcat
   namespace: istio-demo
 spec:
   gateways:
   - front-tomcat-gateway
   hosts:
   - tomcat.istio-demo.com
   http:
   - name: front-tomcat-route
     route:
     - destination:
         host: front-tomcat
         subset: v1
       weight: 90
     - destination:
         host: front-tomcat
         subset: v2
       weight: 10
```

该网关列表指定，只有通过我们指定的网关 front-tomcat-gateway 的流量是允许的。所有其他外部请求将被拒绝，并返回 404 响应。

请注意，在此配置中，来自网格中其他服务的内部请求不受这些规则约束

```plain
$ kubectl apply -f front-tomcat-gateway-virtualservice.yaml
 $ kubectl apply -f front-tomcat-gateway.yaml
```

模拟访问：

```plain
$ kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'
 31995
 $ curl  -HHost:tomcat.istio-demo.com 172.21.51.67:31995/
```

172.21.51.67:31995地址从何而来？

<!-- OCR_START -->
- servers:
- Pilot
- port:
- number: 80
- name: http
- protocol: HTTP
- hosts:
- -weather.com
- frontend
- Envoy
- (Gateway)
- (Sidecar)
<!-- OCR_END -->

浏览器访问: http://tomcat.istio-demo.com:31995/

如何实现不加端口访问网格内服务？

```plain
# 在一台80端口未被占用的机器中，如ip为172.21.51.69
 $ docker run -d --restart=always -p 80:80 --name istio-nginx nginx:alpine
 
 # 在容器的/etc/nginx/conf.d/目录中，新增配置文件
 $ cat front-tomcat.conf
 upstream front-tomcat {
   server 172.21.51.67:31995;
 }
 server {
     listen       80;
     listen  [::]:80;
     server_name  tomcat.istio-demo.com;
 
     location / {
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_http_version 1.1;
         proxy_pass http://front-tomcat;
     }
 }
 
 $ nginx -s reload
```

本地配置hosts

 172.21.51.69 tomcat.istio-demo.com

直接访问http://tomcat.istio-demo.com 即可实现外部域名访问到网格内部服务

#### 实例演示

##### 实例介绍

创建bookinfo实例：

```plain
$ kubectl create namespace bookinfo
 $ kubectl -n bookinfo create -f samples/bookinfo/platform/kube/bookinfo.yaml 
 $ kubectl -n bookinfo get po 
 NAME                                  READY   STATUS    RESTARTS   AGE
 details-v1-5974b67c8-wclnd            1/1     Running   0          34s
 productpage-v1-64794f5db4-jsdbg       1/1     Running   0          33s
 ratings-v1-c6cdf8d98-jrfrn            1/1     Running   0          33s
 reviews-v1-7f6558b974-kq6kj           1/1     Running   0          33s
 reviews-v2-6cb6ccd848-qdg2k           1/1     Running   0          34s
 reviews-v3-cc56b578-kppcx             1/1     Running   0          34s
```

该应用由四个单独的微服务构成。 这个应用模仿在线书店的一个分类，显示一本书的信息。 页面上会显示一本书的描述，书籍的细节（ISBN、页数等），以及关于这本书的一些评论。

Bookinfo 应用分为四个单独的微服务：

* productpage. 这个微服务会调用 details 和 reviews 两个微服务，用来生成页面。
* details. 这个微服务中包含了书籍的信息。
* reviews. 这个微服务中包含了书籍相关的评论。它还会调用 ratings 微服务。
* ratings. 这个微服务中包含了由书籍评价组成的评级信息。

reviews 微服务有 3 个版本：

* v1 版本不会调用 ratings 服务。
* v2 版本会调用 ratings 服务，并使用 1 到 5 个黑色星形图标来显示评分信息。
* v3 版本会调用 ratings 服务，并使用 1 到 5 个红色星形图标来显示评分信息。

Bookinfo 是一个异构应用，几个微服务是由不同的语言编写的。这些服务对 Istio 并无依赖，但是构成了一个有代表性的服务网格的例子：它由多个服务、多个语言构成，并且 reviews 服务具有多个版本。

使用ingress访问productpage服务：

```plain
ingress-productpage.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: productpage
   namespace: bookinfo
 spec:
   rules:
   - host: productpage.bookinfo.com
     http:
       paths:
       - backend:
           serviceName: productpage
           servicePort: 9080
         path: /
 status:
   loadBalancer: {}
```

如何实现更细粒度的流量管控？

##### 注入sidecar容器

###### 如何注入sidecar容器

1. 使用istioctl kube-inject $ kubectl -n bookinfo apply -f <(istioctl kube-inject -f samples/bookinfo/platform/kube/bookinfo.yaml)
2. 为命名空间打label

```plain
# 给命名空间打标签，这样部署在该命名空间的服务会自动注入sidecar容器
 $ kubectl label namespace dafault istio-injection=enabled
```

###### 注入bookinfo

 $ kubectl -n bookinfo apply -f <(istioctl kube-inject -f samples/bookinfo/platform/kube/bookinfo.yaml)

##### 流量路由

实现ingress解决不了的按照比例分配流量

###### ingress-gateway访问productpage

```plain
productpage-gateway.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: Gateway
 metadata:
   name: productpage-gateway
   namespace: bookinfo
 spec:
   selector:
     istio: ingressgateway # use istio default controller
   servers:
   - port:
       number: 80
       name: http
       protocol: HTTP
     hosts:
     - productpage.bookinfo.com
 productpage-virtualservice.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: gateway-front-tomcat
   namespace: bookinfo
 spec:
   gateways:
   - productpage-gateway
   hosts:
   - productpage.bookinfo.com
   http:
   - route:
     - destination:
         host: productpage
         port:
           number: 9080
```

配置nginx，使用域名80端口访问。

```plain
upstream bookinfo-productpage {
   server 172.21.51.67:31995;
 }
 server {
     listen       80;
     listen  [::]:80;
     server_name  productpage.bookinfo.com;
 
     location / {
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_http_version 1.1;
         proxy_pass http://bookinfo-productpage;
     }
 }
```

###### 权重路由

只想访问reviews-v3

```plain
$ cat virtual-service-reviews-v3.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: reviews
   namespace: bookinfo
 spec:
   hosts:
     - reviews
   http:
   - route:
     - destination:
         host: reviews
         subset: v3
 
 $ cat destination-rule-reviews.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: DestinationRule
 metadata:
   name: reviews
   namespace: bookinfo
 spec:
   host: reviews
   trafficPolicy:
     loadBalancer:
       simple: RANDOM
   subsets:
   - name: v1
     labels:
       version: v1
   - name: v2
     labels:
       version: v2
   - name: v3
     labels:
       version: v3
 
 $ kubectl apply -f virtual-service-reviews-v3.yaml
 
 # 访问productpage测试
```

实现如下流量分配：

```plain
90% -> reivews-v1
 10% -> reviews-v2
 0%  -> reviews-v3
 $ cat virtual-service-reviews-90-10.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: reviews
   namespace: bookinfo
 spec:
   hosts:
     - reviews
   http:
   - route:
     - destination:
         host: reviews
         subset: v1
       weight: 90
     - destination:
         host: reviews
         subset: v2
       weight: 10
 
 $ kubectl apply -f virtual-service-reviews-90-10.yaml
 
 # 假如v2版本的副本数扩容为3，v2版本的流量会如何分配？  会不会变成30%？
 $ kubectl -n bookinfo scale deploy reviews-v2 --replicas=3
```

###### 访问路径路由

实现效果如下：

<!-- OCR_START -->
- reviews
- bookinfo.com
- /ratings
- /productpage
<!-- OCR_END -->

```plain
# 定义允许外部流量进入网格,直接编辑已有gateway
 $ kubectl -n bookinfo edit gw productpage-gateway
 
 $ cat bookinfo-routing-with-uri-path.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: bookinfo
   namespace: bookinfo
 spec:
   gateways:
   - productpage-gateway
   hosts:
     - bookinfo.com
   http:
   - name: productpage-route
     match:
     - uri:
         prefix: /productpage
     route:
     - destination:
         host: productpage
   - name: reviews-route
     match:
     - uri:
         prefix: /reviews
     route:
     - destination:
         host: reviews
   - name: ratings-route
     match:
     - uri:
         prefix: /ratings
     route:
     - destination:
         host: ratings
```

nginx中新增配置：

```plain
upstream bookinfo {
   server 172.21.51.67:31995;
 }
 server {
     listen       80;
     listen  [::]:80;
     server_name  bookinfo.com;
 
     location / {
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_http_version 1.1;
         proxy_pass http://bookinfo;
     }
 }
```

访问：

```plain
http://bookinfo.com/productpage
 http://bookinfo.com/ratings/1
```

实际的访问对应为：

```plain
bookinfo.com/productpage  -> productpage:8090/productpage
 bookinfo.com/ratings  ->  ratings:9080/ratings
 bookinfo.com/reviews  ->  reviews:9080/reviews
```

实际访问productpage页面，由于需要引用css、js等静态资源，因此需要补充对/static路径的转发：

```plain
...
   http:
   - name: productpage-route
     match:
     - uri:
         prefix: /productpage
     - uri:
         prefix: /static
     route:
     - destination:
         host: productpage
 ...
```

virtualservice的配置中并未指定service的port端口，转发同样可以生效？

注意，若service中只有一个端口，则不用显式指定端口号，会自动转发到该端口中

###### 路径重写

如果想实现rewrite的功能，

```plain
bookinfo.com/rate  -> ratings:8090/ratings
 ...
   - name: ratings-route
     match:
     - uri:
         prefix: /rate
     rewrite:
       uri: "/ratings"
     route:
     - destination:
         host: ratings
 ...
```

###### 匹配优先级

登录发现/login的匹配也没有添加，后续有可能有别的，因此可以在规则列表最后添加一个规则，作为默认的转发规则。

```plain
$ kubectl -n bookinfo edit vs bookinfo
 ...
   - name: default-route
     route:
     - destination:
         host: productpage
```

###### DestinationRule 转发策略

默认会使用轮询策略，此外也支持如下负载均衡模型，可以在 DestinationRule 中使用这些模型，将请求分发到特定的服务或服务子集。

* Random：将请求转发到一个随机的实例上
* Weighted：按照指定的百分比将请求转发到实例上
* Least requests：将请求转发到具有最少请求数目的实例上

```plain
apiVersion: networking.istio.io/v1alpha3
 kind: DestinationRule
 metadata:
   name: my-destination-rule
 spec:
   host: my-svc
   trafficPolicy:     #默认的负载均衡策略模型为随机
     loadBalancer:
       simple: RANDOM
   subsets:
   - name: v1  #subset1，将流量转发到具有标签 version:v1 的 deployment 对应的服务上
     labels:
       version: v1
   - name: v2  #subset2，将流量转发到具有标签 version:v2 的 deployment 对应的服务上,指定负载均衡为轮询
     labels:
       version: v2
     trafficPolicy:
       loadBalancer:
         simple: ROUND_ROBIN
   - name: v3   #subset3，将流量转发到具有标签 version:v3 的 deployment 对应的服务上
     labels:
       version: v3
```

###### 使用https

方式一：把证书绑定在外部的nginx中， nginx 443端口监听外网域名并转发请求到Istio Ingress网关IP+http端口 ，如果使用公有云lb的话（如slb，clb），可以在lb层绑定证书

方式二：在istio侧使用证书

<https://istio.io/latest/docs/tasks/traffic-management/ingress/secure-ingress/>

###### header头路由

```plain
$ cat virtual-service-reviews-header.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: reviews
   namespace: bookinfo
 spec:
   hosts:
   - reviews
   http:
   - match:
     - headers:
         end-user:
           exact: luffy
     route:
     - destination:
         host: reviews
         subset: v2
   - route:
     - destination:
         host: reviews
         subset: v3
 $ kubectl apply -f virtual-service-reviews-header.yaml
 
 # 刷新观察http://bookinfo.com/productpage
```

更多支持的匹配类型可以在此处查看。

<https://istio.io/latest/docs/reference/config/networking/virtual-service/#HTTPMatchRequest>

##### 流量镜像

###### 介绍

很多情况下，当我们对服务做了重构，或者我们对项目做了重大优化时，怎么样保证服务是健壮的呢？在传统的服务里，我们只能通过大量的测试，模拟在各种情况下服务的响应情况。虽然也有手工测试、自动化测试、压力测试等一系列手段去检测它，但是测试本身就是一个样本化的行为，即使测试人员再完善它的测试样例，无法全面的表现出线上服务的一个真实流量形态 。

流量镜像的设计，让这类问题得到了最大限度的解决。流量镜像讲究的不再是使用少量样本去评估一个服务的健壮性，而是在不影响线上坏境的前提下将线上流量持续的镜像到我们的预发布坏境中去，让重构后的服务在上线之前就结结实实地接受一波真实流量的冲击与考验，让所有的风险全部暴露在上线前夕，通过不断的暴露问题，解决问题让服务在上线前夕就拥有跟线上服务一样的健壮性。由于测试坏境使用的是真实流量，所以不管从流量的多样性，真实性，还是复杂性上都将能够得以展现，同时预发布服务也将表现出其最真实的处理能力和对异常的处理能力。

###### 实践

<!-- OCR_START -->
- One Istio Mesh
- httpbin v1
- HTTP/HTTPS
- Gateway
- Envoy
- redirect
- Httpbin v2
- mirror
<!-- OCR_END -->

```plain
# 准备httpbin v1
 $ cat httpbin-v1.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: httpbin-v1
   namespace: bookinfo
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: httpbin
       version: v1
   template:
     metadata:
       labels:
         app: httpbin
         version: v1
     spec:
       containers:
       - image: docker.io/kennethreitz/httpbin
         imagePullPolicy: IfNotPresent
         name: httpbin
         command: ["gunicorn", "--access-logfile", "-", "-b", "0.0.0.0:80", "httpbin:app"]
 
 $ istioctl kube-inject -f httpbin-v1.yaml | kubectl create -f -
 $ curl $(kubectl -n bookinfo get po  -l version=v1,app=httpbin -ojsonpath='{.items[0].status.podIP}')/headers
 {
   "headers": {
     "Accept": "*/*",
     "Content-Length": "0",
     "Host": "10.244.0.88",
     "User-Agent": "curl/7.29.0",
     "X-B3-Sampled": "1",
     "X-B3-Spanid": "777c7af4458c5b81",
     "X-B3-Traceid": "6b98ea81618deb4f777c7af4458c5b81"
   }
 }
 
 # 准备httpbin v2
 $ cat httpbin-v2.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: httpbin-v2
   namespace: bookinfo
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: httpbin
       version: v2
   template:
     metadata:
       labels:
         app: httpbin
         version: v2
     spec:
       containers:
       - image: docker.io/kennethreitz/httpbin
         imagePullPolicy: IfNotPresent
         name: httpbin
         command: ["gunicorn", "--access-logfile", "-", "-b", "0.0.0.0:80", "httpbin:app"]
 
 $ istioctl kube-inject -f httpbin-v2.yaml | kubectl create -f -
 
 # Service文件
 $ cat httpbin-svc.yaml
 apiVersion: v1
 kind: Service
 metadata:
   name: httpbin
   namespace: bookinfo
   labels:
     app: httpbin
 spec:
   ports:
   - name: http
     port: 8000
     targetPort: 80
   selector:
     app: httpbin
 
 $ kubectl apply -f httpbin-svc.yaml
 
 # 使用bookinfo.com/httpbin访问,因此直接修改bookinfo这个virtualservice即可
 $ kubectl -n bookinfo get vs
 NAME                   GATEWAYS                HOSTS               
 bookinfo               [bookinfo-gateway]      [bookinfo.com]       
 gateway-front-tomcat   [productpage-gateway]   [productpage.bookinfo.com]
 reviews                                        [reviews]     
 $ kubectl -n bookinfo edit vs bookinfo
 #添加httpbin的规则
 ...
   - match:
     - uri:
         prefix: /httpbin
     name: httpbin-route
     rewrite:
       uri: /
     route:
     - destination:
         host: httpbin
         subset: v1
 ...
 # 创建gateway和virtualservice,由于都是使用http请求，因此，直接
 $ cat httpbin-destinationRule.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: DestinationRule
 metadata:
   name: httpbin
   namespace: bookinfo
 spec:
   host: httpbin
   subsets:
   - name: v1
     labels:
       version: v1
   - name: v2
     labels:
       version: v2
 $ kubectl apply -f httpbin-destinationRule.yaml
 
 # 访问http://bookinfo.com/httpbin/headers，查看日志
 
 # 为httpbin-v1添加mirror设置，mirror点为httpbin-v2
 $ kubectl -n bookinfo edit vs bookinfo
 ...
   - match:
     - uri:
         prefix: /httpbin
     name: httpbin-route
     rewrite:
       uri: /
     route:
     - destination:
         host: httpbin
         subset: v1
     mirror:
       host: httpbin
       subset: v2
     mirror_percent: 100
 ...
```

##### 重试

在网络环境不稳定的情况下，会出现暂时的网络不可达现象，这时需要重试机制，通过多次尝试来获取正确的返回信息。 istio 可以通过简单的配置来实现重试功能，让开发人员无需关注重试部分的代码实现，专心实现业务代码。

###### 实践

浏览器访问http://bookinfo.com/httpbin/status/502

```plain
# 此时查看httpbin-v1的日志，显示一条状态码为502的日志
 $ kubectl -n bookinfo logs -f httpbin-v1-5967569c54-sp874 -c istio-proxy
 [2020-11-09T10:26:48.907Z] "GET /httpbin/status/502 HTTP/1.1" 502 - "-" "-" 0 0 5 4 "172.21.50.140,10.244.0.1" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36" "767cf33b-b8cf-9804-8c48-df131393c8a5" "bookinfo.com" "127.0.0.1:80" inbound|8000|http|httpbin.bookinfo.svc.cluster.local 127.0.0.1:48376 10.244.0.90:80 10.244.0.1:0 outbound_.8000_.v1_.httpbin.bookinfo.svc.cluster.local default
```

我们为httpbin服务设置重试机制，这里设置如果服务在 2 秒内没有返回正确的返回值，就进行重试，重试的条件为返回码为5xx，重试 3 次。

```plain
$ kubectl -n bookinfo edit vs bookinfo
 ...
   - match:
     - uri:
         prefix: /httpbin
     mirror:
       host: httpbin
       subset: v2
     mirror_percent: 100
     name: httpbin-route
     retries:
       attempts: 3
       perTryTimeout: 2s
       retryOn: 5xx
     rewrite:
       uri: /
     route:
     - destination:
         host: httpbin
         subset: v1
 ...
 
 # 再次查看httpbin-v1的日志，显示四条状态码为502的日志
```

##### 熔断

###### 介绍

熔断（Circuit Breaker），原是指当电流超过规定值时断开电路，进行短路保护或严重过载保护的机制 。对于微服务系统而言，熔断尤为重要，它可以使系统在遭遇某些模块故障时，通过服务降级等方式来提高系统核心功能的可用性，得以应对来自故障、潜在峰值或其他未知网络因素的影响。

###### 准备环境

Istio 是通过 Envoy Proxy 来实现熔断机制的，Envoy 强制在网络层面配置熔断策略，这样就不必为每个应用程序单独配置或重新编程。下面就通过一个示例来演示如何为 Istio 网格中的服务配置熔断的连接数、请求数和异常检测。

<!-- OCR_START -->
- lstioServiceMesh
- httpbin
- JavaAPP
- Envoy
- Client
<!-- OCR_END -->

* 创建httpbin服务
* 创建测试客户端我们已经为 httpbin 服务设置了熔断策略，接下来创建一个 Java 客户端，用来向后端服务发送请求，观察是否会触发熔断策略。这个客户端可以控制连接数量、并发数、待处理请求队列，使用这一客户端，能够有效的触发前面在目标规则中设置的熔断策略。该客户端的 deployment yaml 内容如下：

```plain
# httpbin-client-deploy.yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: httpbin-client-v1
   namespace: bookinfo
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: httpbin-client-v1
       version: v1
   template:
     metadata:
       labels:
         app: httpbin-client-v1
         version: v1
     spec:
       containers:
       - image: ceposta/http-envoy-client-standalone:latest
         imagePullPolicy: IfNotPresent
         name: httpbin-client
         command: ["/bin/sleep","infinity"]
```

 $ kubectl apply -f <(istioctl kube-inject -f httpbin-client-deploy.yaml)

这里我们会把给客户端也进行 Sidecar 的注入，以此保证 Istio 对网络交互的控制：

###### 验证

先尝试通过单线程（NUM_THREADS=1）创建一个连接，并进行 5 次调用（默认值：NUM_CALLS_PER_CLIENT=5）：

```plain
$ CLIENT_POD=$(kubectl get pod -n bookinfo | grep httpbin-client | awk '{ print $1 }')
 $ kubectl -n bookinfo exec -it $CLIENT_POD -c httpbin-client -- sh -c 'export URL_UNDER_TEST=http://httpbin:8000/get export NUM_THREADS=1 && java -jar http-client.jar'
```

下面尝试把线程数提高到 2：

 $ kubectl -n bookinfo exec -it $CLIENT_POD -c httpbin-client -- sh -c 'export URL_UNDER_TEST=http://httpbin:8000/get export NUM_THREADS=2 && java -jar http-client.jar'

创建DestinationRule， 针对 httpbin 服务设置熔断策略：

```plain
$ kubectl apply -f - <<EOF
 apiVersion: networking.istio.io/v1alpha3
 kind: DestinationRule
 metadata:
   name: httpbin
   namespace: bookinfo
 spec:
   host: httpbin
   trafficPolicy:
     connectionPool:
       tcp:
         maxConnections: 1
       http:
         http1MaxPendingRequests: 1
         maxRequestsPerConnection: 1
 EOF
```

* **maxConnections** : 限制对后端服务发起的 HTTP/1.1 连接数，如果超过了这个限制，就会开启熔断。
* **maxPendingRequests** : 限制待处理请求列表的长度， 如果超过了这个限制，就会开启熔断。
* **maxRequestsPerConnection** : 在任何给定时间内限制对后端服务发起的 HTTP/2 请求数，如果超过了这个限制，就会开启熔断。

可以查看设置的熔断策略在envoy的配置片段：

```plain
$ istioctl pc cluster httpbin-client-v1-56b86fb85c-vg5pp.bookinfo --fqdn httpbin.bookinfo.svc.cluster.local -ojson
 ...
         "connectTimeout": "10s",
         "maxRequestsPerConnection": 1,
         "circuitBreakers": {
             "thresholds": [
                 {
                     "maxConnections": 1,
                     "maxPendingRequests": 1,
                     "maxRequests": 4294967295,
                     "maxRetries": 4294967295
                 }
             ]
         },
 ...
```

再次验证熔断。

##### 故障注入与超时机制

在一个微服务架构的系统中，为了让系统达到较高的健壮性要求，通常需要对系统做定向错误测试。比如电商中的订单系统、支付系统等若出现故障那将是非常严重的生产事故，因此必须在系统设计前期就需要考虑多样性的异常故障并对每一种异常设计完善的恢复策略或优雅的回退策略，尽全力规避类似事故的发生，使得当系统发生故障时依然可以正常运作。而在这个过程中，服务故障模拟一直以来是一个非常繁杂的工作。

istio提供了无侵入式的故障注入机制，让开发测试人员在不用调整服务程序的前提下，通过配置即可完成对服务的异常模拟。目前，包含两类：

* **abort**：非必配项，配置一个 Abort 类型的对象。用来注入请求异常类故障。简单的说，就是用来模拟上游服务对请求返回指定异常码时，当前的服务是否具备处理能力。
* **delay**：非必配项，配置一个 Delay 类型的对象。用来注入延时类故障。通俗一点讲，就是人为模拟上游服务的响应时间，测试在高延迟的情况下，当前的服务是否具备容错容灾的能力。

###### 延迟与超时

目前针对luffy登录用户，访问服务的示意为：

```plain
productpage --> reviews v2 --> ratings
                \
                 -> details
```

可以通过如下方式，为ratings服务注入2秒的延迟：

```plain
$ cat virtualservice-ratings-2s-delay.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: ratings
   namespace: bookinfo
 spec:
   hosts:
   - ratings
   http:
   - fault:
       delay:
         percentage:
           value: 100
         fixedDelay: 2s
     route:
     - destination:
         host: ratings
 
 $ kubectl apply -f virtualservice-ratings-2s-delay.yaml
 # 再次访问http://bookinfo.com/productpage，可以明显感觉2s的延迟,network可以看到
```

可以查看对应的envoy的配置：

 $ istioctl pc r ratings-v1-556cfbd589-89ml4.bookinfo --name 9080 -ojson

此时的调用为:

```plain
productpage --> reviews v2 -（延迟2秒）-> ratings
                \
                 -> details
```

此时，为reviews服务添加请求超时时间：

```plain
$ kubectl -n bookinfo edit vs reviews
 ...
   http:
   - match:
     - headers:
         end-user:
           exact: luffy
     route:
     - destination:
         host: reviews
         subset: v2
     timeout: 1s
   - route:
     - destination:
         host: reviews
         subset: v3
 ...
```

此使的调用关系为：

```plain
productpage -（0.5秒超时）-> reviews v2 -（延迟2秒）-> ratings
                \
                 -> details
```

此时，如果使用非luffy用户，则会出现只延迟，不会失败的情况。

删除延迟：

 $ kubectl -n bookinfo delete vs ratings

###### 状态码

```plain
$ cat virtualservice-details-aborted.yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: VirtualService
 metadata:
   name: details
   namespace: bookinfo
 spec:
   hosts:
   - details
   http:
   - fault:
       abort:
         percentage:
           value: 50
         httpStatus: 500
     route:
     - destination:
         host: details
 
 $ kubectl apply -f virtualservice-details-aborted.yaml
 
 # 再次刷新查看details的状态，查看productpage的日志
 $ kubectl -n bookinfo logs -f $(kubectl -n bookinfo get po -l app=productpage -ojsonpath='{.items[0].metadata.name}') -c istio-proxy
 [2020-11-09T09:00:16.020Z] "GET /details/0 HTTP/1.1" 500 FI "-" "-" 0 18 0 - "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36" "f0387bb6-a445-922c-89ab-689dfbf548f8" "details:9080" "-" - - 10.111.67.169:9080 10.244.0.52:56552 - -
```

#### 可观察性

###### 安装集成组件

<https://istio.io/latest/docs/ops/integrations>

1. Grafana $ kubectl apply -f samples/addons/grafana.yaml
2. Jaeger $ kubectl apply -f samples/addons/jaeger.yaml
3. Kiali
4. Prometheus $ kubectl apply -f samples/addons/prometheus.yaml

```plain
# 完善扩展组件地址：
 grafana url: "http://grafana.istio.com"
 tracing url: "http://jaeger.istio.com"
 $ kubectl apply -f samples/addons/kiali.yaml
```

##### prometheus

Prometheus：

```plain
$ cat prometheus-ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: prometheus
   namespace: istio-system
 spec:
   rules:
   - host: prometheus.istio.com
     http:
       paths:
       - backend:
           serviceName: prometheus
           servicePort: 9090
         path: /
 status:
   loadBalancer: {}
 
 $ kubectl apply -f prometheus-ingress.yaml
```

查看默认添加的targets列表：

<!-- OCR_START -->
- Prometheus
- Alerts Graph
- StatusHelp
- Targets
- AlI
- Unhealthy
- kubernetes-apiservers（1/1up)
- showmore
- kubernetes-nodes (2/2 up)
- kubernetes-nodes-cadvisor (2/2 up)
- kubernetes-pods (18/18up)
- kubernetes-pods-slow (0/0 up)
- kubernetes-service-endpoints(2/2up)
- kubernetes-service-endpoints-slow (0/0 up)
- kubernetes-services(o/0up)
- prometheus (1/1 up)
- prometheus-pushgateway(o/0up)
<!-- OCR_END -->

其中最核心的是kubernetes-pods 的监控，服务网格内的每个服务都作为一个target被监控，而且服务流量指标直接由sidecar容器来提供指标。

```plain
$ kubectl -n bookinfo get po -owide
 $ curl 10.244.0.53:15020/stats/prometheus
```

对于这些监控指标采集的数据，可以在grafana中查看到。

```plain
$ cat grafana-ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: grafana
   namespace: istio-system
 spec:
   rules:
   - host: grafana.istio.com
     http:
       paths:
       - backend:
           serviceName: grafana
           servicePort: 3000
         path: /
 status:
   loadBalancer: {}
 
 
 $ for i in $(seq 1 10000); do curl -s -o /dev/null "http://bookinfo.com/productpage"; done
```

访问界面后，可以查看到Istio Mesh Dashboard等相关的dashboard，因为在grafana的资源文件中， 中以 ConfigMap 的形式挂载了 Istio各个组件的仪表盘 JSON 配置文件：

```plain
$ kubectl -n istio-system get cm istio-services-grafana-dashboards
 NAME                                DATA   AGE
 istio-services-grafana-dashboards   3      7d1h
```

##### jaeger

```plain
$ cat jaeger-ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: jaeger
   namespace: istio-system
 spec:
   rules:
   - host: jaeger.istio.com
     http:
       paths:
       - backend:
           serviceName: tracing
           servicePort: 80
         path: /
 status:
   loadBalancer: {}
 
 $ kubectl apply -f jaeger-ingress.yaml
```

##### kiali

kiali 是一个 可观测性分析服务

```plain
$ cat kiali-ingress.yaml
 apiVersion: extensions/v1beta1
 kind: Ingress
 metadata:
   name: kiali
   namespace: istio-system
 spec:
   rules:
   - host: kiali.istio.com
     http:
       paths:
       - backend:
           serviceName: kiali
           servicePort: 20001
         path: /
 status:
   loadBalancer: {}
 
 $ kubectl apply -f kiali-ingress.yaml
```

集成了Prometheus、grafana、tracing、log、

#### 展望未来

Kubernets已经成为了容器调度编排的事实标准，而容器正好可以作为微服务的最小工作单元，从而发挥微服务架构的最大优势。所以我认为未来微服务架构会围绕Kubernetes展开。而Istio和Conduit这类Service Mesh天生就是为了Kubernetes设计，它们的出现补足了Kubernetes在微服务间服务通讯上的短板。虽然Dubbo、Spring Cloud等都是成熟的微服务框架，但是它们或多或少都会和具体语言或应用场景绑定，并只解决了微服务Dev层面的问题。若想解决Ops问题，它们还需和诸如Cloud Foundry、Mesos、Docker Swarm或Kubernetes这类资源调度框架做结合：

<!-- OCR_START -->
- DevOpsExperience
- AutoScaling&SelfHealing
- Resilience&FaultTolerance
- Kubernetes
- DistributedTracing
- Centralized Metrics
- Centralized Logging
- APIGateway
- JobManagement
- SingletonApplication
- ring
- LoadBalancing
- ServiceDiscovery
- Cloud
- ConfigurationManagement
- ApplicationPackaging
- Deployment&Scheduling
- ProcessIsolation
- EnvironmentManagement
- ResourceManagement
- OperatingSystem
- laaS
- Virtualization
- Hardware,Storage,Networking
<!-- OCR_END -->

但是这种结合又由于初始设计和生态，有很多适用性问题需要解决。

Kubernetes则不同，它本身就是一个和开发语言无关的、通用的容器管理平台，它可以支持运行云原生和传统的容器化应用。并且它覆盖了微服务的Dev和Ops阶段，结合Service Mesh，它可以为用户提供完整端到端的微服务体验。

所以我认为，未来的微服务架构和技术栈可能是如下形式：

<!-- OCR_START -->
- APIGateway
- 服务网格
- Istio
- CONDUIT
- 容器调度编排
- kubernetes
- 容器Runtime
- rkt
- runc
- docker
- kata
- ontainer:
- 基础设施层
- aws
- 阿里云
- openstack
- 腾讯云
<!-- OCR_END -->

多云平台为微服务提供了资源能力（计算、存储和网络等），容器作为最小工作单元被Kubernetes调度和编排，Service Mesh管理微服务的服务通信，最后通过API Gateway向外暴露微服务的业务接口。

未来随着以Kubernetes和Service Mesh为标准的微服务框架的盛行，将大大降低微服务实施的成本，最终为微服务落地以及大规模使用提供坚实的基础和保障。

#### 小结

* 第一代为Spring Cloud为代表的服务治理能力，是和业务代码紧耦合的，没法跨编程语言去使用
* 为了可以实现通用的服务治理能力，istio会为每个业务pod注入一个sidecar代理容器

<!-- OCR_START -->
- Proxy
- docker
- CircuitBreaker
- Rate limiting
- Tracing
- Metrics
- Service A
- ServiceB
- php
- Business logic
- Java
<!-- OCR_END -->

* 为了能够做到服务治理，需要接管pod内的出入流量，因此通过注入的时候引入初始化容器istio-init实现pod内防火墙规则的初始化，分别将出入站流量拦截到pod内的15001和15006端口
* 同时，注入了istio-proxy容器，利用envoy代理，监听了15001和15006端口，对流量进行处理

<!-- OCR_START -->
- 生成
- envoy-revo.js
- Pilot-agent
- on
- 静态配置
- 启动
- (文件)
- 动态配置
- Envoy
- Pilot
- (xDS接口)
<!-- OCR_END -->

* istio在istio-system命名空间启动了istiod服务，用于监听用户写入etcd中的流量规则，转换成envoy可度的配置片段，通过envoy支持的xDS协议，同步到网格内的各envoy中
* envoy获取规则后，做reload，直接应用到了用户期望的转发行为
* envoy提供了强大的流量处理规则，包含了流量路由、镜像、重试、熔断、故障注入等，同时，也内置了分布式追踪、Prometheus监控的实现，业务应用对于这一切都是感知不到的

最后，通过分析bookinfo中，从 Productpage服务调用Reviews服务的 请求流程 来回顾istio重点：

<!-- OCR_START -->
- Pod:Productpage
- Pod:Reviews
- (10.40.0.18)
- (10.40.0.15)
- Container:Productpage
- Container:Reviews
- Get http://reviews:9080/reviews/0
- iptables
- Container:Envoy
- 13
- Endpoint:
- 127.0.0.1:9080
- ISTIO_OUTPUT
- Inbound Cluster:
- ISTIO REDIRECT
- inbound|9080|http|reviews.
- Port:15001
- virtuallnbound
- Listener:virtualOutbound
- filter_chains
- Filter:
- Http_connection_manager
- Outbound Listener:
- 0.0.0.0_9080
- Http Filter:envoy.router
- Http Filter.
- ........
- Http Filter:mixer
- Http Filter:istio_authn
- Port:15006
- Route:9080
- ISTIOINREDIRECT
- Outbound Cluster:
- outbound|9080llreviews...
- ISTIO_INBOUND
- 10.40.0.15:9080
- PREROUTING
<!-- OCR_END -->

1. Productpage发起对Reviews服务的调用：http://reviews:9080/reviews/0
2. 请求被Productpage Pod的iptable规则拦截，重定向到本地的15001端口
3. 15001端口上监听的Envoy Virtual Outbound Listener收到了该请求
4. 请求被Virtual Outbound Listener根据原目标IP（通配）和端口（9080）转发到0.0.0.0_9080这个 outbound listener
5. 根据0.0.0.0_9080 listener的http_connection_manager filter配置,该请求采用“9080” route进行分发
6. 9080的route中，根据domains进行匹配，将请求交给 outbound|9080|v2|reviews.bookinfo.svc.cluster.local这个cluster处理
7. 该cluster为EDS
8. 查寻EDS对应的endpoint列表
9. envoy进程得到了最终需要访问的地址（reviews-v3的podip：port），由envoy做proxy转发出去
10. 此时，虽然还是会走一遍envoy的防火墙规则，但是由于是1337用户发起的请求，因此不会被再次拦截，直接走kubernetes的集群网络发出去
11. 请求到达reviews-v3， 被iptable规则拦截，重定向到本地的15006端口
12. 被监听在15006端口的envoy进程处理
13. VirtualInbound不再转给别的监听器，根据自身过滤器链的匹配条件，请求被Virtual Inbound Listener内部配置的Http connection manager filter处理 ， 该filter设置的路由配置为将其发送给 inbound|9080|http|reviews.bookinfo.svc.cluster.local这个inbound的cluster

```plain
# OUTPUT 链：将所有出站数据包跳转到 ISTIO_OUTPUT 链上。
 Chain OUTPUT (policy ACCEPT 46 packets, 3926 bytes)
 pkts bytes target     prot opt in     out     source               destination
    8   480 ISTIO_OUTPUT  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0
 
 # ISTIO_OUTPUT 链：选择需要重定向到 Envoy（即本地） 的出站流量，所有非 localhost 的流量全部转发到 ISTIO_REDIRECT。为了避免流量在该 Pod 中无限循环，所有到 istio-proxy 用户空间的流量都返回到它的调用点中的下一条规则，本例中即 OUTPUT 链，因为跳出 ISTIO_OUTPUT 规则之后就进入下一条链 POSTROUTING。如果目的地非 localhost 就跳转到 ISTIO_REDIRECT；如果流量是来自 istio-proxy 用户空间的，那么就跳出该链，返回它的调用链继续执行下一条规则（OUTPUT 的下一条规则，无需对流量进行处理）；所有的非 istio-proxy 用户空间的目的地是 localhost 的流量就跳转到 ISTIO_REDIRECT。
 Chain ISTIO_OUTPUT (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 RETURN     all  --  *      lo      127.0.0.6            0.0.0.0/0
    0     0 ISTIO_IN_REDIRECT  all  --  *      lo      0.0.0.0/0           !127.0.0.1            owner UID match 1337
    0     0 RETURN     all  --  *      lo      0.0.0.0/0            0.0.0.0/0            ! owner UID match 1337
    8   480 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0            owner UID match 1337
    0     0 ISTIO_IN_REDIRECT  all  --  *      lo      0.0.0.0/0           !127.0.0.1            owner GID match 1337
    0     0 RETURN     all  --  *      lo      0.0.0.0/0            0.0.0.0/0            ! owner GID match 1337
    0     0 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0            owner GID match 1337
    0     0 RETURN     all  --  *      *       0.0.0.0/0            127.0.0.1
    0     0 ISTIO_REDIRECT  all  --  *      *       0.0.0.0/0            0.0.0.0/0
 
 # ISTIO_REDIRECT 链：将所有流量重定向到 Sidecar（即本地） 的 15001 端口。
 Chain ISTIO_REDIRECT (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            redir ports 15001
```

```plain
$ istioctl pc listener productpage-v1-785b4dbc96-2cw5v.bookinfo --port 15001 -ojson|more
 [
    {
        "name": "virtualOutbound",
        "address": {
            "socketAddress": {
                "address": "0.0.0.0",
                "portValue": 15001
            }
        },
 ...
```

```plain
$ istioctl pc listener productpage-v1-785b4dbc96-2cw5v.bookinfo --port 9080 -ojson
 [
    {
        "name": "0.0.0.0_9080",
        "address": {
            "socketAddress": {
                "address": "0.0.0.0",
                "portValue": 9080
            }
        },
        "filterChains": [
            {
                "filterChainMatch": {
                    "applicationProtocols": [
                        "http/1.0",
                        "http/1.1",
                        "h2c"
                    ]
                },
                "filters": [
                    {
                        "name": "envoy.filters.network.http_connection_manager",
                        "typedConfig": {
                            "statPrefix": "outbound_0.0.0.0_9080",
                            "rds": {
                                "configSource": {
                                    "ads": {},
                                    "resourceApiVersion": "V3"
                                },
                                "routeConfigName": "9080"
                            },
```

```plain
$ istioctl pc route productpage-v1-785b4dbc96-2cw5v.bookinfo --name 9080 -ojson
 ...
             {
                 "name": "reviews.bookinfo.svc.cluster.local:9080",
                 "domains": [
                     "reviews.bookinfo.svc.cluster.local",
                     "reviews.bookinfo.svc.cluster.local:9080",
                     "reviews",
                     "reviews:9080",
                     "reviews.bookinfo.svc.cluster",
                     "reviews.bookinfo.svc.cluster:9080",
                     "reviews.bookinfo.svc",
                     "reviews.bookinfo.svc:9080",
                     "reviews.bookinfo",
                     "reviews.bookinfo:9080",
                     "10.109.133.236",
                     "10.109.133.236:9080"
                 ],
                 "routes": [
                     {
                         "match": {
                             "prefix": "/",
                             "caseSensitive": true,
                             "headers": [
                                 {
                                     "name": "end-user",
                                     "exactMatch": "luffy"
                                 }
                             ]
                         },
                         "route": {
                             "cluster": "outbound|9080|v2|reviews.bookinfo.svc.cluster.local",
                             "timeout": "1s",
```

```plain
$ istioctl pc cluster productpage-v1-785b4dbc96-2cw5v.bookinfo --fqdn reviews.bookinfo.svc.cluster.local --direction outbound -ojson
 ...
         "name": "outbound|9080|v3|reviews.bookinfo.svc.cluster.local",
         "type": "EDS",
         "edsClusterConfig": {
             "edsConfig": {
                 "ads": {},
                 "resourceApiVersion": "V3"
             },
             "serviceName": "outbound|9080|v3|reviews.bookinfo.svc.cluster.local"
         },
         "connectTimeout": "10s",
         "lbPolicy": "RANDOM",
         "circuitBreakers": {
             "thresholds": [
                 {
                     "maxConnections": 4294967295,
                     "maxPendingRequests": 4294967295,
                     "maxRequests": 4294967295,
                     "maxRetries": 4294967295
                 }
             ]
         },
```

```plain
$ istioctl pc endpoint productpage-v1-785b4dbc96-2cw5v.bookinfo --cluster "outbound|9080|v3|reviews.bookinfo.svc.cluster.local" -ojson
 [
     {
         "name": "outbound|9080|v3|reviews.bookinfo.svc.cluster.local",
         "addedViaApi": true,
         "hostStatuses": [
             {
                 "address": {
                     "socketAddress": {
                         "address": "10.244.0.37",
                         "portValue": 9080
                     }
                 },
 ...
```

```plain
# PREROUTING 链：用于目标地址转换（DNAT），将所有入站 TCP 流量跳转到 ISTIO_INBOUND 链上。
 Chain PREROUTING (policy ACCEPT 148 packets, 8880 bytes)
  pkts bytes target     prot opt in     out     source               destination
   148  8880 ISTIO_INBOUND  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0
 
 # INPUT 链：处理输入数据包，非 TCP 流量将继续 OUTPUT 链。
 Chain INPUT (policy ACCEPT 148 packets, 8880 bytes)
  pkts bytes target     prot opt in     out     source               destination
 
 # ISTIO_INBOUND 链：将所有入站流量重定向到 ISTIO_IN_REDIRECT 链上，目的地为 15090，15020，15021端口的流量除外，发送到以上两个端口的流量将返回 iptables 规则链的调用点，即 PREROUTING 链的后继 POSTROUTING。
 Chain ISTIO_INBOUND (1 references)
  pkts bytes target     prot opt in     out     source               destination
     0     0 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15008
     0     0 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
     0     0 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15090
   143  8580 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15021
     5   300 RETURN     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:15020
     0     0 ISTIO_IN_REDIRECT  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0
 
 # ISTIO_IN_REDIRECT 链：将所有入站流量跳转到本地的 15006 端口，至此成功的拦截了流量到sidecar中。
 Chain ISTIO_IN_REDIRECT (3 references)
  pkts bytes target     prot opt in     out     source               destination
     0     0 REDIRECT   tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            redir ports 15006
```

```plain
$ istioctl pc listener reviews-v3-6c7d64cd96-75f4x.bookinfo --port 15006 -ojson|more
 [
     {
         "name": "virtualInbound",
         "address": {
             "socketAddress": {
                 "address": "0.0.0.0",
                 "portValue": 15006
             }
         },
 ...
```

```plain
{
                 "filterChainMatch": {
                     "destinationPort": 9080
                 },
                 "filters": [
                     {
                         "name": "istio.metadata_exchange",
                         "typedConfig": {
                             "@type": "type.googleapis.com/udpa.type.v1.TypedStruct",
                             "value": {
                                 "protocol": "istio-peer-exchange"
                             }
                         }
                     },
                     {
                         "name": "envoy.filters.network.http_connection_manager",
                         "typedConfig": {
                             "statPrefix": "inbound_0.0.0.0_9080",
                             "routeConfig": {
                                 "name": "inbound|9080|http|reviews.bookinfo.svc.cluster.local",
                                 "virtualHosts": [
                                     {
                                         "name": "inbound|http|9080",
                                         "domains": [
                                             "*"
                                         ],
                                         "routes": [
                                             {
                                                 "name": "default",
                                                 "match": {
                                                     "prefix": "/"
                                                 },
                                                 "route": {
                                                     "cluster": "inbound|9080|http|reviews.bookinfo.svc.cluster.local",
                                                     "timeout": "0s",
                                                     "maxGrpcTimeout": "0s"
                                                 }
```

1. inbound|9080|http|reviews.bookinfo.svc.cluster.local配置的endpoint为本机的127.0.0.1:9080,因此转发到Pod内部的Reviews服务的9080端口进行处理。

```plain
$ istioctl pc endpoint reviews-v3-6c7d64cd96-75f4x.bookinfo --cluster "inbound|9080|http|reviews.bookinfo.svc.cluster.local" -ojson
 [
     {
         "name": "inbound|9080|http|reviews.bookinfo.svc.cluster.local",
         "addedViaApi": true,
         "hostStatuses": [
             {
                 "address": {
                     "socketAddress": {
                         "address": "127.0.0.1",
                         "portValue": 9080
                     }
                 },
```

> 更新: 2022-12-22 15:14:08  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/qatqhuqqepntqiv3>