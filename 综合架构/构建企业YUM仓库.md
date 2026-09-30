# 构建企业 YUM 仓库

通过 FTP + `createrepo` 搭建内网统一 YUM 仓库，解决无外网/带宽受限环境下批量装软件的问题。

**组成**
- 本地光盘 → 提供基础软件包 `Base`
- YUM 缓存 → 提供 `update` 更新包
- YUM 缓存 → 提供常用软件包：`nginx`、`zabbix`、`docker`、`saltstack`

**环境准备**

| 系统 | IP | 角色 | 主机名 |
| --- | --- | --- | --- |
| centos7.4_x86_64 | 192.168.69.112 | yum 仓库服务端 | yum_server_69_112 |
| centos7.4_x86_64 | 192.168.69.113 | yum 仓库客户端 | yum_client_69_113 |

## 服务端配置

**1. 基础环境**
```bash
systemctl stop firewalld
setenforce 0
yum -y install vsftpd
systemctl start vsftpd && systemctl enable vsftpd

# 开启 yum 缓存（保留下载的 rpm）
sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf
yum clean all && yum makecache
```

**2. 提供基础 base 源**
```bash
mkdir /var/ftp/centos75
mount /dev/cdrom /mnt
cp -rp /mnt/Packages/*.rpm /var/ftp/centos75
```

**3. 提供第三方源**
```bash
mkdir /var/ftp/ops
yum -y install nginx docker
# 复制已缓存的 nginx/docker 及依赖包到自定义仓库
find /var/cache/yum/x86_64/7/ -iname "*.rpm" -exec cp -rf {} /var/ftp/ops \;
```

**4. 安装 createrepo 生成 repodata**
```bash
yum -y install createrepo
createrepo /var/ftp/ops
createrepo /var/ftp/centos75
# 注意：仓库每次新增软件需重新 createrepo 一次
```

## 客户端使用

**1. 配置 base 基础源**
```bash
gzip /etc/yum.repos.d/*
cat > /etc/yum.repos.d/centos7.repo <<EOF
[centos75]
name=centos74_base
baseurl=ftp://172.16.1.250/centos75
gpgcheck=0
EOF
```

**2. 指向本地 ops 源**
```bash
cat > /etc/yum.repos.d/ops.repo <<EOF
[ops]
name=local ftpserver
baseurl=ftp://172.16.1.250/ops
gpgcheck=0
EOF

yum clean all && yum makecache
yum -y install nginx docker
```

---

## 面试题

1. **企业内部为什么要自建 YUM 仓库？**
   统一软件版本、避免重复下载、内网无外网也能批量装机、便于合规审计。

2. **`createrepo` 的作用？**
   扫描 rpm 目录生成 `repodata` 元数据，客户端 `yum` 才能识别依赖关系、解析安装。

3. **为什么开启 `keepcache=1`？**
   保留下载的 rpm 到 `/var/cache/yum`，便于收集成自定义仓库（如 ops 源）。

4. **仓库新增软件后为什么要重新 `createrepo`？**
   `repodata` 元数据不会自动更新，新增 rpm 后必须重建才能让客户端看到。

5. **baseurl 可用哪些协议？**
   `ftp://`、`http://`、`file://`（本地目录）。

---

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/suhw0p>
