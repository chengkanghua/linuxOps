<font style="color:rgb(53, 53, 53);">LVS（Linux Virtual Server）即Linux虚拟服务器，是由章文嵩博士主导的开源负载均衡项目，目前LVS已经被集成到Linux内核模块中。该项目在Linux内核中实现了基于IP的数据请求负载均衡调度方案，其体系结构如图1所示。</font>![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-01.webp)

+ <font style="color:rgb(53, 53, 53);">官网地址：http://www.linuxvirtualserver.org/</font>

<font style="color:rgb(53, 53, 53);">LVS 是基于 Linux 内核中 netfilter 框架实现的负载均衡系统，所以要学习 LVS 之前必须要先简单了解 netfilter 基本工作原理。更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

#### <font style="color:black;">netfilter基本原理</font>
<font style="color:rgb(53, 53, 53);">netfilter 其实很复杂也很重要，平时我们说的 Linux 防火墙就是 netfilter，不过我们平时操作的都是 iptables，iptables 只是用户空间编写和传递规则的工具而已，真正工作的是 netfilter。通过下图可以简单了解下 netfilter 的工作机制：</font>![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-02.webp)<font style="color:rgb(53, 53, 53);">netfilter 是内核态的 Linux 防火墙机制，作为一个通用、抽象的框架，提供了一整套的 hook 函数管理机制，提供诸如数据包过滤、网络地址转换、基于协议类型的连接跟踪的功能。</font>

<font style="color:rgb(53, 53, 53);">通俗点讲，就是 netfilter 提供一种机制，可以在数据包流经过程中，根据规则设置若干个关卡（hook 函数）来执行相关的操作。netfilter 总共设置了 5 个点，包括：PREROUTING、INPUT、FORWARD、OUTPUT、POSTROUTING。</font>

+ <font style="color:rgb(53, 53, 53);">PREROUTING ：刚刚进入网络层，还未进行路由查找的包，通过此处；</font>
+ <font style="color:rgb(53, 53, 53);">INPUT ：通过路由查找，确定发往本机的包，通过此处；</font>
+ <font style="color:rgb(53, 53, 53);">FORWARD ：经路由查找后，要转发的包，在POST_ROUTING之前；</font>
+ <font style="color:rgb(53, 53, 53);">OUTPUT ：从本机进程刚发出的包，通过此处；</font>
+ <font style="color:rgb(53, 53, 53);">POSTROUTING ：进入网络层已经经过路由查找，确定转发，将要离开本设备的包，通过此处；</font>

<font style="color:rgb(53, 53, 53);">当一个数据包进入网卡，经过链路层之后进入网络层就会到达 PREROUTING，接着根据目标 IP 地址进行路由查找，如果目标 IP 是本机，数据包继续传递到 INPUT 上，经过协议栈后根据端口将数据送到相应的应用程序；应用程序处理请求后将响应数据包发送到 OUTPUT 上，最终通过 POSTROUTING 后发送出网卡。如果目标 IP 不是本机，而且服务器开启了 forward 参数，就会将数据包递送给 FORWARD 上，最后通过 POSTROUTING 后发送出网卡。</font>

## <font style="color:rgb(34, 34, 34);">LVS 的组成及作用</font>
<font style="color:rgb(53, 53, 53);">lvs由两部分的程序组成:ipvs和ipvsadm。</font>

#### <font style="color:black;">ipvs</font>
<font style="color:rgb(53, 53, 53);">ipvs(ip virtual server):LVS是基于内核态的Netfilter 框架实现的IPVS功能,工作在内核态,用户配置vip等相关信息并传递到IPVS就需要用到ipvsadm工具。</font>

#### <font style="color:black;">ipvsadm</font>
<font style="color:rgb(53, 53, 53);">ipvsadm: 是lvs用户态的配套工具,可以实现vip和rs的增删改查功能,是基于Netlink或者raw socket方式与内核lvs进行通信的, 如果 LVS 类比于 Netfilter，那 ipvsadm 就是类似 iptables 工具的地位。更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

