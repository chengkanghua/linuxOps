# Zabbix 监控系列（5 天完整教程）

> 本教程覆盖：监控体系 → 安装 Zabbix → 监控单主机 → 自定义监控/触发器/动作/报警 → 应用监控（TCP/Nginx/PHP-FPM/MySQL/Redis/Tomcat）→ Web 场景监控 → 自动发现/注册 → 主被动模式 → 分布式 Proxy → API → 性能优化。

---

# Day01 监控体系与基础

## 0. 监控体系概述

**为什么要监控**
1. 对系统不间断实时监控
2. 实时反馈系统当前状态
3. 保证服务可靠性、安全性
4. 保证业务持续稳定运行

**监控怎么入手（以磁盘使用率为例）**
1. 如何查看：`df -h`
2. 监控哪些指标：block、inode
3. 如何获取值：`df -h|awk '/\/$/{print $(NF-1)}'`
4. 到达多少报警：如 80%

**流行监控工具**
cacti、Nagios、Zabbix（老牌三件套）；Lepus（天兔，数据库监控）；Open-Falcon（小米）；Prometheus（Docker/K8s 生态）。

**去新公司如何入手**
1. 硬件监控：路由器、交换机、防火墙
2. 系统监控：CPU、内存、磁盘、网络、进程、TCP
3. 服务监控：nginx、php、tomcat、redis、memcache、mysql
4. Web 监控：响应时间、加载时间、渲染时间
5. 日志监控：ELK（收集、存储、分析、展示）、日志易
6. 安全监控：Firewalld、WAF（Nginx+lua）、安全宝、牛盾云、安全狗
7. 网络监控：smokeping（多机房）
8. 业务监控

## 1. 单机如何监控

```bash
# CPU：w、top、htop
%Cpu(s):  0.3 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
# us 用户态（与用户操作有关）/ sy 系统态（与内核处理有关）/ id CPU空闲

# 内存：free
free -m
#           total  used  free  shared  buff/cache  available
# Mem:        974    55   840       0          79         797
# Swap:      3967    48  3919

# 磁盘：df、iotop
Device:  tps  kB_read/s  kB_wrtn/s  kB_read  kB_wrtn
sda      0.80     25.32      33.36   221034   291193
# 设备名 每秒传输次数 每秒读 每秒写 读总量 写总量

# 网络：ifconfig、route、iftop、nethogs、netstat
# 单位换算：100Mbps/8 = 12MB
# iftop 中 <= => 表示流量方向；TX 发送、RX 接收、TOTAL 总流量
netstat -an|grep ESTABLISHED    # 查看 TCP 连接状态
netstat -rn                    # 查看路由
netstat -lntup
```

**用 Shell 脚本做单机内存监控**
> 需求：每分钟监控内存，可用内存低于 100M 发邮件报警并显示剩余内存。

```bash
[root@m01 ~]# cat free.sh
#!/usr/bin/bash
HostName=$(hostname)_$(hostname -i)
Date=$(date +%F)
while true;do
  Free=$(free -m|awk '/^Mem/{print $NF}')
  if [ $Free -le 100 ];then
    echo "$Date: $HostName Mem Is < ${Free}MB"
  fi
  sleep 5
done
```

**OOM（内存耗尽）**
用户增多 → 服务扛不住 → OOM 杀进程；内存不足会用 swap，大量占用 swap 时系统极卡。
```bash
dd if=/dev/zero of=/dev/null bs=800M status=progress
tail -f /var/log/messages
# Out of memory: Kill process 2227 (dd) score 778 or sacrifice child
# Killed process 2227 (dd) total-vm:906724kB, anon-rss:798820kB, file-rss:0kB
```

## 2. 安装 Zabbix-Server

```bash
# 1. 配置仓库并安装
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
yum remove zabbix22 -y
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server

# 2. 创建数据库及用户
systemctl enable mariadb && systemctl start mariadb
mysql -uroot
MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';

# 3. 导入架构与数据
cd /usr/share/doc/zabbix-server-mysql-3.4.12/
zcat create.sql.gz |mysql -uroot zabbix

# 4. 配置 zabbix_server.conf
vim /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
systemctl enable zabbix-server && systemctl start zabbix-server

# 5. 配置 PHP（时区）
vim /etc/httpd/conf.d/zabbix.conf
php_value date.timezone Asia/Shanghai       # 取消注释并设置
systemctl enable httpd && systemctl start httpd

# 6. 浏览器访问 http://IP/zabbix 完成安装，默认账号 Admin / zabbix
```

## 3. 快速监控一台主机

