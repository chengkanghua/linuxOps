# day64 Zabbix 06（分布式 Proxy、API、性能优化）

## 一、分布式监控 Zabbix Proxy

> 适用：跨地域/大规模监控，用 Proxy 分担 Server 压力。架构（Agent 主动 → Proxy → Server 均可主动）：

| 角色 | 外网 | 内网 | 地域 |
| --- | --- | --- | --- |
| Zabbix-Server | 10.0.0.71 | - | - |
| Zabbix-Proxy-node1 | 10.0.0.7 | 172.16.1.7 | 湖北 |
| Zabbix-Agent | 10.0.0.31 | 172.16.1.31 | 湖北 |
| Zabbix-Proxy-node2 | 10.0.0.8 | 172.16.1.8 | 上海 |
| Zabbix-Agent | 10.0.0.41 | 172.16.1.41 | 上海 |

### 安装配置 Proxy（以 node1/湖北 为例）
```bash
# 1. 安装（若报 mysql 冲突先卸载社区版 libs/client）
yum localinstall -y https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-proxy-mysql-3.4.14-1.el7.x86_64.rpm

# 2. 配 zabbix_proxy.conf
grep '^[a-Z]' /etc/zabbix/zabbix_proxy.conf
Server=10.0.0.71
Hostname=proxy_hb          # 必须定义，Web 添加代理时名称要一致
DBHost=localhost
DBName=zabbix_proxy
DBUser=zabbix_proxy
DBPassword=zabbix_proxy
Timeout=30
LogSlowQueries=3000

# 3. 安装并初始化本地数据库
yum install mariadb-server -y
systemctl start mariadb && systemctl enable mariadb
mysql
MariaDB [(none)]> create database zabbix_proxy default charset utf8;
MariaDB [(none)]> grant all on zabbix_proxy.* to zabbix_proxy@'localhost' identified by 'zabbix_proxy';

# 4. 导入 schema（只导架构，不用 data.sql）
cd /usr/share/doc/zabbix-proxy-mysql-3.4.14/
zcat schema.sql.gz |mysql -uzabbix_proxy -pzabbix_proxy zabbix_proxy

# 5. 启动
systemctl enable zabbix-proxy && systemctl start zabbix-proxy
netstat -lntp |grep 10051      # zabbix_proxy 监听 10051
```

### Agent 指向 Proxy
```bash
yum localinstall -y https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.14-1.el7.x86_64.rpm
grep '^[a-Z]' /etc/zabbix/zabbix_agentd.conf
Server=172.16.1.7
ServerActive=172.16.1.7
Hostname=nfs          # 必须和 Web 主机名一致
systemctl restart zabbix-agent
```

### Web 界面关联
1. 管理 → agent 代理程序 → 名称填 `proxy_hb`（与配置一致）。
2. 配置 → 创建主机 → 主机名称 `nfs`（与 hostname 对称）→ agent 接口填 `172.16.1.31` → 「由 agent 代理程序监测」选 `proxy_hb` → 链接模板（如 Template OS Linux）→ 更新。

> 日志排错：`tail -f /var/log/zabbix/zabbix_proxy.log`
> - `proxy "proxy_hb" not found`：Web 里 agent 代理程序名称与 `Hostname` 不一致。
> - `host [nfs01] not found`：Web 主机名与 agent `Hostname` 不一致。

### 新增第二个 Proxy（甘肃）
```bash
# 安装 Proxy、建库授权、导入 schema、配 zabbix_proxy.conf（Hostname=proxy_gs）、启动，步骤同 node1
# Agent 指向新 Proxy
grep '^[a-Z]' /etc/zabbix/zabbix_agentd.conf
Server=172.16.1.8
ServerActive=172.16.1.8
Hostname=backup      # 与 Web 主机名一致
systemctl enable zabbix-agent && systemctl start zabbix-agent
```

> Proxy 架构下 Agent 可用主动模式、Proxy 也可用主动模式；数据流：`Agent(监控项) → Proxy → Server`。

---

## 二、Zabbix API（了解）

> 通过 `api_jsonrpc.php` 用 JSON-RPC 操作，适合批量创建主机、自动化接入。

### 1. 获取令牌（token）
```bash
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0",
"method": "user.login",
"params": {"user": "Admin","password": "zabbix"},
"id": 1
}' http://10.0.0.71/zabbix/api_jsonrpc.php
# 返回：{"jsonrpc":"2.0","result":"981cac6b651d18cd9bc3d47c5560884a","id":1}
```

### 2. 禁用一台主机
```bash
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0",
"method": "host.update",
"params": {"hostid": "10286","status": 1},
"auth": "981cac6b651d18cd9bc3d47c5560884a","id": 1
}' http://10.0.0.71/zabbix/api_jsonrpc.php
```

