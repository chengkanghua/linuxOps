# <font style="color:rgb(51, 51, 51);">任务背景</font>
<font style="color:rgb(51, 51, 51);">实现了远程的存储共享(NAS或SAN)后, 公司业务发展迅速, 存储空间还需要增大。使用NAS或SAN都不方便扩容，NAS可以增加新的挂载目录, SAN可以增加新的硬盘，但我们希望直接在原来挂载的业务目录上实现</font>**<font style="color:rgb(51, 51, 51);">在线扩容</font>**<font style="color:rgb(51, 51, 51);">，数据体量越来越大, 这个时候我们就可以考虑使用</font>**<font style="color:rgb(51, 51, 51);">==分布式存储==</font>**<font style="color:rgb(51, 51, 51);">了。</font>

![](img/2-分布式存储之glusterfs-01.png)

# <font style="color:rgb(51, 51, 51);">任务要求</font>
<font style="color:rgb(51, 51, 51);">1, 将远程</font>**<font style="color:rgb(51, 51, 51);">多台</font>**<font style="color:rgb(51, 51, 51);">服务器的空闲存储空间整合,</font>**<font style="color:rgb(51, 51, 51);">组合成一个大存储</font>**<font style="color:rgb(51, 51, 51);">给应用服务器(如apache,nginx,tomcat,mysql等)使用</font>

<font style="color:rgb(51, 51, 51);">2, 考虑高可用与负载均衡原则，并能实现在线扩容</font>

# <font style="color:rgb(51, 51, 51);">任务拆解</font>
<font style="color:rgb(51, 51, 51);">1, 了解分布式存储的概念与原理</font>

<font style="color:rgb(51, 51, 51);">2, 选择对应的分布式存储软件</font>

<font style="color:rgb(51, 51, 51);">3, 准备多台有空闲空间的服务器做存储服务器</font>

<font style="color:rgb(51, 51, 51);">4, 搭建集群将多台存储服务器组合</font>

<font style="color:rgb(51, 51, 51);">5, 将组合的大存储划分成卷共享给应用服务器使用</font>

<font style="color:rgb(51, 51, 51);">6, 实现在线扩容</font>

# **<font style="color:rgb(51, 51, 51);">学习目标</font>**
+ <font style="color:rgb(51, 51, 51);">能够说出分布式存储的优点</font>
+ <font style="color:rgb(51, 51, 51);">能够成功搭建glusterfs集群</font>
+ <font style="color:rgb(51, 51, 51);">掌握常见的glusterfs卷模式的创建与使用</font>
+ <font style="color:rgb(51, 51, 51);">能够对特定的glusterfs卷实现在线裁减或扩容</font>

# <font style="color:rgb(51, 51, 51);">分布式存储介绍</font>
<font style="color:rgb(51, 51, 51);">我们已经学习了NAS是远程通过网络共享</font>**<font style="color:rgb(51, 51, 51);">目录</font>**<font style="color:rgb(51, 51, 51);">, SAN是远程通过网络共享</font>**<font style="color:rgb(51, 51, 51);">块设备</font>**<font style="color:rgb(51, 51, 51);">。</font>

<font style="color:rgb(51, 51, 51);">那么分布式存储你可以看作</font>**<font style="color:rgb(51, 51, 51);">==拥有多台存储服务器连接起来的存储导出端==</font>**<font style="color:rgb(51, 51, 51);">。把这多台存储服务器的存储合起来做成一个整体再通过网络进行远程共享,共享的方式有目录(文件存储),块设备(块存储),对象网关或者说一个程序接口(对象存储)。</font>

<font style="color:rgb(51, 51, 51);">常见的分布式存储开源软件有:GlusterFS,Ceph,HDFS,MooseFS,FastDFS等。</font>

<font style="color:rgb(51, 51, 51);">分布式存储一般都有以下几个优点: </font>

