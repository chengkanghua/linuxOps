# gRPC快速入门

RPC算是近些年比较火热的概念了，随着微服务架构的兴起，RPC的应用越来越广泛。本文介绍了RPC和gRPC的相关概念，并且通过详细的代码示例介绍了gRPC的基本使用。

## gRPC是什么

`gRPC`是一种现代化开源的高性能RPC框架，能够运行于任意环境之中。最初由谷歌进行开发。它使用HTTP/2作为传输协议。

> 快速了解HTTP/2就戳[HTTP/2相比HTTP/1.x有哪些重大改进？](https://www.zhihu.com/question/34074946)

在gRPC里，客户端可以像调用本地方法一样直接调用其他机器上的服务端应用程序的方法，帮助你更容易创建分布式应用程序和服务。与许多RPC系统一样，gRPC是基于定义一个服务，指定一个可以远程调用的带有参数和返回类型的的方法。在服务端程序中实现这个接口并且运行gRPC服务处理客户端调用。在客户端，有一个stub提供和服务端相同的方法。



<!-- OCR_START -->
> gRPC Client
> Name Resolver
> 2,3
> gRPCClient
> grpclb policy
> (eg DNS)
> 3a,3c
> Load
> 3b
> Balancer
> gRPCServer
> gRPCServer
> gRPCServer
<!-- OCR_END -->



## 为什么要用gRPC

使用gRPC， 我们可以一次性的在一个`.proto`文件中定义服务并使用任何支持它的语言去实现客户端和服务端，反过来，它们可以应用在各种场景中，从Google的服务器到你自己的平板电脑—— gRPC帮你解决了不同语言及环境间通信的复杂性。使用`protocol buffers`还能获得其他好处，包括高效的序列号，简单的IDL以及容易进行接口更新。总之一句话，使用gRPC能让我们更容易编写跨语言的分布式代码。

## 安装gRPC

### 安装gRPC

```bash
go get -u google.golang.org/grpc
```

### 安装Protocol Buffers v3

安装用于生成gRPC服务代码的协议编译器，最简单的方法是从下面的链接：https://github.com/google/protobuf/releases下载适合你平台的预编译好的二进制文件（`protoc-<version>-<platform>.zip`）。

* 适用Windows 64位[protoc-3.20.1-win64.zip](https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protoc-3.20.1-win64.zip)
* 适用于Mac Intel 64位[protoc-3.20.1-osx-x86_64.zip](https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protoc-3.20.1-osx-x86_64.zip)
* 适用于Mac ARM 64位[protoc-3.20.1-osx-aarch_64.zip](https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protoc-3.20.1-osx-aarch_64.zip)
* 适用于Linux 64位[protoc-3.20.1-linux-x86_64.zip](https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protoc-3.20.1-linux-x86_64.zip)

例如，我使用 Intel 芯片的 Mac 系统则下载 `protoc-3.20.1-osx-x86_64.zip` 文件，解压之后得到如下内容。



<!-- OCR_START -->
> gRPC Client
> Name Resolver
> 2,3
> gRPCClient
> grpclb policy
> (eg DNS)
> 3a,3c
> Load
> 3b
> Balancer
> gRPCServer
> gRPCServer
> gRPCServer
<!-- OCR_END -->



其中：

* bin 目录下的 protoc 是可执行文件。
* include 目录下的是 google 定义的`.proto`文件，我们`import "google/protobuf/timestamp.proto"`就是从此处导入。

我们需要将下载得到的可执行文件`protoc`所在的 bin 目录加到我们电脑的环境变量中。

### 安装插件

因为本文我们是使用Go语言做开发，接下来执行下面的命令安装`protoc`的Go插件：

安装go语言插件：

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
```

该插件会根据`.proto`文件生成一个后缀为`.pb.go`的文件，包含所有`.proto`文件中定义的类型及其序列化方法。

安装grpc插件：

```bash
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```

该插件会生成一个后缀为`_grpc.pb.go`的文件，其中包含：

* 一种接口类型(或存根) ，供客户端调用的服务方法。
* 服务器要实现的接口类型。

上述命令会默认将插件安装到`$GOPATH/bin`，为了`protoc`编译器能找到这些插件，请确保你的`$GOPATH/bin`在环境变量中。

[protocol-buffers 官方Go教程](https://developers.google.com/protocol-buffers/docs/gotutorial)

### 检查

依次执行以下命令检查一下是否开发环境都准备完毕。

1. 确认 protoc 安装完成。

```bash
❯ protoc --version
libprotoc 3.20.1
```

2. 确认 protoc-gen-go 安装完成。

```bash
❯ protoc-gen-go --version
protoc-gen-go v1.28.0
```

如果这里提示`protoc-gen-go`不是可执行的程序，请确保你的 GOPATH 下的 bin 目录在你电脑的环境变量中。

3. 确认 protoc-gen-go-grpc 安装完成。

```bash
❯ protoc-gen-go-grpc --version
protoc-gen-go-grpc 1.2.0
```

如果这里提示`protoc-gen-go-grpc`不是可执行的程序，请确保你的 GOPATH 下的 bin 目录在你电脑的环境变量中。

## gRPC的开发方式

把大象放进冰箱分几步？

1. 把冰箱门打开。
2. 把大象放进去。
3. 把冰箱门带上。

gRPC开发同样分三步：

### 编写`.proto`文件定义服务

像许多 RPC 系统一样，gRPC 基于定义服务的思想，指定可以通过参数和返回类型远程调用的方法。默认情况下，gRPC 使用 [protocol buffers](https://developers.google.com/protocol-buffers)作为接口定义语言(IDL)来描述服务接口和有效负载消息的结构。可以根据需要使用其他的IDL代替。

例如，下面使用 protocol buffers 定义了一个`HelloService`服务。

```protobuf
service HelloService {
  rpc SayHello (HelloRequest) returns (HelloResponse);
}

message HelloRequest {
  string greeting = 1;
}

message HelloResponse {
  string reply = 1;
}
```

在gRPC中你可以定义四种类型的服务方法。

* 普通 rpc，客户端向服务器发送一个请求，然后得到一个响应，就像普通的函数调用一样。

```protobuf
  rpc SayHello(HelloRequest) returns (HelloResponse);
```

* 服务器流式 rpc，其中客户端向服务器发送请求，并获得一个流来读取一系列消息。客户端从返回的流中读取，直到没有更多的消息。gRPC 保证在单个 RPC 调用中的消息是有序的。

```protobuf
  rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
```

* 客户端流式 rpc，其中客户端写入一系列消息并将其发送到服务器，同样使用提供的流。一旦客户端完成了消息的写入，它就等待服务器读取消息并返回响应。同样，gRPC 保证在单个 RPC 调用中对消息进行排序。

```protobuf
  rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
```

* 双向流式 rpc，其中双方使用读写流发送一系列消息。这两个流独立运行，因此客户端和服务器可以按照自己喜欢的顺序读写: 例如，服务器可以等待接收所有客户端消息后再写响应，或者可以交替读取消息然后写入消息，或者其他读写组合。每个流中的消息是有序的。

### 生成指定语言的代码

在 `.proto` 文件中的定义好服务之后，gRPC 提供了生成客户端和服务器端代码的 protocol buffers 编译器插件。

我们使用这些插件可以根据需要生成`Java`、`Go`、`C++`、`Python`等语言的代码。我们通常会在客户端调用这些 API，并在服务器端实现相应的 API。

* 在服务器端，服务器实现服务声明的方法，并运行一个 gRPC 服务器来处理客户端发来的调用请求。gRPC 底层会对传入的请求进行解码，执行被调用的服务方法，并对服务响应进行编码。
* 在客户端，客户端有一个称为存根（stub）的本地对象，它实现了与服务相同的方法。然后，客户端可以在本地对象上调用这些方法，将调用的参数包装在适当的 protocol buffers 消息类型中—— gRPC 在向服务器发送请求并返回服务器的 protocol buffers 响应之后进行处理。

### 编写业务逻辑代码

gRPC 帮我们解决了 RPC 中的服务调用、数据传输以及消息编解码，我们剩下的工作就是要编写业务逻辑代码。

在服务端编写业务代码实现具体的服务方法，在客户端按需调用这些方法。

## gRPC入门示例

### 编写proto代码

`Protocol Buffers`是一种与语言无关，平台无关的可扩展机制，用于序列化结构化数据。使用`Protocol Buffers`可以一次定义结构化的数据，然后可以使用特殊生成的源代码轻松地在各种数据流中使用各种语言编写和读取结构化数据。

关于`Protocol Buffers`的教程可以查看[Protocol Buffers V3中文指南](https://www.liwenzhou.com/posts/Go/Protobuf3-language-guide-zh/)，本文后续内容默认读者熟悉`Protocol Buffers`。

```protobuf
syntax = "proto3"; // 版本声明，使用Protocol Buffers v3版本

option go_package = "学习Go语言可以按照下面的顺序学习： 0.go module模式下开始新项目强烈建议先看这个视频: https://b23.tv/pa3R8Z 1.Go语言基础快速入门视频教程：https://b23.tv/IxScdW 2.Go Web开发基础gin框架入门教程：https://b23.tv/rPkNrG   自己动手写个小清单项目 3.Go Web开发进阶实战课程：https://study.163.com/course/courseMain.htm?courseId=1210171207&share=2&shareId=480000002229610  各种业务开发必备的实战技巧，搭建通用开发脚手架，各种部署方案全掌握。 ;pb";  // 指定go package名称；学习Go语言可以按照下面的顺序学习： 0.go module模式下开始新项目强烈建议先看这个视频: https://b23.tv/pa3R8Z 1.Go语言基础快速入门视频教程：https://b23.tv/IxScdW 2.Go Web开发基础gin框架入门教程：https://b23.tv/rPkNrG   自己动手写个小清单项目 3.Go Web开发进阶实战课程：https://study.163.com/course/courseMain.htm?courseId=1210171207&share=2&shareId=480000002229610  各种业务开发必备的实战技巧，搭建通用开发脚手架，各种部署方案全掌握。 通常为你项目的导入路径
//option go_package = "hello_server/pb;pb";

package pb; // 包名


// 定义服务
service Greeter {
    // SayHello 方法
    rpc SayHello (HelloRequest) returns (HelloResponse) {}
}

// 请求消息
message HelloRequest {
    string name = 1;
}

// 响应消息
message HelloResponse {
    string reply = 1;
}
```

### 编写Server端Go代码

我们新建一个`hello_server`项目，在项目根目录下执行`go mod init hello_server`。

再新建一个`pb`文件夹，将上面的 proto 文件保存为`hello.proto`，将`go_package`按如下方式修改。

```protobuf
// ...

option go_package = "hello_server/pb;pb";

// ...
```

此时，项目的目录结构为：

```bash
hello_server
├── go.mod
├── go.sum
├── main.go
└── pb
    └── hello.proto
```

在项目根目录下执行以下命令，根据`hello.proto`生成 go 源码文件。

```bash
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative pb/hello.proto
```

生成后的go源码文件会保存在pb文件夹下。

```bash
hello_server
├── go.mod
├── go.sum
├── main.go
└── pb
    ├── hello.pb.go
    ├── hello.proto
    └── hello_grpc.pb.go
```

将下面的内容添加到`hello_server/main.go`中。

```go
package main

import (
	"context"
	"fmt"
	"hello_server/pb"
	"net"

	"google.golang.org/grpc"
)

// hello server

type server struct {
	pb.UnimplementedGreeterServer
}

func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloResponse, error) {
	return &pb.HelloResponse{Reply: "Hello " + in.Name}, nil
}

