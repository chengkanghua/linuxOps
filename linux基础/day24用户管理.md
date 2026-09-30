# day24 用户管理

> 本文为 Linux 用户与用户组管理课程，涵盖相关配置文件、增删改查命令、useradd 工作原理、su/sudo 提权、用户审计、系统安全（md5/sha 指纹、防木马）以及企业权限案例。

![用户管理](img/day24%E7%94%A8%E6%88%B7%E7%AE%A1%E7%90%86-01.png)
[全部知识回顾总结张首富.xmind](https://www.yuque.com/attachments/yuque/0/2019/xmind/194754/1554017188555-2fcc5dad-122c-4439-bf7b-458dd5c89d8e.xmind)
[用户管理.xmind](https://www.yuque.com/attachments/yuque/0/2026/xmind/194754/1777217542716-9ab380ed-fe83-42c6-980c-e08223b0df2a.xmind)

## 一、相关目录与文件

```bash
# /etc/passwd 每一列含义
cat /etc/passwd
# root:x:0:0:root:/root:/bin/bash
# 1用户名:2密码占位x:3UID:4GID:5用户说明:6家目录:7命令解释器(shell)

/etc/shadow   # 存储用户密码信息
# old : !! : 17749 : 0 : 99999 : 7 : : :
# 1用户名 2密码(!!未设密码) 3最近改密日期 4密码不可更动天数 5需重设天数 6警告期限 7过期恕限 8失效日期 9保留

/etc/group   # 组相关信息  oldboy : x : 500 :
# 1组名 2组密码 3GID 4组成员

/etc/gshadow   # 组密码信息  oldboy : ! : :
# 1组名 2组密码 3组管理员 4成员

/etc/skel   # 新用户家目录的基础环境变量文件（点文件）来源
```

### 命令速查
```bash
useradd       添加用户（默认不删家目录/邮箱）
userdel  -r   删除用户并删除家目录与邮箱；也可通过注释 /etc/passwd 对应行禁用
passwd        修改密码（仅 root 可改他人）；--stdin 非交互设密：echo 123456|passwd --stdin oldboy
usermod       修改用户信息（同 useradd 参数）
   -s 改 shell    -g 主组    -G 附加组（usermod -G root,oldboy,www lidao999；清空用 -G ''）
groupadd      添加组
# 创建虚拟用户 mysql（uid/gid 666，禁止登录、不建家目录）
useradd -u 666 -s /sbin/nologin -M mysql1
id            显示 uid/gid 及所属组
w             谁在线、在做什么（含平均负载：衡量 CPU 与磁盘 IO 繁忙度）
last          所有用户登录情况
lastlog       所有用户最近一次登录情况
```

## 二、/etc/skel 与登录异常修复

企业面试题：用 oldboy 登录后发现提示符变成 `-bash-4.1$`，如何恢复？

```bash
# 模拟故障
useradd u1
passwd u1
# xshell 新窗口 ssh u1@10.0.0.200 登录
rm -rf ~/.bash*        # 删掉家目录下所有 .bash* 配置文件
exit 再登录 → 出现 -bash-4.1$
# 若模拟不成功：vim /etc/profile 注释 PS1= 那行后 source /etc/profile

# 解决：从 /etc/skel 恢复
cp /etc/skel/.bash* ~
```

## 三、useradd 工作原理

```bash
1、不带参数添加用户时，先读取 /etc/login.defs、/etc/default/useradd 的预定义规则
2、按规则添加用户，向 /etc/passwd、/etc/group 写入，并同步生成 /etc/shadow、/etc/gshadow 记录
3、按规则建立家目录，并复制 /etc/skel 中所有隐藏环境配置文件到新用户家目录，完成环境初始化
```

## 四、Linux 用户特点

```bash
多用户、多任务操作系统
root         uid/gid = 0
系统用户（虚拟用户） 1-499   shell 多为 /sbin/nologin，供服务/程序运行
普通用户   500+ 65535        shell 多为 /bin/bash
```

## 五、w / last / lastlog

```bash
[u1@oldboy01 ~]$ w
15:37:49 up  7:58,  3 users,  load average: 0.00, 0.00, 0.00
USER  TTY   FROM         LOGIN@  IDLE  JCPU  PCPU WHAT
root   pts/0 10.0.0.1    07:40   3:45  0.41s 0.00s -bash
u1     pts/1 10.0.0.1    11:44   1.00s 0.02s 0.00s w
[u1@oldboy01 ~]$ w -h    # 不显示表头
last     显示用户登录历史
lastlog  显示所有用户最近一次远程登录信息
```

## 六、创建 / 修改 / 删除 用户与组

```bash
# useradd
useradd 用户名
  -n  不创建同名的私有组
  -c  个人信息
  -u  UID（唯一）
  -s  登录 shell
  -g  主组（须已存在）
  -M  不创建家目录

# usermod
usermod -l u1 oldboy          # 改名
usermod -g root lidao999      # 改主组
usermod -G root,oldboy,www lidao999   # 改附加组
usermod -G '' lidao999        # 清空附加组

# userdel
userdel -r u1     # 连同家目录一起删除
userdel -f u1     # 强制删除

# passwd
passwd 用户名
echo '123456' | passwd --stdin u1     # 非交互设密
# 批量：chpasswd < passwd.txt
vim passwd.txt
y1:123456
y2:123456
```

## 七、su 与 sudo 提权

```bash
su        切换用户，家目录/环境变量不变，但具备管理员权限
su -      切换到新用户家目录，环境变量随之变化

sudo  让普通用户在指定命令上拥有 root 权限
工作过程：
1 用户执行 sudo，系统查找 /etc/sudoers 判断权限
2 有则让用户输入自己的密码确认
3 密码正确开始执行后续命令
4 root 执行 sudo 无需密码（sudoers 中有 root ALL=(ALL) ALL）

# 范例：给 u1 提权，可查看 /root、可使用 useradd
visudo        # 用 visudo 编辑 /etc/sudoers（带语法检查），需 root
# 第98行附近追加：
root  ALL=(ALL)       ALL
u1    ALL=(ALL)       /bin/ls,/usr/sbin/useradd
# 测试
sudo useradd u11
sudo ls /root
sudo -l   # 列出当前用户可执行的 sudo 命令
```

```bash
# oldboy 查看系统日志（临时成为 root 的方式）
# 1. sudo  2. cat + root 的 suid  3. 日志加 r 权限  4. facl 或 root 密码

sudo -l
# [sudo] password for oldboy:
# Sorry, user oldboy may not run sudo on oldboy01.   # 未配置 sudo

visudo
# 授权 oldboy 使用 ls/touch/mkdir
oldboy  ALL=(ALL)       /bin/ls, /bin/touch, /bin/mkdir
# 授权所有命令，但排除危险命令（只能排除你认识的）
oldboy  ALL=(ALL)       /bin/*, !/bin/rm, !/bin/su, !/bin/vi
# 授权所有命令且免密码
oldboy  ALL=(ALL)       NOPASSWD:ALL
```

## 八、用户审计（行为审计）

```bash
跳板机/堡垒机记录用户操作；history -c 可清除记录
1. 硬件：齐治堡垒机
2. 开源：JumpServer
3. 自研：shell / python 脚本
```

## 九、如何让系统更安全

```bash
1 最小化系统/软件
2 保护好 root
   日志分析 /var/log/secure（关注 failure/failed）
   禁止 root 远程登录
   修改 SSH 远程端口
3 文件系统权限
   给关键配置文件加 +a（chattr +a，lsattr 查看）
   给常用命令加 +i
4 给重要文件/命令加指纹
   md5sum oldboy.txt > pol.md5
   md5sum -c pol.md5       # 对比指纹
   # oldboy.txt: OK
   # 定时任务 + md5sum 定期检查（参考 http://blog.51cto.com/lidao/1910889）

linux 查毒思路：
1 事先做指纹，事后对比
2 rpm -Va  比较 rpm/yum 安装的软件是否被篡改
3 杀毒软件 clamav（需 epel 源）
```

## 十、企业面试题：如何防止系统中木马？

```bash
# 与 md5 类似、算法更复杂的指纹：sha
sha1sum  sha224sum  sha256sum  sha384sum  sha512sum
```

**解答战术**（从访问链路层层设卡）：
用户访问 → Linux → HTTP 服务 → 中间件 → 程序代码 → DB → 存储

**从用户访问角度**：
- 程序代码限制上传文件类型（如禁止上传 .php）
- 对上传内容（文本/文件）做检测（程序层、Web/中间件层、DB 层）
- 控制上传目录及非站点目录权限（Linux 权限 + Web 层控制）
- 上传后控制木马的访问与执行（Web 层 + 存储层）
- 对重要配置/命令/WEB 配置做 md5 指纹与备份
- 安装 clamav 定期查杀，配置防火墙与入侵检测
- 监控文件变更、进程、端口、安全日志并及时报警

**从内部管理角度（防提权）**：
- VPN 或 Web 化方式管理服务器；SSH 监听内网
- 跳板机 + 操作审计
- sudo 集权管理、锁定关键文件
- 站点/上传目录权限属组控制
- 系统及站点文件备份指纹监控报警
- 动态口令认证

## 十一、案例题：团队项目目录权限

两个团队 work1、work2，oldboy 是裁判；每队 3 人。要求：组员只能改自己组文件不能删；组长可增删改；其他组不能看/改/进本组目录；所有人不能改自己密码。

```bash
# 一、需求翻译
# 两组 work1/work2；裁判 oldboy；每组 3 人
# 组员：只能改本组文件，不能删
# 组长：可增删改
# 外组：完全不能访问
# 所有人：不能改密码

# 二、标准答案
# 1. 创建组与用户
groupadd work1
groupadd work2
useradd -G work1 work1_z   # 组长
useradd -G work1 work1_1
useradd -G work1 work1_2
useradd -G work2 work2_z
useradd -G work2 work2_1
useradd -G work2 work2_2
useradd oldboy            # 裁判

# 2. 创建项目目录
mkdir -p /data/work1 /data/work2
# 3. 设置归属（组长为所有者，组员同组）
chown work1_z:work1 /data/work1
chown work2_z:work2 /data/work2
# 4. 设置权限
chmod 3770 /data/work1
chmod 3770 /data/work2

# 三、权限解释（3770）
# 770：所有者(组长) rwx；所属组(组员) rwx；其他 ---
# 前面 3 = 1 + 2
# 1 = sticky 粘滞位：组员只能改自己的文件，不能删别人文件
# 2 = SGID：新建文件自动继承组权限
# 四、禁止改密码
chmod 700 /usr/bin/passwd    # 仅 root 可执行 passwd，普通用户无法改密码
```

## 十二、批量创建用户

```bash
# 方式1：for 循环脚本
cat > aa.sh <<EOF
#!/bin/bash
for ((i=1;i<=30;i++))
do
  useradd gj\$i
done
  echo "批量用户成功创建完成啦！！！"
EOF
sh aa.sh
ls /home      # 看到用户即成功

# 批量设密码
cat > aa2.sh <<EOF
#!/bin/bash
for ((i=1;i<=30;i++))
do
    echo "123456"|passwd --stdin gj\$i
done
EOF

# 方式2：命令拼接（禁用 for/while 循环）
# 生成名字与命令
echo stu{01..3}|xargs -n1|sed 's#.*#useradd &#g'
# useradd stu01 / useradd stu02 / useradd stu03
echo stu{01..3}|xargs -n1|sed 's#.*#useradd &;echo 123456|passwd --stdin &#g'
# useradd stu01;echo 123456|passwd --stdin stu01 ...
echo stu{01..3}|xargs -n1|sed 's#.*#useradd &;echo 123456|passwd --stdin &#g' | bash

# 随机密码版（xargs + sed 拼接后交给 bash 执行）
echo user{1..20}|xargs -n1|sed -r 's#(.*)#useradd \1 && echo \1 >>/tmp/passwd.txt && echo $RANDOM |md5sum |cut -c 1-5>>/tmp/passwd.txt && echo `tail -1 /tmp/passwd.txt`|passwd --stdin \1#g'|bash
```

## 十三、脚本开机自启动

```bash
# shell 里变量赋值 = 两边不能有空格
# cat 创建文件时特殊字符需加反斜杠 \$
cat >/root/test.sh<<EOF
#!/bin/bash
DATE=\$(date +%F-%H:%M:%S)
echo \$DATE >> /tmp/time.log
EOF
chmod +x /root/test.sh
vi /etc/rc.d/rc.local
  /bin/bash /root/test.sh
chmod +x /etc/rc.d/rc.local
shutdown -r now
```

## 扩展练习

```bash
# 找出 /etc/init.d/ 下包含 chkconfig: 的行
grep --color 'chkconfig:' /etc/init.d/*|column -t

# 创建一个 uid 999 的虚拟用户，禁止远程登录、不建家目录
useradd -u 999 -s /sbin/nologin -M lidao999
```

每日一题汇总博客（李导）：<http://blog.51cto.com/lidao/1914205>
批量创建用户并设置随机密码：<https://blog.51cto.com/lidao/1936495>

![补充图](img/day24%E7%94%A8%E6%88%B7%E7%AE%A1%E7%90%86-02.png)

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/xga6s4>
