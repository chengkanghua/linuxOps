# day61 zabbix03

day61 zabbix03

## 调整字符集
```plain
1.先搜索zabbix-web包对应字符存放的目录
[root@zabbix-server ~]# rpm -ql zabbix-web|grep fonts
/usr/share/zabbix/fonts
2.进入对应字体目录，发现字体是一个软链接
[root@zabbix-server ~]# cd /usr/share/zabbix/fonts/
[root@zabbix-server fonts]# ll
lrwxrwxrwx 1 root root 33 10月  9 12:31 graphfont.ttf -> /etc/alternatives/zabbix-web-font
3.进入软链接对应的目录，发现还是软链接
[root@zabbix-server fonts]# cd /etc/alternatives/
[root@zabbix-server fonts]# ll
lrwxrwxrwx  1 root root 38 10月  9 12:31 zabbix-web-font -> /usr/share/fonts/dejavu/DejaVuSans.ttf
4.进入最终字体存放的目录
[root@zabbix-server alternatives]# cd /usr/share/fonts/dejavu/
5.将默认字体进行改名
[root@zabbix-server alternatives]# mv DejaVuSans.ttf DejaVuSans.ttf_bak
6.上传自己准备好的字体，字体可以通过windows电脑获取（c:\windows\fonts）
7.最后将新上传的字体进行改名
[root@zabbix-server dejavu]# mv simhei.ttf DejaVuSans.ttf
注意：如果字体是ttc，修改为ttf也行。
```

聚合图形（多张图片放置一起，便于观看重要的指标）  
 先有监控项-->创建一个又一个的图形-->图形聚合在一张图上面  
 10台服务器被监控，10张  
  
幻灯片，轮播方式  
只能添加聚合图形

1.先有监控项  
2.基于监控项创建图形  
3.基于图形创建聚合图形  
4.基于聚合图形创建幻灯片（类似于ppt自动播放）  
5.图形树（第三方开发）  
6.zabbix+grafana出图，最炫

## 图形树
```plain
#1.安装graphtree
cd /usr/share/zabbix
wget https://raw.githubusercontent.com/OneOaaS/graphtrees/master/graphtree3.0.4.patch
#2.导入补丁包
yum install -y patch
patch  -Np0 <graphtree3.0.4.patch
chown -R apache.apache oneoaas
#3.新增Apache配置文件
# vim /etc/httpd/conf.d/zabbix.conf
Alias /oneoaas /usr/share/zabbix/oneoaas
#4.重启httpd服务
systemctl restart httpd
```

## 在扩展一台服务器
```plain
1.安装zabbix-agent
[root@zabbix-agent ~]# rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.14-1.el7.x86_64.rpm
2.zabbix-agent必须指向zabbix-server
[root@zabbix-agent ~]# sed -i  '/^Server=/c Server=172.16.1.71' /etc/zabbix/zabbix_agentd.conf
3.启动zabbix-agent
[root@zabbix-agent ~]# systemctl enable zabbix-agent
[root@zabbix-agent ~]# systemctl start zabbix-agent
4.在zabbix-web界面进行添加该主机，然后引用系统自带模板
5.给该主机添加自定义模板
模板里面存在很多监控项，这些监控项在该主机上能正常运行吗？
1.让该主机支持这些自定义的监控项
2.给该主机新增对应的模板文件
自定义模板
1.模板是支持导入与导出，但是模板里面的监控项是需要借助/etc/zabbix_agent.d/*.conf支撑。
2/etc/zabbix_agent.d/*.conf文件主要用于自定义监控项，自定义监控项需要依靠系统命令或者脚本来采集数据。
3.如果主机需要使用自定义的模板
1.先导入配置文件，其实就是监控项
2.然后再web界面，创建监控主机，链接新导入模板。
注意：通常情况我们会有很多的conf文件，全都是监控项，但不一定适合每台主机。
建议：有多少监控项，不管主机适合不适合，统统都导入就行。
3.如果希望将之前定义的监控项做成模板，找到监控项->全选->复制
4. 自定义使用模板（让监控项可以重复使用）
```

监控nginx  
 1.模板 监控项需要依赖.conf这个文件  
 2.conf 需要依赖脚本取值  
 3.脚本 获取想要的数据

1.自定义监控项  
 1.系统自定义监控项使用，基础（CPU、内存、网络、IO、进程、监听端口...）[]  
 2.自定义监控项（什么都能监控，只能要获取状态就一定能监控）  
 3.自定义触发器，系统自带的模板触发器阈值都比较的低  
 但条件触发器，一个监控项一个触发器  
 多条件触发器，多个监控项共用一个触发器  
 编写触发器需要遵循格式：  
 last、avg、diff、nodata、 avg(5m) avg(#5)  
 4.自定义报警  
 1.报警内容修改  
 2.报警通知方式  
 邮件---->  
 微信---->  
 短信  
 电话  
 钉钉  
 3.执行远程命令  
 1.通过ssh执行  
 2.通过sudo执行（麻烦一点点）  
 4.报警升级机制  
 1.根据步骤执行操作：  
 1-2步骤：执行远程命令  
 3-4步骤：通知管理员  
 5.告警的变量（Hostname、ITEM、TRRIger、）

5.自定义图形  
 基于监控项的基本图形  
 基于图形的聚合图形Screen  
 基于聚合图形生成幻灯片  
 grathtree一般般  
 zabbix+grafana实现更炫图(等待中...)

6.自定义一个模板  
 1.基于模板创建监控项、触发器、图形、只要主机引用即可全部载入到该主机  
 2.支持导入与导出（带走）

######## 通过agent监控系统的状态（）  
通过agent监控应用服务（Nginx、PHP、MySQL、Redis、NFS、Rsync）

####作业：  
 1.把所有的主机全部恢复初始状态（3台起）  
 2.安装zabbix-server和zabbix-agent  
 3.编写自定义监控tcp的脚本  
 4.编写监控nginx的状态，如果不存则报警（设定触发器）  
 5.设定报警（1:重试执行命令启动nginx ）  
 （2：设定报警通知的消息，通知的方式[邮件|微信]）  
 （3：通知的升级，发送给领导）  
 6.给对应的监控项创建图形  
 7.给图形创建聚合图形  
 8.制作一个幻灯片  
 9.将对应的内容制作为模板。  
 10.扩展：Grafana炫图

手动一台台的scp /etc/zabbix_agentd.conf /etc/zabbix_agent.d/*.conf  
自动化的方式 ansible 【留着】



> 更新: 2019-01-12 21:29:09  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/ufqc0n>