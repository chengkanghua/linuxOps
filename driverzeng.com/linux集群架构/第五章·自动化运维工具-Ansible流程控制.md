# 第五章·自动化运维工具-Ansible流程控制

## playbook条件语句

不管是`shell`还是各大编程语言中，流程控制，条件判断这些都是必不可少的，在我们使用`Ansible`的过程中，条件判断的使用频率极其高。

例如：

1.我们使用不同的系统的时候，可以通过判断系统来对软件包进行安装。

2.在`nfs`和`rsync`安装过程中，客户端服务器不需要推送配置文件，之前我们都是写多个play，会影响效率。

3.我们在源码安装nginx的时候，执行第二遍就无法执行了，此时我们就可以进行判断是否安装过。

| 根据不同的操作系统安装apache |
| --- |

官方示例：

```yaml
tasks:
  - name: "shut down Debian flavored systems"
    command: /sbin/shutdown -t now
    when: ansible_facts['os_family'] == "Debian"
    # note that all variables can be used directly in conditionals without double curly braces
```

```yaml
- hosts: web_group
  tasks:
    - name: Install CentOS Httpd
      yum:
        name: httpd
        state: present
    #官方
      when: ansible_facts['os_family'] == "CentOS"
    #非官方
      when: ansible_distribution == "CentOS"
    - name: Install Ubuntu Httpd
      yum:
        name: apache2
        state: present
      when: ansible_facts['os_family'] == "Ubuntu"
```

***

| 还可以使用括号对条件进行分组 |
| --- |

```yaml
tasks:
  - name: "shut down CentOS 6 and Debian 7 systems"
    command: /sbin/shutdown -t now
    when: (ansible_facts['distribution'] == "CentOS" and ansible_facts['distribution_major_version'] == "6") or
          (ansible_facts['distribution'] == "Debian" and ansible_facts['distribution_major_version'] == "7")
          
          
          
```

| 也可以指定多条件为列表 |
| --- |

```yaml
tasks:
  - name: "shut down CentOS 6 systems"
    command: /sbin/shutdown -t now
    when:
      - ansible_facts['distribution'] == "CentOS"
      - ansible_facts['distribution_major_version'] == "6"
      
```

***

| 条件运算 |
| --- |

```yaml
tasks:
  - shell: echo "only on Red Hat 6, derivatives, and later"
    when: ansible_facts['os_family'] == "RedHat" and ansible_facts['lsb']['major_release']|int >= 6
    
```

***

| rsync服务端推送配置文件 |
| --- |

```yaml
[root@m01 ~]# cat rsyncd/rsyncd.yml
- hosts: rsync_server
  tasks:
    - name: Install Rsyncd Server
      yum:
        name: rsync
        state: present
    - name: Create www Group
      group:
        name: www
        gid: 666
    - name: Create www User
      user:
        name: www
        group: www
        uid: 666
        create_home: false
        shell: /sbin/nologin
    - name: Scp Rsync Config
      copy:
        src: ./rsyncd.j2
        dest: /etc/rsyncd.conf
        owner: root
        group: root
        mode: 0644
      when: ansible_hostname == "backup"
    - name: Create Passwd File
      copy:
        content: 'rsync_backup:123'
        dest: /etc/rsync.passwd
        owner: root
        group: root
        mode: 0600
      when: ansible_hostname == "backup"
    - name: Create backup Directory
      file:
        path: /backup
        state: directory
        mode: 0755
        owner: www
        group: www
        recurse: yes
      when: ansible_hostname == "backup"
    - name: Start Rsyncd Server
      systemd:
        name: rsyncd
        state: started
      when: ansible_hostname == "backup"
      
```

***

| rsync客户端推送脚本 |
| --- |

```yaml
[root@m01 ~]# vim rsync.yml
- hosts: rsync_server
  tasks:
    - name: SCP Backup Shell
      copy:
        src: ./backup.sh
        dest: /root/backup.sh
      when: ansible_hostname is match "web*"
#执行结果
PLAY [rsync_server] **************************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************
ok: [web02]
ok: [backup]
ok: [web01]
TASK [SCP Backup Shell] **********************************************************************************************************************************************************************************************************************
skipping: [backup]
changed: [web01]
changed: [web02]
PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
backup                     : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
web01                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

***

| 通过register将命令执行结果保存至变量，然后通过when语句进行判断 |
| --- |

```yaml
- hosts: web_group
  tasks:
    - name: Check Httpd Server
      command: systemctl is-active httpd
      ignore_errors: yes
      register: check_httpd
    - name: debug outprint
      debug: var=check_httpd
    - name: Httpd Restart
      service:
        name: httpd
        state: restarted
      when: check_httpd.rc == 0
      
