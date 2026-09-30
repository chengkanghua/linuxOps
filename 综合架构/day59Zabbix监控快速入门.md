# day59 Zabbix 监控快速入门

## 一、为什么监控 & 如何入手

**1. 为什么要监控**
1. 对系统不间断实时监控
2. 实时反馈系统当前状态
3. 保证服务可靠性、安全性
4. 保证业务持续稳定运行

**2. 如何进行监控（以磁盘使用率为例）**
1. 如何查看：`df -h`
2. 监控哪些指标：block、inode
3. 如何获取具体值：`df -h|awk '/\/$/{print $(NF-1)}'`
4. 到达多少报警：例如 80%

**3. 流行的监控工具**
- cacti、Nagios、Zabbix（老牌三件套）
- Lepus（天兔）数据库监控系统
- Open-Falcon（小米）
- Prometheus（普罗米修斯，Docker/K8s 生态）

**4. 去一家新公司如何入手监控**
1. 硬件监控：路由器、交换机、防火墙
2. 系统监控：CPU、内存、磁盘、网络、进程、TCP
3. 服务监控：nginx、php、tomcat、redis、memcache、mysql
4. Web 监控：请求时间、响应时间、加载时间
5. 日志监控：ELK（收集、存储、分析、展示）、日志易
6. 安全监控：Firewalld、WAF（Nginx+Lua）、安全宝、牛盾云、安全狗
7. 网络监控：smokeping（多机房）
8. 业务监控

### 面试回答思路（监控相关问题）
1. **硬件监控**：SNMP 监控路由交换；服务器温度等用 IPMI。纯云环境可跳过。
2. **系统监控**：CPU 负载、上下文切换、内存使用率、磁盘读写/使用率、inode 使用率；需要配置触发器，默认太低会频繁误报。
3. **服务监控**：LNMP 中 nginx 自带 Status、PHP 有 Status、MySQL 用 Percona 工具、Redis 用 info；要么服务自带，要么脚本实现采集+报警+图形。
4. **网络监控**：云主机非跨机房可不监控；跨机房推荐 smokeping，或交给网络工程师。
5. **安全监控**：云主机用自带防护/防 DDoS，或用 iptables；系统层权限/密码/备份/恢复做好；Web 可用 Nginx+Lua 实现 WAF（或 OpenResty）。
6. **Web 监控**：Zabbix 自带 Web 监控（延迟、js 响应、下载时间）；或用监控宝/听云（全国各地机房）。
7. **日志监控**：收集/存储/查询/展示，用 ELK Stack（Logstash 收集、Elasticsearch 存储搜索、Kibana 展示）；Web 可监控 nginx 50x/40x、PHP error。
8. **业务监控**：与开发/总监确认重要业务指标，脚本采集 + 触发器。
9. **流量分析**：百度/Google 统计嵌代码，或 piwik 自托管。
10. **可视化**：Screen + 第三方库美化，结合平台梳理系统间业务关系。
11. **自动化监控**：用 Zabbix 主动/被动模式，最好通过 API 批量加主机/模板。
12. **分布式监控**。

---

## 二、单机时代如何监控

