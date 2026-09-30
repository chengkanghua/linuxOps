# VSphere之ESXi的安装及基本管理



   虚拟化和云计算技术正在快速的发展，新的概念、观点、产品不断涌现。服务器虚拟化技术受到了人们的高度重视，普遍相信虚拟化将成为数据中心的重要组成部分。vSphere是VMware公司推出的一套服务器虚拟化解决方案，占据了绝大多数的服务器虚拟化市场，只需极少的投资即可通过经济高效的服务器整合和业务连续性为公司提供企业级IT管理。



**虚拟化概述及****VMware VSphere****介绍**

#### 1、什么是虚拟化
    虚拟化就是把硬件资源从物理方式转变为逻辑方式，打破了物理硬件与操作系统及在其上运行的应用程序之间的硬性连接。使用户可以灵活的管理计算机资源，在一台计算机上同时运行多个操作系统，实现资源利用率最大化与灵活管理的一项技术。

    与物理机一样，虚拟机是运行操作系统和应用程序的软件计算机。管理程序用作虚拟机的运行平台，并且可以整合计算资源。每个虚拟机包含自己的虚拟（基于软件的）硬件，包括虚拟CPU、内存、硬盘和网络接口卡。

**例如：**x86计算机硬件被设计为只能运行单个操作系统，即使安装了众多应用程序，大多数硬件资源仍无法得到充分利用。而通过虚拟化可以在单台物理计算机上运行多个虚拟机，且所有虚拟机可在多种环境下共享该物理计算机的资源。在同一物理计算机上，不同的虚拟机可以独立、并行运行不同的操作系统和多个应用程序。下图所示的就是一台物理主机在虚拟化前和虚拟后的差别：

![1551077582760-dcb82092-d04b-421a-964c-491c3fb121ab.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-01.png)



**2、虚拟化的优势**

（1）减少服务器数量，降低硬件采购成本

（2）资源利用率最大化

（3）降低机房空间、散热、用电成本

（4）硬件资源可以动态调整，提高企业IT业务的灵活性

（5）高可用性

（6）在不中断服务的情况下，进行物理硬件调整

（7）降低管理成本

（8）具备更高效的灾备能力



#### 3、什么是vSphere
    vSphere是VMware公司在2011年基于云计算推出的一套企业级虚拟化解决方案，核心组件为ESX，现在已经被ESXi取代。该产品经历6个版本的改进，已经实现了虚拟化基础结构、高可用性、集中管理、性能监控等一体化解决方案，目前仍在不断扩张增强，功能越来越丰富，号称业界第一套云计算的操作系统。



#### 4、什么是ESXi
    ESXi是VMware服务器虚拟化体系的重要成员之一，也是VMware服务器虚拟化的基础，其实它本身也是一个操作系统，采用Linux内核（VMKernel），安装方式为裸金属方式，直接安装在物理服务器上，不需安装在其他操作系统。为了使它尽可能小的占用系统资源，同时又保证其高效稳定的运行，VMware将其进行精简封装。



#### 5、vSphere基础物理架构
    vSphere虚拟化解决方案拥有完整的基础物理架构，其5大组成部分为虚拟化服务器、网络服务、存储网络、集中式管理服务器、客户端

![1551077582733-2b94b248-7cbe-4ed3-8141-567ab6b8d6d1.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-02.png)

**（1）****虚拟化服务器**

   虚拟化服务器就是物理服务器，又称为x86服务器，通过网络服务器提供CPU和内存虚拟化资源，并且虚拟机都在上面运行。虚拟化服务器可由多个组成，并可在裸机硬件上直接安装ESXi 

**（2）****存储网络**

    虚拟化的核心，不但可用于存储虚拟化的所有数据，而且还和虚拟化的性能息息相关。存储资源由vSphere统一管理和分配。存储网络可使用SAN、NAS等存储技术

**（3）****网络服务**

    用于连接整个架构中的所有设备。 vSphere解决方案在网络带宽方面建议不低于千兆，否则很多功能不能达到理想的效果

**（4）****集中式管理服务器**

    集中式管理服务器（vCenter）是vSphere中的重要组件之一。vSphere很多高级功能都是通过vCenter实现的，如vMotion（不中断服务将虚拟机从一个ESXi迁移到另一个ESXi）、HA（ESXi宕机时，虚拟机自动迁移到另一个ESXi）等。不仅如此，vCenter还可以将多个ESXi放到一个集群中进行管理，虚拟机之间也可以资源共享

**（5）客户端**

    客户端（vClient）是vSphere中的重要组件之一，用于用户连接ESXi或vCenter管理和分配各种资源。vClient有两个版本，分别是vClient和Web vClient



#### 6、vSphere的版本
    为适应不同企业的需求，vSphere各版本功能不同，虚拟RAM也不同。并且集中式管理服务器（vCenter）是独立分开的

