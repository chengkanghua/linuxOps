# Apollo配置中心

[Apollo（阿波罗）](https://www.liwenzhou.com/posts/Go/apollo/www.apolloconfig.com)是携程开源的一款可靠的分布式配置管理中心，它能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性，适用于微服务配置管理场景。

[Apollo（阿波罗）](https://www.liwenzhou.com/posts/Go/apollo/www.apolloconfig.com)是携程开源的一款可靠的分布式配置管理中心，它能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性，适用于微服务配置管理场景。

## 搭建开发环境

Apollo 官方提供了一个方便学习使用的[docker-quick-start](https://github.com/apolloconfig/apollo/tree/master/scripts/docker-quick-start) 环境。我们只需要git clone 官方仓库，就可以在项目中的`scripts`目录下找到这个`docker-quick-start`文件夹。

```bash
git clone https://github.com/apolloconfig/apollo.git

cd apollo/scripts/docker-quick-start/
```

在`docker-quick-start`目录下执行下面的命令启动容器。

```bash
docker-compose up
```

等镜像下载完，容器启动之后，就可以访问本地的[http://localhost:8070](http://localhost:8070/)查看Apollo管理后台了。



<!-- OCR_START -->
> Apollo 配置中心
> →
> C
> ① localhost:8070
> ☆
> JH
> ABP
> pollo
> 搜索 Appld、应用名、配置项 Key
> 帮助
> Language→
> 管理员工具▼
> 1 apollo(apollo)
> 我的应用
> 十创建应用
> ★收藏的应用
> Appld
> 应用名称
> 部门
> 负责人
> 邮箱
> 最近浏览的应用
> SampleApp
> Sample App
> 样例部门1(TEST1)
> apollo
> apollo@acme.com
> 公共 Namespace
> Copyright 2022 Apollo Authors Q github
<!-- OCR_END -->



输入用户名`apollo`，密码`admin`后登录管理后台。



<!-- OCR_START -->
> Apollo 配置中心
> →
> C
> ① localhost:8070
> ☆
> JH
> ABP
> pollo
> 搜索 Appld、应用名、配置项 Key
> 帮助
> Language→
> 管理员工具▼
> 1 apollo(apollo)
> 我的应用
> 十创建应用
> ★收藏的应用
> Appld
> 应用名称
> 部门
> 负责人
> 邮箱
> 最近浏览的应用
> SampleApp
> Sample App
> 样例部门1(TEST1)
> apollo
> apollo@acme.com
> 公共 Namespace
> Copyright 2022 Apollo Authors Q github
<!-- OCR_END -->



Apollo支持4个维度管理Key-Value格式的配置：

* application (应用)
* environment (环境)
* cluster (集群)
* namespace (命名空间)

十分推荐大家看一下官方的[Apollo使用指南](https://www.apolloconfig.com/#/zh/usage/apollo-user-guide)，文档读到位，必定事半功倍。

## go接入Apollo

社区中有很多 [Go语言Apollo客户端](https://www.apolloconfig.com/#/zh/usage/third-party-sdks-user-guide?id=_1-go)可供选择，本文以https://github.com/philchia/agollo为例讲解如何使用Go语言接入Apollo获取配置。此外，也可以使用https://github.com/shima-park/agollo支持搭配 Viper 来使用。

### 安装

```bash
go get -u github.com/philchia/agollo/v4
```

### 使用

```go
package main

import (
	"fmt"
	"log"

	"github.com/philchia/agollo/v4"
)

func main() {
	agollo.Start(&agollo.Conf{
		AppID:           "SampleApp",
		Cluster:         "dev",
		NameSpaceNames:  []string{"application.properties", "shopping_cart.yaml"},
		MetaAddr:        "http://localhost:8080",
		AccesskeySecret: "b8ceb3ec62f34030b1b1fd9a431e420b",
	})

	agollo.OnUpdate(func(event *agollo.ChangeEvent) {
		// 监听配置变更
		log.Printf("event:%#v\n", event)
	})
	log.Println("初始化Apollo配置成功")

	// 从默认的application.properties命名空间获取key的值
	val := agollo.GetString("timeout")
	log.Println(val)
	// 获取命名空间下所有key
	keys := agollo.GetAllKeys(agollo.WithNamespace("shopping_cart.yaml"))
	fmt.Println(keys)
	// 获取指定一个命令空间下key的值
	other := agollo.GetString("content", agollo.WithNamespace("shopping_cart.yaml"))
	log.Println(other)
	// 获取指定命名空间下的所有内容
	namespaceContent := agollo.GetContent(agollo.WithNamespace("shopping_cart.yaml"))
	log.Println(namespaceContent)
}
```


> 更新: 2022-05-29 19:47:23  
> 原文: <https://www.yuque.com/chengkanghua/go/eo8r3g>