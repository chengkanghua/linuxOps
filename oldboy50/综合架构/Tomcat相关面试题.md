# Tomcat 相关面试题

> 掌握 Server / Service / Connector / Container 四大组件的关系与功能，Tomcat 相关面试题基本无忧。面试时要有意识地把 Spring MVC 执行流程、URL 完整调用链路等题目，往「Tomcat 处理请求的过程」上引——面试官会很欣赏。

学完本节应明白：
- Server、Service、Connector、Container 四者的关系、联系与主要功能；
- Tomcat 整体架构，请求如何一步步被处理；
- Engine、Host、Context、Wrapper 的概念关系；
- Container 如何处理请求；
- Tomcat 用到的设计模式（责任链、观察者/监听器、模板方法等）。

---

## 一、Tomcat 顶层架构

Tomcat 最顶层的容器是 **Server**，代表整个服务器；一个 Server 可包含至少一个 Service，用于具体提供服务。

Service 主要包含两部分：**Connector** 和 **Container**，它们是 Tomcat 的心脏：
- **Connector**：处理连接相关的事，提供 Socket 与 Request/Response 的转化；
- **Container**：封装和管理 Servlet，具体处理 Request。

> 一个 Tomcat 只有一个 Server；一个 Server 可含多个 Service；一个 Service 只有一个 Container，但可有多个 Connector（如同时提供 HTTP 和 HTTPS，或同协议不同端口）。

多个 Connector + 一个 Container 组成 Service，Service 还需要一个生存环境（由 Server 掌控其生命周期），因此整个 Tomcat 的生命周期由 Server 控制。

上述包含/父子关系都对应 `conf/server.xml` 配置（Tomcat 8.0 配置文件结构图见原文配图）。`Server` 标签的 `port=8005`、`shutdown="SHUTDOWN"` 表示在 8005 端口监听 SHUTDOWN 命令，收到即关闭。

---

## 二、顶层架构小结

1. Tomcat 只有一个 Server；一个 Server 可有多个 Service；一个 Service 可有多个 Connector 和一个 Container。
2. Server 掌管整个 Tomcat 的生死。
3. Service 对外提供服务。
4. Connector 接收请求并封装成 Request/Response。
5. Container 封装管理 Servlet，具体处理 request。

> 开发中绝大多数配置都在 Connector 和 Container 范畴，所以接下来重点看这两者。

---

## 三、Connector 与 Container 的关系

请求发到 Tomcat → 经 Service 交给 Connector → Connector 封装成 Request/Response → 交给 Container 处理 → Container 处理完返回 Connector → Connector 通过 Socket 把结果返回客户端。

Connector 最底层用 **Socket** 连接，Request/Response 按 **HTTP 协议**封装，所以 Connector 同时要处理 TCP/IP 和 HTTP 两种协议。

---

## 四、Connector 架构分析

Connector 接收请求并封装成 Request/Response，再交给 Container，处理完又交回 Connector。

可从四方面理解：
1. Connector 如何接收请求？
2. 如何将请求封装成 Request/Response？
3. 封装后如何交给 Container？
4. Container 处理完如何交回 Connector 并返回客户端？

Connector 用 **ProtocolHandler** 处理请求，不同 ProtocolHandler 代表不同连接类型：
- `Http11Protocol`：普通 Socket 连接；
- `Http11NioProtocol`：NioSocket 连接。

ProtocolHandler 含三个部件：**Endpoint、Processor、Adapter**。
- **Endpoint**：处理底层 Socket 网络连接（实现 TCP/IP）；
- **Processor**：把 Endpoint 收到的 Socket 封装成 Request（实现 HTTP）；
- **Adapter**：把 Request 适配交给 Container 处理。

Endpoint 的抽象 `AbstractEndpoint` 定义了 `Acceptor`（监听请求）、`AsyncTimeout`（检查异步请求超时）、`Handler`（处理收到的 Socket，内部调用 Processor）。

至此 (1)(2)(3) 已能回答；(4) 需看 Container 如何处理及如何返回。

---

## 五、Container 架构分析

