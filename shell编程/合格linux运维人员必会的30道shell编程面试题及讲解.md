# 合格 Linux 运维必会的 Shell 编程面试题（31 题）

> 原文：<https://blog.51cto.com/oldboy/1632876>

本篇汇总 31 道企业级 Shell 面试题，涵盖监控、数组、循环、MySQL、图形打印、代码发布等场景。每题给出**需求**、**参考代码/思路**及**答案链接**，适合边练边背。

---

## 1. 监控 MySQL 主从同步异常并报警
**需求**：① 守护进程每 30 秒检测一次；② 出现错误号（1158/1159/1008/1007/1062）则跳过错误；③ 用**数组**获取主从状态与错误号；异常则发短信/邮件。

`show slave status` 关键字段（模拟数据）：
```bash
[root@oldboy~]# mysql -uroot -p'oldboy' -S /data/3307/mysql.sock -e "show slavestatus\G;"
*************************** 1. row ***************************
               Slave_IO_State:Waiting for master to send event
                  Master_Host:10.0.0.179   #当前的mysql master服务器主机
                  Master_User: rep
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File:mysql-bin.000013
         Read_Master_Log_Pos: 502547
               Relay_Log_File:relay-bin.000013
                Relay_Log_Pos:251
        Relay_Master_Log_File:mysql-bin.000013
             Slave_IO_Running:Yes
           Slave_SQL_Running: Yes
              Replicate_Do_DB:
         Replicate_Ignore_DB: mysql
          Replicate_Do_Table:
      Replicate_Ignore_Table:
     Replicate_Wild_Do_Table:
 Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
         Exec_Master_Log_Pos: 502547
              Relay_Log_Space:502986
              Until_Condition:None
               Until_Log_File:
                Until_Log_Pos: 0
          Master_SSL_Allowed: No
          Master_SSL_CA_File:
          Master_SSL_CA_Path:
              Master_SSL_Cert:
           Master_SSL_Cipher:
               Master_SSL_Key:
       Seconds_Behind_Master: 0   #和主库比同步延迟的秒数，这个参数很重要
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
```
> 思路：循环里 `mysql -e "show slave status\G"` 取 `Slave_IO_Running`/`Slave_SQL_Running`（应为 Yes）和 `Last_SQL_Errno`，用数组存错误码集合比对；非 0 且命中错误号则 `STOP/START SLAVE` 跳过。

## 2. 随机文件名批量建 10 个 html
**需求**：`/oldboy` 下用随机 10 个小写字母 + 固定串 `oldboy` 批量建 10 个 html 文件。
```bash
[root@oldboy oldboy]# sh /server/scripts/oldboy.sh
[root@oldboy oldboy]# ls
coaolvajcq_oldboy.html  qnvuxvicni_oldboy.html  vioesjmcbu_oldboy.html
gmkhrancxh_oldboy.html  tmdjormaxr_oldboy.html  wzewnojiwe_oldboy.html
jdxexendbe_oldboy.html  ugaywanjlm_oldboy.html  xzzruhdzda_oldboy.html
qcawgsrtkp_oldboy.html  vfrphtqjpc_oldboy.html

#!/bin/bash
dir=/oldboy/
[ ! -d $dir ] && mkdir -p $dir
for i in `seq 10`
do
 touch $dir`echo $RANDOM|md5sum|tr "0-9" "j-z"|cut -c1-10`_oldboy.html
done
```

## 3. 文件名 oldboy→oldgirl，html 大写（≥2 种方法，for 循环）
**需求**：将上题文件名中 `oldboy` 全部改成 `oldgirl`，并把 `html` 改为大写 `HTML`。
> 思路 1：`for f in *oldboy*; do mv $f ${f/oldboy/oldgirl}; done` 再 `rename`/`mv` 处理后缀。思路 2：`ls|awk` 生成 `mv` 命令管道执行。

