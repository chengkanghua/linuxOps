# Nginx + Tomcat + HTTPS

> 本文覆盖：Tomcat 安装部署、管理、jpress 实战、多实例、反向代理集群、监控、安全/性能优化，以及 Nginx+Tomcat 的 HTTPS（SSL 卸载）全链路。

---

## 一、Tomcat 简介

Tomcat 是 Web 服务器（类似 Nginx/Apache HTTPD）：
- Nginx/Apache 只能处理**静态**资源（`.html`）。
- Nginx 配 PHP 可处理 `.php` 动态页；**Tomcat 配 JDK 可处理 `.jsp` 动态页**。
- 技术栈对应关系：Linux + Nginx + PHP + MySQL / Linux + Tomcat + JDK + MySQL(MariaDB)。

---

## 二、部署 Java 环境 + 安装 Tomcat

### 1. 安装 JDK（JDK → JVM → 一次编译到处运行）
```bash
cd /application/tools/
# 上传 jdk-8u60-linux-x64.tar.gz 和 apache-tomcat-8.0.27.tar.gz
tar xf jdk-8u60-linux-x64.tar.gz -C /application/
ln -s /application/jdk1.8.0_60 /application/jdk

cat >> /etc/profile <<'EOF'
export JAVA_HOME=/application/jdk
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
EOF
source /etc/profile

java -version
# java version "1.8.0_60"  → 部署成功
```

### 2. 安装 Tomcat
```bash
tar xf apache-tomcat-8.0.27.tar.gz -C /application/
ln -s /application/apache-tomcat-8.0.27 /application/tomcat
echo 'export TOMCAT_HOME=/application/tomcat' >> /etc/profile
source /etc/profile
chown -R root.root /application/jdk/ /application/tomcat/
```

### 3. 目录结构（重点：bin / conf / logs / webapps）
```
bin        启动/关闭脚本（startup.sh / shutdown.sh）
conf       XML 配置文件（server.xml 主配置、tomcat-users.xml 用户管理）
lib        可访问的 JAR 包
logs       Catalina 及应用日志
temp       临时文件
webapps    Web 应用根目录（ROOT 为默认站点）
work       JSP 编译出的 Servlet 的 .java/.class
```

### 4. 启动
```bash
/application/tomcat/bin/startup.sh
netstat -tunlp | grep java
# :::8009    AJP 端口（与 Apache 通信，一般用不到）
# :::8080    HTTP 业务端口
# 浏览器访问 http://10.0.0.9:8080/
```

---

## 三、Tomcat 管理（生产勿用）

管理功能默认禁用，需配 `tomcat-users.xml`：
```xml
<!-- /application/tomcat/conf/tomcat-users.xml，在 </tomcat-users> 前加 -->
<role rolename="manager-gui"/>
<role rolename="admin-gui"/>
<user username="tomcat" password="tomcat" roles="manager-gui,admin-gui"/>
```
```bash
# 若访问 manager 报 403，是 IP 受限，放开 RemoteAddrValve
# 编辑 webapps/manager/META-INF/context.xml
<Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|\d+\.\d+\.\d+\.\d+" />
/application/tomcat/bin/shutdown.sh && /application/tomcat/bin/startup.sh
# 访问 http://10.0.0.9:8080/manager/ 用账号登录
```

---

## 四、搭建 jpress（Java 版 WordPress）

```bash
# 安装数据库（db 服务器）
yum install mariadb-server -y
systemctl start mariadb
mysql -e "create database jpress default character set utf8;"
mysql -e "grant all on jpress.* to jpress@'%' identified by '123456';"
mysql -e "flush privileges;"

# 部署代码到 webapps
cd /server/tomcat-8080/webapps/
cp /tmp/jpress-web-newest.war ./
/application/tomcat/bin/shutdown.sh && /application/tomcat/bin/startup.sh
# .war 放入 webapps 后 Tomcat 会自动解压
mv jpress-web-newest jpress
# 浏览器访问 http://10.0.0.9:8080/jpress/  → 按向导安装
# 后台：http://10.0.0.9:8080/jpress/admin/login
```

---

## 五、server.xml 关键配置

```xml
<Server port="8005" shutdown="SHUTDOWN">      <!-- 关闭端口 + 暗号，向 8005 发 SHUTDOWN 即关闭 -->

<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000" redirectPort="8443" />   <!-- HTTP 业务端口 -->

<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />  <!-- 与 Apache 通信，可注释 -->

<Host name="localhost" appBase="webapps"
      unpackWARs="true" autoDeploy="true">      <!-- 自动解压/部署，生产建议 false -->
  <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
         prefix="localhost_access_log" suffix=".txt"
         pattern="%h %l %u %t &quot;%r&quot; %s %b" />
</Host>
```
```bash
# 通过 8005 端口关闭（三个 java 进程随之退出）
echo SHUTDOWN | nc 127.0.0.1 8005
```

