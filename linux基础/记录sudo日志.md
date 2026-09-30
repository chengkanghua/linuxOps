# 记录sudo日志

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- 记录sudo日志

# 记录sudo日志

```bash
# 1、配置/etc/sudoers记录日志路径
echo "Defaults  logfile=/var/log/sudo.log" >>/etc/sudoers
# 查看追加的日志配置
tail -1 /etc/sudoers  
Defaults  logfile=/var/log/sudo.log
# 检查语法
visudo -c      

# 2.配置rsyslog日志服务
echo "local2.debug /var/log/sudo.log" >>/etc/rsyslog.conf  
# 重启rsyslog服务
systemctl restart rsyslog.service    

# 3.普通用户使用sudo权限验证日志记录
# （普通用户配置到visudo中然后进行测试）

```



> 更新: 2024-09-03 21:51:48  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/zeex9o>