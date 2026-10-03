# 第二章·自动化运维工具-Ansible ad-hoc

## Ansible ad-hoc
| 什么是ad-hoc？ |
| --- |

ad-hoc简而言之就是“临时命令”，执行完即结束，并不会保存

| ad-hoc模式的使用场景 |
| --- |

比如在多台机器上查看某个进程是否启动，或拷贝指定文件到本地，等等

| ad-hoc模式的命令使用 |
| --- |

<!-- OCR_START -->
- 命令格式
- ansible
- 'zls'
- -m
- command
- 'df-h
- 格式说明
- 命令
- 主机名称
- 指定模块
- 模块名称
- 模块动作
- 具体命令
<!-- OCR_END -->

```bash
#批量查看磁盘信息
[root@m01 ~]# ansible web_group -m command -a 'df -h' -i ./hosts
web02 | CHANGED | rc=0 >>
文件系统         容量  已用   可用 已用% 挂载点
/dev/sda3        18G  1.1G   17G    6% /
devtmpfs        981M     0  981M    0% /dev
tmpfs           992M     0  992M    0% /dev/shm
tmpfs           992M  9.5M  982M    1% /run
tmpfs           992M     0  992M    0% /sys/fs/cgroup
/dev/sda1      1014M  124M  891M   13% /boot
tmpfs           199M     0  199M    0% /run/user/0
web01 | CHANGED | rc=0 >>
文件系统        容量  已用  可用 已用% 挂载点
/dev/sda3        18G  1.1G   17G    6% /
devtmpfs        981M     0  981M    0% /dev
tmpfs           992M     0  992M    0% /dev/shm
tmpfs           992M  9.5M  982M    1% /run
tmpfs           992M     0  992M    0% /sys/fs/cgroup
/dev/sda1      1014M  124M  891M   13% /boot
tmpfs           199M     0  199M    0% /run/user/0
#批量查看内存信息
[root@m01 ~]# ansible web_group -m command -a 'free -m' -i ./hosts
web01 | CHANGED | rc=0 >>
              total        used        free      shared  buff/cache   available
Mem:           1982         143        1688           9         150        1668
Swap:          1023           0        1023
web02 | CHANGED | rc=0 >>
              total        used        free      shared  buff/cache   available
Mem:           1982         142        1684           9         155        1666
Swap:          1023           0        1023
```

| ad-hoc结果返回颜色 |
| --- |

> 绿色: 代表被管理端主机没有被修改
>
> 黄色: 代表被管理端主机发现变更
>
> 红色: 代表出现了故障，注意查看提示
>

---

| ad-hoc常用模块 |
| --- |

```bash
command             # 执行shell命令(不支持管道等特殊字符)
shell               # 执行shell命令
scripts             # 执行shell脚本
yum_repository      # 配置yum仓库
yum                 # 安装软件
copy                # 变更配置文件
file                # 建立目录或文件
service             # 启动与停止服务
mount               # 挂载设备
cron                # 定时任务
get_url             #下载软件
firewalld           #防火墙
selinux             #selinux
```

---

| Ansible-doc帮助手册 |
| --- |

```bash
[root@m01 ~]# ansible-doc -l        # 查看所有模块说明
[root@m01 ~]# ansible-doc copy      # 查看指定模块方法
[root@m01 ~]# ansible-doc -s copy   # 查看指定模块参数
```

## Ansible命令模块
| command |
| --- |

```bash
 mv ~/hosts /etc/ansible/
# 默认模块, 执行命令  #默认找的host文件是/etc/ansilbe/hosts
[root@m01 ~]# ansible web_group -a "hostname"
```

---

| shell |
| --- |

```bash
# 如果需要一些管道操作，则使用shell
[root@m01 ~]# ansible web_group -m shell -a "ps -ef|grep nginx" -f 50
```

---

| script |
| --- |

```bash
# 编写脚本
[root@m01 ~]# vim /root/yum.sh
#!/usr/bin/bash
yum install -y vsftpd
#在本地运行模块，等同于在远程执行，不需要将脚本文件进行推送目标主机执行
[root@m01 ~]# ansible web_group -m script -a "/root/yum.sh"
```

## Ansible软件管理模块
| yum |
| --- |

```bash
[root@m01 ~]# ansible web_group -m yum -a "name=httpd state=present"
name                            
    httpd                       #指定要安装的软件包名称
    file://                     #指定本地安装路径（yum localinstall 本地rpm包）
    http://                     #指定yum源（从远程仓库获取rpm包）
    
state                           #指定使用yum的方法
    installed,present           #安装软件包
    removed,absent              #移除软件包
    latest                      #安装最新软件包
    
[root@m01 ~]# ansible-doc yum
exclude=kernel*,foo*            #排除某些包
list=ansible                    #类似于yum list查看是否可以安装
disablerepo="epel,ol7_latest"   #禁用指定的yum仓库
download_only=true              #只下载不安装 yum install d
```

---

| yum_repository |
| --- |

