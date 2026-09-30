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

## 五、文件压缩及解压缩命令

- **tar** — 打包压缩
  - `zcf 打包名.tar.gz 目标` 打包压缩；`tf` 查看压缩包内容；`xf` 解压（`-C` 指定路径）
  - `--exclude` 排除：`tar zcf /tmp/etc-pai.tar.gz /etc/ --exclude /etc/services`
- **unzip** — 解压 zip 文件
- **gzip** — gzip 压缩工具
- **zip** — zip 压缩工具

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

## 七、搜索文件命令

- **which** — 查找二进制命令，按 PATH 路径查找
- **find** — 从磁盘遍历查找文件或目录
  - `-type f/d`；`-name "*.txt"`；`-iname` 不区分大小写；`-size +100k/-10k`
  - `-maxdepth` 目录层级；`-mtime -n` n 天内 / `+n` n 天前 / `n` 第 n 天
  - `-exec` 对匹配文件执行命令；`!` 取反；`-a` 交集；`-o` 并集
- **whereis** — 查找二进制命令，按 PATH 路径查找
- **locate** — 从数据库 `/var/lib/mlocate/mlocate.db` 查找（`updatedb` 更新库）

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

## 十二、系统权限及用户授权相关命令

- **chmod** — 改变文件或目录权限
- **chown** — 改变文件或目录的属主和属组
- **chgrp** — 更改文件用户组
- **umask** — 显示或设置权限掩码

## 十三、查看系统用户登录信息的命令

- **whoami** — 显示当前有效的用户名称（相当于 `id -un`）
- **who** — 显示目前登录系统的用户信息
- **w** — 显示已登录用户列表，并显示其正在执行的指令
- **last** — 显示登入系统的用户
- **lastlog** — 显示系统中所有用户最近一次登录信息
- **users** — 显示当前登录系统的所有用户列表
- **finger** — 查找并显示用户信息

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

## 十六、关机/重启/注销和查看系统信息

- **shutdown** — 关机
- **halt** — 关机
- **poweroff** — 关闭电源
- **reboot** — 重启
- **logout** — 退出当前登录的 Shell
- **exit** — 退出当前登录的 Shell
- **Ctrl+d** — 退出当前登录 Shell 的快捷键

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

## 运维老鸟分享：Linux 运维发展路线规划

> 参考：<https://blog.51cto.com/oldboy/1361536>

> 更新: 2020-05-19 15:00:00
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/bng95k>