1. <font style="color:rgb(51, 51, 51);">扩容方便，轻松达到PB级别或以上</font>
2. <font style="color:rgb(51, 51, 51);">提升读写性能(LB)或数据高可用(HA)</font>
3. <font style="color:rgb(51, 51, 51);">避免单个节点故障导致整个架构问题</font>
4. <font style="color:rgb(51, 51, 51);">价格相对便宜，大量的廉价设备就可以组成，比光纤SAN这种便宜很多</font>

# <font style="color:rgb(51, 51, 51);">Glusterfs</font>
## <font style="color:rgb(51, 51, 51);">glusterfs介绍</font>
<font style="color:rgb(51, 51, 51);">glusterfs是一个免费,开源的分布式文件系统（它属于</font>**<font style="color:rgb(51, 51, 51);">文件存储类型</font>**<font style="color:rgb(51, 51, 51);">）。</font>

[<font style="color:rgb(51, 51, 51);">https://www.gluster.org/</font>](https://www.gluster.org/)

## <font style="color:rgb(51, 51, 51);">raid级别回顾(拓展)</font>
<font style="color:rgb(51, 51, 51);">raid级别有很多种，下面主要介绍常用的几种:</font>

**<font style="color:rgb(51, 51, 51);">raid0</font>**<font style="color:rgb(51, 51, 51);"> 读写性能佳，坏了其中一块，数据挂掉，可靠性低（stripe条带化），磁盘利用率100％</font>

![](img/2-分布式存储之glusterfs-02.png)

**<font style="color:rgb(51, 51, 51);">raid1</font>**<font style="color:rgb(51, 51, 51);"> 镜像备份（mirror)，同一份数据完整的保存在多个磁盘上，写的性能不佳，可靠性高，读的性能还行，磁盘利用率50%</font><font style="color:rgb(51, 51, 51);">	</font>

![](img/2-分布式存储之glusterfs-03.png)

**<font style="color:rgb(51, 51, 51);">raid10</font>**<font style="color:rgb(51, 51, 51);"> 先做raid 1 再做raid 0</font>

![](img/2-分布式存储之glusterfs-04.png)

**<font style="color:rgb(51, 51, 51);">raid5</font>**<font style="color:rgb(51, 51, 51);"> 由多块磁盘做raid 5，磁盘利用率为n-1/n, 其中一块放校验数据，允许坏一块盘，数据可以利用校验值来恢复</font>

![](img/2-分布式存储之glusterfs-05.png)

**<font style="color:rgb(51, 51, 51);">raid6</font>**<font style="color:rgb(51, 51, 51);"> 在raid5的基础上再加一块校验盘，进一步提高数据可靠性</font>

![](img/2-分布式存储之glusterfs-06.png)

**<font style="color:rgb(51, 51, 51);">生产环境中最常用的为raid5和raid10</font>**

## <font style="color:rgb(51, 51, 51);">常见卷的模式</font>
| **<font style="color:rgb(51, 51, 51);">卷模式</font>** | **<font style="color:rgb(51, 51, 51);">描述</font>** |
| :--- | :--- |
| **<font style="color:rgb(51, 51, 51);">Replicated</font>** | <font style="color:rgb(51, 51, 51);">复制卷，类似raid1</font> |
| **<font style="color:rgb(51, 51, 51);">Striped(了解,新版本将会放弃此模式及其它相关的组合模式)</font>** | <font style="color:rgb(51, 51, 51);">条带卷，类似raid0</font> |
| **<font style="color:rgb(51, 51, 51);">Distributed</font>** | <font style="color:rgb(51, 51, 51);">分布卷</font> |
| **<font style="color:rgb(51, 51, 51);">Distribute Replicated</font>** | <font style="color:rgb(51, 51, 51);">分布与复制组合</font> |
| **<font style="color:rgb(51, 51, 51);">Dispersed</font>** | <font style="color:rgb(51, 51, 51);">纠删卷，类似raid5,raid6</font> |


