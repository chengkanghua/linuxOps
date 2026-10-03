# Linux 常用 150 个命令汇总

> 本文按功能分类汇总 Linux 常用命令（约 150 个），前半部分为**命令总览清单**，后半部分为**逐条详解**（含常用选项），末尾附三剑客速查。

![命令汇总](img/linux%E5%B8%B8%E7%94%A8150%E4%B8%AA%E5%91%BD%E4%BB%A4%E6%B1%87%E6%80%BB-01.png)

## 一、命令总览（按功能分类）

| 分类 | 命令清单 |
| --- | --- |
| **线上查询及帮助** | man、help |
| **文件和目录操作** | ls、cd、cp、find、mkdir、mv、pwd、rename、rm、rmdir、touch、tree、basename、dirname、chattr、lsattr、file、md5sum |
| **查看文件及内容处理** | cat、tac、more、less、head、tail、cut、split、paste、sort、uniq、wc、iconv、dos2unix、diff、vimdiff、rev、grep、egrep、join、tr、vi/vim |
| **文件压缩及解压缩** | tar、unzip、gzip、zip |
| **信息显示** | uname、hostname、dmesg、uptime、file、stat、du、df、top、free、date、cal |
| **搜索文件** | which、find、whereis、locate |
| **用户管理** | useradd、usermod、userdel、groupadd、passwd、chage、id、su、visudo、sudo |
| **基础网络操作** | telnet、ssh、scp、wget、ping、route、ifconfig、ifup、ifdown、netstat、ss |
| **深入网络操作** | nmap、lsof、route、mail、mutt、nslookup、dig、host、traceroute、tcpdump |
| **磁盘与文件系统** | mount、umount、df、du、fsck、dd、dumpe2fs、dump、fdisk、parted、mkfs、partprobe、e2fsck、mkswap、swapon、swapoff、sync、resize2fs |
| **系统权限及用户授权** | chmod、chown、chgrp、umask |
| **查看系统用户登录信息** | whoami、who、w、last、lastlog、users、finger |
| **内置命令及其它** | echo、printf、rpm、yum、watch、alias、unalias、date、clear、history、eject、time、nc、xargs、exec、export、unset、type、bc |
| **系统管理与性能监视** | chkconfig、vmstat、mpstat、iostat、sar、ipcs、ipcrm、strace、ltrace |
| **关机/重启/注销** | shutdown、halt、init、poweroff、reboot、logout、exit、Ctrl+d |
| **进程管理** | bg、fg、jobs、kill、killall、pkill、crontab、ps、pstree、top、nice、nohup、pgrep、runlevel、init、service |
| **三剑客** | grep（egrep）、sed、awk |

> **非常危险的系统命令（5 个）**：mv、rm、fdisk、parted、dd —— 使用务必确认目标！

---

## 二、线上查询及帮助命令

- **man** — 帮助，命令的词典（更复杂的还有 info，但不常用）
- **help** — 查看 Linux 内置命令的帮助，比如 cd 命令

### 实战常用（工作场景）

```bash
man ls                      # 查完整手册（空格翻页，/ 搜索，q 退出）
ls --help                   # 精简帮助，日常最常用
help cd                     # 查 bash 内置命令（外部命令用不了）
type ls                     # 判断是内部命令还是外部命令
man -k keyword              # 按关键词搜索手册（忘了命令名时用，等同 apropos）
whatis ls                   # 一行说明
```

## 三、文件和目录操作命令

- **ls** — 全拼 list，列出目录的内容及其内容属性信息
  - `-d` 显示目录本身；`-t` 时间排序；`-r` 逆序；`-l` 长格式显示详细信息
  - `-F` 给不同类型的文件加标记；`-h` 人类可读显示；`-i` 显示 inode 节点；`--full-time` 完整时间格式
- **cd** — 全拼 change directory，切换工作目录（`cd .` / `cd ..` / `cd ~` / `cd -`）
- **cp** — 全拼 copy，复制文件或目录
  - `-p` 保留属性；`-d` 若源是符号链接则只复制链接本身；`-a` 等同 `-p -d -r` 总和
  - `-R/-r` 递归处理；`-i` 覆盖前提示；`-t` 颠倒顺序（`cp -t 目标 源文件`）
- **find** — 查找目录及目录下的文件
  - `find /oldboy/` 接路径；`-maxdepth 1` 最大目录层级；`-type f/d` 文件/目录
  - `-mtime +7/-7/7` 7天前/7天内/第7天；`-name "*.sh"`；`-iname` 不区分大小写
  - `-exec ls -l {} \;` 把查找结果放入 `{}`
- **mkdir** — 全拼 make directories，创建目录（`-p` 递归创建；`-m` 设置权限）
- **mv** — 全拼 move，移动或重命名文件（`-f` 直接覆盖不询问；`-i` 询问；`-n` 不覆盖；`-t` 同 cp）
- **pwd** — 全拼 print working directory，显示当前工作目录绝对路径
- **rename** — 重命名文件
- **rm** — 全拼 remove，删除文件或目录（`-r/-R` 递归；`-f` 不提示；`-i` 删除前确认）
- **rmdir** — 全拼 remove empty directories，删除空目录
- **touch** — 创建新的空文件、改变已有文件时间戳属性
  - `-t 201807281246.30 file` 指定创建时间；`-d 20201001 file` 修改时间属性
  - `-r text.txt a.txt` 让 a.txt 时间属性与 text.txt 一致
- **tree** — 树形结构显示目录内容（`-d` 只显示目录；`-L 1` 显示第一层；`-F` 同 ls 的 -F）
- **basename** — 显示文件名或目录名
- **dirname** — 显示文件或目录路径
- **chattr** — 改变文件的扩展属性
- **lsattr** — 查看文件扩展属性
- **file** — 显示文件的类型
- **md5sum** — 计算和校验文件的 MD5 值

