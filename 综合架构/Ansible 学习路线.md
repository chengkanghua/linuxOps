# Ansible 学习路线

## 最重要的前提
**Ansible 100% 基于你之前学的 SSH。**

你之前学的 SSH 免密登录、跳板机、端口转发，全都是 Ansible 的基础。Ansible 不需要在被控机器上装任何客户端，只需要被控机器开着 SSH，控制节点能通过 SSH 免密登录即可。

---

## 第一阶段：入门必学

### 1. 环境搭建
**控制节点**（自己的电脑 / 运维机）：
- 安装 Ansible：`sudo apt install ansible`（Ubuntu）或 `yum install ansible`（CentOS）
- 验证：`ansible --version`

**被控节点**（所有要管理的服务器）：什么都不用装！只需要开着 SSH。

```bash
# 生成 ED25519 密钥对（推荐，生产标准）
ssh-keygen -t ed25519 -C "运维-张三-生产环境-20260503"

# 若需兼容老旧系统（不支持 ED25519），用 RSA 4096
# ssh-keygen -t rsa -b 4096 -C "运维-张三-生产环境-20260503"
#   -t：指定密钥类型（rsa/ed25519）
#   -b：指定密钥长度（4096 位最高强度）
#   -C：给密钥加注释，方便管理

# 标准方法（自动处理权限）分发公钥
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@10.0.0.4

# 测试免密登录，此时应不需要密码
ssh root@10.0.0.4
```

**批量分发公钥**
```bash
# 方法一：把所有服务器 IP 写文件，逐个分发（会提示输入每台密码）
cat > servers.txt <<EOF
10.0.0.2
10.0.0.4
10.0.0.5
10.0.0.6
10.0.0.7
10.0.0.8
10.0.0.9
EOF
for ip in $(cat servers.txt); do
  echo "正在分发公钥到 $ip"
  ssh-copy-id -i ~/.ssh/id_ed25519.pub root@$ip
done

# 方法二：用 sshpass 免交互（仅适合内网测试，生产严禁！）
SERVERS=( "10.0.0.2" "10.0.0.4" "10.0.0.5" )
PASSWORD="1"
for ip in "${SERVERS[@]}"; do
  echo "正在分发公钥到 $ip"
  sshpass -p "$PASSWORD" ssh-copy-id -i ~/.ssh/id_ed25519.pub -o StrictHostKeyChecking=no root@$ip
done
```
> 生产环境绝对不推荐 sshpass 明文密码：① 密码明文暴露在命令行 / history / `ps aux`；② 违反安全规范；③ 无法处理密码错误、超时等异常，多密码场景难维护。

### 2. Inventory 主机清单（2 小时）
**是什么**：Ansible 的"通讯录"，记录所有服务器的 IP、分组、变量。
**为什么重要**：这是 Ansible 的入口，所有操作都基于它。

```plain
# 单独的服务器
10.0.0.2

# 分组管理（最常用）
[web]
10.0.0.7
10.0.0.8
[db]
10.0.0.9
[backup]
10.0.0.4
[nfs]
10.0.0.5

# 嵌套分组
[all:children]
web
db
```
```bash
ansible all -m ping    # 测试所有主机连通性
ansible web -m ping    # 测试 web 组
```

### 3. Ad-hoc 临时命令
**是什么**：不用写脚本，一行命令批量执行操作。
**为什么重要**：运维日常 90% 的临时批量操作（查磁盘、装软件、改密码）都用它。

```plain
ansible <主机组/主机> -m <模块名> -a "<模块参数>"
```

