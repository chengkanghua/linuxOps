# 第八章·自动化运维工具-Ansible Vault 加密

## Ansible Vault概述

Ansible Vault做为Ansible的一项新功能，可将例如：password，keys等敏感数据文件进行加密处理，而非存放在明文的playbook中或roles中。

## Ansible Vault实战

Ansible 加密使用的是`ansible-vault`命令进行加密，语法示例

```bash
[root@m01 ~]# ansible-vault --help
Usage: ansible-vault [create|decrypt|edit|encrypt|encrypt_string|rekey|view] [options] [vaultfile.yml]
```

***

| 加密一个文件 |
| --- |

```plain
ansible-vault encrypt include.yml
```

***

| 查看一个文件 |
| --- |

```plain
[root@m01 m01]# ansible-vault view include.yml 
Vault password: 
- import_playbook: handler.yml
- import_playbook: when.yml
```

***

| 修改加密的文件内容 |
| --- |

```plain
[root@m01 m01]# ansible-vault edit include.yml
```

***

| rekey 修改密码 |
| --- |

```plain
[root@m01 m01]# ansible-vault rekey include.yml 
Vault password: 
New Vault password: 
Confirm New Vault password: 
Rekey successful
```

***

| 执行加密的playbook |
| --- |

```plain
echo "zls" > ansible.pass
ansible-playbook include.yml  --vault-password-file=ansible.pass
```

***

> 更新: 2024-09-24 19:23:53  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/zpg6y0>