### 实战常用（工作场景）

```bash
# 查文件/目录（最常用组合）
ls -lht                     # 长格式 + 人类可读 + 按时间倒序（看最新改动）
ls -ld /data                # 只看目录本身属性，不看内容
ls -lh --time-style=long-iso   # 显示完整时间（排日志必备）

# 复制 / 备份
cp -a /data /backup/        # 备份目录并保持属性（等同 -pdr，备份首选）
cp -t /backup/ a.log b.log  # -t 颠倒顺序：把多个源文件放到目标目录
cp oldboy.txt{,.bak}        # 花括号快速备份（等价 cp a a.bak）

# 移动 / 改名
mv -t /tmp/ *.log           # 批量移动日志
rename html '' *.jpg        # 批量去掉文件名中的 html

# 创建目录 / 文件
mkdir -p /data/{logs,conf}  # 花括号一次建多个目录
touch -d "2024-01-01" file  # 修改文件时间属性

# 查找（配合删除务必先 -print 确认）
find / -type f -name "*.log" -mtime +7 -print    # 找 7 天前的日志
find / -type f -perm -4000                       # 找含 suid 的文件（安全排查）
find / -type f -size +100M                       # 找大文件（磁盘满排查）
find / -type f -newer /tmp/a.txt                 # 比某文件更新的（排障定位）

tree -L 2 -d /data          # 只看 2 层目录结构（快速了解项目布局）
file /bin/ls                # 判断文件类型（脚本/文本/二进制）
md5sum file > file.md5      # 生成指纹
md5sum -c file.md5          # 校验指纹（判断文件是否被篡改）
chattr +i /etc/passwd       # 锁关键文件，禁止修改删除（lsattr 查看）
```

## 四、查看文件及内容处理命令

- **cat** — 全拼 concatenate，连接多个文件并打印到屏幕或重定向
  - `-n` 所有输出按行编号（不忽略空白行）；`-b` 编号但忽略空白行；`-s` 连续空行替换为一行
- **tac** — cat 的反向拼写，反向显示文件内容（`-n` 显示行号）
- **more** — 分页显示文件内容（`f` 下一页；`b` 上一页；`enter` 一行一行）
- **less** — 分页显示文件内容，more 的相反用法
- **head** — 显示文件头部（`-n 10` 显示头 10 行，默认 10 行）
- **tail** — 显示文件尾部（`-n`）
- **cut** — 将文件每行按指定分隔符分割并输出
  - `-d ' '` 指定分隔符；`-f3,6` 指定列；`-b` 按字节；`-c` 按字符；`-n` 与 -b 连用取消多字节分割
  - `N` 第 N 个；`N-` 从第 N 个到行尾；`N-M` 第 N 到 M；`-M` 第 1 到 M
- **split** — 分割文件为不同小片段
- **paste** — 按行合并文件内容
- **sort** — 对文本内容排序（`-h` 人类可读；`-r` 逆序）
- **uniq** — 去除重复行
- **wc** — 统计行数、单词数或字节数（`-l` 多少行）
- **iconv** — 转换文件的编码格式
- **dos2unix** — 将 DOS 格式文件转换成 UNIX 格式
- **diff** — 全拼 difference，比较文件差异，常用于文本文件
- **vimdiff** — 命令行可视化文件比较工具
- **rev** — 反向输出文件内容
- **grep / egrep** — 过滤字符串（三剑客老三）
  - `-v` 显示不匹配的行（排除）；`-n` 显示匹配行及行号；`-i` 不区分大小写
  - `-c` 只统计匹配行数；`-E` 使用扩展 egrep；`--color=auto` 匹配加颜色
  - `-w` 只匹配单词；`-o` 只输出匹配内容
- **join** — 按两个文件的相同字段合并
- **tr** — 替换或删除字符
- **vi / vim** — 命令行文本编辑器（`i` 编辑模式；`o` 下一行新建；`:set nu` 显示行号）

### 实战常用（工作场景）

```bash
# 看日志（排障第一件事）
tail -f /var/log/messages         # 实时跟踪（Ctrl+C 退出）
tail -n 100 -f app.log            # 先看末尾 100 行再跟踪
tail -f app.log | grep ERROR      # 只跟踪错误
head -20 file                     # 看开头
less file                         # 分页查看（/搜索 n下一个 q退出），大文件不要 cat

# 过滤
grep -n "ERROR" app.log           # 带行号
grep -C3 "Exception" app.log      # 看匹配行上下各 3 行（看堆栈上下文）
grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"   # 去掉注释和空行，只看有效配置
grep -i "error" app.log           # 忽略大小写

# 取列 / 统计（运维最常用组合）
cut -d: -f1 /etc/passwd           # 取第 1 列
awk -F: '{print $1,$3}' /etc/passwd
sort -rn -k2 file | head          # 按第 2 列倒序
sort file | uniq -c               # 去重并计数
sort access.log | uniq -c | sort -rn | head   # 经典 Top 统计
wc -l file                        # 统计行数（PV 统计）

# 其他
dos2unix script.sh                # Windows 脚本转 Unix（解决 ^M 报错）
diff -u old.conf new.conf         # 对比配置差异（上线前比对）
iconv -f gbk -t utf-8 file        # 转编码（乱码处理）
tr -d "\r" < win.txt > unix.txt  # 删除回车符
split -l 1000 big.log part_       # 大文件按 1000 行切分
```

## 五、文件压缩及解压缩命令