## 4. 批量建 10 个系统账号并设置随机 8 位密码
**需求**：`oldboy01`~`oldboy10`，密码为随机 8 位字符串。
> 思路：`for i in {01..10}; do useradd oldboy$i; pass=$(...</dev/urandom tr -dc a-zA-Z0-9|head -c8); echo $pass|passwd --stdin oldboy$i; echo oldboy$i $pass>>/tmp/user.log; done`

## 5. 判断 10.0.0.0/24 当前在线 IP
**需求**：扫描网段，列出在线 IP（方法很多）。
> 思路：`for i in {1..254}; do ping -c1 -w1 10.0.0.$i &>/dev/null && echo 10.0.0.$i >>online.txt; done`（或 `nmap -sP`/`fping`）。

## 6. 脚本解决 DOS 攻击（≥2 种方法）
**需求**：根据 web 日志或连接数，某 IP 并发或短时 PV 达 100 即调用 `iptables -I INPUT -s IP -j DROP` 封禁，每 3 分钟监控一次。
答案：<http://blog.51cto.com/oldboy/2141081>

## 7. 开发 MySQL 多实例启动脚本
**需求**：启动 `mysqld_safe --defaults-file=/data/3306/my.cnf &`，停止 `mysqladmin -u root -poldboy123 -S /data/3306/mysql.sock shutdown`，用函数 + `case` + `if` 实现。
单实例答案：<http://blog.51cto.com/oldboy/2124950>

## 8. MySQL 分库备份脚本
**需求**：对 MySQL 每个库单独备份。
> 思路：`for db in $(mysql -e "show databases"|grep -v ...); do mysqldump $db > $db.sql; done`

## 9. MySQL 分库加分表备份脚本
**需求**：在分库基础上对每个库的表再单独备份。
> 思路：内层再 `for tb in $(mysql $db -e "show tables")` 逐个 `mysqldump 库 表`。

## 10. for 循环打印字母数不大于 6 的单词
**需求**：`I am oldboy teacher welcome to oldboy training class.` 中只打印长度 ≤6 的单词（≥2 种方法）。
> 思路：`for w in 句子; do [ ${#w} -le 6 ] && echo $w; done`；或 `awk` 按长度过滤。

## 11. 两种入参方式比较 2 个整数大小
**需求**：分别用**脚本传参**和 **read 读入** 比较两个整数，屏幕提示结果；需判断变量是否为数字、传参个数。
> 思路：函数 `is_num` 用正则 `^[0-9]+$` 校验；`[ $# -ne 2 ]` 校验参数个数；`if [ $a -gt $b ]` 比较。

## 12. 打印选择菜单一键安装 Web 服务
```bash
[root@oldboyscripts]# sh menu.sh
   1.[install lamp]
   2.[install lnmp]
   3.[exit]
   pls input the num you want:
```
要求：① 输 1 输出 `start installing lamp.` 并执行 `/server/scripts/lamp.sh`（输出 `lamp is installed`）；② 输 2 执行 lnmp 脚本；③ 输 3 退出；④ 其它字符提示 `Input error` 并退出；⑤ 执行前判断脚本是否存在、可执行。
> 思路：`case $num in 1)..2)..3)..*) esac`，用 `[ -x script ]` 判断可执行。

## 13. 监控 web / db 服务正常（各 ≥3 种策略，每 1 分钟）
> 思路（web）：① `curl -I` 看 HTTP 状态码；② `wget --spider`；③ 端口 `ss -lnt`；④ 进程 `pgrep`。db 同理（端口/进程/`mysqladmin ping`）。

## 14. 监控 memcache 服务（模拟客户端）
**需求**：用 `nc` 加 `set/get` 模拟检测，监控响应时间与命中率。
> 思路：`printf 'stats\r\n'|nc ip 11211` 取 `cmd_get`/`get_hits` 算命中率。