## <font style="color:rgb(34, 34, 34);">LVS 特性</font>
+ <font style="color:rgb(53, 53, 53);">工作在网络两层、三层、四层之上，仅作分发之用，CPU 和 内存消耗很低，特别在 DR 模式下，流量会走向后端服务器的网卡，这种方式可以媲美硬件负载</font>
+ <font style="color:rgb(53, 53, 53);">内核直接集成，配置性比较低，没有复杂的配置项</font>
+ <font style="color:rgb(53, 53, 53);">应用范围比较广，因为工作在两层、三层、四层最底层，几乎可以对所有应用做负载，包括 HTTP、数据库等，负载策略多样：3种工作模式、10种调度算法</font>
+ <font style="color:rgb(53, 53, 53);">LVS 不支持七层的虚拟主机、Rewrite 正则表达式、动静分离等功能，这也是负载软件种 nginx、HAproxy 的优势所在</font>
+ <font style="color:rgb(53, 53, 53);">LVS 适合中大型架构种，不适合中小型应用</font>

#### <font style="color:black;">LVS相关术语</font>
+ <font style="color:rgb(53, 53, 53);">DS：Director Server。指的是前端负载均衡器节点。</font>
+ <font style="color:rgb(53, 53, 53);">RS：Real Server。后端真实的工作服务器。</font>
+ <font style="color:rgb(53, 53, 53);">VIP：向外部直接面向用户请求，作为用户请求的目标的IP地址。</font>
+ <font style="color:rgb(53, 53, 53);">DIP：Director Server IP，主要用于和内部主机通讯的IP地址。</font>
+ <font style="color:rgb(53, 53, 53);">RIP：Real Server IP，后端服务器的IP地址。</font>
+ <font style="color:rgb(53, 53, 53);">CIP：Client IP，访问客户端的IP地址</font>

## <font style="color:rgb(34, 34, 34);">LVS 原理架构</font>
![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-03.webp)

+ <font style="color:rgb(53, 53, 53);">IPVS 虚拟出一个对外提供访问的 VIP 地址</font>
+ <font style="color:rgb(53, 53, 53);">用户通过这个 VIP 地址访问服务器</font>
+ <font style="color:rgb(53, 53, 53);">经过 VIP 到达负载调度器的内核空间</font>
+ <font style="color:rgb(53, 53, 53);">PREROUTING 链接受用户请求后，确定是本机 IP，将数据包发往 INPUT 链</font>
+ <font style="color:rgb(53, 53, 53);">用户请求到达 INPUT 链后，IPVS 会将用户请求和 IPVSadm 定义好的规则进行对比，如果用户请求的就是定义的集群服务，此时 IPVS 会强行修改数据包，并将新的数据包发往 POSTROUTING 链</font>
+ <font style="color:rgb(53, 53, 53);">POSTROUTING 链接收到数据包后发现目标 ip 地址刚好是自己的后端服务器，最终会发给后端服务器了</font>

## <font style="color:rgb(34, 34, 34);">LVS 三种工作模式</font>
#### <font style="color:black;">基于NAT的LVS模式负载均衡</font>
<font style="color:rgb(53, 53, 53);">NAT（Network Address Translation）即网络地址转换，其作用是通过数据报头的修改，使得位于企业内部的私有IP地址可以访问外网，以及外部用用户可以访问位于公司内部的私有IP主机。VS/NAT工作模式拓扑结构如图2所示，LVS负载调度器可以使用两块网卡配置不同的IP地址，eth0设置为私钥IP与内部网络通过交换设备相互连接，eth1设备为外网IP与外部网络联通。</font>![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-04.webp)<font style="color:rgb(53, 53, 53);">第一步，用户通过互联网DNS服务器解析到公司负载均衡设备上面的外网地址，相对于真实服务器而言，LVS外网IP又称VIP（Virtual IP Address），用户通过访问VIP，即可连接后端的真实服务器（Real Server），而这一切对用户而言都是透明的，用户以为自己访问的就是真实服务器，但他并不知道自己访问的VIP仅仅是一个调度器，也不清楚后端的真实服务器到底在哪里、有多少真实服务器。</font>

