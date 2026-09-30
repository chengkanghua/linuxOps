# day24用户管理

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- day24用户管理
- 有关用户的目录文件
- ```bash
- cat /etc/passwd
- /etc/group ：主要存储组相关信息的文件 oldboy : x : 500 :
- cat /etc/group
- /etc/gshadow ：主要用来存储组密码信息
- /etc/skel   新用户需要的所有基础环境变量文件的目录。
- ctrl + 回退键
- -a：添加一个用户到组,可以追加到组
- sudo –l  查看当前有什么权限
- visudo
- 授权oldboy用户ls  touch mkdir
- oldboy 进行测试
- !/bin/vi 排除 禁止/bin/rm /bin/su /bin/vi   坑 你只能排除你认识的
- 授权oldboy      /bin/* 所有命令
- #记录指纹库
- md5sum oldboy.txt > pol.md5
- #指纹进行对比
- md5sum -c pol.md5
- 定时任务+ md5sum定时检查
- 和md5类似 ，加密算法更复杂
- sha
- 创建组
- 创建用户
- echo stu{01..3}|xargs -n1|sed 's#.*#useradd &#g'
- echo stu{01..3}|xargs -n1|sed 's#.*#useradd &;echo 123456|passwd --stdin &#g'
- cat 创建文件时里面的特殊字符加反斜杠\$

![1546510854253-45f41c40-bb88-4d25-8ff6-50da95928f53.png](img/day24%E7%94%A8%E6%88%B7%E7%AE%A1%E7%90%86-01.png)

[全部知识回顾总结张首富.xmind](https://www.yuque.com/attachments/yuque/0/2019/xmind/194754/1554017188555-2fcc5dad-122c-4439-bf7b-458dd5c89d8e.xmind)

[用户管理.xmind](https://www.yuque.com/attachments/yuque/0/2026/xmind/194754/1777217542716-9ab380ed-fe83-42c6-980c-e08223b0df2a.xmind)



# 有关用户的目录文件
# ```bash
#/etc/passwd 每一列的含义
# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
1用户名:2密码:3UID:4GID:5用户说明信息:6用户的家目录:7用户使用的命令解释器shell

/etc/shadow ：存储用户密码信息文件
old : !! : 17749 : 0 : 99999 : 7 : : :
1用户名 2 密码 3 最近改动密码的日期 4 密码不可被更动的天数 5 密码需要重新变更的天数 6 密码需要变更期限前的警告期限 7 密码过期的恕限时间
8帐号失效日期 9 保留

# /etc/group ：主要存储组相关信息的文件 oldboy : x : 500 :
# cat /etc/group
root:x:0:
bin:x:1:
mail:x:12:postfix
1组名 2组密码 3组ID（GID） 4组成员

# /etc/gshadow ：主要用来存储组密码信息
oldboy : ! : :
1组名 2组密码 3组管理员 4用户组成员


命令：
useradd
userdel  默认不会删除用户老家 和邮箱
		     -r删除用户的老家 与邮箱
		     通过注释 /etc/passwd 用户所在行
         
passwd  修改密码  只能root用户用
		    --stdin   非交互式设置密码   echo 123456|passwd --stdin oldboy
usermod  修改用户信息  与useradd 类似
  		 -s   改shell解释器
  		 -g  主要组   usermod –g root lidao999
  		 -G  附加组   usermod –G root,oldboy,www lidao999
    		清空组副加组  usermod  -G '' lidao999
groupadd 添加用户组

#添加一个虚拟用户mysql 用户和用户组的uid 666
useradd -u 666  -s /sbin/nologin -M mysql1

查询用户信息
id  显示用户信息 uid gid 和属于用户组

w 显示谁登录系统， 并在干什么
	平均负载： 系统的繁忙程序 ， 衡量cpu和磁盘IO		
  
last   	  所有用户的登陆情况
lastlog  	所有用户最近一次的登陆情况






# /etc/skel   新用户需要的所有基础环境变量文件的目录。
企业面试题
范例:  使用oldboy用户登录到linux 系统后，发现提示为如下所示异常情况，
请问如何恢复到正常的linux命令行提示符情况？
-bash-4.1$
-bash-4.1$

模拟故障：
1、useradd u1
2、passwd u1
3、在xshell里新开一个窗口
    ssh IP地址 //执行此命令
    例如 ：ssh u1@10.0.0.200