func main() {
	// 监听本地的8972端口
	lis, err := net.Listen("tcp", ":8972")
	if err != nil {
		fmt.Printf("failed to listen: %v", err)
		return
	}
	s := grpc.NewServer()                  // 创建gRPC服务器
	pb.RegisterGreeterServer(s, &server{}) // 在gRPC服务端注册服务
	// 启动服务
	err = s.Serve(lis)
	if err != nil {
		fmt.Printf("failed to serve: %v", err)
		return
	}
}
```

编译并执行 `http_server`：

```bash
go build
./server
```

### 编写Client端Go代码

我们新建一个`hello_client`项目，在项目根目录下执行`go mod init hello_client`。

再新建一个`pb`文件夹，将上面的 proto 文件保存为`hello.proto`，将`go_package`按如下方式修改。

```protobuf
// ...

option go_package = "hello_client/pb;pb";

// ...
```

在项目根目录下执行以下命令，根据`hello.proto`在`http_client`项目下生成 go 源码文件。

```bash
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative pb/hello.proto
```

此时，项目的目录结构为：

```bash
http_client
├── go.mod
├── go.sum
├── main.go
└── pb
    ├── hello.pb.go
    ├── hello.proto
    └── hello_grpc.pb.go
```

在`http_client/main.go`文件中按下面的代码调用`http_server`提供的 `SayHello` RPC服务。

```go
package main