```bash
#添加yum仓库
[root@m01 ~]# ansible web_group -m yum_repository -a "name=zls_epel description=EPEL baseurl=https://download.fedoraproject.org/pub/epel/$releasever/$basearch/" -i ./hosts
#仓库名和配置文件名不同
[root@m01 ~]# ansible web_group -m yum_repository -a 'name=zls_epel description=EPEL file=test_zls baseurl=https://download.fedoraproject.org/pub/base/$releasever/$basearch/ gpgcheck=no' -i ./hosts
#添加mirrorlist
[root@m01 ~]# ansible web_group -m yum_repository -a 'name=zls_epel description=EPEL file=test_zls baseurl=https://download.fedoraproject.org/pub/base/$releasever/$basearch/ gpgcheck=no mirrorlist=http://mirrorlist.repoforge.org/el7/mirrors-rpmforge enabled=no' -i ./hosts
#删除yum仓库及文件
[root@m01 ~]# ansible web_group -m yum_repository -a 'name=zls_epel file=test_zls state=absent' -i ./hosts
#开起gpgcheck
[root@m01 ~]# ansible web_group -m yum_repository -a 'name=zls_epel description=EPEL file=test_zls baseurl=https://download.fedoraproject.org/pub/base/$releasever/$basearch/ gpgcheck=yes gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7' -i ./hosts
name        #指定仓库名，如果没有file则为仓库文件名
baseurl     #指定yum源
gpgcheck    #指定检查秘钥
    no
    yes
enabled     #是否启用仓库
    no
    yes
```

## Ansible文件管理模块
对于文件管理，我们在学习Linux基础的时候，就学习了很多命令，比如创建，删除，移动，拷贝，下载...等

**生产场景，统一配置管理**

---

| copy |
| --- |

```bash
# 推送文件模块
[root@m01 ~]# ansible web_group -m copy -a "src=/etc/passwd dest=/tmp/zls.txt"
# 在推送覆盖远程端文件前，对远端已有文件进行备份，按照时间信息备份
[root@m01 ~]# ansible web_group -m copy -a "src=/etc/passwd dest=/tmp/zls.txt backup=yes"
# 直接向远端文件内写入数据信息，并且会覆盖远端文件内原有数据信息
[root@m01 ~]# ansible web_group -m copy -a "content='zls' dest=/tmp/zls.txt"
src             #推送数据的源文件信息
dest            #推送数据的目标路径
backup          #对推送传输过去的文件，进行备份
content         #直接批量在被管理端文件中添加内容
group           #将本地文件推送到远端，指定文件属组信息
owner           #将本地文件推送到远端，指定文件属主信息
mode            #将本地文件推送到远端，指定文件权限信息
```

---

| file |
| --- |

```bash
[root@m01 ~]# ansible web_group -m file -a "path=/tmp/zls_dir state=directory"
[root@m01 ~]# ansible web_group -m file -a "path=/tmp/zls_file state=touch mode=0555 owner=root group=root"
[root@m01 ~]# ansible web_group -m file -a "src=/tmp/zls_dir path=/tmp/zls_dir_link state=link"
[root@m01 ~]# ansible web_group -m file -a "path=/tmp/zls_dir state=directory owner=zls group=zls mode=0700 recurse=yes"
path            #指定远程主机目录或文件信息
recurse         #递归授权
state 
    directory   #在远端创建目录
    touch       #在远端创建文件
    link        #link或hard表示创建链接文件
    absent      #表示删除文件或目录
    mode        #设置文件或目录权限
    owner       #设置文件或目录属主信息
    group       #设置文件或目录属组信息
```

---

| get_url |
| --- |

```bash
[root@m01 ~]# ansible web_group -m get_url -a 'url=https://mirrors.aliyun.com/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.0-1.el7.x86_64.rpm dest=/tmp mode=0644' -i ./hosts
url             #指定下载地址
dest            #指定下载的目录
mode            #指定权限
checksum        #校验加密算法
    md5
    sha256
```

## Ansible服务管理模块
| service、systemd |
| --- |

```bash
#启动crond并加入开机自启
[root@m01 ~]# ansible web_group -m service -a "name=crond state=started enabled=yes"
#停止crond并删除开机自启
[root@m01 ~]# ansible web_group -m service -a "name=crond state=stoped enabled=no"
name        # 定义要启动服务的名称
state       # 指定服务状态
    started     #启动服务
    stopped     #停止服务
    restarted   #重启服务
    reloaded    #重载服务
enabled         #开机自启
```

## Ansible用户管理模块
Ansible管理用户与组，通常使用user、group模块

---

| group |
| --- |

```bash
[root@m01 ~]# ansible web_group -m group -a "name=zls gid=888"
name            #指定创建的组名
gid             #指定组的gid
state
    absent      #移除远端主机的组
    present     #创建远端主机的组（默认）
```

---

| user |
| --- |

