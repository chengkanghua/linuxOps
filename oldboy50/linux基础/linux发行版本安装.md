# Linux 发行版本与系统安装

> 本文涵盖 Linux 发展史、系统组成、各发行版本区别、下载地址、学习环境、虚拟机与 CentOS 安装要点、磁盘分区规则、网络配置、无法上网排查、VMware 三种网络模式，以及 CentOS 6.9 字符集修改。

## 一、Linux 发展史

1. **1969 年**，贝尔实验室开发 **UNIX** 操作系统。
2. **谭宁邦**：1984 年因为 UNIX 规定"不能对学生提供源码"，谭宁邦老师自己编写了兼容 UNIX 的 **Minix** 用于教学。
3. **斯托曼（Stallman）**：1984 年发起 **GNU**（GNU's Not Unix）项目，创办 FSF 基金会。
   - 产品：GCC、Emacs、Bash Shell、GLIBC；倡导"自由软件"。
4. **托瓦兹（Linus Torvalds）**：1991 年，芬兰赫尔辛基大学研究生托瓦兹基于 gcc、bash 开发了针对 386 机器的 **Linux 内核**。

## 二、Linux 系统的组成

**操作系统就是人与硬件之间的中介、桥梁。**

![系统组成](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-01.png)

**Linux = Linux 内核 + 命令解释器 shell + 程序软件**

## 三、Linux 不同发行版本的区别

| 发行版 | 特点 / 使用场景 |
| --- | --- |
| **Ubuntu**（乌班图） | 开发人员使用，有操作界面，有点像 Windows |
| **RedHat**（红帽） | 国企、金融使用，收费；含 Red Hat Linux 9.0 与 RHEL 企业版（如 7.5） |
| **CentOS** | 国内最火爆、使用最多，免费 |
| **Fedora** | RedHat 的测试版，新功能新想法先放入 Fedora，稳定后再进 RedHat |
| **Debian / FreeBSD** | 安全性要求比较高 |
| **SUSE / OpenSUSE** | 德国，高级数据库、邮件服务 |
| **红旗 Linux / 中标麒麟** | 国产，国企使用 |

> 演进关系：**Fedora → RedHat → CentOS**

## 四、CentOS 与 RedHat 区别

1. **RedHat**：免费下载，但**项目收费、无法更新**。
2. **CentOS**：做到与红帽一模一样，只是
   - 去掉红帽的收费项目
   - 去掉红帽的 logo

## 五、32 位系统和 64 位系统的区别

**运算速度（通俗类比）**
- 32 位系统相当于 **4 车道马路**
- 64 位系统相当于 **8 车道马路**

**设计定位**
- 64 位主要给**服务器**使用，用于大量计算。

**从存储容量角度**
一个字的字长是 32/64 位。假设主存/高速缓存中有 a 个字块，一个字块有 b 个字，那么 32 位操作系统主存总容量为 32ab 字节，64 位为 64ab 字节。

**从寻址角度**
指操作系统拥有的最大寻址能力。32 位操作系统有 32 根地址总线，最大寻址能力为 2^32 = **4G**，所以它能读取的最大物理内存就是 4G。

> 当下 64 位操作系统已成为主流，32 位越来越少。

## 六、CentOS 下载地址

**国内镜像站**：<https://developer.aliyun.com/mirror/>

**CentOS 7 ISO 最新版（Minimal）**：
<https://mirrors.aliyun.com/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2207-02.iso>

**CentOS 官网归档**：<https://vault.centos.org/>

**VMware Workstation 官网**
> 现在 VMware 被博通（Broadcom）收购，并宣布 17.5 版本的 VMware Workstation Pro 对**个人用户免费**许可使用。需要有一个博通账号（可用 QQ 邮箱注册）；下载时地址等必填项可随便填，没有影响。

<https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro>

## 七、学习环境

- 虚拟机软件：**VMware Workstation 12.0 / 8.0**
- 计算机要求配置：**I5 处理器、8G 内存、500G 硬盘**

## 八、Linux 系统安装

### 创建虚拟机着重注意的两个地方

#### （1）安装过程中选择"稍后安装"

![稍后安装](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-02.png)
![稍后安装](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-03.png)
![稍后安装](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-04.png)

#### （2）最后一步创建虚拟机保存的位置，一般不放在 C 盘

### 安装 CentOS 系统过程注意的几个地方

#### 1. 系统镜像挂载的位置和"启动时连接"对勾要勾上