import (
	"context"
	"flag"
	"log"
	"time"

	"hello_client/pb"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

// hello_client

const (
	defaultName = "world"
)

var (
	addr = flag.String("addr", "127.0.0.1:8972", "the address to connect to")
	name = flag.String("name", defaultName, "Name to greet")
)

func main() {
	flag.Parse()
	// 连接到server端，此处禁用安全传输
	conn, err := grpc.Dial(*addr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewGreeterClient(conn)

	// 执行RPC调用并打印收到的响应数据
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.SayHello(ctx, &pb.HelloRequest{Name: *name})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.GetReply())
}
```

保存后将`http_client`编译并执行：

```bash
go build
./hello_client -name=七米
```

得到以下输出结果，说明RPC调用成功。

```bash
2022/05/15 00:31:52 Greeting: Hello 七米
```

### gRPC跨语言调用

接下来，我们演示一下如何使用gRPC实现跨语言的RPC调用。

我们使用`Python`语言编写`Client`，然后向上面使用`go`语言编写的`server`发送RPC请求。

python下安装 grpc：

```bash
python -m pip install grpcio
```

安装gRPC tools：

```bash
python -m pip install grpcio-tools
```

简洁  pip install grpcio-tools grpc_tools -i <https://pypi.douban.com/simple>

### 生成Python代码

新建一个`py_client`目录，将`hello.proto`文件保存到`py_client/pb/`目录下。 在`py_client`目录下执行以下命令，生成python源码文件。

hello.proto

```protobuf
syntax = "proto3"; // 版本声明，使用Protocol Buffers v3版本

option go_package = "hello_client/pb";

package pb; // 包名


// 定义一个打招呼服务
service Greeter {
    // SayHello 方法
    rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// 包含人名的一个请求消息
message HelloRequest {
    string name = 1;
}

// 包含问候语的响应消息
message HelloReply {
    string message = 1;
}
```

```bash
cd py_cleint
pip install grpcio-tools grpc_tools -i https://pypi.douban.com/simple

python3 -m grpc_tools.protoc -Ipb --python_out=. --grpc_python_out=. pb/hello.proto
```

### 编写Python版RPC客户端

将下面的代码保存到`py_client/client.py`文件中。

```python
from __future__ import print_function

import logging

import grpc
import hello_pb2
import hello_pb2_grpc


def run():
    # NOTE(gRPC Python Team): .close() is possible on a channel and should be
    # used in circumstances in which the with statement does not fit the needs
    # of the code.
    with grpc.insecure_channel('127.0.0.1:8972') as channel:
        stub = hello_pb2_grpc.GreeterStub(channel)
        response = stub.SayHello(hello_pb2.HelloRequest(name='q1mi'))
    print("Greeter client received: " + response.message)


if __name__ == '__main__':
    logging.basicConfig()
    run()
```

此时项目的目录结构图如下：

```bash
py_client
├── client.py
├── hello_pb2.py
├── hello_pb2_grpc.py
└── pb
    └── hello.proto
```

### Python RPC 调用

执行`client.py`调用go语言的`SayHello`RPC服务。

```bash
❯ python3 client.py
Greeter client received: Hello q1mi
```

这里我们就实现了，使用python代码编写的client去调用Go语言版本的server了。

点击右边的链接查看完整代码：[gRPC_demo完整代码](https://github.com/Q1mi/gRPC_demo)

## gRPC流式示例

### 服务端流式RPC

我们编写一个返回使用多种语言打招呼的方法。

1. 定义服务

```protobuf
   // 服务端返回流式数据
   rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
```

修改`.proto`文件后，需要重新使用 protocol buffers编译器生成客户端和服务端代码。

```protobuf
syntax = "proto3";

option go_package = "hello_server/pb;pb";

package pb;

message Request {
  string name = 1;
}

message Response {
  string reply = 1;
}

service hello{
  rpc SayHello (Request) returns (Response){}
  // 服务端流式RPC
  rpc ServerStreamHello (Request) returns (stream Response){}

}


// protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative pb/hello.proto
```

1. 服务端需要实现 ServerStreamHello 方法。

```go
package main

import (
	"context"
	"fmt"
	"hello_server/pb"
	"log"
	"net"

	"google.golang.org/grpc"
)

// hello server

type server struct {
	pb.UnimplementedHelloServer
}

func (s *server) SayHello(ctx context.Context, in *pb.Request) (*pb.Response, error) {
	return &pb.Response{Reply: "Hello " + in.Name}, nil
}

func (s *server) ServerStreamHello(in *pb.Request, stream pb.Hello_ServerStreamHelloServer) error {
	// 对传进来的人打招呼
	name := in.Name
	// 四国语言打招呼
	words := []string{
		"你好",
		"hello",
		"こんにちは",
		"여보세요",
	}

	for _, word := range words {
		// 通过stream写入打招呼的内容
		if err := stream.Send(&pb.Response{Reply: word + name}); err != nil {
			log.Printf("stream.Send failed, err:%v\n", err)
			return err
		}
	}
	return nil
}

func main() {
	// 监听本地的8972端口
	lis, err := net.Listen("tcp", ":8972")
	if err != nil {
		fmt.Printf("failed to listen: %v", err)
		return
	}
	s := grpc.NewServer()                  // 创建gRPC服务器
	pb.RegisterHelloServer(s, &server{}) // 在gRPC服务端注册服务

	log.Println("server start...")
	if err := s.Serve(lis); err != nil {
		fmt.Printf("failed to serve: %v", err)
	}
}
```

1. 客户端调用ServerStreamHello  并将收到的数据依次打印出来。(客户端的pb文件也要和服务端更新成一样)

```go
package main
import (
	"context"
	"hello_client/pb"
	"io"
	"log"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"time"
)

// hello_client

func doRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	name := "阿平"
	// 创建metadata和context.
	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
	ctx = metadata.NewOutgoingContext(ctx, md)

	res, err := c.SayHello(ctx, &pb.Request{Name: name})
	if err != nil {
		log.Fatalf("c.SayHello failed, err:%v\n", err)
	}
	log.Printf("got reply:%v\n", res.Reply)
}

// doServerStreamRPC 调用服务端流式的RPC
func doServerStreamRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	name := "阿平"
	stream, err := c.ServerStreamHello(ctx, &pb.Request{Name: name})
	if err != nil {
		log.Fatalf("c.SayHello failed, err:%v\n", err)
	}
	// 从stream中依次接收流式返回结果
	for {
		res, err := stream.Recv()
		if err == io.EOF { // io.EOF != nil
			break
		}
		if err != nil {
			log.Fatalf("stream.Recv failed, err:%v\n", err)
		}
		log.Printf("got reply:%v\n", res.Reply) // 把收到的每一次响应打印出来
	}
}

func main() {
	conn, err := grpc.Dial(":8972", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	// 创建rpc client
	client := pb.NewHelloClient(conn)

	// 发送普通的rpc调用（一来一回）
	//doRPC(client)

	// 调用服务端流式RPC
	doServerStreamRPC(client)
}
```

执行程序后会得到如下输出结果。

```bash
2022/05/21 14:36:20 got reply: "你好七米"
2022/05/21 14:36:20 got reply: "hello七米"
2022/05/21 14:36:20 got reply: "こんにちは七米"
2022/05/21 14:36:20 got reply: "여보세요七米"
```

### 客户端流式RPC

我们编写一个发送多个人名，服务端统一返回一个打招呼回复的方法。

1. 定义服务

```protobuf
// 客户端发送流式数据
rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
```

修改`.proto`文件后，需要重新使用 protocol buffers编译器生成客户端和服务端代码。

hello.proto

```protobuf
syntax = "proto3";

option go_package = "hello_client/pb;pb";

package pb;

message Request {
  string name = 1;
  string jwt = 2;
}

message Response {
  string reply = 1;
}

service hello{
  rpc SayHello (Request) returns (Response){}
  // 服务端流式RPC
  rpc ServerStreamHello (Request) returns (stream Response){}
  // 客户端流式RPC
  rpc ClientStreamHello (stream Request) returns (Response){}
}
```

1. 服务端实现ClientStreamHello 方法。

```go
package main

import (
	"context"
	"fmt"
	"hello_server/pb"
	"io"
	"log"
	"net"

	"google.golang.org/grpc"
)

// hello server

type server struct {
	pb.UnimplementedHelloServer
}

func (s *server) SayHello(ctx context.Context, in *pb.Request) (*pb.Response, error) {
	return &pb.Response{Reply: "Hello " + in.Name}, nil
}

func (s *server) ServerStreamHello(in *pb.Request, stream pb.Hello_ServerStreamHelloServer) error {
	// 对传进来的人打招呼
	name := in.Name
	// 四国语言打招呼
	words := []string{
		"你好",
		"hello",
		"こんにちは",
		"여보세요",
	}

	for _, word := range words {
		// 通过stream写入打招呼的内容
		if err := stream.Send(&pb.Response{Reply: word + name}); err != nil {
			log.Printf("stream.Send failed, err:%v\n", err)
			return err
		}
	}
	return nil
}

// ClientStreamHello 客户端发送流式数据
func (s *server) ClientStreamHello(stream pb.Hello_ClientStreamHelloServer) error {
	// 接收流式发来的请求数据
	var reply string = "你好啊 "
	for {
		res, err := stream.Recv()
		if err == io.EOF {
			// 读完了要给客户端返回一个响应
			return stream.SendAndClose(&pb.Response{Reply: reply})
		}
		if err != nil { // 读取请求数据遇到其他错误
			return err
		}
		reply += res.Name
	}
}


func main() {
	// 监听本地的8972端口
	lis, err := net.Listen("tcp", ":8972")
	if err != nil {
		fmt.Printf("failed to listen: %v", err)
		return
	}
	s := grpc.NewServer()                  // 创建gRPC服务器
	pb.RegisterHelloServer(s, &server{}) // 在gRPC服务端注册服务

	log.Println("server start...")
	if err := s.Serve(lis); err != nil {
		fmt.Printf("failed to serve: %v", err)
	}
}
```

1. 客户端调用ClientStreamHello方法，向服务端发送流式请求数据，接收返回值并打印。

```go
package main
import (
	"context"
	"hello_client/pb"
	"io"
	"log"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"time"
)

// hello_client

func doRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	name := "阿平"
	// 创建metadata和context.
	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
	ctx = metadata.NewOutgoingContext(ctx, md)

	res, err := c.SayHello(ctx, &pb.Request{Name: name})
	if err != nil {
		log.Fatalf("c.SayHello failed, err:%v\n", err)
	}
	log.Printf("got reply:%v\n", res.Reply)
}

