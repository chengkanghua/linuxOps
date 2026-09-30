# Ansible 核心知识

## 一、基本概述

**Ansible** 是**开源自动化运维工具**，用来**批量管理多台服务器**：批量执行命令、配置部署、环境初始化、项目发布。

### 软件特点
- **无客户端**：被控机只要开 SSH，不用装代理
- 基于 **SSH** 通信，加密安全
- 配置用 **YAML** 编写，简单易懂
- **幂等性**：重复执行不会重复改动，保证环境一致
- 轻量化、部署简单、无需数据库

### 核心架构
- **控制节点**：安装 Ansible 的机器，统一发号施令
- **被控节点**：所有被管理服务器，只需开 SSH

### 四大核心组件
1. **Inventory 主机清单**：记录要管理的服务器 IP、分组
2. **Module 模块**：内置现成功能（执行命令、装软件、改配置、建用户）
3. **Ad-hoc**：临时批量执行单条命令，不用写脚本
4. **Playbook 剧本**：YAML 编写，多步骤复杂自动化，可重复执行

### 两种使用方式
- **Ad-hoc**：临时一次性批量操作（批量关机、批量查磁盘）
- **Playbook**：写剧本，做标准化部署（初始化环境、部署网站）

### 应用场景
批量初始化新服务器 / 批量安装卸载软件 / 批量改配置推送文件 / 自动化发布回滚 / 统一运维标准。

> 流程：1.购买机器 → 2.配置环境 → 3.部署代码 → 4.测试 → 5.加入集群

### Ansible vs SaltStack
| 维度 | Ansible | SaltStack |
| --- | --- | --- |
| 架构 | 无客户端（Agentless），纯 SSH | 主从（Master-Minion），有客户端 |
| 通信 | SSH，每次新建连接 | ZeroMQ 长连接 |
| 执行速度 | 慢（SSH 握手开销） | 极快（长连接+异步） |
| 学习曲线 | 平缓，1 周上手 | 陡峭，2-3 周熟练 |
| 部署难度 | 极低 | 中等（需装 Minion） |
| 最大规模 | 1000 台以内 | 10 万台以上 |
| 实时性 | 差，只能主动推送 | 极好，事件驱动 |
| 配置语言 | 纯 YAML | SLS（YAML+Jinja2） |

更多：<http://ansible.com.cn/docs/playbooks_intro.html>、<https://ansible.leops.cn/basic/Introduction/>

---

## 二、安装配置

```bash
# 生成 ED25519 密钥（推荐；兼容老系统用 RSA 4096）
ssh-keygen -t ed25519 -C "运维-张三-生产环境-20260503"
# ssh-keygen -t rsa -b 4096 -C "chengkanghua@foxmail.com"

# 批量分发公钥
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.41
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.21

# 1. 安装
yum install ansible -y
ansible --version    # ansible 2.6.1

# 2. 配置清单
# vim /etc/ansible/hosts
[oldboy]
172.16.1.31
172.16.1.41

# 3. 验证（ping 通过 SSH 探测）
ansible oldboy -m ping
```

### 命令语法
```bash
# 格式：ansible 主机组 -m 模块 -a "参数"
ansible oldboy -m command -a "hostname"
ansible oldboy -m command -a "df -h"
```

---

## 三、清单（Inventory）管理

Inventory 用于定义被管主机的认证信息（ssh 用户、密码、key）。

**主机**
- 支持通配/正则：`test[1:4].cominggo.com`
- 支持非标准 ssh 端口：`test5.cominggo.com:5566`
- 支持指定变量：`test2 ansible_ssh_host=10.4.2.123`
- 支持别名与变量

**主机组**
- 嵌套组：`[game:children]` 下的组即为其成员
- 组变量：`[game:vars]` 下指定