### 3. 删除一台主机
```bash
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0",
"method": "host.delete",
"params": ["10286"],
"auth": "981cac6b651d18cd9bc3d47c5560884a","id": 1
}' http://10.0.0.71/zabbix/api_jsonrpc.php
```

### 4. 创建一台主机
```bash
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc": "2.0",
"method": "host.create",
"params": {
  "host": "xxxx",
  "interfaces": [{"type":1,"main":1,"useip":1,"ip":"192.168.3.1","dns":"","port":"10050"}],
  "groups": [{"groupid":"17"}],
  "templates": [{"templateid":"10001"}]
},
"auth": "981cac6b651d18cd9bc3d47c5560884a","id": 1
}' http://10.0.0.71/zabbix/api_jsonrpc.php
```

### 5. 批量添加（脚本）
```bash
cat zabbix_create.sh
#!/usr/bin/bash
GetToken=$(curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc":"2.0","method":"user.login",
"params":{"user":"Admin","password":"zabbix"},"id":1}' http://10.0.0.71/zabbix/api_jsonrpc.php)
Token=$(echo $GetToken|awk -F ',' '{print $2}'|awk -F '"' '{print $4}')
while read line;do
curl -s -X POST -H 'Content-Type:application/json' -d '{
"jsonrpc":"2.0","method":"host.create",
"params":{"host":"'$line'","interfaces":[{"type":1,"main":1,"useip":1,"ip":"'$line'","dns":"","port":"10050"}],
"groups":[{"groupid":"17"}],"templates":[{"templateid":"10001"}]},
"auth":"'$Token'","id":1}' http://10.0.0.71/zabbix/api_jsonrpc.php|python -m json.tool
done < /tmp/ip.txt
```

---

## 三、Zabbix 性能优化

### 架构层面
1. Zabbix 是**写多读少**业务，对 MySQL 做拆分（独立数据库）。
2. 把被动监控改为主动模式，降低 Server 轮询压力。
3. 大规模时用 **Zabbix-Proxy** 分布式监控，分担 Server 压力。

### Server 自身优化
4. 去掉无用监控项，调大不重要项的取值间隔（重要指标 30~60s，不重要删除或调大）。
5. 缩短历史数据保存周期（由 housekeeper 定时清理）。
6. **进程调优**：哪个 Poller 忙就加大其进程数（非越大越好，按实际）：
   - Zabbix Poller processes（agent 取值）
   - zabbix ipmi Poller（硬件）
   - zabbix icmp Poller（ping）
   - zabbix http Poller（web）
   - zabbix proxy Poller（分布式）
   - zabbix java Poller（JVM）
   - zabbix snmp Poller（网络）
   - zabbix vmware Poller（虚拟机）
   - zabbix discoverer Poller（自动发现）
7. **缓存调优**：谁剩余内存少就加大 `CacheSize`（如 `CacheSize=2G`）。
8. 关注 **管理 → 队列**，看是否有被延迟执行的监控项。

**关键监控图**
- Zabbix server performance（每秒取到的监控项数）
- Zabbix preprocessing queue（预处理队列）
- Zabbix internal process busy %（内部进程状态）
- Zabbix data gathering process busy %（数据采集繁忙度）
- Zabbix cache usage, % free（缓存使用率）

---

## 常见面试题

1. **Zabbix Proxy 的作用？**
   分布式监控代理，代替 Server 去采集下属 Agent 数据再汇总上报，跨地域/大规模时分担 Server 压力。

2. **Proxy 配置关键点？**
   `Hostname` 必须与 Web「agent 代理程序」名称一致；其下 Agent 的 `Server/ServerActive` 指向 Proxy 内网 IP；Agent `Hostname` 与 Web 主机名一致。

3. **Proxy 日志报 "proxy not found / host not found" 怎么排查？**
   名称不一致所致：核对 proxy 的 `Hostname` 与 Web 代理程序名、agent 的 `Hostname` 与 Web 主机名。

4. **Zabbix API 能做什么？**
   登录拿 token 后，可 host.create/update/delete，适合批量接入主机、自动化运维。

5. **Zabbix 性能优化从哪几方面入手？**
   架构：拆分 DB、改主动模式、上 Proxy；Server：精简监控项、调间隔、缩历史周期、调 Poller 进程数、调 CacheSize；关注队列延迟。

6. **Zabbix 是读多还是写多？数据库怎么设计？**
   写多读少；建议数据库独立（拆分），并合理设置历史数据保留周期。

---

> 更新：2019-01-12 22:07:44
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/amuae6>