// doServerStreamRPC 调用服务端流式的RPC
func doServerStreamRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	name := "阿平"
	stream, err := c.ServerStreamHello(ctx, &pb.Request{Name: name})
	if err != nil {
		log.Fatalf("c.SayHello failed, err:%v\n", err)
	}
	// 从stream中依次接收流式返回结果
	for {
		res, err := stream.Recv()
		if err == io.EOF { // io.EOF != nil
			break
		}
		if err != nil {
			log.Fatalf("stream.Recv failed, err:%v\n", err)
		}
		log.Printf("got reply:%v\n", res.Reply) // 把收到的每一次响应打印出来
	}
}

func doClientStreamRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	stream, err := c.ClientStreamHello(ctx)
	if err != nil {
		log.Fatalf("c.ClientStreamHello failed, err:%v\n", err)
	}
	// 客户端流式发送请求
	names := []string{
		"根正苗红",
		"三好学生",
		"阿平",
	}
	for _, name := range names {
		stream.Send(&pb.Request{Name: name})
	}
	// 发送结束之后，要告诉服务端并且要开始接收响应
	res, err := stream.CloseAndRecv()
	if err != nil {
		log.Fatalf("stream.CloseAndRecv() failed, err:%v\n", err)
	}
	// 将响应结果打印出来
	log.Printf("got reply:%v\n", res.Reply)
}


func main() {
	conn, err := grpc.Dial(":8972", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	// 创建rpc client
	client := pb.NewHelloClient(conn)

	// 发送普通的rpc调用（一来一回）
	//doRPC(client)

	// 调用服务端流式RPC
	//doServerStreamRPC(client)
	// 调用客户端流式RPC
	doClientStreamRPC(client)

}
```

执行上述函数将得到如下数据结果。

```bash
2022/06/24 20:46:26 got reply:你好啊 根正苗红三好学生阿平
```

### 双向流式RPC

我们编写一个客户端和服务端都发送流式数据的示例。

1. 定义服务

```protobuf
// 双向流式数据
rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
```

```protobuf
syntax = "proto3";

option go_package = "hello_client/pb;pb";

package pb;

message Request {
  string name = 1;
  string jwt = 2;
}

message Response {
  string reply = 1;
}

service hello{
  rpc SayHello (Request) returns (Response){}
  // 服务端流式RPC
  rpc ServerStreamHello (Request) returns (stream Response){}
  // 客户端流式RPC
  rpc ClientStreamHello (stream Request) returns (Response){}
  // 双向流式RPC
  rpc BudiStreamHello (stream Request) returns (stream Response){}
}
```

修改`.proto`文件后，需要重新使用 protocol buffers编译器生成客户端和服务端代码。

1. 服务端实现`BidiHello`方法。

```go
   func (s *server) BidiHello(stream pb.Greeter_BidiHelloServer) error {
   	for {
   		// 接收流式请求
   		in, err := stream.Recv()
   		if err == io.EOF {
   			return nil
   		}
   		if err != nil {
   			return err
   		}
   		
   		reply := magic(in.GetName()) // 对收到的数据做些处理
       
       // 返回流式响应
   		if err := stream.Send(&pb.HelloResponse{Reply: reply}); err != nil {
   			return err
   		}
   	}
   }
```

这里我们还定义了一个处理数据的`magic`函数，其内容如下。

```go
   // magic 一段价值连城的“人工智能”代码
   func magic(s string) string {
   	s = strings.ReplaceAll(s, "吗", "")
   	s = strings.ReplaceAll(s, "吧", "")
   	s = strings.ReplaceAll(s, "你", "我")
   	s = strings.ReplaceAll(s, "？", "!")
   	s = strings.ReplaceAll(s, "?", "!")
   	return s
   }
```

```go
package main

import (
	"context"
	"fmt"
	"hello_server/pb"
	"io"
	"log"
	"net"
	"strings"

	"google.golang.org/grpc"
)

// hello server

type server struct {
	pb.UnimplementedHelloServer
}

func (s *server) SayHello(ctx context.Context, in *pb.Request) (*pb.Response, error) {
	return &pb.Response{Reply: "Hello " + in.Name}, nil
}

func (s *server) ServerStreamHello(in *pb.Request, stream pb.Hello_ServerStreamHelloServer) error {
	// 对传进来的人打招呼
	name := in.Name
	// 四国语言打招呼
	words := []string{
		"你好",
		"hello",
		"こんにちは",
		"여보세요",
	}

	for _, word := range words {
		// 通过stream写入打招呼的内容
		if err := stream.Send(&pb.Response{Reply: word + name}); err != nil {
			log.Printf("stream.Send failed, err:%v\n", err)
			return err
		}
	}
	return nil
}

// ClientStreamHello 客户端发送流式数据
func (s *server) ClientStreamHello(stream pb.Hello_ClientStreamHelloServer) error {
	// 接收流式发来的请求数据
	var reply string = "你好啊 "
	for {
		res, err := stream.Recv()
		if err == io.EOF {
			// 读完了要给客户端返回一个响应
			return stream.SendAndClose(&pb.Response{Reply: reply})
		}
		if err != nil { // 读取请求数据遇到其他错误
			return err
		}
		reply += res.Name
	}
}

// BudiStreamHello 双向流式RPC
func (s *server) BudiStreamHello(stream pb.Hello_BudiStreamHelloServer) error {
	// 服务端 收一条 回复一条
	for {
		res, err := stream.Recv()
		if err != nil {
			log.Printf("stream.Recv failed, err:%v\n", err)
			return err
		}
		// 处理收到的数据拿到要返回的数据
		reply := magic(res.Name)
		// 返回响应
		if err := stream.Send(&pb.Response{Reply: reply}); err != nil {
			log.Printf("stream.Send failed, err:%v\n", err)
			return err
		}
	}
}
// magic 一段价值连城的“人工智能”代码
func magic(s string) string {
	s = strings.ReplaceAll(s, "吗", "")
	s = strings.ReplaceAll(s, "吧", "")
	s = strings.ReplaceAll(s, "你", "我")
	s = strings.ReplaceAll(s, "？", "!")
	s = strings.ReplaceAll(s, "?", "!")
	return s
}

func main() {
	// 监听本地的8972端口
	lis, err := net.Listen("tcp", ":8972")
	if err != nil {
		fmt.Printf("failed to listen: %v", err)
		return
	}
	s := grpc.NewServer()                  // 创建gRPC服务器
	pb.RegisterHelloServer(s, &server{}) // 在gRPC服务端注册服务

	log.Println("server start...")
	if err := s.Serve(lis); err != nil {
		fmt.Printf("failed to serve: %v", err)
	}
}
```

1. 客户端调用 BudiStreamHello 方法，一边从终端获取输入的请求数据发送至服务端，一边从服务端接收流式响应。

```go
package main
import (
	"bufio"
	"context"
	"hello_client/pb"
	"io"
	"log"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"os"
	"strings"
	"time"
)

// hello_client

func doRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	name := "阿平"
	// 创建metadata和context.
	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
	ctx = metadata.NewOutgoingContext(ctx, md)

	res, err := c.SayHello(ctx, &pb.Request{Name: name})
	if err != nil {
		log.Fatalf("c.SayHello failed, err:%v\n", err)
	}
	log.Printf("got reply:%v\n", res.Reply)
}

