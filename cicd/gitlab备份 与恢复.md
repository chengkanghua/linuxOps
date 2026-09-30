# GitLab备份
对gitlab进行备份将会创建一个包含所有库和附件的归档文件。对备份的恢复只能恢复到与备份时的gitlab相同的版本。将gitlab迁移到另一台服务器上的最佳方法就是通过备份和还原。

gitlab提供了一个简单的命令行来备份整个gitlab，并且能灵活的满足需求。

备份文件将保存在配置文件中定义的backup_path中，文件名为TIMESTAMP_gitlab_backup.tar,TIMESTAMP为备份时的时间戳。TIMESTAMP的格式为：EPOCH_YYYY_MM_DD_Gitlab-version。

如果自定义备份目录需要赋予git权限

```bash
# 配置文件中加入/etc/gitlab/gitlab.rb

gitlab_rails['backup_path'] = '/data/backup/gitlab'
gitlab_rails['backup_keep_time'] = 604800       #备份保留的时间（以秒为单位，这个是七天默认值），
mkdir /data/backup/gitlab
chown -R git.git /data/backup/gitlab
完成后执行gitlab-ctl reconfigure

```



### [](#l9lgvz)1、手动备份
执行：gitlab-rake gitlab:backup:create生成一次备份。

```bash
[root@node2 ~]# gitlab-rake gitlab:backup:create

[root@node2 ~]# ll /var/opt/gitlab/backups/
total 272
-rw------- 1 git git 276480 Dec  9 17:24 1512811475_2017_12_09_10.2.2_gitlab_backup.tar
```



### [](#hmbfgx)2、定时备份
```bash
在定时任务里添加：
● 0 2 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create CRON=1

环境变量CRON=1的作用是如果没有任何错误发生时， 抑制备份脚本的所有进度输出。
```



### [](#xf8vtt)3、恢复
```bash
# 只能还原到与备份文件相同的gitlab版本。
# 执行恢复操作时，需要gitlab处于运行状态，备份文件位于gitlab_rails['backup_path']。
[root@node2 ~]# ll /var/opt/gitlab/backups/
total 272
-rw------- 1 git git 276480 Dec  9 17:24 1512811475_2017_12_09_10.2.2_gitlab_backup.tar

# 停止连接到数据库的进程（也就是停止数据写入服务），但是保持GitLab是运行的。
gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq
gitlab-ctl status


# 接下我们进行恢复，指定时间戳你要从那个备份恢复：
[root@node2 ~]# gitlab-rake gitlab:backup:restore BACKUP=1512811475_2017_12_09_10.2.2
Unpacking backup ... done
Before restoring the database, we will remove all existing
tables to avoid future upgrade problems. Be aware that if you have
custom tables in the GitLab database these tables and all data will be
removed.

Do you want to continue (yes/no)? 
将移除我们自建的表。回答yes
Restoring uploads ... 
done
Restoring builds ... 
done
Restoring artifacts ... 
done
Restoring pages ... 
done
Restoring lfs objects ... 
done
This will rebuild an authorized_keys file.
You will lose any data stored in authorized_keys file.
Do you want to continue (yes/no)? 
将移除所有的认证Key。回答yes
....
Deleting tmp directories ... done
done
done
done
done
done
done
done

# 完成后重启GitLab服务
gitlab-ctl restart



# 检查GitLab的服务
gitlab-rake gitlab:check SANITIZE=true


```





报错:  权限被拒绝

```bash
[root@oldboy /]# gitlab-rake gitlab:backup:restore BACKUP=1547536917_2019_01_15_10.2.2
Unpacking backup ... tar: 1547536917_2019_01_15_10.2.2_gitlab_backup.tar: Cannot open: Permission denied
tar: Error is not recoverable: exiting now
unpacking backup failed

[root@oldboy /]# cd /var/opt/gitlab/backups/
[root@oldboy backups]# ll
total 80
-rw------- 1 root root 81920 Jan 15 15:21 1547536917_2019_01_15_10.2.2_gitlab_backup.tar

# 修改权限
# chown -R git.git 1547536917_2019_01_15_10.2.2_gitlab_backup.tar


```