```

## playbook循环语句

在之前的学习过程中，我们经常会有传送文件，创建目录之类的操作，创建2个目录就要写两个file模块来创建，如果要创建100个目录，我们需要写100个file模块？？？妈耶~~~~ 当然不是，只要有循环即可，减少重复性代码。

| 启动多个服务 |
| --- |

```yaml
- hosts: web_group
  tasks:
    - name: start service
      systemd:
        name: "{{ item }}"
        state: started
      with_items:
        - httpd
        - php-fpm
        - mariadb
```

***

| 定义变量循环 |
| --- |

```yaml
- name: ensure a list of packages installed
  yum:
    name: "{{ packages }}"
  vars:
    packages:
    - httpd
    - httpd-tools
```

```yaml
- hosts: web_group
  tasks:
    - name: ensure a list of packages installed
      yum: name= "{{ item }}" state=present
      with_items:
        - httpd
        - httpd-tools
```

***

| 字典循环 |
| --- |

1.创建用户

```yaml
[root@m01 ~]# cat loop.yml
- hosts: web_group
  tasks:
    - name: Add Users
      user:
        name: "{{ item.name }}"
        groups: "{{ item.groups }}"
        state: present
      with_items:
        - { name: 'zls', groups: 'linux' }
        - { name: 'egon', groups: 'python' }
```

2.拷贝文件

```yaml
- hosts: web_group
  tasks:
    - name: copy conf and code
      copy:
        src: "{{ item.src }}"
        dest: "{{ item.dest }}"
        mode: "{{ item.mode }}"
      with_items:
        - { src: "./httpd.conf", dest: "/etc/httpd/conf/", mode: "0644" }
        - { src: "./upload_file.php", dest: "/var/www/html/", mode: "0600" }
```

## playbook handlers

***

| 什么是handlers? |
| --- |

`handler`用来执行某些条件下的任务，比如当配置文件发生变化的时候，通过notify触发handler去重启服务。

在saltstack中也有类似的触发器，写法相对Ansible简单，只需要watch，配置文件即可。

***

| 实践案例 |
| --- |

```yaml
[root@m01 ~]# cat handler.yml 
- hosts: web_group
  vars:
    - http_port: 8080
  tasks:
    - name: Install Http Server
      yum:
        name: httpd
        state: present
    - name: config httpd server
      template:
        src: ./httpd.j2
        dest: /etc/httpd/conf
      notify: 
        - Restart Httpd Server
        - Restart PHP Server
    - name: start httpd server
      service:
        name:httpd
        state: started
        enabled: yes
  handlers:
    - name: Restart Httpd Server
      systemd:
        name: httpd
        state: restarted 
    - name: Restart PHP Server
      systemd:
        name: php-fpm
        state: restarted