4、弹出窗口 输入用户名和密码
5、在普通用户的家目录 ~ rm -rf .bash* 
6、ls -a //发现.bash* 的文件全部删除
7、exit  //退出登录
8、 ssh IP地址 //执行此命令在重新登录一次，登录后发现故障
注如果模拟故障不成功，
	原因分析：1、vim /etc/profile  2、注释掉PS=那行  3、 source /etc/profile
  
解决故障：
cp /etc/skel/.bash* ~  # 把/etc/skel/.bash* 下的所有.bash* 文件拷贝到 用户的家目录

```



# useradd命令工作原理有以下几步完成：
```bash
1、不带任何参数使用添加用户时，
    首先读/etc/login.defs  /etc/default/useradd 预先定义的规则
2、根据设置的规则添加用户，同时会向/etc/passwd  /etc/group文件添加新建的用户和组，
   但/etc/shadow   /etc/gshadow也会同步生成记录
3、同时系统会根据/etc/login.defs /etc/default/useradd文件中配置的信息建立用户的家目录，
并复制/etc/skel中所有隐藏的环境配置文件到新用户的家目录中，以完成对用户环境的初始化设置。



```



# linux 用户特点
```bash
多用户、多任务的操作系统
root的 uid gid  为0

系统用户（虚拟用户） 1-499
普通用户 500+ 65535


```





# w 显示目前登入系统的用户信息
```bash
[u1@oldboy01 ~]$ w
15:37:49 up  7:58,  3 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    10.0.0.1         07:40    3:45   0.41s  0.00s -bash
u1       pts/1    10.0.0.1         11:44    1.00s  0.02s  0.00s w
u2       pts/2    10.0.0.1         11:50    3:28m  0.00s  0.00s -bash	
[u1@oldboy01 ~]$ w -h
root     pts/0    10.0.0.1         07:40    4:24   0.41s  0.00s -bash
u1       pts/1    10.0.0.1         11:44    0.00s  0.02s  0.00s w -h
u2       pts/2    10.0.0.1         11:50    3:29m  0.00s  0.00s -bash

last命令用了显示用户登录情况，
lastlog 命令 显示linux中所有用户最近一次远程登录的信息

```



![1546510533134-27a26fd2-dea4-41e9-b445-c9380fe8ff95-image1.png](img/day24%E7%94%A8%E6%88%B7%E7%AE%A1%E7%90%86-02.png)







# 创建用户  
```bash
useradd  用户名
-n 不创建以用户名为名的组
-c 创建用户时，添加个人信息
-u 用户ID值，这个值必须是唯一的
-s 用户登录后使用的shell
-g 指定用户对应的组，对应的组必须在系统中存在
-M 不创建家目录
```



# usermod 修改系统已经存在的用户信息
```bash
-c 修改用户的个人信息，同useradd 的-c功能 
-g 修改用户对应的用户组，同 useradd的-d功能
-s 修改用户登录后使用的shell名称，同useradd的-s功能
-u 修改用户的uid ，同useradd 的-u功能
-l 修改用户的名称
usermod –l u1 oldboy  //把oldboy用户名改为u1
```



# userdel –r  删除用户  
```bash
		-r 带家目录一起删除
		-f 强制删除用户
userdel –r u1  删除u用户
```



# passwd    修改当前用户密码
```bash
passwd  用户名    修改用户名密码
echo ‘123456’ |passwd  --stdin u1   // 非人工交互设置密码

chpasswd 批量设置密码
y1:123456
y2:123456
# ctrl + 回退键

vim passwd.txt
chpasswd < passwd.txt   //批量设置密码
```



# su  su – 区别  切换用户
su 家目录环境变量没变化   具备管理员权限

su -  切换到家目录 环境变量变化



```bash
sudo  通过配置文件让普通用户在执行指定的命令时候，拥有超级用户的权限。
sudo的工作过程如下：
1，当用户执行sudo时，系统会主动寻找/etc/sudoers文件，判断该用户是否有执行sudo的权限
2，确认用户具有可执行sudo的权限后，让用户输入用户自己的密码确认
3，若密码输入成功，则开始执行sudo后续的命令
4，root执行sudo时不需要输入密码(因为sudoers文件中有配置root ALL=(ALL) ALL这样一条规则)