<font style="color:rgb(53, 53, 53);">第二步，用户将请求发送至124.126.147.168，此时LVS将根据预设的算法选择后端的一台真实服务器（192.168.0.1~192.168.0.3），将数据请求包转发给真实服务器，并且在转发之前LVS会修改数据包中的目标地址以及目标端口，目标地址与目标端口将被修改为选出的真实服务器IP地址以及相应的端口。</font>

<font style="color:rgb(53, 53, 53);">第三步，真实的服务器将响应数据包返回给LVS调度器，调度器在得到响应的数据包后会将源地址和源端口修改为VIP及调度器相应的端口，修改完成后，由调度器将响应数据包发送回终端用户，另外，由于LVS调度器有一个连接Hash表，该表中会记录连接请求及转发信息，当同一个连接的下一个数据包发送给调度器时，从该Hash表中可以直接找到之前的连接记录，并根据记录信息选出相同的真实服务器及端口信息。</font>

###### <font style="color:black;">NAT 模式的优缺点：</font>
+ <font style="color:rgb(53, 53, 53);">优点：</font>
    - <font style="color:rgb(53, 53, 53);">● 支持 Windows 操作系统；</font>
    - <font style="color:rgb(53, 53, 53);">● 支持端口映射，如 RS 服务器 PORT 与 VPORT 不一致的话，LVS 会修改目的 IP 地址和 DPORT 以支持端口映射；</font>
+ <font style="color:rgb(53, 53, 53);">缺点：</font>
    - <font style="color:rgb(53, 53, 53);">● RS 服务器需配置网关；</font>
    - <font style="color:rgb(53, 53, 53);">● 双向流量对 LVS 会产生较大的负载压力；带宽会成为瓶颈。</font>
+ <font style="color:rgb(53, 53, 53);">NAT 模式的使用场景：</font>
    - <font style="color:rgb(53, 53, 53);">● 对 windows 操作系统的用户比较友好，使用 LVS ，必须选择 NAT 模式。</font>



#### <font style="color:black;">基于DR的LVS负载均衡</font>
<font style="color:rgb(53, 53, 53);">在LVS（TUN）模式下，由于需要在LVS调度器与真实服务器之间创建隧道连接，这同样会增加服务器的负担。与LVS（TUN）类似，DR模式也叫直接路由模式，其体系结构如图4所示，该模式中LVS依然仅承担数据的入站请求以及根据算法选出合理的真实服务器，最终由后端真实服务器负责将响应数据包发送返回给客户端。</font>![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-05.webp)<font style="color:rgb(53, 53, 53);">与隧道模式不同的是，直接路由模式（DR模式）要求调度器与后端服务器必须在同一个局域网内，VIP地址需要在调度器与后端所有的服务器间共享，因为最终的真实服务器给客户端回应数据包时需要设置源IP为VIP地址，目标IP为客户端IP，这样客户端访问的是调度器的VIP地址，回应的源地址也依然是该VIP地址（真实服务器上的VIP），客户端是感觉不到后端服务器存在的。</font>

<font style="color:rgb(53, 53, 53);">由于多台计算机都设置了同样一个VIP地址，所以在直接路由模式中要求调度器的VIP地址是对外可见的，客户端需要将请求数据包发送到调度器主机，而所有的真实服务器的VIP地址必须配置在Non-ARP的网络设备上，也就是该网络设备并不会向外广播自己的MAC及对应的IP地址，真实服务器的VIP对外界是不可见的，但真实服务器却可以接受目标地址VIP的网络请求，并在回应数据包时将源地址设置为该VIP地址。调度器根据算法在选出真实服务器后，在不修改数据报文的情况下，将数据帧的MAC地址修改为选出的真实服务器的MAC地址，通过交换机将该数据帧发给真实服务器。整个过程中，真实服务器的VIP不需要对外界可见。</font>

<font style="color:rgb(53, 53, 53);">-------------------------------------------------------</font>

<font style="color:rgb(25, 27, 31);">在RS上修改内核参数以限制arp通告及应答级别；</font>