```bash
#创建用户指定uid和gid，不创建家目录也不允许登陆
[root@m01 ~]# ansible web_group -m user -a "name=zls uid=888 group=888 shell=/sbin/nologin create_home=false"
#创建用户并生成秘钥对
[root@m01 ~]# ansible web_group -m user -a "name=zls uid=888 group=root shell=/bin/bash generate_ssh_key=yes ssh_key_bits=2048 ssh_key_file=.ssh/id_rsa" -i ./hosts
web01 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": true,
    "comment": "",
    "create_home": true,
    "group": 0,
    "home": "/home/zls",
    "name": "zls",
    "shell": "/bin/bash",
    "ssh_fingerprint": "2048 SHA256:WEMHCpSjxxqFwlzrCk1FqrPqeq6N/SHxL1gFTSqHlGM ansible-generated on web01 (RSA)",
    "ssh_key_file": "/home/zls/.ssh/id_rsa",
    "ssh_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRx+bCYGh4FqpKoPzyXrR8ef9GwoY6l6QEFQ0+XPynR22fd9Lbs1eUxWDm5aH4ZO8sPaI8a5xmj88Sipwl0FxlQTjD2X/vreZNEDbwFWrbZ24VvPkfPSSWBh5SxLH6pJt8pGQpPVWuLRMx6yOOxRB1hh9bGFzQNg5z8xqzeogTOoI7cxSFZVuUb5affNj8H5mCw2nAvblV+HNhRzbMlwr+9/EWcCWHDnlVYcELHXjpNJcyGB3VFOu1MPkmLaSTcaB73O0eRvZQkYMBePKJC44tvjHihGhvCk9rzh8qvzHxvMgoMD/+0uKAlIwEvOyfAczb7fxllU0rDtbyPtjbuLsR ansible-generated on web01",
    "state": "present",
    "system": false,
    "uid": 888
}
web02 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": true,
    "comment": "",
    "create_home": true,
    "group": 0,
    "home": "/home/zls",
    "name": "zls",
    "shell": "/bin/bash",
    "ssh_fingerprint": "2048 SHA256:IepfOosi2Xm8kfr4nOPAhG3fec6o8kpMnJ0/RwN+0F8 ansible-generated on web02 (RSA)",
    "ssh_key_file": "/home/zls/.ssh/id_rsa",
    "ssh_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEcO9iDKg4X8ya/y9E0eDelAFMp/rxiDSzW31r+REawaQyF4oywcdIagpz0MTg2BeF2WdaYUmHmtmSTfSOMif26+R1FLcL9f9NYu3io/0388jukcTfyN02diXWgqoKtt4Gbm8Bq8sWE4tX/FSYl42fG6bX1AyDSMzzB7ERr2AD/Y9KuKt7cEXDinGjqTFEXw6+x1wBHpotkUisYiZCci+1Nx4YSznVRBveZTlpxMUYmKgwkUXQIt+RoOYzjgD++0md8O7lwJGgODZkahlrf2pOQnmpS4isLi9or4N+DVnqD+cXb/RjgJzPIJZYazgRY3vtAU9DDqm5i049x/VxEqFj ansible-generated on web02",
    "state": "present",
    "system": false,
    "uid": 888
}
#将明文密码进行hash加密，然后进行用户创建
[root@m01 ~]# ansible web_group -m debug -a "msg={{ 'zls' | password_hash('sha512', 'salt') }}" -i ./hosts
web01 | SUCCESS => {
    "msg": "$6$salt$gaWhNcZweYlKQcLU1CqyY/UbYqIeUffVz6ESj87aMNfMX.xYBx0Z.67wzLN/hkkxmNut7SvkksPZ2Zlrse98m/"
}
web02 | SUCCESS => {
    "msg": "$6$salt$gaWhNcZweYlKQcLU1CqyY/UbYqIeUffVz6ESj87aMNfMX.xYBx0Z.67wzLN/hkkxmNut7SvkksPZ2Zlrse98m/"
}
#创建用户
[root@m01 ~]# ansible web_group -m user -a 'name=zls1 password=$6$salt$gaWhNcZweYlKQcLU1CqyY/UbYqIeUffVz6ESj87aMNfMX.xYBx0Z.67wzLN/hkkxmNut7SvkksPZ2Zlrse98m/ create_home=true shell=/bin/bash' -i ./hosts
uid             #指定用户的uid
group           #指定用户组名称
groups          #指定附加组名称
password        #给用户添加密码(单引号)
shell           #指定用户登录shell
create_home     #是否创建家目录
```

## Ansible定时任务模块
| cron |
| --- |

```bash
# 正常使用crond服务
[root@m01 ~]# crontab -l
* * * * *  /bin/sh /server/scripts/yum.sh
# 使用ansible添加一条定时任务
[root@m01 ~]# ansible web_group -m cron -a "minute=* hour=* day=* month=* weekday=*  job='/bin/sh /server/scripts/test.sh'"
[root@m01 ~]# ansible web_group -m cron -a "job='/bin/sh /server/scripts/test.sh'"
# 设置定时任务注释信息，防止重复，name设定
[root@m01 ~]# ansible web_group -m cron -a "name='cron01' job='/bin/sh /server/scripts/test.sh'"
# 删除相应定时任务
[root@m01 ~]# ansible web_group -m cron -a "name='ansible cron02' minute=0 hour=0 job='/bin/sh /server/scripts/test.sh' state=absent"
 
# 注释相应定时任务，使定时任务失效
[root@m01 scripts]# ansible web_group -m cron -a "name='ansible cron01' minute=0 hour=0 job='/bin/sh /server/scripts/test.sh' disabled=no"
```

