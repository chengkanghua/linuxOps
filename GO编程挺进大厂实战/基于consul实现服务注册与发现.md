# 基于consul实现服务注册与发现

Consul是一个分布式、高可用性和数据中心感知的解决方案，用于跨动态、分布式基础设施连接和配置应用程序。

<font style="color:rgb(51, 51, 51);">为什么需要服务注册与服务发现：</font><https://zhuanlan.zhihu.com/p/161277955>

## Consul介绍

[Consul](https://www.consul.io/)是一个分布式、高可用性和数据中心感知的解决方案，用于跨动态、分布式基础设施连接和配置应用程序。

Consul提供了几个关键特性:

* 多数据中心——Consul被构建为数据中心感知的，可以支持任意数量的区域，而不需要复杂的配置。
* 服务网格/服务细分——使用自动 TLS 加密和基于身份的授权实现安全的服务对服务通信。应用程序可以在服务网格配置中使用 sidecar 代理为入站和出站连接建立 TLS 连接，而完全不知道连接方。
* 服务发现——Consul使服务注册自己和通过 DNS 或 HTTP 接口发现其他服务变得简单。也可以注册外部服务，如 SaaS 提供者。
* 健康检查——健康检查使得领事能够就集群中的任何问题快速向操作员发出警报。与服务发现的集成可以防止将流量路由到不健康的主机，并启用服务级断路器。
* Key/Value存储——一个灵活的键/值存储允许存储动态配置、特性标记、协调、领导选举等。简单的 HTTP API 使得在任何地方都可以轻松使用。

## Consul安装

推荐按[官方docker-compose-datacenter教程](https://learn.hashicorp.com/tutorials/consul/docker-compose-datacenter)使用docker-compose一键搭建consul环境。

推荐使用 Docker Compose 快速搭建学习使用的 Consul 环境。

执行下面的命令，从官方 github 仓库中获取的配置和资源。

```plain
git clone https://github.com/hashicorp/learn-consul-docker.git
```

这个仓库中有很多定义好的各式 consul 环境 docker-compose 配置，我们这里使用的是服务发现的环境，进入到 `datacenter-deploy-service-discovery` 目录。

```bash
cd datacenter-deploy-service-discovery
```

执行以下命令，启动容器。

```bash
❯ docker-compose up -d   # 没有- docker compose up -d
Creating network "datacenter-deploy-service-discovery_consul" with driver "bridge"
Creating consul-server ... done
Creating consul-client ... done
```

这样一个用于服务发现的Consul环境就搭建好了。

使用浏览器打开 [http:127.0.0.1:8500](http://127.0.0.1:8500/) 就可以看到Consul的管理界面了。



<!-- OCR_START -->
> C
> Services - Consul
> ←
> →
> C
> ① localhost:8500/ui/dc1/services
> T
> C
> JH
> ABP
> .
> ■
> dc1
> Help
> Settings
> Services
> Services 2 total
> Nodes
> Q Search
> Search Across
> √
> Key/Value
> Health Status
> Intentions
> Service Type
> √
> Unhealthy to Healthy
> √
> ACCESS CONTROLS
> consul
> 1 instance
> Tokens
> Policies
> dns
> 2 instances
> primary
> Roles
> Auth Methods
<!-- OCR_END -->



## 服务注册与服务发现

详细用法和参数请参照 [Agent HTTP API文档](https://www.consul.io/api-docs/agent/service)。

查询服务

| Method | Path | Produces |
| :---: | :---: | :---: |
| `GET` | `/agent/services` | `application/json` |

注册服务

| Method | Path | Produces |
| :---: | :---: | :---: |
| `PUT` | `/agent/service/register` | `application/json` |

注销服务

| Method | Path | Produces |
| :---: | :---: | :---: |
| `PUT` | `/agent/service/deregister/:service_id` | `application/json` |

**注意：** 实际Path路径前需要加`v1`版本前缀。

postman  put请求注册服务

```go
//10.211.55.6/v1/agent/service/register

{
    "id":"shop-10.211.55.6-60081",
    "name":"shop",
    "tags":["qimi","shop"],
    "address":"10.211.55.6",
    "port":60081
}
```

## Go SDK

在代码中导入官方 api 包

```go
import "github.com/hashicorp/consul/api"
```

### 连接consul

```go
type consul struct {
	client *api.Client
}

// NewConsul 连接至consul服务返回一个consul对象
func NewConsul(addr string) (*consul, error) {
	cfg := api.DefaultConfig()
	cfg.Address = addr
	c, err := api.NewClient(cfg)
	if err != nil {
		return nil, err
	}
	return &consul{c}, nil
}
```

### 获取本机出口IP

这里补充一个获取本机出口IP的方法。

```go
// GetOutboundIP 获取本机的出口IP
func GetOutboundIP() (net.IP, error) {
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		return nil, err
	}
	defer conn.Close()
	localAddr := conn.LocalAddr().(*net.UDPAddr)
	return localAddr.IP, nil
}
```

### 服务注册

将我们 grpc 服务注册到 consul。

```go
// RegisterService 将gRPC服务注册到consul
func (c *consul) RegisterService(serviceName string, ip string, port int) error {
	srv := &api.AgentServiceRegistration{
		ID:      fmt.Sprintf("%s-%s-%d", serviceName, ip, port), // 服务唯一ID
		Name:    serviceName,                                    // 服务名称
		Tags:    []string{"q1mi", "hello"},                      // 为服务打标签
		Address: ip,
		Port:    port,
	}
	return c.client.Agent().ServiceRegister(srv)
}
```

### 健康检查

consul支持健康检查。

#### gRPC服务支持健康检查

gRPC 服务要支持健康检查需要先导入相关依赖包。

```go
	import "google.golang.org/grpc/health"
	import healthpb "google.golang.org/grpc/health/grpc_health_v1"
```

注册健康检查服务。

```go
s := grpc.NewServer() // 创建gRPC服务器
healthcheck := health.NewServer()
healthpb.RegisterHealthServer(s, healthcheck)
```

#### consul添加健康检查

在向 consul 注册我们的 gRPC 服务时，可以指定健康检查的配置。

```go
// RegisterService 将gRPC服务注册到consul
func (c *consul) RegisterService(serviceName string, ip string, port int) error {
	// 健康检查
	check := &api.AgentServiceCheck{
		GRPC:                           fmt.Sprintf("%s:%d", ip, port), // 这里一定是外部可以访问的地址
		Timeout:                        "10s",
		Interval:                       "10s",
		DeregisterCriticalServiceAfter: "20s",
	}
	srv := &api.AgentServiceRegistration{
		ID:      fmt.Sprintf("%s-%s-%d", serviceName, ip, port), // 服务唯一ID
		Name:    serviceName,                                    // 服务名称
		Tags:    []string{"q1mi", "hello"},                      // 为服务打标签
		Address: ip,
		Port:    port,
		Check:   check,
	}
	return c.client.Agent().ServiceRegister(srv)
}
```

### 服务发现

通常我们会选择使用filter查询我们想要的服务，具体支持的filter策略可查看[文档](https://www.consul.io/api-docs/agent/service#filtering)。

```go
// ListService 服务发现
func (c *consul) ListService() (map[string]*api.AgentService, error) {
	// c.client.Agent().Service("hello-127.0.0.1-8972")
	return c.client.Agent().ServicesWithFilter("Service==`hello`")
}
```

### 注销服务

将服务从 consul 注销可以使用`ServiceDeregister`函数。

```go
// Deregister 注销服务
func (c *consul) Deregister(serviceID string) error {
	return c.client.Agent().ServiceDeregister(serviceID)
}
```

在现实场景中我们通常需要在某个server节点退出时将当前节点从 consul 注销。 这里搭配`chan os.Signal`实现程序退出前执行注销服务操作。

```go
lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
if err != nil {
	fmt.Printf("failed to listen: %v", err)
	return
}
s := grpc.NewServer() // 创建gRPC服务器
// 开启健康检查
healthcheck := health.NewServer()
healthpb.RegisterHealthServer(s, healthcheck)
pb.RegisterGreeterServer(s, &server{}) // 在gRPC服务端注册服务
// 注册服务
consul, err := NewConsul("127.0.0.1:8500")
if err != nil {
	log.Fatalf("NewConsul failed, err:%v\n", err)
}
ipObj, _ := GetOutboundIP()
ip := ipObj.String()
serviceId := fmt.Sprintf("%s-%s-%d", "hello", ip, port)
consul.RegisterService(serviceId, ip, port)

// 启动服务
go func() {
	err = s.Serve(lis)
	if err != nil {
		log.Printf("failed to serve: %v", err)
		return
	}
}()

quit := make(chan os.Signal)
signal.Notify(quit, syscall.SIGTERM, syscall.SIGINT)
<-quit
// 退出时注销服务
consul.Deregister(serviceId)
```

### 负载均衡

下面的示例演示了 gRPC 客户端使用 consul 作为注册中心，`round_robin`作为负载均衡策略建立 gRPC 连接的示例。其中使用了第三方的[grpc-consul-resolver](https://github.com/mbobakov/grpc-consul-resolver)库。

```go
package main

import _ "github.com/mbobakov/grpc-consul-resolver"

// ...

conn, err := grpc.Dial(
		// consul服务
		"consul://192.168.1.11:8500/hello?wait=14s",
		// 指定round_robin策略
		grpc.WithDefaultServiceConfig(`{"loadBalancingPolicy": "round_robin"}`),
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
```


> 更新: 2022-06-07 11:19:51  
> 原文: <https://www.yuque.com/chengkanghua/go/eb4y51>