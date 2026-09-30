### SLB负载均衡购买
_1.进入控制台->点击左侧负载均衡，选择创建负载均衡_

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-01.png)

_2.选择负载均衡套餐（根据公司业务需求进行选择）_

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-02.png)

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-03.png)

3.确认无误开通服务

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-04.png)

### [](#vidgxf)ECS阿里云购买
4.购买ECS云主机

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-05.png)

2.自定义ECS配置

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-06.png)

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-07.png)

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-08.png)

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-09.png)

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-10.png)

### [](#8igmun)后端多台服务器配置支持https
_**<font style="color:#FF0000;">ECS配置如需要支持https，必须配置80端口以及443端口</font>**_

```bash
1. 安装Ngix
[root@node5 ~]# yum install nginx -y
1. 配置http访问
[root@node5 conf.d]# cat /etc/nginx/conf.d/http.conf 
server {
	listen 80;
  server_name nginx.bjstack.com;
  root /code;
  index index.html;
}

mkdir /code
echo "Aliyum_SLB" > /code/index.html
systemctl restart nginx

1. 准备https相关文件
mkdir /etc/nginx/ssl_key/
##将阿里云的ssl证书下载并解压至/etc/nginx/ssl_key/
##如果没有阿里云ssl证书, 自己给自己颁发假证书

1. 配置nginx以提供https访问（启用ssl后的配置）
[root@node5 ~]# cat /etc/nginx/conf.d/http.conf 
server {
	listen 80;
	server_name nginx.bjstack.com;
	rewrite (.*) https://$server_name$request_uri redirect;
}
server {
    listen 443;
    server_name nginx.bjstack.com;
    ssl on;
    ssl_certificate   ssl_key/1524377920931.pem;
    ssl_certificate_key  ssl_key/1524377920931.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    location / {
    	root /code;
    	index index.html;
    }
}

1. 下发配置至其他web节点，使其他的后端web节点也支持https
[root@node5 ~]# scp -rp /etc/nginx root@192.168.56.6:/etc/

1. 重启所有后端的web服务
systemctl restart nginx
[root@node5 ~]# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      5461/nginx: master  
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1043/sshd           
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN      5461/nginx: master  
```

### [](#gg1mda)前端SLB配置负载均衡
1.配置

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-11.png)

2.在SLB上先加入ECS云主机

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-12.png)

3.定义SLB后端资源池（upstream）

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-13.png)

4.定义后端web服务80端口

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-14.png)





### [](#mwttsy)SLB负载均衡实现https
_<font style="color:#FF0000;">前端负载均衡通过https协议调用后端web服务器80端口,实现https请求 </font>_

_**<font style="color:#FF0000;">官方提供：证书上传到负载均衡后，负载均衡即可管理证书，不需要在后端ECS上绑定证书。</font>**_

_<font style="color:#FF0000;">https://help.aliyun.com/document_detail/54512.html?spm=a2c4g.11186623.2.20.3be62566PkgO61</font>_



```bash
9. 修改Nginx
[root@node5 conf.d]# cat /etc/nginx/conf.d/http.conf 
server {
  listen 80;
  server_name nginx.bjstack.com;
  location / {
    root /code;
    index index.html;
  	}
}

systemctl restart nginx
```



_10.推送SSL证书至SLB负载均衡，负载均衡需要使用证书，后端web节点不需要使用_

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-15.png)

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-16.png)

_创建虚拟服务器组   后端web 填80端口_



![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-17.png)

_添加监听 https 443 后端选择使用虚拟服务器池_



![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-18.png)

_服务器证书选第一步推送的证书_



![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-19.png)



_下一步 域名填写  检查端口80 路径/ _

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-20.png)

_这一步完成 ，但缺一个80 重定向443端口_

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-21.png)

_浏览器请求 _[https://nginx.bjstack.com](https://nginx.bjstack.com)_ _

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-22.png)



_<font style="color:#FF0000;">坑</font>__如出现无法请求https，请检查阿里云安全组配置_

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-23.png)



_https是能正常访问，但是不能通过http跳转到https【https必须先配置，否则http无法找到监听转发】_

_监听—》添加监听 http:80  选择监听转发 https:443_

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-24.png)

_最后完成截图_

![](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-25.png)





_**<font style="color:#FF0000;">#1.单台webServer配置https需要操作步骤如下：</font>**_

_1.阿里云需要存在已备案过的域名,并保证余额不低于100._

_2.登录阿里云购买免费的ssl证书_

_3.购买ECS云主机，配置Nginx（http跳转到https[https的证书是下载阿里云提供的证书，不要修改名称]）_

_4.打开浏览器访问即可。_



_**<font style="color:#FF0000;">#2.多台webServer配置https，一台proxy，一台配置webserver需要操作步骤如下：</font>**_

_1.阿里云需要存在已备案过的域名,并保证余额不低于100._

_2.登录阿里云购买免费的ssl证书_

_3.配置Nginx后端web，仅监听https（https的证书是下载阿里云提供的证书，不要修改名称]）_

_4.配置NginxProxy，监听80端口跳转至443端口，443端口是通过proxy_pass调度至后端_

_5.打开浏览器访问即可。_



_**<font style="color:#FF0000;">#3.前端SLB负载均衡，后端多台webServer，配置https</font>**_

_1.阿里云需要存在已备案过的域名,并保证余额不低于100._

_2.登录阿里云购买免费的ssl证书_

_3.购买多台ECS云主机，配置Nginx http（后端仅配置http）_

_4.购买SLB负载均衡，先添加服务器组 , 划分虚拟服务器组，监听后端所有服务器的80端口(实际上是定义upstream虚拟资源池)_

_5.配置阿里云的SLB，选择监听->前端监听协议https的443端口，后端监听虚拟服务器组，选择定义好的upstrem。_

_6.选择对应域名的SSL证书，证书是通过阿里云证书管理推送过来的，如果证书是第三方机构，自行在证书管理里添加。_

_7.配置负载均衡的健康检查配置->后端的域名，端口，路径_

_8.https请求能正常访问，但是http无法正常请求，需要在SLB负载均衡上配置强制跳转_

_9.配置负载均衡SLB监听端口->选择http80->会跳转出监听转发->选择之前配置好的https即可_

_10.测试http访问，测试https访问_