```bash
rpm -ivh https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.12-1.el7.x86_64.rpm
vim /etc/zabbix/zabbix_agentd.conf
Server=10.0.0.61          # 指向 Zabbix-Server
systemctl start zabbix-agent && systemctl enable zabbix-agent
netstat -lntp             # 0.0.0.0:10050  LISTEN zabbix_agentd
```
Web：配置 → 主机 → 创建主机 → 选模板 Linux → 添加。

## 4. Zabbix 基础架构

```
zabbix-agent ----> zabbix-server ----> 数据库 <--- zabbix web
   数据采集        数据分析|报警        数据存储       数据展示
```

## 5. Zabbix 拆分数据库（LAP + MySQL）

> 300 台以内可不拆分。

```bash
# 1. 新库建 zabbix
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@'%' identified by 'Bgx123.com';

# 2. 旧 server 备份并导入新库
mysqldump -uroot --databases zabbix --single-transaction > `date +%F%H`-zabbix.sql
cat 2018-08-2017-zabbix.sql |mysql -h 10.0.0.51 -uzabbix -pBgx123.com zabbix

# 3. 改 server 连接
vim /etc/zabbix/zabbix_server.conf
DBHost=172.16.1.51
DBName=zabbix
DBUser=zabbix
DBPassword=Bgx123.com
systemctl restart zabbix-server

# 4. 改 web 连接
vim /etc/zabbix/web/zabbix.conf.php
$DB['SERVER']   = '172.16.1.51';
$DB['PASSWORD'] = 'Bgx123.com';
systemctl restart httpd
```
> 错误 `Z3001 connection to database 'zabbix' failed`：检查是否允许远程连接、账号密码是否正确。

## 6. 自定义监控 - 初试

```bash
# 1. 取值
iostat | awk '/^sda/{print $2}'

# 2. 定义监控项
cat /etc/zabbix/zabbix_agentd.d/iotop.conf
UserParameter=iotps,iostat | awk '/^sda/{print $2}'
systemctl restart zabbix-agent

# 3. agent 本地验证
zabbix_agentd -p |grep iotps     # iotps  [t|1.72]

# 4. server 验证
yum install zabbix-get -y
zabbix_get -s 10.0.0.9 -p10050 -k iotps    # 1.69

# 5. Web：配置→主机→监控项→创建；监测中→最新数据（等 30s）

# 6. 自定义阈值（触发器）
# 配置→主机→触发器→表达式选监控项：{web03-10.0.0.9:system.users.num.last()}>2
# 开多窗口测试；右上角小人头→正在发送消息→开启
```

---

# Day02 自定义报警、深入监控与图形

## 1. 自定义报警（邮件 / 微信）

> 当监控项超过触发器阈值 → 触发动作 →（发送消息 | 执行命令）。
> 注意：SMTP 验证选项可用需 Zabbix 服务器使用 cURL 7.20.0+。

1. 启用动作（配置 → 动作 → 启用）。
2. 管理 → 报警媒介类型 → email，设定发件人账号与授权码（**不是收件人邮箱**）。
3. 右上角用户 → 报警媒介 → 添加收件人邮箱与报警级别 → **更新**。
4. 触发报警后查邮件；失败则查邮箱授权码或报表→动作日志。

**企业微信报警**
```bash
yum install python-pip -y && pip install requests
cd /usr/lib/zabbix/alertscripts
chmod +x weixin.py
./weixin.py  WeiXinID   111   2222
chown zabbix.zabbix /tmp/weixin.log
# 变量：{ALERT.SENDTO} 发给谁 / {ALERT.SUBJECT} 主题 / {ALERT.MESSAGE} 内容
```
脚本需 `corpid`（企业ID）、`appsecret`、`agentid`（企业微信自建应用）。收件人填企业微信里自己的名字全拼（如 XuLiangWei）。

## 2. 自定义监控 - 深入（TCP 11 种状态，传参）

```bash
cat /etc/zabbix/zabbix_agentd.d/tcp_state.conf
UserParameter=tcp_state[*],netstat -ant|grep -c $1
systemctl restart zabbix-agent

# server 测试
zabbix_get -s 10.0.0.7 -k tcp_state[LISTEN]     # 8
```
Web：先加一个监控项再克隆出 11 个；不支持的 key 调整 agent 的 `Timeout=30`。
> 演示：监控 22 端口是否监听，类型选字符 + Service State 值映射。
> 演示差异速度：`diff()`——创建文件写 100，监控取值后重定向写 200，看图形最近 500 个值。

## 3. 自定义阈值 - 深入