- **tar** — 打包压缩
  - `zcf 打包名.tar.gz 目标` 打包压缩；`tf` 查看压缩包内容；`xf` 解压（`-C` 指定路径）
  - `--exclude` 排除：`tar zcf /tmp/etc-pai.tar.gz /etc/ --exclude /etc/services`
- **unzip** — 解压 zip 文件
- **gzip** — gzip 压缩工具
- **zip** — zip 压缩工具

### 实战常用（工作场景）

```bash
# tar（生产备份主力）
tar zcf /backup/etc-$(date +%F).tar.gz /etc/     # 按日期打包备份（最常用）
tar tf /backup/etc-2024-01-01.tar.gz             # 只看内容，不解压
tar xf /backup/etc-2024-01-01.tar.gz             # 解压到当前目录
tar xf /backup/etc.tar.gz -C /tmp/               # 解压到指定目录
tar zchf /backup/rc.tar.gz /etc/rc.local         # -h 跟随软链接打包源文件（重要！）
tar zcf /backup/etc.tar.gz /etc/ --exclude=/etc/services   # 排除某文件
tar zcf - /data | ssh root@10.0.0.201 "cd /backup && tar xf -"   # 边打包边远程传（无中间文件）

# zip（与 Windows 交互）
zip -r /tmp/data.zip /data/       # 压缩目录
unzip -l /tmp/data.zip            # 看内容
unzip -o -d /opt /tmp/data.zip    # 解压到 /opt 并覆盖

# gzip（只能压文件，压完源文件消失）
gzip file.txt                     # → file.txt.gz
gzip -d file.txt.gz               # 解压
zcat file.txt.gz                  # 不解压直接看内容（看压缩日志神器）
```

## 六、信息显示命令

- **uname** — 显示操作系统相关信息（`-r` 内核版本及 64 位；`-m` 多少位）
- **hostname** — 显示或设置主机名（`hostname oldboy` 临时修改）
- **dmesg** — 显示开机信息，用于诊断系统故障
- **uptime** — 显示系统运行时间及负载
- **stat** — 显示文件或文件系统的状态
- **du** — 计算磁盘空间使用情况
- **df** — 报告文件系统磁盘空间使用情况（`-h` 人类可读）
- **top** — 实时显示系统资源使用情况
- **free** — 查看系统内存（`-h` 人类可读）
- **date** — 显示与设置系统时间（`-s "20180725 00:00:00"`）
- **cal** — 查看日历等时间信息

### 实战常用（工作场景）

```bash
# 系统身份
uname -r                          # 内核版本（装驱动/排查用）
uname -m                          # 架构（x86_64 / aarch64）
cat /etc/redhat-release           # 看发行版版本
hostname / hostnamectl set-hostname web01    # 查 / 永久改主机名

# 负载与在线
uptime                            # 1/5/15 分钟负载（>CPU核数要警惕）
w                                 # 谁在线 + 在做什么 + 负载

# 磁盘（最高频）
df -h                             # 各分区使用率（看 block）
df -i                             # inode 使用率（大量小文件必查！）
du -sh /var/* | sort -h           # 逐级找占用大的目录
du -h --max-depth=1 /var/log      # 看日志目录明细

# 内存
free -h                           # 看 available 才是真正可用（buffer/cache 可被回收）

# 实时与详情
top                               # 交互：P 按CPU排、M 按内存排、1 看每核
stat file                         # 看文件 inode、三种时间、权限
date "+%F %T"                     # 当前时间
date +%F -d "-7day"               # 7天前（脚本取日期用）
```

## 七、搜索文件命令

- **which** — 查找二进制命令，按 PATH 路径查找
- **find** — 从磁盘遍历查找文件或目录
  - `-type f/d`；`-name "*.txt"`；`-iname` 不区分大小写；`-size +100k/-10k`
  - `-maxdepth` 目录层级；`-mtime -n` n 天内 / `+n` n 天前 / `n` 第 n 天
  - `-exec` 对匹配文件执行命令；`!` 取反；`-a` 交集；`-o` 并集
- **whereis** — 查找二进制命令，按 PATH 路径查找
- **locate** — 从数据库 `/var/lib/mlocate/mlocate.db` 查找（`updatedb` 更新库）

### 实战常用（工作场景）

```bash
which nginx                       # 查命令绝对路径（确认装没装、装的哪个）
whereis nginx                     # 查命令 + 配置文件 + man 位置
type -a ls                        # 列出所有同名命令（别名/内置/外部）

# find（最强大，按条件找文件）
find / -name "nginx.conf"         # 按名字
find / -iname "*.CONF"            # 不区分大小写
find /var -type f -size +100M     # 找大文件（磁盘满）
find / -type f -mmin -10          # 找 10 分钟内改过的（出问题时定位刚动的文件）
find / -type f -user nginx        # 按属主找
find /data -type f -mtime +30 -print   # 30 天前的（清理前务必先 print）

# locate（快，但基于数据库）
updatedb                          # 先更新数据库（新机器必做）
locate nginx.conf                 # 秒出结果
```

## 八、用户管理命令

- **useradd** — 添加用户
- **usermod** — 修改已存在用户的属性
- **userdel** — 删除用户
- **groupadd** — 添加用户组
- **passwd** — 修改用户密码
- **chage** — 修改用户密码有效期限
- **id** — 查看用户的 uid、gid 及归属用户组
- **su** — 切换用户身份
- **visudo** — 编辑 `/etc/sudoers` 的专属命令
- **sudo** — 以另一用户身份（默认 root）执行 sudoers 允许的命令

### 实战常用（工作场景）