（1）标准版 Standard

    提供一套入门的解决方案，可实现最基本的服务器整合，在很大程度上削减硬件成本，同时保证业务的连续性，避免服务器停机

（2）企业版 Enterprise

     提供一套功能强大的解决方案，可以大幅度提供效率和资源管理，确保业务的连续性

（3）企业增强版 Enterprise Plus

     提供一套拥有全部功能的解决方案，拥有强大的灵活性、可操作性、稳定性、可控性，可以将数据中心转变为极为简化的云计算环境，也可以提供灵活可靠的新一代IT服务



#### 7、vSphere的许可
    ESXi安装后会有60天的评估期，用户可以在60天评估期内的任意时间转换为许可模式，vSphere许可证密钥都是按CPU个数计算的（2核和4核CPU均为一个CPU）,许可证密钥不固定ESXi主机，ESXi主机可任意组合分配。



#### 8、VMware ESXI 6.5 的安装教程
****

设置从IPMI Virtual Disk 3000启动，出现如下界面：

![1551077743318-f5935ff1-c73c-4fce-848d-153f40ade5e4.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-03.png)

默认选择第一项，回车安装

![1551077743350-bf881594-3bd4-42db-b0da-53d10a51947b.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-04.png)

安装程序正在检测服务器硬件信息，如果不满足系统安装条件会跳出错误提示。

检测完成之后会出现下面界面

![1551077743333-e6561a5b-62e8-4cde-b5d2-9fd209ccd545.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-05.png)

回车

![1551077743323-4c1167bb-16df-4f4f-91a0-71b806c4a0b4.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-06.png)

 按F11

 ![1551077743305-4659903f-783d-47d3-acde-810eda6d61c0.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-07.png)

这里列出了服务器硬盘信息，默认回车，出现下面界面

![1551077743510-ca80e9c7-5995-49e7-b4f5-a92cb8cfa049.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-08.png)

 回车

 ![1551077743306-dc185402-6783-4c02-8896-006a53f5fc47.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-09.png)

键盘模式，默认，回车

![1551077743310-80ae23f4-b3a7-4006-9ddb-a4767a17a91a.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-10.png)

服务器root账户密码设置（注意：密码长度7位以上）

![1551077743391-8c045efb-d203-4a7f-8772-e57e940c5897.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-11.png)

按F11开始安装

![1551077743375-5f595b2d-0d4c-4af3-a576-293ccfda6c7a.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-12.png)

正在安装中

安装完成之后会出现如下界面

![1551077743384-c6a96117-2ea0-487c-b3c5-edac891ced21.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-13.png)

安装完成，弹出镜像，回车重新启动系统。

![1551077743352-8cf4c45e-8c23-4ab2-aefb-2964c5c306ca.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-14.png)

系统正在重启中

设置硬盘启动

![1551077743365-12c765c9-655c-4ba0-a4e6-96fa1a8bb68c.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-15.png)

![1551077743428-260a3625-8d74-4e3e-ad20-d12bd404bf38.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-16.png)

![1551077743324-4a72448a-0fd4-4408-91a1-63b8f40bd17d.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-17.png)

系统启动完成，下面对ESXI进行设置

按F2出现下面界面

![1551077743331-f623a905-7cb9-4684-bc44-123d5c6d7c10.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-18.png)

输入root密码，回车

![1551077743365-278a2a16-09cb-43df-a418-f5a117ee2967.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-19.png)

![1551077743345-a83fa6b3-097a-40ad-992e-3560b3277fa9.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-20.png)

切换到Configure Management Network选项，回车

出现下面界面

 ![1551077743464-780fa0e3-06c1-4595-8ba3-c1b42b0925f3.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-21.png)

选择IPv4 Configuration 回车

![1551077743368-daee0ab1-8221-4355-a732-8392169716e2.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-22.png)

用空格选择第三项，设置为静态IP

输入相对应的IP、子网掩码、网关信息 回车

![1551077743373-03199073-e261-4eb1-8bea-493402e2c3b0.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-23.png)

继续选择DNS Configuration 回车

![1551077743362-ba92fb0e-c81d-4f00-b0e4-5b024fa771bb.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-24.png)

用空格选中第二项，使用自定义的DNS，填写DNS、Hostname 修改为你需要的名字

回车

![1551077743373-d42a02d2-a4e6-43fd-b7ba-63993fdb093b.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-25.png)

按ESC，输入Y保存上面的配置信息

继续按ESC 返回主界面

![1551077743359-03d449ba-a05b-4c5c-bc03-8f047589c812.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-26.png)

按F12 重启系统

![1551077743347-db4ace76-a61b-432c-931b-7b451adcb66c.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-27.png)

输入 root 密码 回车

![1551077743374-2a5d7dcc-aca1-4d5c-b1e7-faa52a4459bc.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-28.png)

按F11

![1551077743403-91d1b4d7-bef0-4683-9efd-67fd84dced96.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-29.png)

