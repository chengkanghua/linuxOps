# 记录 sudo 日志

> 目标：把普通用户执行 `sudo` 的操作记录到独立日志文件 `/var/log/sudo.log`，便于审计与追溯"谁在什么时候用 root 权限做了什么"。

## 一、配置 sudoers 指定日志路径

```bash
# 1. 配置 /etc/sudoers 记录日志路径
echo "Defaults  logfile=/var/log/sudo.log" >>/etc/sudoers
# 查看追加的日志配置
tail -1 /etc/sudoers
Defaults  logfile=/var/log/sudo.log
# 检查语法（务必检查，否则可能导致 sudo 不可用）
visudo -c
```

## 二、配置 rsyslog 日志服务

```bash
# 2. 配置 rsyslog 日志服务
echo "local2.debug /var/log/sudo.log" >>/etc/rsyslog.conf
# 重启 rsyslog 服务使配置生效
systemctl restart rsyslog.service
```

## 三、验证

```bash
# 3. 普通用户使用 sudo 权限验证日志记录
# （普通用户配置到 visudo 中然后进行测试）
# 授权示例（visudo 中添加）：
# oldboy  ALL=(ALL)       /bin/ls, /bin/touch
# 之后以该用户执行 sudo 命令，检查日志：
tail -f /var/log/sudo.log
```

> **要点小结**
> - `Defaults logfile=...` 让 `sudo` 把自身日志写到指定文件（而非默认只进系统日志）。
> - `local2.debug` 是 sudo 使用的 syslog 设施（facility），需要在 `rsyslog.conf` 中声明输出目标。
> - 改完 `sudoers` 一定要 `visudo -c` 校验语法；改完 rsyslog 要重启服务。

> 更新: 2024-09-03 21:51:48
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/zeex9o>
