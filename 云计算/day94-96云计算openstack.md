# day94-96 云计算 openstack

### 时间同步
<font style="color:black;">#</font><font style="color:black;">服务端配置</font>

<font style="color:black;">[root@controller ~]# yum install chrony</font>

<font style="color:black;">[root@controller ~]# vim /etc/chrony.conf</font>

<font style="color:black;">                                          allow 10.0.0.0/24</font>

 

<font style="color:black;">[root@controller ~]# systemctl restart chronyd.service</font>

 

<font style="color:black;">#</font><font style="color:black;">客户端</font>

<font style="color:black;">[root@compute1 ~]# head -5 /etc/chrony.conf</font>

<font style="color:black;"># Use public servers from the pool.ntp.org project.</font>

<font style="color:black;"># Please consider joining the pool (http://www.pool.ntp.org/join.html).</font>

<font style="color:black;">server 10.0.0.11 iburst</font>

 

 

<font style="color:black;">[root@compute1 ~]# systemctl restart chronyd.service</font>

 

 

<font style="color:black;">#</font><font style="color:black;">检查</font>

<font style="color:black;">[root@controller ~]# date</font>

<font style="color:black;">2018</font><font style="color:black;">年</font><font style="color:black;"> 12</font><font style="color:black;">月</font><font style="color:black;"> 12</font><font style="color:black;">日</font><font style="color:black;"> </font><font style="color:black;">星期三</font><font style="color:black;"> 08:14:34 CST</font>

<font style="color:black;">[root@compute1 ~]# date</font>

<font style="color:black;">2018</font><font style="color:black;">年</font><font style="color:black;"> 12</font><font style="color:black;">月</font><font style="color:black;"> 12</font><font style="color:black;">日</font><font style="color:black;"> </font><font style="color:black;">星期三</font><font style="color:black;"> 08:14:58 CST</font>

 

## 1：什么是云计算？
云计算是通过虚拟化技术去实现的，它是一种按量付费的模式！

 

## 2：为什么要用云计算？
小公司：1年，20人+，500w，招一个运维，15k，(10台*1.5w，托管IDC机房，8k/年,带宽 100M，5个公网ip， 10k/月),  买10台云主机，600*10=6000

大公司：举行活动，加集群，把闲置时间出租，超卖（kvm）

16G，kvm，64G（ksm），金牌用户（200w+/月）

 

## 3:云计算有哪些功能？虚拟机的管理平台（计费）
kvm：1000宿主机（agent），虚拟出2w虚拟机，

虚拟机的详细情况：硬件资源，ip情况统计？

虚拟机管理平台：每台虚拟机的管理，都用数据库来统计

 

## 4：云计算的服务类型
IAAS

PAAS(docker)

SAAS

 

## 5：openstack实现的是云计算IAAS，开源的云计算平台，apache 2.0，阿里云（飞天云平台）
 

## 6:openstack （soa架构）
云平台（keystone认证服务，glance镜像服务，nova计算服务，neutron网络服务，cinder存储服务，horizon web界面）

 

每个服务：数据库，消息队列，memcached缓存，时间同步

 

## 7：虚拟机规划
controller：内存3G，cpu开启虚拟化，ip：10.0.0.11

compute01： 内存1G，cpu开启虚拟化（必开），ip：10.0.0.31

 

## 8：配置yum源
mount /dev/cdrom /mnt

rz 上传openstack_rpm.tar.gz到/opt，并解压

生成repo配置文件

vim /etc/yum.repos.d/local.repo

[local]

name=local

baseurl=file:///mnt

gpgcheck=0

 

[openstack]

name=openstack

baseurl=file:///opt/repo

gpgcheck=0

 

 

echo 'mount /dev/cdrom /mnt' >>/etc/rc.local

chmod +x /etc/rc.d/rc.local

 

[root@controller yum.repos.d]# cat >local.repo<<EOF

> [local]

> name=local

> baseurl=file:///mnt

> gpgcheck=0

> 

> [openstack]

> name=openstack

> baseurl=file:///opt/repo

> gpgcheck=0

> EOF

 

#检查yum源

[root@compute01 opt]# yum makecache

[root@compute01 opt]# yum repolist

 

## 9：安装基础服务
在所有节点上执行：

a：时间同步

b：安装openstack客户端和openstack-selinux

yum install python-openstackclient -y

yum install openstack-selinux -y

仅控制节点执行：

c: 安装配置mariadb

<font style="color:black;">yum install mariadb mariadb-server python2-PyMySQL -y</font>

#配置数据库

vim /etc/my.cnf.d/openstack.cnf

<font style="color:black;">[mysqld]</font>

<font style="color:black;">bind-address = 10.0.0.11</font>

<font style="color:black;">default-storage-engine = innodb</font>

<font style="color:black;">innodb_file_per_table</font>

<font style="color:black;">max_connections = 4096</font>

<font style="color:black;">collation-server = utf8_general_ci</font>

<font style="color:black;">character-set-server = utf8</font>

#启动 并设置开机自启动

systemctl enable mariadb.service

systemctl start mariadb.service

#安全初始化

<font style="color:black;">mysql_secure_installation</font>

<font style="color:black;">回车</font>

<font style="color:black;">n</font>

<font style="color:black;">y</font>

<font style="color:black;">y</font>

<font style="color:black;">y</font>

<font style="color:black;">y</font>

 

 

d：安装rabbitmq并创建用户

<font style="color:black;">yum install rabbitmq-server -y</font>

<font style="color:black;">systemctl enable rabbitmq-server.service</font>

<font style="color:black;">systemctl start rabbitmq-server.service</font>

 

<font style="color:black;">#</font><font style="color:black;">创建用户</font>

<font style="color:black;">rabbitmqctl add_user openstack RABBIT_PASS</font>

<font style="color:black;">#</font><font style="color:black;">授权</font>

<font style="color:black;">rabbitmqctl set_permissions openstack ".*" ".*" ".*"</font>

 

e：memcached缓存token

<font style="color:black;">yum install memcached python-memcached</font>

<font style="color:black;">#</font><font style="color:black;">修改</font><font style="color:black;">memcached </font><font style="color:black;">配置文件的监听端口</font>

![1566205548992-42df2cd6-e49c-45f1-b09e-d7bd9eaebae3.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-01.png)

 

<font style="color:black;">systemctl enable memcached.service</font>

<font style="color:black;">systemctl start memcached.service</font>

基础环境大检查

![1566205549094-d93f8fe0-d587-4073-9e38-83fdb0f63bf3.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-02.png)

 

