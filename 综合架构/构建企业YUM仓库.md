# 构建企业 YUM仓库

构建企业 YUM仓库

![1547293629675-eec3181c-e4f6-4d14-ae32-ae317dd83efe.png](img/%E6%9E%84%E5%BB%BA%E4%BC%81%E4%B8%9AYUM%E4%BB%93%E5%BA%93-01.png)

本地光盘提供基础软件包`Base` 

yum缓存提供`update`软件包

yum缓存提供常用软件包: `nginx`, `zabbix`, `docker`, `saltstack`

**环境准备**

| 系统 | IP | 角色 | 主机名 |
| --- | --- | --- | --- |
| centos7.4_x86_64 | 192.168.69.112 | yum仓库服务端 | yum_server_69_112 |
| centos7.4_x86_64 | 192.168.69.113 | yum仓库客户端 | yum_client_69_113 |

# 服务端配置

1.基础环境准备

```bash
#关闭防火墙
systemctl stop firewalld
#临时关闭selinux
setenforce 0
#安装ftp服务,启动并加入开机启动
yum -y install vsftpd
systemctl start vsftpd
systemctl enable vsftpd
#开启yum缓存功能
sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf
yum clean all
yum makecache
```

2.提供基础`base`源

```bash
mkdir /var/ftp/centos75
mount /dev/cdrom /mnt
cp -rp  /mnt/Packages/*.rpm /var/ftp/centos75
```

3.提供第三方源

```bash
mkdir /var/ftp/ops
yum -y install nginx docker
//复制已缓存的 Nginx docker 及依赖包 到自定义 YUM 仓库目录中
find /var/cache/yum/x86_64/7/ -iname "*.rpm" -exec cp -rf {} /var/ftp/ops \;

```

4.安装`createrepo`并创建 `reopdata`仓库

```bash
//安装createrepo
yum -y install createrepo
//生成仓库信息
createrepo /var/ftp/ops
createrepo /var/ftp/centos75
//注意: 如果此仓库每次新增软件则需要重新生成一次
```

# 客户端使用yum源

1.配置并使用`base`基础源

```bash
gzip /etc/yum.repos.d/*
cat > /etc/yum.repos.d/centos7.repo <<EOF
[centos75]
name=centos74_base
baseurl=ftp://172.16.1.250/centos75
gpgcheck=0
EOF
```

2.客户端指向本地`ops`源

```bash
cat > /etc/yum.repos.d/ops.repo<<EOF
[ops]
name=local ftpserver
baseurl=ftp://172.16.1.250/ops
gpgcheck=0
EOF

yum clean all
yum makecache
yum -y install nginx docker
```


> 更新: 2024-08-29 21:30:36  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/suhw0p>