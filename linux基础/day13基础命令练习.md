# day13 基础命令练习

> 本文为 day13 基础命令练习，涵盖三剑客过滤、取网卡地址、date、打包压缩、字符串替换、PATH、关键路径、关机重启、命令行快捷键等。保留全部练习与答案。

## 一、通过三剑客进行过滤

```bash
sed   替换 / 后向引用
awk   取列
grep / egrep   过滤行

sed
sed  -n '10p'       oldboy.txt      # 打印第 10 行
sed  -n '/oldboy/p' oldboy.txt      # 打印包含 oldboy 的行

awk
awk      'NR==10'     oldboy.txt     # 打印第 10 行
awk      '/oldboy/'   oldboy.txt     # 打印包含 oldboy 的行
```

## 二、取网卡 IPADDR 地址

```bash
# 取 IPADDR 行
awk '/IPADDR/' /etc/sysconfig/network-scripts/ifcfg-eth0
# IPADDR=10.0.0.200

# 取等号后的值
awk -F= '/IPADDR/{print $2}' /etc/sysconfig/network-scripts/ifcfg-eth0
# 10.0.0.200

# 语法：'条件{动作}'
#   NR==2      第 2 行
#   NR>=10     第 10 行及以后

# 取出网卡 DNS
awk -F= '/DNS(1|2)/{print $2}' /etc/sysconfig/network-scripts/ifcfg-eth0
# 223.6.6.6
# 223.5.5.5
```

## 三、date 日期命令

```bash
# 显示一年前的日期
date -d '-1year'

# 显示 年-月-日_周几
date +%F_%w

# 设置系统时间
date -s '20180521 12:21:12'

# 同步阿里云时间服务器
ntpdate ntp1.aliyun.com
# ntp1.aliyun.com 为时间服务器，用于校对时间
```

## 四、打包压缩 /etc 到 /tmp（每天名字不同）

```bash
tar zcf /tmp/etc-`date +%F_%H`.tar.gz /etc
# 用 小时(%H) 保证每小时压缩包名不同；也可用 %F（每天）或 %F_%H_%M（每分钟）
```

## 五、查找当前目录所有文件并把 oldboy 换成 oldgirl

```bash
# 方法1：find + xargs
find ./ -type f | xargs sed -i 's#oldboy#oldgirl#g'

# 方法2：命令替换 $(...)
sed -i 's#oldboy#oldgirl#g' $(find ./ -type f)

# 方法3：find -exec
find ./ -type f -exec sed -i 's#oldboy#oldgirl#g' {} \;
```

## 六、让两条命令同一行输出

```bash
# 默认每条 echo 各占一行
echo "oldboy";echo "oldboy"

# -n 不显示结尾的回车（不换行）
echo -n 'oldboy';echo -n 'oldboy'

# -e 让 echo 支持转义字符 \n \t
echo -e 'oldboy\nnold\n\nlidao'
```

## 七、普通用户执行 ifconfig 提示 command not found

```bash
# 切换到普通用户 oldboy 后执行 ifconfig 提示 command not found
# 原因：PATH 环境变量问题（PATH 存放命令的搜索路径）
# 模拟：export PATH=     # 清空后所有命令都会找不到

# 修复方法：
# 1. 临时：export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
echo $PATH
# /usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

# 2. 永久：写入 /etc/profile 后生效
source /etc/profile

# 3. 检查
echo $PATH
```

## 八、描述下列路径的作用

```bash
/var/log/messages      系统默认日志
/var/log/secure        用户登录信息
/etc/fstab             开机自动挂载
/etc/hosts             解析主机名（域名）

# 修改主机名
#   1. 临时：hostname
#   2. 永久：CentOS6 改 /etc/sysconfig/network；CentOS7 改 /etc/hostname
#   3. 解析：/etc/hosts

/etc/rc.local          开机自启动脚本
/etc/profile           环境变量、别名
/var/spool/cron/root   定时任务(root)的配置文件
```

## 九、快速查到 ifconfig 全路径

```bash
# 先安装工具
yum install -y net-tools      # 提供 ifconfig
yum install -y mlocate        # 提供 locate

which ifconfig                # 显示命令的绝对路径
whereis ifconfig              # 显示命令相关文件信息

updatedb                     # 更新 locate 数据库（会占磁盘 IO）
locate ifconfig              # 按名字查找文件位置
```

## 十、查看系统在线用户

```bash
w
# 10:40:07 up 1 day, 16:38,  2 users,  load average: 0.00, 0.01, 0.00
# USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
# root  tty1   -      Thu12 20:24 0.38s 0.38s -bash
# root  pts/0 192.168.21.15 Sun20 0.00s 0.23s 0.00s w

# 报错：63 column window is too narrow  → 窗口太窄，放大终端即可

# 取在线用户数（第 1 行的第 6 列 / 倒数第 7 列）
w | awk -F' ' 'NR==1{print $6}'
# 2
w | awk -F' ' 'NR==1{print $(NF-6)}'
# 2
```

## 十一、正确关机和重启命令

```bash
# 重启
shutdown -r 10       # 10 分钟后重启
shutdown -r 0/now    # 立刻重启
shutdown -c          # 取消当前重启/关机计划
reboot               # 重启
init 6               # 重启

# 关机
halt
shutdown -h 10       # 10 分钟后关机
shutdown -h 0/now    # 立刻关机
poweroff
init 0
```

## 十二、命令行快捷键功能

```bash
Ctrl + a   光标移到行首
Ctrl + e   光标移到行尾
Ctrl + c   取消当前命令（cancel）
Ctrl + d   退出当前用户
Ctrl + l   清屏
Ctrl + u   删除光标到行首的内容（剪切）
Ctrl + k   删除光标到行尾的内容（剪切）
Ctrl + y   粘贴（粘贴 u/k 剪切的内容）
Ctrl + s   锁屏
Ctrl + q   解锁
Ctrl + r   搜索历史命令，回车即执行

# history 显示历史记录，配合 grep 筛选
history | grep awk
```

## 扩展练习

```bash
# 统计 /etc/passwd 中各类 shell 的数量，取前 3
cut -d ':' -f7 /etc/passwd | sort | uniq -c | sort -nr | head -3
#     15 /sbin/nologin
#      1 /sbin/shutdown
#      1 /sbin/halt

cut -d ':' -f7 /etc/passwd | sort | uniq -c | sort -nr | column -t
# 15  /sbin/nologin
# 1   /sbin/shutdown
# 1   /sbin/halt
# 1   /bin/sync
# 1   /bin/bash

# nginx 日志统计 IP 访问量排名前 5
cut -d ' ' -f1 access.log | sort | uniq -c | sort -nr | head -5 | column -t
# 7326  122.71.226.14
# 3708  123.66.148.193
# 1638  122.71.243.118
# 936   122.71.70.94
# 738   223.72.40.36
```

参考附件：[access.txt](https://www.yuque.com/attachments/yuque/0/2019/txt/194754/1553423006142-9c45f67e-9cb8-4dcc-8cce-7dc9b67f60c1.txt)

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/qf6ogy>