Container 封装管理 Servlet、具体处理 Request，内部包含 **4 个子容器**：

| 子容器 | 作用 |
| --- | --- |
| **Engine** | 引擎，管理多个站点；一个 Service 最多一个 Engine |
| **Host** | 代表一个站点（虚拟主机），配 Host 即可加站点 |
| **Context** | 代表一个应用（一套程序 / WEB-INF + web.xml） |
| **Wrapper** | 每个 Wrapper 封装一个 Servlet |

`webapps` 是一个 Host 站点，其下每个文件夹是一个 Context，`ROOT` 是主应用；访问 `ROOT` 直接用域名（如 `www.ledouit.com`），访问其他应用用 `www.ledouit.com/docs`。

---

## 六、Container 如何处理请求（Pipeline-Valve 管道）

Container 用 **Pipeline-Valve 管道**处理请求（Valve = 阀门），本质采用**责任链模式**：请求处理过程中多个处理者依次处理，各管一段，再交给下一个。

但与普通责任链有两点不同：
1. 每个 Pipeline 都有**特定的最后一个 Valve（BaseValve）**，不可删除；
2. 上层容器管道的 BaseValve 会调用下层容器的管道。

四个子容器对应的 BaseValve：`StandardEngineValve`、`StandardHostValve`、`StandardContextValve`、`StandardWrapperValve`。

**处理流程**
1. Connector 收到请求，先调用最顶层容器（Engine）的管道 `EnginePipeline`；
2. 依次执行 `EngineValve1`、`EngineValve2`… 最后 `StandardEngineValve` → 调用 Host 管道 → `StandardHostValve` → Context 管道 → Wrapper 管道 → `StandardWrapperValve`；
3. 到 `StandardWrapperValve` 时创建 `FilterChain` 并调用 `doFilter`，依次执行匹配的 Filter 和 Servlet 的 `service` 方法，请求得到处理；
4. 所有 Pipeline-Valve 执行完，结果交回 Connector，Connector 通过 Socket 返回客户端。

---

## 七、常见面试题

1. **Tomcat 顶层架构是什么关系？**
   Server ⊃ Service（多个 Connector + 一个 Container）⊃ Engine ⊃ Host ⊃ Context ⊃ Wrapper。Server 掌控整个生命周期。

2. **Connector 的作用？它实现了哪些协议？**
   接收连接、把 Socket 请求封装成 HTTP 的 Request/Response 交给 Container。底层用 Socket 实现 TCP/IP，Request/Response 按 HTTP 协议封装，所以同时处理这两种协议。

3. **Connector 内部 ProtocolHandler 含哪三个部件？**
   Endpoint（TCP/IP 网络层）、Processor（HTTP 封装）、Adapter（适配交给 Servlet 容器）。`Http11NioProtocol` 用 NioSocket。

4. **Container 的四个子容器分别是什么？**
   Engine（站点集合）、Host（虚拟主机/站点）、Context（一个 Web 应用）、Wrapper（一个 Servlet）。

5. **Container 如何处理请求？**
   通过 Pipeline-Valve 责任链：从 Engine 管道逐级下钻到 Wrapper，最终在 StandardWrapperValve 创建 FilterChain 调用 Filter 和 Servlet，再把响应经管道逐层返回 Connector。

6. **Pipeline-Valve 和普通责任链的区别？**
   每个管道都有不可删除的 BaseValve 且最后执行；上层 BaseValve 会调用下层容器管道。

7. **Tomcat 用到了哪些设计模式？**
   责任链（Pipeline-Valve）、观察者/监听器（Listener 监听生命周期事件）、模板方法（容器生命周期 `init/start/stop` 模板）等。

8. **为什么访问 ROOT 应用直接用域名，其他应用要带路径？**
   Host 站点下每个目录是一个 Context；`path=""` 的 Context 是默认应用（ROOT），匹配不到其他 path 时回落到它；其他应用 path 为目录名（如 `/docs`），故需 `域名/docs`。

---

> 原文参考：<https://www.cnblogs.com/54chensongxia/p/12530651.html>