![镜像挂载](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-05.png)

#### 2. 安装过程注意时间问题
**UTO 选项的对勾记得要去掉**，不然会和计算机有时差。

#### 3. 安装分区注意事项

| 分区 | 作用 | 大小 |
| --- | --- | --- |
| `/boot` | 引导分区 | 200M |
| `swap` | 交换分区（内存不足时临时把 swap 当内存使用） | 内存 <8G → 1.5 倍；内存 ≥8G → 8G |
| `/` | 根分区（所有程序软件存放的位置） | 剩余多少给多少 |

> 生产环境中内存都很大（内存也便宜），**swap 可以不设置**。

#### 4. 安装好后配置网络
主要用到 `setup` 命令，进入图形界面配置 eth0 网卡。注意：
- **DHCP 要关掉**
- **On boot 要记得启动**

![网络配置](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-06.png)
![网络配置](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-07.png)
![网络配置](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-08.png)
![网络配置](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-09.png)
![网络配置](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-10.png)

> 看不到 next 按钮时使用快捷键 **F12**。

![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-11.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-12.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-13.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-14.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-15.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-16.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-17.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-18.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-19.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-20.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-21.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-22.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-23.png)
![安装步骤](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-24.png)

## 九、Linux 下磁盘分区规则

### 适用于数据不重要
```
/boot  引导分区   200M（CentOS 7 为 1G）
swap   交换分区   <8G → 1.5G；>=8G → 8G
/      根分区     剩余所有
```

### 适用于数据重要
```
/boot  引导分区   200M（CentOS 7 为 1G）
swap   交换分区   <8G → 1.5G；>=8G → 8G
/      根分区     20-200G
/data  数据分区   剩余所有（系统出问题时 data 区文件不会丢失）
```

### 适用于不知道文件重不重要
```
/boot  引导分区   200M（CentOS 7 为 1G）
swap   交换分区   <8G → 1.5G；>=8G → 8G
/      根分区     20-200G
剩余的不分配，留着谁使用谁分配
```

## 十、网络配置

![网络配置](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-25.png)
![网络配置](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-26.png)

> **vmnet8 地址应该是 10.0.0.254**

![vmnet8](img/linux%E5%8F%91%E8%A1%8C%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85-27.png)

## 十一、Linux 服务器无法上网排查过程

1. **IP 是否正确**
2. **网卡配置文件是否正确**
   - 网关配置错误
   - DNS
3. **VMware 虚拟网络编辑器**
   - 编辑 → 虚拟网络编辑器 → NAT 模式 → 子网 IP `10.0.0.0`
   - NAT 设置 → 网关 IP `10.0.0.254`
4. **VMware 服务**（win+r 输入 `services.msc`）

| 服务 | 状态 | 启动类型 |
| --- | --- | --- |
| VMware Authorization Service | 正在运行 / 已启动 | 自动 |
| VMware NAT Service | 正在运行 / 已启动 | 自动 |
| VMware DHCP Service | 正在运行 / 已启动 | 自动 |

**修复步骤**：
```bash
1. 重启 NAT service
2. 断开虚拟机网卡再连接上
3. Linux 系统里重启网络： systemctl restart network
```

## 十二、VMware 三种网络模式

### 一、桥接模式（Bridged，VMnet0）
**核心原理**：虚拟机虚拟网卡直接"桥接"到主机物理网卡（有线/无线），**相当于局域网里一台独立的真实电脑**，和主机平级、同网段。

### 二、NAT 模式（Network Address Translation，VMnet8）—— 最常用、默认
**核心原理**：VMware 内置虚拟 NAT 路由器 + DHCP，虚拟机处于**私有虚拟子网**，**共享主机的物理 IP 上网**，外部看不到虚拟机真实 IP。

### 三、仅主机模式（Host-Only，VMnet1）—— 封闭隔离
**核心原理**：仅创建**纯内部虚拟网络**，无 NAT、无外网出口，虚拟机只能和主机、同 Host-Only 的虚拟机通信，完全隔离物理网络与外网。

## 十三、CentOS 6.9 修改系统默认字符集

```bash
# locale -a        # 列出系统所支持的所有字符集

yum -y groupinstall chinese-support      # 安装中文支持包

# 修改方法：
# 1. 临时修改
export LANG=zh_CN.UTF8

# 2. 永久修改文件
vim /etc/sysconfig/i18n
LANG="zh_CN.UTF8"

source /etc/sysconfig/i18n              # 生效配置文件
```