```bash
# 建用户
useradd -u 1000 -g dev -s /bin/bash -m deploy    # 指定 uid/主组/shell/建家目录
useradd -M -s /sbin/nologin nginx                # 建虚拟用户（服务专用，禁止登录）
useradd -r -s /sbin/nologin mysql                # -r 系统用户

# 改用户
usermod -aG wheel deploy          # 追加附加组（-aG！少了 -a 会覆盖原有附加组）
usermod -s /sbin/nologin olduser  # 禁止某用户登录（禁用账号不删除）
usermod -L deploy                 # 锁定账号（-U 解锁）
passwd deploy                     # 交互式改密
echo "123456" | passwd --stdin deploy            # 非交互（批量初始化）
chage -M 90 deploy                # 密码 90 天过期（安全合规）
chage -l deploy                   # 查看密码策略

# 删用户
userdel -r olduser                # 连家目录和邮箱一起删

# 查 / 切
id deploy                         # 看 uid/gid/所属组
whoami                            # 当前是谁（脚本里判断权限）
su - deploy                       # 完全切换（带环境变量，推荐带 -）

# 提权
visudo                            # 安全编辑 sudoers（带语法检查，别直接 vi）
sudo -l                           # 看自己能 sudo 什么
# sudoers 常见写法：
# deploy  ALL=(ALL)   NOPASSWD:/bin/systemctl restart nginx
```

## 九、基础网络操作命令

- **telnet** — 使用 TELNET 协议远程登录
- **ssh** — 使用 SSH 加密协议远程登录
- **scp** — 全拼 secure copy，不同主机之间复制文件
- **wget** — 命令行下载文件
- **ping** — 测试主机之间网络连通性
- **route** — 显示和设置 Linux 系统路由表
- **ifconfig** — 查看、配置、启用或禁用网络接口
- **ifup** — 启动网卡
- **ifdown** — 关闭网卡
- **netstat** — 查看网络状态
- **ss** — 查看网络状态

### 实战常用（工作场景）

```bash
# 查本机网络
ip a                              # 查 IP（CentOS7+，替代 ifconfig）
ifconfig eth0                     # 传统查法
ip route / route -n               # 查路由表（网关是否正确）
cat /etc/resolv.conf              # 查 DNS 配置

# 连通性
ping -c3 10.0.0.200               # 测连通（必须加 -c，否则 Linux 一直 ping）
ping -c3 www.baidu.com            # 同时验证 DNS 是否正常

# 端口与服务（最常用）
ss -lntup                         # 查监听端口 + 进程（比 netstat 快）
ss -lntup | grep :80              # 查 80 是否被监听
ss -ant                           # 所有 TCP 连接
ss -ant | awk '{print $1}' | sort | uniq -c    # 统计各状态连接数（看并发/异常）
netstat -lntup                    # 传统写法

# 远程与传输
ssh -p22 root@10.0.0.201                          # 登录
ssh root@10.0.0.201 "hostname -I; df -h /"        # 远程执行（批量巡检核心）
scp /tmp/a.txt root@10.0.0.201:/tmp/              # 传文件
scp -r /data root@10.0.0.201:/backup/             # 传目录
wget -O /tmp/nginx.tar.gz http://xx/nginx.tar.gz  # 下载并改名
```

## 十、深入网络操作命令

- **nmap** — 网络扫描命令（`nmap -p22,80,443 www.baidu.com`）
- **lsof** — 全名 list open files，显示所有被打开的文件
  - `-i:25` 列出占用 TCP/UDP 25 端口的进程；`| grep delete` 筛选被删除的文件
- **mail** — 发送和接收邮件
- **mutt** — 邮件管理命令
- **nslookup** — 交互式查询互联网 DNS 服务器
- **dig** — 查找 DNS 解析过程
- **host** — 查询 DNS 的命令
- **traceroute** — 追踪数据传输路由状况
- **tcpdump** — 命令行抓包工具

### 实战常用（工作场景）

```bash
# 端口占用 / 文件被占用
lsof -i:80                        # 谁占用了 80 端口（服务起不来先查这个）
lsof /var/log/messages            # 谁在打开这个文件
lsof | grep deleted               # 已删除但仍被进程占用（磁盘满却 du 对不上时必查！）

# 端口扫描与连通
nmap -p22,80,443 10.0.0.200       # 扫端口开放情况
nc -zv 10.0.0.201 22              # 快速探测端口（比 telnet 简洁）
telnet 10.0.0.201 22              # 测端口（无 nc 时用）

# DNS 排查
dig www.baidu.com                 # 解析详情（看 ANSWER 段）
nslookup www.baidu.com            # 查解析
host www.baidu.com                # 快速查

# 路径追踪
traceroute www.baidu.com          # 看卡在第几跳
mtr www.baidu.com                 # traceroute + ping 实时版（更好用）

# 抓包（网络问题终极手段）
tcpdump -n -i eth0 port 80        # 抓 80 端口
tcpdump -n -i any port 53         # 抓 DNS（验证解析是否正常）
tcpdump -nn -i eth0 host 10.0.0.201 and port 3306   # 抓与某主机的 3306 通信
tcpdump -w /tmp/cap.pcap -i eth0  # 存文件，下载后用 wireshark 分析
```

## 十一、磁盘与文件系统命令

- **mount** — 挂载文件系统
- **umount** — 卸载文件系统
- **fsck** — 检查并修复 Linux 文件系统
- **dd** — 转换或复制文件
- **dumpe2fs** — 导出 ext2/ext3/ext4 文件系统信息
- **dump** — ext2/3/4 文件系统备份工具
- **fdisk** — 磁盘分区，适用于 2TB 以下磁盘
- **parted** — 磁盘分区，无磁盘大小限制
- **mkfs** — 格式化创建 Linux 文件系统
- **partprobe** — 更新内核的硬盘分区表信息
- **e2fsck** — 检查 ext2/ext3/ext4 类型文件系统
- **mkswap** — 创建 Linux 交换分区
- **swapon** — 启用交换分区
- **swapoff** — 关闭交换分区
- **sync** — 将内存缓冲区内的数据写入磁盘
- **resize2fs** — 调整 ext2/ext3/ext4 文件系统大小
- **ln** — 默认创建硬链接；`-s` 创建软链接