范例1：给普通用户u1提权,让普通用户可以查看root用户的家目录；普通用户可以使用useradd命令，创建新用户
范例分析步骤：
1） useradd u1
2） visudo=vi打开/etc/sudoers文件 或 vim /etc/sudoers 
注：visudo会检查内部语法，避免用户输入错误信息，所以我们一般使用visudo，编辑此文件要用root权限
3) 编辑文件的第98行，编辑完成后，wq! 强制保存退出
root ALL=(ALL) ALL
u1 ALL=(ALL) /bin/ls,/usr/sbin/useradd 
4）使用u1 用户登录测试 
sudo useradd u11 //可成功创建用户，证明提权成功
sudo ls /root //可查看root的家，证明提权成功
5） sudo -l //-l 参数是列出当前用户可执行的命令，但只有在sudoers文件里的用户才能使用该选项。



```



# id命令  查看用户的 uid gid
```bash
[root@bogon /]# id user6
uid=8897(user6) gid=8899(z11) groups=8899(z11)
[root@bogon /]# id -g user6
8899
[root@bogon /]# id -G user6
8899
[root@bogon /]# id -u user6
8897
```



# groupadd  添加组命令
```bash
groupadd 组名
groupadd -g 666 zz1  添加新组 指定gid
groupadd –f  已经存在的组名     强制覆盖一个已存在的组 ， gid 组成员不会改变

[root@oldboy01 ~]# gpasswd -M u1,u2 edu  //  添加u1 u2 用户到 edu用户组
[root@oldboy01 ~]# grep edu /etc/group
edu:x:515:u1,u2
[root@oldboy01 ~]# gpasswd -M '' edu    //批量清空用户组成员
[root@oldboy01 ~]# grep edu /etc/group
edu:x:515:
```



# gpasswd  将用户加入组中
```bash
# -a：添加一个用户到组,可以追加到组
gpasswd -a user1 z1      #将user1 追到z1 成员中 -M：添加多个用户到组，覆盖之前的组成员

#将u1 u2 u3 加入zz1 组里 覆盖之前的组成员信息 
gpasswd -M u1,u2,u3 zz1   

#-d：从组删除用户
gpasswd –d  user1 z1    # 将user1从组成员中删除


```



# groupmod  修改组信息
```bash
-n 修改组名
groupmod -n z1 zz1   将zz1 修改z1 -g 修改GID
groupmod -g 888 z1   将z1 组gid 改成888
```



# groupdel 组名    删除 组名
```bash
groupdel z1   删除组
删除组，删除组后，用户名依然存在
```

``

# groups 用户名  查看用户属于哪个组的
```bash
[root@oldboy01 mail]# groups u3
u3 : u3 z1
```

# 临时成为root :   sudo
	oldboy用户 查看系统日志

1. sudo
2. cat root  suid
3. 日志加上 r权限
4. facl  或者 root密码

```bash
# sudo –l  查看当前有什么权限
[oldboy@oldboy01 ~]$ sudo -l
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:
#1) Respect the privacy of others.
#2) Think before you type.
#3) With great power comes great responsibility.
[sudo] password for oldboy:
Sorry, user oldboy may not run sudo on oldboy01. # 你没有配置sudo


# visudo
# 授权oldboy用户ls  touch mkdir
root    ALL=(ALL)        ALL
oldboy  ALL=(ALL)       /bin/ls, /bin/touch, /bin/mkdir
# oldboy 进行测试
$ sudo ls /root