**自定义网站目录**
```xml
<!-- 把 meminfo.jsp 直接从 ROOT 下访问，不用带二级目录 -->
<Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
  <Context path="" docBase="/application/tomcat/webapps/memtest"
           debug="0" reloadable="false" crossContext="true"/>
</Host>
# 或快速插入第 149 行后
sed -i.ori '149a <Context path="" docBase="/application/tomcat/webapps/memtest" debug="0" reloadable="false" crossContext="true"/>' conf/server.xml
```

---

## 六、Tomcat 多实例（多虚拟主机）

```bash
cd /application/tools/
tar xf apache-tomcat-8.5.34.tar.gz
cp -a apache-tomcat-8.5.34 tomcat8_1
cp -a apache-tomcat-8.5.34 tomcat8_2
cp -a apache-tomcat-8.5.34 tomcat8_3

# 每个实例改启动端口（8005→8011/8012/8013，8080→8081/8082/8083）
sed -i 's#8005#8011#;s#8080#8081#' tomcat8_1/conf/server.xml
sed -i 's#8005#8012#;s#8080#8082#' tomcat8_2/conf/server.xml
sed -i 's#8005#8013#;s#8080#8083#' tomcat8_3/conf/server.xml

tar zcf tomcat_muti.tar.gz ./tomcat8_1 ./tomcat8_2 ./tomcat8_3
mv tomcat8_1 tomcat8_2 tomcat8_3 /application/

tomcat8_1/bin/startup.sh
tomcat8_2/bin/startup.sh
netstat -lntup    # 8081 / 8082 等已监听
# 浏览器访问 http://10.0.0.9:8081/  和 8082/
```
> 多实例：在一台机器上跑多个 Tomcat，更充分利用系统资源。

---

## 七、Tomcat 反向代理集群（Nginx 前置）

```nginx
# /etc/nginx/conf.d/proxyhttps.conf（推荐放 conf.d，不要直接堆在 nginx.conf）
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
> Windows hosts 加解析后访问 `http://jpress.etiantian.org/`。

---

## 八、Tomcat 监控

```bash
# 1. 自带检测页
# 浏览器访问 http://10.0.0.3/meminfo.jsp

# 2. jps（JDK 自带，查看 JVM 进程）
jps -lvm

# 3-5. 其他工具
jstack    # 查看线程堆栈
jmap      # 内存分析
jconsole / visualvm   # 图形化监控
```
**开启远程监控（JMX）**
```bash
# tomcat8_1/bin/catalina.sh 第 109 行附近
CATALINA_OPTS="$CATALINA_OPTS
  -Dcom.sun.management.jmxremote
  -Dcom.sun.management.jmxremote.port=12345
  -Dcom.sun.management.jmxremote.authenticate=false
  -Dcom.sun.management.jmxremote.ssl=false
  -Djava.rmi.server.hostname=172.16.1.9"
shutdown.sh && startup.sh
netstat -lntup | grep 12345
# 本机多实例需保证端口不重复
# Windows：C:\Program Files\Java\jdk1.8.0_31\bin 下的 jconsole / jvisualvm 连接
```

**Zabbix 监控**
```bash
rpm -qa zabbix-java-gateway    # 需安装并配置 zabbix server 对接
```

---

## 九、安全与性能优化

### 9.1 安全优化（必会）
```bash
# 降权启动（用普通用户跑 Tomcat）
useradd tomcat
cp -a tomcat8_2 /home/tomcat/
chown -R tomcat.tomcat /home/tomcat8_2/
su - tomcat -c 'tomcat8_2/bin/startup.sh'     # 普通用户执行，也可写开机自启

# 管理端口保护（8005 关闭端口 + 暗号）
# AJP 端口保护（8009 注释掉，通常不用）
# 禁用管理端（webapps 只留一个 ROOT）
```

### 9.2 性能优化
**屏蔽 DNS 查询**
```xml
<Connector port="8081" protocol="HTTP/1.1"
  connectionTimeout="6000" enableLookups="false"
  acceptCount="800" redirectPort="8443" />
```