```bash
# 1. 剩余内存百分比
vim /etc/zabbix/zabbix_agentd.d/oldboy.conf
UserParameter=Mem_pre,free -m|awk '/^Mem/{print $NF*100/$2}'
systemctl restart zabbix-agent
zabbix_get -s 10.0.0.9 -k 'Mem_pre'    # 72.1766

# 2. 单条件触发器：内存低于 30% 报警
# 表达式：{web03-10.0.0.9:Mem_pre.last()}<30
# 压测：dd if=/dev/zero of=/dev/null bs=500M count=1024

# 3. 多条件（更精准）：内存<30% 且 swap>1%
vim /etc/zabbix/zabbix_agentd.d/oldboy.conf
UserParameter=Swap_pre,free -m|awk '/^Swap/{print $3*100/$2}'
systemctl restart zabbix-agent
# 表达式：{web03-10.0.0.9:Mem_pre.last()}<30 and {web03-10.0.0.9:Swap_pre.last()}>1
# 仅内存低（swap 未超）不会报警；两者都满足才报警
```

**常用触发器函数**
- `and` / `or`：并且 / 或者
- `last()`：比对最新值
- `avg(5m)`：最近 5 分钟平均值（避免波动误报）
- `diff()`：比对上一次内容
- `nodata(5m)`：收不到数据则报警

## 4. 图形中文乱码处理

```bash
cd /usr/share/fonts/dejavu/
mv DejaVuSans.ttf DejaVuSans.ttf.bak
rz   # 上传 Windows 字体 simhei.ttf
mv simhei.ttf DejaVuSans.ttf
```

## 5. 自定义报警内容（宏）

```
故障消息：
报警主机：{HOST.NAME1}
报警服务: {ITEM.NAME1}
报警Key1: {ITEM.KEY1}：{ITEM.VALUE1}
报警Key2: {ITEM.KEY2}：{ITEM.VALUE2}
严重级别: {TRIGGER.SEVERITY}

恢复消息：
恢复主机：{HOST.NAME1}
恢复服务： {ITEM.NAME1}
恢复Key1：{ITEM.KEY1}：{ITEM.VALUE1}
恢复Key2: {ITEM.KEY2}：{ITEM.VALUE2}
```

## 6. 自定义图形 / 聚合 / 幻灯片 / 图形树

层级：**监控项 → 图形 → 聚合图形（Screen）→ 幻灯片（轮播，只能放聚合图形）→ 图形树 → zabbix+grafana（最炫）**。

**图形树（graphtree，第三方）**
```bash
cd /usr/share/zabbix
wget https://raw.githubusercontent.com/OneOaaS/graphtrees/master/graphtree3.0.4.patch
yum install -y patch
patch -Np0 < graphtree3.0.4.patch
chown -R apache.apache oneoaas
vim /etc/httpd/conf.d/zabbix.conf
Alias /oneoaas /usr/share/zabbix/oneoaas
systemctl restart httpd
```

## 7. 自定义模板

1. 模板支持导入/导出，但模板里的监控项依赖 `/etc/zabbix/zabbix_agentd.d/*.conf` 支撑（脚本要一起打包）。
2. `.conf` 定义监控项，调用脚本或命令。
3. 复用：监控项全选 → 复制 → 做成模板。
4. 使用模板：客户端 agent 定义监控项 → 服务端导入模板 → 创建主机并链接模板。

---

# Day03 应用服务监控

> 通用方法：服务自带 status/info → 写取值脚本 → 定义 `UserParameter` → `zabbix_get` 验证 → Web 加监控项/模板 → 关联主机。

## 1. TCP 状态监控

```bash
cat /etc/zabbix/scripts/tcp_status.sh
#!/bin/bash
[ $# -ne 1 ] && echo "Usage:CLOSE-WAIT|CLOSED|CLOSING|ESTAB|FIN-WAIT-1|FIN-WAIT-2|LAST-ACK|LISTEN|SYN-RECV|SYN-SENT|TIME-WAIT" && exit 1
tcp_status_fun(){
    TCP_STAT=$1
    ss -ant | awk 'NR>1 {++s[$1]} END {for(k in s) print k,s[k]}' > /tmp/ss.txt
    TCP_STAT_VALUE=$(grep "$TCP_STAT" /tmp/ss.txt | cut -d ' ' -f2)
    [ -z "$TCP_STAT_VALUE" ] && TCP_STAT_VALUE=0
    echo $TCP_STAT_VALUE
}
tcp_status_fun $1

cat /etc/zabbix/zabbix_agentd.d/tcp.conf
UserParameter=tcp_status[*],/bin/bash /etc/zabbix/scripts/tcp_status.sh "$1"
systemctl restart zabbix-agent
zabbix_get -s 192.168.90.11 -k tcp_status[ESTAB]    # 8
# 添加全部监控项并关联到主机、建图形
```
> ESTAB 并发高、`syn_recv` 高可能受攻击；`time_wait` 高要考虑内核调优（占用端口）。

## 2. Nginx 监控