```bash
# cat /etc/ansible/hosts
[webservers]
web[1:3].oldboy.com ansible_ssh_pass='123456'      # 密码版（改良）
[webservers:vars]                                   # 密码拆分版
ansible_ssh_pass='123456'

[apache]
web[1:3].oldboy.com
[apache:vars]
ansible_ssh_pass='123456'

[nginx]
10.0.0.7
10.0.0.31
[nginx:vars]
ansible_ssh_pass='123456'

# webservers 组包含两个子组
[webservers:children]
apache
nginx

ansible nginx --list-hosts
ansible apache --list-hosts
ansible webservers --list-hosts
```

### 内置变量
| 参数 | 用途 |
| --- | --- |
| ansible_ssh_host | 定义 hosts ssh 地址 |
| ansible_ssh_port | 定义 hosts ssh 端口 |
| ansible_ssh_user | 定义 hosts ssh 认证用户 |
| ansible_ssh_pass | 定义 hosts ssh 认证密码 |
| ansible_sudo | 定义 hosts sudo 用户 |
| ansible_sudo_pass | 定义 hosts sudo 密码 |
| ansible_connection | 定义 hosts 连接方式（如 local） |
| ansible_ssh_private_key_file | 定义私钥文件 |
| ansible_python_interpreter | 任务执行 python 路径 |
| ansible_*_interpreter | 其他语言解析路径 |

---

## 四、常用模块

> 提示颜色：翔黄=对远端做了修改；帽绿=未修改/仅查看；深红=执行异常；浅紫=警告建议。

### 模块速查
| 模块 | 作用 | 例子 |
| --- | --- | --- |
| **ping** | 测试连通性 | `ansible all -m ping` |
| **command** | 执行简单命令（不支持管道/重定向），默认模块 | `ansible web -a "hostname"` |
| **shell** | 复杂命令（支持管道/重定向/变量） | `ansible web -m shell -a "ifconfig|grep eth0" -f 50` |
| **script** | 把本地脚本传到远端执行 | `ansible web -m script -a "./deploy.sh"` |
| **copy** | 本地文件/目录复制到远端 | `ansible web -m copy -a "src=nginx.conf dest=/etc/nginx/nginx.conf mode=644 owner=root"` |
| **file** | 创建/删除文件目录、改权限属主 | `ansible web -m file -a "path=/data/logs state=directory mode=755 owner=nginx"` |
| **service** | 管理服务的启停/重启/自启 | `ansible web -m service -a "name=nginx state=restarted enabled=yes"` |
| **yum** | CentOS 安装/卸载软件 | `ansible web -m yum -a "name=nginx state=present"` |
| **apt** | Ubuntu 安装/卸载软件 | `ansible web -m apt -a "name=nginx state=present update_cache=yes"` |
| **template** | 渲染 Jinja2 模板并复制 | `ansible web -m template -a "src=nginx.conf.j2 dest=/etc/nginx/conf.d/default.conf"` |
| **authorized_key** | 批量分发 SSH 公钥 | `ansible all -m authorized_key -a "user=root key='{{ lookup('file','~/.ssh/id_ed25519.pub') }}'"` |
| **fetch** | 从远端拉取文件（copy 反向） | `ansible web -m fetch -a "src=/var/log/nginx/access.log dest=./logs/ flat=yes"` |
| **lineinfile** | 改单行内容 | `ansible all -m lineinfile -a "path=/etc/hosts line='192.168.1.100 web01'"` |
| **user** | 管理用户 | `ansible all -m user -a "name=ops state=present groups=wheel shell=/bin/bash"` |
| **group** | 管理组 | `ansible all -m group -a "name=dev state=present"` |
| **cron** | 管理定时任务 | `ansible web -m cron -a "name='清理日志' minute=0 hour=3 job='/usr/bin/rm -rf /data/logs/*.log'"` |
| **setup** | 收集系统 facts | `ansible web -m setup -a "filter=ansible_default_ipv4"` |
| **raw** | 原始命令（无 Python 的老系统） | `ansible old_server -m raw -a "uptime"` |
| **mount** | 挂载/卸载 | `ansible db -m mount -a "path=/data src=/dev/sdb1 fstype=xfs state=mounted"` |

