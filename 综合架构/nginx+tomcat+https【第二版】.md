# Nginx + Tomcat + HTTPS【第二版】

> ⚠️ 说明：本文是《nginx+tomcat+https》的**更新整理版**，核心内容（安装、jpress、多实例、反向代理、HTTPS 全链路）基本一致，仅 server.xml 配置更完整。两篇保留其一即可，建议以本版为准。
> 更新：2024-09-01 16:00:27 ｜ 原文：<https://www.yuque.com/chengkanghua/oldboy50/fuspmx>

---

## 一、Tomcat 简介

Tomcat 是 Web 服务器（类似 Nginx/Apache HTTPD）：
- Nginx/Apache 只能处理**静态**资源（`.html`）。
- Nginx 配 PHP 可处理 `.php`；**Tomcat 配 JDK 可处理 `.jsp` 动态页**。
- 技术栈：`Linux + Nginx + PHP + MySQL` / `Linux + Tomcat + JDK + MySQL(MariaDB)`。

---

## 二、部署 Java 环境 + 安装 Tomcat

### JDK
```bash
cd /application/tools/
tar xf jdk-8u60-linux-x64.tar.gz -C /application/
ln -s /application/jdk1.8.0_60 /application/jdk
cat >> /etc/profile <<'EOF'
export JAVA_HOME=/application/jdk
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
EOF
source /etc/profile
java -version      # "1.8.0_60" 即成功
```

### Tomcat
```bash
tar xf apache-tomcat-8.0.27.tar.gz -C /application/
ln -s /application/apache-tomcat-8.0.27 /application/tomcat
echo 'export TOMCAT_HOME=/application/tomcat' >> /etc/profile
source /etc/profile
chown -R root.root /application/jdk/ /application/tomcat/

# 目录结构（重点 bin/conf/logs/webapps）
# bin      启动/关闭脚本（startup.sh/shutdown.sh）
# conf     server.xml 主配置、tomcat-users.xml 用户管理
# logs     Catalina 及应用日志
# webapps  Web 应用根目录（ROOT 为默认站点）
# work     JSP 编译出的 Servlet 的 .java/.class
```

### 启动
```bash
/application/tomcat/bin/startup.sh
netstat -tunlp | grep java
# :::8009  AJP（与 Apache 通信，一般不用）
# :::8080  HTTP 业务端口
# 浏览器访问 http://10.0.0.9:8080/
```

---

## 三、Tomcat 管理（生产勿用）

```xml
<!-- /application/tomcat/conf/tomcat-users.xml，在 </tomcat-users> 前加 -->
<role rolename="manager-gui"/>
<role rolename="admin-gui"/>
<user username="tomcat" password="tomcat" roles="manager-gui,admin-gui"/>
```
```bash
# 若访问 manager 报 403（IP 受限），放开 RemoteAddrValve
# webapps/manager/META-INF/context.xml
<Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|\d+\.\d+\.\d+\.\d+" />
/application/tomcat/bin/shutdown.sh && /application/tomcat/bin/startup.sh
# 访问 http://10.0.0.9:8080/manager/ 登录
```

---

## 四、搭建 jpress（Java 版 WordPress）

```bash
# 数据库（db 服务器）
yum install mariadb-server -y
systemctl start mariadb
mysql -e "create database jpress default character set utf8;"
mysql -e "grant all on jpress.* to jpress@'%' identified by '123456';"
mysql -e "flush privileges;"

# 部署代码
cd /server/tomcat-8080/webapps/
cp /tmp/jpress-web-newest.war ./
/application/tomcat/bin/shutdown.sh && /application/tomcat/bin/startup.sh
# .war 放入 webapps 后自动解压；改名为 jpress
mv jpress-web-newest jpress
# 访问 http://10.0.0.9:8080/jpress/  → 按向导安装
# 后台：http://10.0.0.9:8080/jpress/admin/login
```

---

## 五、server.xml 关键配置

```xml
<!-- 关闭端口 + 暗号，向 8005 发 SHUTDOWN 即关闭 -->
<Server port="8005" shutdown="SHUTDOWN">

<!-- HTTP 业务端口 -->
<Connector port="8080" protocol="HTTP/1.1"
  connectionTimeout="20000" redirectPort="8443" />

<!-- 与 Apache 通信，通常注释 -->
<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />

<Host name="localhost" appBase="webapps"
  unpackWARs="true" autoDeploy="true">   <!-- 生产建议 false -->
  <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
    prefix="localhost_access_log" suffix=".txt"
    pattern="%h %l %u %t &quot;%r&quot; %s %b" />
</Host>
```
```bash
# 8005 端口关闭 Tomcat
echo SHUTDOWN | nc 127.0.0.1 8005
```

**自定义网站目录**（从 ROOT 直接访问 meminfo.jsp）
```xml
<Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
  <Context path="" docBase="/application/tomcat/webapps/memtest"
    debug="0" reloadable="false" crossContext="true"/>
</Host>
# 或快速插入
sed -i.ori '149a <Context path="" docBase="/application/tomcat/webapps/memtest" debug="0" reloadable="false" crossContext="true"/>' conf/server.xml
```

---

## 六、Tomcat 多实例