**<font style="color:rgb(51, 51, 51);">glusterfs看作是一个将多台服务器存储空间组合到一起，再划分出不同类型的文件存储卷给导入端使用。</font>**

**<font style="color:rgb(51, 51, 51);"></font>**

**<font style="color:rgb(51, 51, 51);">Replicated卷</font>**

![](img/2-分布式存储之glusterfs-07.png)

**<font style="color:rgb(51, 51, 51);">Striped卷</font>**

![](img/2-分布式存储之glusterfs-08.png)

**<font style="color:rgb(51, 51, 51);">Distributed卷</font>**

![](img/2-分布式存储之glusterfs-09.png)

**<font style="color:rgb(51, 51, 51);">Distribute Replicated卷</font>**

![](img/2-分布式存储之glusterfs-10.png)

**<font style="color:rgb(51, 51, 51);">其它模式请参考官网</font>**<font style="color:rgb(51, 51, 51);">: </font>[<font style="color:rgb(51, 51, 51);">https://docs.gluster.org/en/latest/Administrator%20Guide/Setting%20Up%20Volumes/</font>](https://docs.gluster.org/en/latest/Administrator%20Guide/Setting%20Up%20Volumes/)

## <font style="color:rgb(51, 51, 51);">glusterfs集群</font>
**<font style="color:rgb(51, 51, 51);">实验准备:</font>**

![](img/2-分布式存储之glusterfs-11.png)

1. **<font style="color:rgb(51, 51, 51);">所有节点(包括client)</font>**<font style="color:rgb(51, 51, 51);">静态IP（NAT网络，能上外网）</font>
2. **<font style="color:rgb(51, 51, 51);">所有节点(包括client)</font>**<font style="color:rgb(51, 51, 51);">都配置主机名及其主机名互相绑定（这次我这里做了别名,方便使用)</font>

```bash
10.1.1.11   vm1.cluster.com     storage1
10.1.1.12   vm2.cluster.com     storage2
10.1.1.13   vm3.cluster.com     storage3
10.1.1.14   vm4.cluster.com     storage4
10.1.1.15   vm5.cluster.com     client
```

1. **<font style="color:rgb(51, 51, 51);">所有节点(包括client)</font>**<font style="color:rgb(51, 51, 51);">关闭防火墙,selinux</font>

```bash
# systemctl stop firewalld
# systemctl disable firewalld
# iptables -F
```

2. **<font style="color:rgb(51, 51, 51);">所有节点(包括client)</font>**<font style="color:rgb(51, 51, 51);">时间同步</font>
3. **<font style="color:rgb(51, 51, 51);">所有节点(包括client)</font>**<font style="color:rgb(51, 51, 51);">配置好yum(需要加上glusterfs官方yum源)</font>

```bash
cat > /etc/yum.repos.d/glusterfs.repo <<EOF
[glusterfs]
name=glusterfs
baseurl=https://buildlogs.centos.org/centos/7/storage/x86_64/gluster-4.1/
enabled=1
gpgcheck=0
EOF
```

<font style="color:rgb(51, 51, 51);">yum源说明:</font>

+ <font style="color:rgb(51, 51, 51);">可按照以上yum路径去查找</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">glusterfs5</font>`<font style="color:rgb(51, 51, 51);">或</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">glusterfs6</font>`<font style="color:rgb(51, 51, 51);">版本的yum源路径(目前我们使用4.1版)</font>
+ <font style="color:rgb(51, 51, 51);">如果网速太慢，可下载我共享的软件做本地yum源安装</font>

**<font style="color:rgb(51, 51, 51);">实验步骤:</font>**

1. <font style="color:rgb(51, 51, 51);">在所有storage服务器上安装相关软件包,并启动服务</font>
2. <font style="color:rgb(51, 51, 51);">所有storage服务器建立连接, 成为一个集群</font>
3. <font style="color:rgb(51, 51, 51);">所有storage服务器准备存储目录</font>
4. <font style="color:rgb(51, 51, 51);">创建存储卷</font>
5. <font style="color:rgb(51, 51, 51);">启动存储卷</font>
6. <font style="color:rgb(51, 51, 51);">client安装挂载软件</font>
7. <font style="color:rgb(51, 51, 51);">client挂载使用</font>

**<font style="color:rgb(51, 51, 51);">实验过程:</font>**

**<font style="color:rgb(51, 51, 51);">第1步, 在所有storage服务器上(不包括client)安装glusterfs-server软件包，并启动服务</font>**

```bash
下面的命令所有存储服务器都要做
yum install glusterfs-server

