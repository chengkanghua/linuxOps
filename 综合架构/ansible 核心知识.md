# Ansible基本概述
## <font style="color:#333333;">ansible软件介绍</font>
 Ansible 是**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">开源自动化运维工具</font>**，用来**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">批量管理多台服务器</font>**，实现批量执行命令、配置部署、环境初始化、项目发布。  



## <font style="color:#333333;">ansible软件特点</font>
+ **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无客户端</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：被控机器</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">不用装任何代理程序</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，只需要开启 SSH 就行</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">基于 </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">SSH</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 通信，加密安全</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">配置用 </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">YAML</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 编写，简单易懂</font>
+ **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">幂等性</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：重复执行剧本，不会重复改动，保证环境一致</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">轻量化、部署简单、无需数据库</font>



## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心架构</font>
+ **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">控制节点</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：安装 Ansible 的机器，统一发号施令</font>
+ **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">被控节点</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：所有被管理的服务器，只需开启 SSH</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">四大核心组件</font>
1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Inventory 主机清单</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：记录所有要管理的服务器 IP、分组</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Module 模块</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：内置现成功能（执行命令、装软件、改配置、创建用户）</font>
3. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Ad-hoc</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：临时批量执行单条命令，不用写脚本</font>
4. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Playbook 剧本</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：YAML 编写，多步骤复杂自动化任务，可重复执行</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">工作原理</font>
<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">控制节点通过 </font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">SSH 免密</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 登录所有被控机器，调用内置模块，下发任务远程执行，</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">不装客户端、无后台进程</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">。</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">两种使用方式</font>
1. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Ad-hoc</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：临时一次性批量操作（批量关机、批量查磁盘）</font>
2. **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Playbook</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">：写剧本，做标准化部署（初始化环境、部署网站、安装依赖）</font>

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">应用场景</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">批量初始化新服务器</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">批量安装 / 卸载软件</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">批量修改配置、推送文件</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">自动化项目发布、回滚</font>
+ <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">统一运维标准，避免人工操作出错</font>



<font style="color:#6F6F6F;">Ansible</font>

<font style="color:#6F6F6F;">1.购买机器->2.配置环境->3.部署代码->4测试->5.加入集群</font>

## <font style="color:#6F6F6F;">Ansible/Saltstack(master->minion) 区别</font>
**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Ansible = 简单、轻量、无客户端，适合中小规模</font>**

**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">SaltStack = 高速、强大、有客户端，适合大规模</font>**

 核心差异对比表（一眼看懂）  

| 对比维度 | Ansible | SaltStack |
| --- | --- | --- |
| **架构模式** | 无客户端（Agentless），纯 SSH | 主从架构（Master-Minion），有客户端 |
| **通信方式** | SSH 协议，每次执行都新建连接 | ZeroMQ 消息队列，长连接 |
| **执行速度** | 慢（SSH 握手开销大） | 极快（长连接 + 异步通信） |
| **学习曲线** | 平缓，1 周就能上手干活 | 陡峭，需要 2-3 周才能熟练 |
| **部署难度** | 极低，控制机装 Ansible 就行 | 中等，需要在所有被控机装 Minion |
| **最大管理规模** | 1000 台以内（超过会有明显延迟） | 10 万台以上（官方测试数据） |
| **实时性** | 差，只能主动推送 | 极好，支持事件驱动、实时响应 |
| **配置语言** | 纯 YAML，简单易懂 | SLS（YAML+Jinja2），支持 Python 扩展 |




其他文档