## Ansible磁盘挂载模块
| mount |
| --- |

```bash
[root@m01 ~]# ansible web_group -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=present"
[root@m01 ~]# ansible web01 -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=mounted"
[root@m01 ~]# ansible web02 -m mount -a "src=172. 16.1.31:/data path=/data fstype=nfs opts=defaults state=unmounted"
[root@m01 ~]# ansible web -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=absent"
present     # 开机挂载，仅将挂载配置写入/etc/fstab
mounted     # 挂载设备，并将配置写入/etc/fstab
unmounted   # 卸载设备，不会清除/etc/fstab写入的配置
absent      # 卸载设备，会清理/etc/fstab写入的配置

```

## Ansible防火墙模块
| selinux |
| --- |

```bash
#修改配置文件关闭selinux，必须重启
[root@m01 ~]# ansible web_group -m selinux -a 'state=disabled' -i ./hosts
 [WARNING]: SELinux state temporarily changed from 'enforcing' to 'permissive'. State change will take effect next reboot.
web01 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": true,
    "configfile": "/etc/selinux/config",
    "msg": "Config SELinux state changed from 'enforcing' to 'disabled'",
    "policy": "targeted",
    "reboot_required": true,
    "state": "disabled"
}
web02 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": true,
    "configfile": "/etc/selinux/config",
    "msg": "Config SELinux state changed from 'enforcing' to 'disabled'",
    "policy": "targeted",
    "reboot_required": true,
    "state": "disabled"
}
#临时关闭
[root@m01 ~]# ansible web_group -m shell -a 'setenforce 0' -i ./hosts
web02 | CHANGED | rc=0 >>
web01 | CHANGED | rc=0 >>
[root@m01 ~]# ansible web_group -m shell -a 'getenforce' -i ./hosts
web02 | CHANGED | rc=0 >>
Permissive
web01 | CHANGED | rc=0 >>
Permissive
```

---

| firewalld |
| --- |

```bash
[root@m01 ~]# ansible web_group -m firewalld -a 'service=http permanent=yes state=enabled' -i ./hosts
[root@m01 ~]# ansible web_group -m firewalld -a "service=http immediate=yes permanent=yes state=enabled" -i ./hosts
[root@m01 ~]# ansible web_group -m firewalld -a "port=8080-8090/tcp immediate=yes permanent=yes state=enabled" -i ./hosts
service                 #指定开放或关闭的服务名称
port                    #指定开放或关闭的端口
permanent               #是否添加永久生效
state                   #开启或者关闭
    enabled
    disabled
zone                    #指定配置某个区域
rich_rule               #配置辅规则
masquerade              #开启地址伪装
immediate               #临时生效
source                  #指定来源IP
```

## Ansible主机信息模块
为什么要讲这个模块？

做过自动化的小伙伴会觉得这个模块非常实用

在公司中总会有一些需求

比如：

1.根据不同主机不同IP创建对应IP的目录

2.根据不同主机不同主机名创建对应主机名的目录

3.自动化运维平台需要自动获取到主机的IP地址，内存信息，磁盘信息，主机名...等

4.如果安装数据库，分配内存为物理内存的80%，此时有3台不同物理内存的机器2G、4G、16G

写一个playbook的情况下，我需要获取到对应主机的内存并作出计算，写判断。

---

| setup |
| --- |

_**1.查看所有详细信息**_