systemctl start glusterd
systemctl enable glusterd
systemctl status glusterd
```

<font style="color:rgb(51, 51, 51);">分布式集群一般有两种架构:</font>

+ <font style="color:rgb(51, 51, 51);">有中心节点的</font><font style="color:rgb(51, 51, 51);">	</font><font style="color:rgb(51, 51, 51);"> 中心节点一般指管理节点，后面大部分分布式集群架构都属于这一种</font>
+ <font style="color:rgb(51, 51, 51);">无中心节点的 所有节点又管理又做事,glusterfs属于这一种</font>

**<font style="color:rgb(51, 51, 51);">第2步, 所有storage服务器建立连接，成为一个集群</font>**

```bash
4个storage服务器建立连接不用两两连接，只需要找其中1个,连接另外3个各一次就OK了

下面我就在storage1上操作
storage1# gluster peer probe storage2       
storage1# gluster peer probe storage3
storage1# gluster peer probe storage4       --这里使用ip,主机名,主机名别名都可以

然后在所有存储上都可以使用下面命令来验证检查
# gluster peer status
```

**<font style="color:rgb(51, 51, 51);">==注意==</font>**<font style="color:rgb(51, 51, 51);">:</font>

<font style="color:rgb(51, 51, 51);">如果这一步建立连接有问题（一般问题会出现在网络连接,防火墙,selinux,主机名绑定等);</font>

<font style="color:rgb(51, 51, 51);">如果想重做这一步，可以使用gluster peer detach xxxxx [force] 来断开连接，重新做</font>

**<font style="color:rgb(51, 51, 51);">第3步, 所有storage服务器准备存储目录（可以用单独的分区，也可以使用根分区)</font>**

```bash
因为我让大家准备的storage服务器没有准备额外的硬盘，所以这里用根分区来做实验
但生产环境肯定是不建议数据盘和系统盘在一起的
# mkdir -p /data/gv0
```

**<font style="color:rgb(51, 51, 51);">第4步, 创建存储卷(在任意一个storage服务器上做)</font>**

**<font style="color:rgb(51, 51, 51);">==注意==</font>**<font style="color:rgb(51, 51, 51);">: ==改变的操作(create,delete,start,stop)等只需要在任意一个storage服务器上操作，查看的操作(info)等可以在所有storage服务器上操作==</font>

```bash
下面命令我是在storage1上操作的
因为在根分区创建所以需要force参数强制
replica 4表示是在4台上做复制模式(类似raid1)

storage1# gluster volume create gv0 replica 4 storage1:/data/gv0/ storage2:/data/gv0/ storage3:/data/gv0/ storage4:/data/gv0/ force
volume create: gv0: success: please start the volume to access data
```

```bash
所有storage服务器上都可以查看
# gluster volume info gv0
 
Volume Name: gv0
Type: Replicate             模式为replicate模式
Volume ID: 328d3d55-4506-4c45-a38f-f8748bdf1da6
Status: Created             这里状态为created,表示刚创建，还未启动,需要启动才能使用
Snapshot Count: 0
Number of Bricks: 1 x 4 = 4
Transport-type: tcp
Bricks:
Brick1: storage1:/data/gv0
Brick2: storage2:/data/gv0
Brick3: storage3:/data/gv0
Brick4: storage4:/data/gv0
Options Reconfigured:
transport.address-family: inet
nfs.disable: on
```

**<font style="color:rgb(51, 51, 51);">第5步, 启动存储卷</font>**

storage1# gluster volume start gv0

```bash
# gluster volume info gv0