| 模块名 | 核心作用 | 生产常用例子 |
| --- | --- | --- |
| **ping** | 测试主机连通性 | `ansible all -m ping` |
| **command** | 执行简单远程命令（不支持管道/重定向） | `ansible web -m command -a "df -h"` |
| **shell** | 执行复杂命令（支持管道/重定向/变量） | `ansible web -m shell -a "free -h \| grep Mem"` |
| **script** | 把本地脚本传到远端执行 | `ansible web -m script -a "./deploy.sh"` |
| **copy** | 本地文件/目录复制到远端 | `ansible web -m copy -a "src=./nginx.conf dest=/etc/nginx/nginx.conf mode=644 owner=root"` |
| **file** | 创建/删除文件目录、改权限属主 | `ansible web -m file -a "path=/data/logs state=directory mode=755 owner=nginx"` |
| **service** | 管理系统服务启停/重启/自启 | `ansible web -m service -a "name=nginx state=restarted enabled=yes"` |
| **yum** | CentOS/RHEL 安装/卸载软件 | `ansible web -m yum -a "name=nginx state=present"` |
| **apt** | Ubuntu/Debian 安装/卸载软件 | `ansible web -m apt -a "name=nginx state=present update_cache=yes"` |
| **template** | 渲染 Jinja2 模板并复制（动态配置） | `ansible web -m template -a "src=./nginx.conf.j2 dest=/etc/nginx/conf.d/default.conf"` |
| **authorized_key** | 批量分发 SSH 公钥 | `ansible all -m authorized_key -a "user=root key='{{ lookup('file','~/.ssh/id_ed25519.pub') }}'"` |
| **fetch** | 从远端拉取文件到本地（copy 反向） | `ansible web -m fetch -a "src=/var/log/nginx/access.log dest=./logs/ flat=yes"` |
| **lineinfile** | 修改文件单行内容（增删改） | `ansible all -m lineinfile -a "path=/etc/hosts line='192.168.1.100 web01'"` |
| **user** | 管理系统用户 | `ansible all -m user -a "name=ops state=present groups=wheel shell=/bin/bash"` |
| **group** | 管理系统用户组 | `ansible all -m group -a "name=dev state=present"` |
| **cron** | 管理系统定时任务 | `ansible web -m cron -a "name='清理日志' minute=0 hour=3 job='/usr/bin/rm -rf /data/logs/*.log'"` |
| **setup** | 收集系统信息（facts 变量） | `ansible web -m setup -a "filter=ansible_default_ipv4"` |
| **raw** | 执行原始命令（无 Python 的老系统） | `ansible old_server -m raw -a "uptime"` |
| **mount** | 管理磁盘挂载点 | `ansible db -m mount -a "path=/data src=/dev/sdb1 fstype=xfs state=mounted"` |

> 练习：用 Ad-hoc 给所有 web 服务器安装 nginx 并启动。

### 4. Playbook 剧本基础
**是什么**：用 YAML 写的自动化脚本，把多个步骤组合，可重复执行。
**为什么重要**：复杂自动化任务（部署网站、初始化服务器）必须用 Playbook。

**YAML 语法注意（新手最易错）**
1. 用空格缩进，不能用 Tab
2. 冒号后面必须跟一个空格
3. 列表用 `-` 开头

```yaml
# nginx_install.yml
- name: 安装并启动Nginx
  hosts: web   # 对 web 组执行
  become: yes  # 用 root 权限执行

  tasks:       # 任务列表，按顺序执行
    - name: 安装Nginx
      yum:
        name: nginx
        state: present

    - name: 启动Nginx并设置开机自启
      service:
        name: nginx
        state: started
        enabled: yes
```
```bash
ansible-playbook nginx_install.yml
```

---

## 第二阶段：核心必学

### 1. Playbook 进阶语法

#### （1）变量 Variables
**是什么**：把重复的值抽出来，方便修改和复用。
**3 条规则**：① 变量名只能字母、数字、下划线；② 调用必须写 `{{变量名}}`；③ 冒号后必须有空格。
**优先级（高→低）**：命令行 `-e` > 单独变量文件 > Playbook vars > Inventory 变量。