<font style="color:rgb(25, 27, 31);">修改RS上内核参数（arp_ignore和arp_announce）将RS上的VIP配置在lo接口的别名上，并限制其不能响应对VIP地址解析请求。</font>

<font style="color:rgb(25, 27, 31);">------------------------------------------------------</font>

###### <font style="color:black;">DR 模式的优缺点：</font>
+ <font style="color:rgb(53, 53, 53);">优点：</font>
    - <font style="color:rgb(53, 53, 53);">● 响应数据不经过 LVS，性能高；</font>
    - <font style="color:rgb(53, 53, 53);">● 对数据包修改小，信息完整性好；</font>
+ <font style="color:rgb(53, 53, 53);">缺点：</font>
    - <font style="color:rgb(53, 53, 53);">● LVS 与 RS 必须在同一个物理网络；</font>
    - <font style="color:rgb(53, 53, 53);">● RS 上必须配置 lo 和其他内核参数；</font>
    - <font style="color:rgb(53, 53, 53);">● 不支持端口映射；</font>
+ <font style="color:rgb(53, 53, 53);">DR 模式的使用场景：</font>
    - <font style="color:rgb(53, 53, 53);">● 对性能要求高的，可首选 DR 模式，还可透传客户端源 IP 地址。</font>

<font style="color:rgb(53, 53, 53);"></font>

#### <font style="color:black;">基于TUN的LVS负载均衡</font>
<font style="color:rgb(53, 53, 53);">在LVS（NAT）模式的集群环境中，由于所有的数据请求及响应的数据包都需要经过LVS调度器转发，如果后端服务器的数量大于10台，则调度器就会成为整个集群环境的瓶颈。我们知道，数据请求包往往远小于响应数据包的大小。因为响应数据包中包含有客户需要的具体数据，所以LVS（TUN）的思路就是将请求与响应数据分离，让调度器仅处理数据请求，而让真实服务器响应数据包直接返回给客户端。</font>![](img/LVS%20%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5-06.webp)<font style="color:rgb(53, 53, 53);">LVS/TUN工作模式拓扑结构如图3所示。其中，IP隧道（IP tunning）是一种数据包封装技术，它可以将原始数据包封装并添加新的包头（内容包括新的源地址及端口、目标地址及端口），从而实现将一个目标为调度器的VIP地址的数据包封装，通过隧道转发给后端的真实服务器（Real Server），通过将客户端发往调度器的原始数据包封装，并在其基础上添加新的数据包头（修改目标地址为调度器选择出来的真实服务器的IP地址及对应端口），LVS（TUN）模式要求真实服务器可以直接与外部网络连接，真实服务器在收到请求数据包后直接给客户端主机响应数据。</font>

###### <font style="color:black;">TUN 模式的优缺点：</font>
+ <font style="color:rgb(53, 53, 53);">优点：</font>
    - <font style="color:rgb(53, 53, 53);">● 单臂模式，LVS 负载压力小；</font>
    - <font style="color:rgb(53, 53, 53);">● 数据包修改小，信息完整性高；</font>
    - <font style="color:rgb(53, 53, 53);">● 可跨机房；</font>
+ <font style="color:rgb(53, 53, 53);">缺点：</font>
    - <font style="color:rgb(53, 53, 53);">● 不支持端口映射；</font>
    - <font style="color:rgb(53, 53, 53);">● 需在 RS 后端服务器安装模块及配置 VIP；</font>
    - <font style="color:rgb(53, 53, 53);">● 隧道头部 IP 地址固定，RS 后端服务器网卡可能会不均匀；</font>
    - <font style="color:rgb(53, 53, 53);">● 隧道头部的加入可能会导致分片，最终会影响服务器性能；</font>
+ <font style="color:rgb(53, 53, 53);">TUN 模式的使用场景：</font>
    - <font style="color:rgb(53, 53, 53);">● 如对转发性要求较高且具有跨机房需求的，可选择 TUN 模式。</font>

<font style="color:rgb(53, 53, 53);"></font>

<font style="color:rgb(53, 53, 53);"></font>

## <font style="color:rgb(53, 53, 53);">小结:</font>
1. NAT模式（Network Address Translation）

