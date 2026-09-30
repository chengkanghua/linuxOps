# SSH 核心知识

## 一、SSH 基本概述

**SSH（Secure Shell Protocol）**：数据传输前先用加密技术对联机数据包加密，确保传递数据安全。默认端口 22。

### 六大功能
1. **安全远程登录**：替代 Telnet 明文登录，全程加密，远程操控服务器终端
2. **安全文件传输**：内置 `scp`/`sftp`，加密上传下载，防窃听篡改
3. **端口转发 / 隧道穿透**：`-L` 本地转发、`-R` 远程转发、`-D` 动态代理，实现内网穿透、跳板机、隐藏真实 IP
4. **远程执行命令**：无需交互登录，直接远程单机/批量执行命令、脚本，方便自动化
5. **图形界面转发（X11）**：远程运行服务端图形程序，画面渲染到本地
6. **连接复用**：长连接复用，一次认证后短时内秒连，免重复输密码/验密钥

### 远程连接方式对比
| 类型 | 方式 | 说明 |
| --- | --- | --- |
| 命令行 | SSH | 主流标准，加密跨平台（Linux/Win11/Mac） |
| 命令行 | Telnet | 明文传输，不安全，**生产禁用** |
| 命令行 | IPMI/Console 串口 | 物理底层远程，系统崩了也能进 |
| 图形桌面 | RDP / VNC / XRDP | Windows/Linux 图形远程桌面 |
| 文件类 | SFTP/SCP / FTP / Samba | SSH 加密传文件 / 局域网共享 |
| Web 式 | WebSSH / 堡垒机 / 面板 | 浏览器连服务器、统一审计管控 |

### SSH vs Telnet
- SSH 是**加密**协议；Telnet 是**明文**协议
- Telnet 默认**不支持 root 直接登录**

> **案例（wireshark 验证）**：装 `telnet-server` → `systemctl start telnet.socket`，用普通用户 `od` 登录，wireshark 抓 vmnet8 上 telnet 流量可看到明文账号密码；而 SSH 抓到的全是密文。

```bash
# telnet 探测端口
telnet 10.0.0.41 22
ss -lntup | grep 22
nmap -p 22 10.0.0.41
nc 10.0.0.41 22

# SSH 连不上时的分层排查
服务端：22端口是否打开、防火墙是否放行
客户端：
  ping 127.0.0.1     # 检查TCP/IP协议栈/网卡
  ping 对端IP        # 排查交换机
  ping 网关          # 数据包能否抵达路由器
  ping 域名          # 检查DNS
```

---

## 二、SSH 相关命令

SSH 是 C/S 架构：`openssh-server`（服务端）、`openssh-clients`（客户端）。

```bash
rpm -ql openssh-server       # /etc/ssh/sshd_config(配置)  /usr/sbin/sshd(进程)
rpm -ql openssh-clients      # /usr/bin/{scp,sftp,ssh,ssh-copy-id}
```

### 1. ssh 远程登录
```bash
ssh -p22 root@10.0.0.150 [命令]
# -p 指定端口（默认22可省）；@前为用户名，@后为服务器IP
# 不登录直接执行命令：
ssh root@172.16.1.41 "hostname -i"
```

### 2. scp 远程拷贝（全量）
```bash
# 推（上传）
scp -P22 -rp /tmp/oldboy oldboy@10.0.0.150:/tmp
# 拉（下载）
scp -P22 -rp root@10.0.0.7:/tmp/oldboy /opt/
#   -r 递归目录  -p 保持属性  -P 端口  -l 限速(kb) 例: -l 1024
# 结论：scp 每次全量拷贝，效率低；适合临时少量文件
```

### 3. sftp 交互传输
```bash
sftp root@192.168.56.12
sftp> get conf.txt /tmp/      # 下载
sftp> put /root/t1.txt /root/ # 上传
# 特性：支持批量、单文件>4G、断点续传（对应图形工具 XFTP）
```

---

## 三、密钥认证（核心）

### 原理
- **非对称加密握手 + 对称加密传输**
  1. 客户端发起连接，服务端返回自己的公钥
  2. 客户端生成随机会话密钥，用服务端公钥加密发送
  3. 服务端用私钥解密得到会话密钥
  4. 后续所有数据用**对称会话密钥**（AES）加密传输，密钥仅存内存，下次重连重新算

> **密钥认证过程**：`ssh-keygen` 生成私钥+公钥一对；`ssh-copy-id` **首次必须输服务器密码**推送公钥；之后免密登录。
> - 服务器 `~/.ssh/authorized_keys` 存所有允许免密的客户端公钥
> - 客户端 `~/.ssh/known_hosts` 存服务器主机公钥（`/etc/ssh/ssh_host_*.pub`）
> - 权限：`.ssh` 目录 `700`，`authorized_keys`/`私钥` 文件 `600`

```bash
ssh-keygen -t ed25519 -C xuliangwei.com      # 推荐，比 RSA 更安全更快
ls ~/.ssh/                                    # id_ed25519(私钥)  id_ed25519.pub(公钥)
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@172.16.1.31
ssh root@172.16.1.41                          # 免密登录

# 验证服务端指纹（防中间人）
ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub            # SHA256
ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub -E md5     # MD5
```