visudo
# !/bin/vi 排除 禁止/bin/rm /bin/su /bin/vi   坑 你只能排除你认识的
# 授权oldboy      /bin/* 所有命令
oldboy  ALL=(ALL)       /bin/*, !/bin/rm, !/bin/su, !/bin/vi


授权oldboy 系统所有命令  且不需要 密码
visudo
oldboy  ALL=(ALL)       NOPASSWD:ALL


```









# 用户审计  行为审计（记录用户操作）
```bash
跳板机 堡垒机  # 记录用户记录
	        history –c  清楚操作记录
          
1. 硬件： 齐治堡垒机
2. 开源软件：jumpserver
3. 自己写： shell脚本  python


```

# 用户分类：
```bash
  UID     0    root
  
	虚拟用户： 1-499  命令解释器/sbin/nologin
					服务/程序  运行所需要的用户
          
	普通用户：500+     /bin/bash
```



# 如何让系统更安全
```bash
1 最小化  系统 软件
2 保护好root
      日志分析/var/log/secure     failure或failed
      禁止root远程登录
      修改远程连接端口号				
3 文件系统权限
      给系统配置文件 +a   （命令是 chattr +a 文件名 lsattr查看）
      常用命令+i			（命令是 shattr +i 文件名 lsattr查看）	
4 给重要文件或命令加指纹
#给文件创建指纹

# #记录指纹库
# md5sum oldboy.txt > pol.md5
# #指纹进行对比
# md5sum -c pol.md5
oldboy.txt: OK

# 定时任务+ md5sum定时检查
参考http://blog.51cto.com/lidao/1910889


linux常见查出病毒方法：
1 事先做好指纹，时候进行检查
2 rpm –aV 比较yum 或者 rpm安装的软件 是否变化
3. 查病毒的软件：clamav
作业： 安装clamav（增加epel源）

---------------------------------------------

命令：
	md5sum  显示文件指纹0信息
		-c   --check   根据指纹列表进行对比
	useradd 添加用户
		-u  指定uid
		-s  指定shell命令解释器
		-M  不创建家目录
		-g  指定用户所属的群组
	passwd  设置密码
		--stdin
	userdel 删除用户
		-r  删除用户家目录
	usermod  修改用户信息
		参数与useradd 类似
	groupadd 添加组
		-g  指定用户组gid
	id 显示用户信息  UID GID  属于哪些用户组
	w  显示谁登录了系统 并做什么 ， 附加 负载信息 uptime
	last 显示用户登录情况  谁在哪里  什么时间登录系统， 登录了多久
	lastlog  显示所有用户最近一次的登陆情况
	sed  ‘s###g’
			&  表示前面正则表达式匹配到的内容
```



# 如何防止系统中木马? 
```bash
# 和md5类似 ，加密算法更复杂
# sha
sha1sum    sha224sum  sha256sum  sha384sum  sha512sum  


http://lidao.blog.51cto.com/3388056/1910889
如何防止系统中木马? 

-解答战术

因为Linux下的木马常常是恶意者通过Web的上传目录的方式来上传木马到Linux服务器的，可根据
从恶意者访问网站开始-->Linux系统-->HTTP服务-->中间件服务-->程序代码-->DB-->存储，层层设卡防护。

-从用户访问角度解答参考
开发程序代码对上传文件类型做限制，例如不能上传.php程序（JS及后端代码控制）。
对上传的内容（包括文本和文件）检测，检测方式可通过程序、Web服务层（中间件层）、数据库等层面控制。
控制上传目录的权限以及非站点目录的权限（Linux文件目录权限+Web服务层控制）。
 传上木马文件后的访问和执行控制（Web服务层+文件系统存储层）。
对重要配置文件、命令和WEB配置等文件做md5指纹及备份。
安装杀毒软件clamav等，定期监测查杀木马。
 配置服务器防火墙及入侵检测服务。
监控服务器文件变更、进程变化、端口变化、重要安全日志并及时报警。

-从内部管理人员角度：防止被提权
vpn管理服务器或Web化管理服务器。
ssh监听内网。
采用跳板机、操作审计。
sudo集权管理、锁定关键文件。
站点目录、上传目录权限属组控制。
做系统及站点文件备份指纹监控报警。
动态口令认证。
```



# 案例题分析：
## 两个参赛团队work1、work2，
两个参赛团队work1、work2，oldboy是两个组的裁判员，这两个团队互相竞争，各需提交一份项目方案报告，每组成员可以修改自己团队内的文件、队员不能删除文件、队长可以删除、且不能让其他团队的人修改、读取自己的文件内容，并且参赛的所有人不能修改密码。此时怎么办？每个参塞团队各3人。

```bash
一、先把需求翻译成人话（面试必说）
两个团队：work1、work2
裁判：oldboy
每组 3 个成员
权限要求：
组员 只能改自己组文件，不能删
组长 可以删、可以改
另一组不能看、不能改、不能进 本组目录
所有人 不能改自己密码

二、标准答案（直接背）
1. 创建用户和组
# 创建组
groupadd work1
groupadd work2

# 创建用户
useradd -G work1 work1_z  # 组长
useradd -G work1 work1_1
useradd -G work1 work1_2

useradd -G work2 work2_z  # 组长
useradd -G work2 work2_1
useradd -G work2 work2_2

useradd oldboy  # 裁判
2. 创建项目目录（最关键）
mkdir -p /data/work1
mkdir -p /data/work2
3. 设置归属（核心）
chown work1_z:work1 /data/work1
chown work2_z:work2 /data/work2
4. 设置权限（面试核心）
chmod 3770 /data/work1
chmod 3770 /data/work2

三、权限解释（面试必须讲清楚）
3770 权限拆解
770
所有者（组长）：rwx → 增删改查
所属组（组员）：rwx → 增改，不能删
其他组：--- → 完全不能访问
最前面的 3 = 1 + 2
1 = sticky 粘滞位 → 组员只能改自己的文件，不能删别人文件
2 = SGID 位 → 新建文件自动继承组权限

四、禁止修改密码（最后一步）
chmod 700 /usr/bin/passwd
#只有 root 能执行 passwd，普通用户无法改密码！


口语版：
1. 创建两个组 work1、work2，分别创建组长和成员。
2. 创建项目目录 /data/work1 和 /data/work2。
3. 目录归属：组长是所有者，组员属于同组。
4. 权限设置为 3770：
   - 770 保证本组可读写，外组不能访问。
   - 粘滞位 1 保证组员不能删文件。
   - SGID 2 保证继承组权限。
5. 把 passwd 命令权限改为 700，禁止普通用户改密码。

```



## 批量创建用户： 
```bash
1、创建一个文件，此文件的扩展名必须为*.sh
cat > aa.sh <<EOF
#!/bin/bash 
for ((i=1;i<=30;i++))
do
  useradd gj\$i
done
  echo "批量用户成功创建完成啦！！！"  
EOF
sh aa.sh 
3、查看脚本是否成功
 ls /home  注：如果在home里看到，批量创建的用户，代表成功 批量创建30个用户，
   并为30个用户批量设置密码，以脚本形式。


cat > aa2.sh <<EOF
#!/bin/bash 
for ((i=1;i<=30;i++))
do  
    #useradd gj\$i 
    echo "123456"|passwd --stdin gj\$i 
done
EOF

```



## 批量添加用户升级版


```bash
批量添加3个用户stu01,stu02....stu10,并设置123456      (禁止使用for,while等循环)
批量添加10个用户stu01,stu02....stu10,并设置8位随机密码(禁止使用for,while等循环)

老师内容：
		命令拼接
1 目标
		 useradd stu01;  echo 123456|passwd --stdin stu01
		 useradd stu02;  echo 123456|passwd --stdin stu02
		 useradd stu03;  echo 123456|passwd --stdin stu02
     
2生成名字
# echo stu{01..3}|xargs -n1|sed 's#.*#useradd &#g'
useradd stu01
useradd stu02
useradd stu03
# echo stu{01..3}|xargs -n1|sed 's#.*#useradd &;echo 123456|passwd --stdin &#g'
useradd stu01;echo 123456|passwd --stdin stu01
useradd stu02;echo 123456|passwd --stdin stu02
useradd stu03;echo 123456|passwd --stdin stu03
echo stu{01..3}|xargs -n1|sed 's#.*#useradd &;echo 123456|passwd --stdin &#g' |bash

方法一
echo user{1..20}|xargs -n1|sed -r 's#(.*)#useradd \1 \&\& echo \1 >>/tmp/passwd.txt \&\& echo $RANDOM |md5sum |cut -c 1-5>>/tmp/passwd.txt \&\& echo `tail -1 /tmp/passwd.txt`|passwd --stdin \1#g'|bash

echo user{1..20}|xargs -n1|sed -r 's#(.*)#useradd \1 \&\& \
echo \1 >>/tmp/passwd.txt \&\& \
echo $RANDOM |md5sum |cut -c 1-5>>/tmp/passwd.txt \&\& \
echo `tail -1 /tmp/passwd.txt`|passwd --stdin \1#g'|bash



```

# # 面试题: 如何让一个脚本开机自启动
```bash
#shell里设置变量 = 两边不能有空格
# cat 创建文件时里面的特殊字符加反斜杠\$ 
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



# 找出/etc/init.d/下面的文件中 包含chkconfig:的行
```bash
grep --color 'chkconfig:' /etc/init.d/*|column -t 


```



# 添加一个用户lidao999 uid为999  禁止远程登入系统 不创建家目录
```bash
#创建一个uid为999的虚拟用户
useradd -u 999 -s /sbin/nologin -M lidao999

-u 指定uid
-s shell 命令解释器（默认是/bin/bash）
		/sbin/nologin
-M   不创建家目录 （sM）
-g  指定用户组名称


```











扩展: 

每日一题-汇总博客 李导   [http://blog.51cto.com/lidao/1914205](http://blog.51cto.com/lidao/1914205)  

[https://blog.51cto.com/lidao/1936495](https://blog.51cto.com/lidao/1936495)  批量创建用户并设置随机密码





















> 更新: 2026-04-26 23:57:52  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/xga6s4>