### 实战常用（工作场景）

```bash
# 看盘（最直观）
lsblk                             # 看磁盘、分区、挂载点（首选）
fdisk -l                          # 看分区表
blkid                             # 查各分区 UUID（写 fstab 要用）
df -h                             # 看使用率和挂载点

# 挂载
mount /dev/sdb1 /data             # 临时挂载
mount -o loop /tmp/disk.img /mnt  # 挂载镜像文件
mount -a                          # 测试 /etc/fstab 是否写对（改完 fstab 必做！）
umount /data                      # 卸载
umount -lf /data                  # 强制卸载（设备忙时用，谨慎）

# 永久挂载（改错会开不了机，改完一定 mount -a 验证）
# /etc/fstab 一行示例：
# UUID=xxxx-xxxx  /data  ext4  defaults  0  0

# 分区与格式化（新盘上线流程）
fdisk /dev/sdb                    # 2TB 以下用 fdisk
parted /dev/sdb                   # 2TB 以上用 parted（GPT）
partprobe /dev/sdb                # 通知内核分区表已变（不重启）
mkfs.ext4 /dev/sdb1               # 格式化
tune2fs -c 0 -i 0 /dev/sdb1       # 关闭磁盘自检（避免开机 fsck）
e2fsck -f /dev/sdb1               # 检查修复 ext 文件系统
xfs_repair /dev/sdb1              # 修复 xfs（CentOS7 默认）

# 链接（运维常用）
ln -s /data/app/current /app      # 软链接（版本平滑切换的核心技巧）
ln -s /data/logs /var/log/myapp   # 软链接（日志统一入口）
ln file file.hard                 # 硬链接（防误删）

# swap 应急
swapon -s                         # 看 swap 组成
dd if=/dev/zero of=/tmp/swap bs=1M count=1024    # 造 1G 文件
mkswap /tmp/swap && swapon /tmp/swap             # 转成 swap 并启用
sync                              # 强制把内存缓冲写盘
```

## 十二、系统权限及用户授权相关命令

- **chmod** — 改变文件或目录权限
- **chown** — 改变文件或目录的属主和属组
- **chgrp** — 更改文件用户组
- **umask** — 显示或设置权限掩码

### 实战常用（工作场景）

```bash
# 常规权限（网站标准：文件 644，目录 755）
chmod 644 file
chmod 755 dir
chmod -R 755 /data                # 递归（谨慎：会把文件也变 755）
# 正确做法：目录 755、文件 644 分开设置
find /data -type d -exec chmod 755 {} \;
find /data -type f -exec chmod 644 {} \;

# 归属（网站 403/上传失败 90% 是归属问题）
chown -R nginx:nginx /usr/share/nginx/html     # 网站目录归属
chown www.www /app/blog/upload/                # 上传目录给 web 用户（上传报错必做）
chgrp -R dev /data/dev                         # 改属组

# 特殊权限位
chmod u+x script.sh               # 加执行权限（脚本必做）
chmod 600 id_rsa                  # 私钥必须 600（否则 ssh 报权限太开放）
chmod 1777 /tmp                   # 粘滞位：人人可建，但只能删自己的
chmod u+s /bin/ls                 # suid：执行时临时拥有属主权限（慎用）

# 默认权限
umask                             # 查看（022 → 文件 644、目录 755）
umask 027                         # 收紧默认权限（安全加固）
```

## 十三、查看系统用户登录信息的命令

- **whoami** — 显示当前有效的用户名称（相当于 `id -un`）
- **who** — 显示目前登录系统的用户信息
- **w** — 显示已登录用户列表，并显示其正在执行的指令
- **last** — 显示登入系统的用户
- **lastlog** — 显示系统中所有用户最近一次登录信息
- **users** — 显示当前登录系统的所有用户列表
- **finger** — 查找并显示用户信息

### 实战常用（工作场景）

```bash
whoami                            # 当前用户名（脚本里判断权限最常用）
w                                 # 谁在线 + 正在执行的命令 + 负载（看有没有人误操作）
who                               # 简单看当前登录
users                             # 只列用户名
last -10                          # 最近 10 次登录记录（安全审计/查谁动过机器）
last -i                           # 显示 IP
lastlog                           # 所有用户最后一次登录（查长期不登录的僵尸账号）
lastlog | grep -v "Never logged in"   # 筛出真正登录过的
```

## 十四、内置命令及其它

- **echo** — 打印变量，或直接输出指定字符串
- **printf** — 将结果格式化输出到标准输出
- **rpm** — 管理 rpm 包的命令（`-qa 软件名` 查询；`-ql 软件名` 显示文件列表）
- **yum** — 自动化管理 rpm 包的命令（`-install` 安装；`-y` 自动 yes）
- **watch** — 周期性执行给定命令并全屏显示输出
- **alias** — 设置系统别名
- **unalias** — 取消系统别名
- **date** — 查看或设置系统时间（`-s "2018-07-25 00:00:00"`）
- **clear** — 清屏
- **history** — 查看命令执行历史记录（`ctrl + r` 搜索历史命令）
- **eject** — 弹出光驱
- **time** — 计算命令执行时间
- **nc** — 功能强大的网络工具（`nc 10.0.0.200 22`）
- **xargs** — 将标准输入转换成命令行参数（`-n` 几列显示）
- **exec** — 调用并执行指令
- **export** — 设置或者显示环境变量
- **unset** — 删除变量或函数
- **type** — 判断另一个命令是否是内置命令
- **bc** — 命令行科学计算器

