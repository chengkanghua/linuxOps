# Nginx Web服务内核调优

# Nginx Web服务内核调优

`时间:2016.10.17`

笔者Q:552408925、572891887 

架构师群:471443208

```plain
#fs.file-max = 102400 
vm.swappiness = 0
#net.nf_conntrack_max = 655360
net.netfilter.nf_conntrack_tcp_timeout_established = 1200
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_recycle = 0
#net.ipv4.tcp_tw_reuse = 1
#net.ipv4.tcp_timestamps = 0
#net.ipv4.tcp_max_syn_backlog = 200000
#net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_syn_retries = 1
#net.ipv4.tcp_fin_timeout = 1
net.ipv4.ip_local_port_range = 1024 65535
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
#net.core.somaxconn = 262144
#net.ipv4.tcp_keepalive_time = 1200
```

> 更新: 2019-03-21 09:27:02  
> 原文: <https://www.yuque.com/chengkanghua/xuliangwei/pv8fnn>