```bash
cd /application/tools/
tar xf apache-tomcat-8.5.34.tar.gz
cp -a apache-tomcat-8.5.34 tomcat8_1
cp -a apache-tomcat-8.5.34 tomcat8_2
cp -a apache-tomcat-8.5.34 tomcat8_3
# 改启动端口（8005→8011/8012/8013，8080→8081/8082/8083）
sed -i 's#8005#8011#;s#8080#8081#' tomcat8_1/conf/server.xml
sed -i 's#8005#8012#;s#8080#8082#' tomcat8_2/conf/server.xml
sed -i 's#8005#8013#;s#8080#8083#' tomcat8_3/conf/server.xml
tar zcf tomcat_muti.tar.gz ./tomcat8_1 ./tomcat8_2 ./tomcat8_3
mv tomcat8_1 tomcat8_2 tomcat8_3 /application/
tomcat8_1/bin/startup.sh && tomcat8_2/bin/startup.sh
# 浏览器访问 http://10.0.0.9:8081/ 和 8082/
```

---

## 七、Tomcat 反向代理集群（Nginx 前置）

```nginx
# /etc/nginx/conf.d/proxyhttps.conf（推荐放 conf.d）
upstream java {
  server 172.16.1.9:8081;
  server 172.16.1.9:8082;
}
server {
  listen 80;
  server_name jpress.etiantian.org;
  location / {
    proxy_pass http://java;
    include proxy_params;
  }
}
```

---

## 八、监控 / 安全 / 性能

**监控**：`jps -lvm`、`jstack`、`jmap`、`jconsole`/`jvisualvm`（JMX 远程，端口 12345），ROOT/meminfo.jsp 检测页，Zabbix + java-gateway。
**安全**：降权启动、保护/关闭 8005、注释 8009 AJP、webapps 只留 ROOT。
**性能**：`enableLookups="false"` 屏蔽 DNS；JVM 调优（`-Xms/-Xmx` 设为物理内存一半、`-Xmn` 新生代、`-Xss` 线程栈、GC 算法）。

---

## 九、Nginx + Tomcat 配置 HTTPS（SSL 卸载）

浏览器↔Nginx 走 HTTPS，Nginx↔Tomcat 走 HTTP（`proxy_pass`）。

### 1. 证书（lb01）
```bash
mkdir -p /etc/nginx/ssl_key && cd /etc/nginx/ssl_key/
openssl genrsa -idea -out server.key 2048          # 密码 1234
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 \
  -keyout server.key -out server.crt
# 交互：CN / WH / WH / edu / SA / bgx / bgx@foxmail.com
```

### 2. lb01 proxyhttps.conf
```nginx
upstream java { server 172.16.1.9:8081; }
server {
  listen 80;
  server_name jpress.etiantian.org;
  return 302 https://$server_name$request_uri;
}
server {
  listen       443 ssl;
  server_name  jpress.etiantian.org;
  ssl on;
  ssl_certificate     ssl_key/server.crt;
  ssl_certificate_key ssl_key/server.key;
  ssl_session_cache   shared:SSL:1m;
  ssl_session_timeout 5m;
  ssl_ciphers  HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;
  location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-Proto https;     # 关键
    proxy_redirect off;
    proxy_connect_timeout 240;
    proxy_send_timeout    240;
    proxy_read_timeout    240;
    proxy_pass http://java;
  }
}
```

### 3. Tomcat server.xml（完整版）
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Server port="8011" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.startup.VersionLoggerListener" />
  <Listener className="org.apache.catalina.security.SecurityListener" />
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />
  <Resource name="UserDatabase" auth="Container"
    type="org.apache.catalina.UserDatabase"
    description="User database that can be updated and saved"
    factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
    pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>
  <Service name="Catalina">
    <Connector port="8081" protocol="HTTP/1.1"
      connectionTimeout="20000" redirectPort="443" proxyPort="443" />
    <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
    <Engine name="Catalina" defaultHost="localhost">
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
          resourceName="UserDatabase"/>
      </Realm>
      <Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
          remoteIpHeader="x-forwarded-for"
          remoteIpProxiesHeader="x-forwarded-by"
          protocolHeader="x-forwarded-proto"
          prefix="localhost_access_log" suffix=".txt"
          pattern="%h %l %u %t &quot;%r&quot; %s %b" />
      </Host>
    </Engine>
  </Service>
</Server>
```
> ⚠️ **关键**：`proxyPort="443"` + `redirectPort="443"` 必须有，否则 `getScheme()` 及 web.xml 安全策略失效。

---

## 十、常见面试题

1. **Nginx + Tomcat 必须两边都配 SSL 吗？**
   不必。推荐 Nginx 做 SSL 卸载：浏览器↔Nginx 走 HTTPS，Nginx↔Tomcat 走 HTTP；Tomcat 只需设 `proxyPort="443"`、`redirectPort="443"` 并加 `X-Forwarded-Proto` 头。

2. **Tomcat 多实例怎么做？**
   复制解压包、改 `server.xml` 里的 8005/8080/8009 端口避免冲突，分别启动，充分利用单机资源。

3. **Tomcat 安全与性能优化要点？**
   安全：降权启动、关 8005、注释 8009、webapps 仅留 ROOT；性能：`enableLookups="false"`、JVM 调优（`-Xms/-Xmx/-Xmn/-Xss`、GC 算法）。

4. **怎么监控 Tomcat？**
   jconsole/jvisualvm（JMX）、jps/jstack/jmap 命令行、meminfo.jsp 检测页、Zabbix + java-gateway。

5. **server.xml 里 proxyPort/redirectPort 设成 443 的作用？**
   让 Tomcat 知道前端是 HTTPS，应用里 `getScheme()` 返回 https、web.xml 安全约束才能正确生效。

---

> 参考：<https://blog.oldboyedu.com/java-tomcat/>、<http://www.zyops.com/java-tomcat/>、<https://www.cnblogs.com/swbzmx/articles/8845810.html>
