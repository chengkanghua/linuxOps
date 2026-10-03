# day13 知识点串

> day13 综合知识点串讲：引号、路由追踪、端口/进程检查、find 结合 tar/cp、程序/进程/守护进程、vim 故障与快捷键、光盘挂载与 RPM、网卡/主机名/hosts、yum 组包、zip。

![知识点](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-01.png)

## 一、单引号 / 双引号 / 反引号

```bash
# 1 单引号：所见即所得，里面的内容原封不动输出
echo 'oldboy $LANG $PS1 $(hostname) `pwd`'
# oldboy $LANG $PS1 $(hostname) `pwd`

# 2 双引号：与单引号类似，但里面的特殊符号会被解析（运行）
echo "oldboy $LANG $PS1 $(hostname) `pwd`"
# oldboy en_US_UTF8 [\u@\h \W]\$ oldboy /oldboy

# 3 反引号：优先执行命令，类似 $( 命令 )
```

## 二、显示到目标之间每个路由是否通畅

- Windows：`tracert`
- Linux：`traceroute`

```bash
# 检查机房网络是否有故障（Windows）
[e:\~]$ tracert -d www.baidu.com
通过最多 30 个跃点跟踪
到 www.a.shifen.com [111.13.100.91] 的路由:
 1     2 ms     2 ms     2 ms  192.168.21.254
 2     3 ms     3 ms     3 ms  122.71.224.1
...
10     5 ms     6 ms     4 ms  111.13.100.91
跟踪完成。

# Linux
traceroute -d www.taobao.com
traceroute to www.taobao.com (101.37.183.171), 30 hops max, 60 byte packets
 1  * * *
 2  11.216.38.73 (11.216.38.73)  5.497 ms ...
```

## 三、检查 sshd 是否在运行

**两条思路**：① 检查端口 22（端口用来区分不同服务，22 端口 = sshd 服务）；② 检查进程是否运行。

```bash
# 查询/安装所需软件包
rpm -qa telnet nc nmap
yum install nc nmap telnet lrzsz -y

# 查询 22 端口是否在运行
telnet 10.0.0.200 22
# Trying 10.0.0.200...
# Connected to 10.0.0.200.
# SSH-2.0-OpenSSH_5.3

nc 10.0.0.200 22
# SSH-2.0-OpenSSH_5.3

# nmap 查询主机多个端口是否开启
nmap -p1-1024 主机名          # 查 1-1024 端口
nmap -p22,80,443 www.baidu.com
# PORT    STATE    SERVICE
# 22/tcp  filtered ssh
# 80/tcp  open     http
# 443/tcp open     https

# 查询本机 22 端口是否开启
ss -lntup | grep 22
netstat -lntup | grep 22
lsof -i:22
```

> 补充：`nc` 还能实现 Linux 与 Windows 之间的简单"聊天"（见下图）。
> ![nc聊天](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-02.png)

## 四、检查进程是否运行

```bash
ps -ef                          # 显示所有运行的进程
ps -ef | grep sshd
ps -ef | grep crond
ps -ef | egrep "sshd|crond"

# 判断数量
ps -ef | grep /sshd | wc -l
2

# 用 [s]sh 技巧避免 grep 自身被统计
ps -ef | grep /ss[h]
# root  918  1  0 May19 ?  00:00:00 /usr/sbin/sshd -D
```

> 杀死进程：`kill 2001`；查询该进程是否还在：`ps -ef | grep 2001`

## 五、find 实战：打包 / 复制

### 找出 /app/logs 下以 .log 结尾的文件（不区分大小写）打包备份到 /tmp/log.tar.gz
```bash
# 方法1
find /app/logs/ -type f -iname "*.log" | xargs tar zcvf /tmp/log.tar.gz

# 方法2
tar zcvf /tmp/log3.tar.gz $(find /app/logs/ -type f -iname "*.log")

# 方法3（-exec + 一次性传参）
find -type f -iname "*.log" -exec tar zcf /tmp/log2.tar.gz {} +;
```