```bash
[root@m01 ~]# ansible web01 -m setup
web01 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "10.0.0.7"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::20c:29ff:fef8:9880"
        ],
        "ansible_apparmor": {
            "status": "disabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "04/13/2018",
        "ansible_bios_version": "6.00",
        "ansible_cmdline": {
            "BOOT_IMAGE": "/vmlinuz-3.10.0-862.el7.x86_64",
            "LANG": "en_US.UTF-8",
            "biosdevname": "0",
            "net.ifnames": "0",
            "quiet": true,
            "rhgb": true,
            "ro": true,
            "root": "UUID=7348b9b1-f2a7-46c6-bede-4f22224dc168"
        },
        "ansible_date_time": {
            "date": "2019-09-10",
            "day": "10",
            "epoch": "1568115243",
            "hour": "19",
            "iso8601": "2019-09-10T11:34:03Z",
            "iso8601_basic": "20190910T193403218395",
            "iso8601_basic_short": "20190910T193403",
            "iso8601_micro": "2019-09-10T11:34:03.218468Z",
            "minute": "34",
            "month": "09",
            "second": "03",
            "time": "19:34:03",
            "tz": "CST",
            "tz_offset": "+0800",
            "weekday": "星期二",
            "weekday_number": "2",
            "weeknumber": "36",
            "year": "2019"
        },
        "ansible_default_ipv4": {
            "address": "10.0.0.7",
            "alias": "eth0",
            "broadcast": "10.0.0.255",
            "gateway": "10.0.0.2",
            "interface": "eth0",
            "macaddress": "00:0c:29:f8:98:80",
            "mtu": 1500,
            "netmask": "255.255.255.0",
            "network": "10.0.0.0",
            "type": "ether"
        },
        "ansible_default_ipv6": {},
        "ansible_device_links": {
            "ids": {
                "sr0": [
                    "ata-VMware_Virtual_IDE_CDROM_Drive_00000000000000000001"
                ],
                "sr1": [
                    "ata-VMware_Virtual_IDE_CDROM_Drive_10000000000000000001"
                ]
            },
            "labels": {},
            "masters": {},
            "uuids": {
                "sda1": [
                    "8e547355-994a-4bad-a941-da93f4f1cdfd"
                ],
                "sda2": [
                    "9e4d046c-02cf-47bd-a4bf-1e8b5fa4bed5"
                ],
                "sda3": [
                    "7348b9b1-f2a7-46c6-bede-4f22224dc168"
                ]
            }
        },
        "ansible_devices": {
            "sda": {
                "holders": [],
                "host": "SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 01)",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "VMware Virtual S",
                "partitions": {
                    "sda1": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "8e547355-994a-4bad-a941-da93f4f1cdfd"
                            ]
                        },
                        "sectors": "2097152",
                        "sectorsize": 512,
                        "size": "1.00 GB",
                        "start": "2048",
                        "uuid": "8e547355-994a-4bad-a941-da93f4f1cdfd"
                    },
                    "sda2": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "9e4d046c-02cf-47bd-a4bf-1e8b5fa4bed5"
                            ]
                        },
                        "sectors": "2097152",
                        "sectorsize": 512,
                        "size": "1.00 GB",
                        "start": "2099200",
                        "uuid": "9e4d046c-02cf-47bd-a4bf-1e8b5fa4bed5"
                    },
                    "sda3": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "7348b9b1-f2a7-46c6-bede-4f22224dc168"
                            ]
                        },
                        "sectors": "37746688",
                        "sectorsize": 512,
                        "size": "18.00 GB",
                        "start": "4196352",
                        "uuid": "7348b9b1-f2a7-46c6-bede-4f22224dc168"
                    }
                },
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "deadline",
                "sectors": "41943040",
                "sectorsize": "512",
                "size": "20.00 GB",
                "support_discard": "0",
                "vendor": "VMware,",
                "virtual": 1
            },
            "sr0": {
                "holders": [],
                "host": "IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)",
                "links": {
                    "ids": [
                        "ata-VMware_Virtual_IDE_CDROM_Drive_00000000000000000001"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "VMware IDE CDR00",
                "partitions": {},
                "removable": "1",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "deadline",
                "sectors": "2097151",
                "sectorsize": "512",
                "size": "1024.00 MB",
                "support_discard": "0",
                "vendor": "NECVMWar",
                "virtual": 1
            },
            "sr1": {
                "holders": [],
                "host": "IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)",
                "links": {
                    "ids": [
                        "ata-VMware_Virtual_IDE_CDROM_Drive_10000000000000000001"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "VMware IDE CDR10",
                "partitions": {},
                "removable": "1",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "deadline",
                "sectors": "2097151",
                "sectorsize": "512",
                "size": "1024.00 MB",
                "support_discard": "0",
                "vendor": "NECVMWar",
                "virtual": 1
            }
        },
        "ansible_distribution": "CentOS",
        "ansible_distribution_file_parsed": true,
        "ansible_distribution_file_path": "/etc/redhat-release",
        "ansible_distribution_file_variety": "RedHat",
        "ansible_distribution_major_version": "7",
        "ansible_distribution_release": "Core",
        "ansible_distribution_version": "7.5",
        "ansible_dns": {
            "nameservers": [
                "10.0.0.2"
            ]
        },
        "ansible_domain": "",
        "ansible_effective_group_id": 0,
        "ansible_effective_user_id": 0,
        "ansible_env": {
            "HOME": "/root",
            "LANG": "zh_CN.UTF-8",
            "LESSOPEN": "||/usr/bin/lesspipe.sh %s",
            "LOGNAME": "root",
            "LS_COLORS": "rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:",
            "MAIL": "/var/mail/root",
            "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin",
            "PWD": "/root",
            "SELINUX_LEVEL_REQUESTED": "",
            "SELINUX_ROLE_REQUESTED": "",
            "SELINUX_USE_CURRENT_RANGE": "",
            "SHELL": "/bin/bash",
            "SHLVL": "2",
            "SSH_CLIENT": "10.0.0.51 53512 22",
            "SSH_CONNECTION": "10.0.0.51 53512 10.0.0.7 22",
            "SSH_TTY": "/dev/pts/1",
            "TERM": "xterm-256color",
            "USER": "root",
            "XDG_RUNTIME_DIR": "/run/user/0",
            "XDG_SESSION_ID": "87",
            "_": "/usr/bin/python"
        },
        "ansible_eth0": {
            "active": true,
            "device": "eth0",
            "features": {
                "busy_poll": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off",
                "rx_checksumming": "off",
                "rx_fcs": "off",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "on [fixed]",
                "rx_vlan_offload": "on",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipip_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_sit_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "off [fixed]",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "on [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off [fixed]",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "10.0.0.7",
                "broadcast": "10.0.0.255",
                "netmask": "255.255.255.0",
                "network": "10.0.0.0"
            },
            "ipv6": [
                {
                    "address": "fe80::20c:29ff:fef8:9880",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "00:0c:29:f8:98:80",
            "module": "e1000",
            "mtu": 1500,
            "pciid": "0000:02:01.0",
            "promisc": false,
            "speed": 1000,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "ansible_fibre_channel_wwn": [],
        "ansible_fips": false,
        "ansible_form_factor": "Other",
        "ansible_fqdn": "web01",
        "ansible_hostname": "web01",
        "ansible_hostnqn": "",
        "ansible_interfaces": [
            "lo",
            "eth0"
        ],
        "ansible_is_chroot": false,
        "ansible_iscsi_iqn": "",
        "ansible_kernel": "3.10.0-862.el7.x86_64",
        "ansible_lo": {
            "active": true,
            "device": "lo",
            "features": {
                "busy_poll": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "on [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "on [fixed]",
                "netns_local": "on [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on [fixed]",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "on [fixed]",
                "tx_checksumming": "on",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipip_segmentation": "off [fixed]",
                "tx_lockless": "on [fixed]",
                "tx_nocache_copy": "off [fixed]",
                "tx_scatter_gather": "on [fixed]",
                "tx_scatter_gather_fraglist": "on [fixed]",
                "tx_sctp_segmentation": "on",
                "tx_sit_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "on",
                "tx_tcp_mangleid_segmentation": "on",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "on",
                "vlan_challenged": "on [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "127.0.0.1",
                "broadcast": "host",
                "netmask": "255.0.0.0",
                "network": "127.0.0.0"
            },
            "ipv6": [
                {
                    "address": "::1",
                    "prefix": "128",
                    "scope": "host"
                }
            ],
            "mtu": 65536,
            "promisc": false,
            "timestamping": [
                "rx_software",
                "software"
            ],
            "type": "loopback"
        },
        "ansible_local": {},
        "ansible_lsb": {},
        "ansible_machine": "x86_64",
        "ansible_machine_id": "c9d400bd3c1249bd81b2d49252985ab6",
        "ansible_memfree_mb": 1068,
        "ansible_memory_mb": {
            "nocache": {
                "free": 1622,
                "used": 360
            },
            "real": {
                "free": 1068,
                "total": 1982,
                "used": 914
            },
            "swap": {
                "cached": 0,
                "free": 1023,
                "total": 1023,
                "used": 0
            }
        },
        "ansible_memtotal_mb": 1982,
        "ansible_mounts": [
            {
                "block_available": 227935,
                "block_size": 4096,
                "block_total": 259584,
                "block_used": 31649,
                "device": "/dev/sda1",
                "fstype": "xfs",
                "inode_available": 523962,
                "inode_total": 524288,
                "inode_used": 326,
                "mount": "/boot",
                "options": "rw,seclabel,relatime,attr2,inode64,noquota",
                "size_available": 933621760,
                "size_total": 1063256064,
                "uuid": "8e547355-994a-4bad-a941-da93f4f1cdfd"
            },
            {
                "block_available": 69275,
                "block_size": 262144,
                "block_total": 73684,
                "block_used": 4409,
                "device": "10.0.0.31:/data",
                "fstype": "nfs4",
                "inode_available": 9409536,
                "inode_total": 9436672,
                "inode_used": 27136,
                "mount": "/opt",
                "options": "rw,relatime,vers=4.1,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=10.0.0.7,local_lock=none,addr=10.0.0.31",
                "size_available": 18160025600,
                "size_total": 19315818496,
                "uuid": "N/A"
            },
            {
                "block_available": 4354375,
                "block_size": 4096,
                "block_total": 4715776,
                "block_used": 361401,
                "device": "/dev/sda3",
                "fstype": "xfs",
                "inode_available": 9403419,
                "inode_total": 9436672,
                "inode_used": 33253,
                "mount": "/",
                "options": "rw,seclabel,relatime,attr2,inode64,noquota",
                "size_available": 17835520000,
                "size_total": 19315818496,
                "uuid": "7348b9b1-f2a7-46c6-bede-4f22224dc168"
            }
        ],
        "ansible_nodename": "web01",
        "ansible_os_family": "RedHat",
        "ansible_pkg_mgr": "yum",
        "ansible_proc_cmdline": {
            "BOOT_IMAGE": "/vmlinuz-3.10.0-862.el7.x86_64",
            "LANG": "en_US.UTF-8",
            "biosdevname": "0",
            "net.ifnames": "0",
            "quiet": true,
            "rhgb": true,
            "ro": true,
            "root": "UUID=7348b9b1-f2a7-46c6-bede-4f22224dc168"
        },
        "ansible_processor": [
            "0",
            "GenuineIntel",
            "Intel(R) Core(TM) i7-8850H CPU @ 2.60GHz"
        ],
        "ansible_processor_cores": 1,
        "ansible_processor_count": 1,
        "ansible_processor_threads_per_core": 1,
        "ansible_processor_vcpus": 1,
        "ansible_product_name": "VMware Virtual Platform",
        "ansible_product_serial": "VMware-56 4d a5 a2 9d f3 51 25-4d 67 a8 58 f8 f8 98 80",
        "ansible_product_uuid": "A2A54D56-F39D-2551-4D67-A858F8F89880",
        "ansible_product_version": "None",
        "ansible_python": {
            "executable": "/usr/bin/python",
            "has_sslcontext": true,
            "type": "CPython",
            "version": {
                "major": 2,
                "micro": 5,
                "minor": 7,
                "releaselevel": "final",
                "serial": 0
            },
            "version_info": [
                2,
                7,
                5,
                "final",
                0
            ]
        },
        "ansible_python_version": "2.7.5",
        "ansible_real_group_id": 0,
        "ansible_real_user_id": 0,
        "ansible_selinux": {
            "config_mode": "disabled",
            "mode": "permissive",
            "policyvers": 31,
            "status": "enabled",
            "type": "targeted"
        },
        "ansible_selinux_python_present": true,
        "ansible_service_mgr": "systemd",
        "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAiDBJtsjcCuaEVqC4e2tPeN3X7FbSfbWq4gDx65v5AX8yPzZcufMmv0yydrCvbkb3HhMGqVJ7oNMioQdyqiu8Q=",
        "ansible_ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAIBVg0/vQDn4AFzoNyeGcB61Jr3a+Cv3hu36XOW+BAgv+",
        "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQC4PhQf/9RtL4kuFejVDjQoT8ng10Wdf5SA884Nu9l5wfrBLTVpKUusox5g4lU9+cuYicZiEYmasvxQbACsI90OybLUs26eUymRMtYQiS+N9Mfz0I+CLSssIEtUd5nplNoaPLM7dvgej1YxzLoz8mF6XkwhTLCd3nnye/YxuYYecGNZRCi2q6mkMYjO0HuHtqeSyoK+gPB2so7p7QrC3kcYbgblKfztDDUJ11tmYTBQJdDm7+ICztFjiwyWsnOvbItpOyI2M6neDkN8KCqoDwDYKCbXSbs6uamWkInlz03G9LGuIf+B/rhG6pmFVxG3Ac9h1tS5b6H2DJRMxQR+Vf5/",
        "ansible_swapfree_mb": 1023,
        "ansible_swaptotal_mb": 1023,
        "ansible_system": "Linux",
        "ansible_system_capabilities": [
            "cap_chown",
            "cap_dac_override",
            "cap_dac_read_search",
            "cap_fowner",
            "cap_fsetid",
            "cap_kill",
            "cap_setgid",
            "cap_setuid",
            "cap_setpcap",
            "cap_linux_immutable",
            "cap_net_bind_service",
            "cap_net_broadcast",
            "cap_net_admin",
            "cap_net_raw",
            "cap_ipc_lock",
            "cap_ipc_owner",
            "cap_sys_module",
            "cap_sys_rawio",
            "cap_sys_chroot",
            "cap_sys_ptrace",
            "cap_sys_pacct",
            "cap_sys_admin",
            "cap_sys_boot",
            "cap_sys_nice",
            "cap_sys_resource",
            "cap_sys_time",
            "cap_sys_tty_config",
            "cap_mknod",
            "cap_lease",
            "cap_audit_write",
            "cap_audit_control",
            "cap_setfcap",
            "cap_mac_override",
            "cap_mac_admin",
            "cap_syslog",
            "35",
            "36+ep"
        ],
        "ansible_system_capabilities_enforced": "True",
        "ansible_system_vendor": "VMware, Inc.",
        "ansible_uptime_seconds": 96743,
        "ansible_user_dir": "/root",
        "ansible_user_gecos": "root",
        "ansible_user_gid": 0,
        "ansible_user_id": "root",
        "ansible_user_shell": "/bin/bash",
        "ansible_user_uid": 0,
        "ansible_userspace_architecture": "x86_64",
        "ansible_userspace_bits": "64",
        "ansible_virtualization_role": "guest",
        "ansible_virtualization_type": "VMware",
        "discovered_interpreter_python": "/usr/bin/python",
        "gather_subset": [
            "all"
        ],
        "module_setup": true
    },
    "changed": false
}
```