Volume Name: gv0
Type: Replicate
Volume ID: 328d3d55-4506-4c45-a38f-f8748bdf1da6
Status: Started			现在看到状态变为started，那么就表示可以被客户端挂载使用了
Snapshot Count: 0
Number of Bricks: 1 x 4 = 4
Transport-type: tcp
Bricks:
Brick1: storage1:/data/gv0
Brick2: storage2:/data/gv0
Brick3: storage3:/data/gv0
Brick4: storage4:/data/gv0
Options Reconfigured:
transport.address-family: inet
nfs.disable: on
```

**<font style="color:rgb(51, 51, 51);">第6步, client安装软件</font>**

```bash
客户端上操作
yum install glusterfs glusterfs-fuse -y

# 客户端和服务
yum install glusterfs-libs-4.1.0-1.el7.x86_64
yum install glusterfs-fuse-4.1.0
```

<font style="color:rgb(51, 51, 51);">说明:</font>

<font style="color:rgb(51, 51, 51);">fuse(Filesystem in Userspace): 用户空间文件系统,是一个客户端挂载远程文件存储的模块</font>

**<font style="color:rgb(51, 51, 51);">第7步, client挂载使用</font>**

**<font style="color:rgb(51, 51, 51);">==注意==:</font>**<font style="color:rgb(51, 51, 51);">客户端也需要在/etc/hosts文件里绑定存储节点的主机名，才可以挂载（因为我前面做的步骤是用名字的)</font>

```bash
client# mkdir /test0
client# mount -t glusterfs storage1:gv0 /test0

这里client是挂载storage1，也可以挂载storage2,storage3,storage4任意一个。（也就是说这4个storage既是老板,又是员工。这是glusterfs的一个特点，其它的分布式存储软件基本上都会有专门的管理server)
```

## **<font style="color:rgb(51, 51, 51);">replica卷测试</font>**
<font style="color:rgb(51, 51, 51);">读写测试方法:</font>

<font style="color:rgb(51, 51, 51);">在客户端使用dd命令往挂载目录里写文件，然后查看在storage服务器上的分布情况(具体验证详细过程参考授课视频)</font>

<font style="color:rgb(51, 51, 51);">(</font>**<font style="color:rgb(51, 51, 51);">==注意: 读写操作请都在客户端进行，不要在storage服务器上操作==</font>**<font style="color:rgb(51, 51, 51);">)</font>

client# dd if=/dev/zero of=/test0/file1 bs=1M count=100

1. <font style="color:rgb(51, 51, 51);">读写测试结果: 结果类似raid1</font>
2. <font style="color:rgb(51, 51, 51);">同读同写测试: 有条件的可以再开一台虚拟机做为client2，两个客户端挂载gv0后实现同读同写(文件存储类型的特点)</font>

![](img/2-分布式存储之glusterfs-12.png)

<font style="color:rgb(51, 51, 51);">运维思想: </font>

<font style="color:rgb(51, 51, 51);">搭建OK后,你要考虑性能,稳定, 高可用，负载均衡，健康检查, 扩展性等</font>

<font style="color:rgb(51, 51, 51);">如果某一个节点挂了,你要考虑是什么挂了(网卡,服务,进程,服务器关闭了),如何解决?</font>

<font style="color:rgb(51, 51, 51);">请测试如下几种情况:</font>

+ <font style="color:rgb(51, 51, 51);">将其中一个storage节点关机</font>

客户端需要等待10几秒钟才能正常继续使用,再次启动数据就正常同步过去

+ <font style="color:rgb(51, 51, 51);">将其中一个storage节点网卡down掉</font>

客户端需要等待10几秒钟才能正常继续使用,再次启动数据就正常同步过去

+ <font style="color:rgb(51, 51, 51);">将其中一个storage节点glusterfs相关的进程kill掉</font>

客户端无需等待就能正常继续使用,但写数据不会同步到挂掉的storage节点,等它进程再次启动就可以同步过去了

<font style="color:rgb(51, 51, 51);">结论: 作为一名运维工程师，HA场景有不同的挂法:</font>

+ <font style="color:rgb(51, 51, 51);">服务器关闭</font>
+ <font style="color:rgb(51, 51, 51);">网卡坏了</font>
+ <font style="color:rgb(51, 51, 51);">网线断了</font>
+ <font style="color:rgb(51, 51, 51);">交换机挂了</font>
+ <font style="color:rgb(51, 51, 51);">服务进程被误杀等等</font>

<font style="color:rgb(51, 51, 51);">但我们需要去考虑，当软件无法把我们全自动实现时，我们可能需要使用脚本来辅助。有一个简单的方法为: 如果一个节点没死透，我们就干脆将它关机，让它死透</font><font style="color:rgb(51, 51, 51);">😂</font>

<font style="color:rgb(51, 51, 51);">请参考拓展: RHCS,pacemaker里的fence,stonish(shoot the other node in the head)等概念。</font>

## **<font style="color:rgb(51, 51, 51);">卷的删除</font>**
**<font style="color:rgb(51, 51, 51);">第1步: 先在客户端umount已经挂载的目录(在umount之前把测试的数据先删除)</font>**

```bash
client# rm /test0/* -rf   		
client# umount /test0
```

**<font style="color:rgb(51, 51, 51);">第2步: 在任一个storage服务器上使用下面的命令停止gv0并删除，我这里是在storage1上操作</font>**

```bash
storage1# gluster volume stop gv0
Stopping volume will make its data inaccessible. Do you want to continue? (y/n) y
volume stop: gv0: success