### 找出 /app/logs 下以 .log 结尾的文件（不区分大小写）复制到 /tmp/ 下
```bash
mkdir -p /tmp/{a..d}

# 方法1：-t 指定目标目录，把前面所有源放到该目录
find /app/logs/ -type f -iname "*.log" | xargs cp -t /tmp/a

# 方法2：命令替换
cp `find /app/logs/ -type f -iname "*.log"` /tmp/b

# 方法3：-exec 逐个复制
find -type f -iname "*.log" -exec cp {} /tmp/c/ \;
```

## 六、程序 / 进程 / 守护进程

- **程序**：硬盘上的**静态文件**
- **进程**：程序运行后，内存中的**动态实例**
- **守护进程**：**后台长期运行、脱离终端、提供服务**的特殊进程（系统服务）

| 名称 | 状态 | 位置 | 生命周期 | 特点 | 例子 |
| --- | --- | --- | --- | --- | --- |
| **程序** | 静态 | 硬盘 | 永久存在（直到删除） | 只是文件，不运行 | nginx 执行文件、ls 命令 |
| **进程** | 动态 | 内存 | 运行 → 结束 → 销毁 | 有 PID，占用资源 | 执行 ping、ls 产生的进程 |
| **守护进程** | 动态 | 内存 | 长期运行（开机 → 关机） | 后台、无终端、系统服务 | sshd、mysql、nginx 服务 |

### 1. 程序（Program）—— 静态的代码
就是磁盘上的二进制文件/脚本，没有运行，一动不动。
- 本质：代码、指令的集合；状态：静态；位置：硬盘/U 盘
- 例子：`/usr/bin/ls`、`/usr/sbin/sshd`、`/root/test.sh`、nginx 执行文件

### 2. 进程（Process）—— 动态的实例
程序被加载到内存开始运行，就变成了进程。
- 本质：程序的执行过程；状态：动态
- 有唯一标识 **PID（进程号）**，占用内存/CPU
- 生命周期：运行开始 → 执行结束 → 销毁

### 3. 守护进程（Daemon）—— 后台"不死"进程
特殊的进程：后台运行、脱离终端、长期存活、开机自启，也叫**服务进程**。
- 后台运行，不占终端；关机才停；没有交互界面；都是系统服务
- 例子：sshd、nginx、mysql、crond、firewalld

```bash
# 查看守护进程（系统服务）
ps -ef | grep sshd
ps -ef | grep nginx
```

## 七、vim 故障与快捷键

### vim 故障原因
```
1. 编辑文件的时候断开连接
2. 多个窗口同时编辑一个文件
```

### 创建练习环境
```bash
cat /etc/services /etc/sysconfig/network-scripts/ifcfg-eth0 >>/tmp/vim.log
```
![vim故障](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-03.png)

### 解决办法
```bash
# 1. 未保存数据不要了
q                       # 退出编辑
ls -la                  # 显示隐藏文件
rm -rf .oldboy.txt.swp  # 命令行删除临时文件

# 2. 未保存数据必须要
q                       # 先退出编辑
vim -r oldboy.txt       # 命令行恢复数据
:wq                     # 恢复后保存退出
```
![vim恢复](img/day13%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2-04.png)

### vim 的三种模式
```bash
zz          # 保存并退出
# 第一种 命令模式：G  gg  i  a
# 第二种 编辑模式：i  o  C  A
# 第三种 底行模式：:
```

**命令模式（移动光标 / 复制删除粘贴）**
```bash
h j k l     # 左 下 上 右
gg          # 光标移到文件第一行
G           # 光标移到文件最后一行
100gg       # 到第 100 行
$           # 移到行尾
0           # 移到行首
yy          # 复制当前行
p           # 粘贴
3p          # 粘贴 3 次
dd          # 删除当前行（剪切）
dG          # 删除当前行到结尾的内容
```