// doServerStreamRPC 调用服务端流式的RPC
func doServerStreamRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	name := "阿平"
	stream, err := c.ServerStreamHello(ctx, &pb.Request{Name: name})
	if err != nil {
		log.Fatalf("c.SayHello failed, err:%v\n", err)
	}
	// 从stream中依次接收流式返回结果
	for {
		res, err := stream.Recv()
		if err == io.EOF { // io.EOF != nil
			break
		}
		if err != nil {
			log.Fatalf("stream.Recv failed, err:%v\n", err)
		}
		log.Printf("got reply:%v\n", res.Reply) // 把收到的每一次响应打印出来
	}
}

func doClientStreamRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	stream, err := c.ClientStreamHello(ctx)
	if err != nil {
		log.Fatalf("c.ClientStreamHello failed, err:%v\n", err)
	}
	// 客户端流式发送请求
	names := []string{
		"根正苗红",
		"三好学生",
		"阿平",
	}
	for _, name := range names {
		stream.Send(&pb.Request{Name: name})
	}
	// 发送结束之后，要告诉服务端并且要开始接收响应
	res, err := stream.CloseAndRecv()
	if err != nil {
		log.Fatalf("stream.CloseAndRecv() failed, err:%v\n", err)
	}
	// 将响应结果打印出来
	log.Printf("got reply:%v\n", res.Reply)
}

// doBudiStreamRPC 调用双向流式RPC
func doBudiStreamRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Minute)
	defer cancel()

	stream, err := c.BudiStreamHello(ctx)
	if err != nil {
		log.Fatalf("c.BudiStreamHello failed, err:%v\n", err)
	}
	waitChan := make(chan struct{})
	// 一边收服务端发来的响应
	go func() { // 开启一个单独的goroutine去接收消息
		defer func() {
			waitChan <- struct{}{}
		}()
		for {
			in, err := stream.Recv()
			if err == io.EOF {
				return
			}
			if err != nil {
				log.Printf("stream.Recv failed, err:%v\n", err)
				return
			}
			// 将收到的响应打印出来
			log.Printf("AI：%v\n", in.Reply)
		}
	}()
	go func() {
		// 一边还要源源不断的发送请求数据
		// 要发送的数据是用户在终端输入的
		reader := bufio.NewReader(os.Stdin)
		for {
			c, _ := reader.ReadString('\n') // 没有输入hang住
			c = strings.TrimSpace(c)        // 去掉首尾的空格
			if len(c) == 0 {
				continue
			}
			if strings.ToUpper(c) == "QUIT" {
				break
			}
			// 把用户的输入内容发送给服务端
			stream.Send(&pb.Request{Name: c})
		}
		stream.CloseSend() // 关闭发送流
	}()
	<-waitChan
}