### 实战常用（工作场景）

```bash
# 历史与效率
history | grep ssh                # 搜历史命令
!ls                               # 执行最近一条以 ls 开头的命令
!!                                # 重复上一条（常配合 sudo !!）
Ctrl + r                          # 交互式搜历史（按回车执行）

# 别名
alias ll='ls -lh --color=auto'    # 设置别名
alias                             # 查看所有别名
unalias ll                        # 取消
\cp src dst                      # 反斜杠跳过别名（用原生命令，不询问）

# 环境变量
echo $PATH                        # 命令搜索路径（command not found 先查这个）
export PATH=$PATH:/usr/local/nginx/sbin    # 临时追加
echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile && source /etc/profile   # 永久

# xargs（管道转参数，批量操作核心）
find . -name "*.log" | xargs rm -f                  # 批量删除
find . -name "*.jpg" | xargs -I{} mv {} {}.bak      # 批量改名（-I 占位符）
echo "1 2 3 4" | xargs -n2                          # 每 2 个一行
find . -name "*.sh" -print0 | xargs -0 chmod +x     # 处理含空格的文件名

# 监控与调试
watch -n1 'df -h'                 # 每 1 秒执行一次（观察变化）
time cp -r big/ /tmp/             # 测命令耗时
nc -l 8888                        # 临时起端口（测网络连通）

# 软件包（command not found 时）
yum provides */ifconfig           # 查命令在哪个包
yum install -y net-tools          # 装上
rpm -qf $(which ifconfig)         # 查已装文件属于哪个包
rpm -qa | grep nginx              # 查包装没装
```

## 十五、系统管理与性能监视命令

- **chkconfig** — 管理 Linux 系统开机启动项（`--level 2 iptables on` 设置 2 级别）
- **vmstat** — 虚拟内存统计
- **mpstat** — 显示各个可用 CPU 的状态统计
- **iostat** — 统计系统 IO
- **sar** — 全面获取 CPU、运行队列、磁盘 I/O、分页、内存、中断和网络等性能数据
- **ipcs** — 报告进程间通信设施状态（消息列表、共享内存、信号量）
- **ipcrm** — 删除消息队列、信号量集或共享内存标识
- **strace** — 诊断、调试的用户空间跟踪器，监控系统调用、信号传递、进程状态变更
- **ltrace** — 跟踪进程的库函数调用

### 实战常用（工作场景）

```bash
# CPU
vmstat 1 5                        # 概览：r(运行队列) us sy wa(等IO) si so(swap)
mpstat 1 5                        # 每个 CPU 核心的使用率
top -Hp PID                       # 看某个进程的线程（Java 高 CPU 排障）
pidstat -u 1 5                    # 按进程看 CPU

# 内存
free -h                           # 看 available
vmstat 1 5                        # si/so 不为 0 说明在换页（内存不足）
sar -r 1 3                        # 内存使用历史

# 磁盘 IO（机器卡慢重点看这个）
iostat -x 1 3                     # %util 接近 100% = IO 瓶颈；await 大 = 慢
iotop                             # 看哪个进程在占 IO（需 root）
sar -d 1 3                        # 磁盘历史

# 网络
sar -n DEV 1 3                    # 网卡流量
iftop                             # 实时流量（按连接）

# 综合（事后分析）
sar -u -r -d 1 10                 # 同时采 CPU/内存/磁盘
sar -f /var/log/sa/sa10           # 看历史某天的性能数据（复盘用）

# 深度排查
strace -p PID                     # 跟踪进程的系统调用（卡死/报错定位）
strace -tt -T -f -o /tmp/trace.log command
ltrace -p PID                     # 跟踪库函数调用

# 开机自启
chkconfig --list                  # CentOS6 查开机启动项
systemctl list-unit-files --type=service | grep enabled   # CentOS7
```

## 十六、关机/重启/注销和查看系统信息

- **shutdown** — 关机
- **halt** — 关机
- **poweroff** — 关闭电源
- **reboot** — 重启
- **logout** — 退出当前登录的 Shell
- **exit** — 退出当前登录的 Shell
- **Ctrl+d** — 退出当前登录 Shell 的快捷键

### 实战常用（工作场景）

```bash
shutdown -h now                   # 立刻关机（生产最常用）
shutdown -r now                   # 立刻重启（常用）
shutdown -h 10                    # 10 分钟后关机（给业务留缓冲）
shutdown -h 23:00                 # 指定时间关机
shutdown -c                       # 取消关机/重启计划（重要！设错了马上取消）

reboot                            # 重启（等价 shutdown -r now）
init 0                            # 运行级别 0 = 关机
init 6                            # 运行级别 6 = 重启
poweroff / halt                   # 关机

exit / logout                     # 退出当前登录
Ctrl + d                          # 退出快捷键（生产最常用）

# 生产建议
# 1) 重启前先同步数据：sync
# 2) 给业务留通知时间，用 shutdown -r +10 "系统维护重启"
# 3) 计划变更后记得 shutdown -c 取消
```

## 十七、进程管理相关命令

- **bg** — 将后台暂停的命令变成继续执行（后台执行）
- **fg** — 将后台命令调至前台继续运行
- **jobs** — 查看当前有多少后台运行的命令
- **kill** — 终止进程
- **killall** — 通过进程名终止进程
- **pkill** — 通过进程名终止进程
- **crontab** — 定时任务命令
- **ps** — 显示进程快照（`-ef` 显示程序和环境变量；`f` 树状显示）
- **pstree** — 树形显示进程
- **nice / renice** — 调整程序运行优先级
- **nohup** — 忽略挂起信号运行指定命令
- **pgrep** — 查找匹配条件的进程
- **runlevel** — 查看系统当前运行级别
- **init** — 切换运行级别
- **service** — 启动、停止、重启、关闭系统服务，并显示服务状态

