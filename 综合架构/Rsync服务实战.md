# Rsync 服务实战

> 一套完整的「客户端本地打包 → 推送到服务端 → 服务端校验并邮件通知」备份方案。

## 一、需求

**客户端（所有业务服务器）**
1. 每天凌晨 01 点本地打包备份（系统配置、日志、应用配置等）。
2. 备份存放到以 `主机名_IP_当前时间` 命名的目录，如 `/backup/nfs-server_172.16.1.31_2018-09-02`。
3. 通过 rsync 把本地打包好的备份推送到 backup 服务器。
4. 本地仅保留最近 **7 天** 数据，避免浪费磁盘。

**服务端（backup 服务器）**
1. 部署 rsync，接收客户端推送的备份。
2. 每天校验客户端推送的数据是否完整（md5）。
3. 把校验结果邮件通知管理员。
4. 仅保留 **6 个月（180 天）** 的备份数据。

> 注意：所有服务器的备份目录必须都是 `/backup`。

---

## 二、环境准备（服务端）

```bash
# 1. 安装
yum -y install rsync

# 2. 配置 /etc/rsyncd.conf
cat > /etc/rsyncd.conf<<EOF
uid = rsync
gid = rsync
port = 873
fake super = yes
use chroot = no
max connections = 200
timeout = 600
ignore errors
read only = false
list = false
auth users = rsync_backup
secrets file = /etc/rsync.password
log file = /var/log/rsyncd.log
#####################################
[backup]
comment = welcome to oldboyedu backup!
path = /backup
EOF

# 3. 创建运行用户与备份目录
useradd -M -s /sbin/nologin rsync
mkdir /backup
chown -R rsync.rsync /backup/

# 4. 虚拟用户密码文件（客户端连接时使用）
echo "rsync_backup:1" >/etc/rsync.password
chmod 600 /etc/rsync.password

# 5. 启动并开机自启
systemctl start rsyncd
systemctl enable rsyncd

# 6. 检查端口 873
netstat -lntp |grep 873

# 7. 测试
# 客户端也装 rsync（不启动服务）
rsync -avz /etc/passwd rsync_backup@10.0.0.7::backup                      # 推送
rsync -avz rsync_backup@10.0.0.7::backup /opt                            # 拉取

# 无密码方式（指定密码文件）
echo "1" > /etc/rsync.password
chmod 600 /etc/rsync.password
rsync -avz rsync_backup@10.0.0.7::backup /opt --password-file=/etc/rsync.password

# 无密码方式（环境变量）
export RSYNC_PASSWORD=1
rsync -avz rsync_backup@10.0.0.7::backup /opt
```

**其他常用操作**
```bash
# 强制一致性：让 PC 和 U 盘完全一致（--delete 删除目标多余文件）
rsync -avz --delete rsync_backup@10.0.0.7::backup/ /data/ --password-file=/etc/rsync.password
rsync -avz --delete /data/ rsync_backup@10.0.0.7::backup/ --password-file=/etc/rsync.password

# 限速（避免打满带宽）
dd if=/dev/zero of=/opt/test.dosk bs=1M count=1024
rsync -avzP --bwlimit=1 /opt/test.dosk rsync_backup@10.0.0.7::backup
```

**定时批量测试（模拟 30 天）**
```bash
for i in {1..30}; do date -s 2018/08/$i && sh /server/scripts/client_rsync_backup.sh; done
```

---

## 三、客户端推送脚本