开启 `stub_status`：
```bash
location /nginx_status {
    stub_status on;
    access_log  off;
    allow 127.0.0.1;
    deny all;
}
```
取值脚本：
```bash
cat /etc/zabbix/scripts/nginx_status.sh
#!/bin/bash
NGINX_PORT=80
NGINX_COMMAND=$1
nginx_active(){  /usr/bin/curl -s "http://127.0.0.1:${NGINX_PORT}/nginx_status/" |awk '/Active/ {print $NF}'; }
nginx_reading(){ /usr/bin/curl -s "http://127.0.0.1:${NGINX_PORT}/nginx_status/" |awk '/Reading/ {print $2}'; }
nginx_writing(){ /usr/bin/curl -s "http://127.0.0.1:${NGINX_PORT}/nginx_status/" |awk '/Writing/ {print $4}'; }
nginx_waiting(){ /usr/bin/curl -s "http://127.0.0.1:${NGINX_PORT}/nginx_status/" |awk '/Waiting/ {print $6}'; }
nginx_accepts(){ /usr/bin/curl -s "http://127.0.0.1:${NGINX_PORT}/nginx_status/" |awk 'NR==3 {print $1}'; }
nginx_handled(){ /usr/bin/curl -s "http://127.0.0.1:${NGINX_PORT}/nginx_status/" |awk 'NR==3 {print $2}'; }
nginx_requests(){ /usr/bin/curl -s "http://127.0.0.1:${NGINX_PORT}/nginx_status/" |awk 'NR==3 {print $3}'; }
case $NGINX_COMMAND in
    active)   nginx_active;;   reading)  nginx_reading;;  writing)  nginx_writing;;
    waiting)  nginx_waiting;;  accepts)  nginx_accepts;;  handled)  nginx_handled;;
    requests) nginx_requests;;
    *) echo $"USAGE:$0 {active|reading|writing|waiting|accepts|handled|requests}";;
esac

cat /etc/zabbix/zabbix_agentd.d/nginx_status.conf
UserParameter=nginx_status[*],/bin/bash /etc/zabbix/scripts/nginx_status.sh "$1"
chmod +x /etc/zabbix/scripts/nginx_status.sh
systemctl restart zabbix-agent
zabbix_get -s 192.168.90.11 -k nginx_status[writing]   # 1
# 添加所有监控项、关联到主机、建图形
```
> Nginx 状态：`Active connections` 活动连接；`accepts/handled/requests` 累计握手/连接/请求；`Waiting` = active-(reading+writing)。

## 3. PHP-FPM 监控

```bash
# 1. 开启状态
vim /etc/php-fpm.d/www.conf
pm.status_path = /phpfpm_status
systemctl restart php-fpm

# 2. Nginx 暴露
location ~ ^/(phpfpm_status)$ {
    include fastcgi_params;
    fastcgi_pass    127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}

# 3. 取值
curl http://127.0.0.1/phpfpm_status
# pool: www  process manager: dynamic  start since: 409
# accepted conn: 22  listen queue: 0  max listen queue: 0
# idle processes: 4  active processes: 1  total processes: 5
# max active processes: 2  max children reached: 0  slow requests: 0
```
取值脚本：
```bash
cat /etc/zabbix/scripts/phpfpm_status.sh
#!/bin/bash
PHPFPM_COMMAND=$1
PHPFPM_PORT=80
start_since(){    /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^start since:/ {print $NF}'; }
accepted_conn(){  /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^accepted conn:/ {print $NF}'; }
listen_queue(){   /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^listen queue:/ {print $NF}'; }
max_listen_queue(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^max listen queue:/ {print $NF}'; }
listen_queue_len(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^listen queue len:/ {print $NF}'; }
idle_processes(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^idle processes:/ {print $NF}'; }
active_processes(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^active processes:/ {print $NF}'; }
total_processes(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^total processes:/ {print $NF}'; }
max_active_processes(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^max active processes:/ {print $NF}'; }
max_children_reached(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^max children reached:/ {print $NF}'; }
slow_requests(){ /usr/bin/curl -s "http://127.0.0.1:${PHPFPM_PORT}/phpfpm_status" |awk '/^slow requests:/ {print $NF}'; }
case $PHPFPM_COMMAND in
    start_since) start_since;;  accepted_conn) accepted_conn;;  listen_queue) listen_queue;;
    max_listen_queue) max_listen_queue;;  listen_queue_len) listen_queue_len;;  idle_processes) idle_processes;;
    active_processes) active_processes;;  total_processes) total_processes;;  max_active_processes) max_active_processes;;
    max_children_reached) max_children_reached;;  slow_requests) slow_requests;;
    *) echo $"USAGE:$0 {start_since|accepted_conn|listen_queue|max_listen_queue|listen_queue_len|idle_processes|active_processes|total_processes|max_active_processes|max_children_reached}";;
esac

cat /etc/zabbix/zabbix_agentd.d/phpfpm_status.conf
UserParameter=phpfpm_status[*],/bin/bash /etc/zabbix/scripts/phpfpm_status.sh "$1"
chmod +x /etc/zabbix/scripts/phpfpm_status.sh
systemctl restart zabbix-agent
zabbix_get -s 192.168.90.11 -k phpfpm_status[accepted_conn]   # 45
# 添加监控项、关联主机、建图形
```
> 触发器（多条件）：`{主机:fpm["idle processes"].avg(1m)}=0 or {主机:fpm["listen queue"].avg(1m)}>30`（`ab -n10000 -c200` 模拟故障）。