**编辑模式**
```bash
o   # 当前行下面插入空行并进入编辑模式
O   # 当前行上面插入空行并进入编辑模式
C   # 删除光标到行尾并进入编辑模式
A   # 到行尾并进入编辑模式
D   # 删除光标到行尾（不进入编辑模式）
```

**底行模式**
```bash
:set nu            # 显示行号
:set nonu          # 取消行号
/搜索内容          # 回车搜索；n 向下查找，N 向上查找
:noh               # 临时取消语法高亮
:% s#ssh#lili#g    # s 替换，g 全局（替换所有）
```

**vim 帮助**
```bash
:help G
:help :noh
:q            # 退出帮助
```

**批量操作**
```bash
# 批量删除
1  ctrl + v        # 可视块模式
2  上下左右选择
3  按 d 删除所选内容

# 批量编辑（插入）
1  ctrl + v        # 可视块模式
2  上下左右选择
3  大写 I
4  编辑完成按 esc 等待
```

**用 sed 替换**
```bash
sed 's#ssh#oldboy#g' vim.log    # 也支持 's@@@g' / 's///g'
```

> 补充：防火墙 `iptables` 用于 CentOS 5.x/6.x，`firewalld` 用于 CentOS 7.x。

## 八、挂载光盘、rpm 安装软件

```bash
# 第1步 挂载光盘
mount /dev/cdrom /mnt/

# 第2步 检查
df -h

# 第3步 通过 rpm 命令安装软件
rpm -ivh /mnt/Packages/lrzsz-0.12.20-27.1.el6.x86_64.rpm

# 检查软件是否安装
rpm -qa tree
# tree-1.5.3-3.el6.x86_64

# 显示软件包内容（list）
rpm -ql tree
```

## 九、如何解压 RPM 包

> 参考：https://www.cnblogs.com/joeblackzqq/archive/2011/03/19/1989137.html

```plain
有时我们需要 RPM 包中的某个文件，如何解压 RPM 包呢？
RPM 是使用 cpio 格式打包的，因此可以先转成 cpio 然后解压：

rpm2cpio xxx.rpm | cpio -div

例如：
rpm2cpio csphere-controller-2.0.15.1-stable7facf03.x86_64.rpm | cpio -div
```

## 十、网卡配置文件

```bash
# /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
ONBOOT=yes
BOOTPROTO=static
#HWADDR=00:0C:29:59:D4:13
IPADDR=10.0.0.200
PREFIX=24          # NETMASK=255.255.255.0
GATEWAY=10.0.0.254
DNS1=223.5.5.5
DNS2=223.6.6.6
```

## 十一、如何修改主机名

```bash
hostname oldboy                       # 临时
echo "oldboy" > /etc/hostname         # 永久

hostnamectl set-hostname new_hostname # 等同于上面两条命令（推荐）

# CentOS 6 的配置文件（CentOS 7 已无）
cat /etc/sysconfig/network
# NETWORKING=yes
# HOSTNAME=oldboy
```

## 十二、hosts：主机名与域名解析

```bash
cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.0.0.200  oldboyedu50-lnb

ping oldboyedu50-lnb
ping `hostname`
```

## 十三、yum grouplist（软件包组）

```bash
yum grouplist
# Installed Groups:  已经安装的软件包组
#   Base / Compatibility libraries / Debugging Tools / Development tools
#   E-mail server / Graphical Administration Tools / ...
# Available Groups:  你还可以安装的软件包组
#   Additional Development / Backup Client / Backup Server / ...

# 安装组包
yum groupinstall 'Debugging Tools'
```

## 十四、zip 打包文件

```bash
zip /a/hosts.zip /etc/hosts
#  adding: etc/hosts (deflated 59%)

unzip /a/host.zip

# -r 打包目录
zip -r /tmp/a/etc.zip /etc/
```

> 更新: 2026-04-26 10:28:32
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/encyeg>