### 示例命令
```bash
# command（默认模块）
ansible oldboy -a "hostname"
ansible oldboy -m shell -a "ifconfig|grep eth0" -f 50     # -f = forks，并行数量

# yum
ansible oldboy -m yum -a "name=httpd state=installed"
#   installed/present=安装  removed/absent=卸载  latest=最新

# copy
ansible oldboy -m copy -a "src=/etc/hosts dest=/tmp/test.txt owner=www group=www mode=0600"
ansible oldboy -m copy -a "src=/etc/hosts dest=/tmp/test.txt backup=yes"   # 覆盖前备份
ansible oldboy -m copy -a "content='bgx' dest=/tmp/oldboy"                  # 直接写内容（覆盖）

# service
ansible oldboy -m service -a "name=crond state=stopped enabled=yes"
#   started/stopped/restarted/reloaded  enabled=是否开机自启

# script
mkdir -p /server/scripts
cat > /server/scripts/yum.sh <<EOF
#!/usr/bin/bash
yum install -y iftop
EOF
ansible oldboy -m script -a "/server/scripts/yum.sh"

# file
ansible oldboy -m file -a "path=/tmp/oldboy state=directory"
ansible oldboy -m file -a "path=/tmp/tt state=touch mode=555 owner=root group=root"
ansible oldboy -m file -a "src=/tmp/tt path=/tmp/tt_link state=link"

# group / user
ansible oldboy -m group -a "name=oldgirl gid=888"
ansible oldboy -m user -a "name=oldgirl uid=888 group=888 shell=/sbin/nologin create_home=no"
# 加密密码：echo "bgx" | openssl passwd -1 -stdin
ansible oldboy -m user -a 'name=xlw password="$1$765yDGau$diDKPRoCIPMU6KEVEaPTZ0"'

# cron
ansible oldboy -m cron -a "name='cron01' job='/bin/sh /server/scripts/test.sh'"
ansible oldboy -m cron -a "name='cron02' job='...' state=absent"      # 删除
ansible oldboy -m cron -a "name='cron01' job='...' disabled=yes"       # 注释失效

# mount
ansible web -m mount -a "src=172.16.1.31:/data path=/data fstype=nfs opts=defaults state=mounted"
#   present=写fstab不挂  mounted=挂并写fstab  unmounted=卸不清理fstab  absent=卸并清理fstab
```

### 查看帮助
```bash
ansible-doc -l           # 所有模块
ansible-doc copy         # 指定模块用法
```

---

## 五、Playbook 概述

用 YAML 写自动化脚本，多步骤组合、可重复执行。

**YAML 语法注意**
1. 用空格缩进，不能用 Tab
2. 冒号后必须跟一个空格
3. 列表用 `-` 开头

### 安装 httpd（基础）
```yaml
# 清单
[web]
10.0.0.4
10.0.0.3

# httpd_install.yaml
- hosts: web
  tasks:
    - name: Install Httpd Server
      yum: name=httpd,httpd-tools state=installed
    - name: Start Httpd Server
      service: name=httpd state=started enabled=yes

ansible-playbook --syntax-check httpd_install.yaml    # 语法检查
ansible-playbook -C httpd_install.yaml                # 干跑测试
ansible-playbook  httpd_install.yaml                  # 真正执行
```

### 含配置推送 + handlers
```yaml
- hosts: web
  tasks:
    - name: Install Httpd Server
      yum: name=httpd,httpd-tools state=installed
    - name: Configgure Httpd Server
      copy: src=./httpd.conf dest=/etc/httpd/conf/httpd.conf
      notify: Resart Httpd Server
    - name: Start Httpd Server
      service: name=httpd state=started enabled=yes
  handlers:
    - name: Resart Httpd Server
      service: name=httpd state=restarted
```

---

## 六、综合案例：集中式 Playbook 项目