storage1# gluster volume delete gv0 
Deleting volume will erase all information about the volume. Do you want to continue? (y/n) y
volume delete: gv0: success
```

**<font style="color:rgb(51, 51, 51);">第3步: 在所有storage服务器上都可以查看，没有gv0的信息了，说明这个volumn被删除了</font>**

```bash
# gluster volume info gv0 
Volume gv0 does not exist
```

**<font style="color:rgb(51, 51, 51);">问题:</font>**<font style="color:rgb(51, 51, 51);"> 我在不删除gv0的情况下，能否再创建一个叫gv1的卷? </font>

当然可以,换个目录再创建就OK

## **<font style="color:rgb(51, 51, 51);">stripe模式</font>**<font style="color:rgb(51, 51, 51);">(条带)</font>
**<font style="color:rgb(51, 51, 51);">第1步: 再重做成stripe模式的卷(重点是命令里的stripe 4参数)(在任一个storage服务器上操作, 我这里是在storage1上操作）</font>**

```bash
storage1# gluster volume create gv0 stripe 4 storage1:/data/gv0/ storage2:/data/gv0/ storage3:/data/gv0/ storage4:/data/gv0/ force
volume create: gv0: success: please start the volume to access data
```

**<font style="color:rgb(51, 51, 51);">第2步: 启动gv0(在任一个storage服务器上操作, 我这里是在storage1上操作）</font>**

storage1# gluster volume start gv0

**<font style="color:rgb(51, 51, 51);">第3步: 客户端挂载</font>**

client# mount -t glusterfs storage1:gv0 /test0

**<font style="color:rgb(51, 51, 51);">第4步:读写测试</font>**

**<font style="color:rgb(51, 51, 51);">读写测试结果:</font>**<font style="color:rgb(51, 51, 51);"> 文件过小,不会平均分配给存储节点。有一定大小的文件会平均分配。类似raid0。</font>

+ <font style="color:rgb(51, 51, 51);">磁盘利率率100%(前提是所有节点提供的空间一样大，如果大小不一样，则按小的来进行条带)</font>
+ <font style="color:rgb(51, 51, 51);">大文件会平均分配给存储节点（LB）</font>
+ <font style="color:rgb(51, 51, 51);">没有HA，挂掉一个存储节点，此stripe存储卷则不可被客户端访问</font>

## **<font style="color:rgb(51, 51, 51);">distributed模式</font>**
**<font style="color:rgb(51, 51, 51);">第1步: 准备新的存储目录(所有存储服务器上都要操作)</font>**

# mkdir -p /data/gv1

**<font style="color:rgb(51, 51, 51);">第2步: 创建distributed卷gv1(不指定replica或stripe就默认是Distributed的模式, 在任一个storage服务器上操作, 我这里是在storage1上操作)</font>**

storage1# gluster volume create gv1 storage1:/data/gv1/ storage2:/data/gv1/ storage3:/data/gv1/ storage4:/data/gv1/ force

**<font style="color:rgb(51, 51, 51);">第3步: 启动gv1(在任一个storage服务器上操作, 我这里是在storage1上操作)</font>**

storage1# gluster volume start gv1

**<font style="color:rgb(51, 51, 51);">第4步: 客户端挂载</font>**

```bash
client# mkdir /test1
client# mount -t glusterfs storage1:gv1 /test1
```

**<font style="color:rgb(51, 51, 51);">第5步:读写测试(测试方法与replica模式一样，具体过程参考授课视频)</font>**

**<font style="color:rgb(51, 51, 51);">读写测试结果:</font>**<font style="color:rgb(51, 51, 51);"> 测试结果为随机写到不同的存储里，直到所有写满为止。</font>

+ <font style="color:rgb(51, 51, 51);">利用率100%</font>
+ <font style="color:rgb(51, 51, 51);">方便扩容</font>
+ <font style="color:rgb(51, 51, 51);">不保障的数据的安全性(挂掉一个节点,等待大概1分钟后,这个节点就剔除了,被剔除的节点上的数据丢失)</font>
+ <font style="color:rgb(51, 51, 51);">也不提高IO性能</font>

## **<font style="color:rgb(51, 51, 51);">distributed-replica模式</font>**
**<font style="color:rgb(51, 51, 51);">第1步: 准备新的存储目录(所有存储服务器上都要操作)</font>**

# mkdir -p /data/gv2

**<font style="color:rgb(51, 51, 51);">第2步:</font>****<font style="color:rgb(51, 51, 51);">创建distributed-replica卷gv2(在任一个storage服务器上操作, 我这里是在storage1上操作)</font>**

storage1# gluster volume create gv2 replica 2 storage1:/data/gv2/ storage2:/data/gv2/ storage3:/data/gv2/ storage4:/data/gv2/ force  

**<font style="color:rgb(51, 51, 51);">第3步: 启动gv2(在任一个storage服务器上操作, 我这里是在storage1上操作)</font>**

storage1# gluster volume start gv2

**<font style="color:rgb(51, 51, 51);">第4步: 客户端挂载</font>**

```bash
client# mkdir /test2
client# mount -t glusterfs storage1:gv2 /test2
```

**<font style="color:rgb(51, 51, 51);">第5步:读写测试</font>**

**<font style="color:rgb(51, 51, 51);">读写测试结果:</font>**<font style="color:rgb(51, 51, 51);"> 4个存储分为两个组，这两个组按照distributed模式随机。但在组内的两个存储会按replica模式镜像复制。</font>

<font style="color:rgb(51, 51, 51);">特点:</font>

+ <font style="color:rgb(51, 51, 51);">结合了distributed与replica的优点:可以扩容，也有HA特性</font>

## <font style="color:rgb(51, 51, 51);">dispersed模式</font>
<font style="color:rgb(51, 51, 51);">disperse卷是v3.6版本后发布的一种卷模式，类似于raid5/6</font>

**<font style="color:rgb(51, 51, 51);">第1步: 准备新的存储目录(所有存储服务器上都要操作)</font>**

# mkdir -p /data/gv3

**<font style="color:rgb(51, 51, 51);">第2步:</font>****<font style="color:rgb(51, 51, 51);">创建卷gv3(在任一个storage服务器上操作, 我这里是在storage1上操作)</font>**

```bash
storage1# gluster volume create gv3 disperse 4 storage1:/data/gv3/ storage2:/data/gv3/ storage3:/data/gv3/ storage4:/data/gv3/ force
There is not an optimal redundancy value for this configuration. Do you want to create the volume with redundancy 1 ? (y/n) y
volume create: gv3: success: please start the volume to access data