系统正在重新启动

重启之后，出现下面界面

![1551077743374-cf9537da-8092-4dc7-b4ab-075db73a2fc7.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-30.png)

至此，VMware ESXI 6.5安装完成，

 

选择不同的网卡

![1551077743380-04f973dc-b945-4a29-b910-0a0847c0a770.png](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-31.png)









#### 9 在ESXI里创建win7系统


<font style="color:#FF0000;">打开火狐游览器，输入esxi IP地址访问</font>

![1551077787914-aaa1e199-32d4-414b-a610-d21189e510cb.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-32.jpeg)



报错 ： 登陆之后报错

主机客户端引发未处理的异常：Error: [$rootScope:inprog] http://errors.angularjs.org/1.3.2/$rootScope/inprog?p0=%24digest (2150529)

官网详细说明： [https://kb.vmware.com/s/article/2150529?lang=zh_CN](https://kb.vmware.com/s/article/2150529?lang=zh_CN)

解决： 换一个浏览器， 使用谷歌浏览器



<font style="color:#FF0000;">选择创建虚拟机</font>

![1551077787928-ee07c565-6baa-475f-8932-e6c5d3f86074.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-33.jpeg)



<font style="color:#FF0000;">创建新虚拟机</font>

![1551077787924-a1696c0d-ca30-472c-a374-291d49073663.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-34.jpeg)



<font style="color:#FF0000;">填写相关信息</font>

![1551077787912-16c60843-c8d5-42d4-b3ab-a39e949466e3.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-35.jpeg)



<font style="color:#FF0000;">选择硬盘，继续下一步</font>

![1551077787970-6f9ba3a1-391e-46fd-8200-a8c75ce73d59.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-36.jpeg)





精简置备（thin）：

创建磁盘时，占用磁盘的空间大小根据实际使用量计算，即用多少分多少，提前不分配空间，对磁盘保留数据不置零，且最大不超过划分磁盘的大小。

所以当有I/O操作时，需要先分配空间，在将空间置零，才能执行I/O操作。当有频繁I/O操作时，磁盘性能会有所下降

I/O不频繁时，磁盘性能较好；I/O频繁时，磁盘性能较差。时间短，适合于对磁盘I/O不频繁的业务应用虚拟机



厚置备延迟置零：

默认的创建格式，创建磁盘时，直接从磁盘分配空间，但对磁盘保留数据不置零。所以当有I/O操作时，只需要做置零的操作。

磁盘性能较好，时间短，适合于做池模式的虚拟桌面



厚置备置零（thick）：

创建群集功能的磁盘。创建磁盘时，直接从磁盘分配空间，并对磁盘保留数据置零。所以当有I/O操作时，不需要等待直接执行。

磁盘性能最好，时间长，适合于做跑运行繁重应用业务的虚拟机。



<font style="color:#FF0000;">磁盘选择精简置备</font>

![1551077787931-9556fd46-d470-4ca4-8310-b775c6c42243.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-37.jpeg)



<font style="color:#FF0000;">点击完成</font>

![1551077787964-bb09254e-6e3e-41b2-a90b-62748eaeb3a6.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-38.jpeg)



<font style="color:#FF0000;">点击浏览存储数据器，上传iso</font>

![1551077787953-b6894d99-4368-47f5-99bb-d8c15e0eccca.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-39.jpeg)



<font style="color:#FF0000;">把win 7的ISO上传上去</font>

![1551077787944-75015027-dd23-40c6-87e4-352ad02fe5e2.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-40.jpeg)



<font style="color:#FF0000;">选择编辑设置</font>

![1551077787988-be8b9628-b85e-42e9-bf43-6bfdd54381e0.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-41.jpeg)



<font style="color:#FF0000;">指定ISO后 保存。</font>

![1551077787953-922d56cf-06fe-4342-8384-d083dbc4243a.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-42.jpeg)



<font style="color:#FF0000;">打开电源，打开控制台，进行安装系统。</font>

![1551077787950-cc6fa1ea-4618-494e-8dbf-859bad95e1d5.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-43.jpeg)



<font style="color:#FF0000;">进行安装系统。</font>

![1551077787943-2f2989dc-f74d-4aaf-9e82-d763954d0986.jpeg](img/VSphere%E4%B9%8BESXi%E7%9A%84%E5%AE%89%E8%A3%85%E5%8F%8A%E5%9F%BA%E6%9C%AC%E7%AE%A1%E7%90%86-44.jpeg)





参考文档：

[https://blog.51cto.com/laotang6/2044861](https://blog.51cto.com/laotang6/2044861)

[https://www.cnblogs.com/yunweis/p/7878049.html](https://www.cnblogs.com/yunweis/p/7878049.html)

[https://blog.51cto.com/yangshufan/1969073](https://blog.51cto.com/yangshufan/1969073)



> 更新: 2019-02-25 15:00:08  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/mdeoza>