## 10：keystone认证服务
![1566205549211-a1d37638-cf04-422b-8ba5-ae5f3c7150cf.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-03.png)

![1566205549337-035d4541-8bb6-4ab1-ac6d-164cc25e6182.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-04.png)

除了 keystone

 

a：创库授权

<font style="color:black;"># mysql</font><font style="color:black;">登入执行</font>

<font style="color:black;">CREATE DATABASE keystone;</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \</font>

<font style="color:black;">  IDENTIFIED BY 'KEYSTONE_DBPASS';</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \</font>

<font style="color:black;">  IDENTIFIED BY 'KEYSTONE_DBPASS';</font>

 

keystone 在keystone 还没配置好之前,可以设置一个管理员token(令牌)

 

b：安装keystone相关软件包

<font style="color:black;">yum install openstack-keystone httpd mod_wsgi -y</font>

c:修改配置文件

<font style="color:black;">#</font><font style="color:black;">备份配置文件</font>

<font style="color:black;">\cp /etc/keystone/keystone.conf{,.bak}</font>

<font style="color:black;">#</font><font style="color:black;">去除注释和空行</font>

<font style="color:black;">grep -Ev '^$|#' /etc/keystone/keystone.conf.bak >/etc/keystone/keystone.conf</font>

<font style="color:black;">#</font><font style="color:black;">安装修改配置文件工具</font>

<font style="color:black;">yum install openstack-utils.noarch –y</font>

 

<font style="color:black;">#</font><font style="color:black;">自动化修改配置文件</font>

<font style="color:black;">openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token  ADMIN_TOKEN</font>

<font style="color:black;">openstack-config --set /etc/keystone/keystone.conf database connection  mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone</font>

<font style="color:black;">openstack-config --set /etc/keystone/keystone.conf token provider  fernet</font>

 

 

<font style="color:black;">#</font><font style="color:black;">检查</font><font style="color:black;"> MD5sum</font><font style="color:black;">值</font>

<font style="color:black;">[root@controller ~]# md5sum /etc/keystone/keystone.conf</font>

<font style="color:black;">d5acb3db852fe3f247f4f872b051b7a9  /etc/keystone/keystone.conf</font>

d：同步数据库

<font style="color:black;">su -s /bin/sh -c "keystone-manage db_sync" keystone</font>

 

<font style="color:black;">#</font><font style="color:black;">检查</font>

<font style="color:black;">[root@controller ~]# mysql keystone -e 'show tables;'</font>

e：初始化fernet

<font style="color:black;">keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone</font>

f：配置httpd

<font style="color:black;">echo "ServerName controller" >>/etc/httpd/conf/httpd.conf</font>

vi /etc/httpd/conf.d/wsgi-keystone.conf

<font style="color:black;">Listen 5000</font>

<font style="color:black;">Listen 35357</font>

 

<font style="color:black;"><VirtualHost *:5000></font>

<font style="color:black;">    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}</font>

<font style="color:black;">    WSGIProcessGroup keystone-public</font>

<font style="color:black;">    WSGIScriptAlias / /usr/bin/keystone-wsgi-public</font>

<font style="color:black;">    WSGIApplicationGroup %{GLOBAL}</font>

<font style="color:black;">    WSGIPassAuthorization On</font>

<font style="color:black;">    ErrorLogFormat "%{cu}t %M"</font>

<font style="color:black;">    ErrorLog /var/log/httpd/keystone-error.log</font>

<font style="color:black;">    CustomLog /var/log/httpd/keystone-access.log combined</font>

 

<font style="color:black;">    <Directory /usr/bin></font>

<font style="color:black;">        Require all granted</font>

<font style="color:black;">    </Directory></font>

<font style="color:black;"></VirtualHost></font>

 

<font style="color:black;"><VirtualHost *:35357></font>

<font style="color:black;">    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}</font>

<font style="color:black;">    WSGIProcessGroup keystone-admin</font>

<font style="color:black;">    WSGIScriptAlias / /usr/bin/keystone-wsgi-admin</font>

<font style="color:black;">    WSGIApplicationGroup %{GLOBAL}</font>

<font style="color:black;">    WSGIPassAuthorization On</font>

<font style="color:black;">    ErrorLogFormat "%{cu}t %M"</font>

<font style="color:black;">    ErrorLog /var/log/httpd/keystone-error.log</font>

<font style="color:black;">    CustomLog /var/log/httpd/keystone-access.log combined</font>

 

<font style="color:black;">    <Directory /usr/bin></font>

<font style="color:black;">        Require all granted</font>

<font style="color:black;">    </Directory></font>

<font style="color:black;"></VirtualHost></font>

 

#检查

**<font style="color:black;">[root@controller ~]# md5sum /etc/httpd/conf.d/wsgi-keystone.conf</font>**

**<font style="color:black;">8f051eb53577f67356ed03e4550315c2  /etc/httpd/conf.d/wsgi-keystone.conf</font>**

g:启动httpd

<font style="color:black;">systemctl enable httpd.service</font>

<font style="color:black;">systemctl start httpd.service</font>

 

h：创建服务和注册api：

<font style="color:black;">export OS_TOKEN=ADMIN_TOKEN</font>

<font style="color:black;">export OS_URL=http://controller:35357/v3</font>

<font style="color:black;">export OS_IDENTITY_API_VERSION=3</font>

 

<font style="color:black;">openstack service create \</font>

<font style="color:black;">  --name keystone --description "OpenStack Identity" identity</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  identity public http://controller:5000/v3</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  identity internal http://controller:5000/v3</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  identity admin http://controller:35357/v3</font>

 

#检查

![1566205549458-1d384f91-bdea-41d6-a071-86349fd1ba6a.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-05.png)

![1566205549607-8976fa20-0843-4d69-98c7-bafcb62b4de5.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-06.png)

I：创建域、项目、用户、角色

<font style="color:black;">openstack domain create --description "Default Domain" default</font>

<font style="color:black;">openstack project create --domain default \</font>

<font style="color:black;">  --description "Admin Project" admin</font>

<font style="color:black;">openstack user create --domain default \</font>

<font style="color:black;">  --password ADMIN_PASS admin</font>

<font style="color:black;">openstack role create admin</font>

#关联项目，用户，角色

<font style="color:black;">openstack role add --project admin --user admin admin</font>

<font style="color:black;">openstack project create --domain default \</font>

<font style="color:black;">  --description "Service Project" service</font>

 

#检查

![1566205549732-bf83c616-be91-4061-a85a-fda9f8101b97.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-07.png)

 