```yaml
# 目录结构
/etc/ansible/ansible_playbook/
├── base.yaml
├── conf/{confxml.xml,exports,resolv.conf,rsyncd.conf}
├── file/sersync2.5.4_64bit_binary_stable_final.tar.gz
├── mail.yaml
├── nfs.yaml
├── rsync.yaml
├── scripts/{rsync_backup_md5.sh,rsync_check_backup.sh}
├── sersync.yaml
└── web.yaml
```

```yaml
# mail.yaml（入口：依次调用各子剧本）
- import_playbook: base.yaml
- import_playbook: rsync.yaml
- import_playbook: nfs.yaml
- import_playbook: sersync.yaml
- import_playbook: web.yaml
```

```yaml
# base.yaml（所有主机初始化）
- hosts: all
  tasks:
    - name: clear yum.repos.d
      shell: rm -f /etc/yum.repos.d/*
    - name: Install Base Repos
      get_url: url=http://mirrors.aliyun.com/repo/Centos-7.repo dest=/etc/yum.repos.d/CentOS-Base.repo
    - name: Install Epel Repos
      get_url: url=http://mirrors.aliyun.com/repo/epel-7.repo dest=/etc/yum.repos.d/epel.repo
    - name: Dns Client
      copy: src=./conf/resolv.conf dest=/etc/resolv.conf
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
```

```yaml
# rsync.yaml（backup 节点）
- hosts: backup
  tasks:
    - name: Installed Rsync Server
      yum: name=rsync,mailx state=installed
    - name: configure Rsync Server
      copy: src=./conf/rsyncd.conf dest=/etc/rsyncd.conf
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
```

```yaml
# nfs.yaml
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
```

```yaml
# sersync.yaml
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
      shell: pgrep sersync; [ $? -eq 0 ] || /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
  handlers:
    - name: kill old sersync and restart new sersync
      shell: pgrep sersync | xargs kill -9; /usr/local/sersync/sersync2 -dro /usr/local/sersync/confxml.xml
```

```yaml
# web.yaml
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
```

配套脚本与配置：`scripts/rsync_backup_md5.sh`、`scripts/rsync_check_backup.sh`、`conf/confxml.xml`、`conf/exports`、`conf/resolv.conf`、`conf/rsyncd.conf`（内容与前述 NFS/Rsync 章节一致）。

---

## 七、Playbook 进阶语法

### 1. 变量 Variables
**规则**：① 变量名仅字母/数字/下划线；② 调用写 `{{变量名}}`；③ 冒号后必须有空格。
**优先级（高→低）**：命令行 `-e` > 单独变量文件 > Playbook vars > Inventory 变量。

```yaml
# 在 Playbook 中定义
- name: 安装Nginx
  hosts: web
  vars:
    nginx_port: 80
    nginx_user: nginx
  tasks:
    - name: 启动Nginx
      service:
        name: "{{ nginx_user }}"
        state: started
```
```yaml
# Inventory 中定义（不同机器不同变量）
[web]
192.168.1.100 nginx_port=8080
192.168.1.101 nginx_port=8081
```
```yaml
# 单独变量文件（企业标准）
# vars.yml
nginx_port: 80
nginx_user: nginx
# 引用
- name: 部署Nginx
  hosts: web
  vars_files:
    - vars.yml
  tasks:
    - service: { name: "{{ nginx_user }}" }
```
```bash
# 命令行覆盖
ansible-playbook nginx.yml -e "nginx_port=8080"
```

**变量类型**
```yaml
port: 80                       # 普通变量
packages:                      # 列表（数组）
  - nginx
  - mysql
  - php
nginx:                        # 字典（key=value）
  port: 80
  user: nginx
  home: /usr/share/nginx/html
```
```yaml
- name: 安装软件
  yum: { name: "{{ item }}", state: present }
  loop: "{{ packages }}"
{{ nginx.port }}    # 字典调用
```

