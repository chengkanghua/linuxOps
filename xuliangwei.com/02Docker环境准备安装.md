# 02 Docker环境准备安装

# 02 Docker环境准备安装

* [1.CentOS安装Docker](http://class.xuliangwei.com/15285084954756.html#toc_0)
  * [1.1卸载旧版本Docker](http://class.xuliangwei.com/15285084954756.html#toc_1)
  * [1.2安装Docker容器](http://class.xuliangwei.com/15285084954756.html#toc_2)
  * [1.3卸载Docker容器](http://class.xuliangwei.com/15285084954756.html#toc_3)
* [2.配置Docker镜像加速](http://class.xuliangwei.com/15285084954756.html#toc_4)
* [3.配置Docker存储数据](http://class.xuliangwei.com/15285084954756.html#toc_5)
* [5.Docker常用命令列表](http://class.xuliangwei.com/15285084954756.html#toc_6)

> 徐亮伟, 江湖人称标杆徐。多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。擅长Web集群架构与自动化运维，曾负责国内某大型电商运维工作。
>
> 个人博客"[徐亮伟架构师之路](http://www.xuliangwei.com/)"累计受益数万人。
>
> 笔者Q:552408925、572891887 
>
> 架构师群:471443208

## 1.CentOS安装Docker

`Centos`环境安装`Docker`需要准备64位版本的`CentOS 7`操作系统，查看系统版本和内核版本命令如下：

```plain
[root@docker-server ~]# cat /etc/redhat-release
CentOS Linux release 7.4.1708 (Core)
[root@docker-server ~]# uname -r
3.10.0-693.el7.x86_64
```

### 1.1卸载旧版本Docker

为了保证与本书一致性，需要确保当前主机不存在旧版`Docker`软件，如果存在旧版本Docker软件，则需要进行卸载，卸载步骤如下：

1.检测本机是否存在较老版本的`docker`检测的命令如下:

```plain
[root@docker ~]# rpm -qa docker docker-engine
# 注意：如果执行后没有返回代表没有安装旧版本`Docker`则不需要进行后续的操作。
```

2.如果返回后有相关软件包，代表已安装旧版本`Docker`那么需要卸载该软件包以及相关的依赖包，卸载的命令如下:

```plain
[root@docker ~]# yum remove -y docker \
                  docker-common \
                  container-selinux \
                  docker-selinux \
                  docker-engine \
        docker-engine-selinux
#提示："\" 代表换行的意思。
```

### 1.2安装Docker容器

`Centos`安装`Docker`有如下三种方式：根据实际需要以不同的方式进行安装Docker。

> 1.设置Docker的仓库并从中安装，以方便安装和升级任务。 #推荐此方法。
>
> 2.更新CentOS操作系统，使用脚本自动化安装Docker。
>
> 3.使用国内阿里云开源仓库，进行获取、更新、下载并安装Docker。

1. 执行时间同步操作命令如下:

```plain
[root@docker ~]# yum install ntpdate -y
[root@docker ~]# ntpdate pool.ntp.org
```

2. 安装`yum-utils`它提供`yum-config-manager`实用程序，安装命令如下:

```plain
[root@docker ~]# yum install -y yum-utils device-mapper-persistent-data lvm2
```

3. 执行以下操作设置稳定仓库源，并更新yum缓存，执行命令如下：

```plain
[root@docker ~]# yum-config-manager \
--add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
[root@docker ~]# yum makecache fast
```

4. 安装最新版本的Docker，安装命令如下：

```plain
[root@docker ~]# yum install –y docker-ce
```

5. 启动`Docker`服务，并加入开机自启，配置命令如下：

```plain
[root@docker ~]# systemctl start docker
[root@docker ~]# systemctl enable docker
```

6. Docker通过运行hello-world 镜像验证是否正确安装，执行如下命令：

```plain
[root@docker ~]# docker run hello-world
latest: Pulling from library/hello-world
78445dd45222: Pull complete
Digest: sha256:c5515758d4c5e1e838e9cd307f6c6a0d620b5e07e6f927b07d05f6d12a1ac8d7
Status: Downloaded newer image for hello-world:latest
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

此命令完成的功能是下载测试镜像并在容器中运行它。当容器运行时，它打印一个`" Hello from Docker!"` 信息消息并退出，代表容器安装完成。

### 1.3卸载Docker容器

卸载已安装的Docker，进行如下操作步骤：

1. 卸载安装好的docker-ce软件包，执行如下命令：

```plain
[root@docker ~]# yum remove docker
```

2. 主机上的镜像，容器，卷或自定义配置文件不会自动删除。所以需要手动删除所有镜像，容器和卷，执行如下命令：

```plain
[root@docker ~]# rm -rf /var/lib/docker
```

3. 最后必须手动删除已编辑过的配置文件。

## 2.配置Docker镜像加速

我们在获取Docker镜像时，会出现无法下载，或者下载很慢的情况。下面将会演示如何使用国内阿里云镜像加速器进行镜像下载的加速。以CentOS系统为案例，操作步骤如下：

1. 注册阿里云账户，注册地址如下：

<https://account.aliyun.com/register/register.htm>

2. 访问阿里云的云端容器服务，并获取加速地址，访问地址如下：

<https://cr.console.aliyun.com/#/accelerator>

3. 通过修改配置文件"/etc/docker/daemon.json"使用阿里云加速器，配置操作如下：

```plain
[root@docker ~]# mkdir -p /etc/docker
[root@docker ~]# tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://q2gr04ke.mirror.aliyuncs.com"]
}
EOF
```

5. 重新加载载入docker服务

```plain
[root@docker ~]# systemctl daemon-reload
[root@docker ~]# systemctl restart docker
```

6. 检测Docker是否配置成功加速器，检测操作命令如下：

```plain
[root@docker ~]# docker info|grep -A1 "Registry Mirrors"
Registry Mirrors:
 https://q2gr04ke.mirror.aliyuncs.com/
```

容器镜像加速器的配置到此已经完成，现在你可以使用阿里云的镜像源进行加速了。

## 3.配置Docker存储数据

Docker默认存储路径"/var/lib/docker"，其中包括Docker的镜像、容器、日志等重要文件。

由于操作系统配置的系统盘存储空间较小且磁盘空间大小不易扩展，在生产环境中会将Docker存储的位置迁移至专门的数据存储盘，防止出现磁盘空间不足，导致容器运行时出现故障，给线上业务造成不必要的损失。

下面是将Docker存储镜像的位置迁移至新数据存储盘符的案例，这里我们假定data目录是新添加的存储盘并已经挂载，操作步骤如下：

1. 停止docker服务，命令如下：

```plain
[root@docker ~]# systemctl stop docker
```

2. 通过修改配置文件"/etc/docker/daemon.json"使用自定义存储位置云加速器，配置操作如下：

```plain
[root@docker ~]# cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://q2gr04ke.mirror.aliyuncs.com"],"graph": "/data/docker"
}
```

3. 拷贝原有数据，命令如下：

```plain
[root@docker ~]# mkdir /data
[root@docker ~]# cp -r /var/lib/docker /data
```

4. 重启docker服务，命令如下：

```plain
[root@docker ~]# systemctl start docker
```

5. 验证是否修改成功，命令如下：

```plain
[root@docker ~]# docker info|grep "Root"
Docker Root Dir: /data/docker
```

## 5.Docker常用命令列表

如表1-1所示，以下参数详情是docker配置选项，容器、镜像、仓库、网络

<!-- OCR_START -->
- Docker配置选项
- 选项
- 说明
- --help
- 打印使用
- -V, --version=false
- 打印版本信息并退出
- --config=~/.docker
- 客户端配置文件的位置
- -D, --debug=false
- 启用Debug调试模式
- -H, --host=[]
- 守护进程的套接字（Socket）连接
- -l, --log-level=info
- 设置日志级别
- --tls=false
- Use TLS; implied by --tlsverify
- --tlscacert=~/.docker/ca.pem
- 信任证书签名 CA
- --tlscert=~/.docker/cert.pem
- TLS 证书文件路径
- --tlskey=~/.docker/key.pem
- TLS 密钥文件路径
- --tlsverify=false
- 使用TLS验证远程
<!-- OCR_END -->

<!-- OCR_START -->
- Docker基础入门指令
- pull
- 从docker镜像源服务器拉取指定镜像或者库镜像
- push
- 推送指定镜像或者库镜像至docker源服务器
- search
- 在dockerhub中搜索镜像
- tag
- 给源中镜像打标签
<!-- OCR_END -->

<!-- OCR_START -->
- Docker容器相关指令
- create
- 创建一个新的容器，同run 但不启动容器
- 创建一个新的容器并运行一个命令
- start
- 启动容器
- pause
- 暂停容器
- unpause
- 取消暂停容器
- 停止容器
- 重启运行的容器
- rename
- 重命名容器
- kill
- kill指定docker容器
- ps
- 列出容器列表
- rm
- 移除一个或者多个容器
<!-- OCR_END -->

<!-- OCR_START -->
- Docker镜像相关指令
- images
- 列出系统当前镜像
- commit
- 提交当前容器为新的镜像
- build
- 通过Dockerfile定制镜像
- rmi
- 移除一个或多个镜像(无容器使用该镜像才可以删除，否则需要删除相
- 关容器才可以继续或者-f强制删除)
- history
- 展示一个镜像形成历史
- Docker仓库相关指令
- login
- 注册或者登陆一个docker源服务器
- logout
- 从当前Dockerregistry退出
- Docker网络相关指令
- port
- 查看映射端口对应的容器内部源端口
<!-- OCR_END -->

<!-- OCR_START -->
- Docker备份相关指令
- export
- 导出容器的内容流作为一个tar归档文件
- import
- 从tar 包中的内容创建一个新的文件系统映像(对应 export)
- save
- 保存一个镜像为一个tar包
- load
- 从一个tar包中加载一个镜像
<!-- OCR_END -->

<!-- OCR_START -->
- Docker运维相关指令
- top
- 查看容器中运行的进程信息
- status
- 统计容器使用资源
- inspect
- 查看容器详细信息
- info
- 显示系统相关信息
- version
- 查看容器版本号
- exec
- 在已存在的容器上运行命令
- logs
- 输出当前容器日志信息
- cp
- 从容器中拷贝指定文件或者目录到宿主机中
- attach
- 当前 shell下 attach 连接指定运行镜像
- events
- 从docker服务获取容器实时事件
- diff
- 查看docker 容器变化
- wait
- 截取容器停止时的退出状态值
<!-- OCR_END -->

> 更新: 2019-03-22 20:22:42  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/zivwn8>