路由转发模式。在该模式下，负载均衡器不仅需要修改请求报文的目标地址，还需要修改响应报文的源地址，适用于小规模集群。

2. DR模式（Direct Routing）

直接路由模式。在该模式下，负载均衡器只修改请求报文的目标MAC地址，而不修改IP地址，后端服务器直接将响应报文发回客户端，适用于大规模集群。



3. TUN模式（IP Tunneling）

隧道模式。该模式通过IP隧道将请求转发到后端服务器，后端服务器直接将响应报文发回客户端，适用于地理位置分散的集群。



4. FULLNAT模式

通过同时修改请求报文的源IP地址和目标IP地址进行转发。阿里自己研发的FULL-NAT模式，



###### <font style="color:rgb(0, 0, 0);">TUN模式</font>
<font style="color:rgb(119, 119, 119);">TUN模式本质上同DR的方式一样，只是在Director和RealServer之间是通过IP隧道的方式去通信，一般这种方式只在企业需要在多个异地机房做调度时，可以采用这种方式，因此较为不常用。 </font>

###### <font style="color:rgb(0, 0, 0);">Full-NAT模式</font>
<font style="color:rgb(119, 119, 119);">这种方式同NAT的方式本质上也是一样的，不管是请求报文还是响应报文都要经过Director，唯一的区别是，NAT模式在发送给后端RealServer时，只是做目的IP地址和目的端口转换，而Full-NAT模型下是源目IP地址和源目端口都需要做转换.</font>

<font style="color:rgb(119, 119, 119);"></font>

