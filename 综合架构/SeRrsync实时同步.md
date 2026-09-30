# SeRrsync 实时同步实战

## 一、什么是实时同步

实时同步：只要本地目录**触发变更事件**，立刻同步到远端目录。相比定时任务（以**分钟**为单位），实时同步保证数据连续性、减少人工维护成本。

### 实时同步工具选型
| 方案 | 说明 |
| --- | --- |
| inotify + rsync | 基础组合，需自己写脚本 |
| **sersync + rsync** | 国人基于 rsync+inotify 开发，推荐（见下） |
| lsyncd | 基于 inotify/lua，配置简单 |

**Inotify**：Linux 内核的通知接口，监控文件系统的存取、删除、移动等变化，可方便实现异动告警、增量备份、触发式实时同步。

**Sersync** 项目：<https://github.com/wsgzao/sersync>（原 Google Code 已归档）。

**Sersync 优点**
1. 支持通过配置文件管理（不用写脚本）；
2. 真正的守护进程（socket），常驻后台；
3. 对失败文件定时重传（内置定时任务）；
4. 提供第三方 HTTP 接口（如更新 CDN 缓存）；
5. 默认多线程 rsync 同步，效率高。

---

## 二、案例：web → NFS → backup 实时同步

> 目标：web 上传视频/图片到 NFS 共享目录，NFS 目录一有变化就实时复制到 backup 服务器；NFS 宕机时可把 web 挂载切到 backup。

| 角色 | 外网 IP | 内网 IP | 安装 |
| --- | --- | --- | --- |
| web01 | eth0:10.0.0.7 | eth1:172.16.1.7 | nfs 客户端 |
| nfs-server | eth0:10.0.0.31 | eth1:172.16.1.31 | nfs + rsync + inotify + sersync |
| backup | eth0:10.0.0.41 | eth1:172.16.1.41 | rsync-server |

### 1. 配置 backup 服务器
```bash
# 1. 安装 rsync
yum install rsync -y

# 2. 配置 rsyncd
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

# 3. 创建数据目录
mkdir /backup /data

# 4. 用户与授权
useradd -M -s /sbin/nologin rsync
chown -R rsync.rsync /backup/ /data/
ll -d /backup/ /data/   # 检查

# 5. 虚拟用户密码文件（修复：需加 > 重定向）
echo "rsync_backup:1" > /etc/rsync.password
chmod 600 /etc/rsync.password

# 6. 启动
systemctl restart rsyncd
```

### 2. 配置 nfs 服务器
```bash
# 1. 安装
yum install nfs-utils -y

# 2. /etc/exports
# /data 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)

# 3. 依赖环境
groupadd -g 666 www
useradd -u 666 -g 666 www
mkdir /data
chown -R www.www /data

# 4. 启动（修复：应启动 nfs-server 而非 nfs-utils）
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server
```

### 3. 配置 web 服务器
```bash
yum install nfs-utils -y
systemctl start rpcbind

mkdir /data
showmount -e 172.16.1.31
# Export list for 172.16.1.31:
# /data 172.16.1.0/24

mount -t nfs 172.16.1.31:/data /data

# 模拟上传（或 Windows 上传视频/图片至 /data）
wget -O /data/th.jpg http://img.mp.itc.cn/upload/20170511/cad88c2e57f44e93b664a48a98a47108_th.jpg
# ls /data/   # 在 nfs 服务器上验证
```

---

## 三、实时同步（sersync）

> 目的：NFS 共享的 `/data` 一旦变化，实时同步至 backup 的 `data` 模块，防 NFS 宕机丢数据。

**nfs-server 上操作**
```bash
# 1. 安装 inotify-tools + rsync
yum install inotify-tools rsync -y

# 2. 安装 sersync
wget https://raw.githubusercontent.com/wsgzao/sersync/master/sersync2.5.4_64bit_binary_stable_final.tar.gz
tar xf sersync2.5.4_64bit_binary_stable_final.tar.gz
mv GNU-Linux-x86/ /usr/local/sersync

# 4. 配置 confxml.xml
vim /usr/local/sersync/confxml.xml
    <fileSystem xfs="true"/>            <!-- 文件系统 -->
    <filter start="false">              <!-- 排除不想同步的文件 -->
        <exclude expression="(.*)\.svn"></exclude>
        <exclude expression="(.*)\.gz"></exclude>
        <exclude expression="^info/*"></exclude>
        <exclude expression="^static/*"></exclude>
    </filter>
    <inotify>                          <!-- 监控事件类型 -->
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
        <localpath watch="/data">       <!-- 监控目录 -->
            <remote ip="172.16.1.41" name="data"/>   <!-- backup IP 与模块 -->
        </localpath>
        <rsync>
           <commonParams params="-az"/>
            <auth start="true" users="rsync_backup" passwordfile="/etc/rsync.pass"/>
            <userDefinedPort start="false" port="874"/><!-- port=874 -->
            <timeout start="true" time="100"/><!-- timeout=100 -->
            <ssh start="false"/>
        </rsync>
        <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!-- 每 60 分钟重传失败文件 -->
    </sersync>

# 5. 创建密码文件
echo "1" > /etc/rsync.pass
chmod 600 /etc/rsync.pass

# 6. 启动
# /usr/local/sersync/sersync2 -h 参数说明：
#   -d  启用守护进程模式
#   -r  启动前先把监控目录与远端用 rsync 推一遍
#   -n  守护线程数（默认 10）
#   -o  指定配置文件（默认 confxml.xml）
#   -m  单独启用模块（refreshCDN / socket / http）
/usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml

# 若报错，手动验证推送：
# cd /data && rsync -avz -R --delete ./ --timeout=100 rsync_backup@172.16.1.41::data --password-file=/etc/rsync.pass
```

