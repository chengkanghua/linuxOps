# phpMyAdmin 配合 Nginx 与 PHP 安装

## 1. 概况

phpMyAdmin 是网页端图形化操作 MySQL 的工具（本文用 4.8.3）。在 Web 集群中，数据库常独立部署在一台机器，而管理员希望在管理机上通过 Web 界面操作数据库——把 phpMyAdmin 装在管理机（10.0.0.61），实际操作的是数据库机（10.0.0.51）的数据。

**环境**
- phpMyAdmin-4.8.3-all-languages、PHP 7.1、Nginx 1.14、MySQL 5.7、CentOS 7.5
- 管理机 10.0.0.61：装 nginx / php / phpMyAdmin
- 数据库机 10.0.0.51：装 MySQL 5.7

**步骤概览**
1. 管理机装 PHP 7.1（webtatic 源）
2. 管理机装 Nginx 1.14（官方源）
3. 数据库机装 MySQL 5.7（官方源）
4. 数据库机授权远程连接账号
5. 管理机下载 phpMyAdmin 4.8.3
6. 简单优化 PHP / Nginx
7. 配置 Nginx
8. 配置 `config.inc.php`
9. 浏览器访问

## 2. MySQL 与 PHP/Nginx 简单优化

**数据库机（10.0.0.51）**
```bash
hostname -I        # 10.0.0.51 172.16.1.51
# 用初始临时密码改 root 密码
mysql -uroot -p$(awk '/temporary password/ {print $NF}' /var/log/mysqld.log) \
  --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'As4k.top';"
# 创建远程账号并授权（权限打满，仅测试）
mysql -uroot -pAs4k.top -e 'GRANT ALL PRIVILEGES ON *.* TO "as4k"@"%" IDENTIFIED BY "As4k.top";'
mysql -uroot -pAs4k.top -e "CREATE DATABASE jpress;"
```
> 登录远程数据库必须用已授权的 `as4k` 账号，**无法用 root 直接登录**。

**管理机（10.0.0.61）**
```bash
hostname -I        # 10.0.0.61 172.16.1.61
# 虚拟用户 www
groupadd -g 666 www
useradd -u666 -g666 -s /sbin/nologin -M www

# nginx 运行用户与上传大小
sed -i '/^user/c  user www;' /etc/nginx/nginx.conf
grep 'client_max_body_size' /etc/nginx/nginx.conf
[ $? -eq 1 ] && sed -i '/^http/a client_max_body_size 2048M;' /etc/nginx/nginx.conf

# php-fpm 运行用户
sed -i '/^user/c user = www' /etc/php-fpm.d/www.conf
sed -i '/^group/c group = www' /etc/php-fpm.d/www.conf

# php 上传/内存限制
sed -i '/^post_max_size/c post_max_size = 2048M' /etc/php.ini
sed -i '/^memory_limit/c memory_limit = 128M' /etc/php.ini
sed -i '/^upload_max_filesize/c upload_max_filesize = 2048M' /etc/php.ini

systemctl restart nginx && systemctl enable nginx
systemctl restart php-fpm && systemctl enable php-fpm

# 快速验证
id www
netstat -lntup | egrep 'nginx|php'
ps aux | egrep 'nginx|php'
nginx -t
systemctl status nginx | grep running
systemctl status php-fpm | grep running
```
> 注：`sed` 批量修改时一次性粘贴太多到 Xshell 可能错乱，建议一块一块复制执行。

## 3. 配置 Nginx 与 phpMyAdmin

### 1. 准备代码
```bash
mkdir -p /code && cd /code
# 官网 phpmyadmin.net 下载 phpMyAdmin-4.8.3-all-languages.zip
unzip -q phpMyAdmin-4.8.3-all-languages.zip
mv phpMyAdmin-4.8.3-all-languages phpmyadmin
```

### 2. 配置 Nginx（phpmyadmin.conf）
```nginx
server {
    listen 3307;
    server_name 10.0.0.61;
    root /code/phpmyadmin;
    index index.php index.html;

    location ~ \.php$ {
        root /code/phpmyadmin;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```
```bash
nginx -t
systemctl restart nginx
netstat -lntp | grep 3307
```
> 端口用 3307 仅为避开冲突，默认 80 等均可，只要不与其它服务冲突。

### 3. 配置 config.inc.php
该文件位于 `/code/phpmyadmin/`，用于配置**远程数据库**信息。可由 `10.0.0.61:3307/setup` 自动生成，也可手动编写：
```php
<?php
$i = 0;

/* Server: 172.16.1.51 */
$i++;
$cfg['Servers'][$i]['verbose'] = '';
$cfg['Servers'][$i]['host'] = '172.16.1.51';
$cfg['Servers'][$i]['port'] = 3306;
$cfg['Servers'][$i]['socket'] = '';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['user'] = 'as4k';
$cfg['Servers'][$i]['password'] = 'As4k.top';

$cfg['DefaultLang'] = 'zh_CN';
$cfg['ServerDefault'] = 1;
$cfg['blowfish_secret'] = 'b:*hP-87360)+znI#P[/fKC@fH~gvkbW';
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
?>
```
> 把 `host`/`port`/授权账号密码改成自己的即可。

### 4. 浏览器访问与常见报错

访问 `10.0.0.61:3307` 可能遇到 session 报错：phpMyAdmin 无法读取 session。检查 `/var/lib/php/session` 目录：
```bash
ls -ld /var/lib/php/session
# drwxrwx--- 2 root apache 6 ...   所属用户为 apache，与 www 不符
```
**修复**：新建并改属主为运行 PHP 的用户 www
```bash
mkdir -p /var/lib/php/session
chown -R www:www /var/lib/php/session
```
> 注意：直接把权限打满 777 或改 apache 属主并非完善方案，可能与既有服务（如 wecenter）的 session 冲突。本质多为 PHP 非官方源导致。

**扩展：登录后提示 tmp 权限问题**
```bash
cd /code/phpmyadmin
mkdir tmp && chmod 777 tmp
```

---

## 参考资料
- 官方安装帮助：<https://docs.phpmyadmin.net/en/latest/require.html>
- 作者：阿胜4K 出处：<https://www.cnblogs.com/asheng2016/p/phpmyadmin.html>

## 面试题

1. **phpMyAdmin 部署在哪、操作哪里的数据？**
   装在管理机（Nginx+PHP），通过 `config.inc.php` 指向远程数据库 IP/端口，操作的是数据库机的库。

2. **为什么连不上 root 而要用授权账号？**
   MySQL 默认 `root@localhost` 仅本机；远程连接需用 `%` 授权的独立账号（如 as4k）。

3. **phpMyAdmin 报 session 错误怎么处理？**
   确保 `/var/lib/php/session` 存在且属主为 PHP 运行用户（php-fpm 的 www），权限正确。

4. **Nginx 转发 PHP 的关键配置？**
   `location ~ \.php$` 中 `fastcgi_pass 127.0.0.1:9000` + `fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name` + `include fastcgi_params`。

5. **`blowfish_secret` 作用？**
   phpMyAdmin 用其对 cookie 认证信息进行加密，必须设置足够随机的字符串，否则报错。

---

> 更新：2026-09-30
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/yuqymc>
