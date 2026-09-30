# HTTPS配置案例

## HTTPS配置案例
### 1.实战单台web服务配置HTTPS
```plain
# 1.准备文件
mkdir /etc/nginx/ssl_key -p
cd /etc/nginx/ssl_key
openssl genrsa -idea -out server.key 2048
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt

# 2.配置nginx
[root@web03 conf.d]# cat https.conf 
server {
  listen 443;
  server_name s.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    root /code;
    index index.html;
  }
}
server {
  listen 80;
  server_name s.oldboy.com;
  rewrite (.*) https://$server_name$1 redirect;
  #return 302 https://$server_name$request_uri;
}

```

### 2实战Nginx负载均衡+Nginx WEB配置HTTPS
```bash
### 注意：ssl证书使用通配符，生产必须统一，如果是自己签发证书可以随意使用（黑户）
# 1.环境准备
角色      外网IP(NAT)       内网IP(LAN)       服务
lb01    eth0:10.0.0.5   eth1:172.16.1.5    nginx-proxy
web01   eth0:10.0.0.7   eth1:172.16.1.7     nginx-web01
web02   eth0:10.0.0.8   eth1:172.16.1.8     nginx-web02

# 2.先配置后端的所有web节点, 如下操作,统一配置
//生成证书（仅生成一次即可, 其他机器拷贝）
mkdir /etc/nginx/ssl_key -p
cd /etc/nginx/ssl_key
openssl genrsa -idea -out server.key 2048
openssl req -days 36500 -x509 -sha256 -nodes -newkey rsa:2048 -keyout server.key -out server.crt

//配置后端节点通过https方式访问，如果该节点不直接对用户访问提供服务，则不需要启动http端口
[root@web01 conf.d]# cat wordpress.conf
server {
  listen 80;
  server_name wordpress.oldboy.com;
  rewrite (.*) https://$server_name$request_uri redirect;
}
server {
  listen 443;
  server_name wordpress.oldboy.com;
  ssl on;
  ssl_certificate   ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    root /code/wordpress;
    index index.php index.html;
  }
  location ~ \.php$ {
    root /code/wordpress;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
  }
}

# 3.配置第二台web节点
[root@web01 ~]# scp -rp /etc/nginx/ssl_key/ root@172.16.1.8:/etc/nginx/  
[root@web01 ~]# scp -rp /etc/nginx/conf.d/ root@172.16.1.8:/etc/nginx/
# 4.重启两台后端web节点Nginx
[root@web01 ~]# systemctl restart nginx
[root@web02 ~]# systemctl restart nginx

# 5.拷贝web上的ssl证书至Proxy
[root@web01 ~]# scp -rp /etc/nginx/ssl_key/ root@172.16.1.5:/etc/nginx/

# 6.配置Nginx负载均衡调度
[root@lb01 ~]# cat /etc/nginx/conf.d/proxy.conf 
# 必须修改后端监听资源池为443端口
upstream site {
  server 172.16.1.7:443 max_fails=1 fail_timeout=60s;
  server 172.16.1.8:443 max_fails=1 fail_timeout=60s;
}
# 接收用户https请求, 将请求内容抛至后端web节点
server {
  listen 443;
  server_name blog.oldboy.com;
  ssl on;
  ssl_certificate  ssl_key/server.crt;
  ssl_certificate_key  ssl_key/server.key;
  location / {
    proxy_pass https://site;
    include proxy_params;
  }
}
# 用户通过http请求跳转至https
server {
  listen 80;
  server_name blog.oldboy.com;
  return 302 https://$server_name$request_uri;
}
# 7.重启Proxy Nginx
systemctl restart nginx

# 8.wordpress早期安装如果是使用http方式, 那开启https后会导致wordpress出现破图或加载不全的情况。
建议:
1.在安装wordpress之前就配置好https
2.在wordpress后台管理页面, 设置->常规->修改（WordPress地址以及站点地址）为 https://
```





###########################################################

## ![1547292159199-dcee986c-c1d1-4dfb-905d-10a2b0759fb7.png](img/HTTPS%E9%85%8D%E7%BD%AE%E6%A1%88%E4%BE%8B-01.png)


![1547292166338-e494bd1b-4b53-4ce1-898d-55519bdc5be9.png](img/HTTPS%E9%85%8D%E7%BD%AE%E6%A1%88%E4%BE%8B-02.png)

![1547292172166-351d0042-8086-491a-b859-c7424df937f8.png](img/HTTPS%E9%85%8D%E7%BD%AE%E6%A1%88%E4%BE%8B-03.png)



> 更新: 2026-05-06 15:45:22  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/nylmf8>