### 2. Handlers 触发器
仅当任务发生变化时才执行的任务（如配置改了才重启服务，避免无谓重启）。
```yaml
tasks:
  - name: 复制Nginx配置文件
    copy: { src: ./nginx.conf, dest: /etc/nginx/nginx.conf }
    notify: 重启Nginx
handlers:
  - name: 重启Nginx
    service: { name: nginx, state: restarted }
```

### 3. 条件判断 When
```yaml
- name: 在CentOS上安装nginx
  yum: { name: nginx, state: present }
  when: ansible_os_family == "RedHat"
- name: 在Ubuntu上安装nginx
  apt: { name: nginx, state: present }
  when: ansible_os_family == "Debian"
```

### 4. 循环 Loop
```yaml
- name: 创建多个用户
  user: { name: "{{ item }}", state: present }
  loop: [user1, user2, user3]
```

---

## 八、角色 Roles（最重要）

把 Playbook 按功能拆分成独立模块，方便复用和维护。一个角色 = 一个功能（nginx、mysql、docker）。

**标准目录结构**
```
roles/nginx/
├── defaults/   # 默认变量
├── files/      # 静态文件
├── handlers/   # 触发器 (main.yml)
├── meta/       # 角色依赖
├── tasks/      # 任务 (main.yml)
├── templates/  # 模板文件 (.j2)
└── vars/       # 变量 (main.yml)
```
> tests/ 测试目录一般删除。同级的 `site.yml` 作为主剧本调用角色。

**创建与使用**
```bash
ansible-galaxy init ./roles/nginx

cat > roles/nginx/vars/main.yml <<EOF
nginx_port: 80
nginx_packages:
  - nginx
  - vim
EOF

cat > roles/nginx/tasks/main.yml <<EOF
- name: 安装 Nginx 软件
  yum: { name: "{{ item }}", state: present }
  loop: "{{ nginx_packages }}"
- name: 部署 Nginx 配置文件
  template: { src: nginx.conf.j2, dest: /etc/nginx/nginx.conf }
  notify: 重启 Nginx
- name: 启动 Nginx 服务
  service: { name: nginx, state: started, enabled: yes }
EOF

cat > roles/nginx/handlers/main.yml <<EOF
- name: 重启 Nginx
  service: { name: nginx, state: restarted }
EOF

cat > roles/nginx/templates/nginx.conf.j2 <<EOF
user nginx;
worker_processes auto;
events { worker_connections 1024; }
http {
  server {
    listen {{ nginx_port }};
    root /usr/share/nginx/html;
    index index.html;
  }
}
EOF

# 主剧本 site.yml
- name: 部署 Nginx 服务
  hosts: web
  become: yes
  roles:
    - nginx

ansible-playbook site.yml
```

---

## 九、Jinja2 模板

动态生成配置文件的模板语言，用于不同服务器生成有细微差异的配置文件。

```yaml
# roles/nginx/vars/main.yml
nginx_user: nginx
web_root: /usr/share/nginx/html
run_env: prod
web_sites:
  - { name: blog,  port: 8081 }
  - { name: shop,  port: 8082 }
  - { name: admin, port: 8083 }
```
```jinja
{# roles/nginx/templates/nginx.conf.j2 #}
user {{ nginx_user }};   {# 变量调用 #}
worker_processes auto;
events { worker_connections 1024; }
http {
    include mime.types;
    {% if run_env == "prod" %}    {# if 判断：生产/测试不同 #}
    sendfile on;
    keepalive_timeout 65;
    {% else %}
    sendfile off;
    keepalive_timeout 10;
    {% endif %}
    {% for site in web_sites %}    {# for 循环：批量站点 #}
    server {
        listen {{ site.port }};
        server_name {{ site.name }};
        root {{ web_root }}/{{ site.name }};
        index index.html;
    }
    {% endfor %}
}
```

---

## 十、进阶语法

