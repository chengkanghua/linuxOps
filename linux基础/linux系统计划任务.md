# Linux 系统计划任务

> 基础课程：Linux **Crond 计划任务**。内容涵盖：① Crond 计划任务概述 ② crond 配置文件详解 ③ crond 计划任务管理 ④ crond 配置编写实例 ⑤ crond 计划任务调试。

## 一、Crond 计划任务概述

**什么是计划任务**：计划任务类似于我们平时生活中的**闹钟**。在 Linux 系统中，计划任务服务 `crond` 可以满足**周期性执行任务**的需求。

- `crond` 进程**每分钟会处理一次**计划任务
- 计划任务主要用于做一些周期性的任务，目前最主要的用途是**定时备份数据**

**调度方式对比**：

| 方式 | 说明 |
| --- | --- |
| `at` | Schedule one-time tasks with at —— 一次性调度执行 |
| `cron` | Schedule recurring jobs with cron —— 循环调度执行 |

> **所有计划任务执行中的输出都会以邮件的方式发送给指定用户，除非重定向。**

```bash
# 循环调度执行：cron 进程每分钟会处理一次计划任务
[root@server ~]# systemctl status crond.service
[root@server ~]# ps aux | grep crond
root   1201  0.0  0.0 126264  1640 ?   Ss   11:15   0:00 /usr/sbin/crond -n
```

**计划任务分为两种情况**：

1. **系统级别的定时任务**
   - 清理系统缓存
   - 临时文件清理
   - 系统信息采集
   - 日志文件切割
2. **用户级别的定时任务**
   - 定时同步互联网时间
   - 定时备份系统配置文件
   - 定时备份数据库文件

## 二、crond 配置文件详解

| 文件 | 说明 |
| --- | --- |
| `/etc/crontab` | Crontab 配置文件 |
| `/etc/cron.deny` | 该文件中所列用户不允许使用 crontab 命令 |
| `/var/spool/cron/*` | 所有用户定时文件都存放此目录，文件以用户名命名 |
| `/var/log/cron*` | 定时任务执行后的日志文件，可用来回溯 |

## 三、crond 计划任务管理

### 1. crontab 命令参数

```bash
[root@server ~]# crontab --help
```

| 参数 | 含义 | 指定示例 |
| --- | --- | --- |
| `-e` | 编辑 crontab 文件内容 | `crontab -e` |
| `-l` | 查看 crontab 文件内容 | `crontab -l` |
| `-r` | 删除 crontab 文件内容 | `crontab -r` |
| `-u` | 管理其他用户的计划任务 | `crontab -u server -l` |

> **注意**：`crontab -l / -e` 实际上就是在操作 `/var/spool/cron/username`。

### 2. crond 时间含义

```plain
# Example of job definition:
# .---------------- minute (0 - 59)                        // 分钟
# |  .------------- hour (0 - 23)                          // 小时
# |  |  .---------- day of month (1 - 31)                  // 日期
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr      // 月份
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7)    // 星期
# |  |  |  |  |      OR sun,mon,tue,wed,thu,fri,sat
# *  *  *  *  *   command to be executed
```

| 符号 | 含义 |
| --- | --- |
| `*` | 表示任意的（分、时、日、月、周）时间都执行 |
| `-` | 表示一个时间范围段，如 `5-7` 点 |
| `,` | 表示分隔时段，如 `6,0,4` 表示周六、周日、周四 |
| `/n` | 表示每隔 n 单位时间，如 `*/10` 每 10 分钟 |

### 3. crond 编写示例

```bash
00 02 * * * ls        # 每天 2:00 整
00 02 1 * * ls        # 每月 1 号 2:00 整
00 02 14 2 * ls       # 每年 2 月 14 号 2:00 整
00 02 * * 7 ls        # 每周日 2:00 整
00 02 * 6 5 ls        # 每年 6 月的周五 2:00 整
00 02 14 * 7 ls       # 每月 14 号 2:00 整 或 每周日 2:00 整，这两个时间都执行
00 02 14 2 7 ls       # 每年 2 月 14 号 2:00 整 或 每周日 2:00 整，这两个时间都执行
00 02 * * * ls        # 每天 2:00 整
*  02 * * * ls        # 每天 2:00 中的每一分钟（逻辑错误）
* * * * *  ls         # 每分钟执行 ls
* * 14 2 *  ls        # 2 月 14 号的每分钟（逻辑错误）
*/5 * * * *  ls       # 每隔 5 分钟
00 02 * 1,5,8 * ls    # 每年 1、5、8 月的每天 2:00 整
00 02 1-8 * *  ls     # 每月 1 到 8 号的 2:00 整
```

