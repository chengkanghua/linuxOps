# 第七章·自动化运维工具-Ansible roles

推荐文档 : <http://ansible.com.cn/docs/playbooks_loops.html#nested-loops>

官方文档

<https://docs.ansible.com/ansible/latest/collections/ansible/builtin/cron_module.html>

中文版:

<https://docs.ansible.org.cn/ansible-core/devel/collections/ansible/builtin/cron_module.html#ansible-collections-ansible-builtin-cron-module>

## Ansible Roles基本概述

`roles`不管是Ansible还是saltstack，我在写一键部署的时候，都不可能把所有的步骤全部写入到一个'剧本'文件当中，我们肯定需要把不同的工作模块，拆分开来，解耦，那么说到解耦，我们就需要用到`roles`官方推荐，因为`roles`的目录结构层次更加清晰。

例如：我们之前推荐大家写一个`base.yml`里面写所有基础优化的项目，其实把所有东西摞进去也是很鸡肋的，不如我们把这些功能全部拆分开，谁需要使用，就调用即可。

建议：每个roles最好只使用一个tasks这样方便我们去调用，能够很好的做到解耦。（SOA）

## Ansible Roles目录结构

**1.官方推荐最佳实践目录结构定义方式**

<!-- OCR_START -->
production
#inventory file for production servers
staging
#inventory file for staging environment
group_vars/
groupl.yml
#here we assign variables to particular groups
host_vars/
hostnamel.yml
#here we assign variables to particular systems
library/
#ifany custom modules,put them here(optional)
module_utils/
#if any custom module_utils to support modules,put them here (optional)
filter_plugins/
#if anycustom filterplugins,put them here（optional)
site.yml
#masterplaybook
webservers.yml
#playbook for webserver tier
dbservers.yml
#playbook for dbserver tier
roles/
common/
#this hierarchy represents a"role"
tasks/
main.yml
tasks file can include smaller files ifwarranted
handlers/
handlers file
templates/
<--
files for use with thetemplateresource
ntp.conf.j2
templatesendin.j2
files/
bar.txt
files for usewith thecopyresource
foo.sh
<-
script filesfor use with the script resource
vars/
variablesassociatedwith this role
defaults/
defaultlowerpriorityvariablesfor thisrole
meta/
roledependencies
#roles can also include custom modules
#roles can also include custom module_utils
lookup_plugins/
#or other types of plugins,likelookup in thiscase
webtier/
#same kind ofstructure ascommonwas above,done for the webtier role
monitoring/
fooapp/
1111
曾老湿
<!-- OCR_END -->

```yaml
production                # inventory file for production servers
staging                   # inventory file for staging environment
group_vars/
   group1.yml             # here we assign variables to particular groups
   group2.yml
host_vars/
   hostname1.yml          # here we assign variables to particular systems
   hostname2.yml
library/                  # if any custom modules, put them here (optional)
module_utils/             # if any custom module_utils to support modules, put them here (optional)
filter_plugins/           # if any custom filter plugins, put them here (optional)
site.yml                  # master playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier
roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case
    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```

**2.roles目录结构使用galaxy创建**

```yaml
[root@m01 ~]# cd /etc/ansible/roles/
[root@m01 roles]# ansible-galaxy init wordpress
[root@m01 roles]# tree -d 1 wordpress/
wordpress/           #项目名称
├── defaults        #低优先级变量
├── files           #存放文件
├── handlers        #触发器文件
├── meta            #依赖关系文件
├── tasks           #工作任务文件
├── templates       #jinja2模板文件
├── tests           #测试文件
└── vars            #变量文件
```

## Ansible Roles依赖关系

`roles`允许你再使用roles时自动引入其他的roles。role依赖关系存储在roles目录中meta/main.yml文件中。

例如：推送wordpress并解压，前提条件，必须要安装nginx和php，把服务跑起来，才能运行wordpress的页面，此时我们就可以在wordpress的roles中定义依赖nginx和php的roles

```yaml
[root@m01 roles]# vim /etc/ansible/roles/wordpress/meta/main.yml
dependencies:
  - { role: nginx }
  - { role: php }
```