注意:没有指定冗余值，默认为1，按y确认
```

**<font style="color:rgb(51, 51, 51);">第3步: 启动gv3(在任一个storage服务器上操作, 我这里是在storage1上操作)</font>**

```bash
storage1# gluster volume start gv3

storage1# gluster volume info gv3
Volume Name: gv3
Type: Disperse					
Volume ID: 767add4e-48c4-4a2d-a5d1-467076d73afd
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x (3 + 1) = 4				这里看到冗余数为1
Transport-type: tcp
Bricks:
Brick1: storage1:/data/gv3
Brick2: storage2:/data/gv3
Brick3: storage3:/data/gv3
Brick4: storage4:/data/gv3
Options Reconfigured:
transport.address-family: inet
nfs.disable: on
```

**<font style="color:rgb(51, 51, 51);">第4步: 客户端挂载</font>**

```bash
client# mkdir /test3
client# mount -t glusterfs storage1:gv3 /test3
```

**<font style="color:rgb(51, 51, 51);">第5步:读写测试(测试方法与replica模式一样，具体过程参考授课视频)</font>**

<font style="color:rgb(51, 51, 51);">读写测试结果: 写100M,每个存储服务器上占33M左右。因为4个存储1个为冗余(与raid5一样)。</font>

**<font style="color:rgb(51, 51, 51);">课后测试:</font>**<font style="color:rgb(51, 51, 51);"> 如果想要实现2个冗余，则最少需要5台存储服务器</font>

```bash
# gluster volume create gv4 disperse 4 redundancy 2 storage1:/data/gv4/ storage2:/data/gv4/ storage3:/data/gv4/ storage4:/data/gv4/ force
redundancy must be less than 2 for a disperse 4 volume
这里指定disperse 4 redundancy 2参数，但报错为冗余值必须要比disperse值少2以上
```

## **<font style="color:rgb(51, 51, 51);">在线裁减与在线扩容</font>**
<font style="color:rgb(51, 51, 51);">在线裁减要看是哪一种模式的卷,比如stripe模式就不允许在线裁减。下面我以distributed卷来做裁减与扩容</font>

**<font style="color:rgb(51, 51, 51);">在线裁减</font>**<font style="color:rgb(51, 51, 51);">(注意要remove没有数据的brick)</font>

```bash
# gluster volume remove-brick gv1 storage4:/data/gv1 force  
Removing brick(s) can result in data loss. Do you want to Continue? (y/n) y
volume remove-brick commit force: success
```

**<font style="color:rgb(51, 51, 51);">在线扩容</font>**

```bash
# gluster volume add-brick gv1 storage4:/data/gv1 force
volume add-brick: success
```

<font style="color:rgb(51, 51, 51);">问题1: 4个存储节点想扩容为5个存储节点怎么做?</font>

答案: 第5个存储服务器安装服务器软件包，启动服务，然后gluster peer probe storage5加入集群

<font style="color:rgb(51, 51, 51);">问题2: 一个卷里已经有4个brick，想在线扩容brick，怎么做?</font>

只有distributed模式或带有distributed组合的模式才能在线扩容brick

**<font style="color:rgb(51, 51, 51);">glusterfs小结:</font>**

<font style="color:rgb(51, 51, 51);">属于文件存储类型，优点:可以数据共享 缺点: 速度较低 </font>

**<font style="color:rgb(51, 51, 51);">卷类型:</font>**

<font style="color:rgb(51, 51, 51);">见xmind文件</font>

  
 