[监控命令参考文档](http://man.linuxde.net/par/3)

```bash
# CPU 监控
w、top、htop、glances
%Cpu(s):  0.3 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
us 用户态：跟用户操作有关   sy 系统态：跟内核处理有关   id CPU 空闲

# 内存监控
free -m
#           total  used  free  shared  buff/cache  available
# Mem:       974   440   194       4         340        328
# Swap:     2047    11  2036

# 磁盘监控
df、iotop
Device:  tps  kB_read/s  kB_wrtn/s  kB_read  kB_wrtn
sda      0.80    25.32      33.36    221034   291193
# 设备名 每秒传输次数 每秒读 每秒写 读总量 写总量

# 网络监控
ifconfig、route、glances、iftop、nethogs、netstat
# 单位换算：100Mbps/8 = 12MB
# iftop 中 <= => 表示流量方向；TX 发送、RX 接收、TOTAL 总流量
netstat -an|grep ESTABLISHED     # 查看 TCP 连接状态
netstat -rn                     # 查看路由信息
netstat -lntup
```

> 用户变多后服务可能扛不住被 **OOM（out of memory）**：内存不足时大量用 swap → 系统卡顿（有时内存还剩 300~500M 仍会用 swap）。

```bash
dd if=/dev/zero of=/dev/null bs=800M      # 模拟吃内存
tail -f /var/log/messages
# Out of memory: Kill process 2227 (dd) score 778 or sacrifice child
# Killed process 2227 (dd) total-vm:906724kB, anon-rss:798820kB, file-rss:0kB
```

### 用 Shell 脚本做单机监控
> 需求：每 1 分钟监控内存，可用内存低于 100M 发邮件报警并显示剩余内存。

```bash
[root@nfs ~]# cat free.sh
#!/usr/bin/bash
#Auth
while true
do
  #1.定义主机名，时间，IP地址
  Date=$(hostname)_$(hostname -I|awk '{print $2}')_$(date +%F)
  #2.获取可用的内存
  Free_Use=$(free -m|awk '/^Mem/{print $NF}')
  #3.进行比较
  if [ $Free_Use -le 100 ];then
    echo "$Date 内存已经低于100M, 当前还剩余可用内存: $Free_Use"
  fi
  sleep 3
  echo "循环又开始"
done
```

---

## 三、Zabbix 监控快速安装

```bash
# 1. 配置 Zabbix 仓库（3.4 示例，也有 5.5/6.5 可选）
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/5.5/rhel/7/x86_64/zabbix-release-5.5-1.el7.noarch.rpm
# rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/6.5/rhel/7/x86_64/zabbix-release-6.5-1.el7.noarch.rpm

# 2. 安装 Zabbix 程序包 + MySQL + Zabbix-agent
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server

# 3. 创建 Zabbix 数据库及用户
systemctl start mariadb
mysql -uroot
MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';

# 4. 导入 Zabbix 数据
cd /usr/share/doc/zabbix-server-mysql-3.4.15/
zcat create.sql.gz |mysql -uroot zabbix

# 5. 配置 /etc/zabbix/zabbix_server.conf
grep  ^[a-Z]  /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix

# 6. 启动 Zabbix 服务并开机自启
systemctl start zabbix-server
systemctl enable zabbix-server

# 7. 配置 Apache（/etc/httpd/conf.d/zabbix.conf）时区
php_value date.timezone Asia/Shanghai        # 取消注释并设置

# 8. 启动 Apache
systemctl enable httpd
systemctl start httpd

# 9. 浏览器访问 http://IP/zabbix 进入安装向导
# 10. 默认登录账号密码：Admin / zabbix
# mariadb 也加入开机自启
systemctl enable mariadb.service

# 若网络延时导致下载失败，可改用清华源手动安装
yum localinstall https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-server-mysql-3.4.12-1.el7.x86_64.rpm
yum localinstall https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-web-3.4.12-1.el7.noarch.rpm
```

安装向导截图（检查依赖、配置 DB、配置 Server、安装摘要、完成、登录、切中文）：

![依赖检查](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-01.png)
![依赖检查2](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-02.png)
![配置数据库](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-03.png)
![配置Server](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-04.png)
![安装摘要](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-05.png)
![安装完成](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-06.png)
![默认登录](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-07.png)
![切中文](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-08.png)
![完成](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-09.png)

---

## 四、快速监控一台主机

```bash
# 安装 zabbix-agent（版本可低于服务端）
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm

# 查看包内容
rpm -ql zabbix-agent
# /etc/zabbix/zabbix_agentd.conf
# /usr/lib/systemd/system/zabbix-agent.service
# /usr/sbin/zabbix_agentd

# 修改配置（指定 Server）
sed '/^Server/c Server=172.16.1.71' /etc/zabbix/zabbix_agentd.conf
# 或 vim /etc/zabbix/zabbix_agentd.conf 改 Server=172.16.1.71

# 启动并检查端口 10050
systemctl start zabbix-agent.service
netstat -lntp
# tcp 0 0 0.0.0.0:10050 0.0.0.0:* LISTEN 2410/zabbix_agentd
```

Web 界面操作（配置 → 主机 → 创建主机 → 选模板 Linux → 添加）：
![创建主机](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-10.png)
![创建主机2](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-11.png)
![选模板](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-12.png)
![选模板2](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-13.png)
![选模板3](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-14.png)

---

## 五、Zabbix 基础架构

```
zabbix-agent ----> zabbix-server ----> 数据库 <--- zabbix web
   数据采集        数据分析|报警       数据存储      数据展示
```

![架构](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-15.png)

---

## 六、Zabbix 拆分数据库（LAP + MySQL）

> 300 台服务器以内可不用拆分数据库。

```bash
ll /etc/zabbix/zabbix_server.conf
ll /etc/zabbix/web/zabbix.conf.php

# 1. 新数据库上建 zabbix 库
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@'%' identified by 'Bgx123.com';

# 2. 旧 zabbix 服务器备份并导入新库
mysqldump -uroot --databases zabbix --single-transaction > `date +%F%H`-zabbix.sql
cat 2018-08-2017-zabbix.sql |mysql -h 10.0.0.51 -uzabbix -pBgx123.com zabbix

# 3. 修改 zabbix server 数据库连接
vim /etc/zabbix/zabbix_server.conf
DBHost=172.16.1.51
DBName=zabbix
DBUser=zabbix
DBPassword=Bgx123.com
systemctl restart zabbix-server

# 4. 修改 zabbix web 数据库连接
vim /etc/zabbix/web/zabbix.conf.php
$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '172.16.1.51';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'Bgx123.com';
systemctl restart httpd
```

> 若报错 `Z3001 connection to database 'zabbix' failed: Can't connect to MySQL server`，检查数据库是否允许远程连接、账户密码是否正确。

---

## 七、自定义监控 - 初试

```bash
# 1. 监控对象取值
iostat | awk '/^sda/{print $2}'

# 2. 增加监控项：UserParameter=<key>,<shell command>
cat /etc/zabbix/zabbix_agentd.d/iotop.conf
UserParameter=iotps,iostat | awk '/^sda/{print $2}'
systemctl restart zabbix-agent

# 3. agent 本地验证自定义监控项
zabbix_agentd -p |grep iotps
# iotps  [t|1.72]

# 4. Zabbix-Server 验证 agent 取值
yum install zabbix-get -y
zabbix_get -s 172.16.1.7 -p10050 -k iotps
# 3.76

# 5. Web 界面关联
# 配置 → 主机 → 对应主机 → 监控项 → 创建监控项（名称、键值、信息类型、单位）
# 监测中 → 最新数据 → 等待 30s
```

![创建监控项](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-16.png)
![创建监控项2](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-17.png)
![最新数据](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-18.png)

**7. 自定义阈值（触发器）**
1. 配置 → 主机 → 对应主机 → 触发器 → 创建触发器
2. 表达式选对应监控项：`{web03-10.0.0.9:system.users.num.last()}>2`
3. 开多个会话窗口测试前端报警
4. 前端报警开启：右上角小人头 → 正在发送消息 → 开启

![触发器](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-19.png)
![触发器2](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-20.png)
![测试报警](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-21.png)
![多窗口](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-22.png)

---

## 八、自定义报警（邮件 / 微信）

> 当监控项超过触发器阈值 → **触发动作** →（发送消息 | 执行命令）。
> 注意：SMTP 验证选项可用需 Zabbix 服务器使用 cURL 7.20.0 或更高版本。

1. 配置 → 动作 → 启用动作
   ![启用动作](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-23.png)
2. 管理 → 报警媒介类型 → 设定发送介质 email
   ![报警媒介](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-24.png)
3. 配置发件人邮箱账户和授权密码（注意：不是收件人邮箱）
   ![发件人](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-25.png)
4. 右上角用户 → 报警媒介 → 添加收件人邮箱
   ![收件人](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-26.png)
5. 填写类型、收件人、报警级别后添加
   ![添加](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-27.png)
6. 确认无误点更新
   ![更新](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-28.png)
7. 触发报警查看邮件是否收到
   ![邮件](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-29.png)
8. 若发送失败：报表 → 动作日志 检查
   ![动作日志](img/day59Zabbix%E7%9B%91%E6%8E%A7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8-30.png)

---

## 常见面试题

1. **Zabbix 的基础架构是什么？**
   agent 采集 → server 分析与报警 → 数据存数据库 → web 展示。

2. **快速监控一台主机的关键步骤？**
   装 agent、改 `Server=` 指向 server IP、启动 10050、Web 创建主机并关联模板（如 Linux）。

3. **自定义监控项怎么实现？**
   在 agent 的 `zabbix_agentd.d/*.conf` 写 `UserParameter=key,command`，重启 agent，用 `zabbix_agentd -p` 本地验证、`zabbix_get` 服务端验证，再 Web 建监控项。

4. **触发器（阈值）怎么配？**
   配置 → 触发器 → 表达式选监控项，如 `{主机:监控项.last()}>2`。

5. **Zabbix 报警媒介有哪些？怎么配邮件？**
   邮件、微信、短信、脚本等；邮件需在「报警媒介类型」配 SMTP 发件人（授权密码），并在用户里添加收件人媒介。

6. **什么时候需要拆分 Zabbix 数据库？**
   规模较大（如超过 300 台）时，把数据库独立到单独 MySQL，改 `zabbix_server.conf` 和 `zabbix.conf.php` 的连接信息。

7. **拆分数据库后连不上怎么排查？**
   看 `zabbix_server.log` 的 `Z3001` 错误，检查目标 MySQL 是否允许远程、账号密码是否正确。

---

> 更新：2024-08-30 18:33:50
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/gyq69l>