如果编写了meta目录下的main.yml文件，那么Ansible会自动先执行meta目录中main.yml文件中的dependencies文件，如上所示，就会先执行nginx和php的安装。

## Ansible Roles最佳实践

***

| roles小技巧 |
| --- |

1.创建`roles`目录结构，手动使用`ansible-galaxy init test`

2.编写`roles`功能

3.在`playbook`中引用

***

### 使用roles重构rsync

*1.规划目录结构如下*

```bash
[root@m01 rsync]# cd /etc/ansible/roles/
[root@m01 roles]# ansible-galaxy init rsync
- Role rsync was created successfully
[root@m01 roles]# tree rsync
rsync
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml

```

*2.定义roles主机清单*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/hosts 
[backup]
172.16.1.41
```

*3.指定backup主机组，执行那个roles*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/site.yml
- hosts: backup
  remote_user: root
  roles:
    - rsync
```

*4.查看rsync角色的tasks任务*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/rsync/tasks/main.yml 
- name: Install Rsync Server
  yum: name=rsync state=present
- name: Configure Rsync Server
  copy:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    mode: "{{ item.mode }}"
  with_items:
    - {src: "rsyncd.conf", dest: "/etc/rsyncd.conf", mode: "0644"}
    - {src: "rsync.passwd", dest: "/etc/rsync.passwd", mode: "0600"}
  notify: Restart Rsync Server
- name: Start Rsync Server
  systemd:
    name: rsyncd
    state: started
    enabled: yes
```

*5.查看rsync角色的handlers*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/rsync/handlers/main.yml 
- name: Restart Rsync Server
  service:
    name: rsyncd
    state: restarted
    
```

*6.查看rsync角色的files目录*

```yaml
cat > /etc/ansible/roles/rsync/files/rsyncd.conf <<EOF
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
secrets file = /etc/rsync.passwd
log file = /var/log/rsyncd.log
#####################################
[backup]
comment = welcome to oldboyedu backup!
path = /backup
EOF

echo "rsync_backup:zls" >/etc/ansible/roles/rsync/files/rsync.passwd
chmod 600 /etc/ansible/roles/rsync/files/rsync.passwd

[root@m01 roles]#  ll /etc/ansible/roles/rsync/files/
total 8
-rw-r--r-- 1 root root 322 Nov 16 18:49 rsyncd.conf
-rw------- 1 root root  20 Nov 16 18:30 rsync.passwd

```

*8.执行roles，使用-t指定执行测试rsync角色*

```yaml
[root@m01 roles]# ansible-playbook -i hosts  -t rsync site.yml 
PLAY [backup] ********************************************************************************************
TASK [Gathering Facts] ********************************************************************************
ok: [172.16.1.41]
TASK [backup : Install Rsync Server] ***********************************************************************
ok: [172.16.1.41]
TASK [backup : Configure Rsync Server] *********************************************************************
ok: [172.16.1.41]
TASK [backup : Start Rsync Server] *************************************************************************
ok: [172.16.1.41]
PLAY RECAP ********************************************************************************************
172.16.1.41                : ok=5    changed=0    unreachable=0    failed=0

#真实执行
[root@ansible roles]# ansible-playbook -i hosts   site.yml

```

***

### 使用roles重构nfs

***1.使用roles创建Nfs服务, 目录结构如下***

```bash
cd /etc/ansible/roles/
ansible-galaxy init nfs
[root@m01 roles]# tree /etc/ansible/roles
├── group_vars
│   └── all
├── hosts
├── nfs
│   ├── files
│   ├── handlers
│   │   └── main.yml
│   ├── tasks
│   │   └── main.yml
│   ├── templates
│   │   └── exports
│   └── vars
├── site.yml
```

*2.定义roles主机清单*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/hosts 
[nfs]
172.16.1.31
```

*3.指定nfs主机组，执行那个roles*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/site.yml 
- hosts: nfs
  remote_user: root
  roles:
    - nfs
  tags: nfs
```

*4.查看nfs角色的tasks任务*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/nfs/tasks/main.yml 
- name: Install Nfs-Server
  yum:
    name: nfs-utils
    state: present
- name: Configure Nfs-Server
  template:
    src: exports
    dest: /etc/exports
  notify: Restart Nfs-Server