[http://ansible.com.cn/docs/playbooks_intro.html](http://ansible.com.cn/docs/playbooks_intro.html)

[https://ansible.leops.cn/basic/Introduction/](https://ansible.leops.cn/basic/Introduction/)

# Ansible 安装配置
```bash

# 生成ED25519密钥对（推荐，生产标准）
ssh-keygen -t ed25519 -C "运维-张三-生产环境-20260503"
# 若需要兼容老旧系统（不支持ED25519），用RSA 4096
# ssh-keygen -t rsa -b 4096 -C "运维-张三-生产环境-20260503"


#0.ansible借助公钥批量管理
ssh-keygen -t rsa -b 4096 -C chengkanghua@foxmail.com

#利用非交换式工具实现批量分发公钥与批量管理服务器
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.41
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.21
#1.安装ansible
yum install ansible -y

#检查ansible版本
# ansible --version
ansible 2.6.1
2.配置ansible
# vim /etc/ansible/hosts
[oldboy]
172.16.1.31
172.16.1.41
#3.验证ansible
# ansible是通过ssh端口探测通信
ansible oldboy -m ping


```



<font style="color:#333333;">4 .ansible命令语法格式</font>

```bash
#格式说明
ansible oldboy -m command -a "hostname"
命令 主机组 指定模块参数 模块名称 模块参数  "具体命令动作"


#批量执行命令
ansible oldboy -m command -a "df -h"
```



# Ansible 清单管理
<font style="color:#333333;">inventory文件通常用于定义要管理主机的认证信息，</font>

<font style="color:#333333;">例如ssh登录用户名、密码以及key相关信息。如何配置Inventory文件</font>

**<font style="color:#333333;">主机</font>**

<font style="color:#6F6F6F;">1.支持主机名通配以及正则表达式，例如test[1:4].cominggo.com </font>

<font style="color:#6F6F6F;">2.支持基于非标准的ssh端口，例如test5.cominggo.com:5566 </font>

<font style="color:#6F6F6F;">3.支持指定变量，可对个别主机的特殊配置，如登陆用户、端口、私钥等 </font>

<font style="color:#6F6F6F;">4.支持设置别名，如test2 ansible_ssh_host=10.4.2.123</font>

<font style="color:#6F6F6F;"></font>

**<font style="color:#333333;">主机组</font>**

<font style="color:#6F6F6F;">1.支持嵌套组，例如[game:children]在下面的组即为game组所包含 </font>

<font style="color:#6F6F6F;">2.支持指定变量，例如[game:vars]在下面指定变量</font>



```bash
# cat /etc/ansible/hosts
[webservers]
10.0.0.8
10.0.0.31
10.0.0.41
10.0.0.61

# 添加三台主机至webserver[low版]
[webservers]
web1.oldboy.com
web2.oldboy.com
web3.oldboy.com

# 添加三台主机至webserver[low改良版]
[webservers]
web[1:3].oldboy.com


# 添加三台主机至webserver[密码版]
[webservers]
web1.oldboy.com ansible_ssh_pass='123456'
web2.oldboy.com ansible_ssh_pass='123456'
web3.oldboy.com ansible_ssh_pass='123456'

# 添加三台主机至webserver[密码改良版]
[webservers]
web[1:3].oldboy.com ansible_ssh_pass='123456'

# 添加三台主机至webserver[密码拆分版]
[webservers]
web1.oldboy.com
web2.oldboy.com
web3.oldboy.com
[webservers:vars]
ansible_ssh_pass='123456'


# 定义多组，多组汇总整合
[apache]
web1.oldboy.com
web2.oldboy.com
web3.oldboy.com
[apache:vars]
ansible_ssh_pass='123456'

[nginx]
10.0.0.7
10.0.0.31
10.0.0.41
10.0.0.61
[nginx:vars]
ansible_ssh_pass='123456'

# webservers组包括两个子组[apapche,nginx]
[webservers:children]
apache
nginx

ansible nginx --list-hosts
ansible apache --list-hosts
ansible websers --list-hosts

# ansible oldboy --list-hosts
 hosts (3):
   172.16.1.31
   172.16.1.41
   172.16.1.7
# ansible backup --list-hosts
 hosts (1):
   172.16.1.41
```



**<font style="color:#333333;">Ansible内置变量</font>**

| 参数 | 用途 | 例子 |
| --- | --- | --- |
| ansible_ssh_host | 定义 hosts ssh 地址 | ansible_ssh_host=192.169.1.100 |
| ansible_ssh_port | 定义 hosts ssh 端口 | ansible_ssh_port=3000 |
| ansible_ssh_user | 定义 hosts ssh 认证用户 | ansible_ssh_user=user |
| ansible_ssh_pass | 定义 hosts ssh 认证密码 | ansible_ssh_pass=pass |
| ansible_sudo | 定义 hosts sudo 用户 | ansible_sudo=www |
| ansible_sudo_pass | 定义 hosts sudo 密码 | ansible_sudo_pass=pass |
| ansible_sudo_exe | 定义 hosts sudo 路径 | ansible_sudo_exe=/usr/bin/sudo |
| ansible_connection | 定义 hosts 连接方式 | ansible_connection=local |
| ansible_ssh_private_key_file | 定义 hosts 私钥 | ansible_ssh_private_key_file=/root/key |
| ansible_ssh_shell_type | 定义 hosts shell 类型 | ansible_ssh_shell_type=bash |
| ansible_python_interpreter | 定义 hosts 任务执行 python 路径 | ansible_python_interpreter=/usr/bin/python2.6 |
| ansible_*_interpreter | 定义 hosts 其他语言解析路径 | ansible_*_interpreter=/usr/bin/ruby |




# Ansible 常用模块
### <font style="color:rgb(51, 51, 51);">Ad-hoc 临时命令</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：不用写脚本，一行命令批量执行操作。</font>

**<font style="color:rgb(51, 51, 51);">为什么重要</font>**<font style="color:rgb(51, 51, 51);">：运维日常 90% 的临时批量操作都用它，比如批量查磁盘、批量装软件、批量改密码。</font>

**<font style="color:rgb(51, 51, 51);">基本格式</font>**<font style="color:rgb(51, 51, 51);">：</font>

ansible <主机组/主机> -m <模块名> -a "<模块参数>"

<font style="color:rgb(51, 51, 51);"></font>

<font style="color:#333333;">Ansible注意事项->提示颜色信息说明</font>

<font style="color:#0D0D0D;">翔黄色：对远程节点进行相应修改 </font>

<font style="color:#0D0D0D;">帽子绿：对远程节点不进行相应修改，或者只是对远程节点信息进行查看 </font>

<font style="color:#0D0D0D;">深红色：操作执行命令有异常 </font>

<font style="color:#0D0D0D;">浅紫色：表示对命令执行发出警告信息（可能存在的问题，给你一下建议）</font>

<font style="color:#0D0D0D;"></font>

<font style="color:#0D0D0D;"></font>

**<font style="color:rgb(51, 51, 51);">常用模块</font>**<font style="color:rgb(51, 51, 51);">：</font>

| <font style="color:#0D0D0D;">模块名</font> | <font style="color:#0D0D0D;">核心作用</font> | <font style="color:#0D0D0D;">生产常用例子</font> |
| --- | --- | --- |
| **ping** | <font style="color:#0D0D0D;">测试主机连通性（最基础必用）</font> | `<font style="color:#0D0D0D;">ansible all -m ping</font>` |
| **command** | <font style="color:#0D0D0D;">执行简单远程命令（不支持管道 / 重定向）</font> | `<font style="color:#0D0D0D;">ansible web -m command -a "df -h"</font>`<br/><font style="color:#0D0D0D;"># 默认模块, 执行命令</font><br/><font style="color:#0D0D0D;">ansible web -a "hostname"</font> |
| **shell** | <font style="color:#0D0D0D;">执行复杂远程命令（支持管道 / 重定向 / 变量）</font> | <font style="color:#0D0D0D;">ansible web -m shell -a "free -h grep Mem"</font><br/><font style="color:#0D0D0D;"># 如果需要一些管道操作，则使用shell</font><br/><font style="color:#0D0D0D;">ansible web -m shell -a "ifconfig|grep eth0" -f 50</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">script</font>** | <font style="color:rgb(0, 0, 0);">把</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">本地脚本</font>**<font style="color:rgb(0, 0, 0);">传到远程服务器并执行</font> | `<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ansible web -m script -a "./deploy.sh"</font>` |
| **copy** | <font style="color:#0D0D0D;">把本地文件 / 目录复制到远程服务器</font> | `<font style="color:#0D0D0D;">ansible web -m copy -a "src=./nginx.conf dest=/etc/nginx/nginx.conf mode=644 owner=root"</font>` |
| **file** | <font style="color:#0D0D0D;">创建 / 删除文件 / 目录、修改权限 / 属主</font> | `<font style="color:#0D0D0D;">ansible web -m file -a "path=/data/logs state=directory mode=755 owner=nginx"</font>` |
| **service** | <font style="color:#0D0D0D;">管理系统服务（启动 / 停止 / 重启 / 开机自启）</font> | `<font style="color:#0D0D0D;">ansible web -m service -a "name=nginx state=restarted enabled=yes"</font>` |
| **yum** | <font style="color:#0D0D0D;">CentOS/RHEL 系统安装 / 卸载软件包</font> | `<font style="color:#0D0D0D;">ansible web -m yum -a "name=nginx state=present"</font>`<br/> |
| **apt** | <font style="color:#0D0D0D;">Ubuntu/Debian 系统安装 / 卸载软件包</font> | `<font style="color:#0D0D0D;">ansible web -m apt -a "name=nginx state=present update_cache=yes"</font>` |
| **template** | <font style="color:#0D0D0D;">渲染 Jinja2 模板并复制到远程（动态生成配置）</font> | `<font style="color:#0D0D0D;">ansible web -m template -a "src=./nginx.conf.j2 dest=/etc/nginx/conf.d/default.conf"</font>` |
| **authorized_key** | <font style="color:#0D0D0D;">批量分发 SSH 公钥（配置免密登录）</font> | `<font style="color:#0D0D0D;">ansible all -m authorized_key -a "user=root key='{{ lookup('file', '~/.ssh/id_ed25519.pub') }}'"</font>` |
| **fetch** | <font style="color:#0D0D0D;">从远程服务器拉取文件到本地（与 copy 相反）</font> | `<font style="color:#0D0D0D;">ansible web -m fetch -a "src=/var/log/nginx/access.log dest=./logs/ flat=yes"</font>` |
| **lineinfile** | <font style="color:#0D0D0D;">修改文件中的单行内容（增删改查）</font> | `<font style="color:#0D0D0D;">ansible all -m lineinfile -a "path=/etc/hosts line='192.168.1.100 web01'"</font>` |
| **user** | <font style="color:#0D0D0D;">管理系统用户（创建 / 删除 / 修改属性）</font> | `<font style="color:#0D0D0D;">ansible all -m user -a "name=ops state=present groups=wheel shell=/bin/bash"</font>` |
| **group** | <font style="color:#0D0D0D;">管理系统用户组</font> | `<font style="color:#0D0D0D;">ansible all -m group -a "name=dev state=present"</font>` |
| **cron** | <font style="color:#0D0D0D;">管理系统定时任务</font> | `<font style="color:#0D0D0D;">ansible web -m cron -a "name='清理日志' minute=0 hour=3 job='/usr/bin/rm -rf /data/logs/*.log'"</font>` |
| **setup** | <font style="color:#0D0D0D;">收集远程服务器系统信息（事实变量）</font> | `<font style="color:#0D0D0D;">ansible web -m setup -a "filter=ansible_default_ipv4"</font>` |
| **raw** | <font style="color:#0D0D0D;">执行原始命令（用于没有 Python 的老旧系统）</font> | `<font style="color:#0D0D0D;">ansible old_server -m raw -a "uptime"</font>` |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">mount</font>** | <font style="color:rgb(0, 0, 0);">管理磁盘挂载点（挂载 / 卸载 / 开机自启）</font> | `<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ansible db -m mount -a "path=/data src=/dev/sdb1 fstype=xfs state=mounted"</font>` |


<font style="color:#0D0D0D;"></font>



```bash
1.command命令模块
# 默认模块, 执行命令
ansible oldboy  -a "hostname"

# 如果需要一些管道操作，则使用shell
ansible oldboy -m shell -a "ifconfig|grep eth0" -f 50

# -f =forks   /etc/ansible/ansible.cfg #结果返回的数量

2.yum安装模块
#推送脚本文件至远程，远程执行脚本文件
ansible oldboy -m yum -a "name=httpd state=installed"
name    ---指定要安装的软件包名称
state   ---指定使用yum的方法
   installed，present   ---安装软件包
   removed，absent      ---移除软件包
   latest               ---安装最新软件包

3.copy模块
# 推送文件模块
ansible oldboy -m copy -a "src=/etc/hosts dest=/tmp/test.txt owner=www group=www mode=0600"

# 在推送覆盖远程端文件前，对远端已有文件进行备份，按照时间信息备份
ansible oldboy -m copy -a "src=/etc/hosts dest=/tmp/test.txt backup=yes"

# 直接向远端文件内写入数据信息，并且会覆盖远端文件内原有数据信息
ansible oldboy -m copy -a "content='bgx' dest=/tmp/oldboy"

src           --- 推送数据的源文件信息
dest          --- 推送数据的目标路径
backup        --- 对推送传输过去的文件，进行备份
content       --- 直接批量在被管理端文件中添加内容
group         --- 将本地文件推送到远端，指定文件属组信息
owner         --- 将本地文件推送到远端，指定文件属主信息
mode          --- 将本地文件推送到远端，指定文件权限信息
4.service服务模块
ansible oldboy -m service -a "name=crond state=stopped enabled=yes"
name        --- 定义要启动服务的名称
state       --- 指定服务状态是停止或是运行
   started     --- 启动
   stopped     --- 停止
   restarted   --- 重启
   reloaded    --- 重载
enabled     --- 是否让服务开启自启动


# scripts 模块
# 编写脚本
mkdir -p /server/scripts
cat > /server/scripts/yum.sh <<EOF
#!/usr/bin/bash
yum install -y iftop
EOF

#在本地运行模块，等同于在远程执行，不需要将脚本文件进行推送目标主机执行
ansible oldboy -m script -a "/server/scripts/yum.sh"

file配置模块
创建目录
ansible oldboy -m file -a "path=/tmp/oldboy state=directory"

创建文件
ansible oldboy -m file -a "path=/tmp/tt state=touch mode=555 owner=root group=root"

ansible oldboy -m file -a "src=/tmp/tt path=/tmp/tt_link state=link"
path        --- 指定远程主机目录或文件信息
recurse     --- 递归授权
state       ---
   directory   --- 在远端创建目录
   touch       --- 在远端创建文件
   link        --- link或hard表示创建链接文件
   absent      --- 表示删除文件或目录
   mode        --- 设置文件或目录权限
   owner       --- 设置文件或目录属主信息
   group       --- 设置文件或目录属组信息

group模块
name            --- 指定创建的组名
gid             --- 指定组的gid
state
   absent      --- 移除远端主机的组
   present     --- 创建远端主机的组（默认）


# 创建组，指定gid
ansible oldboy -m group -a "name=oldgirl gid=888"

user模块
uid             --- 指定用户的uid
group           --- 指定用户组名称
groups          --- 指定附加组名称
password        --- 给用户添加密码
shell           --- 指定用户登录shell
create_home     --- 是否创建家目录


创建oldgirl，设定uid为888，并加入gid为888
ansible oldboy -m user -a "name=oldgirl uid=888 group=888 shell=/sbin/nologin create_home=no"

随机生成加密字符串（-1使用MD5进行加密 -stdin 非交互式 -salt 加密参数）
echo "bgx" | openssl passwd -1 -stdin
固定加密字符串
echo "123"| openssl passwd -1 -stdin -salt 'salt'

创建普通用户，并配置对应的用户密码
# echo "bgx" | openssl passwd -1 -stdin
$1$1KmeCnsK$HGnBE86F/XkXufL.n6sEb.
ansible oldboy -m user -a 'name=xlw password="$1$765yDGau$diDKPRoCIPMU6KEVEaPTZ0"'

crond模块
# 正常使用crond服务
# crontab -l
* * * * *  /bin/sh /server/scripts/yum.sh

# 使用ansible添加一条定时任务
ansible oldboy -m cron -a "minute=* hour=* day=* month=* weekday=*  job='/bin/sh /server/scripts/test.sh'"
ansible oldboy -m cron -a "job='/bin/sh /server/scripts/test.sh'"

# 设置定时任务注释信息，防止重复，name设定
ansible oldboy -m cron -a "name='cron01' job='/bin/sh /server/scripts/test.sh'"

# 删除相应定时任务
ansible oldboy -m cron -a "name='ansible cron02' minute=0 hour=0 job='/bin/sh /server/scripts/test.sh' state=absent"
# 注释相应定时任务，使定时任务失效    
ansible oldboy -m cron -a "name='ansible cron01' minute=0 hour=0 job='/bin/sh /server/scripts/test.sh' disabled=yes"

mount模块
present     ---开机挂载，仅将挂载配置写入/etc/fstab
mounted     ---挂载设备，并将配置写入/etc/fstab
unmounted   ---卸载设备，不会清除/etc/fstab写入的配置
absent      ---卸载设备，会清理/etc/fstab写入的配置


仅将挂载的配置写入/etc/fstab，并不会执行挂载操作
ansible oldboy -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=present"

临时挂载设备，并将挂载信息写入/etc/fstab
ansible web -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=mounted"

临时卸载，不会清理/etc/fstab
ansible web -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=unmounted"

卸载，不仅临时卸载，同时会清理/etc/fstab
ansible web -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=absent"


翻译
children    孩子们
success    成功
changed    改变
pong			乒乓球
owner			所有者
content		内容
mode 		权限
recurse		递归
state			状态
```



# playbook概述
**是什么**：用 YAML 写的自动化脚本，把多个步骤组合起来，可重复执行。

**为什么重要**：复杂的自动化任务（比如部署网站、初始化服务器）必须用 Playbook。

**YAML 语法注意事项**（新手最容易错的地方）：

1. 用**空格缩进**，不能用 Tab
2. 冒号后面必须跟一个空格
3. 列表用`-`开头



<font style="color:#333333;">ansible查看帮助方法</font>

ansible-doc -l       # --- 查看所有模块说明信息

ansible-doc copy  # --- 表示指定查看某个模块参数用法信息

## 安装httpd 服务
```yaml
# tail -n3 /etc/ansible/hosts
[web]
10.0.0.4
10.0.0.3


cat > httpd_install.yaml<<EOF
#这是一个ansible 的playbook
- hosts: web
  tasks:
    - name: Install Httpd Server
      yum: name=httpd,httpd-tools state=installed
    # - name: Configgure Httpd Server
    - name: Start Httpd Server
      service: name=httpd state=started enabled=yes
EOF

#检查语法
ansible-playbook --syntax-check httpd_install.yaml

#测试-C 测试执行
ansible-playbook -C httpd_install.yaml

# 真正执行
ansible-playbook  httpd_install.yaml

# 准备配置文件
[root@m01 ~]#scp root@172.16.1.7:/etc/httpd/conf/httpd.conf ./
grep -vE '^(.*#.*)$' /etc/httpd/conf/httpd.conf > ./httpd.conf

cat >httpd_install.yaml<<EOF
- hosts: web
  tasks:
    - name: Install Httpd Server
      yum: name=httpd,httpd-tools state=installed

    - name: Configgure Httpd Server
      copy: src=./httpd.conf dest=/etc/httpd/conf/httpd.conf

    - name: Start Httpd Server
      service: name=httpd state=started enabled=yes
EOF

cat > httpd_install.yaml<<EOF
#这是一个ansible 的playbook
- hosts: web
  tasks:
    - name: Install Httpd Server
      yum: name=httpd,httpd-tools state=installed

    - name: Configgure Httpd Server
      copy: src=./httpd.conf dest=/etc/httpd/conf/httpd.conf
      # 配置文件修改后 执行 notify 后面的
      notify: Resart Httpd Server

    - name: Start Httpd Server
      service: name=httpd state=started enabled=yes

  handlers:
    - name: Resart Httpd Server
      service: name=httpd state=restarted	  
EOF
```

# 案例;
文件目录结构

```yaml

[root@m01 ansible_playbook]# tree /etc/ansible/ansible_playbook
/etc/ansible/ansible_playbook
├── base.yaml
├── conf
│   ├── confxml.xml
│   ├── exports
│   ├── resolv.conf
│   └── rsyncd.conf
├── file
│   └── sersync2.5.4_64bit_binary_stable_final.tar.gz
├── mail.yaml
├── nfs.yaml
├── rsync.retry
├── rsync.yaml
├── scripts
│   ├── rsync_backup_md5.sh
│   └── rsync_check_backup.sh
└── sersync.yaml
└── web.yaml

3 directories, 14 files
```



配置清单

```yaml
[root@m01 ~]# tail -n20 /etc/ansible/hosts
[backup]
10.0.0.6
[web01]
10.0.0.4
[web02]
10.0.0.3
[nfs]
10.0.0.2
[web]
10.0.0.4
10.0.0.3
----------------------------------------------------分割线
  
# mkdir /etc/ansible/ansible_playbook
# mkdir -p /etc/ansible/ansible_playbook/conf
# mkdir -p /etc/ansible/ansible_playbook/file
# mkdir -p /etc/ansible/ansible_playbook/scripts
mkdir -p /etc/ansible/ansible_playbook/{conf,file,scripts}



# mail.yaml
cat > /etc/ansible/ansible_playbook/mail.yaml<<EOF
- import_playbook: base.yaml
- import_playbook: rsync.yaml
- import_playbook: nfs.yaml
- import_playbook: sersync.yaml
- import_playbook: web.yaml
EOF

# base.yaml
cat > /etc/ansible/ansible_playbook/base.yaml<<EOF
- hosts: all
  tasks:
    - name: clear yum.repos.d
      shell: rm -f /etc/yum.repos.d/*
    - name: Install Base Repos
      get_url: url=http://mirrors.aliyun.com/repo/Centos-7.repo dest=/etc/yum.repos.d/CentOS-Base.repo
    - name: Install Epel Repos
      get_url: url=http://mirrors.aliyun.com/repo/Centos-7.repo dest=/etc/yum.repos.d/epel.repo
    - name: Dns Client
      copy: src=./conf/resolv.conf dest=/etc/rsolv.conf
    - name: Install Rsync Nfs-Utils
      yum: name=rsync,nfs-utils state=installed
    - name: Create Group WWW
      group: name=www gid=666
    - name: Create User WWW
      user: name=www uid=666 group=666 create_home=no shell=/sbin/nologin
    - name: Create Rsync_Client_Pass
      copy: content='1' dest=/etc/rsync.pass mode=600
    - name: Create Sripts Directory
      file: path=/server/scripts/ recurse=yes state=directory
    - name: Push Scripts
      copy: src=./scripts/rsync_backup_md5.sh dest=/server/scripts/
    - name: Crontable Scripts
      cron: name="backup scripts" hour=01 minute=00 job="/usr/bin/bash /server/scripts/rsync_backup_md5.sh &>/dev/null"
EOF

#rsync.yaml
cat > /etc/ansible/ansible_playbook/rsync.yaml<<EOF
- hosts: backup
  tasks:
    - name: Installed Rsync Server
      yum: name=rsync,mailx state=installed
    - name: configure Rsync Server
      copy: src=/etc/ansible/ansible_playbook/conf/rsyncd.conf dest=/etc/rsyncd.conf
      notify: Restart Rsync Server
    - name: Create Virt User
      copy: content='rsync_backup:1' dest=/etc/rsync.password mode=600
    - name: Create Date
      file: path=/data state=directory recurse=yes owner=www group=www mode=755
    - name: Create Backup
      file: path=/backup state=directory recurse=yes owner=www group=www mode=755
    - name: Start RsyncServer
      service: name=rsyncd state=started enabled=yes
    - name: Push Check Scripts
      copy: src=./scripts/rsync_check_backup.sh dest=/server/scripts/
    - name: Crond Check Scripts
      cron: name="check scripts" hour=05 minute=00 job="/usr/bin/bash /server/scripts/rsync_check_backup.sh &>/dev/null"
  handlers:
    - name: Restart Rsync Server
      service: name=rsyncd state=restarted
EOF

# nfs.yaml
cat > /etc/ansible/ansible_playbook/nfs.yaml<<EOF
- hosts: nfs
  tasks:
    - name: Installed Nfs Server
      yum: name=nfs-utils state=installed
    - name: Configure Nfs Server
      copy: src=./conf/exports dest=/etc/exports
      notify: Restart Nfs Server
    - name: Create Share Data
      file: path=/data state=directory recurse=yes owner=www group=www mode=755
    - name: Start Nfs Server
      service: name=nfs-server state=started enabled=yes
  handlers:
    - name: Restart Nfs Server
      service: name=nfs-server state=restarted
EOF

#sersync.yaml
cat > /etc/ansible/ansible_playbook/sersync.yaml<<EOF
- hosts: nfs
  tasks:
    - name: Scp Sersync
      copy: src=./file/sersync2.5.4_64bit_binary_stable_final.tar.gz dest=/usr/local/sersync.tar.gz
    - name: Zip
      shell: cd /usr/local && tar xf sersync.tar.gz && mv GNU-Linux-x86 sersync
      args:
        creates: /usr/local/sersync
    - name: configure Sersync
      copy: src=./conf/confxml.xml dest=/usr/local/sersync/confxml.xml
      notify: kill old sersync and restart new sersync
    - name: Start Sersync
      shell: pgrep sersync;
             [ $? -eq 0 ] || /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
  handlers:
    - name: kill old sersync and restart new sersync
      shell: pgrep sersync | xargs kill -9;
             /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
EOF

cat >sersync.yaml<<EOF
- hosts: nfs
  tasks:
    - name: Scp Sersync
      copy: src=./file/sersync2.5.4_64bit_binary_stable_final.tar.gz dest=/usr/local/sersync.tar.gz
    - name: Zip
      shell: cd /usr/local && tar xf sersync.tar.gz && mv GNU-Linux-x86 sersync
      args:
        creates: /usr/local/sersync
    - name: configure Sersync
      copy: src=./conf/confxml.xml dest=/usr/local/sersync/confxml.xml
    - name: Start Sersync
      shell: /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
EOF

#web.yaml
cat > /etc/ansible/ansible_playbook/web.yaml<<EOF
- hosts: web
  tasks:
    - name: Mount NFS Server Share Date
      mount: src=10.0.0.2:/data path=/data fstype=nfs opts=defaults state=mounted
    - name: Install Httpd Php
      yum: name=httpd,php state=installed
    - name: Configurl copy
      copy: src=./conf/httpd.conf dest=/etc/httpd/conf/httpd.conf
      notify: Restart Httpd
    - name: Unzip kaoshi.zip
      unarchive: src=./file/kaoshi.zip dest=/data/ creates=/data/index.html
    - name: Start Httpd
      service: name=httpd state=started enabled=yes
  handlers:
    - name: Restart Httpd
      service: name=httpd state=restarted
EOF

    
```



```bash
cat > /etc/ansible/ansible_playbook/scripts/rsync_backup_md5.sh<<EOF
#!/usr/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#1.定义变量
Host=$(hostname)
Addr=$(ifconfig eth1|awk 'NR==2{print $2}')
Date=$(date +%F)
Dest=${Host}_${Addr}_${Date}
Path=/backup

#2.创建备份目录
[ -d $Path/$Dest ] || mkdir -p $Path/$Dest

#3.备份对应的文件
cd / && \
[ -f $Path/$Dest/system.tar.gz ] || tar czf $Path/$Dest/system.tar.gz etc/fstab etc/rsyncd.conf && \
[ -f $Path/$Dest/log.tar.gz ] || tar czf $Path/$Dest/log.tar.gz  var/log/messages var/log/secure && \

#4.携带md5验证信息
[ -f $Path/$Dest/flag ] || md5sum $Path/$Dest/*.tar.gz >$Path/$Dest/flag_${Date}

#4.推送本地数据至备份服务器
export RSYNC_PASSWORD=1
rsync -avz $Path/ rsync_backup@10.0.0.7::backup

#5.本地保留最近7天的数据
find $Path/ -type d -mtime +7|xargs rm -rf
EOF

cat > /etc/ansible/ansible_playbook/scripts/rsync_check_backup.sh<<EOF
#!/usr/bin/bash
#1.定义全局的变量
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

#2.定义局部变量
Path=/backup
Date=$(date +%F)

#3.查看flag文件,并对该文件进行校验, 然后将校验的结果保存至result_时间
find $Path/*_${Date} -type f -name "flag$Date"|xargs md5sum -c >$Path/result_${Date}

#4.将校验的结果发送邮件给管理员 123@qq.com
mail -s "Rsync Backup $Date" 123@qq.com <$Path/result_${Date}

#5.删除超过7天的校验结果文件, 删除超过180天的备份数据文件
find $Path/ -type f -name "result*" -mtime +7|xargs rm -f
find $Path/ -type d -mtime +180|xargs rm -rf
EOF

# curl -o /etc/ansible/ansible_playbook/file/sersync2.5.4_64bit_binary_stable_final.tar.gz https://raw.githubusercontent.com/wsgzao/sersync/master/sersync2.5.4_64bit_binary_stable_final.tar.gz

curl -o /etc/ansible/ansible_playbook/file/sersync2.5.4_64bit_binary_stable_final.tar.gz https://gitee.com/zx19931031/sersync/raw/master/sersync2.5.4_64bit_binary_stable_final.tar.gz

cat > /etc/ansible/ansible_playbook/conf/confxml.xml<<EOF
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

EOF

cat > /etc/ansible/ansible_playbook/conf/exports <<EOF
/data 10.0.0.0/24(rw,sync,all_squash)
EOF

cat > /etc/ansible/ansible_playbook/conf/resolv.conf<<EOF
# Generated by NetworkManager
search localdomain
nameserver 223.5.5.5
EOF

cat > /etc/ansible/ansible_playbook/conf/rsyncd.conf<<EOF
uid = rsync
gid = rsync
port = 873
fake super = yes
use chroot = no
max connections = 200
timeout = 600
ignore errors
read only = false
list = false
auth users = rsync_backup
secrets file = /etc/rsync.password
log file = /var/log/rsyncd.log
#####################################
[backup]
comment = welcome to oldboyedu backup!
path = /backup
EOF
```



# <font style="color:rgb(51, 51, 51);">第二阶段：核心必学</font>
### <font style="color:rgb(51, 51, 51);">1. Playbook 进阶语法</font>
#### <font style="color:rgb(51, 51, 51);">（1）变量 Variables</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：把重复的值抽出来，方便修改和复用。</font>

**<font style="color:rgb(51, 51, 51);">变量必须记住的 3 条规则</font>**

1. **<font style="color:rgb(51, 51, 51);">变量名只能字母、数字、下划线</font>**
2. **<font style="color:rgb(51, 51, 51);">调用必须写 {{变量名}}</font>**
3. **<font style="color:rgb(51, 51, 51);">冒号后面必须有空格</font>**

**<font style="color:rgb(51, 51, 51);">面试必问（背下来）</font>**

<font style="color:rgb(51, 51, 51);">变量优先级（从高到低）</font>

<font style="color:rgb(51, 51, 51);">命令行 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">-e</font>`<font style="color:rgb(51, 51, 51);"> > 单独变量文件 > Playbook vars > Inventory 变量</font>

#### <font style="color:rgb(51, 51, 51);">2. 变量作用</font>
<font style="color:rgb(51, 51, 51);">方便统一修改、提高可读性、避免重复写死值。</font>

**<font style="color:rgb(51, 51, 51);">定义方式</font>**<font style="color:rgb(51, 51, 51);">：</font>

+ <font style="color:rgb(51, 51, 51);">在 Playbook 中定义：</font>

```plain
vars:
  nginx_port: 80
  nginx_user: nginx
  
--------------------------------------示例
- name: 安装Nginx
  hosts: web
  vars: #这里定义变量
    nginx_port: 80
    nginx_user: nginx
    nginx_home: /usr/share/nginx/html

  tasks:
    - name: 启动Nginx
      service:
        name: "{{ nginx_user }}" #调用变量
        state: started
```

+ <font style="color:rgb(51, 51, 51);">在 Inventory 中定义： 给不同机器不同变量</font>

```plain
[web]
192.168.1.100 nginx_port=8080
192.168.1.101 nginx_port=8081

# Playbook 里直接用 {{ nginx_port }}
```

#### <font style="color:rgb(51, 51, 51);">方式 3：单独变量文件（企业标准）</font>
<font style="color:rgb(51, 51, 51);">新建 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">vars.yml</font>`

```plain
nginx_port: 80
nginx_user: nginx
```

<font style="color:rgb(51, 51, 51);">Playbook 里引用：</font>

```plain
- name: 部署Nginx
  hosts: web
  vars_files:
    - vars.yml

  tasks:
    - name: 启动服务
      service:
        name: "{{ nginx_user }}"
```

---

#### <font style="color:rgb(51, 51, 51);">方式 4：命令行传变量（临时覆盖）</font>
<font style="color:rgb(51, 51, 51);">ansible-playbook nginx.yml -e "nginx_port=8080"</font>

---

#### <font style="color:rgb(51, 51, 51);">变量类型（必须会 3 种）</font>
##### <font style="color:rgb(51, 51, 51);">1. 普通变量</font>
<font style="color:rgb(51, 51, 51);">port: 80</font>

##### <font style="color:rgb(51, 51, 51);">2. 列表变量（数组）</font>
```plain
packages:
  - nginx
  - mysql
  - php
```

<font style="color:rgb(51, 51, 51);">使用（循环）：</font>

```plain
- name: 安装软件
  yum:
    name: "{{ item }}"
    state: present
  loop: "{{ packages }}"
```

##### <font style="color:rgb(51, 51, 51);">3. 字典变量（key=value）</font>
```plain
nginx:
  port: 80
  user: nginx
  home: /usr/share/nginx/html
```

<font style="color:rgb(51, 51, 51);">使用：</font>

```plain
{{ nginx.port }}
{{ nginx.user }}
```

#### <font style="color:rgb(51, 51, 51);">变量实战例子（你直接复制就能用）</font>
```plain
- name: 变量完整演示（修正版）
  hosts: web
  vars:
    # 端口变量
    web_port: 80
    # 运行服务的系统用户
    web_user: nginx
    # 需要批量安装的软件列表
    web_packages:
      - nginx
      - vim

  tasks:
    - name: 批量安装 Web 服务软件
      yum:
        # loop 循环时，item 自动赋值为 nginx、vim
        name: "{{ item }}"
        state: present
      loop: "{{ web_packages }}"

    - name: 启动 Nginx 并设置开机自启
      service:
        name: nginx       # 服务名：nginx（正确）
        state: started
        enabled: yes
```

#### <font style="color:rgb(51, 51, 51);">（2）Handlers 触发器</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：只有当任务执行结果发生变化时才会执行的任务。</font>

**<font style="color:rgb(51, 51, 51);">为什么重要</font>**<font style="color:rgb(51, 51, 51);">：比如只有当配置文件修改了，才需要重启服务，避免不必要的重启。</font>

**<font style="color:rgb(51, 51, 51);">例子</font>**<font style="color:rgb(51, 51, 51);">：</font>

```plain
tasks:
  - name: 复制Nginx配置文件
    copy:
      src: ./nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: 重启Nginx  # 触发handler

handlers:  # 触发器，放在tasks后面
  - name: 重启Nginx
    service:
      name: nginx
      state: restarted
```

#### <font style="color:rgb(51, 51, 51);">（3）条件判断 When</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：根据不同条件执行不同任务。</font>

**<font style="color:rgb(51, 51, 51);">例子</font>**<font style="color:rgb(51, 51, 51);">：不同操作系统安装不同软件</font>

```plain
- name: 在CentOS上安装nginx
  yum:
    name: nginx
    state: present
  when: ansible_os_family == "RedHat"

- name: 在Ubuntu上安装nginx
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"
```

#### <font style="color:rgb(51, 51, 51);">（4）循环 Loop</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：批量执行相同的任务。</font>

**<font style="color:rgb(51, 51, 51);">例子</font>**<font style="color:rgb(51, 51, 51);">：批量创建多个用户</font>

```plain
- name: 创建多个用户
  user:
    name: "{{ item }}"
    state: present
  loop:
    - user1
    - user2
    - user3
```

#### <font style="color:rgb(51, 51, 51);">2. 角色 Roles（最重要的核心）</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：把 Playbook 按功能拆分成独立的模块，方便复用和维护。</font>

**<font style="color:rgb(51, 51, 51);">为什么重要</font>**<font style="color:rgb(51, 51, 51);">：当你的 Playbook 超过 100 行，或者有多个项目需要管理时，不用 Roles 会变成一团乱麻。</font>

<font style="color:rgb(51, 51, 51);">一个角色 = 一个功能（比如 nginx、mysql、docker）</font>

**<font style="color:rgb(51, 51, 51);">Roles 标准目录结构</font>**<font style="color:rgb(51, 51, 51);">：</font>

```plain
roles/
  nginx/  # nginx角色
    tasks/      # 任务
      main.yml
    handlers/   # 触发器
      main.yml
    templates/  # 模板文件
      nginx.conf.j2
    vars/       # 变量
      main.yml
    defaults/   # 默认变量
      main.yml
    files/      # 静态文件
    meta/       # 角色依赖
```

**<font style="color:rgb(51, 51, 51);">怎么用 Roles</font>**<font style="color:rgb(51, 51, 51);">：</font>

1. <font style="color:rgb(51, 51, 51);">创建角色：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible-galaxy init nginx</font>`<font style="color:rgb(51, 51, 51);">（自动生成上面的目录结构）</font>

```plain
ansible-galaxy init ./roles/nginx

[root@ansible ~]# tree ./roles/
./roles/
└── nginx          # nginx角色
    ├── defaults   # 默认变量
    │   └── main.yml
    ├── files      # 静态文件
    ├── handlers   # 触发器
    │   └── main.yml
    ├── meta       # 角色依赖
    │   └── main.yml
    ├── README.md
    ├── tasks      # 任务
    │   └── main.yml
    ├── templates  # 模板文件
    ├── tests      # 测试文件夹 完全不需要，删除掉
    │   ├── inventory
    │   └── test.yml
    └── vars     # 变量
        └── main.yml
        
roles 同级 目录手动新建一个site.yml 作为主剧本用来调用其他角色
```

<font style="color:rgb(51, 51, 51);">2.把对应的任务、变量、模板放到对应的目录里</font>

```plain
cat > roles/nginx/vars/main.yml <<EOF
# 端口
nginx_port: 80
# 安装的软件包
nginx_packages:
  - nginx
  - vim
EOF

cat > roles/nginx/tasks/main.yml <<EOF
# 1. 批量安装软件
- name: 安装 Nginx 软件
  yum:
    name: "{{ item }}"
    state: present
  loop: "{{ nginx_packages }}"

# 2. 推送模板配置文件
- name: 部署 Nginx 配置文件
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  # 配置修改后，触发重启
  notify: 重启 Nginx

# 3. 启动服务并开机自启
- name: 启动 Nginx 服务
  service:
    name: nginx
    state: started
    enabled: yes
EOF

cat > roles/nginx/handlers/main.yml <<EOF
- name: 重启 Nginx
  service:
    name: nginx
    state: restarted
EOF

cat > roles/nginx/templates/nginx.conf.j2 <<EOF
user nginx;
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    server {
        # 变量来自 vars/main.yml
        listen {{ nginx_port }};
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOF
```

1. <font style="color:rgb(51, 51, 51);">在 Playbook 中引用角色：</font>

```plain
# 主剧本
cat > ansible_demo/site.yml <<EOF
- name: 部署 Nginx 服务
  hosts: web
  # 提权 root
  become: yes
  # 调用 nginx 角色
  roles:
    - nginx
EOF


#最终目录结构
ansible_demo/
├── roles/
│   └── nginx/
│       ├── vars/main.yml
│       ├── tasks/main.yml
│       ├── handlers/main.yml
│       └── templates/nginx.conf.j2
└── site.yml

# 一键运行
ansible-playbook site.yml
```

#### <font style="color:rgb(51, 51, 51);">3. Jinja2 模板</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：动态生成配置文件的模板语言。</font>

**<font style="color:rgb(51, 51, 51);">为什么重要</font>**<font style="color:rgb(51, 51, 51);">：不同服务器的配置文件可能有细微差别（比如端口、IP），用模板可以自动生成不同的配置文件。</font>

**<font style="color:rgb(51, 51, 51);">例子</font>**<font style="color:rgb(51, 51, 51);">：nginx.conf.j2 模板</font>

```plain
# roles/nginx/vars/main.yml
# 基础变量
nginx_user: nginx
web_root: /usr/share/nginx/html

# 判断用变量：环境类型 (test/prod)
run_env: prod

# 循环用变量：多站点配置
web_sites:
  - name: blog
    port: 8081
  - name: shop
    port: 8082
  - name: admin
    port: 8083


#roles/nginx/templates/nginx.conf.j2
{# 1. Jinja2 注释 #}
user {{ nginx_user }};  {# 2. 变量调用 #}
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type application/octet-stream;

    {# 3. if 判断：生产/测试环境配置不同 #}
    {% if run_env == "prod" %}
    sendfile on;
    keepalive_timeout 65;
    {% else %}
    sendfile off;
    keepalive_timeout 10;
    {% endif %}

    {# 4. for 循环：批量生成多站点配置 #}
    {% for site in web_sites %}
    server {
        listen {{ site.port }};
        server_name {{ site.name }};
        root {{ web_root }}/{{ site.name }};
        index index.html;
    }
    {% endfor %}
}


    

        

# roles/nginx/tasks/main.yml
- name: 安装 Nginx
  yum:
    name: nginx
    state: present

- name: 部署三合一模板配置
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: 重启 Nginx

- name: 启动 Nginx
  service:
    name: nginx
    state: started
    enabled: yes
```

---

## <font style="color:rgb(51, 51, 51);">第三阶段：进阶必学</font>
### <font style="color:rgb(51, 51, 51);">1. 标签 Tags</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：给 Playbook 中的任务打标签，只执行指定标签的任务。</font>

**<font style="color:rgb(51, 51, 51);">为什么重要</font>**<font style="color:rgb(51, 51, 51);">：一个大的 Playbook 可能有几十上百个任务，不用每次都从头执行。</font>

**<font style="color:rgb(51, 51, 51);">例子</font>**<font style="color:rgb(51, 51, 51);">：</font>

```plain
tasks:
  - name: 安装Nginx
    yum:
      name: nginx
      state: present
    tags: install

  - name: 配置Nginx
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/conf.d/default.conf
    tags: config
```

**<font style="color:rgb(51, 51, 51);">执行指定标签的任务</font>**<font style="color:rgb(51, 51, 51);">：</font>

```plain
ansible-playbook nginx.yml --tags config  # 只执行配置任务
ansible-playbook nginx.yml --skip-tags install  # 跳过安装任务
```

### <font style="color:rgb(51, 51, 51);">2. 错误处理</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ignore_errors: yes</font>`<font style="color:rgb(51, 51, 51);">：忽略错误，继续执行后面的任务</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">failed_when</font>`<font style="color:rgb(51, 51, 51);">：自定义失败条件</font>
+ `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">block/rescue/always</font>`<font style="color:rgb(51, 51, 51);">：异常处理（类似 try/catch/finally）</font>

### <font style="color:rgb(51, 51, 51);">3. 调试 Debug</font>
**<font style="color:rgb(51, 51, 51);">是什么</font>**<font style="color:rgb(51, 51, 51);">：打印变量和任务执行结果，排查问题。</font>

**<font style="color:rgb(51, 51, 51);">例子</font>**<font style="color:rgb(51, 51, 51);">：</font>

```plain
- name: 打印服务器IP
  debug:
    var: ansible_default_ipv4.address
```

### <font style="color:rgb(51, 51, 51);">4. 批量执行优化</font>
+ <font style="color:rgb(51, 51, 51);">并行执行：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible-playbook -f 10 nginx.yml</font>`<font style="color:rgb(51, 51, 51);">（同时执行 10 台服务器）</font>
+ <font style="color:rgb(51, 51, 51);">只执行失败的主机：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible-playbook nginx.yml --limit @/root/ansible_failed.retry</font>`

---

## <font style="color:rgb(51, 51, 51);">第四阶段：生产实战</font>
### <font style="color:rgb(51, 51, 51);">1. 批量初始化新服务器</font>
<font style="color:rgb(51, 51, 51);">写一个 Playbook，完成以下任务：</font>

+ <font style="color:rgb(51, 51, 51);">修改主机名</font>
+ <font style="color:rgb(51, 51, 51);">关闭防火墙和 SELinux</font>
+ <font style="color:rgb(51, 51, 51);">配置 YUM 源</font>
+ <font style="color:rgb(51, 51, 51);">安装基础软件（vim、wget、curl、net-tools）</font>
+ <font style="color:rgb(51, 51, 51);">创建运维用户并配置 sudo 权限</font>
+ <font style="color:rgb(51, 51, 51);">配置 SSH 安全加固（禁用 root 登录、修改默认端口）</font>

### <font style="color:rgb(51, 51, 51);">2. 批量部署应用</font>
<font style="color:rgb(51, 51, 51);">写一个 Playbook，部署一个简单的 Web 应用：</font>

+ <font style="color:rgb(51, 51, 51);">安装 Nginx</font>
+ <font style="color:rgb(51, 51, 51);">安装 PHP</font>
+ <font style="color:rgb(51, 51, 51);">安装 MySQL</font>
+ <font style="color:rgb(51, 51, 51);">部署应用代码</font>
+ <font style="color:rgb(51, 51, 51);">配置 Nginx 反向代理</font>
+ <font style="color:rgb(51, 51, 51);">启动所有服务并设置开机自启</font>

### <font style="color:rgb(51, 51, 51);">3. 配置管理</font>
+ <font style="color:rgb(51, 51, 51);">统一管理所有服务器的 /etc/hosts 文件</font>
+ <font style="color:rgb(51, 51, 51);">统一管理所有服务器的定时任务</font>
+ <font style="color:rgb(51, 51, 51);">统一推送配置文件并重启服务</font>

### <font style="color:rgb(51, 51, 51);">4. 最佳实践</font>
+ <font style="color:rgb(51, 51, 51);">所有 Playbook 和 Roles 都用 Git 版本控制</font>
+ <font style="color:rgb(51, 51, 51);">变量和代码分离，不同环境用不同的变量文件</font>
+ <font style="color:rgb(51, 51, 51);">严格遵守幂等性：重复执行 Playbook 不会产生副作用</font>
+ <font style="color:rgb(51, 51, 51);">给所有任务和 Playbook 加清晰的注释</font>
+ <font style="color:rgb(51, 51, 51);">定期备份 Ansible 配置文件</font>

## <font style="color:rgb(51, 51, 51);">一、标准项目目录结构</font>
```plain
ansible_production/
├── roles/
│   ├── init_server/       # 1. 服务器初始化角色
│   ├── web_deploy/        # 2. Web应用部署角色
│   └── config_manage/     # 3. 统一配置管理角色
├── inventory/
│   └── hosts              # 主机清单
├── site.yml               # 主入口剧本
└── vars/
    └── global.yml         # 全局变量文件
```

---

## <font style="color:rgb(51, 51, 51);">二、基础配置文件</font>
### <font style="color:rgb(51, 51, 51);">1. 主机清单 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">inventory/hosts</font>`
```plain
[web]
192.168.1.100
192.168.1.101

[db]
192.168.1.102

[all:vars]
ansible_ssh_user=root
ansible_ssh_port=22
```

### <font style="color:rgb(51, 51, 51);">2. 全局变量 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">vars/global.yml</font>`
```plain
# 通用配置
env: prod
timezone: Asia/Shanghai

# 初始化服务器
hostname_prefix: web-server
ops_user: opsuser
ssh_port: 2233

# Web应用
nginx_port: 80
php_version: 7.4
mysql_root_password: Root@123456
```

### <font style="color:rgb(51, 51, 51);">3. 主入口剧本 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">site.yml</font>`
```plain
- name: 生产环境 - 服务器初始化
  hosts: all
  become: yes
  roles:
    - init_server

- name: 生产环境 - 部署Web应用
  hosts: web
  become: yes
  roles:
    - web_deploy

- name: 生产环境 - 统一配置管理
  hosts: all
  become: yes
  roles:
    - config_manage
```

---

## <font style="color:rgb(51, 51, 51);">三、角色 1：服务器初始化 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">roles/init_server</font>`
### <font style="color:rgb(51, 51, 51);">1. 变量 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">vars/main.yml</font>`
```plain
base_packages:
  - vim
  - wget
  - curl
  - net-tools
  - tree
  - lrzsz
```

### <font style="color:rgb(51, 51, 51);">2. 核心任务 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">tasks/main.yml</font>`
```plain
- name: 加载全局变量
  include_vars: ../../vars/global.yml

- name: 修改主机名
  hostname:
    name: "{{ hostname_prefix }}-{{ inventory_hostname_short }}"

- name: 关闭防火墙
  service:
    name: firewalld
    state: stopped
    enabled: no

- name: 临时关闭SELinux
  command: setenforce 0
  ignore_errors: yes

- name: 永久关闭SELinux
  lineinfile:
    path: /etc/selinux/config
    regexp: '^SELINUX='
    line: 'SELINUX=disabled'

- name: 配置阿里云YUM源
  yum_repository:
    name: aliyun
    description: Aliyun YUM Repo
    baseurl: http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
    gpgcheck: no

- name: 安装基础软件
  yum:
    name: "{{ item }}"
    state: present
  loop: "{{ base_packages }}"

- name: 创建运维用户
  user:
    name: "{{ ops_user }}"
    state: present
    shell: /bin/bash

- name: 配置sudo免密
  lineinfile:
    path: /etc/sudoers
    line: '{{ ops_user }} ALL=(ALL) NOPASSWD: ALL'
    validate: 'visudo -cf %s'

- name: SSH加固 - 修改端口
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#Port|^Port'
    line: "Port {{ ssh_port }}"

- name: SSH加固 - 禁止root登录
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PermitRootLogin'
    line: 'PermitRootLogin no'
  notify: 重启SSH服务
```

### <font style="color:rgb(51, 51, 51);">3. 触发器 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">handlers/main.yml</font>`
```plain
- name: 重启SSH服务
  service:
    name: sshd
    state: restarted
```

---

## <font style="color:rgb(51, 51, 51);">四、角色 2：Web 应用部署 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">roles/web_deploy</font>`
### <font style="color:rgb(51, 51, 51);">1. 任务 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">tasks/main.yml</font>`
```plain
- name: 加载全局变量
  include_vars: ../../vars/global.yml

# 安装Nginx
- name: 安装Nginx
  yum:
    name: nginx
    state: present

# 安装PHP
- name: 安装PHP
  yum:
    name:
      - php
      - php-fpm
      - php-mysqlnd
    state: present

# 安装MySQL
- name: 安装MySQL
  yum:
    name: mariadb-server
    state: present

# 部署Web代码
- name: 创建站点目录
  file:
    path: /usr/share/nginx/html
    state: directory
    mode: 0755

- name: 部署测试页面
  copy:
    content: "<?php phpinfo(); ?>"
    dest: /usr/share/nginx/html/index.php

# Nginx配置
- name: 配置Nginx代理
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/conf.d/default.conf
  notify: 重启Nginx

# 启动所有服务
- name: 启动Nginx/PHP/MySQL
  service:
    name: "{{ item }}"
    state: started
    enabled: yes
  loop:
    - nginx
    - php-fpm
    - mariadb
```

```plain
server {
    listen {{ nginx_port }};
    root /usr/share/nginx/html;
    index index.php index.html;

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

_**<font style="color:rgb(204, 204, 204);">### </font>**_**<font style="color:rgb(51, 51, 51);">3. 触发器 </font>**`**<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">handlers/main.yml</font>**`

```plain
- name: 重启Nginx
  service:
    name: nginx
    state: restarted
```

---

## <font style="color:rgb(51, 51, 51);">五、角色 3：统一配置管理 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">roles/config_manage</font>`
### <font style="color:rgb(51, 51, 51);">1. 任务 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">tasks/main.yml</font>`
```plain
# 1. 统一管理 /etc/hosts
- name: 配置hosts文件
  lineinfile:
    path: /etc/hosts
    line: "{{ hostvars[item].ansible_host }} {{ item }}"
    state: present
  loop: "{{ groups.all }}"   #内置变量  循环遍历所有机器

# 2. 统一管理定时任务
- name: 创建日志清理定时任务
  cron:
    name: "clean logs"
    minute: "0"
    hour: "3"
    job: "/usr/bin/find /var/log -name '*.log' -mtime +7 -delete"

# 3. 推送统一配置文件
- name: 推送时区配置
  copy:
    content: "Asia/Shanghai"
    dest: /etc/timezone
  notify: 同步时区
```

### <font style="color:rgb(51, 51, 51);">2. 触发器 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">handlers/main.yml</font>`
```plain
- name: 同步时区
  command: timedatectl set-timezone Asia/Shanghai
```

---

## <font style="color:rgb(51, 51, 51);">六、执行命令（生产标准）</font>
```plain
# 进入项目目录
cd ansible_production

# 执行全套自动化部署
ansible-playbook -i inventory/hosts site.yml
```

---

## <font style="color:rgb(51, 51, 51);">七、生产最佳实践（企业标准）</font>
### <font style="color:rgb(51, 51, 51);">1. 代码管理</font>
+ <font style="color:rgb(51, 51, 51);">所有 Ansible 代码提交到 </font>**<font style="color:rgb(51, 51, 51);">Git/GitLab</font>**<font style="color:rgb(51, 51, 51);">，禁止本地裸奔</font>
+ <font style="color:rgb(51, 51, 51);">分支规范：</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">dev</font>`<font style="color:rgb(51, 51, 51);">(测试) → </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">test</font>`<font style="color:rgb(51, 51, 51);">(预发) → </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">main</font>`<font style="color:rgb(51, 51, 51);">(生产)</font>

### <font style="color:rgb(51, 51, 51);">2. 变量规范</font>
+ <font style="color:rgb(51, 51, 51);">公共变量放 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">global.yml</font>`
+ <font style="color:rgb(51, 51, 51);">角色私有变量放角色内 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">vars/main.yml</font>`
+ <font style="color:rgb(51, 51, 51);">敏感密码（MySQL、SSH）使用 </font>**<font style="color:rgb(51, 51, 51);">ansible-vault 加密</font>**

### <font style="color:rgb(51, 51, 51);">3. 幂等性保障</font>
+ <font style="color:rgb(51, 51, 51);">全部使用 Ansible 原生模块，</font>**<font style="color:rgb(51, 51, 51);">禁止使用 shell/command</font>**
+ <font style="color:rgb(51, 51, 51);">重复执行剧本不会重复修改、不会报错</font>

### <font style="color:rgb(51, 51, 51);">4. 安全规范</font>
+ <font style="color:rgb(51, 51, 51);">禁用 root 远程登录，使用普通运维用户</font>
+ <font style="color:rgb(51, 51, 51);">SSH 修改默认端口，仅允许密钥登录</font>
+ <font style="color:rgb(51, 51, 51);">密码统一加密管理，绝不明文写在代码里</font>

### <font style="color:rgb(51, 51, 51);">5. 运维规范</font>
+ <font style="color:rgb(51, 51, 51);">所有任务添加清晰 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">name</font>`<font style="color:rgb(51, 51, 51);"> 注释</font>
+ <font style="color:rgb(51, 51, 51);">定期备份 Ansible 项目目录</font>
+ <font style="color:rgb(51, 51, 51);">生产执行前加 </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">--check</font>`<font style="color:rgb(51, 51, 51);"> 干跑测试</font>

# <font style="color:rgb(51, 51, 51);">ansible 内置变量</font>
# <font style="color:rgb(51, 51, 51);">Ansible 常用内置变量速查表</font>
## <font style="color:rgb(51, 51, 51);">一、主机清单类（最常用 → 批量管理、配置 hosts 必用）</font>
| **<font style="color:rgb(51, 51, 51);">变量名</font>** | **<font style="color:rgb(51, 51, 51);">核心作用</font>** | **<font style="color:rgb(51, 51, 51);">实战示例</font>** |
| :--- | :--- | :--- |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">groups</font>` | <font style="color:rgb(51, 51, 51);">所有主机分组的字典</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">groups.all</font>`<br/><font style="color:rgb(51, 51, 51);">（所有主机）</font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">groups.web</font>`<br/><font style="color:rgb(51, 51, 51);">（web 组主机）</font> |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">hostvars</font>` | <font style="color:rgb(51, 51, 51);">所有主机的变量合集</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">hostvars[item].ansible_default_ipv4.address</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">inventory_hostname</font>` | <font style="color:rgb(51, 51, 51);">当前主机在清单中的名称</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">192.168.1.100</font>`<br/><font style="color:rgb(51, 51, 51);"> / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">web01</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">inventory_hostname_short</font>` | <font style="color:rgb(51, 51, 51);">主机名 / IP 短格式</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">100</font>`<br/><font style="color:rgb(51, 51, 51);">（截取 IP 最后一段）</font> |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_host</font>` | <font style="color:rgb(51, 51, 51);">主机连接 IP（清单定义）</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">192.168.1.100</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_port</font>` | <font style="color:rgb(51, 51, 51);">主机 SSH 端口</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">22</font>`<br/><font style="color:rgb(51, 51, 51);"> / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">2233</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_user</font>` | <font style="color:rgb(51, 51, 51);">主机登录用户</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">root</font>`<br/><font style="color:rgb(51, 51, 51);"> / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">opsuser</font>` |


---

## <font style="color:rgb(51, 51, 51);">二、系统 Facts 类（自动收集 → 系统信息、差异化配置必用）</font>
| **<font style="color:rgb(51, 51, 51);">变量名</font>** | **<font style="color:rgb(51, 51, 51);">核心作用</font>** | **<font style="color:rgb(51, 51, 51);">实战示例</font>** |
| :--- | :--- | :--- |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_os_family</font>` | <font style="color:rgb(51, 51, 51);">系统家族</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">RedHat</font>`<br/><font style="color:rgb(51, 51, 51);">(CentOS) / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">Debian</font>`<br/><font style="color:rgb(51, 51, 51);">(Ubuntu)</font> |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_distribution</font>` | <font style="color:rgb(51, 51, 51);">系统名称</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">CentOS</font>`<br/><font style="color:rgb(51, 51, 51);"> / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">Ubuntu</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_distribution_version</font>` | <font style="color:rgb(51, 51, 51);">系统版本</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">7</font>`<br/><font style="color:rgb(51, 51, 51);"> / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">8</font>`<br/><font style="color:rgb(51, 51, 51);"> / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">20.04</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_default_ipv4.address</font>` | <font style="color:rgb(51, 51, 51);">本机默认网卡 IP</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">192.168.1.100</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_memtotal_mb</font>` | <font style="color:rgb(51, 51, 51);">总内存大小</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">1823</font>`<br/><font style="color:rgb(51, 51, 51);">（MB）</font> |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_processor_vcpus</font>` | <font style="color:rgb(51, 51, 51);">CPU 核心数</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">2</font>`<br/><font style="color:rgb(51, 51, 51);"> / </font>`<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">4</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_hostname</font>` | <font style="color:rgb(51, 51, 51);">系统主机名</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">localhost.localdomain</font>` |


---

## <font style="color:rgb(51, 51, 51);">三、任务 / 执行类（Playbook 开发 → 循环、角色、调试必用）</font>
| **<font style="color:rgb(51, 51, 51);">变量名</font>** | **<font style="color:rgb(51, 51, 51);">核心作用</font>** | **<font style="color:rgb(51, 51, 51);">实战示例</font>** |
| :--- | :--- | :--- |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">item</font>` | <font style="color:rgb(51, 51, 51);">循环内置变量</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">loop</font>`<br/><font style="color:rgb(51, 51, 51);"> 遍历列表时自动赋值</font> |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">play_hosts</font>` | <font style="color:rgb(51, 51, 51);">当前 Play 生效的主机</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">[192.168.1.100, 192.168.1.101]</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">role_path</font>` | <font style="color:rgb(51, 51, 51);">当前角色路径</font> | `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">/opt/ansible/roles/nginx</font>` |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_play_hosts</font>` | <font style="color:rgb(51, 51, 51);">当前执行的所有主机</font> | <font style="color:rgb(51, 51, 51);">同 play_hosts</font> |
| `<font style="color:rgb(51, 51, 51);background-color:rgb(243, 244, 244);">ansible_date_time</font>` | <font style="color:rgb(51, 51, 51);">系统当前时间</font> | <font style="color:rgb(51, 51, 51);">日志、备份文件名生成</font> |


---

# <font style="color:rgb(51, 51, 51);">两个关键命令（自己查看所有内置变量）</font>
## <font style="color:rgb(51, 51, 51);">1. 查看主机清单内置变量</font>
ansible web -m debug -a "var=groups"

## <font style="color:rgb(51, 51, 51);">2. 查看系统 Facts 所有变量（最全）</font>
ansible web -m setup

---

## <font style="color:rgb(51, 51, 51);">第五阶段：面试高频考点（直接背）</font>
1. **<font style="color:rgb(51, 51, 51);">Ansible 的特点是什么？</font>**

<font style="color:rgb(51, 51, 51);">无客户端、基于 SSH 通信、YAML 配置、幂等性、轻量化、无需数据库。</font>

2. **<font style="color:rgb(51, 51, 51);">什么是幂等性？为什么重要？</font>**

<font style="color:rgb(51, 51, 51);">重复执行同一个操作，结果都是一样的。保证环境一致性，避免人工操作出错。</font>

3. **<font style="color:rgb(51, 51, 51);">Ad-hoc 和 Playbook 的区别？</font>**

<font style="color:rgb(51, 51, 51);">Ad-hoc 是临时单行命令，适合简单一次性操作；Playbook 是 YAML 脚本，适合复杂可重复的任务。</font>

4. **<font style="color:rgb(51, 51, 51);">Roles 的作用是什么？</font>**

<font style="color:rgb(51, 51, 51);">把 Playbook 按功能模块化，提高代码复用性和可维护性。</font>

5. **<font style="color:rgb(51, 51, 51);">Ansible 的工作原理是什么？</font>**

<font style="color:rgb(51, 51, 51);">控制节点通过 SSH 免密登录被控节点，把模块和参数推送到被控节点执行，执行完后删除临时文件。</font>

6. **<font style="color:rgb(51, 51, 51);">command 和 shell 模块的区别？</font>**

<font style="color:rgb(51, 51, 51);">command 不支持管道、重定向等 shell 特性；shell 支持，功能更强大，但有安全风险。</font>