```

**练习：多个nginx配置文件的推送及触发器**

***

**注意：**

1.无论多少个task通知了相同的handlers，handlers仅会在所有tasks结束后运行一次。

2.Handlers只有在其所在的任务被执行时，才会被运行；如果一个任务中定义了notify调用Handlers，但是由于条件判断等原因，该任务未被执行，那么Handlers同样不会被执行。

3.Handlers只会在每一个play的末尾运行一次；如果想在一个playbook中间运行Handlers，则需要使用meta模块来实现。例如： -meta: flush_handlers。

4.如果一个play在运行到调用Handlers的语句之前失败了，那么这个Handlers将不会被执行。我们可以使用meta模块的--force-handlers选项来强制执行Handlers，即使Handlers所在的play中途运行失败也能执行。

5.不能使用handlers替代tasks

***

## playbook任务标签

默认情况下，Ansible在执行一个playbook时，会执行playbook中定义的所有任务，Ansible的标签(tag)功能可以给单独任务甚至整个playbook打上标签，然后利用这些标签来指定要运行playbook中的个别任务，或不执行指定的任务。

| 打标签的方式 |
| --- |

1.对一个task打一个标签

2.对一个task打多个标签

3.对多个task打一个标签

***

| 打完标签如何使用 |
| --- |

-t:执行指定的tag标签任务

\--skip-tags:执行--skip-tags之外的标签任务

***

| 使用-t指定tag |
| --- |

```yaml
[root@m01 m01]# cat tag.yml 
- hosts: web_group
  vars:
    - http_port: 8080
  tasks:
    - name: Install Http Server
      yum:
        name: httpd
        state: present
      tags: 
        - install_httpd
        - httpd_server
    - name: configure httpd server
      template:
        src: ./httpd.j2
        dest: /etc/httpd/conf/httpd.conf
      notify: Restart Httpd Server
      tags: 
        - config_httpd
        - httpd_server
    - name: start httpd server
      service:
        name: httpd
        state: started
        enabled: yes
      tags: service_httpd
  handlers:
    - name: Restart Httpd Server
      systemd:
        name: httpd
        state: restarted 
[root@m01 m01]# ansible-playbook tag.yml --list-tags
[root@m01 m01]# ansible-playbook tag.yml -t httpd_server
[root@m01 m01]# ansible-playbook tag.yml -t install_httpd,confiure_httpd
[root@m01 m01]# ansible-playbook tag.yml --skip-tags httpd_server
```

## playbook文件复用

在之前写playbook的过程中，我们发现，写多个playbook没有办法，一键执行，这样我们还要单个playbook挨个去执行，很鸡肋。所以在playbook中有一个功能，叫做`include`用来动态调用task任务列表。

<!-- OCR_START -->
- name:create file1
- hosts:all
- command:touch filel
- remote_user:root
- f20.yml
- tasks:
- -include_tasks:f20.yml
- -include_tasks:f21.yml
- -name:createfile2
- f21.yml
<!-- OCR_END -->

￼

只调用task：`include_tasks`

调用整个task文件：`include` （新版本：import_playbook）

在saltstack中，叫做`top file`入口文件。

**示例一：**

```yaml
[root@m01 m01]# cat task.yml 
- hosts: web_group
  vars:
    - http_port: 8080
  tasks:
    - include_tasks: task_install.yml
    - include_tasks: task_configure.yml
    - include_tasks: task_start.yml
  handlers:
    - name: Restart Httpd Server
      systemd:
        name: httpd
        state: restarted
        
[root@m01 m01]# cat task_install.yml 
- name: Install Http Server
  yum:
    name: httpd
    state: present
    
[root@m01 m01]# cat task_configure.yml 
- name: configure httpd server
  template:
    src: ./httpd.j2
    dest: /etc/httpd/conf/httpd.conf
  notify: Restart Httpd Server
  
[root@m01 m01]# cat task_start.yml 
- name: start httpd server
  service:
    name: httpd
    state: started
    enabled: yes
    
```

**示例二**

```yaml
- include: httpd.yml
- include: nfs.yml
- include: rsync.yml
```

**示例三**

```yaml
- import_playbook: httpd.yml
- import_playbook: nfs.yml
- import_playbook: rsync.yml

```

## playbook忽略错误

默认playbook会检测task执行的返回状态，如果遇到错误则会立即终止playbook的后续task执行，然鹅有些时候playbook即使执行错误了也要让其继续执行。

加入参数：ignore_errors:yes 忽略错误

```yaml
[root@m01 ~]# cat ignore.yml
---
- hosts: web_group
  tasks:
    - name: Ignore False
      command: /bin/false
      ignore_errors: yes
      
    - name: touch new file
      file:
        path: /tmp/zls.txt
        state: touch
        
```

## playbook错误处理

如上所述，当task执行失败时，playbook将不再继续执行，包括如果在task中设置了handler也不会被执行。

但是我们可以采取强制措施...

***

| 强制调用handler |
| --- |

```yaml
[root@m01 ~]# cat handler.yml 
- hosts: web_group
  vars:
    - http_port: 8080
  force_handlers: yes
  tasks:
    - name: config httpd server
      template:
        src: ./httpd.j2
        dest: /etc/httpd/conf
      notify: 
        - Restart Httpd Server
        - Restart PHP Server
    - name: Install Http Server
      yum:
        name: htttpd
        state: present
    - name: start httpd server
      service:
        name:httpd
        state: started
        enabled: yes
  handlers:
    - name: Restart Httpd Server
      systemd:
        name: httpd
        state: restarted 
    - name: Restart PHP Server
      systemd:
        name: php-fpm
        state: restarted
