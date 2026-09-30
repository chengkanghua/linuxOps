# day61 Zabbix 03（图形、模板、扩展主机）

## 一、调整中文字体（乱码修复）

Zabbix 图形中文乱码，本质是字体缺失，替换为中文字体即可：

```bash
# 1. 找 zabbix-web 字体目录
rpm -ql zabbix-web |grep fonts
# /usr/share/zabbix/fonts

# 2. 发现 graphfont.ttf 是软链接
cd /usr/share/zabbix/fonts/ && ll
# graphfont.ttf -> /etc/alternatives/zabbix-web-font

# 3. 顺藤摸瓜找到真实字体
cd /etc/alternatives/ && ll
# zabbix-web-font -> /usr/share/fonts/dejavu/DejaVuSans.ttf
cd /usr/share/fonts/dejavu/

# 4. 备份并替换为中文字体（可从 Windows c:\windows\fonts 取，ttc 改 ttf 也行）
mv DejaVuSans.ttf DejaVuSans.ttf_bak
mv simhei.ttf DejaVuSans.ttf
```

---

## 二、聚合图形 / 幻灯片 / 图形树

层级关系：**监控项 → 图形 → 聚合图形（Screen）→ 幻灯片（轮播）→ 图形树 → zabbix+grafana 出图（最炫）**。

- **聚合图形**：多张图放一起看重要指标（如 10 台服务器各一张）。
- **幻灯片**：轮播播放聚合图形（类似 PPT 自动播放），只能添加聚合图形。
- **图形树（graphtree，第三方）**：
```bash
cd /usr/share/zabbix
wget https://raw.githubusercontent.com/OneOaaS/graphtrees/master/graphtree3.0.4.patch
yum install -y patch
patch -Np0 < graphtree3.0.4.patch
chown -R apache.apache oneoaas
# 新增 Apache 配置
vim /etc/httpd/conf.d/zabbix.conf
Alias /oneoaas /usr/share/zabbix/oneoaas
systemctl restart httpd
```

---

## 三、再扩展一台服务器

```bash
# 1. 安装 agent
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.14-1.el7.x86_64.rpm
# 2. 指向 server
sed -i  '/^Server=/c Server=172.16.1.71' /etc/zabbix/zabbix_agentd.conf
# 3. 启动并开机自启
systemctl enable zabbix-agent && systemctl start zabbix-agent
# 4. Web 添加主机 + 引用系统自带模板
# 5. 给该主机添加自定义模板
```

**自定义模板要点**
1. 模板支持导入/导出，但模板里的监控项依赖 `/etc/zabbix/zabbix_agentd.d/*.conf` 支撑。
2. `*.conf` 用于自定义监控项，靠系统命令或脚本采集数据。
3. 主机要用自定义模板：① 先导入 conf（监控项）② 再 Web 创建主机并链接模板。
4. 注意：很多 conf 不一定适合每台主机，建议按需要导入；想复用监控项 → 监控项全选 → 复制 → 做成模板。

> 手动一台台 `scp /etc/zabbix_agentd.conf /etc/zabbix_agent.d/*.conf` 太慢，可用 **Ansible** 自动化（后续章节）。

---

## 四、监控 Nginx（自定义监控完整链路）

> 链路：模板 → 监控项依赖 `.conf` → `.conf` 依赖脚本取值 → 脚本获取想要的数据。

```bash
# 1. Nginx 开启 stub_status（被监控机）
vim /etc/nginx/conf.d/status.conf
server {
  listen 80;
  server_name status.oldboy.com;
  location /nginx_status {
    stub_status;
    access_log off;
  }
}

# 2. agent 端取值脚本 /etc/zabbix/zabbix_agentd.d/nginx.conf
UserParameter=nginx.status[*],/bin/bash /server/scripts/nginx_status.sh $1

# 3. 取值脚本（示例取 active 连接数）
cat /server/scripts/nginx_status.sh
#!/bin/bash
NGINX_PORT=80
NGINX_HOST=127.0.0.1
case $1 in
  active)    curl -s "http://$NGINX_HOST:$NGINX_PORT/nginx_status" |awk 'NR==1{print $NF}' ;;
  accepts)   curl -s "http://$NGINX_HOST:$NGINX_PORT/nginx_status" |awk 'NR==3{print $1}' ;;
  *) echo "Usage: $0 [active|accepts|handled|requests|reading|writing|waiting]" ;;
esac

# 4. 本地与服务端验证后，Web 建监控项 + 模板
zabbix_agentd -p |grep nginx.status
zabbix_get -s 172.16.1.7 -k nginx.status[active]
```

---

## 五、自定义监控体系总结

1. **系统自带监控项**：CPU、内存、网络、IO、进程、监听端口等。
2. **自定义监控项**：只要能取到状态就能监控（`UserParameter`）。
3. **自定义触发器**：
   - 系统自带模板阈值偏低，需调整；
   - 单条件：一个监控项一个触发器；
   - 多条件：多个监控项共用一个触发器。
   - 函数：`last`、`avg`、`diff`、`nodata`、`avg(5m)`、`avg(#5)`。
4. **自定义报警**：
   - 内容修改、通知方式（邮件/微信/短信/电话/钉钉）；
   - 执行远程命令（ssh 或 sudo）；
   - 报警升级：1-2 步骤执行远程命令，3-4 步骤通知管理员；
   - 告警变量：`{HOST.NAME}`、`{ITEM.NAME}`、`{TRIGGER.NAME}` 等。
5. **自定义图形**：基础图形 → 聚合图形（Screen）→ 幻灯片 → graphtree → zabbix+grafana。
6. **自定义模板**：包含监控项/触发器/图形，主机引用即全部载入，支持导入导出。

---

## 六、作业

1. 所有主机恢复初始状态（≥3 台）。
2. 安装 zabbix-server 和 zabbix-agent。
3. 编写自定义监控 tcp 的脚本。
4. 监控 nginx 状态，不存在则报警（设触发器）。
5. 设定报警：① 远程命令重试启动 nginx；② 通知方式（邮件/微信）；③ 升级通知领导。
6. 创建图形 → 创建聚合图形 → 制作幻灯片。
7. 制作为模板。
8. 扩展：Grafana 炫图。

---

## 常见面试题

1. **Zabbix 图形中文乱码怎么解决？**
   替换字体：把软链接最终的 `DejaVuSans.ttf` 换成中文字体（如 simhei.ttf）。

2. **聚合图形和幻灯片的层级关系？**
   监控项 → 图形 → 聚合图形（Screen）→ 幻灯片（轮播）；幻灯片只能放聚合图形。

3. **自定义模板导入导出要注意什么？**
   模板导出不含 `*.conf` 监控项定义，必须同时把 `/etc/zabbix/zabbix_agentd.d/*.conf` 一起分发到 agent，否则监控项变"不支持"。

4. **监控 Nginx 怎么实现？**
   开 `stub_status`，agent 端写 `UserParameter` 调取值脚本，验证后 Web 建监控项并归入模板。

5. **报警升级机制怎么设计？**
   动作步骤分级：前几步执行远程命令（自愈），后续步骤逐级通知运维→经理→总监，按主机分组可发给不同人。

---

> 更新：2019-01-12 21:29:09
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/ufqc0n>