**PHP-FPM 状态含义**
| 字段 | 含义 |
| --- | --- |
| pool | fpm 池（多为 www） |
| process manager | dynamic / static |
| accepted conn | 当前池接受的请求数 |
| listen queue | 请求等待队列（**长期>0 需加进程数**） |
| idle processes | 空闲进程（长期为 0 要报警） |
| max children reached | 达到进程上限次数（**>0 说明进程数偏小**） |

## 4. MySQL 监控（Percona 插件）

```bash
yum install php php-fpm php-mysql mariadb-server -y
systemctl start mariadb
mysql -uroot -e "grant all on *.* to mysql@'%' identified by '123456';"
rpm -ivh https://www.percona.com/downloads/percona-monitoring-plugins/percona-monitoring-plugins-1.1.8/binary/redhat/7/x86_64/percona-zabbix-templates-1.1.8-1.noarch.rpm
tree /var/lib/zabbix/percona
cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.d/
systemctl restart zabbix-agent

# 配置 php 连接数据库
vim /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php
$mysql_user = 'root'; $mysql_pass = ''; $mysql_port = 3306;

# 测试
sh /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh gg    # 405647
# server 端取值
zabbix_get -s 10.0.0.11 -k MySQL.pool-read-requests    # 2572
# 取不到值排查：MySQL 密码错误 / 别直接执行脚本 / 删 /tmp/localhost-mysql_cacti_stats.txt / 权限
rm -f /tmp/localhost-mysql_cacti_stats.txt
# Web 导入模板（/var/lib/zabbix/percona/templates/zabbix_agent_template_percona_mysql_server_*.xml）并关联主机
```

## 5. Redis 监控

```bash
cat /etc/zabbix/scripts/redis_status.sh
#!/bin/bash
R_COMMAND="$1"
R_PORT="6379"
R_SERVER="127.0.0.1"
PASSWD=""    # 无密码留空
redis_status(){
   (echo -en "AUTH $PASSWD\r\nINFO\r\n";sleep 1;) | /usr/bin/nc "$R_SERVER" "$R_PORT" > /tmp/redis_"$R_PORT".tmp
   REDIS_STAT_VALUE=$(grep "$R_COMMAND:" /tmp/redis_"$R_PORT".tmp | cut -d ':' -f2)
   echo "$REDIS_STAT_VALUE"
}
case $R_COMMAND in
    used_cpu_user_children) redis_status "$R_PORT" "$R_COMMAND";;
    used_cpu_sys) redis_status "$R_PORT" "$R_COMMAND";;
    total_commands_processed) redis_status "$R_PORT" "$R_COMMAND";;
    role) redis_status "$R_PORT" "$R_COMMAND";;
    lru_clock) redis_status "$R_PORT" "$R_COMMAND";;
    latest_fork_usec) redis_status "$R_PORT" "$R_COMMAND";;
    keyspace_misses) redis_status "$R_PORT" "$R_COMMAND";;
    keyspace_hits) redis_status "$R_PORT" "$R_COMMAND";;
    keys) redis_status "$R_PORT" "$R_COMMAND";;
    expires) redis_status "$R_PORT" "$R_COMMAND";;
    expired_keys) redis_status "$R_PORT" "$R_COMMAND";;
    evicted_keys) redis_status "$R_PORT" "$R_COMMAND";;
    connected_clients) redis_status "$R_PORT" "$R_COMMAND";;
    changes_since_last_save) redis_status "$R_PORT" "$R_COMMAND";;
    blocked_clients) redis_status "$R_PORT" "$R_COMMAND";;
    bgsave_in_progress) redis_status "$R_PORT" "$R_COMMAND";;
    bgrewriteaof_in_progress) redis_status "$R_PORT" "$R_COMMAND";;
    used_memory_peak) redis_status "$R_PORT" "$R_COMMAND";;
    used_memory) redis_status "$R_PORT" "$R_COMMAND";;
    used_cpu_user) redis_status "$R_PORT" "$R_COMMAND";;
    used_cpu_sys_children) redis_status "$R_PORT" "$R_COMMAND";;
    total_connections_received) redis_status "$R_PORT" "$R_COMMAND";;
    *) echo $"USAGE:$0 {used_cpu_user_children|used_cpu_sys|total_commands_processed|role|lru_clock|latest_fork_usec|keyspace_misses|keyspace_hits|keys|expires|expired_keys|connected_clients|changes_since_last_save|blocked_clients|bgrewriteaof_in_progress|used_memory_peak|used_memory|used_cpu_user|used_cpu_sys_children|total_connections_received}";;
esac
chmod +x /etc/zabbix/scripts/redis_status.sh
cat /etc/zabbix/zabbix_agentd.d/redis_status.conf
UserParameter=redis_status[*],/bin/bash /etc/zabbix/scripts/redis_status.sh "$1"
systemctl restart zabbix-agent
zabbix_get -s 192.168.90.11 -k redis_status[used_cpu_sys]   # 16.81
# 权限不足：rm -f /tmp/redis_6379.tmp
```
> Redis `INFO` 字段：`server / clients(connected_clients,blocked_clients) / memory(used_memory,used_memory_rss,used_memory_peak,mem_fragmentation_ratio) / persistence / stats / replication / cpu / commandstats / cluster / keyspace`。