<font style="color:rgb(119, 119, 119);">推荐</font>[https://blog.csdn.net/u010489158/article/details/86776691](https://blog.csdn.net/u010489158/article/details/86776691)



**LVS-NAT与LVS-FULLNAT：**

请求和响应报文都经由Director

LVS-NAT：RIP的网关要指向DIP

LVS-FULLNAT：RIP和DIP未必在同一IP网络，但要能通信



**LVS-DR与LVS-TUN：**

请求报文要经由Director，但响应报文由RS直接发往Client

LVS-DR：通过封装新的MAC首部实现，通过MAC网络转发

LVS-TUN：通过在原IP报文外封装新IP头实现转发，支持远距离通信

原文链接：[https://blog.csdn.net/weixin_51867896/article/details/123646168](https://blog.csdn.net/weixin_51867896/article/details/123646168)

## <font style="color:rgb(34, 34, 34);">LVS负载均衡调度算法</font>
<font style="color:rgb(53, 53, 53);">根据前面的介绍，我们了解了LVS的三种工作模式，但不管实际环境中采用的是哪种模式，调度算法进行调度的策略与算法都是LVS的核心技术，LVS在内核中主要实现了一下十种调度算法。更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

#### <font style="color:black;">轮询调度</font>
<font style="color:rgb(53, 53, 53);">轮询调度（Round Robin 简称'RR'）算法就是按依次循环的方式将请求调度到不同的服务器上，该算法最大的特点就是实现简单。轮询算法假设所有的服务器处理请求的能力都一样的，调度器会将所有的请求平均分配给每个真实服务器。</font>

#### <font style="color:black;">加权轮询调度</font>
<font style="color:rgb(53, 53, 53);">加权轮询（Weight Round Robin 简称'WRR'）算法主要是对轮询算法的一种优化与补充，LVS会考虑每台服务器的性能，并给每台服务器添加一个权值，如果服务器A的权值为1，服务器B的权值为2，则调度器调度到服务器B的请求会是服务器A的两倍。权值越高的服务器，处理的请求越多。</font>

#### <font style="color:black;">最小连接调度</font>
<font style="color:rgb(53, 53, 53);">最小连接调度（Least Connections 简称'LC'）算法是把新的连接请求分配到当前连接数最小的服务器。最小连接调度是一种动态的调度算法，它通过服务器当前活跃的连接数来估计服务器的情况。调度器需要记录各个服务器已建立连接的数目，当一个请求被调度到某台服务器，其连接数加1；当连接中断或者超时，其连接数减1。</font>

#### <font style="color:black;">加权最小连接调度</font>
<font style="color:rgb(53, 53, 53);">加权最少连接（Weight Least Connections 简称'WLC'）算法是最小连接调度的超集，各个服务器相应的权值表示其处理性能。服务器的缺省权值为1，系统管理员可以动态地设置服务器的权值。加权最小连接调度在调度新连接时尽可能使服务器的已建立连接数和其权值成比例。调度器可以自动问询真实服务器的负载情况，并动态地调整其权值。</font>

#### <font style="color:black;">基于局部的最少连接</font>
<font style="color:rgb(53, 53, 53);">基于局部的最少连接调度（Locality-Based Least Connections 简称'LBLC'）算法是针对请求报文的目标IP地址的负载均衡调度，目前主要用于Cache集群系统，因为在Cache集群客户请求报文的目标IP地址是变化的。</font>

#### <font style="color:black;">带复制的基于局部性的最少连接</font>
<font style="color:rgb(53, 53, 53);">带复制的基于局部性的最少连接（Locality-Based Least Connections with Replication  简称'LBLCR'）算法也是针对目标IP地址的负载均衡，目前主要用于Cache集群系统，它与LBLC算法不同之处是它要维护从一个目标IP地址到一组服务器的映射，而LBLC算法维护从一个目标IP地址到一台服务器的映射。按'最小连接'原则从该服务器组中选出一一台服务器，若服务器没有超载，将请求发送到该服务器；若服务器超载，则按'最小连接'原则从整个集群中选出一台服务器，将该服务器加入到这个服务器组中，将请求发送到该服务器。同时，当该服务器组有一段时间没有被修改，将最忙的服务器从服务器组中删除，以降低复制的程度。</font>

#### <font style="color:black;">目标地址散列调度</font>
<font style="color:rgb(53, 53, 53);">目标地址散列调度（Destination Hashing 简称'DH'）算法先根据请求的目标IP地址，作为散列键（Hash Key）从静态分配的散列表找出对应的服务器，若该服务器是可用的且并未超载，将请求发送到该服务器，否则返回空。</font>

#### <font style="color:black;">源地址散列调度U</font>
<font style="color:rgb(53, 53, 53);">源地址散列调度（Source Hashing  简称'SH'）算法先根据请求的源IP地址，作为散列键（Hash Key）从静态分配的散列表找出对应的服务器，若该服务器是可用的且并未超载，将请求发送到该服务器，否则返回空。它采用的散列函数与目标地址散列调度算法的相同，它的算法流程与目标地址散列调度算法的基本相似。</font>

#### <font style="color:black;">最短的期望的延迟</font>
<font style="color:rgb(53, 53, 53);">最短的期望的延迟调度（Shortest Expected Delay 简称'SED'）算法基于WLC算法。举个例子吧，ABC三台服务器的权重分别为1、2、3 。那么如果使用WLC算法的话一个新请求进入时它可能会分给ABC中的任意一个。使用SED算法后会进行一个运算：</font>

```plain
A：（1+1）/1=2   B：（1+2）/2=3/2   C：（1+3）/3=4/3
```

<font style="color:rgb(53, 53, 53);">就把请求交给得出运算结果最小的服务器。</font>

#### <font style="color:black;">最少队列调度</font>
<font style="color:rgb(53, 53, 53);">最少队列调度（Never Queue 简称'NQ'）算法，无需队列。如果有realserver的连接数等于0就直接分配过去，不需要在进行SED运算。</font>

<font style="color:rgb(53, 53, 53);">更多关于企业集群运维管理系列的学习文章，请参阅：</font>[<font style="color:rgb(53, 53, 53);">玩转企业集群运维管理</font>](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI0MDQ4MTM5NQ==&action=getalbum&album_id=3218136782744354820#wechat_redirect)<font style="color:rgb(53, 53, 53);">专栏，本系列持续更新中。</font>

_参考链接：https://blog.csdn.net/weixin_38738049_

_/article/details/125749863 https://blog.csdn.net_

_/weixin_40470303/article/details/80541639_

