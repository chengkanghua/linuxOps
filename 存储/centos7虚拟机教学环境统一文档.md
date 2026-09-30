# centos7虚拟机环境统一文档

## 创建虚拟机注意事项

### 内存大小

![](img/img-01.png)

### 网络类型

![](img/img-02.png)

### 安装包选择

选包的话大家最好和我下面的一致（左边GNOME Desktop,右边全打勾)

![](img/img-03.png)

### 分区规划

![](img/img-04.png)

![](img/img-05.png)

![](img/img-06.png)

## 安装完成后注意事项

### 网络配置

![](img/img-07.png)

![](img/img-08.png)

### 关闭selinux

![](img/img-09.png)

### 主机名配置与关闭防火墙

![](img/img-10.png)

### yum源保持默认

![](img/img-11.png)

```bash
# yum clean all
# yum makecache
```

### 时间同步

![](img/img-12.png)

### 开机启动级别设置

```bash
# systemctl get-default         查看开机启动级别
graphical.target                相当于为5级别

# systemctl set-default multi-user.target       设置为
multi-user.target(相当于3级别)

# systemctl get-default
multi-user.target               确认开机启动级别为multi-
user.target(相当于3级别)
```

### 重启系统

selinux关闭后需要reboot才能生效,验证开机启动级别也需要reboot

```bash
# reboot
```

## 验证

![](img/img-13.png)

## 快照

上面都做好后，就可以做一个快照了

## 克隆

然后将这个虚拟机克隆5个, 克隆后的虚拟机，需要做如下修改

- 修改IP

- 修改对应的主机名

- 再次iptables -F 清除防火墙规则

再次做快照(因为克隆是不克隆快照的)

这样, 一共准备了6台完美快照虚拟机，大功告成。以后不用麻烦准备环境了。
