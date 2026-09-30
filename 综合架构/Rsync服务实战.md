# Rsync服务实战

# Rsync服务实战
<font style="color:#222222;">客户端需求</font>

<font style="color:#363636;">1.客户端每天凌晨01点在服务器本地打包备份(系统配置文件、日志文件、其他目录、应用配置等文件)</font>

<font style="color:#363636;">2.客户端备份的数据必须存放至以主机名_IP地址_当前时间命名的目录中, 例/backup/nfs-server_172.16.1.31_2018-09-02 </font>

<font style="color:#363636;">3.客户端最后通过rsync推送本地已打包好的备份文件至backup服务器</font>

<font style="color:#363636;">4.客户端服务器本地保留最近7天的数据, 避免浪费磁盘空间</font><font style="color:#222222;">/backup/ 服务端需求</font>

<font style="color:#363636;"></font>

<font style="color:#363636;">服务端</font>

<font style="color:#363636;">1.服务端部署rsync，用于接收客户端推送过来的备份数据</font>

<font style="color:#363636;">2.服务端需要每天校验客户端推送过来的数据是否完整</font>

<font style="color:#363636;">3.服务端需要每天校验的结果通知给管理员</font>

<font style="color:#363636;">4.服务端仅保留6个月的备份数据,其余的全部删除</font>

<font style="color:#666666;">注意：所有服务器的备份目录必须都为/backup</font>

# 准备环境
```bash
#1 安装rsync软件
yum -y install rsync

#2 配置 /etc/rsyncd.conf
cat >> /etc/rsyncd.conf<<EOF
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

# 3 创建用户（运行rsync服务的用户身份）
useradd -M -s /sbin/nologin rsync
mkdir /backup
chown -R rsync.rsync /backup/

# 4 创建虚拟用户密码文件(客户端连接时候使用)
echo "rsync_backup:1" >/etc/rsync.password
chmod 600 /etc/rsync.password

# 5启动 rsync 服务，并加入开机自启
systemctl start rsyncd
systemctl enable rsyncd

# 6检查对应的端口 873
netstat -lntp |grep 873

# 7测试 (客户端也安装rsync 但是不启动服务)
#客户端推送  /etc/passwd 推到 服务端 backup模块
rsync -avz /etc/passwd rsync_backup@10.0.0.7::backup
#客户端下载
rsync -avz rsync_backup@10.0.0.7::backup /opt

#无密码方式备份 之指定文件
echo "1" > /etc/rsync.password
chmod 600 /etc/rsync.password 
rsync -avz rsync_backup@10.0.0.7::backup /opt --password-file=/etc/rsync.password

#无密码方式备份 之环境变量方式
export RSYNC_PASSWORD=1
rsync -avz rsync_backup@10.0.0.7::backup /opt

8其他
强制一致性 pc  ->  U盘保持一致（--delete）
rsync -avz --delete rsync_backup@10.0.0.7::backup/ /data/ --password-file=/etc/rsync.password

rsync -avz --delete /data/ rsync_backup@10.0.0.7::backup/ --password-file=/etc/rsync.password

限速
dd if=/dev/zero of=/opt/test.dosk bs=1M count=1024
rsync -avzP --bwlimit=1 /opt/test.dosk rsync_backup@10.0.0.7::backup

1.脚本，每天01定时执行一次（打包->标记->推送->备份服务器->保留最近7天的文件）
批量执行
for i in {1..30};do date -s 2018/08/$i && sh /server/scripts/client_rsync_backup.sh;done


```

[  
](#k2ylcx)

# [](#izf5tk)客户端推送脚本
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

#3.备份对应的文件
[ -f $Path/$Dest/system.tar.gz ] || tar czf $Path/$Dest/system.tar.gz /etc/fstab /etc/rsyncd.conf && \
[ -f $Path/$Dest/log.tar.gz ] || tar czf $Path/$Dest/log.tar.gz  /var/log/messages /var/log/secure && \

#4.携带md5验证信息
[ -f $Path/$Dest/flag ] || md5sum $Path/$Dest/*.tar.gz > $Path/$Dest/flag_${Date}

#4.推送本地数据至备份服务器
export RSYNC_PASSWORD=1
rsync -avz $Path/ rsync_backup@10.0.0.4::backup

#5.本地保留最近7天的数据
find $Path/ -type d -mtime +7|xargs rm -rf
EOF

2.校验的压缩包（邮箱->md5->结果保存下来->将保存的结果发送给管理员->保留最近180天的数据）
```

# [](#8ge2xq)服务端接收文件并校验发送邮箱
```bash
# 1.配置邮箱（配发件服务器）#克隆的主机可以卸载了重新安装一下
yum install mailx -y
# 配置邮件服务功能
cat > /etc/mail.rc<<EOF   
set from=343264992@163.com
set smtp=smtps://smtp.163.com:465
set smtp-auth-user=343264992@163.com
set smtp-auth-password=aa123456
set smtp-auth=login
set ssl-verify=ignore
set nss-config-dir=/etc/pki/nssdb/
EOF

```
# 登录163 把这两个服务开启
IMAP/SMTP服务已开启 
POP3/SMTP服务已开启
授权密码管理： 新增一个
set smtp-auth-password=密码填写这里
```

#测试发邮件          标题			 收件人				发送内容
mail -s "test$(date +%F)" 343264992@qq.com </etc/passwd

mkdir /server/scripts -p
2 服务端脚本
cat > /server/scripts/check_backup.sh<<'EOF'
#!/usr/bin/bash
#1.定义全局的变量
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

#2.定义局部变量
Path=/backup
Date=$(date +%F)

#3.查看flag文件,并对该文件进行校验, 然后将校验的结果保存至result_时间
find $Path/*_${Date} -type f -name "flag_$Date"|xargs md5sum -c >$Path/result_${Date}
#find $Path/*_${Date} -type f -name "flag_$Date" -exec md5sum -c {} \; >$Path/result_${Date}
#4.将校验的结果发送邮件给管理员 123@qq.com
mail -s "Rsync Backup $Date" 343264992@qq.com <$Path/result_${Date}

#5.删除超过7天的校验结果文件, 删除超过180天的备份数据文件
find $Path/ -type f -name "result*" -mtime +7|xargs rm -f
find $Path/ -type d -mtime +180|xargs rm -rf
EOF

定时任务
	#多台客户端
# crontab -l
00 01 * * * /usr/bin/bash /server/scripts/clinet_rsync_backup.sh >/dev/null 2>&1

 #服务端
# crontab -l
00 05 * * * /usr/bin/bash /server/scripts/check_backup.sh >/dev/null 2>&1



```













> 更新: 2026-04-29 18:59:05  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/zickig>