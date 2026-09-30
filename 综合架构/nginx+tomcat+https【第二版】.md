# nginx+tomcat+https【第二版】

## 1 Tomcat简介


tomcat 是一个web服务器, 类似nginx , apache的http

	nginx, http 只能处理html 等静态文件

	网页分为静态网页(以.html 或者.html 结尾的url地址) 和动态网页(伪静态)

	nginx 和http配置php 就能够处理动态的网页(.php结尾)

	tomcat 配合jdk 就能够处理动态的网页(.jsp结尾)



## 2.下载并安装Tomcat服务


JDK下载：[http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

Tomcat下载：[http://tomcat.apache.org/](http://tomcat.apache.org/)



cd /application/tools/

#上传软件包

安装jdk     jkd  --> java虚拟机(jvm)  --> 一处编译,处处使用



## 2.2 部署java环境


```bash
[root@tomcat ~]# cd /application/tools/
[root@tomcat tools]# rz

tar xf jdk-8u60-linux-x64.tar.gz -C /application/

ln -s /application/jdk1.8.0_60 /application/jdk

sed -i.ori '$a export JAVA_HOME=/application/jdk\nexport PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH\nexport CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar' /etc/profile

source /etc/profile
#→出现下面结果证明部署成功
[root@tomcat ~]# java -version
java version "1.8.0_60"
Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)
```



## 2.3 安装Tomcat


```bash
tar xf apache-tomcat-8.0.27.tar.gz -C /application/

ln -s /application/apache-tomcat-8.0.27 /application/tomcat

echo 'export TOMCAT_HOME=/application/tomcat'>>/etc/profile

source /etc/profile

chown -R root.root /application/jdk/ /application/tomcat/

[root@tomcat ~]# tail -4 /etc/profile
export JAVA_HOME=/application/jdk
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
export TOMCAT_HOME=/application/tomcat
```



## 2.4 Tomcat目录介绍   (关注点 bin conf logs webapps)


```bash
[root@tomcat ~]# cd /application/tomcat/
[root@tomcat tomcat]# tree -L 1
.
├── bin         #→用以启动、关闭Tomcat或者其它功能的脚本（.bat文件和.sh文件）
├── conf        #→用以配置Tomcat的XML及DTD文件 | server.xml 主配置文件, tomcat-users.xml 用户管理
├── lib         #→存放web应用能访问的JAR包
├── LICENSE
├── logs        #→Catalina和其它Web应用程序的日志文件
├── NOTICE
├── RELEASE-NOTES
├── RUNNING.txt
├── temp        #→临时文件
├── webapps     #→Web应用程序根目录
└── work        #→用以产生有JSP编译出的Servlet的.java和.class文件
7 directories, 4 files
[root@tomcat tomcat]# cd webapps/
[root@tomcat webapps]# ll
total 20
drwxr-xr-x 14 root root 4096 Oct  5 12:09 docs     #→tomcat帮助文档
drwxr-xr-x  6 root root 4096 Oct  5 12:09 examples #→web应用实例
drwxr-xr-x  5 root root 4096 Oct  5 12:09 host-manager #→管理
drwxr-xr-x  5 root root 4096 Oct  5 12:09 manager  #→管理
drwxr-xr-x  3 root root 4096 Oct  5 12:09 ROOT     #→默认网站根目录
```



## 2.5 启动Tomcat


```bash
#→启动程序/application/tomcat/bin/startup.sh
#→关闭程序/application/tomcat/bin/shutdown.sh

[root@tomcat ~]# /application/tomcat/bin/startup.sh
Using CATALINA_BASE:   /application/tomcat
Using CATALINA_HOME:   /application/tomcat
Using CATALINA_TMPDIR: /application/tomcat/temp
Using JRE_HOME:        /application/jdk
Using CLASSPATH:       /application/tomcat/bin/bootstrap.jar:/application/tomcat/bin/tomcat-juli.jar
Tomcat started.
[root@tomcat ~]# netstat -tunlp|grep java
tcp        0      0 :::8009        :::*           LISTEN      4743/java           
tcp        0      0 :::8080        :::*           LISTEN      4743/java    
       
[root@tomcat ~]# ps -ef|grep [j]ava
root       4743      1 17 06:10 pts/0    00:00:03 /application/jdk/bin/java -Djava.util.logging.config.file=/application/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.endorsed.dirs=/application/tomcat/endorsed -classpath /application/tomcat/bin/bootstrap.jar:/application/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/application/tomcat -Dcatalina.home=/application/tomcat -Djava.io.tmpdir=/application/tomcat/temp org.apache.catalina.startup.Bootstrap start

#访问网站 网址：http://10.0.0.9:8080/
```



## 3.2 Tomcat管理


```bash
# 通过web管理 测试功能，生产环境不要用。

Tomcat管理功能用于对Tomcat自身以及部署在Tomcat上的应用进行管理的web应用。在默认情况下是处于禁用状态的。如果需要开启这个功能，就需要配置管理用户，即配置前面说过的tomcat-users.xml。

[root@tomcat ~]# vim /application/tomcat/conf/tomcat-users.xml
…………
<role rolename="manager-gui"/>
<role rolename="admin-gui"/>
<user username="tomcat" password="tomcat" roles="manager-gui,admin-gui"/>
</tomcat-users>  #→在此行前加入上面三行

#然后重启tomcat，重新访问manager app页面，如果此时仍然出现403 Access Denied错误，那么就是访问的ip地受到了限制，
打开/webapps/manager/META-INF/目录下context.xml文件.
将里面的内容注释掉或者修改为
<Valve className="org.apache.catalina.valves.RemoteAddrValve"
allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|\d+\.\d+\.\d+\.\d+" />

[root@tomcat ~]# /application/tomcat/bin/shutdown.sh
[root@tomcat ~]# /application/tomcat/bin/startup.sh	

# 浏览器访问 管理页面10.0.0.9:8080/manager/  用配置好的账号密码登录
```





## 8 搭建jpress--java 版本的wordpress


```plain
jsp 网页
```



linux  nginx php mysql

linux  tomcat jdk mysql(mariadb)



```bash
#安装mysql  (db服务器已经安装)
yum install mariadb-server -y
systemctl start mariadb 
#创建数据库 jpress
create database jpress default characher set utf8;
# 授权 
grant all jpress.* to jpress@'%' identified by '123456';
# 刷新权限
flush privileges;


# 部署站点代码
[root@web03 ~]# cd /server/tomcat-8080/webapps/
[root@web03 webapps]# cp /tmp/jpress-web-newest.war ./
# jpress包放入webapps 目录下 重新tomcat 会发现包已经自动被解压了
[root@web03 webapps]# /server/tomcat-8080/bin/shutdown.sh
[root@web03 webapps]# /server/tomcat-8080/bin/startup.sh
# 查看
[root@web03 webapps]# ls
docs  examples  host-manager  jpress-web-newest  jpress-web-newest.war  manager  ROOT
# 目录改名 |最好删除jpress-web-newest.war 重启之后又会解压一遍
[root@web03 webapps]# mv jpress-web-newest jpress

# 浏览器访问 10.0.0.9:8080/jpress
# 进入安装界面了 按提示安装..

#安装完成 重启tomcat
[root@web03 webapps]# /server/tomcat-8080/bin/shutdown.sh
[root@web03 webapps]# /server/tomcat-8080/bin/startup.sh

网站访问
http://10.0.0.9:8080/jpress/
后台地址  账号密码是安装时候设置的
http://10.0.0.9:8080/jpress/admin/login
```



## tomcat 配置文件   conf/server.xml


```bash
	语法: 以<!-- 开头, 以-->结尾, 中间包含的都是注释, 段注释
	
[root@web03 tomcat-8080]# vim conf/server.xml
# 指定关闭tomcat的端口号及暗号
<Server port="8005" shutdown="SHUTDOWN">
#指定 tomcat的web站点监听端口
<Connector port="8080" protocol="HTTP/1.1"
       connectionTimeout="20000"
       redirectPort="8443" />
# 专门和apache通信的端口  不用,注释
 <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
# 定义主机 网站根目录
 <Host name="localhost"  appBase="webapps"
       unpackWARs="true" autoDeploy="true">  //自动解压 自动部署 (生产环境关闭false)
#定义日志  及日志格式
<Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
       prefix="localhost_access_log" suffix=".txt"
       pattern="%h %l %u %t &quot;%r&quot; %s %b" />
 
	   
n[root@web03 ~]# netstat -lntup
tcp6       0      0 127.0.0.1:8005          :::*                    LISTEN      2069/java
tcp6       0      0 :::8009                 :::*                    LISTEN      2069/java
tcp6       0      0 :::8080                 :::*                    LISTEN      2069/java

#向本地的8005端口发送SHUTDOWN 就可以关闭tomcat (后台三个java进程关闭了)
[root@web03 ~]# echo SHUTDOWN|nc 127.0.0.1 8005
```



## tomcat 自定义网站目录


```bash
	默认在 webapps/ROOT
	以前地址 http://10.0.0.9:8080/memtest/meminfo.jsp
	想要的地址: http://10.0.0.9:8080/meminfo.jsp

	第一种方法: 将 meminfo.jsp 放入ROOT目录
	第二种方法: 想想 nginx的location 规则
				 location /oldboyedu/ {
					.....
				 }
 # 在host标签内 添加 Context 标签
[root@tomcat ~]# vim /application/tomcat/conf/server.xml
  <Host name="localhost"  appBase="webapps"
        unpackWARs="true" autoDeploy="true">
<Context path="" docBase="/application/tomcat/webapps/memtest" debug="0" reloadable="false" crossContext="true"/>

#sed 命令快速修改  在149行后面添加
[root@web03 tomcat-8080]# sed -i.ori '149a <Context path="" docBase="/application/tomcat/webapps/memtest" debug="0" reloadable="false" crossContext="true"/>' conf/server.xml

# 修改好后重启tomcat
[root@tomcat ~]# /application/tomcat/bin/shutdown.sh
[root@tomcat ~]# /application/tomcat/bin/startup.sh
```



## Tomcat多实例 (多个虚拟主机)


```bash
多虚拟主机: nginx
	多实例: tomcat, 尽可能使用我们的系统的资源 (资源相对多)
	
[root@web03 tomcat-8080]# cd /application/tools/
[root@web03 tools]# ls
apache-tomcat-8.5.34.tar.gz
[root@web03 tools]# tar xf apache-tomcat-8.5.34.tar.gz
[root@web03 tools]# cp -a apache-tomcat-8.5.34 tomcat8_1
[root@web03 tools]# cp -a apache-tomcat-8.5.34 tomcat8_2
[root@web03 tools]# cp -a apache-tomcat-8.5.34 tomcat8_3

# 修改每个实例运行端口

[root@web03 tools]# sed -i 's#8005#8011#;s#8080#8081#' tomcat8_1/conf/server.xml
[root@web03 tools]# sed -i 's#8005#8012#;s#8080#8082#' tomcat8_2/conf/server.xml
[root@web03 tools]# sed -i 's#8005#8013#;s#8080#8083#' tomcat8_3/conf/server.xml

#打包多实例,方便以后批量配置实例
[root@web03 tools]# tar zcf tomcat_muti.tar.gz ./tomcat8_1 ./tomcat8_2 ./tomcat8_3
#将配置好的 实例移动到软件目录下
[root@web03 tools]# mv tomcat8_1 tomcat8_2 tomat8_3 /application/

# 启动 多个实例

[root@web03 server]# tomcat8_1/bin/startup.sh
[root@web03 server]# tomcat8_2/bin/startup.sh

# 检查对应端口 8081 8082

[root@web03 server]# netstat -lntup
tcp6       0      0 :::8009           :::*           LISTEN      2448/java
tcp6       0      0 127.0.0.1:8011     :::*           LISTEN      2448/java
tcp6       0      0 127.0.0.1:8012     :::*           LISTEN      2506/java
tcp6       0      0 :::8081           :::*           LISTEN      2448/java
tcp6       0      0 :::8082           :::*            LISTEN      2506/java

#浏览器访问
http://10.0.0.9:8081/
http://10.0.0.9:8082/
```



## tomcat反向代理集群


```bash
					// 前面加nginx反向代理	

							upstream java {
							server 172.16.1.8:8081
							server 172.16.1.9:8081
						}

# lb01 安装nginx  (安装过了)
 
# 编辑配置文件 在http段里写 include 下面
vim /etc/nginx/nginx.conf 

upstream java {
#	server 172.16.1.9:8080;
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
						
推荐写到 /etc/nginx/conf.d/proxy.conf (因为nginx.conf 主配置文件包含conf.d/*.conf)
[root@lb01 conf.d]# cat proxyhttps.conf
upstream java {
#	server 172.16.1.9:8080;
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
						
#  window hosts 解析后 浏览器访问http://jpress.etiantian.org/
```



## tomcat监控


```bash
# 查看当前运行的java进程及pid号

[root@web03 server]# jps -lvm

1、Tomcat自带函数检测
 	ROOT/meminfo.jsp
	#浏览器访问 http://10.0.0.3/meminfo.jsp

2、jps命令	jkd包自带的命令, jps主要用来输出jvm中运行的进程状态信息.
	man jps
	
3、jstack命令   主要用来查看某个java进程内的线程堆栈信息

4、jmap
	
5、jconsole和visualvm

5.1Tomcat开启远程监控功能
	[root@web03 server]# vim tomcat8_1/bin/catalina.sh
109 CATALINA_OPTS="$CATALINA_OPTS
110 -Dcom.sun.management.jmxremote
111 -Dcom.sun.management.jmxremote.port=12345
112 -Dcom.sun.management.jmxremote.authenticate=false
113 -Dcom.sun.management.jmxremote.ssl=false
114 -Djava.rmi.server.hostname=172.16.1.9"

#重启tomcat
[root@web03 server]# tomcat8_1/bin/shutdown.sh	
[root@web03 server]# tomcat8_1/bin/startup.sh	

# 检测有没有12345端口
[root@web03 server]# netstat -lntup|grep 12345
tcp6       0      0 :::12345         :::*          LISTEN      3565/java

# 如果没有查看的日志文件   | 配对应的/etc/hosts

[root@web03 server]# tailf tomcat8_1/logs/catalina.out

# 如果是多个实例 这个配置要修改port端口 不能相同

windows下 安装的jdk1.8 目录下的bin
c:/program files /java/jdk1.8.0.31/bin 
								jconsole
								jvisualvm
```



## zabbix监控


```bash
rpm -qa zabbix-java-gateway
#还要安装zabbix

配置 zabbix server
```



1. Tomcat安全优化和性能优化  
7.1 安全优化(必会)



```bash
降权启动    //降低权限启动  使用个普通用户启动tomcat
		useradd tomcat
		cp -a tomcat8_2 /home/tomcat/
		chown -R tomcat.tomcat /home/tomcat8_2/
		su - tomcat
		tomcat8_2/bin/startup.sh
	#不用切换用户使用普通用户执行命令,可以放入开机自启动  
	su - tomcat -c '这里写命令'

telnet管理端口保护 (8005)
ajp连接端口保护 (8009 注释掉)
禁用管理端  // webapps目录下只保留一个ROOT
```



#### 7.2 性能优化


##### 7.2.1 屏蔽dns查询enableLookups="false"


```xml
<Connector  port="8081" protocol="HTTP/1.1"
           connectionTimeout="6000" enableLookups="false" acceptCount="800"
           redirectPort="8443" />
```



##### 7.2.2 jvm调优


```plain
Tomcat最吃内存，只要内存足够，这只猫就跑的很快。

如果系统资源有限，那就需要进行调优，提高资源使用率。

优化catalina.sh配置文件。在catalina.sh配置文件中添加以下代码：

JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -Xms1024m -Xmx1024m -XX:NewSize=512m -XX:MaxNewSize=512m -XX:PermSize=512m -XX:MaxPermSize=512m"

server:一定要作为第一个参数，在多个CPU时性能佳
-Xms：初始堆内存Heap大小，使用的最小内存,cpu性能高时此值应设的大一些
-Xmx：初始堆内存heap最大值，使用的最大内存
上面两个值是分配JVM的最小和最大内存，取决于硬件物理内存的大小，建议均设为物理内存的一半。

-XX:PermSize:设定内存的永久保存区域
-XX:MaxPermSize:设定最大内存的永久保存区域
-XX:MaxNewSize:
-Xss 15120 这使得JBoss每增加一个线程（thread)就会立即消耗15M内存，而最佳值应该是128K,默认值好像是512k.
+XX:AggressiveHeap 会使得 Xms没有意义。这个参数让jvm忽略Xmx参数,疯狂地吃完一个G物理内存,再吃尽一个G的swap。
-Xss：每个线程的Stack大小
-verbose:gc 现实垃圾收集信息
-Xloggc:gc.log 指定垃圾收集日志文件
-Xmn：young generation的heap大小，一般设置为Xmx的3、4分之一
-XX:+UseParNewGC ：缩短minor收集的时间
-XX:+UseConcMarkSweepGC ：缩短major收集的时间
```



## nginx+tomcat配置https


网上搜索的很多文章在描述 Nginx + Tomcat 启用 HTTPS 支持的时候，都必须在 Nginx 和 Tomcat 两边同时配置 SSL 支持。



最终配置的方案是浏览器和 Nginx 之间走的 HTTPS 通讯 而Nginx 到 Tomcat 通过 proxy_pass 走的是普通 HTTP 连接。



### lb01 负载均衡 nginx 配置


```bash
先申请https证书
[root@web01 code]# mkdir /etc/nginx/ssl_key -p
[root@web01 code]# cd /etc/nginx/ssl_key/
[root@web01 ~]# openssl genrsa -idea -out server.key 2048
这里密码设置1234
[root@web01 ~]# openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:WH
Locality Name (eg, city) [Default City]:WH
Organization Name (eg, company) [Default Company Ltd]:edu    
Organizational Unit Name (eg, section) []:SA
Common Name (eg, your name or your server's hostname) []:bgx
Email Address []:bgx@foxmail.com
```



### lb01 的 proxyhttps.conf 配置


```nginx
[root@lb01 conf.d]# cat proxyhttps.conf
upstream java {
#	server 172.16.1.9:8080;
	server 172.16.1.9:8081;
#	server 172.16.1.9:8082;
}
server {
	listen 80;
	server_name jpress.etiantian.org;
	return 302 https://$server_name$request_uri;
#	location / {
#		proxy_pass http://java;
#		include proxy_params;
#	}
}
server {
    listen       443 ssl;
    server_name  jpress.etiantian.org;

	ssl on;
	ssl_certificate  ssl_key/server.crt;
	ssl_certificate_key  ssl_key/server.key;

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;

    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_redirect off;
        proxy_connect_timeout      240;
        proxy_send_timeout         240;
        proxy_read_timeout         240;
        # note, there is not SSL here! plain HTTP is used
        proxy_pass http://java;
    }
}	

#其中最为关键的就是 ssl_certificate 和 ssl_certificate_key 这两项配置，其他的按正常配置。不过多了一个 proxy_set_header X-Forwarded-Proto https; 配置。
```



### Tomcat server.xml 完整配置


```xml
[root@web03 server]# cat tomcat8_1/conf/server.xml
<?xml version="1.0" encoding="UTF-8"?>

<Server port="8011" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.startup.VersionLoggerListener" />
  <Listener className="org.apache.catalina.security.SecurityListener" />
  -->
  <!--APR library loader. Documentation at /docs/apr.html -->
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <!-- Prevent memory leaks due to use of particular java/javax APIs-->
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
               connectionTimeout="20000"
               redirectPort="443"
		proxyPort="443" />
 
    <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
	
    <Engine name="Catalina" defaultHost="localhost">

      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>

      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">

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

#上述的配置中没有什么特别的，但是特别特别注意的是必须有 proxyPort="443"，这是整篇文章的关键，当然 redirectPort 也必须是 443。同时 <Value> 节点的配置也非常重要，否则你在 Tomcat 中的应用在读取 getScheme() 方法以及在 web.xml 中配置的一些安全策略会不起作用。
```



参考文档

[https://blog.oldboyedu.com/java-tomcat/](https://blog.oldboyedu.com/java-tomcat/)

[http://www.zyops.com/java-tomcat/](http://www.zyops.com/java-tomcat/)

[https://www.cnblogs.com/swbzmx/articles/8845810.html](https://www.cnblogs.com/swbzmx/articles/8845810.html)







> 更新: 2024-09-01 16:00:27  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/fuspmx>