func main() {
	conn, err := grpc.Dial(":8972", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	// 创建rpc client
	client := pb.NewHelloClient(conn)

	// 发送普通的rpc调用（一来一回）
	//doRPC(client)
	// 调用服务端流式RPC
	//doServerStreamRPC(client)
	// 调用客户端流式RPC
	//doClientStreamRPC(client)

	// 调用双向流式RPC
	doBudiStreamRPC(client)
}
```

将服务端和客户端的代码都运行起来，就可以实现简单的对话程序了。

```bash
hello
AI：hello
你吃饭了吗?
AI：我吃饭了!
你会写代码吗
AI：我会写代码
可以和你约会吗?
AI：可以和我约会!
现在可以吗?
AI：现在可以!
走吧?
AI：走!
```

## metadata

类似于 HTTP 请求中的 Cookie 数据，元数据（[metadata](https://pkg.go.dev/google.golang.org/grpc/internal/metadata)）是关于特定 RPC 调用的信息（例如身份验证详细信息），采用键值对列表的形式，其中键是字符串，值通常是字符串，但也可以是二进制数据。 元数据对 gRPC 本身是不透明的——它允许客户端提供与服务器调用相关的信息，反之亦然。

如何访问元数据取决于具体使用的编程语言。在Go语言中 metadata 类型原始定义 （不需要自己定义）：

```go
type MD map[string][]string
```

我们可以按如下方式创建和获取 metadata。

### 普通RPC

1. client端的 metadata 操作

```go
 func unaryCallWithMetadata(c pb.GreeterClient, name string) {
   	// 创建metadata和context.
   	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   	ctx := metadata.NewOutgoingContext(context.Background(), md)
   	// 使用带有metadata的context执行RPC调用.
   	var header, trailer metadata.MD
   	r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name}, grpc.Header(&header), grpc.Trailer(&trailer))
   	if err != nil {
   		log.Fatalf("failed to call SayHello: %v", err)
   	}
   
   	if t, ok := header["timestamp"]; ok {
   		fmt.Printf("timestamp from header:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("timestamp expected but doesn't exist in header")
   	}
   	if l, ok := header["location"]; ok {
   		fmt.Printf("location from header:\n")
   		for i, e := range l {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("location expected but doesn't exist in header")
   	}
   	fmt.Printf("got response: %s\n", r.Reply)
   	if t, ok := trailer["timestamp"]; ok {
   		fmt.Printf("timestamp from trailer:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("timestamp expected but doesn't exist in trailer")
   	}
   }
```

课堂代码

```go
package main
import (
	"bufio"
	"context"
	"hello_client/pb"
	"io"
	"log"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"os"
	"strings"
	"time"
)

// hello_client

func doRPC(c pb.HelloClient) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	name := "阿平"
	// 创建metadata和context.
	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
	ctx = metadata.NewOutgoingContext(ctx, md)

	res, err := c.SayHello(ctx, &pb.Request{Name: name})
	if err != nil {
		log.Fatalf("c.SayHello failed, err:%v\n", err)
	}
	log.Printf("got reply:%v\n", res.Reply)
}



func main() {
	conn, err := grpc.Dial(":8972", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	// 创建rpc client
	client := pb.NewHelloClient(conn)

	// 发送普通的rpc调用（一来一回）
	doRPC(client)

}
```

1. 服务端的 metadata 操作

```go
func (s *server) UnarySayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloResponse, error) {
   	fmt.Println("--- UnarySayHello ---")
   	// 在defer中创建记录函数返回时间的trailer.
   	defer func() {
   		trailer := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   		grpc.SetTrailer(ctx, trailer)
   	}()
   
   	// 从客户端读取metadata.
   	md, ok := metadata.FromIncomingContext(ctx)
   	if !ok {
   		return nil, status.Errorf(codes.DataLoss, "UnarySayHello: failed to get metadata")
   	}
   	if t, ok := md["timestamp"]; ok {
   		fmt.Printf("timestamp from metadata:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	}
   
   	// 创建和发送header.
   	header := metadata.New(map[string]string{"location": "BeiJing", "timestamp": time.Now().Format("2006-01-02 15:04:05")})
   	grpc.SendHeader(ctx, header)
   
   	fmt.Printf("request received: %v, say hello...\n", in)
   
   	return &pb.HelloResponse{Reply: in.Name}, nil
   }
```

课堂代码

```go
package main

import (
	"context"
	"fmt"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
	"hello_server/pb"
	"io"
	"log"
	"net"
	"strings"

	"google.golang.org/grpc"
)

// hello server

type server struct {
	pb.UnimplementedHelloServer
}

func (s *server) SayHello(ctx context.Context, in *pb.Request) (*pb.Response, error) {
	// 从客户端读取metadata.
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return nil, status.Errorf(codes.DataLoss, "UnarySayHello: failed to get metadata")
	}
	if t, ok := md["timestamp"]; ok {
		fmt.Printf("timestamp from metadata:\n")
		// []string 打印客户端发送过来的metadata数据
		for i, e := range t {
			fmt.Printf(" %d. %s\n", i, e)
		}
	}
	return &pb.Response{
		Reply: "hello " + in.Name,
	}, nil
}

func main() {
	// 监听本地的8972端口
	lis, err := net.Listen("tcp", ":8972")
	if err != nil {
		fmt.Printf("failed to listen: %v", err)
		return
	}
	s := grpc.NewServer()                  // 创建gRPC服务器
	pb.RegisterHelloServer(s, &server{}) // 在gRPC服务端注册服务

	log.Println("server start...")
	if err := s.Serve(lis); err != nil {
		fmt.Printf("failed to serve: %v", err)
	}
}
```

### 服务端流式RPC

1. client端的metadata操作

```go
 func unaryCallWithMetadata(c pb.GreeterClient, name string) {
   	// 创建metadata和context.
   	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   	ctx := metadata.NewOutgoingContext(context.Background(), md)
   	// 使用带有metadata的context执行RPC调用.
   	var header, trailer metadata.MD
   	r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name}, grpc.Header(&header), grpc.Trailer(&trailer))
   	if err != nil {
   		log.Fatalf("failed to call SayHello: %v", err)
   	}
   
   	if t, ok := header["timestamp"]; ok {
   		fmt.Printf("timestamp from header:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("timestamp expected but doesn't exist in header")
   	}
   	if l, ok := header["location"]; ok {
   		fmt.Printf("location from header:\n")
   		for i, e := range l {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("location expected but doesn't exist in header")
   	}
   	fmt.Printf("got response: %s\n", r.Reply)
   	if t, ok := trailer["timestamp"]; ok {
   		fmt.Printf("timestamp from trailer:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("timestamp expected but doesn't exist in trailer")
   	}
   }
```

1. server端的metadata操作

```go
   func (s *server) ServerStreamingSayHello(in *pb.HelloRequest, stream pb.Greeter_LotsOfRepliesServer) error {
   	fmt.Println("--- ServerStreamingSayHello ---")
   	// 在defer中创建trailer记录函数的返回时间.
   	defer func() {
   		trailer := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   		stream.SetTrailer(trailer)
   	}()
   
   	// 读取client的metadata.
   	md, ok := metadata.FromIncomingContext(stream.Context())
   	if !ok {
   		return status.Errorf(codes.DataLoss, "ServerStreamingSayHello: failed to get metadata")
   	}
   	if t, ok := md["timestamp"]; ok {
   		fmt.Printf("timestamp from metadata:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	}
   
   	// 创建和发送header.
   	header := metadata.New(map[string]string{"location": "X2Q", "timestamp": time.Now().Format("2006-01-02 15:04:05")})
   	stream.SendHeader(header)
   
   	fmt.Printf("request received: %v\n", in)
   
   	// 读取请求数据返回响应数据.
   	for i := 0; i < 5; i++ {
   		fmt.Printf("recv name %v\n", in.Name)
   		err := stream.Send(&pb.HelloResponse{Reply: in.Name})
   		if err != nil {
   			return err
   		}
   	}
   	return nil
   }
```

### 客户端流式RPC

1. client端的metadata操作

```go
   func clientStreamWithMetadata(c pb.GreeterClient, name string) {
   	fmt.Printf("--- client streaming ---\n")
   	// 创建metadata和context.
   	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   	ctx := metadata.NewOutgoingContext(context.Background(), md)
   
   	// 使用带有metadata的context执行RPC调用.
   	stream, err := c.LotsOfGreetings(ctx)
   	if err != nil {
   		log.Fatalf("failed to call LotsOfGreetings: %v\n", err)
   	}
   
   	// 当header到达的时候读取header
   	header, err := stream.Header()
   	if err != nil {
   		log.Fatalf("failed to get header from stream: %v", err)
   	}
   	// 从server端的header中读取metadata
   	if t, ok := header["timestamp"]; ok {
   		fmt.Printf("timestamp from header:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("timestamp expected but doesn't exist in header")
   	}
   	if l, ok := header["location"]; ok {
   		fmt.Printf("location from header:\n")
   		for i, e := range l {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("location expected but doesn't exist in header")
   	}
   
   	// 发送所有数据到server端
   	for i := 0; i < 5; i++ {
   		if err := stream.Send(&pb.HelloRequest{Name: name}); err != nil {
   			log.Fatalf("failed to send streaming: %v\n", err)
   		}
   	}
   
   	// 读取响应
   	r, err := stream.CloseAndRecv()
   	if err != nil {
   		log.Fatalf("failed to CloseAndRecv: %v\n", err)
   	}
   	fmt.Printf("gor response:%s\n", r.Reply)
   
   	// 在RPC结束后读取trailer.
   	trailer := stream.Trailer()
   	// 从server端的trailer中读取metadata.
   	if t, ok := trailer["timestamp"]; ok {
   		fmt.Printf("timestamp from trailer:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("timestamp expected but doesn't exist in trailer")
   	}
   }
```

1. server端的metadata操作

```go
   func (s *server) ClientStreamingSayHello(stream pb.Greeter_LotsOfGreetingsServer) error {
   	fmt.Println("--- ClientStreamingSayHello ---")
   	// 在defer中创建trailer记录函数的返回时间.
   	defer func() {
   		trailer := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   		stream.SetTrailer(trailer)
   	}()
   
   	// 从client读取metadata.
   	md, ok := metadata.FromIncomingContext(stream.Context())
   	if !ok {
   		return status.Errorf(codes.DataLoss, "ClientStreamingSayHello: failed to get metadata")
   	}
   	if t, ok := md["timestamp"]; ok {
   		fmt.Println("timestamp from metadata:")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	}
   
   	// 创建和发送header.
   	header := metadata.New(map[string]string{"location": "X2Q", "timestamp": time.Now().Format("2006-01-02 15:04:05")})
   	stream.SendHeader(header)
   
   	// 读取请求数据发送响应数据.
   	var name string
   	for {
   		in, err := stream.Recv()
   		if err == io.EOF {
   			fmt.Println("last received message")
   			return stream.SendAndClose(&pb.HelloResponse{Reply: name})
   		}
   		name += in.Name
   		fmt.Printf("request received: %v, building reply\n", in)
   		if err != nil {
   			return err
   		}
   	}
   }
```

### 双向流式RPC

1. client端的metadata操作

```go
   func bidirectionalWithMetadata(c pb.GreeterClient, name string) {
   	fmt.Printf("--- bidirectional ---\n")
   	// 创建metadata和context.
   	md := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   	ctx := metadata.NewOutgoingContext(context.Background(), md)
   
   	// 使用带有metadata的context执行RPC调用.
   	stream, err := c.BidiHello(ctx)
   	if err != nil {
   		log.Fatalf("failed to call BidiHello: %v\n", err)
   	}
   
   	go func() {
   		// 当header到达时读取header.
   		header, err := stream.Header()
   		if err != nil {
   			log.Fatalf("failed to get header from stream: %v", err)
   		}
   		// 从server端的header中读取数据.
   		if t, ok := header["timestamp"]; ok {
   			fmt.Printf("timestamp from header:\n")
   			for i, e := range t {
   				fmt.Printf(" %d. %s\n", i, e)
   			}
   		} else {
   			log.Fatal("timestamp expected but doesn't exist in header")
   		}
   		if l, ok := header["location"]; ok {
   			fmt.Printf("location from header:\n")
   			for i, e := range l {
   				fmt.Printf(" %d. %s\n", i, e)
   			}
   		} else {
   			log.Fatal("location expected but doesn't exist in header")
   		}
   
   		// 发送所有的请求数据到server.
   		for i := 0; i < 5; i++ {
   			if err := stream.Send(&pb.HelloRequest{Name: name}); err != nil {
   				log.Fatalf("failed to send streaming: %v\n", err)
   			}
   		}
   		stream.CloseSend()
   	}()
   
   	// 读取所有的响应.
   	var rpcStatus error
   	fmt.Printf("got response:\n")
   	for {
   		r, err := stream.Recv()
   		if err != nil {
   			rpcStatus = err
   			break
   		}
   		fmt.Printf(" - %s\n", r.Reply)
   	}
   	if rpcStatus != io.EOF {
   		log.Fatalf("failed to finish server streaming: %v", rpcStatus)
   	}
   
   	// 当RPC结束时读取trailer
   	trailer := stream.Trailer()
   	// 从server的trailer中读取metadata.
   	if t, ok := trailer["timestamp"]; ok {
   		fmt.Printf("timestamp from trailer:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	} else {
   		log.Fatal("timestamp expected but doesn't exist in trailer")
   	}
   }
```

1. server端的metadata操作

```go
   func (s *server) BidirectionalStreamingSayHello(stream pb.Greeter_BidiHelloServer) error {
   	fmt.Println("--- BidirectionalStreamingSayHello ---")
   	// 在defer中创建trailer记录函数的返回时间.
   	defer func() {
   		trailer := metadata.Pairs("timestamp", time.Now().Format("2006-01-02 15:04:05"))
   		stream.SetTrailer(trailer)
   	}()
   
   	// 从client读取metadata.
   	md, ok := metadata.FromIncomingContext(stream.Context())
   	if !ok {
   		return status.Errorf(codes.DataLoss, "BidirectionalStreamingSayHello: failed to get metadata")
   	}
   
   	if t, ok := md["timestamp"]; ok {
   		fmt.Printf("timestamp from metadata:\n")
   		for i, e := range t {
   			fmt.Printf(" %d. %s\n", i, e)
   		}
   	}
   
   	// 创建和发送header.
   	header := metadata.New(map[string]string{"location": "X2Q", "timestamp": time.Now().Format("2006-01-02 15:04:05")})
   	stream.SendHeader(header)
   
   	// 读取请求数据发送响应数据.
   	for {
   		in, err := stream.Recv()
   		if err == io.EOF {
   			return nil
   		}
   		if err != nil {
   			return err
   		}
   		fmt.Printf("request received %v, sending reply\n", in)
   		if err := stream.Send(&pb.HelloResponse{Reply: in.Name}); err != nil {
   			return err
   		}
   	}
   }
```

## 加密或认证

### 无加密认证

在上面的示例中，我们都没有为我们的 gRPC 配置加密或认证。

Client端：

```go
conn, _ := grpc.Dial("127.0.0.1:8972", grpc.WithTransportCredentials(insecure.NewCredentials()))
client := pb.NewGreeterClient(conn)
```

Server端：

```go
s := grpc.NewServer()
lis, _ := net.Listen("tcp", "127.0.0.1:8972")
// error handling omitted
s.Serve(lis)
```

### 使用服务器身份验证 SSL/TLS

client端：

```go
creds, _ := credentials.NewClientTLSFromFile( , "")
conn, _ := grpc.Dial("127.0.0.1:8972", grpc.WithTransportCredentials(creds))
// error handling omitted
client := pb.NewGreeterClient(conn)
// ...
```

Server端：

```go
creds, _ := credentials.NewServerTLSFromFile(certFile, keyFile)
s := grpc.NewServer(grpc.Creds(creds))
lis, _ := net.Listen("tcp", "127.0.0.1:8972")
// error handling omitted
s.Serve(lis)
```

## 错误处理

grpc 中的错误使用[status](https://pkg.go.dev/google.golang.org/grpc/internal/status)。

所有服务方法处理程序应该从状态返回 `nil` 或`status.Status`中的错误。客户端可以直接访问错误。

遇到错误时，gRPC 服务器方法处理程序应该创建一个 `status.Status`。通常，我们会使用 `status.New`函数并传入适当的`status.Code`和错误描述来生成一个`status.Status`。调用`status.Err`方法便能将一个`status.Status`转为`error`类型。也存在一个简单的`status.Error`方法直接生成`error`。下面是两种方式的比较。

```go
// 创建status.Status
st := status.New(codes.NotFound, "some description")
err := st.Err()  // 转为error类型

// vs.

err := status.Error(codes.NotFound, "some description")
```

### 为错误添加其他详细信息

在某些情况下，可能需要为服务器端的特定错误添加详细信息。`status.WithDetails`就是为此而存在的。然后，客户端可以通过首先将普通`error`类型转换回`status.Status`，然后使用`status.Details`来读取这些详细信息。

常用的错误码由[codes](https://pkg.go.dev/google.golang.org/grpc/codes)定义，本质上是一个uint32。

```go
type Code uint32
```

目前已经定义的状态码有如下几种。

| Code | 值 | 含义 |
| :--- | :--- | --- |
| OK | 0 | 请求成功 |
| Canceled | 1 | 操作已取消 |
| Unknown | 2 | 未知错误。如果从另一个地址空间接收到的状态值属 于在该地址空间中未知的错误空间，则可以返回此错误的示例。 没有返回足够的错误信息的API引发的错误也可能会转换为此错误 |
| InvalidArgument | 3 | 表示客户端指定的参数无效。 请注意，这与 FailedPrecondition 不同。 它表示无论系统状态如何都有问题的参数（例如，格式错误的文件名）。 |
| DeadlineExceeded | 4 | 表示操作在完成之前已过期。对于改变系统状态的操作，即使操作成功完成，也可能会返回此错误。 例如，来自服务器的成功响应可能已延迟足够长的时间以使截止日期到期。 |
| NotFound | 5 | 表示未找到某些请求的实体（例如，文件或目录）。 |
| AlreadyExists | 6 | 创建实体的尝试失败，因为实体已经存在。 |
| PermissionDenied | 7 | 表示调用者没有权限执行指定的操作。 它不能用于拒绝由耗尽某些资源引起的（使用 ResourceExhausted ）。 如果无法识别调用者，也不能使用它（使用 Unauthenticated ）。 |
| ResourceExhausted | 8 | 表示某些资源已耗尽，可能是每个用户的配额，或者整个文件系统空间不足 |
| FailedPrecondition | 9 | 指示操作被拒绝，因为系统未处于操作执行所需的状态。 例如，要删除的目录可能是非空的，rmdir 操作应用于非目录等。 |
| Aborted | 10 | 表示操作被中止，通常是由于并发问题，如排序器检查失败、事务中止等。 |
| OutOfRange | 11 | 表示尝试超出有效范围的操作。 |
| Unimplemented | 12 | 表示此服务中未实施或不支持/启用操作。 |
| Internal | 13 | 意味着底层系统预期的一些不变量已被破坏。 如果你看到这个错误，则说明问题很严重。 |
| Unavailable | 14 | 表示服务当前不可用。这很可能是暂时的情况，可以通过回退重试来纠正。 请注意，重试非幂等操作并不总是安全的。 |
| DataLoss | 15 | 表示不可恢复的数据丢失或损坏 |
| Unauthenticated | 16 | 表示请求没有用于操作的有效身份验证凭据 |
| \_maxCode | 17 | - |

## 拦截器（中间件）

gRPC 提供了简单的 api，可以在每个 ClientConn/Server 基础上实现和安装拦截器。拦截器拦截每个 RPC 调用的执行。用户可以使用拦截器进行日志记录、身份验证/授权、度量收集，以及许多其他可以在 rpc 之间共享的功能。

在 gRPC 中，拦截器根据拦截的 RPC 调用类型可以分为两类。第一个是普通拦截器，它拦截普通RPC 调用。另一个是流拦截器，它处理流式 RPC 调用。每个客户机和服务器都有自己的普通截取器和流截取器类型。因此，在 gRPC 中总共有四种不同类型的拦截器。

### client端拦截器

#### 普通拦截器

```go
func unaryInterceptor(ctx context.Context, method string, req, reply interface{}, cc *grpc.ClientConn, invoker grpc.UnaryInvoker, opts ...grpc.CallOption) error {
	var credsConfigured bool
	for _, o := range opts {
		_, ok := o.(grpc.PerRPCCredsCallOption)
		if ok {
			credsConfigured = true
			break
		}
	}
	if !credsConfigured {
		opts = append(opts, grpc.PerRPCCredentials(oauth.NewOauthAccess(&oauth2.Token{
			AccessToken: fallbackToken,
		})))
	}
	start := time.Now()
	err := invoker(ctx, method, req, reply, cc, opts...)
	end := time.Now()
	logger("RPC: %s, start time: %s, end time: %s, err: %v", method, start.Format("Basic"), end.Format(time.RFC3339), err)
	return err
}
```

#### 流拦截器

```go
func streamInterceptor(ctx context.Context, desc *grpc.StreamDesc, cc *grpc.ClientConn, method string, streamer grpc.Streamer, opts ...grpc.CallOption) (grpc.ClientStream, error) {
	var credsConfigured bool
	for _, o := range opts {
		_, ok := o.(*grpc.PerRPCCredsCallOption)
		if ok {
			credsConfigured = true
			break
		}
	}
	if !credsConfigured {
		opts = append(opts, grpc.PerRPCCredentials(oauth.NewOauthAccess(&oauth2.Token{
			AccessToken: fallbackToken,
		})))
	}
	s, err := streamer(ctx, desc, cc, method, opts...)
	if err != nil {
		return nil, err
	}
	return newWrappedStream(s), nil
}
```

#### 注册拦截器

```go
creds, err := credentials.NewClientTLSFromFile(data.Path("x509/ca_cert.pem"), "x.test.example.com")
if err != nil {
  log.Fatalf("failed to load credentials: %v", err)
}
conn, err := grpc.Dial(*addr, grpc.WithTransportCredentials(creds), grpc.WithUnaryInterceptor(unaryInterceptor), grpc.WithStreamInterceptor(streamInterceptor))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
```

### server端拦截器

定义一个`validate`校验函数。

```go
// valid 校验认证信息.
func valid(authorization []string) bool {
	if len(authorization) < 1 {
		return false
	}
	token := strings.TrimPrefix(authorization[0], "Bearer ")
	// Perform the token validation here. For the sake of this example, the code
	// here forgoes any of the usual OAuth2 token validation and instead checks
	// for a token matching an arbitrary string.
	return token == "some-secret-token"
}
```

#### 普通拦截器

```go
func unaryInterceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
	// authentication (token verification)
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return nil, errMissingMetadata
	}
	if !valid(md["authorization"]) {
		return nil, errInvalidToken
	}
	m, err := handler(ctx, req)
	if err != nil {
		logger("RPC failed with error %v", err)
	}
	return m, err
}
```

#### 流拦截器

```go
func streamInterceptor(srv interface{}, ss grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
	// authentication (token verification)
	md, ok := metadata.FromIncomingContext(ss.Context())
	if !ok {
		return errMissingMetadata
	}
	if !valid(md["authorization"]) {
		return errInvalidToken
	}

	err := handler(srv, newWrappedStream(ss))
	if err != nil {
		logger("RPC failed with error %v", err)
	}
	return err
}
```

#### 注册拦截器

```go
creds, err := credentials.NewServerTLSFromFile(data.Path("x509/server_cert.pem"), data.Path("x509/server_key.pem"))
if err != nil {
  log.Fatalf("failed to create credentials: %v", err)
}

s := grpc.NewServer(grpc.Creds(creds), grpc.UnaryInterceptor(unaryInterceptor), grpc.StreamInterceptor(streamInterceptor))
```

### go-grpc-middleware

社区中有很多开源的常用的grpc中间件——[go-grpc-middleware](https://github.com/grpc-ecosystem/go-grpc-middleware)，大家可以根据需要选择使用。

## 负载均衡

负载均衡需要搭配服务注册于服务发现组件，例如 etcd、consul等。本小节示例基于 consul实现，在阅读下面的示例前推荐先阅读[基于consul实现服务注册与服务发现](https://www.liwenzhou.com/posts/Go/consul/)

### 负载均衡的工作模式



<!-- OCR_START -->
> gRPC Client
> Name Resolver
> 2,3
> gRPCClient
> grpclb policy
> (eg DNS)
> 3a,3c
> Load
> 3b
> Balancer
> gRPCServer
> gRPCServer
> gRPCServer
<!-- OCR_END -->



1. 启动时，gRPC client端会请求注册中心查询指定service的所有IP地址列表、[service config](https://github.com/grpc/grpc/blob/master/doc/service_config.md)（指定client端使用的负载均衡策略和策略配置）和一系列属性。
2. 客户端实例化负载均衡策略，并把从service配置中获取的负载均衡配置、 IP地址列表和属性传递给它。
3. 负载平衡策略为服务器的 IP 地址创建一组子通道(可能与解析器返回的 IP 地址不同)。它还监视子通道的连接状态，并决定每个子通道应该尝试连接的时间。
4. 对于每一次 RPC 请求，负载均衡策略决定本次 RPC请求 应该发送到哪个子通道(即，哪个服务器)。

gRPC默认通过`grpc.WithDefaultServiceConfig`支持两种负载均衡策略——`pick_first`和`round_robin`。

### pick_first

`pick_first`是 gRPC 负载均衡的默认值，因此不需要设置。`pick_first` 会尝试连接取到的第一个服务端地址，如果连接成功，则将其用于所有 RPC，如果连接失败，则尝试下一个地址(并继续这样做，直到一个连接成功)。因此，所有的 RPC 将被发送到同一个后端。所有接收到的响应都显示相同的后端地址。

### round_robin

`round_robin` 连接到它所看到的所有地址，并按顺序一次向每个server发送一个 RPC。 例如，我们现在注册有两个server，第一个 RPC 将被发送到 server-1，第二个 RPC 将被发送到 server-2，第三个 RPC 将再次被发送到 server-1。

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


> 更新: 2022-06-25 12:30:06  
> 原文: <https://www.yuque.com/chengkanghua/go/uf6aog>