### 实战常用（工作场景）

```bash
# 查进程
ps -ef | grep nginx               # 标准查法
ps aux --sort=-%cpu | head        # CPU 占用 Top（谁把 CPU 吃满）
ps aux --sort=-%mem | head        # 内存占用 Top（谁把内存吃满）
pstree -p                         # 树形（看父子进程关系）
pgrep nginx                       # 只取 PID（脚本里用）
ps -ef | grep -c "[n]ginx"        # 统计进程数（[n] 避免 grep 自身）

# 结束进程
kill PID                          # 优雅停止（SIGTERM，让进程自己善后）——先试这个
kill -9 PID                       # 强制杀死（SIGKILL，最后手段，可能丢数据）
killall nginx                     # 按进程名杀
pkill -f "java -jar app.jar"      # 按完整命令行杀（精准）
ps -ef | grep nginx | grep -v grep | awk '{print $2}' | xargs kill    # 批量杀

# 前台 / 后台
command &                         # 后台运行
jobs                              # 看后台任务
fg %1                             # 调回前台
bg %1                             # 后台继续
Ctrl + z                          # 暂停当前任务

# 脱离终端（运维必会）
nohup ./start.sh >/tmp/out.log 2>&1 &
# 退出终端后仍继续运行，输出进日志

# 定时任务
crontab -e                        # 编辑
crontab -l                        # 查看
# 格式：分 时 日 月 周 命令
# 00 01 * * * /bin/sh /server/scripts/bak.sh >/dev/null 2>&1

# 优先级
nice -n 10 command                # 低优先级运行（备份任务别影响业务）
renice -n 5 -p PID                # 调整已运行进程的优先级
```

## 十八、三剑客

### sed（三剑客老二：取行）
```bash
-n        取消默认输出    sed -n '3p'（第3行）  sed -n '3,5p'
-i        修改文件内容
-i.bak    修改文件内容并备份
's#oldboy#oldgirl#g'   替换
-r        支持扩展正则    sed -r 's#^.*t |/.*$##g'
sed '/^$/d' test.txt    d = delete，按行删除
# s === sub（替换）
```

### awk（三剑客老大：取列）
```bash
NR        行号
'NR==3,NR==5'
'NR==3{print $4}'      $4 = 第4列
-F '[: ]'  指定分隔符
awk '!/^$/' test.txt   ! = 排除
```

### grep（三剑客老三）
使用正则表达式搜索文本，并把匹配的行打印出来（`-v` 反向选择）。

---

### 实战常用（工作场景）

```bash
# ===== grep：过滤 =====
grep -n "ERROR" app.log           # 带行号
grep -v "^#" conf | grep -v "^$"  # 去注释去空行，只看有效配置
grep -C3 "Exception" app.log      # 看上下文
grep -c "404" access.log          # 只统计次数
grep -o '\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}' file   # 只提取 IP

# ===== sed：取行 / 替换 =====
sed -n '20,30p' file              # 取 20~30 行
sed -n '/10:00/,/11:00/p' app.log # 按时间范围取日志（日志排障神器）
sed -i.bak 's#old#new#g' *.conf   # 批量替换并自动备份（生产安全写法）
sed 's#oldboy#oldgirl#g' file     # 只屏幕预览，不改文件
sed -i 's#^#注释#' file           # 批量注释
sed -n '$=' file                  # 看文件总行数

# ===== awk：取列 / 计算 / 统计 =====
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10   # Top10 IP
awk '{sum+=$10}END{printf "总流量: %.2f GB\n", sum/1024^3}' access.log
awk '$9>=500{c++}END{print "5xx数量:", c+0}' access.log              # 统计错误数
awk -F: '$3>=1000{print $1}' /etc/passwd                             # 普通用户
awk 'NR==20,NR==30' file          # 取行范围
awk '{h[$1]++}END{for(i in h) print h[i],i}' access.log | sort -rn | head   # 数组统计
df -h | awk -F'[ %]+' 'NR>1 && $5+0>80{print $1,$NF}'                # 磁盘超80%告警
free -m | awk '/Mem/{printf "内存使用率: %.2f%%\n", $3/$2*100}'

# ===== 三剑客组合 =====
cat access.log | grep "POST" | awk '{print $1}' | sort | uniq -c | sort -rn | head
# 含义：先筛 POST 请求 → 取 IP → 排序去重计数 → 倒序 → 取前几
```

## 十九、综合实战案例（命令串联 · 锻炼运维思维）

> 上面是按类别记命令，实战中往往是**多个命令串成一条链路**解决问题。下面 5 个案例覆盖运维最高频场景，每个案例都按「**现象 → 定位 → 解决 → 验证 → 预防**」五步走。

### 案例一：磁盘告警 95%，如何排查并清理？