j：创建环境变量脚本

unset OS_TOKEN OS_URL

![1566205549863-bd4a7b18-de8c-4c15-86c4-20450d47eaf1.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-08.png)

 

#在root家目录下创建环境变量文件

vi admin-openrc

####

<font style="color:black;">export OS_PROJECT_DOMAIN_NAME=default</font>

<font style="color:black;">export OS_USER_DOMAIN_NAME=default</font>

<font style="color:black;">export OS_PROJECT_NAME=admin</font>

<font style="color:black;">export OS_USERNAME=admin</font>

<font style="color:black;">export OS_PASSWORD=ADMIN_PASS</font>

<font style="color:black;">export OS_AUTH_URL=http://controller:35357/v3</font>

<font style="color:black;">export OS_IDENTITY_API_VERSION=3</font>

<font style="color:black;">export OS_IMAGE_API_VERSION=2</font>

 

#生效环境变量

<font style="color:black;">source admin-openrc</font>

 

#检查

![1566205549966-99f2fabd-56ad-46b8-96ea-03a4593f084c.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-09.png)

 

#报错

<font style="color:black;">[root@controller ~]# openstack token issue</font>

<font style="color:black;">The request you have made requires authentication. (HTTP 401) (Request-ID: req-1eeb7c85-c4df-4541-814e-4e120cf567e1)</font>

 

解决 修改环境变量密码

![1566205550065-1237ad14-86a1-4118-9446-32f4f5c3c9e5.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-10.png)

 

![1566205550180-7afac68d-ca7c-40b2-968a-f0fbb71f3565.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-11.png)

 

 

## 11：安装glance镜像服务
a：数据库创库授权

<font style="color:black;">CREATE DATABASE glance;</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \</font>

<font style="color:black;">  IDENTIFIED BY 'GLANCE_DBPASS';</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \</font>

<font style="color:black;">  IDENTIFIED BY 'GLANCE_DBPASS';</font>

 

b：在keystone创建glance用户关联角色

<font style="color:black;">openstack user create --domain default --password GLANCE_PASS glance</font>

<font style="color:black;">openstack role add --project service --user glance admin</font>

 

c：在keystone上创建服务实体和注册api

<font style="color:black;">openstack service create --name glance \</font>

<font style="color:black;">  --description "OpenStack Image" image</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  image public http://controller:9292</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  image internal http://controller:9292</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  image admin http://controller:9292</font>

 

d：安装服务相应软件包

<font style="color:black;">yum install openstack-glance -y</font>

 

e：修改相应服务的配置文件

