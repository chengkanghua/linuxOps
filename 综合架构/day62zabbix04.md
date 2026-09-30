# day62 Zabbix 04（应用服务监控）

> 应用监控对象：Nginx、PHP-FPM、MySQL、Redis、Tomcat、Rsync、NFS 等。通用方法：
> 1. 判断软件是否自带 status/info 信息（找到要监控的指标并取值）；
> 2. 编写监控项（命令或脚本）；
> 3. `zabbix_get` 测试取值；
> 4. Web 添加监控项 → 应用集 → 模板；
> 5. 关联主机 → 引用模板。

---

## 一、Nginx 监控

### 1. 开启 stub_status
```bash
cat status.conf
server {
  listen 80;
  server_name _;
  location /nginx_status {
    stub_status;
    access_log off;
    allow 127.0.0.1;
    deny all;
  }
}
```

### 2. 取值
```bash
curl 127.0.0.1/nginx_status
# Active connections: 1
# server accepts handled requests
# 1 1 1
# Reading: 0 Writing: 1 Waiting: 0

accepts   curl -s 127.0.0.1/nginx_status|awk 'NR==3{print $1}'
handled   curl -s 127.0.0.1/nginx_status|awk 'NR==3{print $2}'
requests  curl -s 127.0.0.1/nginx_status|awk 'NR==3{print $NF}'
```

### 3. 取值脚本（建议放 `/etc/zabbix/zabbix_agentd.d/scripts/`）
```bash
#!/usr/bin/bash
# nginx_status.sh
HOST="127.0.0.1"
PORT=80
case $1 in
  active)   curl -s "http://$HOST:$PORT/nginx_status" |awk 'NR==1{print $NF}' ;;
  accepts)  curl -s "http://$HOST:$PORT/nginx_status" |awk 'NR==3{print $1}' ;;
  handled)  curl -s "http://$HOST:$PORT/nginx_status" |awk 'NR==3{print $2}' ;;
  requests) curl -s "http://$HOST:$PORT/nginx_status" |awk 'NR==3{print $NF}' ;;
  reading)  curl -s "http://$HOST:$PORT/nginx_status" |awk 'NR==4{print $2}' ;;
  writing)  curl -s "http://$HOST:$PORT/nginx_status" |awk 'NR==4{print $4}' ;;
  waiting)  curl -s "http://$HOST:$PORT/nginx_status" |awk 'NR==4{print $6}' ;;
  *) echo "Usage: $0 [active|accepts|handled|requests|reading|writing|waiting]" ;;
esac
```

### 4. 自定义监控项
```bash
cat /etc/zabbix/zabbix_agentd.d/nginx.conf
UserParameter=nginx_status[*],/usr/bin/bash /etc/zabbix/zabbix_agentd.d/scripts/nginx_status.sh "$1"
```

### 5. 服务端验证
```bash
zabbix_get -s 172.16.1.8 -k nginx_status[accepts]
# 10
```

### 6. 导入 Nginx 模板并关联主机
配置 → 模板 → 导入；关联主机 → 等待获取值；模板自带图形，可直接出报表。
```bash
ab -n10000 -c200 http://127.0.0.1/nginx_status    # 压测验证
```

> 多台相同主机监控 Nginx：① 都开 status 模块；② 脚本一致；③ 监控项名称一致；④ 用同一模板。

---

## 二、Nginx 日志状态码监控（200/301/302/404/403/500/502/504）

```bash
# 取值脚本
cat /etc/zabbix/zabbix_agentd.d/scripts/nginx_log.sh
#!/usr/bin/bash
awk -vS=$1 '{if($9==S) sum++}END{print sum}' /var/log/nginx/access.log

# 监控项
cat /etc/zabbix/zabbix_agentd.d/nginx.conf
UserParameter=nginx_status[*],/usr/bin/bash /etc/zabbix/zabbix_agentd.d/scripts/nginx_status.sh "$1"
UserParameter=nginx_log[*],/usr/bin/bash /etc/zabbix/zabbix_agentd.d/scripts/nginx_log.sh "$1"
systemctl restart zabbix-agent

# 服务端验证
zabbix_get -s 172.16.1.8 -k nginx_log[404]
# 20283
```
Web 建模板、逐个加监控项、加图形，主机引用模板。

---

## 三、PHP-FPM 监控

```bash
# 1. 开启 status（php-fpm.conf）
vim /etc/php-fpm.d/www.conf
pm.status_path = /phpfpm_status
systemctl restart php-fpm

# 2. Nginx 暴露 status
location ~ /phpfpm_status {
  include fastcgi_params;
  fastcgi_pass    127.0.0.1:9000;
  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}

# 3. 取值测试
curl http://127.0.0.1/phpfpm_status
# pool: www  process manager: dynamic  start since: 409
# accepted conn: 22  listen queue: 0  max listen queue: 0
# idle processes: 4  active processes: 1  total processes: 5
# max active processes: 2  max children reached: 0  slow requests: 0
```