**Discuz 集成 Redis 缓存案例**
```bash
# 安装组件并部署 Discuz
yum install mariadb-server nginx php php-fpm php-mysql php-pecl-redis -y
mkdir -p /code && cd /code && rz -E && unzip Discuz_X3.2_SC_UTF8.zip && mv upload/* ./
chmod -R 777 *
cat /etc/nginx/conf.d/discuz.conf
server { listen 80; root /code; index index.php index.html;
  location ~ \.php$ { root /code; fastcgi_pass 127.0.0.1:9000; fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; include fastcgi_params; } }
nginx -t && systemctl reload nginx && systemctl restart php-fpm
mysql -e "create database bbs;"
# 开启 redis 并加密码
yum install redis -y && vim /etc/redis.conf   # requirepass 123456
systemctl start redis
# 修改 Discuz 配置 /code/config/config_global.php 接入 redis，重启 php-fpm
```

## 6. Tomcat 监控（JMX）

数据流：`Zabbix-Server → Zabbix-Java-Gateway → JVM`

**配置步骤**
```bash
# 1. 安装 java-gateway
yum install zabbix-java-gateway java-1.8.0-openjdk -y

# 2. 配置 zabbix_java_gateway.conf（默认即可）

# 3. 启动
systemctl start zabbix-java-gateway
netstat -lntup|grep 10052     # :::10052 LISTEN java

# 4. 配置 zabbix-server 连 gateway
vim /etc/zabbix/zabbix_server.conf
JavaGateway=192.168.90.11
JavaGatewayPort=10052
StartJavaPollers=5
systemctl restart zabbix-server

# 5. 安装 tomcat 并开启 JMX
mkdir /soft/package/src -p
wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.2/bin/apache-tomcat-9.0.2.tar.gz
tar xf apache-tomcat-9.0.2.tar.gz -C /soft/ && ln -s /soft/apache-tomcat-9.0.2/ /soft/tomcat

vim /soft/tomcat/bin/catalina.sh
CATALINA_OPTS="$CATALINA_OPTS
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=12345
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
-Djava.rmi.server.hostname=192.168.90.11"
/soft/tomcat/bin/shutdown.sh && /soft/tomcat/bin/startup.sh

# 6. Web 添加 tomcat 主机，关联 Zabbix 自带 Java 模板
```
> 自带模板可能不够，可按业务定制 JVM 监控模板。

---

# Day04 场景监控、自动发现/注册、主被动模式

## 1. 架构回顾
- 基础架构：agent 采集 → server 分析报警 → DB 存储 → web 展示
- 监控方式：agent、snmp、ipmi、ssh、telnet、jmx
- 资源：监控项 → 应用集 → 触发器 → 动作 → 图形/聚合/幻灯片 → 模板

## 2. Web 场景检测

**静态 vs 动态网站**
- 静态：服务端源码 = 客户端源码
- 动态：如 `<?php phpinfo()?>`，每次访问由内存动态生成 HTML、支持登录与交互
- 交互靠 **Session（服务端）+ Cookie（客户端）**：服务端分配 sessionID，客户端存 cookie，再次访问携带校验