_**2.获取IP地址**_

```bash
[root@m01 ~]# ansible web01 -m setup -a 'filter=ansible_default_ipv4'
web01 | SUCCESS => {
    "ansible_facts": {
        "ansible_default_ipv4": {
            "address": "10.0.0.7",
            "alias": "eth0",
            "broadcast": "10.0.0.255",
            "gateway": "10.0.0.2",
            "interface": "eth0",
            "macaddress": "00:0c:29:f8:98:80",
            "mtu": 1500,
            "netmask": "255.255.255.0",
            "network": "10.0.0.0",
            "type": "ether"
        },
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false
}
```

_**3.获取主机名**_

```bash
[root@m01 ~]# ansible web01 -m setup -a 'filter=ansible_fqdn'
web01 | SUCCESS => {
    "ansible_facts": {
        "ansible_fqdn": "web01",
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false
}
```

_**4.获取内存信息**_

```bash
[root@m01 ~]# ansible web01 -m setup -a 'filter=ansible_memory_mb'
web01 | SUCCESS => {
    "ansible_facts": {
        "ansible_memory_mb": {
            "nocache": {
                "free": 1622,
                "used": 360
            },
            "real": {
                "free": 1068,
                "total": 1982,
                "used": 914
            },
            "swap": {
                "cached": 0,
                "free": 1023,
                "total": 1023,
                "used": 0
            }
        },
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false
}
```