**JVM 调优（catalina.sh）**
```bash
JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server
  -Xms1024m -Xmx1024m -XX:NewSize=512m -XX:MaxNewSize=512m
  -XX:PermSize=512m -XX:MaxPermSize=512m"
```
| 参数 | 含义 |
| --- | --- |
| `-server` | 多 CPU 性能更佳，应作为第一个参数 |
| `-Xms` | JVM 初始堆内存（最小） |
| `-Xmx` | JVM 最大堆内存（建议与 -Xms 相同，设为物理内存一半） |
| `-XX:PermSize` / `MaxPermSize` | 永久保存区域大小 |
| `-Xmn` | 新生代 heap 大小（一般设 -Xmx 的 1/3~1/4） |
| `-Xss` | 每个线程栈大小（最佳 128K，默认偏大） |
| `-verbose:gc` / `-Xloggc:gc.log` | 输出 GC 信息到日志 |
| `-XX:+UseParNewGC` | 缩短 minor GC |
| `-XX:+UseConcMarkSweepGC` | 缩短 major GC |

---

## 十、Nginx + Tomcat 配置 HTTPS（SSL 卸载）

常规误区：很多人以为 Nginx 和 Tomcat 都要配 SSL。**最佳实践**：浏览器 ↔ Nginx 走 HTTPS，Nginx ↔ Tomcat 通过 `proxy_pass` 走普通 HTTP（SSL 卸载，减轻后端）。

### 1. 申请证书（lb01 上）
```bash
mkdir -p /etc/nginx/ssl_key && cd /etc/nginx/ssl_key/
openssl genrsa -idea -out server.key 2048      # 密码设 1234
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 \
  -keyout server.key -out server.crt
# 交互：CN / WH / WH / edu / SA / bgx / bgx@foxmail.com
```

### 2. lb01 的 proxyhttps.conf
```nginx
upstream java {
  server 172.16.1.9:8081;
}
server {
  listen 80;
  server_name jpress.etiantian.org;
  return 302 https://$server_name$request_uri;     # HTTP 强制跳 HTTPS
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
    proxy_set_header X-Forwarded-Proto https;     # 关键：告诉后端是 HTTPS
    proxy_redirect off;
    proxy_connect_timeout 240;
    proxy_send_timeout    240;
    proxy_read_timeout    240;
    proxy_pass http://java;                        # 后端仍是 HTTP
  }
}
```

### 3. Tomcat server.xml 关键配置
```xml
<Connector port="8081" protocol="HTTP/1.1"
  connectionTimeout="20000" redirectPort="443" proxyPort="443" />
<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
<Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
  <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
    remoteIpHeader="x-forwarded-for"
    remoteIpProxiesHeader="x-forwarded-by"
    protocolHeader="x-forwarded-proto"
    prefix="localhost_access_log" suffix=".txt"
    pattern="%h %l %u %t &quot;%r&quot; %s %b" />
</Host>
```
> ⚠️ **关键**：`proxyPort="443"` 和 `redirectPort="443"` 必须有，否则 Tomcat 应用里 `getScheme()` 及 web.xml 安全策略会失效。

---

## 十一、常见面试题

1. **Nginx 和 Tomcat 分别处理什么？**
   Nginx 处理静态 + 反向代理；Tomcat（配 JDK）处理 Java/JSP 动态请求。常规架构是 Nginx 前置，动态请求转发给 Tomcat。

2. **Nginx + Tomcat 怎么做 HTTPS？必须两边都配 SSL 吗？**
   不用。推荐 Nginx 做 SSL 终结（SSL 卸载）：浏览器↔Nginx 走 HTTPS，Nginx↔Tomcat 走 HTTP。Tomcat 只需设 `proxyPort="443"`、`redirectPort="443"` 并加 `X-Forwarded-Proto` 头。

3. **Tomcat 多实例有什么用？怎么做？**
   一台机器跑多个 Tomcat 充分利用资源。复制解压包、改 `server.xml` 里的 8005/8080/8009 等端口避免冲突，分别启动。

4. **Tomcat 安全优化有哪些？**
   降权启动（普通用户）、关闭/保护 8005 管理端口、注释无用 8009 AJP、webapps 仅留 ROOT、生产关闭 manager。

5. **Tomcat 性能优化主要调什么？**
   `enableLookups="false"` 屏蔽 DNS 查询；JVM 调优（`-Xms/-Xmx` 设为物理内存一半、`-Xmn` 新生代、`-Xss` 线程栈、GC 算法）。

6. **怎么监控 Tomcat？**
   jconsole/jvisualvm（JMX 远程）、jps/jstack/jmap 命令行、ROOT/meminfo.jsp 自带检测页，以及 Zabbix + java-gateway。

---

> 参考：<https://blog.oldboyedu.com/java-tomcat/>、<http://www.zyops.com/java-tomcat/>、<https://www.cnblogs.com/swbzmx/articles/8845810.html>
> 更新：2024-08-29 19:12:29
> 原文：<https://www.yuque.com/chengkanghua/oldboy50/ydrh0w>