## 15. 监控 web 站点目录文件是否被篡改
**需求**：`/var/html/www` 下文件内容被改则打印改动文件名并邮件通知，每 3 分钟执行。
> 思路：首次对所有文件 `md5sum` 存档，定时 `md5sum -c` 比对，不一致即告警。

## 16. rsync 独立进程启动脚本
**需求**：`/etc/init.d/rsyncd {start|stop|restart}`，用系统函数库、函数实现、可被 `chkconfig` 管理。
> 思路：头部加 `# chkconfig: 2345 20 80`、`. /etc/init.d/functions`，`case` 调 `rsync --daemon` / `pkill`。

## 17. 抓阄程序（天津项目实践）
**需求**：输入英文全拼生成 01-99 随机数，数字越大越优先；已出现数字不可重复；输完不退出继续等待。
答案：<http://blog.51cto.com/oldboy/1308647>

## 18. 破解 RANDOM 经 md5sum 截取后的字符串
**需求**：已知下面字符串是 `echo $RANDOM|md5sum|cut -c1-8` 的结果，求对应 RANDOM 数字（范围 0-32767）。
```
21029299
00205d1c
a3da1677
1f6d12dd
890684b
```
```bash
[root@iotcontroll-centos-1 tmp]# cat random.sh
#!/bin/bash
a=(21029299
00205d1c
a3da1677
1f6d12dd)
for n in {0..32767}
do
        random=`echo $n|md5sum|cut -c1-8`
        for((i=0;i<=${#a[@]};i++))
        do
                if [ "$random" == "${a[i]}" ];then
                echo "$n" "${a[i]}"
                fi
        done
done
```

## 19. 数组批量检查多个网站地址
**需求**：用 shell 数组检测多个 URL 是否正常，策略模拟用户访问。
```bash
[root@web01 ~]# vim check_url.sh
#############################################################
# File Name: check_url.sh
# Version: V1.0
# Author: ckh
# Created Time : 2018-11-15
#############################################################
url=(
http://www.etiantian.org
http://www.taobao.com
http://oldboy.blog.51cto.com
http://10.0.0.7
)
for i in ${url[@]}
      do
      a=`curl -o /dev/null -s --connect-timeout 2 -w %{http_code} $i`
      if [ $a = 200 -o $a = 301 -o $a = 302 ]
        then
          echo "$i 正常"
        else
          echo "$i 异常"
      fi
done
```

## 20. 文本词频 / 字母频统计（中企动力）
**需求**：① 按单词出现频率降序；② 按字母出现频率降序。
文本：`The months of learning in Old Boy education are the few months that I think the time efficient is the most.I had also studied at other training institutions before, but I was hard to understand what the tutor said and hard to follow. It was just too much to learn with no outline.`

**按单词频率：**
```bash
# 方法1：去符号→空格换换行→计数
sed 's#[,\.]##g' oldboy.log|tr " " "\n"|sort|uniq -c|sort -rn|head -5
      4 the
      3 to
      2 was
      2 months
      2 I

# 方法2：awk 数组
tr " ," "\n" <oldboy.log|awk '{S[$1]++}END{for(k in S) print S[k],k}'|sort -rn|head -5

# 方法3：awk 直接横向处理
awk -F "[ ,.]+" '{for(i=1;i<NF;i++)S[$i]++}END{for(k in S) print S[k],k}' oldboy.log |sort -rn|head -5
```

**按字母频率：**
```bash
# 方法1：竖向排列字符后计数
sed 's#[,. ]##g' oldboy.log|grep -o "."|sort|uniq -c|sort -rn|head -5
     33 t
     20 o
     19 e
     18 n
     17 i

# 方法2：awk 数组
sed 's#[,. ]##g' oldboy.log|grep -o "."|awk '{S[$1]++}END{for(k in S) print S[k],k}'|sort -rn|head -5

# 方法3：awk -F "" 横向处理
sed 's#[,. ]##g' oldboy.log|awk -F "" '{for(i=1;i<NF;i++)S[$i]++}END{for(k in S) print S[k],k}'|sort -rn|head -5
```