```bash
# ① 现象：收到告警 / 服务报 No space left on device
df -h                                   # 看是哪个分区满了（block）
df -i                                   # 同时看 inode（小文件多也会满）

# ② 定位：逐级找占用大的目录
du -sh /* 2>/dev/null | sort -h         # 先找一级目录
du -sh /var/* | sort -h                 # 再深入
du -h --max-depth=1 /var/log            # 看日志明细
find /var/log -type f -size +100M       # 直接找大文件

# ③ 特殊情况：df 满但 du 对不上 → 文件被删但进程仍占用
lsof | grep deleted                     # 找被删除但仍占用的文件
systemctl restart rsyslog               # 重启对应服务释放（不要 kill -9）

# ④ 解决：清理（务必先 -print 确认再 -delete）
find /var/log -name "*.log" -mtime +7 -print
find /var/log -name "*.log" -mtime +7 -delete

# ⑤ 验证 + 预防
df -h && df -i                          # 复查
# 预防：定时任务必须重定向，否则邮件小文件耗尽 inode
# 00 01 * * * /bin/sh /server/scripts/clean.sh >/dev/null 2>&1
```

### 案例二：网站访问慢 / 打不开，排查链

```bash
# ① 看整体：是不是机器本身压力大
uptime                                  # 负载
w                                       # 谁在做什么

# ② 服务在不在
ss -lntup | grep -E ':80|:443'           # 端口监听
systemctl status nginx                   # 服务状态
ps -ef | grep -c "[n]ginx"               # 进程数

# ③ 本地能不能访问（排除网络因素）
curl -o /dev/null -s -w "%{http_code}\n" http://127.0.0.1   # 200 正常
curl -I http://127.0.0.1                                    # 看响应头

# ④ 看错误日志
tail -100 /var/log/nginx/error.log | grep -i error
tail -f /var/log/nginx/access.log                            # 实时看请求

# ⑤ 是否被打/并发异常
ss -ant | awk '{print $1}' | sort | uniq -c                  # 连接状态统计
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head   # Top IP

# ⑥ 状态码分布（5xx 多少）
awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn

# ⑦ 应急：临时封 IP（确认是攻击后）
iptables -I INPUT -s 1.2.3.4 -j DROP
```

### 案例三：日志分析——一条链出运维报表

```bash
LOG=/var/log/nginx/access.log

# PV（总访问量）
wc -l $LOG

# UV（独立 IP 数）
awk '{print $1}' $LOG | sort -u | wc -l

# Top 10 访问 IP（判断是否被刷）
awk '{print $1}' $LOG | sort | uniq -c | sort -rn | head -10

# 总流量
awk '{sum+=$10}END{printf "总流量: %.2f GB\n", sum/1024^3}' $LOG

# 5xx 错误数量（服务质量）
awk '$9>=500{c++}END{print "5xx:", c+0}' $LOG

# 访问最多的 URL
awk '{print $7}' $LOG | sort | uniq -c | sort -rn | head -5

# 某时间段的请求（如 10 点~11 点）
sed -n '/10\/Aug\/2024:10:/,/10\/Aug\/2024:11:/p' $LOG | wc -l

# 一条命令出综合报表：IP + 次数 + 流量
awk '{c[$1]++; b[$1]+=$10}END{
  for(i in c) printf "%-18s 次数:%-6d 流量:%.2f MB\n", i, c[i], b[i]/1024^2
}' $LOG | sort -rnk2 | head
```

### 案例四：批量巡检多台服务器

```bash
# 前提：已配置 ssh 免密
for ip in 10.0.0.201 10.0.0.202 10.0.0.203; do
  echo "========== $ip =========="
  ssh root@$ip "
    echo -n '主机名: '; hostname
    echo -n '负载: ';   uptime | awk -F'load' '{print \$2}'
    echo -n '磁盘: ';   df -h / | awk 'NR==2{print \$5}'
    echo -n '内存: ';   free -m | awk '/Mem/{printf \"%d/%d MB\n\", \$3, \$2}'
  "
done

# 更简洁：用 pssh / ansible 做真正的批量运维
ansible all -m shell -a "uptime; df -h /"
```

### 案例五：发布上线与秒级回滚（软链接技巧）

```bash
# 目录约定：每个版本一个目录，current 是软链接指向当前版本
/data/app/
├── v1.0/
├── v2.0/
└── current -> /data/app/v2.0

# ① 上传新版本
tar xf app-v3.0.tar.gz -C /data/app/
ls -l /data/app/

# ② 校验（可选）
md5sum -c app-v3.0.md5

# ③ 平滑切换（改软链接指向，秒级生效）
ln -sfn /data/app/v3.0 /data/app/current

# ④ 重启/重载服务
systemctl reload nginx

# ⑤ 验证
curl -o /dev/null -s -w "%{http_code}\n" http://127.0.0.1

# ⑥ 出问题秒级回滚（改回软链接即可）
ln -sfn /data/app/v2.0 /data/app/current
systemctl reload nginx
```

---

### 运维思维总结：排障五步法

| 步骤 | 核心问题 | 常用命令 |
| --- | --- | --- |
| **① 现象** | 到底是什么问题？影响范围？ | `df -h`、`uptime`、`curl`、监控告警 |
| **② 定位** | 问题出在哪一层？ | 自下而上：`ping` → `ss/端口` → `ps/进程` → 日志 `tail/grep` |
| **③ 解决** | 最小代价恢复业务 | 优先"重启服务/切备机/回滚"，而非直接改配置 |
| **④ 验证** | 真的恢复了吗？ | 再用第①步的命令复查 + `curl` 验证业务 |
| **⑤ 预防** | 怎么不让它再发生？ | 加监控、加日志切割、加定时任务清理、写文档 |

> **口诀**：
> - **先恢复，后根因**（业务优先）
> - **改前先备份**（`cp a{,.bak}`、软链接回滚）
> - **删除前先 print**（`find ... -print` 确认再 `-delete`）
> - **批量操作先小范围试**（别一上来就 `rm -rf`）

---

## 运维老鸟分享：Linux 运维发展路线规划

> 参考：<https://blog.51cto.com/oldboy/1361536>

> 更新: 2020-05-19 15:00:00
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/bng95k>