**curl 模拟登录（关闭验证码后）**
```bash
# 登录 zabbix
curl -L -c tt -b tt -d 'name=Admin&password=zabbix&autologin=1&enter=Sign+in' 'http://10.0.0.61/zabbix/index.php'
# 登录 discuz
curl -L -c cook -b cook -d 'fastloginfield=username&username=admin&password=1&quickforward=yes&handlekey=ls' 'http://10.0.0.9/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1'
# 退出 discuz
curl -L -c cook -b cook 'http://10.0.0.9/member.php?mod=logging&action=logout'
```
Web 场景步骤：① 登录（POST 账号密码）② 验证（访问需登录的页面）③ 退出。
- 登录 URL：`http://10.0.0.9/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1`
- 原始提交：`fastloginfield=username&username=admin&password=1&quickforward=yes&handlekey=ls`
- 验证 URL：`http://10.0.0.9/home.php?mod=space&do=friend`
- 退出 URL：`http://10.0.0.9/member.php?mod=logging&action=logout`

## 3. 自动发现（被动，server 找 agent）

由**发现（discovery）+ 动作（actions）** 组成。默认标题 `自动发现主机IP:{DISCOVERY.DEVICE.IPADDRESS}`；消息：`客户端名称:{DISCOVERY.SERVICE.NAME} 端口:{DISCOVERY.SERVICE.PORT} 状态:{DISCOVERY.SERVICE.STATUS}`。

配置：配置→自动发现（选 IP 段、检查项、频次）；配置→动作→事件源「自动发现」→启用→操作（添加主机+加组+链接模板+发邮件）。
新增主机：`grep "^Server" /etc/zabbix/zabbix_agentd.conf` 指向 server，`systemctl restart zabbix-agent`。

**弊端**：server 每 60s 扫描有资源开销；扫描中丢机器；某台卡住拖慢后续；规定时间扫不完则本轮不检查。

## 4. 自动注册（主动，agent 找 server）

```bash
vim /etc/zabbix/zabbix_agentd.conf
ServerActive=10.0.0.61
# Hostname=     # 不写则用系统 hostname
systemctl restart zabbix-agent
```
Web：配置→动作→事件源「自动注册」→创建动作→操作（关联模板+发送消息）。注册成功后收到邮件。可按主机名（含 web/db）或主机元数据区分不同模板。

## 5. 主动模式 vs 被动模式（相对 agent）

| 维度 | 被动（默认） | 主动 |
| --- | --- | --- |
| 谁发起 | server 轮询 agent | agent 主动上报 |
| 配置项 | `Server` | `ServerActive` |
| 100 个监控项 | 100 个回合 | 1 个回合 |
| 适用 | 机器少 | 机器>300 / Queue 延迟大 / 监控项多 / 自动注册 |

**改为主动**：agent 配 `ServerActive` + `Hostname`；Web 全克隆被动模板 → 改名 → 监控项类型改为主动（Zabbix agent (active)）→ 主机先取消被动模板链接并清理，再链接主动模板。

---

# Day05 分布式 Proxy、API、性能优化

## 1. ZabbixProxy 分布式监控

**Proxy 特征**：轻量、无 GUI、独立工作、易维护、自动建库、无本地管理、适合嵌入式硬件、单向 TCP、集中配置、**不支持图形/报警**、**需要数据库**、**不能与 Server 同机**。

**适用**：主机多性能跟不上、跨机房、网络不稳定。

**环境**
| 功能 | 外网IP | 内网IP |
| --- | --- | --- |
| zabbix-server | 10.0.0.61 | |
| zabbix-proxy | 10.0.0.8 | 172.16.1.8 |
| zabbix-agent | 10.0.0.9 | 172.16.1.9 |

```bash
# 1. 安装 proxy
yum localinstall https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-proxy-mysql-3.4.12-1.el7.x86_64.rpm

# 2. 安装并初始化数据库
yum install mariadb-server -y && systemctl start mariadb
mysql
MariaDB [(none)]> create database zabbix_proxy default charset utf8;
MariaDB [(none)]> grant all on zabbix_proxy.* to zabbix_proxy@'localhost' identified by 'zabbix_proxy';

# 3. 只导入 schema
cd /usr/share/doc/zabbix-proxy-mysql-3.4.12/
zcat schema.sql.gz |mysql -uzabbix_proxy -pzabbix_proxy zabbix_proxy

# 4. 配置 proxy
grep '^[a-Z]' /etc/zabbix/zabbix_proxy.conf
Server=10.0.0.61
Hostname=Zabbix proxy     # 必须与 Web 代理程序名称一致
DBName=zabbix_proxy
DBUser=zabbix_proxy
DBPassword=zabbix_proxy
systemctl enable zabbix-proxy && systemctl start zabbix-proxy
netstat -lntp|grep 10051    # zabbix_proxy

# 5. Agent 指向 proxy
grep '^[a-Z]' /etc/zabbix/zabbix_agentd.conf
Server=172.16.1.8
ServerActive=172.16.1.8
Hostname=web03
systemctl restart zabbix-agent

# 6. Web：管理→agent代理程序（名称=Zabbix proxy）→配置→创建主机（主机名=web03，agent接口=172.16.1.9，由代理程序监测选proxy）
```
> 日志排错 `tail -f /var/log/zabbix/zabbix_proxy.log`：`proxy not found`（Web 代理名≠Hostname）、`host [web03] not found`（Web 主机名≠agent Hostname）。
> 优化：`Timeout=30`、`DataSenderFrequency=20`（主动模式下向 server 发送数据频率）。