### 4. crond 书写规范

**① 为计划任务增加必要的注释**
```bash
[root@server ~]# crontab -l
##time sync by server 2018-00-00
*/5 * * * * /usr/sbin/ntpdate time.windows.com &>/dev/null
```

**② 规范计划任务执行脚本存放的路径 `/soft/scripts/`**
```bash
[root@server ~]# crontab -l
##backup www to /backup server 2018-00-00
00 01 * * * /bin/sh /soft/scripts/www_backup.sh &>/dev/null
```

**③ 执行 shell 脚本任务前加 `/bin/sh`，脚本结尾加 `&>/dev/null`**
```bash
[root@server ~]# crontab -l
####backup www to /backup server 2018-00-00
00 01 * * * /bin/sh /soft/scripts/www_backup.sh &>/dev/null
```
> 调试好后应屏蔽 debug 输出信息，避免产生系统垃圾占用过多 inode；如需输出日志，可重定向至日志文件。

## 四、crond 配置编写实例

```bash
[root@server ~]# crontab -e

# 每天凌晨切割 nginx 日志
00 00 * * * /bin/sh -x /soft/scripts/cut_nginx.sh &> /soft/scripts/log/nginx.log

# 每天 5 点备份数据库
00 05 * * * /bin/sh -x /soft/scripts/dump_sql.sh &>/soft/scripts/log/mysql.log

# 每 5 分钟检测数据库是否正常
*/5 * * * * /bin/sh /soft/scripts/start_mysql.sh &>/dev/null
```

> **注意**：
> 1. `crond` 是运行的**程序/服务**；`crontab` 命令是用户用来**设置定时规则**的命令。
> 2. `crond` 服务是企业生产工作中常用的重要服务，`at` 很少使用，可以忽略。
> 3. 几乎每个服务器都会用到 `crond` 服务。

## 五、crond 计划任务调试

**调试要点**：

1. 调整任务为每分钟执行，检测是否正常（有些任务不要频繁执行）
2. 调整系统时间然后再检测任务（生产不建议直接使用此方式）
3. 执行脚本，将脚本执行输出写入指定日志文件，观察日志内容是否正常
4. 注意一些任务命令带来的问题：`echo "server" >>/tmp/xlw.log &>/dev/null`
5. 命令使用**绝对路径**，防止无法找到命令导致定时任务执行故障
6. 查看 `/var/log/cron` 日志进行调试

> **建议**：将需要定期执行的任务写入脚本中，建立 `/soft/scripts` 目录统一存放脚本，脚本中命令必须使用绝对路径，手动执行脚本检测输出是否正常，然后将脚本加入计划任务测试，测试后无问题将脚本输出写入对应的日志文件中即可。

**推荐流程（5 步）**：

1. **手动执行**：保留执行命令的正确结果
2. **编写脚本**
   - 脚本需要统一路径 `/soft/scripts`
   - 脚本开头建议填写注释信息，包括执行时间、周期、任务
   - 脚本内容复制执行成功的命令至脚本文件中（减少每个环节出错几率）
   - 脚本内容尽可能优化，使用一些变量或简单的判断语句
   - 脚本执行的输出信息不要随意打印，可重定向至其他位置保留或丢入黑洞
3. **执行脚本**
   - 用 `bash` 执行，防止脚本没有增加执行权限（`/usr/bin/bash`）
   - 执行命令及脚本成功后，复制该命令
4. **编写计划任务**
   - 加上必要的注释信息：人、时间、任务
   - 设定计划任务执行的周期
   - 粘贴执行脚本的命令（不要手敲）
5. **调试计划任务**
   - 增加任务频率测试、调整系统时间测试（不能用于生产）
   - 检查环境变量问题、检查 crond 服务产生日志进行排查

> 来源：`linux系统计划任务.pdf`（原附件：<https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1554022051031-042edb15-5062-4d27-8229-446fd258b937.pdf>）