```bash
cat > /server/scripts/client_rsync_backup.sh<<'EOF'
#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#1.定义变量
Host=$(hostname)
Addr=$(ifconfig eth0|awk 'NR==2{print $2}')
Date=$(date +%F)
Dest=${Host}_${Addr}_${Date}
Path=/backup

#2.创建备份目录
[ -d $Path/$Dest ] || mkdir -p $Path/$Dest

#3.备份对应文件
[ -f $Path/$Dest/system.tar.gz ] || tar czf $Path/$Dest/system.tar.gz /etc/fstab /etc/rsyncd.conf && \
[ -f $Path/$Dest/log.tar.gz ]    || tar czf $Path/$Dest/log.tar.gz    /var/log/messages /var/log/secure

#4.携带md5校验信息
[ -f $Path/$Dest/flag ] || md5sum $Path/$Dest/*.tar.gz > $Path/$Dest/flag_${Date}

#5.推送本地数据至备份服务器
export RSYNC_PASSWORD=1
rsync -avz $Path/ rsync_backup@10.0.0.4::backup

#6.本地保留最近7天
find $Path/ -type d -mtime +7|xargs rm -rf
EOF
```

---

## 四、服务端接收、校验并邮件通知

### 1. 配置发件（mailx）
```bash
yum install mailx -y
cat > /etc/mail.rc<<EOF
set from=343264992@163.com
set smtp=smtps://smtp.163.com:465
set smtp-auth-user=343264992@163.com
set smtp-auth-password=aa123456
set smtp-auth=login
set ssl-verify=ignore
set nss-config-dir=/etc/pki/nssdb/
EOF
# 登录 163 邮箱，开启 IMAP/SMTP 与 POP3/SMTP 服务，新增授权密码填入 smtp-auth-password
# 测试
mail -s "test$(date +%F)" 343264992@qq.com </etc/passwd
```

### 2. 服务端校验脚本
```bash
mkdir /server/scripts -p
cat > /server/scripts/check_backup.sh<<'EOF'
#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
Path=/backup
Date=$(date +%F)

# 3.校验 flag 文件中的 md5，结果保存到 result_时间
find $Path/*_${Date} -type f -name "flag_$Date"|xargs md5sum -c >$Path/result_${Date}
# find $Path/*_${Date} -type f -name "flag_$Date" -exec md5sum -c {} \; >$Path/result_${Date}

# 4.校验结果邮件发给管理员
mail -s "Rsync Backup $Date" 343264992@qq.com <$Path/result_${Date}

# 5.清理：超过7天的校验结果、超过180天的备份数据
find $Path/ -type f -name "result*" -mtime +7|xargs rm -f
find $Path/ -type d -mtime +180|xargs rm -rf
EOF
```

### 3. 定时任务
```bash
# 多台客户端：每天 01:00 执行推送
# crontab -l
00 01 * * * /usr/bin/bash /server/scripts/client_rsync_backup.sh >/dev/null 2>&1

# 服务端：每天 05:00 执行校验+通知
# crontab -l
00 05 * * * /usr/bin/bash /server/scripts/check_backup.sh >/dev/null 2>&1
```

---

## 五、常见面试题

1. **rsync 服务端配置里 `fake super = yes` 有什么用？**
   让 rsync 进程（如以 rsync 普通用户运行）能保留文件的属主/权限等元数据，无需以 root 运行，提升安全性。

2. **`--delete` 参数是做什么的？**
   使目标目录与源完全一致，删除目标中源没有的文件（强制同步）。生产慎用，避免误删。

3. **客户端怎么免密推送？**
   两种方式：① `--password-file` 指定密码文件（`chmod 600`）；② 环境变量 `RSYNC_PASSWORD=xxx`。

4. **md5 校验在备份方案中的作用？**
   客户端打包后生成 `flag` 文件记录各包 md5；服务端 `md5sum -c` 校验完整性，结果邮件通知，确保备份没损坏。

5. **`--bwlimit` 一般什么时候用？**
   备份大文件时限制传输速率，避免打满带宽影响业务。

6. **本地保留 7 天、服务端保留 180 天是怎么实现的？**
   用 `find ... -mtime +N` 配合 `rm`：客户端 `-mtime +7`、服务端 `-mtime +180` 定时清理。

---

> 更新：2026-04-29 18:59:05
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/zickig>