## 2. Zabbix API（了解）

```bash
# 1. 获取 token
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0","method": "user.login",
"params": {"user": "Admin","password": "zabbix"},"id": 1}' http://10.0.0.61/zabbix/api_jsonrpc.php
# 返回 token：4f51830c86bdffebfbc4b5a92734260c

# 2. 禁用主机
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0","method": "host.update",
"params": {"hostid": "10289","status": 1},
"auth": "4f51830c86bdffebfbc4b5a92734260c","id": 1}' http://10.0.0.61/zabbix/api_jsonrpc.php

# 3. 删除主机
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0","method": "host.delete",
"params": ["10289"],
"auth": "4f51830c86bdffebfbc4b5a92734260c","id": 1}' http://10.0.0.61/zabbix/api_jsonrpc.php

# 4. 创建主机
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0","method": "host.create",
"params": {"host": "192.168.3.3",
"interfaces": [{"type":1,"main":1,"useip":1,"ip":"192.168.3.1","dns":"","port":"10050"}],
"groups": [{"groupid":"5"}],"templates": [{"templateid":"10095"}]},
"auth": "e42a8c26b5a66826f7c3b988d53d4a9f","id": 1}' http://10.0.0.61/zabbix/api_jsonrpc.php

# 5. 批量创建
cat zabbix_create.sh
#!/usr/bin/bash
GetToken=$(curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc":"2.0","method":"user.login",
"params":{"user":"Admin","password":"zabbix"},"id":1}' http://10.0.0.61/zabbix/api_jsonrpc.php)
Token=$(echo $GetToken|awk -F ',' '{print $2}'|awk -F '"' '{print $4}')
while read line;do
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc":"2.0","method":"host.create",
"params":{"host":"'"$line"'","interfaces":[{"type":1,"main":1,"useip":1,"ip":"'"$line"'","dns":"","port":"10050"}],
"groups":[{"groupid":"2"}],"templates":[{"templateid":"10001"}]},
"auth":"'"$Token"'","id":1}' http://10.0.0.61/zabbix/api_jsonrpc.php|python -m json.tool
done < /tmp/ip.txt
```

## 3. Zabbix 性能优化

1. **MySQL 拆分**：zabbix 写多读少，把数据库独立（拆 db）。
2. **改主动模式**：降低 server 轮询压力。
3. **用 Zabbix-Proxy**：分布式分担。
4. **精简监控项**：去掉无用项、加大取值间隔、缩短历史数据保留周期（housekeeper）。
5. **进程调优**：谁忙加谁的 Poller（`zabbix Poller / ipmi / icmp / http / proxy / java / snmp / vmware / discoverer Poller`）。
6. **缓存调优**：谁剩余内存少加谁的 `CacheSize`（如 `CacheSize=2G`）。
7. **关注「管理→队列」**：看监控项是否被延迟执行。

---

## 常见面试题

1. **Zabbix 基础架构？**
   agent 采集 → server 分析报警 → DB 存储 → web 展示。

2. **自定义监控通用流程？**
   服务自带 status/info → 写取值脚本 → 定义 `UserParameter` → `zabbix_get` 验证 → Web 加监控项/模板 → 关联主机。

3. **单条件与多条件触发器？**
   单条件：`{主机:项.last()}>阈值`；多条件用 `and/or` 组合（如内存低且 swap 高才报警）。

4. **自动发现 vs 自动注册？**
   自动发现是 server 被动扫描 IP 段（开销大、易丢机器）；自动注册是 agent 主动上报（高效，配 `ServerActive`）。

5. **何时用主动模式？**
   主机>300、Queue 有延迟、监控项多、要自动注册时。

6. **Zabbix Proxy 的作用与限制？**
   分布式代理，分担 server；不支持图形/报警、需要独立数据库、不能与 server 同机、名称须与 Web 代理程序一致。

7. **Zabbix 性能优化从哪几方面？**
   拆分 DB、改主动模式、上 Proxy、精简监控项/调间隔/缩保留周期、调 Poller 进程、调 CacheSize。

8. **Tomcat 怎么用 Zabbix 监控？**
   装 zabbix-java-gateway，server 配 `JavaGateway`/`StartJavaPollers`，tomcat 开启 JMX（`catalina.sh` 的 `CATALINA_OPTS`），Web 关联 Java 模板。

---

> 原文：<https://www.yuque.com/chengkanghua/oldboy50>