**定义方式**
```yaml
# 方式1：Playbook 中定义
- name: 安装Nginx
  hosts: web
  vars:
    nginx_port: 80
    nginx_user: nginx
    nginx_home: /usr/share/nginx/html
  tasks:
    - name: 启动Nginx
      service:
        name: "{{ nginx_user }}"
        state: started
```
```properties
# 方式2：Inventory 中定义（不同机器不同变量）
[web]
192.168.1.100 nginx_port=8080
192.168.1.101 nginx_port=8081
```
```yaml
# 方式3：单独变量文件（企业标准）vars.yml
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
# 方式4：命令行临时覆盖
ansible-playbook nginx.yml -e "nginx_port=8080"
```

**变量类型（必须会 3 种）**
```plain
port: 80                              # 1. 普通变量
packages:                             # 2. 列表变量（数组）
  - nginx
  - mysql
  - php
nginx:                               # 3. 字典变量（key=value）
  port: 80
  user: nginx
  home: /usr/share/nginx/html
```
```yaml
# 列表循环调用
- name: 安装软件
  yum: { name: "{{ item }}", state: present }
  loop: "{{ packages }}"

# 字典调用
{{ nginx.port }}    {{ nginx.user }}
```

**实战例子**
```yaml
- name: 变量完整演示
  hosts: web
  vars:
    web_port: 80
    web_user: nginx
    web_packages:
      - nginx
      - vim
  tasks:
    - name: 批量安装 Web 服务软件
      yum: { name: "{{ item }}", state: present }
      loop: "{{ web_packages }}"
    - name: 启动 Nginx 并设置开机自启
      service: { name: nginx, state: started, enabled: yes }
```

#### （2）Handlers 触发器
**是什么**：只有当任务执行结果发生变化时才会执行的任务。
**为什么重要**：比如只有配置文件被修改了才重启服务，避免无谓重启。
```yaml
tasks:
  - name: 复制Nginx配置文件
    copy: { src: ./nginx.conf, dest: /etc/nginx/nginx.conf }
    notify: 重启Nginx
handlers:
  - name: 重启Nginx
    service: { name: nginx, state: restarted }
```

#### （3）条件判断 When
```yaml
- name: 在CentOS上安装nginx
  yum: { name: nginx, state: present }
  when: ansible_os_family == "RedHat"
- name: 在Ubuntu上安装nginx
  apt: { name: nginx, state: present }
  when: ansible_os_family == "Debian"
```

#### （4）循环 Loop
```yaml
- name: 创建多个用户
  user: { name: "{{ item }}", state: present }
  loop: [user1, user2, user3]
```

#### 2. 角色 Roles（最重要的核心）
**是什么**：把 Playbook 按功能拆分成独立模块，方便复用和维护。
**为什么重要**：Playbook 超过 100 行或多项目时，不用 Roles 会一团乱麻。一个角色 = 一个功能（nginx、mysql、docker）。

**标准目录结构**
```
roles/
  nginx/
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
> tests/ 测试目录一般删除；Roles 同级手动新建 `site.yml` 作为主剧本调用各角色。

**用法**
```bash
ansible-galaxy init ./roles/nginx
```

```bash
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

cat > ansible_demo/site.yml <<EOF
- name: 部署 Nginx 服务
  hosts: web
  become: yes
  roles:
    - nginx
EOF

ansible-playbook site.yml
```
最终结构：
```
ansible_demo/
├── roles/nginx/{vars,tasks,handlers,templates}/main.yml
└── site.yml
```

#### 3. Jinja2 模板
**是什么**：动态生成配置文件的模板语言。
**为什么重要**：不同服务器的配置文件有细微差别（端口、IP），用模板自动生成。
```yaml
# roles/nginx/vars/main.yml
nginx_user: nginx
web_root: /usr/share/nginx/html
run_env: prod                      # test/prod
web_sites:
  - { name: blog,  port: 8081 }
  - { name: shop,  port: 8082 }
  - { name: admin, port: 8083 }