- **Tags 标签**：`tags: install` 只执行安装任务；`ansible-playbook nginx.yml --tags config` / `--skip-tags install`。
- **错误处理**：`ignore_errors: yes`（忽略错误继续）；`failed_when`（自定义失败条件）；`block/rescue/always`（类似 try/catch/finally）。
- **Debug**：`debug: { var: ansible_default_ipv4.address }`。
- **批量优化**：`-f 10`（并行 10 台）；`--limit @/root/ansible_failed.retry`（只跑失败主机）。

---

## 十一、生产实战项目

### 标准目录
```
ansible_production/
├── roles/
│   ├── init_server/     # 服务器初始化
│   ├── web_deploy/      # Web 应用部署
│   └── config_manage/   # 统一配置管理
├── inventory/hosts
├── site.yml
└── vars/global.yml
```

### 1. init_server 角色
```yaml
# vars/main.yml
base_packages: [vim, wget, curl, net-tools, tree, lrzsz]

# tasks/main.yml
- name: 加载全局变量
  include_vars: ../../vars/global.yml
- name: 修改主机名
  hostname: { name: "{{ hostname_prefix }}-{{ inventory_hostname_short }}" }
- name: 关闭防火墙
  service: { name: firewalld, state: stopped, enabled: no }
- name: 临时关闭SELinux
  command: setenforce 0
  ignore_errors: yes
- name: 永久关闭SELinux
  lineinfile: { path: /etc/selinux/config, regexp: '^SELINUX=', line: 'SELINUX=disabled' }
- name: 配置阿里云YUM源
  yum_repository: { name: aliyun, baseurl: "http://mirrors.aliyun.com/centos/$releasever/os/$basearch/", gpgcheck: no }
- name: 安装基础软件
  yum: { name: "{{ item }}", state: present }
  loop: "{{ base_packages }}"
- name: 创建运维用户
  user: { name: "{{ ops_user }}", state: present, shell: /bin/bash }
- name: 配置sudo免密
  lineinfile: { path: /etc/sudoers, line: '{{ ops_user }} ALL=(ALL) NOPASSWD: ALL', validate: 'visudo -cf %s' }
- name: SSH加固-修改端口
  lineinfile: { path: /etc/ssh/sshd_config, regexp: '^#Port|^Port', line: "Port {{ ssh_port }}" }
- name: SSH加固-禁止root登录
  lineinfile: { path: /etc/ssh/sshd_config, regexp: '^PermitRootLogin', line: 'PermitRootLogin no' }
  notify: 重启SSH服务
# handlers/main.yml
- name: 重启SSH服务
  service: { name: sshd, state: restarted }
```

### 2. web_deploy 角色
```yaml
# tasks/main.yml
- name: 加载全局变量
  include_vars: ../../vars/global.yml
- name: 安装Nginx
  yum: { name: nginx, state: present }
- name: 安装PHP
  yum: { name: [php, php-fpm, php-mysqlnd], state: present }
- name: 安装MySQL
  yum: { name: mariadb-server, state: present }
- name: 创建站点目录
  file: { path: /usr/share/nginx/html, state: directory, mode: 0755 }
- name: 部署测试页面
  copy: { content: "<?php phpinfo(); ?>", dest: /usr/share/nginx/html/index.php }
- name: 配置Nginx代理
  template: { src: nginx.conf.j2, dest: /etc/nginx/conf.d/default.conf }
  notify: 重启Nginx
- name: 启动Nginx/PHP/MySQL
  service: { name: "{{ item }}", state: started, enabled: yes }
  loop: [nginx, php-fpm, mariadb]
# templates/nginx.conf.j2
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

### 3. config_manage 角色
```yaml
# tasks/main.yml
- name: 配置hosts文件
  lineinfile: { path: /etc/hosts, line: "{{ hostvars[item].ansible_host }} {{ item }}", state: present }
  loop: "{{ groups.all }}"
- name: 创建日志清理定时任务
  cron: { name: "clean logs", minute: "0", hour: "3", job: "/usr/bin/find /var/log -name '*.log' -mtime +7 -delete" }
- name: 推送时区配置
  copy: { content: "Asia/Shanghai", dest: /etc/timezone }
  notify: 同步时区