- name: Create Directory Data
  file:
    path: "{{ share_dir }}"
    state: directory
    owner: www
    group: www
    mode: 0755
- name: Start Nfs-Server
  systemd:
    name: nfs
    state: started
    enabled: yes
```

*5.查看nfs角色的handlers*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/nfs/handlers/main.yml 
- name: Restart Nfs-Server
  systemd:
    name: nfs
    state: restarted
```

*6.查看rsync角色的files目录*

```yaml
[root@m01 roles]# cat /etc/ansible/roles/nfs/templates/exports 
{{ share_dir }} {{ share_ip }}(rw,sync,all_squash,anonuid=666,anongid=666)

```

*7.nfs对应的变量定义*

```yaml
mkdir -p /etc/ansible/roles/group_vars
[root@m01 roles]# cat /etc/ansible/roles/group_vars/all 
#nfs
share_dir: /data
share_ip: 172.16.1.31
```

*8.执行roles，使用-t指定执行nfs标签*

```yaml
[root@m01 roles]# ansible-playbook -i hosts  -t nfs site.yml 
PLAY [nfs] ********************************************************************************************
TASK [Gathering Facts] ********************************************************************************
ok: [172.16.1.31]
TASK [nfs : Install Nfs-Server] ***********************************************************************
ok: [172.16.1.31]
TASK [nfs : Configure Nfs-Server] *********************************************************************
ok: [172.16.1.31]
TASK [nfs : Create Directory Data] ********************************************************************
ok: [172.16.1.31]
TASK [nfs : Start Nfs-Server] *************************************************************************
ok: [172.16.1.31]
PLAY RECAP ********************************************************************************************
172.16.1.31                : ok=5    changed=0    unreachable=0    failed=0

ansible-playbook -i hosts site.yml 

```

## ansible Galaxy

Galaxy是一个免费网站，类似于github网站，网站上基本都是共享roles，从Galaxy下载roles是最快启动项目方式之一。