```

***

| 抑制changed |
| --- |

被管理主机没有发生变化，可以使用参数将change状态改为ok

```yaml
[root@m01 ~]# cat handler.yml 
- hosts: web_group
  vars:
    - http_port: 8080
  force_handlers: yes
  tasks:
    - name: shell
      shell: netstat -lntup|grep httpd
      register: check_httpd
      changed_when: false
    - name: debug
      debug: msg={{ check_httpd.stdout.lines }}
```

```yaml
[root@m01 project2]# cat changed_when.yml 
- hosts: webservers
  vars:
    - http_port: 8080
  tasks:
    - name: configure httpd server
      template:
        src: ./httpd.j2
        dest: /etc/httpd/conf/httpd.conf
      notify: Restart Httpd Server
    - name: Check HTTPD
      shell: /usr/sbin/httpd -t
      register: httpd_check
      changed_when: 
        - httpd_check.stdout.find('OK')
        - false
    - name: start httpd server
      service:
        name: httpd
        state: started
        enabled: yes
  handlers:
    - name: Restart Httpd Server
      systemd:
        name: httpd
        state: restarted
```

\*\*	解释： \*\*

在您提供的 Ansible playbook `changed_when.yml` 中，`changed_when` 关键字用于控制任务的 `changed` 状态。`changed` 状态表示任务对目标系统做了实际的更改。默认情况下，如果任务执行了任何操作，它就会被标记为 `changed`。但是，通过 `changed_when`，你可以定义更复杂的条件来决定任务是否应该被标记为 `changed`。

让我们逐个分析这个 playbook 中的 `changed_when` 示例：

```plain
yaml

取消自动换行

复制

- name: Check HTTPD
  shell: /usr/sbin/httpd -t
  register: httpd_check
  changed_when: 
    - httpd_check.stdout.find('OK')
    - false
```

解释：

1.**任务定义**: 这个任务使用 `shell` 模块执行命令 `/usr/sbin/httpd -t`，该命令用于测试 Apache HTTP 服务器的配置文件是否有语法错误。

2.**注册变量**: 执行结果被注册到变量 `httpd_check` 中，这样可以在后续的步骤中使用。

3.

**changed_when 条件**:

```
- `<font style="color:rgb(88, 113, 162);background-color:rgb(247, 248, 249);">httpd_check.stdout.find('OK')</font>`<font style="color:rgb(20, 21, 26);">: 这个条件检查</font><font style="color:rgb(20, 21, 26);"> </font>`<font style="color:rgb(88, 113, 162);background-color:rgb(247, 248, 249);">httpd_check</font>`<font style="color:rgb(20, 21, 26);"> </font><font style="color:rgb(20, 21, 26);">变量的</font><font style="color:rgb(20, 21, 26);"> </font>`<font style="color:rgb(88, 113, 162);background-color:rgb(247, 248, 249);">stdout</font>`<font style="color:rgb(20, 21, 26);">（命令的输出）中是否包含字符串 "OK"。如果包含，说明配置文件没有错误。</font>
- `<font style="color:rgb(88, 113, 162);background-color:rgb(247, 248, 249);">false</font>`<font style="color:rgb(20, 21, 26);">: 这个条件始终为假。</font>
```

`changed_when` 关键字接受一个列表，列表中的每个元素都是一个布尔表达式。如果列表中任何一个表达式的结果为真（true），则任务会被标记为 `changed`。在这个例子中，由于列表中包含 `false`，无论 `httpd_check.stdout.find('OK')` 的结果如何，`changed_when` 的结果都将为假（false），意味着这个任务永远不会被标记为 `changed`。

这种设置通常用于以下情况：

* 你希望任务总是返回 `ok` 状态，即使它实际上执行了某些操作。
* 你希望避免因为任务的执行而触发不必要的后续任务或通知。

> 更新: 2024-09-24 18:51:51  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/qcfrdb>