_**5.获取磁盘信息**_

```bash
web01 | SUCCESS => {
    "ansible_facts": {
        "ansible_memory_mb": {
            "nocache": {
                "free": 1622,
                "used": 360
            },
            "real": {
                "free": 1068,
                "total": 1982,
                "used": 914
            },
            "swap": {
                "cached": 0,
                "free": 1023,
                "total": 1023,
                "used": 0
            }
        },
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false
}
[root@m01 ~]# ansible web01 -m setup -a 'filter=ansible_devices'
web01 | SUCCESS => {
    "ansible_facts": {
        "ansible_devices": {
            "sda": {
                "holders": [],
                "host": "SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 01)",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "VMware Virtual S",
                "partitions": {
                    "sda1": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "8e547355-994a-4bad-a941-da93f4f1cdfd"
                            ]
                        },
                        "sectors": "2097152",
                        "sectorsize": 512,
                        "size": "1.00 GB",
                        "start": "2048",
                        "uuid": "8e547355-994a-4bad-a941-da93f4f1cdfd"
                    },
                    "sda2": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "9e4d046c-02cf-47bd-a4bf-1e8b5fa4bed5"
                            ]
                        },
                        "sectors": "2097152",
                        "sectorsize": 512,
                        "size": "1.00 GB",
                        "start": "2099200",
                        "uuid": "9e4d046c-02cf-47bd-a4bf-1e8b5fa4bed5"
                    },
                    "sda3": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "7348b9b1-f2a7-46c6-bede-4f22224dc168"
                            ]
                        },
                        "sectors": "37746688",
                        "sectorsize": 512,
                        "size": "18.00 GB",
                        "start": "4196352",
                        "uuid": "7348b9b1-f2a7-46c6-bede-4f22224dc168"
                    }
                },
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "deadline",
                "sectors": "41943040",
                "sectorsize": "512",
                "size": "20.00 GB",
                "support_discard": "0",
                "vendor": "VMware,",
                "virtual": 1
            },
            "sr0": {
                "holders": [],
                "host": "IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)",
                "links": {
                    "ids": [
                        "ata-VMware_Virtual_IDE_CDROM_Drive_00000000000000000001"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "VMware IDE CDR00",
                "partitions": {},
                "removable": "1",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "deadline",
                "sectors": "2097151",
                "sectorsize": "512",
                "size": "1024.00 MB",
                "support_discard": "0",
                "vendor": "NECVMWar",
                "virtual": 1
            },
            "sr1": {
                "holders": [],
                "host": "IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)",
                "links": {
                    "ids": [
                        "ata-VMware_Virtual_IDE_CDROM_Drive_10000000000000000001"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "VMware IDE CDR10",
                "partitions": {},
                "removable": "1",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "deadline",
                "sectors": "2097151",
                "sectorsize": "512",
                "size": "1024.00 MB",
                "support_discard": "0",
                "vendor": "NECVMWar",
                "virtual": 1
            }
        },
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false
}
```

_**6.其他信息参数**_

```bash
ansible_all_ipv4_addresses：仅显示ipv4的信息。
ansible_devices：仅显示磁盘设备信息。
ansible_distribution：显示是什么系统，例：centos,suse等。
ansible_distribution_major_version：显示是系统主版本。
ansible_distribution_version：仅显示系统版本。
ansible_machine：显示系统类型，例：32位，还是64位。
ansible_eth0：仅显示eth0的信息。
ansible_hostname：仅显示主机名。
ansible_kernel：仅显示内核版本。
ansible_lvm：显示lvm相关信息。
ansible_memtotal_mb：显示系统总内存。
ansible_memfree_mb：显示可用系统内存。
ansible_memory_mb：详细显示内存情况。
ansible_swaptotal_mb：显示总的swap内存。
ansible_swapfree_mb：显示swap内存的可用内存。
ansible_mounts：显示系统磁盘挂载情况。
ansible_processor：显示cpu个数(具体显示每个cpu的型号)。
ansible_processor_vcpus：显示cpu个数(只显示总的个数)。
```

此处匹配规则 支持通配符，后面我们在使用playbook的时候，会针对这些内置变量参考使用。

> 更新: 2024-09-24 16:33:48  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/cg4ucv>