# handlers/main.yml
- name: 同步时区
  command: timedatectl set-timezone Asia/Shanghai
```

### 执行与最佳实践
```bash
cd ansible_production
ansible-playbook -i inventory/hosts site.yml
```
**最佳实践**
- 所有 Ansible 代码提交 Git（dev → test → main 分支）。
- 公共变量放 `global.yml`，角色私有变量放 `vars/main.yml`，敏感密码用 **ansible-vault** 加密。
- 优先用原生模块，避免滥用 shell/command（保障幂等性）。
- 禁用 root 远程登录、改 SSH 端口、密钥登录、密码加密。
- 所有任务加 `name`，定期备份项目目录，生产前 `--check` 干跑。

---

## 十二、内置变量速查

### 主机清单类
| 变量 | 作用 | 例子 |
| --- | --- | --- |
| `groups` | 所有分组字典 | `groups.all` / `groups.web` |
| `hostvars` | 所有主机变量合集 | `hostvars[item].ansible_default_ipv4.address` |
| `inventory_hostname` | 清单中的主机名 | `192.168.1.100` / `web01` |
| `inventory_hostname_short` | 主机名短格式 | `100` |
| `ansible_host` | 连接 IP | `192.168.1.100` |
| `ansible_port` | SSH 端口 | `22` / `2233` |
| `ansible_user` | 登录用户 | `root` / `opsuser` |

### 系统 Facts 类
| 变量 | 作用 | 例子 |
| --- | --- | --- |
| `ansible_os_family` | 系统家族 | `RedHat` / `Debian` |
| `ansible_distribution` | 系统名称 | `CentOS` / `Ubuntu` |
| `ansible_distribution_version` | 系统版本 | `7` / `8` / `20.04` |
| `ansible_default_ipv4.address` | 默认网卡 IP | `192.168.1.100` |
| `ansible_memtotal_mb` | 总内存 | `1823` |
| `ansible_processor_vcpus` | CPU 核数 | `2` / `4` |
| `ansible_hostname` | 系统主机名 | `localhost.localdomain` |

### 任务/执行类
| 变量 | 作用 | 例子 |
| --- | --- | --- |
| `item` | 循环内置变量 | `loop` 遍历时自动赋值 |
| `play_hosts` | 当前 Play 生效主机 | `[192.168.1.100, ...]` |
| `role_path` | 当前角色路径 | `/opt/ansible/roles/nginx` |
| `ansible_play_hosts` | 当前执行所有主机 | 同 play_hosts |
| `ansible_date_time` | 系统当前时间 | 日志/备份文件名 |

```bash
ansible web -m debug -a "var=groups"      # 查清单变量
ansible web -m setup                       # 查全部 facts（最全）
```

---

## 常见面试题

1. **Ansible 的特点？**
   无客户端、基于 SSH、YAML 配置、幂等性、轻量、无需数据库。

2. **什么是幂等性？为什么重要？**
   重复执行结果一致，保证环境一致、避免人工出错。

3. **Ad-hoc 与 Playbook 区别？**
   Ad-hoc 单行临时命令（简单一次性）；Playbook 是 YAML 脚本（复杂可重复）。

4. **Roles 的作用？**
   把 Playbook 按功能模块化，提升复用性与可维护性。

5. **Ansible 工作原理？**
   控制节点 SSH 免密登录被控节点，推送模块与参数到远端执行，执行完删临时文件。

6. **command 与 shell 区别？**
   command 不支持管道/重定向（默认模块）；shell 支持，功能强但有安全风险。

7. **变量优先级？**
   命令行 `-e` > 变量文件 > Playbook vars > Inventory 变量。

8. **生产环境怎么管理密码？**
   用 `ansible-vault` 加密敏感变量，绝不明文写代码；禁用 root 远程登录、改 SSH 端口、密钥登录。

---

> 更新：2026-05-14 17:46:12
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/xdvhpn>