**PHP-FPM 状态字段含义**
| 字段 | 含义 |
| --- | --- |
| pool | fpm 池名称（多为 www） |
| process manager | 进程管理方式 dynamic/static |
| start time / start since | 启动时间 / 已运行时间 |
| accepted conn | 当前池接受的连接数 |
| listen queue | 请求等待队列（**长期 >0 需加进程数**） |
| max listen queue | 等待队列峰值 |
| listen queue len | socket 等待队列长度 |
| idle processes | 空闲进程数（长期为 0 要报警） |
| active processes | 活跃进程数 |
| total processes | 总进程数 |
| max active processes | 最大活跃进程数 |
| max children reached | 达到进程上限次数（>0 说明进程数偏小，需调大） |
| slow requests | 超过 5s 的慢请求数 |

```bash
# 4. 取值 + 监控项
curl -s http://127.0.0.1/phpfpm_status|grep "$1"|awk '{print $NF}'
cat /etc/zabbix/zabbix_agentd.d/php.conf
UserParameter=fpm[*],curl -s http://127.0.0.1/phpfpm_status|grep ^"$1":|awk '{print $NF}'

# 5. 服务端验证
zabbix_get -s 172.16.1.8 -k fpm["accepted conn"]
# 50077
```

**触发器（多条件练习）**：空闲进程=0 或 队列>0 持续 1 分钟报警
```
{Fpm Status:fpm["idle processes"].avg(1m)}=0 or {Fpm Status:fpm["listen queue"].avg(1m)}>30
```
Web 加模板、监控项、触发器（邮件）、图形；`ab -n10000 -c200 http://127.0.0.1/phpfpm_status` 模拟故障。

---

## 四、Redis 监控（内存数据库）

```bash
yum install redis -y
systemctl start redis      # 监听 6379
redis-cli info
# connected_clients:1
# used_memory_human:794.38K
# used_memory_rss_human:5.65M
```
参考：<http://www.yanglixun.com/?p=176>
> 方法同前：① info 自带状态；② 取值；③ 加监控项；④ 导入模板、加触发器、画图形。

---

## 五、MySQL 监控（Percona 插件）

> 用 Percona 官方插件监控 MySQL（自带脚本 + conf + Web 模板）。

```bash
# 前置：Zabbix agent, php, php-mysql 已装
# 1. 安装 percona 模板
yum install -y https://www.percona.com/downloads/percona-monitoring-plugins/percona-monitoring-plugins-1.1.8/binary/redhat/7/x86_64/percona-zabbix-templates-1.1.8-1.noarch.rpm

# 2. 查看文件位置
rpm -ql percona-zabbix-templates
# /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh
# /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php
# /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf
# /var/lib/zabbix/percona/templates/zabbix_agent_template_percona_mysql_server_ht_2.0.9-sver1.1.8.xml

# 3. 填数据库账号密码
vim /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php
$mysql_user = 'root';
$mysql_pass = 'Bgx123.com';

# 4. 测试取值
sh /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh gg
# 6

# 5. 自定义监控项
cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.d/
systemctl restart zabbix-agent

# 6. 服务端取值
zabbix_get -s 172.16.1.51 -k MySQL.Key-read-requests
# 6（若报 /tmp 文件删不掉，不影响取值）

# 7. 导入模板并关联 MySQL 主机
```

---

## 六、作业（视频）

0. 对象：Rsync、NFS、Nginx、PHP、MySQL
1. 2 台 web（Nginx+PHP）、1 台 MySQL、1 台 NFS、1 台 Rsync（`.conf` 监控项一样，模板不一样）
2. 自定义监控项、触发器、动作
3. 制作模板、导入导出

> 用 **Ansible** 统一：安装 agent、配置 agent、推送脚本、推送 `.conf` 文件。

---

## 常见面试题

1. **应用服务监控的通用流程？**
   看软件是否自带 status/info → 写取值脚本 → 定义 `UserParameter` → `zabbix_get` 验证 → Web 建模板/监控项/触发器/图形 → 关联主机。

2. **Nginx 怎么监控？**
   开 `stub_status`，用脚本取 active/accepts/handled/requests 等，配 `UserParameter=nginx_status[*]`。

3. **Nginx 状态码怎么监控？**
   用脚本统计 access.log 中 `$9` 等于目标码的行数（如 `nginx_log[404]`）。

4. **PHP-FPM 状态里 listen queue 长期 >0 说明什么？**
   FPM 进程不够，请求在排队，需要调大 `pm.max_children` 等进程数。

5. **MySQL 用什么方案监控？**
   Percona Monitoring Plugins：装 rpm → 改 php 脚本的库账号密码 → 复制 userparameter conf → 导入模板关联主机。

6. **多台相同服务怎么高效部署监控？**
   统一脚本和 `UserParameter`，用同一个模板；脚本和 conf 用 Ansible 批量推送。

---

> 更新：2019-01-12 21:38:56
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/mcvuev>