<font style="color:black;">cp /etc/glance/glance-api.conf{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/glance/glance-api.conf.bak >/etc/glance/glance-api.conf</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  database  connection  mysql+pymysql://glance:GLANCE_DBPASS@controller/glance</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  glance_store stores  file,http</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  glance_store default_store  file</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  glance_store filesystem_store_datadir  /var/lib/glance/images/</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken auth_uri  http://controller:5000</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken memcached_servers  controller:11211</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken project_name  service</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken username  glance</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  keystone_authtoken password  GLANCE_PASS</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-api.conf  paste_deploy flavor  keystone</font>

 

#检查

![1566205550271-13c2f14b-3943-43cf-8b43-7cf7adc80610.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-12.png)

#####

<font style="color:black;">cp /etc/glance/glance-registry.conf{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/glance/glance-registry.conf.bak > /etc/glance/glance-registry.conf</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  database  connection  mysql+pymysql://glance:GLANCE_DBPASS@controller/glance</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken auth_uri  http://controller:5000</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken memcached_servers  controller:11211</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken project_name  service</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken username  glance</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  keystone_authtoken password  GLANCE_PASS</font>

<font style="color:black;">openstack-config --set /etc/glance/glance-registry.conf  paste_deploy flavor  keystone</font>

 

#检查

![1566205550345-32cfdc5b-9f45-4bd8-bf1d-8d62fe08b569.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-13.png)

f：同步数据库

<font style="color:black;">#</font><font style="color:black;">忽略警告信息</font>

<font style="color:black;">su -s /bin/sh -c "glance-manage db_sync" glance</font>

<font style="color:black;">#</font><font style="color:black;">检查</font>

<font style="color:black;">mysql glance -e "show tables;"</font>

g：启动服务

<font style="color:black;">systemctl enable openstack-glance-api.service \</font>

<font style="color:black;">  openstack-glance-registry.service</font>

<font style="color:black;">systemctl start openstack-glance-api.service \</font>

<font style="color:black;">  openstack-glance-registry.service</font>

 

#检查是不是有9292端口

![1566205550418-b8f87a69-9656-4d98-8b08-62de9aee8b7a.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-14.png)

 

#报错

![1566205550518-79ef3da7-9245-40b0-a8c3-aa4578f8bce2.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-15.png)

h: 验证

先上传 cirros-0.3.4-x86_64-disk.img 文件

<font style="color:black;">openstack image create "cirros" \</font>

<font style="color:black;">  --file cirros-0.3.4-x86_64-disk.img \</font>

<font style="color:black;">  --disk-format qcow2 --container-format bare \</font>

<font style="color:black;">  --public</font>

  #检查文件是不是有文件  | MD5值是一样的 只是改了个名字

![1566205550606-7f7345e0-27f9-476a-bf04-b02ada9cd252.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-16.png)

 

#查看当前系统有几个镜像

![1566205550710-cc3fd552-b655-4667-a67e-beffb775eb53.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-17.png)

 

## 十二：nova 计算服务
nova-api:接受并响应所有的计算服务请求，管理虚拟机(云主机)生命周期

nova-compute（多个）：真正管理虚拟机

nova-scheduler：      nova调度器（挑选出最合适的nova-compute来创建虚机）

nova-conductor：      帮助nova-compute代理修改数据库中虚拟机的状态

nova-network          早期openstack版本管理虚拟机的网络（已弃用，neutron）

nova-consoleauth和nova-novncproxy：web版的vnc来直接操作云主机

novncproxy：web版 vnc客户端

nova-api-metadata：接受来自虚拟机发送的元数据请求

 

在控制节点上：

1：数据库创库授权 | 登陆数据库 mysql

<font style="color:black;">CREATE DATABASE nova_api;</font>

<font style="color:black;">CREATE DATABASE nova;</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \</font>

<font style="color:black;">  IDENTIFIED BY 'NOVA_DBPASS';</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \</font>

<font style="color:black;">  IDENTIFIED BY 'NOVA_DBPASS';</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \</font>

<font style="color:black;">  IDENTIFIED BY 'NOVA_DBPASS';</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \</font>

<font style="color:black;">  IDENTIFIED BY 'NOVA_DBPASS';</font>

 

2：在keystone创建系统用户(glance,nova,neutron)关联角色

<font style="color:black;">openstack user create --domain default \</font>

<font style="color:black;">  --password NOVA_PASS nova</font>

<font style="color:black;">openstack role add --project service --user nova admin</font>

 

3：在keystone上创建服务实体和注册api

<font style="color:black;">openstack service create --name nova \</font>

<font style="color:black;">  --description "OpenStack Compute" compute</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  compute public http://controller:8774/v2.1/%\(tenant_id\)s</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  compute internal http://controller:8774/v2.1/%\(tenant_id\)s</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  compute admin http://controller:8774/v2.1/%\(tenant_id\)s</font>

 

4：安装服务相应软件包

<font style="color:black;">yum install openstack-nova-api openstack-nova-conductor \</font>

<font style="color:black;">  openstack-nova-console openstack-nova-novncproxy \</font>

<font style="color:black;">  openstack-nova-scheduler -y</font>

 

5：修改相应服务的配置文件

<font style="color:black;">cp /etc/nova/nova.conf{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/nova/nova.conf.bak >/etc/nova/nova.conf</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT enabled_apis  osapi_compute,metadata</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT rpc_backend  rabbit</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT auth_strategy  keystone</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT my_ip  10.0.0.11</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT use_neutron  True</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT firewall_driver  nova.virt.firewall.NoopFirewallDriver</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  api_database connection  mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  database  connection  mysql+pymysql://nova:NOVA_DBPASS@controller/nova</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  glance api_servers  http://controller:9292</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_uri  http://controller:5000</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  memcached_servers  controller:11211</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  project_name  service</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  username  nova</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  password  NOVA_PASS</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_concurrency lock_path  /var/lib/nova/tmp</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_host  controller</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_userid  openstack</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_password  RABBIT_PASS</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  vnc vncserver_listen  '$my_ip'</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  vnc vncserver_proxyclient_address  '$my_ip'</font>

#校验

<font style="color:black;">md5sum /etc/nova/nova.conf</font>

<font style="color:black;">47ded61fdd1a79ab91bdb37ce59ef192  /etc/nova/nova.conf</font>

 

6：同步数据库  |忽略警告信息

<font style="color:black;">su -s /bin/sh -c "nova-manage api_db sync" nova</font>

<font style="color:black;">su -s /bin/sh -c "nova-manage db sync" nova</font>

 

#检查

![1566205550810-0182d15d-d963-4a9a-8a0c-2052c950f910.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-18.png)

7：启动服务

<font style="color:black;">systemctl enable openstack-nova-api.service \</font>

<font style="color:black;">  openstack-nova-consoleauth.service openstack-nova-scheduler.service \</font>

<font style="color:black;">  openstack-nova-conductor.service openstack-nova-novncproxy.service</font>

<font style="color:black;">systemctl start openstack-nova-api.service \</font>

<font style="color:black;">  openstack-nova-consoleauth.service openstack-nova-scheduler.service \</font>

<font style="color:black;">  openstack-nova-conductor.service openstack-nova-novncproxy.service</font>

 

#检查计算服务列表

openstack compute service list

![1566205550887-c661cdc1-d71d-407b-a247-57c8edabe6c6.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-19.png)<font style="color:black;"> </font>

 

计算节点上：

nova-compute调用libvirtd来创建虚拟机

安装

<font style="color:black;">yum install openstack-nova-compute -y</font>

<font style="color:black;">yum install openstack-utils.noarch -y</font>

配置

#检查本机开启虚拟化

![1566205550975-0a8b9e0b-16f1-4d7d-b02d-eb89d080efe3.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-20.png)

 

 

<font style="color:black;">cp /etc/nova/nova.conf{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/nova/nova.conf.bak >/etc/nova/nova.conf</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT rpc_backend  rabbit</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT auth_strategy  keystone</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT my_ip  10.0.0.31</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT use_neutron  True</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  DEFAULT firewall_driver  nova.virt.firewall.NoopFirewallDriver</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  glance api_servers  http://controller:9292</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_uri  http://controller:5000</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  memcached_servers  controller:11211</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  project_name  service</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  username  nova</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  keystone_authtoken  password  NOVA_PASS</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_concurrency lock_path  /var/lib/nova/tmp</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_host  controller</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_userid  openstack</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_password  RABBIT_PASS</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  vnc enabled  True</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  vnc vncserver_listen  0.0.0.0</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  vnc vncserver_proxyclient_address  '$my_ip'</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  vnc novncproxy_base_url  http://controller:6080/vnc_auto.html</font>

#校验

![1566205551041-998f13e8-205b-45a7-b538-74460bf14af8.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-21.png)

 

启动

<font style="color:black;">systemctl enable libvirtd.service openstack-nova-compute.service</font>

<font style="color:black;">systemctl start libvirtd.service openstack-nova-compute.service</font>

 

#控制端检查 会多一个计算服务节点

![1566205551122-9684a79e-2e98-4416-a5f2-eb27ab4824c0.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-22.png)

 

## openstack环境检查
<font style="color:black;">0.0.0.0:6080          2486/nova-novncproxy</font>

<font style="color:black;"> 0.0.0.0:8774          2482/nova-api</font>

<font style="color:black;"> 0.0.0.0:8775          2482/nova-metadata-api</font>

<font style="color:black;"> 0.0.0.0:9191          1737/glance-registry</font>

<font style="color:black;"> 0.0.0.0:25672         969/rabbitmq (</font><font style="color:black;">集群之间同步数据</font><font style="color:black;">)</font>

<font style="color:black;"> 10.0.0.11:3306        1179/mysqld</font>

<font style="color:black;"> 10.0.0.11:11211       972/memcached</font>

<font style="color:black;"> 0.0.0.0:9292          1736/glance-api</font>

<font style="color:black;"> 0.0.0.0:111           1/systemd</font>

<font style="color:black;"> 0.0.0.0:4369          1/rabbitmq</font>

<font style="color:black;"> 0.0.0.0:22            975/sshd</font>

<font style="color:black;"> 127.0.0.1:25          1223/master</font>

<font style="color:black;"> :::35357              982/httpd (keystone admin)   5000</font><font style="color:black;">端口</font><font style="color:black;">(keystone </font><font style="color:black;">非</font><font style="color:black;">admin)</font>

<font style="color:black;"> :::5672               969/rabbitmq (</font><font style="color:black;">对外提供服务</font><font style="color:black;">)</font>

<font style="color:black;"> :::5000               982/httpd</font>

<font style="color:black;"> :::111                1/systemd</font>

<font style="color:black;"> :::80                 982/httpd</font>

<font style="color:black;"> :::22                 975/sshd</font>

<font style="color:black;"> ::1:25                1223/master</font>

<font style="color:black;"> 127.0.0.1:323         667/chronyd</font>

<font style="color:black;"> 0.0.0.0:829           663/rpcbind</font>

<font style="color:black;"> 10.0.0.11:11211       972/memcached</font>

<font style="color:black;"> 0.0.0.0:111           1/systemd</font>

<font style="color:black;"> 0.0.0.0:123           667/chronyd</font>

<font style="color:black;"> ::1:323               667/chronyd</font>

<font style="color:black;"> :::829                663/rpcbind</font>

<font style="color:black;"> :::111                1/systemd</font>

#检查 

<font style="color:black;"># keystone</font>

<font style="color:black;">openstack token issue</font>

<font style="color:black;"># glance</font>

<font style="color:black;">openstack image list</font>

<font style="color:black;">#nova</font>

<font style="color:black;">openstack compute service list</font>

<font style="color:black;">nova service-list</font>

<font style="color:black;">#</font><font style="color:black;">检查时间</font>

<font style="color:black;">[root@controller ~]# date</font>

<font style="color:black;">2018</font><font style="color:black;">年</font><font style="color:black;"> 12</font><font style="color:black;">月</font><font style="color:black;"> 12</font><font style="color:black;">日</font><font style="color:black;"> </font><font style="color:black;">星期三</font><font style="color:black;"> 19:29:02 CST</font>

 

 

 

 

## 十三：neutron 网络服务
neutron-server  端口(9696)  api：接受和响应外部的网络管理请求

neutron-linuxbridge-agent:       负责创建桥接网卡

neutron-dhcp-agent：             负责分配IP

neutron-metadata-agent：         配合nova-metadata-api实现虚拟机的定制化操作

L3-agent                         实现三层网络(网络层)

 

在控制节点上：

1：数据库创库授权

<font style="color:black;">CREATE DATABASE neutron;</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \</font>

<font style="color:black;">  IDENTIFIED BY 'NEUTRON_DBPASS';</font>

<font style="color:black;">GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \</font>

<font style="color:black;">  IDENTIFIED BY 'NEUTRON_DBPASS';</font>

 

2：在keystone创建系统用户(glance,nova,neutron)关联角色

<font style="color:black;">openstack user create --domain default --password NEUTRON_PASS neutron</font>

<font style="color:black;">openstack role add --project service --user neutron admin</font>

 

3：在keystone上创建服务和注册api

<font style="color:black;">openstack service create --name neutron \</font>

<font style="color:black;">  --description "OpenStack Networking" network</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  network public http://controller:9696</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  network internal http://controller:9696</font>

<font style="color:black;">openstack endpoint create --region RegionOne \</font>

<font style="color:black;">  network admin http://controller:9696</font>

 

4：安装服务相应软件包

<font style="color:black;">yum install openstack-neutron openstack-neutron-ml2 \</font>

<font style="color:black;">  openstack-neutron-linuxbridge ebtables -y</font>

 

5：修改相应服务的配置文件

a:/etc/neutron/neutron.conf

<font style="color:black;">cp /etc/neutron/neutron.conf{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/neutron/neutron.conf.bak >/etc/neutron/neutron.conf</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT core_plugin  ml2</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT service_plugins</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT rpc_backend  rabbit</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT auth_strategy  keystone</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT notify_nova_on_port_status_changes  True</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT notify_nova_on_port_data_changes  True</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  database connection  mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_uri  http://controller:5000</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken memcached_servers  controller:11211</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken project_name  service</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken username  neutron</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken password  NEUTRON_PASS</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova region_name  RegionOne</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova project_name  service</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova username  nova</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  nova password  NOVA_PASS</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_concurrency lock_path  /var/lib/neutron/tmp</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_host  controller</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_userid  openstack</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_password  RABBIT_PASS</font>

 

#检查

![1566205551201-cc47824c-1a2a-4b40-83f7-a00df784ef1a.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-23.png)

 

####

b:/etc/neutron/plugins/ml2/ml2_conf.ini

<font style="color:black;">cp /etc/neutron/plugins/ml2/ml2_conf.ini{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/neutron/plugins/ml2/ml2_conf.ini.bak >/etc/neutron/plugins/ml2/ml2_conf.ini</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini  ml2 type_drivers  flat,vlan</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini  ml2 tenant_network_types</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini  ml2 mechanism_drivers  linuxbridge</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini  ml2 extension_drivers  port_security</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini  ml2_type_flat flat_networks  provider</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/ml2_conf.ini  securitygroup enable_ipset  True</font>

 

#检查

![1566205551307-43d587f1-737f-43be-bc53-9b85cbd73634.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-24.png)

 

####

c:/etc/neutron/plugins/ml2/linuxbridge_agent.ini

<font style="color:black;">cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak >/etc/neutron/plugins/ml2/linuxbridge_agent.ini</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  linux_bridge physical_interface_mappings  provider:eth0</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  securitygroup enable_security_group  True</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  securitygroup firewall_driver  neutron.agent.linux.iptables_firewall.IptablesFirewallDriver</font>

<font style="color:black;">openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  vxlan enable_vxlan  False</font>

 

#检查

![1566205551378-ae80ee6c-edd7-4a93-86b3-70faaec32c5e.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-25.png)

 

####

d:/etc/neutron/dhcp_agent.ini

<font style="color:black;">vi /etc/neutron/dhcp_agent.ini</font>

<font style="color:black;">[DEFAULT]</font>

<font style="color:black;">interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver</font>

<font style="color:black;">dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq</font>

<font style="color:black;">enable_isolated_metadata = True</font>

 

#检查

![1566205551443-503047c7-3f3d-41d0-8858-a02aefbf7795.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-26.png)

 

e:/etc/neutron/metadata_agent.ini

<font style="color:black;">vi /etc/neutron/metadata_agent.ini</font>

<font style="color:black;">[DEFAULT]</font>

<font style="color:black;">nova_metadata_ip = controller</font>

<font style="color:black;">metadata_proxy_shared_secret = METADATA_SECRET</font>

 

#检查

![1566205551527-aab162a7-bd8b-4ac4-9f4e-b43d4dde6f4a.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-27.png)

 

f:再次修改/etc/nova/nova.conf

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron url  http://controller:9696</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron region_name  RegionOne</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron project_name  service</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron username  neutron</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron password  NEUTRON_PASS</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron service_metadata_proxy  True</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron metadata_proxy_shared_secret  METADATA_SECRET</font>

 

#检查

![1566205551590-55b5f4ce-eaf2-4d48-bdef-81fecd5455d7.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-28.png)

 

 

6：同步数据库

<font style="color:black;">ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini</font>

<font style="color:black;">su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \</font>

<font style="color:black;">  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron</font>

 

7：启动服务

<font style="color:black;">systemctl restart openstack-nova-api.service</font>

<font style="color:black;">systemctl enable neutron-server.service \</font>

<font style="color:black;">  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \</font>

<font style="color:black;">  neutron-metadata-agent.service</font>

<font style="color:black;">systemctl start neutron-server.service \</font>

<font style="color:black;">  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \</font>

<font style="color:black;">  neutron-metadata-agent.service</font>

 

#检查  这个检查要等1分钟左右再执行才有结果

![1566205551691-abab3481-fe66-47ae-9940-c19f85eb5684.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-29.png)

 

 

##计算节点上：

安装

<font style="color:black;">yum install openstack-neutron-linuxbridge ebtables ipset -y</font>

配置

<font style="color:black;">cp /etc/neutron/neutron.conf{,.bak}</font>

<font style="color:black;">grep '^[a-Z\[]' /etc/neutron/neutron.conf.bak >/etc/neutron/neutron.conf</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT rpc_backend  rabbit</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  DEFAULT auth_strategy  keystone</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_uri  http://controller:5000</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken memcached_servers  controller:11211</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken project_name  service</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken username  neutron</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken password  NEUTRON_PASS</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_concurrency lock_path  /var/lib/neutron/tmp</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_host  controller</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_userid  openstack</font>

<font style="color:black;">openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_password  RABBIT_PASS</font>

 

#检查

![1566205551802-63ec8d63-ff76-49d7-afb5-09492026b939.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-30.png)

 

####

vim /etc/neutron/plugins/ml2/linuxbridge_agent.ini   //这里里面内容全清楚

<font style="color:black;">[DEFAULT]</font>

<font style="color:black;">[agent]</font>

<font style="color:black;">[linux_bridge]</font>

<font style="color:black;">physical_interface_mappings = provider:eth0</font>

<font style="color:black;">[securitygroup]</font>

<font style="color:black;">enable_security_group = True</font>

<font style="color:black;">firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver</font>

<font style="color:black;">[vxlan]</font>

<font style="color:black;">enable_vxlan = False</font>

#检查

![1566205551886-0a58a17e-5ebf-4d0e-9449-2c954a80d56b.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-31.png)

 

#####

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron url  http://controller:9696</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron auth_url  http://controller:35357</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron auth_type  password</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron project_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron user_domain_name  default</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron region_name  RegionOne</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron project_name  service</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron username  neutron</font>

<font style="color:black;">openstack-config --set /etc/nova/nova.conf  neutron password  NEUTRON_PASS</font>

 

#检查

![1566205551975-5bbb375d-c860-4832-aac7-c8504fbfd297.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-32.png)

 

启动

<font style="color:black;">systemctl restart openstack-nova-compute.service</font>

<font style="color:black;">systemctl enable neutron-linuxbridge-agent.service</font>

<font style="color:black;">systemctl start neutron-linuxbridge-agent.service</font>

 

#检查  在控制节点查看  多一个linux bridge agent

![1566205552064-111a3427-65b9-4cc9-9d22-77029b52a904.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-33.png)

 

 

## 十四：安装horizon web界面
1：安装  (建议装在31主机上)

<font style="color:black;">yum install openstack-dashboard -y</font>

 

2：配置

 

<font style="color:black;">#</font><font style="color:black;">上传配置文件</font><font style="color:black;"> </font><font style="color:black;">重定向覆盖原配置文件</font>

<font style="color:black;">[root@compute1 ~]# rz –E</font>

<font style="color:black;">rz waiting to receive.</font>

<font style="color:black;">[root@compute1 ~]# cat local_settings >/etc/openstack-dashboard/local_settings</font>

 

3：启动  这里启动慢

<font style="color:black;">systemctl start httpd</font>

 

<font style="color:black;">less /var/log/messages   //</font><font style="color:black;">日志文件</font>

 

浏览器访问

<font style="color:black;">http://10.0.0.31/dashboard</font>

![1566205552177-d0972337-95fe-4bcf-a9dc-977ae52aace1.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-34.png)

 

如果报错

![1566205552315-3f0897e1-5873-488e-8296-e091d79f8308.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-35.png)

十五：启动一个实例

1：创建网络（网络名+子网） |控制节点执行

<font style="color:black;">neutron net-create --shared --provider:physical_network provider \</font>

<font style="color:black;">  --provider:network_type flat oldboy</font>

<font style="color:black;">neutron subnet-create --name oldgirl \</font>

<font style="color:black;">  --allocation-pool start=10.0.0.101,end=10.0.0.250 \</font>

<font style="color:black;">  --dns-nameserver 223.5.5.5 --gateway 10.0.0.254 \</font>

<font style="color:black;">  oldboy 10.0.0.0/24</font>

 

#检查

![1566205552435-52bda66f-8af9-474d-9261-67be10c054ce.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-36.png)

2:创建云主机的硬件配置方案

<font style="color:black;">openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano</font>

 

#查看当前有哪些方案

![1566205552883-1d63e31e-a6ff-4382-8154-fe222e4e8aae.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-37.png)

 

3：创建密钥对

<font style="color:black;">ssh-keygen -q -N "" -f ~/.ssh/id_rsa</font>

<font style="color:black;">openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey</font>

 

#查看列表

![1566205552967-fa7f27a3-9030-422a-a558-90d284d4ec6a.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-38.png)

 

4：创建安全组规则

<font style="color:black;">openstack security group rule create --proto icmp default</font>

<font style="color:black;">openstack security group rule create --proto tcp --dst-port 22 default</font>

 

5：启动一个实例：

 

<font style="color:black;">#</font><font style="color:black;">先查看自己的</font><font style="color:black;">id</font>

![1566205553053-8d716449-c029-4a01-8b38-521fed90c5bd.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-39.png)

 

<font style="color:black;">#</font><font style="color:black;">换成自己的</font><font style="color:black;">id </font><font style="color:black;">启动实例</font>

<font style="color:black;">openstack server create --flavor m1.nano --image cirros \</font>

<font style="color:black;">  --nic net-id=19c30f6f-9205-4802-bc65-364296e5c919 --security-group default \</font>

<font style="color:black;">  --key-name mykey oldboy </font>

 

#查看当前实例的实时状态

![1566205553196-82396462-e94d-4fef-9a92-97bf15c3057a.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-40.png)

 

#进入网页 查看实例 --> 进入控制台

![1566205553284-3009cd01-966f-41c7-b28c-f5eef28de72f.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-41.png)

 

解决办法  修改window hosts文件 C:\Windows\System32\drivers\etc\hosts

<font style="color:black;">10.0.0.11  controller</font>

 

控制台进入 但卡在GRUB

![1566205553407-a06765fe-01c4-4d06-bdb6-d14c0172088f.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-42.png)

 

解决: 修改计算节点 vim /etc/nova/nova.conf

 

<font style="color:black;">[libvirt]</font>

<font style="color:black;">cpu_mode = none</font>

<font style="color:black;">virt_type = qemu</font>

 

#修改完配置文件 重启服务

<font style="color:black;">[root@compute1 ~]# systemctl restart openstack-nova-compute.service</font>

 

网页上 硬重启实例

 

启动实例.

 

#起个名字

![1566205553571-a2e9565b-55e1-4418-ae8e-2adc2da01f1d.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-43.png)

 

#选一个镜像

![1566205553678-7797a9ce-676a-43ad-8ca3-dcfb827eb44b.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-44.png)

 

#选一个方案

![1566205553786-c8e8c698-92cd-466f-b442-bec8133975f8.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-45.png)

 

剩下不用选 -->启动实例

 

控制台登陆  ping baidu.com 看网路通不通

![1566205553893-0db4a826-b14e-4755-befa-f6c2f16066c4.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-46.png)

 

![1566205554026-12190d29-53eb-47ee-a347-6611c51b6cb0.png](img/day94-96%E4%BA%91%E8%AE%A1%E7%AE%97openstack-47.png)

 

 

重启电脑后 等一会服务都启动了再启动

<font style="color:black;">systemctl start httpd</font>

<font style="color:black;">#</font><font style="color:black;">浏览器访问</font>

<font style="color:black;">http://10.0.0.31/dashboard</font>

 

 

 

 

十六：增加一个计算节点

1：配置yum源

 

2: 时间同步

 

3：安装openstack客户端和openstack-selinux

yum install python-openstackclient.noarch  openstack-selinux.noarch -y

 

4：安装nova-compute

yum install openstack-nova-compute -y

yum install openstack-utils.noarch -y

\cp /etc/nova/nova.conf{,.bak}

grep -Ev '^$|#' /etc/nova/nova.conf.bak >/etc/nova/nova.conf

openstack-config --set /etc/nova/nova.conf  DEFAULT enabled_apis  osapi_compute,metadata

openstack-config --set /etc/nova/nova.conf  DEFAULT rpc_backend  rabbit

openstack-config --set /etc/nova/nova.conf  DEFAULT auth_strategy  keystone

openstack-config --set /etc/nova/nova.conf  DEFAULT my_ip  10.0.0.31

openstack-config --set /etc/nova/nova.conf  DEFAULT use_neutron  True

openstack-config --set /etc/nova/nova.conf  DEFAULT firewall_driver  nova.virt.firewall.NoopFirewallDriver

openstack-config --set /etc/nova/nova.conf  glance api_servers  http://controller:9292

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_uri  http://controller:5000

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_url  http://controller:35357

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  memcached_servers  controller:11211

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  auth_type  password

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  project_domain_name  default

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  user_domain_name  default

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  project_name  service

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  username  nova

openstack-config --set /etc/nova/nova.conf  keystone_authtoken  password  NOVA_PASS

openstack-config --set /etc/nova/nova.conf  oslo_concurrency lock_path  /var/lib/nova/tmp

openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_host  controller

openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_userid  openstack

openstack-config --set /etc/nova/nova.conf  oslo_messaging_rabbit   rabbit_password  RABBIT_PASS

openstack-config --set /etc/nova/nova.conf  vnc enabled  True

openstack-config --set /etc/nova/nova.conf  vnc vncserver_listen  0.0.0.0

openstack-config --set /etc/nova/nova.conf  vnc vncserver_proxyclient_address  '$my_ip'

openstack-config --set /etc/nova/nova.conf  vnc novncproxy_base_url  http://controller:6080/vnc_auto.html

openstack-config --set /etc/nova/nova.conf  neutron url  http://controller:9696

openstack-config --set /etc/nova/nova.conf  neutron auth_url  http://controller:35357

openstack-config --set /etc/nova/nova.conf  neutron auth_type  password

openstack-config --set /etc/nova/nova.conf  neutron project_domain_name  default

openstack-config --set /etc/nova/nova.conf  neutron user_domain_name  default

openstack-config --set /etc/nova/nova.conf  neutron region_name  RegionOne

openstack-config --set /etc/nova/nova.conf  neutron project_name  service

openstack-config --set /etc/nova/nova.conf  neutron username  neutron

openstack-config --set /etc/nova/nova.conf  neutron password  NEUTRON_PASS

#5：安装neutron-linuxbridge-agent

yum install openstack-neutron-linuxbridge ebtables ipset -y

\cp /etc/neutron/neutron.conf{,.bak}

grep -Ev '^$|#' /etc/neutron/neutron.conf.bak >/etc/neutron/neutron.conf

openstack-config --set /etc/neutron/neutron.conf  DEFAULT rpc_backend  rabbit

openstack-config --set /etc/neutron/neutron.conf  DEFAULT auth_strategy  keystone

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_uri  http://controller:5000

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_url  http://controller:35357

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken memcached_servers  controller:11211

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken auth_type  password

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken project_domain_name  default

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken user_domain_name  default

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken project_name  service

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken username  neutron

openstack-config --set /etc/neutron/neutron.conf  keystone_authtoken password  NEUTRON_PASS

openstack-config --set /etc/neutron/neutron.conf  oslo_concurrency lock_path  /var/lib/neutron/tmp

openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_host  controller

openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_userid  openstack

openstack-config --set /etc/neutron/neutron.conf  oslo_messaging_rabbit rabbit_password  RABBIT_PASS

 

\cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini{,.bak}

grep '^[a-Z\[]' /etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak >/etc/neutron/plugins/ml2/linuxbridge_agent.ini

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  linux_bridge physical_interface_mappings  provider:eth0

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  securitygroup enable_security_group  True

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  securitygroup firewall_driver  neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

openstack-config --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini  vxlan enable_vxlan  False

 

6：启动服务

systemctl start  libvirtd openstack-nova-compute neutron-linuxbridge-agent

 

7: 创建虚机来检查新增的计算节点是否可用！

 

十七：openstack，用户，项目，角色的关系

 

十八：glance镜像服务迁移

 

十九：cinder块存储服务

cinder-api:       接收和响应外部有关块存储请求

cinder-volume：   提供存储空间

cinder-scheduler：调度器，决定将要分配的空间由哪一个cinder-volume提供

cinder-backup：    备份存储

 

1：数据库创库授权

CREATE DATABASE cinder;

GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \

  IDENTIFIED BY 'CINDER_DBPASS';

GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \

  IDENTIFIED BY 'CINDER_DBPASS';

 

2：在keystone创建系统用户(glance,nova,neutron,cinder)关联角色

openstack user create --domain default --password CINDER_PASS cinder

openstack role add --project service --user cinder admin

 

3：在keystone上创建服务和注册api

openstack service create --name cinder \

  --description "OpenStack Block Storage" volume

openstack service create --name cinderv2 \

  --description "OpenStack Block Storage" volumev2

openstack endpoint create --region RegionOne \

  volume public http://controller:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne \

  volume internal http://controller:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne \

  volume admin http://controller:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne \

  volumev2 public http://controller:8776/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne \

  volumev2 internal http://controller:8776/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne \

  volumev2 admin http://controller:8776/v2/%\(tenant_id\)s

 

4：安装服务相应软件包

yum install openstack-cinder

 

5：修改相应服务的配置文件

cp /etc/cinder/cinder.conf{,.bak}

grep -Ev '^$|#' /etc/cinder/cinder.conf.bak >/etc/cinder/cinder.conf

openstack-config --set /etc/cinder/cinder.conf   DEFAULT  rpc_backend  rabbit

openstack-config --set /etc/cinder/cinder.conf   DEFAULT  auth_strategy  keystone

openstack-config --set /etc/cinder/cinder.conf   DEFAULT  my_ip  10.0.0.11

openstack-config --set /etc/cinder/cinder.conf   database connection mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   auth_uri  http://controller:5000

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   auth_url  http://controller:35357

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   memcached_servers  controller:11211

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   auth_type  password

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   project_domain_name  default

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   user_domain_name  default

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   project_name  service

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   username  cinder

openstack-config --set /etc/cinder/cinder.conf   keystone_authtoken   password  CINDER_PASS

openstack-config --set /etc/cinder/cinder.conf   oslo_concurrency  lock_path  /var/lib/cinder/tmp

openstack-config --set /etc/cinder/cinder.conf   oslo_messaging_rabbit  rabbit_host  controller

openstack-config --set /etc/cinder/cinder.conf   oslo_messaging_rabbit  rabbit_userid  openstack

openstack-config --set /etc/cinder/cinder.conf   oslo_messaging_rabbit  rabbit_password  RABBIT_PASS

 

6：同步数据库

su -s /bin/sh -c "cinder-manage db sync" cinder

 

7：启动服务

systemctl restart openstack-nova-api.service

systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service

systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service

 

在计算节点上：

先决条件

yum install lvm2 -y

systemctl enable lvm2-lvmetad.service

systemctl start lvm2-lvmetad.service

###增加两块硬盘

echo '- - -' >/sys/class/scsi_host/host0/scan

fdisk -l

pvcreate /dev/sdb

pvcreate /dev/sdc

vgcreate cinder-ssd /dev/sdb

vgcreate cinder-sata /dev/sdc

###修改/etc/lvm/lvm.conf

在130下面插入一行：

filter = [ "a/sdb/", "a/sdc/","r/.*/"]

 

安装

yum install openstack-cinder targetcli python-keystone -y

 

配置

[root@compute1 ~]# cat /etc/cinder/cinder.conf

[DEFAULT]

rpc_backend = rabbit

auth_strategy = keystone

my_ip = 10.0.0.31

glance_api_servers = http://10.0.0.32:9292

enabled_backends = ssd,sata

[BACKEND]

[BRCD_FABRIC_EXAMPLE]

[CISCO_FABRIC_EXAMPLE]

[COORDINATION]

[FC-ZONE-MANAGER]

[KEYMGR]

[cors]

[cors.subdomain]

[database]

connection = mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder

[keystone_authtoken]

auth_uri = http://controller:5000

auth_url = http://controller:35357

memcached_servers = controller:11211

auth_type = password

project_domain_name = default

user_domain_name = default

project_name = service

username = cinder

password = CINDER_PASS

[matchmaker_redis]

[oslo_concurrency]

lock_path = /var/lib/cinder/tmp

[oslo_messaging_amqp]

[oslo_messaging_notifications]

[oslo_messaging_rabbit]

rabbit_host = controller

rabbit_userid = openstack

rabbit_password = RABBIT_PASS

[oslo_middleware]

[oslo_policy]

[oslo_reports]

[oslo_versionedobjects]

[ssl]

[ssd]

volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver

volume_group = cinder-ssd

iscsi_protocol = iscsi

iscsi_helper = lioadm

[sata]

volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver

volume_group = cinder-sata

iscsi_protocol = iscsi

iscsi_helper = lioadm

 

 

启动

systemctl enable openstack-cinder-volume.service target.service

systemctl start openstack-cinder-volume.service target.service

 

二十：再增加flat网段

 

 

二十一：cinder对接nfs后端存储

 

nova：不提供虚拟化，支持多种虚拟化技术，nova-compute对接vmware ESXI

cinder：不提供存储，支持多种存储技术，lvm，nfs，glusterFS，ceph

 

二十二：把控制节点兼职计算节点

yum install openstack-nova-compute -y

 

vi /etc/nova/nova.conf

 

 

 

 

 

-------------------------------------------------------------------------

openstack 管理kvm虚拟机的平台

数据库： 每一个虚拟机的配置， ip地址



云主机， 无法使用keepalived高可用



主 10.0.0.7   vip：10.0.0.3  （ip都由openstack管理，不允许主机自定义ip）

从 10.0.0.8



集群架构：

云主机，负载均衡高可用SLB



物理机： keepalived高可用

 

 

 

 

 

 

 

 



> 更新: 2024-09-07 17:20:04  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/gzgs63>