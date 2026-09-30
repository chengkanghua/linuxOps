# day34知识点串线

![1547276832937-9d241dd0-474e-49c4-8615-06e8c34a647f.png](img/day34%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2%E7%BA%BF-01.png)



![1547276847726-f143f00f-0f96-4e45-8fa9-847b2c95b1c6.png](img/day34%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2%E7%BA%BF-02.png)



![1547276859816-60e20b41-ed6f-40e8-aa8b-cb3dc4a76e71.png](img/day34%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2%E7%BA%BF-03.png)

![1547276872317-53e9b78e-e413-414d-a167-a9748fa20a06.png](img/day34%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2%E7%BA%BF-04.png)



![1547276898239-38a894ea-3f44-474d-82ef-110e04ecd424.png](img/day34%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2%E7%BA%BF-05.png)



[day34基础课程回顾.xmind](https://www.yuque.com/attachments/yuque/0/2019/xmind/194754/1554020708751-067c23f2-56f3-4a83-bb53-d0b5f66fc641.xmind)



[老男孩-DELL R710服务器raid配置.pdf](https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1553425919452-c49c5e84-8597-4f7e-8d95-4babae1db118.pdf)

[老男孩--生产环境Dell R410服务器远程控制卡安装配置文档（草稿）.pdf](https://www.yuque.com/attachments/yuque/0/2019/pdf/194754/1553425924155-d7556b69-3509-43d3-9f6f-1b9d8212f0d3.pdf)

# 基础课程回顾  面试题：
服务器配置		

```bash
牌子 型号    dell r720 
cpu	        2路cpu
内存				32 64G  128G
磁盘        sas 15k 300G*6

```



## RAID级别与应用场景
|  | 最少需要几块盘 | 安全冗余 | 可用容量 | 性能 | 使用场景 | 举例 |
| --- | --- | --- | --- | --- | --- | --- |
| Raid0 | 1 | 最低 | 所有硬盘容量之和 | 读写最快 | 不要求安全只求速度 | 数据库从库<br/>存储从库 |
| Raid1 | 只能两块 | 100% | 一半（两块硬盘容量之和） | 写入速度慢读取ok | 只追求安全性，对速度没 | 系统盘 监控服务器 |
| Raid 5 | 3 | 最多损坏一块 | 损失一块盘容量 | 写入性能不好读取速度ok | 对 速度和安全要求不高 | 普遍数据库存储 |
| Raid10 | 4 | 可以损坏一盘 | 损失所有硬盘一半容量 | 读写很快 | 对于安全和性能都要 | 高并发或高访问量<br/>数据库主库 存储 |




## 程序 进程 守护进程
```bash
含义
    程序：命令 软件
    进程： 正在运行的软件
    守护进程： 一直运行的进程
如何查询正在运行的进程
    ps aux| grep '/[s]shd'
    ps aux|grep '[c]rond' |wc –l #显示crond进程数量
    ps aux|grep -c '[c]rond'    # -c 统计行数

    
```

				



## buffer 和cache
```bash
写buffer 缓冲区
读 cache 缓存区  缓存无处不在
```

## 如何看系统内存使用情况
```bash
	free –h
	系统会把用过的命令 文件缓存起来
```

			 

## 如何查看系统的并发数量
```bash
		并发？  与系统已经建立连接的
    如何查看？ 
    ss –ant      #ESTAB 建立连接
    netstat -ant	
```

## 常见linux发行版本
```bash
		Ubuntu 	 开发人员
    debian	 安全性比较高
    redhat   国企金融
    centos    和redhat一样，去掉了logo 和收费项目
    fedora   redhat测试版
    opensuse	德国
    中标麒麟 红旗   国产的
```

## 企业磁盘分区规则
```bash
数据不重要（节点）
      /boot  200M   swap 内存的1.5倍，最大8G  / 50-200G
数据重要
    /boot  200M   swap 内存的1.5倍，最大8G  / 50-200G  /data 剩下全给
不知道是否重要
    /boot  200M   swap 内存的1.5倍，最大8G  / 50-200G   剩余空间不分配
```

## 什么是端口 ip 协议
```bash
端口； 区分不同的服务
      远程连连ssh 22    http 80  https 443
ip ： 服务器的位置
协议： 共同遵守规则
```

### 查看哪个端口开启
```bash
yum install telnet nc nmap -y
	telnet 10.0.0.200 22
	nc 10.0.0.200 22
  nmap -p22 10.0.0.200     
  nmap -p1-1024 www.baidu.com 10.0.0.200
	
  服务器本地执行
	     netstat -lntap |grep 22
       ss -lntapu | grep 22
			 lsof -i:22
       
```



## 特殊符号
```bash
引号系列
  $() ===`` 运行里面的命令
  ""  特殊符号进行解析
  '' 所见即所得 ，原封不动输出
    不加引号  与双引号类似， 可以使用{}（通配符）

重定向系列
  >  标准输出重定向
  >>    标准输出追加重定向
  2>    错误输出
  2>>  错误追加
  <    标准输入重定向  xargs   tr替换  tr a c <test.txt
  <<  标准输入追加重定向
         cat >> oldboy.txt<<EOF   EOF
  2>&1  >/dev/null 2>&1
                  >>/tmp/oldboy.log  2>&1  追加到指定文件
判断系列
  &&    前面正确 才执行后面的
  ||       前面失败 在执行后面
  $?     上一个命令的退出状态 0 正确  非0 错误

位置系列
  ~    cd ~家目录  # awk 包含 awk ‘$1~/oldboy/’
                   # sed表示从哪里开始每次增加 sed –n ‘1~2p’
  .    当前目录   source   .  /etc/init.d/functions
  ..   上级目录
  cd –  返回上次所在目录  cd $OLDPWD
  su -  切换用户

无分类系列
  #   注释  代表root用户
  $   普通命令提示符   以.. 结尾   awk中$1取第几列 $0一整行 $oldboy 取变量内容
              shell  $1 $2 $3  $0脚本名称 $?上个命令退出状态 $#脚本参数个数
  $() == ``        ${} ==${a}week
  !     取反  vim中强制:q!   !ls 执行最近以ls开头的命令  history “ls”
  !!    运行上一个命令
  |     管道符号   ||或者
  ;     在同一行分割多条命令
```

### 正则表达式


```bash
BRE   ERE
	表示连续出现/重复     *  +  a{n,m}  ?
	 其他      					^
              				$
					            ^$
					            .
					            *
					            .*
					            |
					            []
					            [^]
					            ()
                      
```



### egrep '^[^:]+' /etc/passwd  找:前面的
```bash
# '[^:]'：表示匹配任何不包含冒号的字符
egrep '[^:]' /etc/passwd
egrep '[^:]' /etc/passwd -o

# [^:] 表示匹配任何一个不是冒号的字符。
# + 表示前面的模式重复一次或多次。所以 [^:]+ 整体的意思就是匹配至少一个非冒号字符。
egrep '[^:]+' /etc/passwd

# ^ 表示匹配行的开头。 [^:] 表示匹配任何不是冒号的字符;+ 表示前面的字符集（非冒号字符）出现一次或多次。
egrep '^[^:]+' /etc/passwd
egrep '^[^:]+' /etc/passwd  -o
```



## 目录结构
/etc/sysconfig/network-scripts/ifcfg-eth0

```bash
# cat /etc/sysconfig/network-scripts/ifcfg-eth0
name=eth0
device=eth0
bootproto=static/none
ipaddr =10.0.0.200
netmask=255.255.255.0 #prefix=24
onboot=yes
gateway=10.0.0.254
dns1=223.5.5.5


	/etc/	resolv.conf       域名解析    域名 解析ip地址	
	/etc/	sysconfig/network  主机名修改

#设置修改主机名
1 hostname                  临时
2 /etc/sysconfig/network    永久
3 /etc/hosts       10.0.0.200  oldboy         #解析
 ping 主机名可以ping通
#主机名修改配置文件之后不需要source   只有source  /etc/profile  /etc/sysconfig/i18n

/etc/	hosts		        域名解析
/etc/	fstab     开机自动挂载设备
每一列含义
    1 要挂载的分区或设备
    2挂载位置
    3 文件系统类型
    4 挂载的参数
    5 自否定时备份 0  1
    6 是否自动检查    0 1 2   根目录1 其他设备2  0表示设备不会被fsck检查

/etc/	inittab    运行级别
/etc/	init.d/    服务脚本
/etc/	rc.local   开机自启动命令
/etc/	profile    环境变量  别名 全局生效
/etc/	bashrc   	别名
  ~/.bashrc       用户家目录
  ~/.bash_profile		
/etc/profile.d/   脚本以.sh结尾  这里脚本每次开机自运行 #自己写个跳板机
/etc/	issue		登入之前
/etc/	motd		登入之后
/etc/	crontab     系统定时任务的配置文件
/etc/	sudoers      sudu配置文件  visudo == vi /etc/sudoers
           visudo –c  检查语法
/etc/	passwd   用户信息
/etc/	shadow	   用户密码
/etc/	group	  用户组信息
/etc/	gshadow
/etc/	skel      新用户的家目录的模板    

命令行-bash-4.1$如何解决？  (用户管理)
echo $PS1
解决：  cp /etc/skel/.bash*  ~/

/etc/	sysconfig/i18n   字符集编码
/etc/	sysconfig/selinux -- /etc/selinux/config
/etc/yum.conf    yum配置文件   keepcache =1 自动保存yum下载的软件包
rpm –e tree lrzsz nmap  卸载软件  yum自动保存位置/var/cache/yum/x86_64
/etc/	yum.repos.d/   存放yum源配置文件    yum repolist 查看系统的yum源
/etc/	crontab    定时任务配置文件
    /etc/	cron.daily/    每天
    /etc/	cron.hourly/   每小时
    /etc/	cron.monthly/  每月
    /etc/	cron.weekly/		每周

/proc/   虚拟目录
  cpuinfo
  meminfo
  loadawg
  mounts
/var/
  log/secure
  log/messages
  log/cron   定时任务日志
  spool/cron/root  root定时任务配置文件
  spool/mail/root  root邮箱
  spool/postfix/maildrop 邮件的临时目录
/usr
  local  编译安装默认的位置
              
linux下软件软件安装方法
    yum install –y tree xxxx
    yum grouplist	
    yum groupinstall
        rpm   -ivh  安装
    -e  卸载
    -qa 检查
    -ql 查看软件包内容	
    -qf  查命令的软件包rpm -qf `which ifconfig ip`
        yum search ifconfig  查询命令相关软件包
        
  编译安装
        ./configure  make  make install

其他
/dev	   /dev/null   /dev/zero
	/tmp   权限1777
	/home
	/root



  
```



# 故障案例项目案例
```bash
	1提升用户体验
		redis/memcached
		让数据放入内存中   高并发 用户访问量不大的时候
	2 无法远程连接服务器
		排除过程	 	检查道路是否通畅 ping
		 			    关闭 selinux  iptables
		  			  端口是否开启 22
		常见原因
				ip地址
			    网卡配置
			    vmware服务
				vmware 虚拟网路编辑器  nat设置  网关设置
				windows 虚拟网卡
	3 linux 显示中文乱码
		乱码原因： linux系统的字符集和远程工具字符集不同
		如何检查   查看系统字符集  echo $LANG
					            检查xshell 使用的字符集
		解决乱码  修改xshell字符集
				            修改系统的字符集
					          export  LANG=en_US.UTF-8
					          vim /etc/sysconfig/i18n    LANG=”en_US.UTF-8”
					          source /etc/sysconfig/i18n
			              检查 echo $LANG  查看字符集文件


```





		



![1547276954111-4bc10e31-4222-4364-8fcd-9547f7cd01e9.png](img/day34%E7%9F%A5%E8%AF%86%E7%82%B9%E4%B8%B2%E7%BA%BF-06.png)









> 更新: 2024-08-23 20:29:44  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/vxgdl1>