### 练习案例
```bash
# 1. 一把钥匙开多把锁（A钥匙 → BC锁）
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.31
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.41

# 2. 多把钥匙开一把锁（BC钥匙 → A锁）
ssh-keygen -t rsa -C nfs@linux.com && ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.61
ssh-keygen -t rsa -C backup@linux.com && ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.1.61

# 3. 从A分发文件到BC
scp -rp /tmp/yum.log root@172.16.1.31:/tmp
scp -rp /tmp/yum.log root@172.16.1.41:/tmp

# 4. 批量查看所有机器 load/CPU/Memory
cat > test.sh <<'EOF'
#!/usr/bin/bash
[ $# -ne 1 ] && echo "输入执行的命令" && exit 1
for i in 31 41; do
  echo "########## 172.16.1.$i ##########"
  ssh root@172.16.1.$i "$1"
done
EOF
sh test.sh "free -h"
```

### 批量分发公钥（免交互）
```bash
ssh-keygen -t rsa -C xuliangwei.com
yum install sshpass -y
for i in 5 6 7 8 9 31 41 51 52 53 61 71; do
  sshpass -p 1 ssh-copy-id -o "StrictHostKeyChecking no" root@172.16.1.$i
done
# 注意：生产严禁明文密码，sshpass 仅内网测试用
```

**Windows 密钥登录**：Xshell 生成密钥 → 服务器 `~/.ssh`(700) 下建 `authorized_keys`(600) → 粘贴公钥 → 登录方式选 Public Key。

---

## 四、免密登录完整流程（深度）

### 阶段 1：建立加密通道（前 6 步明文）
1. TCP 三次握手建立明文连接
2. 互换 SSH 版本号（`SSH-2.0-OpenSSH_8.0`）；互发明文随机数 `Client-Rand` / `Server-Rand`
3. 协商加密/签名/哈希算法组合
4. 服务端**明文**发送主机公钥 `/etc/ssh/ssh_host_*.pub`
5. 客户端校验 `known_hosts`：无记录弹指纹→yes 存入；一致放行；不一致报错断开
6. 客户端生成随机**预主密钥**，用服务端公钥加密发送；服务端用主机私钥解密

### 阶段 2：派生会话密钥
- `会话密钥 = KDF(预主密钥 + Client-Rand + Server-Rand + SHA256)`
- 预主密钥立即销毁，会话密钥仅存内存；从第 8 步起**全程 AES 对称加密**

### 阶段 3：用户认证（免密核心）
9. 服务端发**加密**随机挑战串
10. 客户端用**本地用户私钥**对挑战串签名（私钥绝不外传）
11. 客户端发回签名；服务端用 `authorized_keys` 公钥验签
12. 验签通过 → 免密登录成功

### 阶段 4：正常交互
13. 进入 Shell，命令与结果全走 AES 加密
14. 断开后内存清空会话密钥，下次重连重新随机

> **要点**：随机数/主机公钥/算法列表全程明文不怕抓包；只把"预主密钥"用服务器公钥加密防中间人；两套密钥互不干扰——主机密钥做身份校验+协商，用户密钥做免密签名。

---

## 五、常用操作与参数

```bash
ssh user@remote-ip                 # 默认22端口
ssh -p 2222 user@remote-ip         # 指定端口
ssh -i /path/key user@remote-ip    # 指定私钥
ssh -v user@remote-ip              # 调试模式，排障必备

# 高频参数
-N   不执行远程命令（专用于端口转发）
-f   后台运行
-T   不分配伪终端
-X   启用 X11 转发（远程图形）
-o StrictHostKeyChecking=no        # 自动接受主机公钥（脚本常用）
-t   强制伪终端（远程跑 top/vim/sudo 必须加）
```

---

## 六、高级功能

### 1. 端口转发（隧道）【超高频】
| 类型 | 命令 | 作用 | 场景 |
| --- | --- | --- | --- |
| 本地转发 `-L` | `ssh -L 3306:192.168.1.100:3306 user@跳板` | 本地端口流量转发到远端内网服务 | 本机访问跳板身后的 3306 |
| 远程转发 `-R` | `ssh -R 8080:127.0.0.1:80 user@公网` | 远端端口流量反向转发到本地 | 内网穿透，外网访问内网 Web |
| 动态转发 `-D` | `ssh -D 1080 user@remote` | 本地起 SOCKS5 代理 | 走跳板上网、访问内网 |

```bash
ssh -fN -L 3306:10.0.0.2:3306 root@10.0.0.4   # 本机:3306 = 10.0.0.2:3306
ssh -R 8080:127.0.0.1:80 user@public-ip        # 公网:8080 = 内网:80
ssh -fNT -D 1080 user@jump-ip                   # 本地开 SOCKS5 代理
# 浏览器/工具配置 socks5://127.0.0.1:1080 即可
```

### 2. 跳板机登录
```bash
# 旧方法
ssh -o ProxyCommand="ssh -W %h:%p user@jump" user@target
# 新方法（SSH 7.3+，推荐）
ssh -J user@jump user@target
ssh -J 跳板1,跳板2,跳板3 目标机        # 多节点链式跳板
```