```
```jinja
{# roles/nginx/templates/nginx.conf.j2 #}
user {{ nginx_user }};             {# 变量调用 #}
worker_processes auto;
events { worker_connections 1024; }
http {
    include mime.types;
    {% if run_env == "prod" %}     {# if 判断 #}
    sendfile on;
    keepalive_timeout 65;
    {% else %}
    sendfile off;
    keepalive_timeout 10;
    {% endif %}
    {% for site in web_sites %}    {# for 循环 #}
    server {
        listen {{ site.port }};
        server_name {{ site.name }};
        root {{ web_root }}/{{ site.name }};
        index index.html;
    }
    {% endfor %}
}
```
```yaml
# roles/nginx/tasks/main.yml
- name: 安装 Nginx
  yum: { name: nginx, state: present }
- name: 部署模板配置
  template: { src: nginx.conf.j2, dest: /etc/nginx/nginx.conf }
  notify: 重启 Nginx
- name: 启动 Nginx
  service: { name: nginx, state: started, enabled: yes }
```

---

## 第三阶段：进阶必学

### 1. 标签 Tags
**是什么**：给任务打标签，只执行指定标签的任务。
**为什么重要**：大 Playbook 几十上百任务，不用每次从头执行。
```yaml
tasks:
  - name: 安装Nginx
    yum: { name: nginx, state: present }
    tags: install
  - name: 配置Nginx
    template: { src: nginx.conf.j2, dest: /etc/nginx/conf.d/default.conf }
    tags: config
```
```bash
ansible-playbook nginx.yml --tags config           # 只执行配置任务
ansible-playbook nginx.yml --skip-tags install      # 跳过安装任务
```

### 2. 错误处理
- `ignore_errors: yes`：忽略错误，继续执行后续任务
- `failed_when`：自定义失败条件
- `block/rescue/always`：异常处理（类似 try/catch/finally）

### 3. 调试 Debug
```yaml
- name: 打印服务器IP
  debug: { var: ansible_default_ipv4.address }
```

### 4. 批量执行优化
- 并行执行：`ansible-playbook -f 10 nginx.yml`（同时 10 台）
- 只跑失败主机：`ansible-playbook nginx.yml --limit @/root/ansible_failed.retry`

---

## 第四阶段：生产实战

### 1. 批量初始化新服务器
修改主机名 / 关防火墙和 SELinux / 配 YUM 源 / 装基础软件（vim、wget、curl、net-tools）/ 创建运维用户并配 sudo / SSH 安全加固（禁用 root 登录、改默认端口）。

### 2. 批量部署应用
安装 Nginx / PHP / MySQL / 部署应用代码 / 配置 Nginx 反向代理 / 启动所有服务并开机自启。

### 3. 配置管理
统一管理 `/etc/hosts`、统一定时任务、统一推送配置文件并重启服务。

### 4. 最佳实践
- 所有 Playbook/Roles 用 Git 版本控制
- 变量和代码分离，不同环境用不同变量文件
- 严格遵守幂等性
- 给所有任务加清晰注释
- 定期备份 Ansible 配置

### 标准项目目录
```
ansible_production/
├── roles/
│   ├── init_server/     # 服务器初始化
│   ├── web_deploy/      # Web应用部署
│   └── config_manage/   # 统一配置管理
├── inventory/hosts      # 主机清单
├── site.yml             # 主入口剧本
└── vars/global.yml      # 全局变量
```

### 基础配置
```properties
# inventory/hosts
[web]
192.168.1.100
192.168.1.101
[db]
192.168.1.102
[all:vars]
ansible_ssh_user=root
ansible_ssh_port=22
```
```yaml
# vars/global.yml
env: prod
timezone: Asia/Shanghai
hostname_prefix: web-server
ops_user: opsuser
ssh_port: 2233
nginx_port: 80
php_version: 7.4
mysql_root_password: Root@123456
```
```yaml
# site.yml
- name: 生产环境 - 服务器初始化
  hosts: all
  become: yes
  roles: [init_server]
- name: 生产环境 - 部署Web应用
  hosts: web
  become: yes
  roles: [web_deploy]
- name: 生产环境 - 统一配置管理
  hosts: all
  become: yes
  roles: [config_manage]
```

### 角色1：服务器初始化 init_server
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

### 角色2：Web 应用部署 web_deploy
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
# handlers/main.yml
- name: 重启Nginx
  service: { name: nginx, state: restarted }
```

### 角色3：统一配置管理 config_manage
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
**企业标准**
- 代码管理：提交 Git/GitLab，分支 `dev`→`test`→`main`
- 变量规范：公共放 `global.yml`，角色私有放 `vars/main.yml`，敏感密码用 **ansible-vault** 加密
- 幂等性：尽量用原生模块，减少 shell/command
- 安全：禁用 root 远程登录、改 SSH 端口、仅密钥登录、密码加密
- 运维：任务加 `name`、定期备份、生产前 `--check` 干跑

---

## 内置变量速查

### 主机清单类
| 变量名 | 核心作用 | 实战示例 |
| :--- | :--- | :--- |
| `groups` | 所有主机分组的字典 | `groups.all` / `groups.web` |
| `hostvars` | 所有主机的变量合集 | `hostvars[item].ansible_default_ipv4.address` |
| `inventory_hostname` | 当前主机在清单中的名称 | `192.168.1.100` / `web01` |
| `inventory_hostname_short` | 主机名短格式 | `100` |
| `ansible_host` | 主机连接 IP | `192.168.1.100` |
| `ansible_port` | 主机 SSH 端口 | `22` / `2233` |
| `ansible_user` | 主机登录用户 | `root` / `opsuser` |

### 系统 Facts 类
| 变量名 | 核心作用 | 实战示例 |
| :--- | :--- | :--- |
| `ansible_os_family` | 系统家族 | `RedHat`(CentOS) / `Debian`(Ubuntu) |
| `ansible_distribution` | 系统名称 | `CentOS` / `Ubuntu` |
| `ansible_distribution_version` | 系统版本 | `7` / `8` / `20.04` |
| `ansible_default_ipv4.address` | 默认网卡 IP | `192.168.1.100` |
| `ansible_memtotal_mb` | 总内存 | `1823`（MB） |
| `ansible_processor_vcpus` | CPU 核心数 | `2` / `4` |
| `ansible_hostname` | 系统主机名 | `localhost.localdomain` |

### 任务/执行类
| 变量名 | 核心作用 | 实战示例 |
| :--- | :--- | :--- |
| `item` | 循环内置变量 | `loop` 遍历时自动赋值 |
| `play_hosts` | 当前 Play 生效主机 | `[192.168.1.100, 192.168.1.101]` |
| `role_path` | 当前角色路径 | `/opt/ansible/roles/nginx` |
| `ansible_play_hosts` | 当前执行的所有主机 | 同 play_hosts |
| `ansible_date_time` | 系统当前时间 | 日志、备份文件名 |

```bash
ansible web -m debug -a "var=groups"    # 查清单变量
ansible web -m setup                      # 查系统 Facts 全部变量（最全）
```

---

## 第五阶段：面试题（直接背）

1. **Ansible 的特点是什么？**
   无客户端、基于 SSH 通信、YAML 配置、幂等性、轻量化、无需数据库。

2. **什么是幂等性？为什么重要？**
   重复执行同一个操作结果都一样。保证环境一致性，避免人工操作出错。

3. **Ad-hoc 和 Playbook 的区别？**
   Ad-hoc 是临时单行命令，适合简单一次性操作；Playbook 是 YAML 脚本，适合复杂可重复任务。

4. **Roles 的作用是什么？**
   把 Playbook 按功能模块化，提高代码复用性和可维护性。

5. **Ansible 的工作原理是什么？**
   控制节点通过 SSH 免密登录被控节点，把模块和参数推送到被控节点执行，执行完删除临时文件。

6. **command 和 shell 模块的区别？**
   command 不支持管道、重定向等 shell 特性；shell 支持，功能更强大但有安全风险。

7. **变量优先级？**
   命令行 `-e` > 单独变量文件 > Playbook vars > Inventory 变量。

8. **生产环境如何安全管理密码？**
   用 ansible-vault 加密敏感变量；禁用 root 远程登录、改 SSH 端口、仅密钥登录，绝不明文写密码。

---

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/gntyzz>