Galaxy官方网站:[TP](https://galaxy.ansible.com/)      <https://galaxy.ansible.com/ui/>

ansible提供了一个命令ansible-galaxy，可以用来对roles项目进行初始化，查找，安装，移除等操作

```yaml
[root@m01 roles]# ansible-galaxy --help
Usage: ansible-galaxy [delete|import|info|init|install|list|login|remove|search|setup] [--help] [options] ...
Perform various Role related operations.
Options:
  -h, --help            show this help message and exit
  -c, --ignore-certs    Ignore SSL certificate validation errors.
  -s API_SERVER, --server=API_SERVER
                        The API server destination
  -v, --verbose         verbose mode (-vvv for more, -vvvv to enable
                        connection debugging)
  --version             show program's version number, config file location,
                        configured module search path, module location,
                        executable location and exit
 See 'ansible-galaxy <command> --help' for more information on a specific
command.
```

***

| 使用galaxy搜索项目 |
| --- |

```yaml
[root@m01 roles]# ansible-galaxy search openvpn
Found 103 roles matching your search:
 Name                                      Description
 ----                                      -----------
 AdrienKuhn.fail2ban                       Configure fail2ban jails
 AdrienKuhn.ufw                            Configure firewall with UFW
 alexiscangelosi.openvpn                   Ansible role openvpn
 andrelohmann.easy_rsa                     ansible galaxy role to deploy easy-rsa
 andrelohmann.openvpn                      ansible galaxy role to deploy an openvpn server
 antoniobarbaro.openvpn-client             Install openvpn client, configure and start service
 arillso.openvpn                           Configurate your OpenVPN Client
 asm0dey.ansible_role_openvpn              OpenVPN playbook for CentOS/Fedora/RHEL/RHEL clones & Ubuntu/Debian
 barbudone.pritunl_server                  Pritunl for EL Linux.
 blaet.openvpn                             OpenVPN playbook for CentOS/Fedora/RHEL/RHEL clones & Ubuntu/Debian
 bmcclure.pia                              Manages Private Internet Access VPN utilizing the AUR and openvpn on Archlinux
 borkenpipe.ansible_openvpn                OpenVPN with PKI for Ubuntu/Debian
 borkenpipe.openvpn                        Install OpenVPN for us with AWS bastions.
 borkenpipe.stouts_openvpn                 Manage OpenVPN server
 cinject.openvpn                           Openvpn role
 clvx.easy-rsa                             Role to generate an openvpn pki.
 clvx.openvpn                              Role to deploy server and openvpn clients.
 cornfeedhobo.openvpn                      Install and manage OpenVPN
 d3atiq.openvpn_client                     A role for automatic managed connection to OpenVPN VPN.
 danrabinowitz.openvpn_for_access          This role provisions an OpenVPN server. This server is NOT designed for routing all traffic from the client. It is for granting access to the server, so that ssh (for example) can be allowed ONLY
 dresden-weekly.openvpn                    collection of Ansible roles to run OpenVPN.
 edeckers.openvpn-ldap                     Installs an OpenLDAP backed OpenVPN-server
 egeneralov.openvpn                        Provision openvpn servers
 ehime.openvpn                             OpenVPN playbook for CentOS/Fedora/RHEL/RHEL clones & Ubuntu/Debian
 escapace.ansible_openvpn                  openvpn role
 gavika.easy_rsa                           Install and configure EasyRSA
 gavika.openvpn                            Role to install and configure OpenVPN server and generate client configurations
 gregorydulin.ansible_role_openvpn         OpenVPN playbook for CentOS/Fedora/RHEL/RHEL clones & Ubuntu/Debian
 grycap.openvpn                            Install OpenVPN to create hybrid clusters with EC3
 iamsudipt.openvpn                         OpenVpn ansible role for creating a secure tunnel to your private infra.
 icasimpan.ansible_role_openvpn            OpenVPN playbook for CentOS/Fedora/RHEL/RHEL clones & Ubuntu/Debian
 ieguiguren.nordvpn                        downloads NordVPN servers' list and set it up
 indigo-dc.openvpn                         Install OpenVPN to create hybrid clusters with EC3
 indix.openvpn-ops                         This repo can be used to create a openvpn server.
 iroquoisorg.openvpn                       manage openvpn server
 iroquoisorg.openvpn_client                install openvpn client
 jtyr.openvpn                              Role which helps to install and configure OpenVPN server.
 juju4.openvpnclient                       setup openvpn as client
 kbrebanov.openvpn                         Installs and configures OpenVPN
 kbrebanov.openvpn_as                      Installs and configures OpenVPN Access Server
 kharkevich.pritunl                        Deploy pritunl: Enterprise Distributed OpenVPN and IPsec Server.
 kostyrevaa.openvpn                        Installs and configures openvpn client
 kyl191.openvpn                            OpenVPN playbook for CentOS/Fedora/RHEL/RHEL clones & Ubuntu/Debian
 leafnode.openvpn_client                   install openvpn client
 linuxhq.iproute                           RHEL/CentOS - Advanced IP routing and network device configuration tools
 linuxhq.openvpn_client                    RHEL/CentOS - The Open Source VPN (client)
 
 
```

2.查看详细信息

```yaml
[root@m01 roles]# ansible-galaxy info kostyrevaa.openvpn
Role: kostyrevaa.openvpn
        description: Installs and configures openvpn client
        active: True
        commit:
        commit_message:
        commit_url:
        company:
        created: 2015-08-17T18:13:15.551754Z
        download_count: 20
        forks_count: 0
        github_branch: master
        github_repo: ansible-openvpn
        github_user: kostyrev
        id: 4798
        imported: None
        is_valid: True
        issue_tracker_url: https://github.com/kostyrevaa/ansible-openvpn/issues
        license: license (GPLv3)
        min_ansible_version: 1.2
        modified: 2018-04-13T06:31:20.195475Z
        open_issues_count: 0
        path: (u'/root/.ansible/roles', u'/usr/share/ansible/roles', u'/etc/ansible/roles')
        role_type: ANS
        stargazers_count: 0
        travis_status_url:
```

3.安装项目

```yaml
[root@m01 roles]# ansible-galaxy install kyl191.openvpn
- downloading role 'openvpn', owned by kyl191

```

> 更新: 2024-09-29 12:20:34  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/mdn2v4>