### 3. SSH 代理转发（不用复制私钥到跳板）
```bash
ssh-add                 # 私钥加入本地 ssh-agent
ssh -A user@jump-server # 启用代理转发
# 在跳板上直接 ssh user@target，无需密码
```

### 4. 连接复用（解决断连、重复输密码）
```bash
# ~/.ssh/config
Host *
  ControlMaster auto
  ControlPath ~/.ssh/%h_%p_%r.sock
  ControlPersist 1h     # 退出终端后台保活1小时（yes=永久）
```
> 用途：批量操作服务器秒连无延迟。

### 5. 远程批量执行
```bash
ssh user@IP "ls -l /root"      # 单命令
ssh user@IP < test.sh           # 执行本地脚本
for ip in 10.0.0.1 10.0.0.2; do ssh user@$ip "reboot"; done
```

---

## 七、配置文件与安全加固（面试必问）

```bash
# 服务端
vim /etc/ssh/sshd_config         # 改完须重启 sshd
# 客户端
vim /etc/ssh/ssh_config          # 全局
vim ~/.ssh/config                # 用户级
```

### 服务端关键加固项
```bash
Port 2222                       # 1. 修改默认端口，减少暴力破解
PermitRootLogin no              # 2. 禁止 root 直接登录（重要）
PasswordAuthentication no       # 3. 关闭密码认证，仅允许密钥（重要）
PubkeyAuthentication yes        # 4. 启用密钥认证
AllowUsers alice bob            # 5. 白名单，只允许指定用户
# DenyUsers eviluser            #    或黑名单
ClientAliveInterval 300         # 6. 300秒无操作断开
ClientAliveCountMax 2
MaxAuthTries 3                  # 7. 最多3次尝试
PermitEmptyPasswords no         # 8. 禁止空密码
UseDNS no                       # 9. 关闭DNS解析，加快登录
```

### 其他安全措施
- 使用 **fail2ban** 自动封禁暴力破解 IP
- 定期检查 `/var/log/secure`（CentOS）或 `/var/log/auth.log`（Ubuntu）
- 禁用 SSH1，只用 SSH2
- 定期轮换密钥，强密码保护私钥

---

## 八、常见故障排查
1. **连接超时**：防火墙（iptables/firewalld/ufw）放 22、云安全组、网络连通性
2. **连接被拒绝**：sshd 未启动、端口错、SELinux 阻止
3. **权限错误（最常见）**：`.ssh` 目录 `700`、`authorized_keys`/`私钥` `600`
4. **Host key verification failed**：服务器公钥变更，删 `known_hosts` 对应条目
5. **免密不生效**：检查权限、公钥是否正确上传、sshd 是否允许密钥认证

---

## 九、面试 TOP10 高频

1. **SSH 工作原理？加密过程？**
   版本协商→算法协商→密钥交换生成临时会话密钥→身份认证→加密传输。先用非对称加密协商出随机会话密钥，再用对称加密传业务数据，哈希校验完整性防篡改。

2. **密码认证 vs 密钥认证？**
   密码：输账号密码，易被爆破/劫持；密钥：本地公私钥配对，私钥不传输无法爆破，更安全。

3. **如何配置免密登录？**
   `ssh-keygen` 生成密钥 → 公钥传入目标 `~/.ssh/authorized_keys` → 权限设 `.ssh` 700、`authorized_keys` 600 → 直接 ssh 免密。

4. **端口转发三类型与场景？**
   `-L` 本机访问内网服务；`-R` 内网穿透让外网访问内网；`-D` SOCKS5 全局代理。

5. **生产如何加固 SSH（5 点+）？**
   改端口、禁 root 登录、关密码仅密钥、限制用户白名单、空闲断开、防火墙限源 IP。

6. **连接失败如何排查？**
   ping 测网络→telnet 测端口→`ssh -v` 调试→查文件权限→清 known_hosts→看 sshd 日志。

7. **为何 .ssh 要 700、authorized_keys 要 600？**
   SSH 安全机制禁止权限过宽，防他人读取/篡改密钥与授权文件，权限不对直接免密失效。

8. **known_hosts 作用？**
   首次连接保存服务器公钥指纹，下次比对防中间人伪装服务器。

9. **如何通过跳板机登录内网？**
   先登跳板再 ssh 内网；`ssh -J 跳板 目标`；或 `~/.ssh/config` 配好跳板别名一键登录。

10. **scp 与 rsync 区别？**
    scp 全量覆盖不支持增量；rsync 增量同步、断点续传、压缩、保留权限，适合大文件/定时备份。

### 附：经典面试题
- **进程名 mongo，查对应端口**：`ss -lntup | grep mongo`
- **给定端口查服务**：`ss -lntup|grep 22` / `lsof -i:22` / `grep -w 22 /etc/services` / `nmap -p 22 host`
- **用户访问网站原理**：DNS 解析→TCP 三次握手→HTTP 请求→服务器响应→TCP 四次挥手

---

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/mcqvrw>
