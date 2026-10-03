# 第六章·自动化运维工具-Ansible Jinja2模板

## Ansible Jinja2模板概述
| 什么是jinja2模板 |
| --- |

jinja2是Python的全功能模板引擎

---

| Jinja2与Ansible啥关系 |
| --- |

Ansible通常会使用jinja2模板来修改被管理主机的配置文件等...在saltstack中同样会使用到jinja2

如果在100台主机上安装nginx，每台nginx的端口都不一样，如何解决？

---

| Ansible如何使用Jinja2 |
| --- |

使用Ansible的jinja2模板也就是使用template模块，该模块和copy模块一样，都是讲文件复制到远端主机上去，但是区别在于，template模块可以获取到文件中的变量，而copy则是原封不动的把文件内容复制过去。之前我们在推送rsync的backup脚本时，想把脚本中的变量名改成主机名，如果使用copy模块则推送过去的就是{{  ansible_fqdn }}，不变，如果使用template，则会变成对应的主机名。

---

| Ansible使用Jinja2注意事项 |
| --- |

Ansible允许jinja2模板中使用条件判断和循环，但是不允许在playbook中使用。

注意：不是每个管理员都需要这个特性，但是有些时候jinja2模块能大大提高效率。

## Ansible Jinja2模板使用
| Jinja模板基本语法 |
| --- |

```yaml
{{ EXPR }}输出变量值，会输出自定义的变量值或facts
1)playbook文件使用template模块
2)模板文件里面变量使用{{名称}}，比如{{PORT}}或使用facts
```

---

| Jinja2模板逻辑判断 |
| --- |

```yaml
#循环表达式
{% for i in EXPR %}
{% endfor %}
#条件判断
{% if EXPR %}
{% elif EXPR %}
{% else %}
{% ednif %}
#注释
{# COMMENT #}
```

---

| Jinja2示例 |
| --- |

1.编辑playbook

```yaml
[root@m01 ~]# vim jinja2.yml
- hosts: web_group
  tasks:
    - name: Copy Template File
      template:
        src: ./motd.j2
        dest: /etc/motd
```

2.准备motd.j2文件

```yaml
[root@m01 ~]# vim motd.j2
Welcome to {{ ansible_fqdn }}
This system total mem is : {{ ansible_memtotal_mb }} MB
This system free mem is: {{ ansible_memfree_mb }} MB
```

3.执行playbook

```yaml
[root@m01 ~]# ansible-playbook jinja2.yml
PLAY [web_group] *****************************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************
ok: [web02]
ok: [web01]
TASK [Copy Template File] ********************************************************************************************************************************************************************************************************************
changed: [web01]
changed: [web02]
PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
web01                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

#查看结果
[root@m01 ~]# ansible web_group -a 'cat /etc/motd'
web01 | CHANGED | rc=0 >>
Welcome to web01
This system total mem is : 1982 MB
This system free mem is: 1106 MB
web02 | CHANGED | rc=0 >>
Welcome to web02
This system total mem is : 1982 MB
This system free mem is: 1096 MB
```

该示例展示了如何利用jinja2模板使用facts变量，达到我们想要的目的，实现自动化的需求。

## Ansible Jinja2管理nginx
Ansible使用jinja2的for循环表达式渲染出nginx负载均衡的配置文件

---

| 使用playbook推送文件 |
| --- |

1.编辑playbook

```yaml
[root@m01 ~]# vim lb.yml
- hosts: lb_group
  vars:
    http_port: 80
    server_name: www.drz.com
  tasks:
    - name: copy
      template:
        src: ./www.drz.com.conf.j2
        dest: /etc/nginx/conf.d/www.drz.com.conf
      notify: reload nginx
  handlers:
    - name: reload nginx
      systemd:
        name: nginx
        state: reloaded
```

2.准备配置文件

```yaml
[root@m01 ~]# vim www.drz.com.conf.j2
upstream {{ server_name }} {
{% for n in range(21) %}
        server 172.16.1.{{ n }}:{{ up_port }};
{% endfor %}
}
server {
        listen 80;
        server_name {{ server_name }};
        location / {
                root /code;
                index index.html;
                proxy_pass http://{{ server_name }};
                proxy_set_header Host $http_host;
        }
}

```

## Ansible Jinja2管理keepalived
ansible使用jinja2模板的if判断表达式渲染出keepalived高可用配置文件，并推送到lb主机上。

---

| 推送keepalived配置文件 |
| --- |

```yaml
[root@m01 ~]# vim keepalived.yml
- hosts: lb_group
  tasks:
    - name: copy file
      template:
        src: ./keepalived.j2
        dest: /etc/keepalived/keepalived.conf
      notify: restart keepalived
  handlers:
    - name: restart keepalived
      systemd:
        name: keepalived
        state: restarted
```

---

| keepalived原配 |
| --- |

```yaml
#keepalived master 配置文件
global_defs {
    router_id lb01
}
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 50
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {         
        10.0.0.3
    }
}

#keepalived backup配置文件
global_defs {
    router_id lb02
}
vrrp_instance VI_1 {
    state BACKUP        
    interface eth0
    virtual_router_id 50
    priority 100
    advert_int 1
    authentication {    
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        10.0.0.3
    }
}
```

---

| 准备keepalived配置文件 |
| --- |

```yaml
[root@m01 ~]# vim keepalived.j2
global_defs {
    router_id {{ ansible_fqdn }}
}
vrrp_instance VI_1 {
{% if ansible_fqdn == "lb01" %}
    state MASTER
    priority 150
{% else %}
    state BACKUP
    priority 100
{% endif %}
    interface eth0
    virtual_router_id 50
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {         
        10.0.0.3
    }
}

```

**	**

 			

> 更新: 2024-09-24 18:58:12  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/qu3qwo>