![架构](img/SeRrsync%E5%AE%9E%E6%97%B6%E5%90%8C%E6%AD%A5-01.png)
![架构](img/SeRrsync%E5%AE%9E%E6%97%B6%E5%90%8C%E6%AD%A5-02.png)

---

## 四、NFS 宕机时的故障切换

> 若 NFS 宕机，希望把 web 的挂载切到 backup 服务器，怎么做？

```bash
# 1. 让 backup 与 nfs 配置保持一致（nfs 配置、共享目录、权限）
# backup 上：
yum install nfs-utils -y
rsync -avz root@10.0.0.4:/etc/exports /etc/    # 从 nfs 同步配置（注意：示例里写的是 10.0.0.4，按实际 nfs 内/外网 IP）
groupadd -g 666 www
useradd -u 666 -g 666 www

# 2. 启动 nfs
systemctl start rpcbind
systemctl start nfs-server

# 3. 修改 rsync 权限为 www（与 nfs 一致）
# sed -i '1,2s/rsync/www/' /etc/rsyncd.conf
sed -i 's/^uid = rsync/uid = www/; s/^gid = rsync/gid = www/' /etc/rsyncd.conf

# 4. 重新授权
chown -R www.www /data/ /backup/

# 5. 重启 rsync
systemctl restart rsyncd

# 6. 模拟 NFS 故障（挂起 nfs 虚拟机）

# 7. web 强制卸载 nfs
umount -lf /data

# 8. web 挂载到 backup
mount -t nfs 172.16.1.41:/data /data/
```

---

## 五、sersync 配置文件详解

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<head version="2.5">
    <!-- hostip:本机 IP；port:后台用于实时备份的端口 -->
    <host hostip="localhost" port="8008"></host>
    <debug start="false"/>                 <!-- 是否开启 debug -->
    <fileSystem xfs="false"/>              <!-- 分区为 xfs 时需开启 -->
    <filter start="false">                 <!-- 过滤排除 -->
        <exclude expression="(.*)\.svn"></exclude>
        <exclude expression="(.*)\.gz"></exclude>
        <exclude expression="^info/*"></exclude>
        <exclude expression="^static/*"></exclude>
    </filter>
    <inotify>
        <!-- 完全同步：目标与源一致，特别危险，不开启 -->
        <delete start="false"/>
        <createFolder start="true"/>       <!-- 监控目录（一般必须开启） -->
        <createFile start="false"/>         <!-- 创建文件即监控（太耗性能，一般关） -->
        <closeWrite start="true"/>         <!-- 文件关闭即推送（常用） -->
        <moveFrom start="true"/>
        <moveTo start="true"/>
        <attrib start="false"/>             <!-- 改隐藏属性 -->
        <modify start="true"/>              <!-- 监控权限更改就推送（一般开启） -->
    </inotify>

    <sersync>
        <localpath watch="/backup">        <!-- 本地要备份目录 -->
            <remote ip="10.0.0.61" name="backup_crond"/>
            <!--<remote ip="192.168.8.39" name="tongbu"/>-->
        </localpath>
        <rsync>
            <commonParams params="-az"/>
            <auth start="true" users="cron_backup" passwordfile="/etc/rsync_passwd_cron.conf"/>
            <userDefinedPort start="false" port="874"/>
            <timeout start="true" time="300"/>
            <ssh start="false"/>
        </rsync>
        <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!-- 每 60 分钟重传失败文件 -->
        <crontab start="false" schedule="600"><!-- 600 分钟 -->
            <crontabfilter start="false">
                <exclude expression="*.php"></exclude>
                <exclude expression="info/*"></exclude>
            </crontabfilter>
        </crontab>
        <plugin start="false" name="command"/>
    </sersync>

    <plugin name="command">
        <param prefix="/bin/sh" suffix="" ignoreError="true"/>
        <filter start="false">
            <include expression="(.*)\.php"/>
            <include expression="(.*)\.sh"/>
        </filter>
    </plugin>
</head>
```

---

## 六、常见面试题

1. **为什么需要实时同步？和定时任务比有什么优势？**
   定时任务以分钟为粒度，数据有丢失窗口；实时同步在目录变更事件触发时立刻同步，保证连续性和一致性。

2. **sersync 相对 inotify+rsync 脚本好在哪？**
   自带配置文件管理、守护进程常驻、失败文件定时重传、多线程 rsync、HTTP 接口，免写脚本。

3. **sersync 的 `<delete start="true"/>` 要小心什么？**
   开启后目标会与源强一致，源删文件目标也删，属于危险操作，配置时要确认方向正确。

4. **NFS 宕机怎么快速切换到 backup？**
   backup 上配成和 nfs 一致（exports、目录、www 权限、rsync 以 www 运行），web 端 `umount -lf` 强制卸载 nfs，再 `mount` 到 backup。

5. **sersync 启动时 `-dro` 各参数含义？**
   `-d` 守护进程、`-r` 首次启动先把目录推一遍、`-o` 指定配置文件。

6. **web 挂载 NFS 卡死无法卸载怎么办？**
   用 `umount -lf /data` 强制（lazy）卸载，再做故障切换。

---

> 更新：2026-04-29 16:23:43
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/rmat2x>
