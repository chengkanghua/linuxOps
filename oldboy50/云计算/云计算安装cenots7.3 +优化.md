

勾选开启虚拟化

![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-01.png)



开机 按住tab 空格 net.ifnames=0 biosdevname=0   让网卡命名模式eth0

  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-02.png)



  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-03.png)



手动设置ip  dns 设置223.5.5.5  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-04.png)



勾选开机自启动  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-05.png)



  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-06.png)



时区选亚洲上海

  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-07.png)



支持的语言 添加一个中文

  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-08.png)

安装包只勾选 debug 兼容库  devtools（开发工具）

![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-09.png)



手动配置分区 done

  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-10.png)

 分区类型 标准分区 ， 两个分区 第一个swap 2G 剩下全部根分区  

![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-11.png)

关闭kdump    

![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-12.png)





然后开启安装 设置密码1

  
![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-13.png)



基础优化



以下代码是优化后的网卡全部配置

```bash
[root@ova ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=10.0.0.11
PREFIX=24
GATEWAY=10.0.0.254
DNS1=223.5.5.5
------------------------------------------------------------------

systemctl restart network

# 关闭防火墙 selinux
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
getenforce
sestatus
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config 

# ssh 优化  
#vi /etc/ssh/sshd_config
#93行 GSSAPIAuthentication no
#129行 UseDNS no

sed -ie "/UseDNS/s/yes/no/g;/UseDNS/s/#//g;/^GSSAPI/s/yes/no/g" /etc/ssh/sshd_config

#重启ssh
systemctl restart sshd


# hosts 的优化
vi /etc/hosts
#增加两行
10.0.0.11 controller
10.0.0.31 computel


# 修改主机名
# hostnamectl set-hostname xxxx



# 使用光盘搭建本地yum源
umount /mnt
cd /etc/yum.repos.d/
mkdir test -p
mv *.repo test

echo '[local]
name=local
baseurl=file:///mnt
gpgcheck=0'> local.repo

mount /dev/cdrom /mnt
yum makecache

#挂载iso文件的命令
mount -o loop -t iso9660 ./CentOS-7.5-x86_64-DVD-1804.iso /mnt

#---------------------------------------
cat > local.repo <<EOF
[local]
name=local
baseurl=file:///root/mnt
gpgcheck=0
EOF
----------------
cat >>     # >> 表示追加
cat '文件名'  # 文件名单引号括起来 追加内容不支持变量名了



# aliyun yum源
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#安装yum epel 源
yum -y install epel-release
```







其他优化



```bash
#关闭网卡图形化设置模式
systemctl stop NetworkManager
systemctl disable NetworkManager
#安装tab补全命令
#yum install -y bash-completion.noarch
#下载常用命令
#yum install -y net-tools vim lrzsz wget tree screen lsof tcpdump
yum install net-tools vim tree htop iotop iftop screen lsof \
iotop lrzsz sl wget unzip telnet nmap nc tcpdump psmisc \
dos2unix bash-completion sysstat rsync nfs-utils -y
#关闭邮件服务
systemctl stop postfix
systemctl disable postfix.service 

#至此，模板及优化完成，关机导出ova格式
shutdown -h now

```



剩下的服务 323 端口是时间同步服务

![](img/%E4%BA%91%E8%AE%A1%E7%AE%97%E5%AE%89%E8%A3%85cenots7.3%20%2B%E4%BC%98%E5%8C%96-14.png)