## 21. 输出正方形、等腰三角形、直角梯形
答案：<http://oldboy.blog.51cto.com/2561410/1718607>

## 22. Web 界面展示 Nginx 代理节点状态
![Nginx 节点状态效果](img/%E5%90%88%E6%A0%BClinux%E8%BF%90%E7%BB%B4%E4%BA%BA%E5%91%98%E5%BF%85%E4%BC%9A%E7%9A%8430%E9%81%93shell%E7%BC%96%E7%A8%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%8A%E8%AE%B2%E8%A7%A3-01.jpeg)
答案：<http://blog.51cto.com/oldboy/1589685>

## 23. LVS 主节点 ipvsadm 管理脚本
**需求**：`/etc/init.d/lvs {start|stop|restart}` 手工管理 LVS。
> 思路：`case` 调 `ipvsadm -A/-a/-D` 增删虚拟服务与真实节点。

## 24. LVS 主节点模拟 keepalived 健康检查
**需求**：节点挂掉（检测 2 次、间隔 2 秒）从池中剔除；恢复（检测 2 次）加回，利用 `ipvsadm` 实现。
> 思路：循环 `ipvsadm -Ln` 取节点状态，异常则 `ipvsadm -d` 剔除、正常则 `-a` 加回。

## 25. LVS 客户端节点 VIP/ARP 抑制脚本
**需求**：`/etc/init.d/lvsclient {start|stop|restart}` 配置 VIP 并抑制 ARP。
> 思路：`start`：`ifconfig lo:0 VIP netmask 255.255.255.255 up` + `echo 1 > /proc/sys/net/ipv4/conf/.../arp_ignore` 等。

## 26. LVS 备节点模拟 vrrp 接管
**需求**：监听主节点，主不可访问则备启动并配置 LVS 接管资源（注意 ARP 缓存）。
> 思路：定时 `ping` 主节点 VIP，失败则在本机 `ipvsadm` 配置并 `arping` 刷新网关 ARP。

## 27. 画正方形 `oldboy_square.sh`
**需求**：接收用户输入数字 n，输出 n×n 的方块的。
```bash
[root@oldboy ~]# sh oldboy_square1.sh
Please Enter a number:5
++++++++++
++++++++++
++++++++++
++++++++++
++++++++++
[root@oldboy ~]# sh oldboy_square2.sh
Please Enter a number:9
■■■■■■■■
■■■■■■■■
■■■■■■■■
■■■■■■■■
■■■■■■■■
■■■■■■■■
■■■■■■■■
■■■■■■■■
■■■■■■■■
```

## 28. 画等腰三角形 `oldboy2_triangle.sh`
**需求**：接收数字 n，输出 n 行的等腰三角形。
```bash
[root@oldboy ~]# sh oldboy2_triangle.sh
Please Enter a number:5
    *
   ***
  *****
 *******
*********
[root@oldboy ~]# sh oldboy2_triangle.sh
Please Enter a number:8
       *
      ***
     *****
    *******
   *********
  ***********
 *************
***************
```

## 29. 画直角梯形 `oldboy4.sh`
**需求**：接收参数 n、m，输出上底 n、下底 m 的直角梯形。
```bash
[root@oldboy ~]# sh oldboy4.sh 4 6
****
*****
******
```
> 27/28/29 参考：<http://oldboy.blog.51cto.com/2561410/1718607>

## 30. 企业代码上线发布系统
**需求**：用 SVN 管理代码与配置，从办公室服务器取出指定版本发布到 IDC 分发机，在分发/负载/应用服务器本地实现平滑发布、上线、回滚脚本。

## 31. Git + Saltstack 代码线上发布方案
**需求**：设计一套 Git + Saltstack 的代码线上发布与管理方案（参考《跟老男孩学习 Linux 运维：Shell 高级编程实战》）。

---

> 更新：2024-09-03 21:54:06
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/rhi6yh>
