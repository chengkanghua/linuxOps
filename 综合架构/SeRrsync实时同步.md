SeRrsync 实时同步实战

# 什么是实时同步
  实时同步是一种只要当前目录触发事件，就马上同步到远程的目录。rsync

## 为什么要实时同步web->nfs->backup
   保证数据的连续性（定时任务是以分钟为单位的）

   减少人力维护成本

## 实时同步工具的选择
   inotify+RSYNC

   sersync+RSYNC

   lsyncd



Inotify是一个通知接口，用来监控文件系统的各种变化，如果文件存取，删除，移动。可以非常方便地实现文件异动告警，增量备份，并针对目录或文件的变化及时作出响应。rsync+inotify可以实触发式实时同步增量备份



sersync是国人基于 rsync+inotify-tools开发的 实时增量同步工具 ，不仅保留了优点同时还强化了实时监控，文件过滤，简化配置等功能，帮助用户提高运行效率，节省时间和网络资源。

sersync项目地址

<font style="color:rgb(77, 77, 77);">google code地址：</font>[https://code.google.com/archive/p/sersync/](https://code.google.com/archive/p/sersync/)  
<font style="color:rgb(77, 77, 77);">github地址：</font>[https://github.com/wsgzao/sersync](https://github.com/wsgzao/sersync)



sersync优点

1）支持通过配置文件管理

2)  真正的守护进程socket（不需要写脚本）。

3）可以对失败文件定时重传（定时任务功能）。

4）第三方的HTTP接口（例如更新cdn缓存）。

5）默认多线程rsync同步。

# 案例:
实现web服务器上传视频文件，实则是写入NFS存储，当NFS存在新的数据则会实时的复制到备份backup服务器

角色	     外网IP(NAT)	        内网IP(LAN)	           安装工具

web01	     eth0:10.0.0.7	        eth1:172.16.1.7	

nfs-server    eth0:10.0.0.31	        eth1:172.16.1.31	    rsync+inotify+sersync

backup	     eth0:10.0.0.41	        eth1:172.16.1.41	    rsync-server



## 配置好backup服务器，操作如下：
```bash
#1.安装rsync
yum install rsync -y
# 2.配置rsync
cat > /etc/rsyncd.conf <<EOF
uid = rsync
gid = rsync
port = 873
fake super = yes
use chroot = no
max connections = 200
timeout = 600
ignore errors
read only = false
list = true
secrets file = /etc/rsync.password
auth users = rsync_backup
log file = /var/log/rsyncd.log
#####################################
[backup]
path = /backup

[data]
path = /data
EOF
# 3.创建数据目录
mkdir /backup
mkdir /data

# 4.创建用户并授权
useradd -M -s /sbin/nologin rsync
chown -R rsync.rsync /backup/ /data/
ll -d /backup/ /data/   #检查

# 5.创建链接的虚拟用户
echo "rsync_backup:1" /etc/rsync.password
chmod 600 /etc/rsync.password

# 6.启动rsyncd
systemctl restart rsyncd

```

## 配置好nfs服务器，操作如下：
```bash
# 1.安装nfs
yum install nfs-utils -y
# 2.配置nfs
# cat /etc/exports
/data 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)

# 3.配置nfs依赖环境
groupadd -g 666 www
useradd -u 666 -g 666 www
mkdir /data
chown -R www.www /data

# 4.启动nfs
systemctl enable rpcbind nfs-utils
systemctl start rpcbind nfs-server
```



## 配置好web服务器，操作如下：
```bash
# 1.先安装对应的工具包
yum install nfs-utils -y
systemctl start rpcbind

#2.创建目录，用于挂载使用
mkdir /data

# 3.挂载nfs的data目录
# showmount -e 172.16.1.31
#Export list for 172.16.1.31:
#/data 172.16.1.0/24

mount -t nfs 172.16.1.31:/data /data

#4.通过windows上传一个视频或图片至/data
wget -o /data/th.jpg  http://img.mp.itc.cn/upload/20170511/cad88c2e57f44e93b664a48a98a47108_th.jpg

# 验证内容是否存在nfs服务器
# ls /data/

```



# 实时同步sersync
为了防止nfs down机后丢失数据，希望nfs共享的data目录一旦发生变化，则实时的同步至backup

nfs-server 服务器操作如下：



```bash
#1.安装inotify-tools
yum install inotify-tools rsync -y

#2.安装sersync
wget https://raw.githubusercontent.com/wsgzao/sersync/master/sersync2.5.4_64bit_binary_stable_final.tar.gz

#3.解压并重命名
tar xf sersync2.5.4_64bit_binary_stable_final.tar.gz
mv GNU-Linux-x86/ /usr/local/sersync

# 4.配置好sersync即可
[root@nfs01 sersync]# vim /usr/local/sersync/confxml.xml
     <fileSystem xfs="true"/>  <!-- 文件系统 -->
     <filter start="false">  <!-- 排除不想同步的文件-->
         <exclude expression="(.*)\.svn"></exclude>
         <exclude expression="(.*)\.gz"></exclude>
         <exclude expression="^info/*"></exclude>
         <exclude expression="^static/*"></exclude>
     </filter>
     <inotify> <!-- 监控的事件类型 -->
         <delete start="true"/>
         <createFolder start="true"/>
         <createFile start="true"/>
         <closeWrite start="true"/>
         <moveFrom start="true"/>
         <moveTo start="true"/>
         <attrib start="false"/>
         <modify start="false"/>
     </inotify>
     <sersync>
         <localpath watch="/data"> <!-- 监控的目录 -->
             <remote ip="172.16.1.41" name="data"/>  <!-- backup的IP以及模块 -->
         </localpath>
         <rsync> <!-- rsync的选项 -->
            <commonParams params="-az"/>
             <auth start="true" users="rsync_backup" passwordfile="/etc/rsync.pass"/>
             <userDefinedPort start="false" port="874"/><!-- port=874 -->
             <timeout start="true" time="100"/><!-- timeout=100 -->
             <ssh start="false"/>
         </rsync>
           <!-- 每60分钟执行一次同步-->
         <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--def
   ault every 60mins execute once-->



#5.创建密码文件
echo "1" > /etc/rsync.pass
chmod 600 /etc/rsync.pass


# 6.启动sersync
# /usr/local/sersync/sersync2  -h
set the system param
execute：echo 50000000 > /proc/sys/fs/inotify/max_user_watches
execute：echo 327679 > /proc/sys/fs/inotify/max_queued_events
parse the command param
_______________________________________________________
参数-d:启用守护进程模式
参数-r:在监控前，将监控目录与远程主机用rsync命令推送一遍
参数-n: 指定开启守护线程的数量，默认为10个
参数-o:指定配置文件，默认使用confxml.xml文件
参数-m:单独启用其他模块，使用 -m refreshCDN 开启刷新CDN模块
参数-m:单独启用其他模块，使用 -m socket 开启socket模块
参数-m:单独启用其他模块，使用 -m http 开启http模块
不加-m参数，则默认执行同步程序
________________________________________________________________
/usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml


# 注意：如果发生错误，请手动执行命令检查推送是否正常
# cd /data && rsync -avz -R --delete ./  --timeout=100 rsync_backup@172.16.1.41::data --password-file=/etc/rsync.pass


```





# 如果nfs现在down机了，希望将web客户端挂载至backup服务器上？怎么实现？
```bash
# 1.nfs和backup两台服务器应该保持一样（nfs配置。nfs共享的目录。nfs的权限）
# backup主机上操作
yum install nfs-utils -y
#ip是nfs服务器地址
rsync -avz root@10.0.0.4:/etc/exports /etc/
groupadd -g 666 www
useradd -u666 -g666 www
   
# 2.启动nfs
systemctl start rpcbind
systemctl start nfs-server

3.修改rsync的权限
# uid = www
# gid = www
sed -i '1,2s/rsync/www/' /etc/rsyncd.conf

#4.修改授权
chown -R www.www /data/ /backup/

#5.重启rsync
systemctl restart rsyncd

#6.模拟nfs故障（挂起虚拟机）

# 7.web服务器 强制卸载 nfs服务器 172.16.1.31:/data      
umount -lf /data
8.web尝试挂载backup服务器 172.16.1.41:/data
mount -t nfs 172.16.1.41:/data /data/

```





![](img/SeRrsync%E5%AE%9E%E6%97%B6%E5%90%8C%E6%AD%A5-01.png)







![](img/SeRrsync%E5%AE%9E%E6%97%B6%E5%90%8C%E6%AD%A5-02.png)



# sersync 配置文件详解


```bash
<?xml version="1.0" encoding="ISO-8859-1"?>
<head version="2.5">
    #hostip本机的Ip地址，后台使用那个端口来进行实时备份
    <host hostip="localhost" port="8008"></host>
    #是否开启debug 调试信息
    <debug start="false"/>
    #是否支持xfs文件系统，如果有分区文件系统为xfs的时候，需要开启这个选项
    <fileSystem xfs="false"/>
    #是否开启过滤，排除
    <filter start="false">
    #exclude排除这些文件名中包含这些字符的，不推送这些
    <exclude expression="(.*)\.svn"></exclude>
    <exclude expression="(.*)\.gz"></exclude>
    <exclude expression="^info/*"></exclude>
    <exclude expression="^static/*"></exclude>
    </filter>
    #inotify模块的配置
    <inotify>
    #是否开启完全同步，源文件里面有什么，目标文件里面就有什么，特别危险，不开启
    <delete start="false"/>
    #是否监控目录，如果不开启他将不监控这个目录下的子文件和子目录的更改，除非有特殊要求，否则必须开启
    <createFolder start="true"/>
    #创建文件就监控，我们一般把这个设为false，否则太消耗性能
    <createFile start="false"/>
    #文件关闭的时候就推送，这个开启，新建文件打开这个就会对上面的进行备份了
    <closeWrite start="true"/>
    #mv剪切走
    <moveFrom start="true"/>
    #mv剪切到这个文件里面
    <moveTo start="true"/>
    #更改文件隐藏属性
    <attrib start="false"/>
    #监控权限更改就会推送，一般选择开启
    <modify start="true"/>
    </inotify>

    <sersync>
    #本地要备份的目录
    <localpath watch="/backup">
        #远程rsync的地址，和使用的模块
        <remote ip="10.0.0.61" name="backup_crond"/>
        <!--<remote ip="192.168.8.39" name="tongbu"/>-->
        <!--<remote ip="192.168.8.40" name="tongbu"/>-->
    </localpath>
    <rsync>
        #rsync推送的使用的参数
        <commonParams params="-az"/>
        #是不是开启用户认证，使用的那个用户，密码文件什么，密码文件权限必须是600
        <auth start="true" users="cron_backup" passwordfile="/etc/rsync_passwd_cron.conf"/>
        #服务端使用的那个端口，端口地址是什么
        <userDefinedPort start="false" port="874"/><!-- port=874 -->
        #推送超时时间，超过这个时间就认为推送不成功。
        <timeout start="true" time="300"/><!-- timeout=100 -->
        <ssh start="false"/>
    </rsync>
    <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once-->
    <crontab start="false" schedule="600"><!--600mins-->
        <crontabfilter start="false">
        <exclude expression="*.php"></exclude>
        <exclude expression="info/*"></exclude>
        </crontabfilter>
    </crontab>
    <plugin start="false" name="command"/>
    </sersync>

    <plugin name="command">
    <param prefix="/bin/sh" suffix="" ignoreError="true"/>  <!--prefix /opt/tongbu/mmm.sh suffix-->
    <filter start="false">
        <include expression="(.*)\.php"/>
        <include expression="(.*)\.sh"/>
    </filter>
    </plugin>
```



