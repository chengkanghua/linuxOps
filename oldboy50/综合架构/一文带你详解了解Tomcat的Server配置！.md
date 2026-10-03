# 详解 Tomcat 的 server.xml 配置

> Tomcat 的核心配置都在 `$TOMCAT_HOME/conf/server.xml`。理解它的组件层级，是排错、做虚拟主机、多实例、性能调优的基础。下文配合官方 server.xml 实例逐元素讲解，阅读时可对照参考图。

---

## 一、server.xml 的整体结构

```xml
<Server>                    <!-- 整个 Tomcat 容器（必须唯一最外层） -->
  <Service name="Catalina"> <!-- 一组 Connector + 一个 Engine -->
    <Connector .../>        <!-- 接收请求（HTTP/AJP） -->
    <Connector .../>
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
        <Context .../>      <!-- 一个 Web 应用（自动部署时通常不写） -->
      </Host>
    </Engine>
  </Service>
</Server>
```

**元素分类（4 类）**

| 分类 | 元素 | 作用 |
| --- | --- | --- |
| 顶层 | `<Server>`、`<Service>` | Server 是整个容器；Service 把 Connector 和 Engine 组装一起对外服务 |
| 连接器 | `<Connector>` | 外部客户端与 Service 通信的接口（收请求 + 回响应） |
| 容器 | `<Engine>`、`<Host>`、`<Context>` | 处理请求并产生响应，三者是**父子**关系：Engine ⊃ Host ⊃ Context |
| 内嵌组件 | Listener / Realm / Valve / GlobalNamingResources 等 | 嵌入容器，提供监听、安全、日志等辅助能力 |

---

## 二、核心组件详解

### 1. Server
- 最顶层的根元素，**唯一**。
- `port`：接收 shutdown 指令的端口；设为 `-1` 可禁掉。
- `shutdown`：关闭口令（向该端口发送此字符串即关闭 Tomcat）。
- 职责：提供接口让客户端访问其下所有 Service，并维护各 Service 的初始化、销毁、查找生命周期。

### 2. Service
- 在 Connector 和 Engine 外面包一层，组装成对外服务。
- 一个 Service 可含**多个 Connector**，但**只能有一个 Engine**；Connector 收请求、Engine 处理请求。
- Tomcat 可配多个 Service（监听不同端口）。

### 3. Connector
- 接收连接、创建 `Request`/`Response`、分配线程交给 Engine、再把结果传回客户端。
- 常见两个：
  - **HTTP Connector**（8080）：`protocol="HTTP/1.1"`。`redirectPort` 指强制 https 时重定向到 8443；`connectionTimeout` 连接超时。
  - **AJP Connector**（8009）：`protocol="AJP/1.3"`，用于与 Apache 等集成（Apache 处理静态、Tomcat 当 Servlet/JSP 容器）。
- 生产中 Tomcat 常监听 8080 而非 80，因为前面通常加 Nginx 反向代理（局域网内用 8080 即可）。

### 4. Engine
- Service 中**有且仅有一个**，是请求处理组件，从 Connector 收请求、返回响应。
- `name`：日志/错误信息用，整 Server 内唯一。
- `defaultHost`：当请求 Host 名匹配不到时使用的默认虚拟主机，**值必须**与某个 Host 的 `name` 一致。

### 5. Host（虚拟主机）
- Engine 的子容器，可内嵌 1 个或多个；每个代表一个虚拟主机，需在网络（DNS）中注册主机名。
- 作用：运行多个 Web 应用（一个 Context = 一个应用），负责安装/展开/启动/停止。
- 客户端通过 HTTP 头的主机名连接，Tomcat 据此匹配 Host；匹配不到 → 默认 Host。
- 关键属性：
  - `name`：虚拟主机名（其中一个须等于 Engine 的 `defaultHost`）。
  - `unpackWARs`：是否解压 WAR 运行（true 解压后运行，false 直接用 WAR）。
  - `autoDeploy` / `deployOnStartup` / `appBase` / `xmlBase`：决定自动部署行为（见下）。

### 6. Context（Web 应用）
- Host 的子容器，每个代表在特定虚拟主机上的一个 Web 应用。
- 自动部署下 server.xml 通常不写 Context，由 Tomcat 按规则自动部署。
- 自动部署机制：`deployOnStartup`/`autoDeploy` 为 true 时，Tomcat 启动/运行期定期扫描；`appBase` 指定应用目录（默认 `webapps`），`xmlBase` 指定 XML 配置目录（默认 `conf/Catalina/localhost`）。
- 扫描顺序：① xmlBase 下的 XML 配置 → ② appBase 下的 WAR → ③ appBase 下的应用目录。
- 关键属性：
  - `docBase`：WAR 或应用目录路径（自动部署且不在 appBase 中才需指定）。
  - `path`：访问上下文路径；`path=""` 为该虚拟主机默认应用。自动部署下由文件名/WAR名/目录名推导（ROOT → `""`）。
  - `reloadable`：是否监控 class 改动自动重载；**开发环境 true 便于调试，生产环境 false**（否则有性能压力）。

---

## 三、核心组件的关联（请求如何被处理）

1. **按协议和端口选定 Service/Engine**：请求到 8080（HTTP）→ 选中监听该端口的 Service → Engine 确定。
2. **按域名/IP 选定 Host**：在 Service 内匹配 `name` 与主机名相同的 Host；否则用 `defaultHost`。
3. **按 URI 选定 Context**：根据应用的 `path` 与 URI 匹配程度选择 Web 应用。

**举例**：`http://localhost:8080/app1/index.html`
```
协议+端口(http:8080) → 选定 Service
主机名(localhost)       → 选定 Host
URI(/app1/index.html)  → 选定 app1 应用
```

### 配置多个 Service（多端口访问不同应用）
1. 复制一份 `<Service>` 放在当前 Service 之后。
2. 改 `<Connector>` 的 `port`（确保未被占用）。
3. 改 Service 和 Engine 的 `name`。
4. 改 Host 的 `appBase`（如 `webapps2`）。
5. 新应用仍用自动部署。
6. 把原 webapps 下的 docs 拷到 webapps2 → 可通过 `http://localhost:8080/docs/` 和 `http://localhost:8084/docs/` 两个端口访问。

---

## 四、其他组件

### 1. Listener（监听器）
特定事件（Tomcat 启停）发生时执行操作。例子中 6 个都在 Server 中，且只能存在于 Server。核心是 `className`（须实现 `LifecycleListener`）。

- `VersionLoggerListener`：启动时记录 Tomcat/Java/OS 信息（须第一个）。
- `AprLifecycleListener`：存在 APR 库时加载（提升性能与本地集成）。
- `JasperListener`：启动前初始化 Jasper（JSP 引擎，把 JSP 解析成 java 再编译成 class）。
- `JreMemoryLeakPreventionListener`：防止类加载器导致的内存泄漏。
- `GlobalResourcesLifecycleListener`：初始化全局 JNDI 资源（无它则用不了全局资源）。
- `ThreadLocalLeakPreventionListener`：Web 应用因 thread-local 内存泄漏停止时，触发线程池线程更新。

### 2. GlobalNamingResources 与 Realm
- `Realm`（域）：提供用户密码与 Web 应用的映射，实现角色安全管理。
- 本例 Realm 用名为 `UserDatabase` 的资源实现，该资源在 Server 的 `GlobalNamingResources` 中通过读取 `conf/tomcat-users.xml` 定义。

### 3. Valve（阀门）
请求处理流水线上的组件，可关联到 Engine/Host/Context。
- `AccessLogValve`：记录所在容器的所有请求访问日志（放在 Host 下则记该 Host 全部请求）。

| 属性 | 含义 |
| --- | --- |
| className | Valve 类型（此处 AccessLogValve） |
| directory | 日志目录（默认 `$TOMCAT_HOME/logs`） |
| prefix / suffix | 日志文件名前缀 / 后缀 |
| pattern | 日志格式 |

**pattern 常用字段**
| 字段 | 含义 |
| --- | --- |
| `%h` | 远程主机名/IP（有代理则是代理 IP） |
| `%l` | 远程逻辑用户名，总是 `-` |
| `%u` | 授权的远程用户名，无则 `-` |
| `%t` | 访问时间 |
| `%r` | 请求首行（方法 + URI + 协议） |
| `%s` | 响应状态码 |
| `%b` | 响应数据量（不含头，0 显示 `-`） |
| `%D` | 请求处理耗时（毫秒，常用做性能分析） |

> 访问日志可用于分析接口访问比例、成功率、慢请求，指导优化。

---

## 五、Tomcat 结构原理补充

**目录结构**
```
bin      启动/关闭脚本
conf     server.xml、web.xml 等配置
lib      Tomcat 运行库
logs     运行日志
webapps  Web 部署根目录
work     jsp 编译后的 class 文件
```

**组件关系速记**
- **Server**：维护其下所有 Service 的生命周期。
- **Service**：含多个 Connector + 一个容器 Engine。
- **Connector**：监听请求（8080 HTTP / 8009 AJP），提交容器处理，返回结果。
- **Engine**：含多个虚拟主机，匹配不到用默认 Host。
- **Host**：虚拟主机，按最长匹配选 Context；`path=""` 为默认应用。
- **Context**：一个 Web 应用，由若干 Servlet 组成；按 web.xml 的 mapping table 找对应 Servlet 处理。

**一个 HTTP 请求的处理全过程**（以 `http://localhost:8080/wsota/wsota_index.jsp` 为例）
```
1. 请求到 8080 → Coyote HTTP/1.1 Connector 接收
2. Connector 交给所属 Service 的 Engine
3. Engine 匹配虚拟主机 → localhost Host
4. Host 匹配 Context → /wsota
5. Context 匹配 URL PATTERN *.jsp → JspServlet
6. 构造 HttpServletRequest/Response，调用 JspServlet 的 doGet/doPost
7. Context → Host → Engine → Connector → 浏览器（逐级返回响应）
```

---

## 六、常见面试题

1. **server.xml 的组件层级是什么？**
   Server ⊃ Service（含多个 Connector + 一个 Engine）⊃ Engine ⊃ Host ⊃ Context。

2. **Tomcat 一个 Service 能有几个 Engine/Connector？**
   一个 Service 只能有一个 Engine，可有多个 Connector（监听不同端口/协议）。

3. **请求来了 Tomcat 怎么确定交给谁处理？**
   先按协议+端口选定 Service/Engine，再按 Host 名匹配 Host（否则默认 Host），最后按 URI 匹配 Context（path）。

4. **自动部署和静态部署（在 server.xml 写 Context）区别？**
   自动部署靠 `autoDeploy`/`deployOnStartup` + 扫描 appBase/xmlBase，运行中可动态加载、无需重启；静态部署写在 server.xml 里，需重启才能生效（不推荐）。

5. **`reloadable=true` 在生产和开发环境怎么设？**
   开发环境设 true 便于改 class 自动重载；生产环境必须 false，否则持续监控 class 变更会拖慢性能。

6. **为什么生产环境 Tomcat 常监听 8080 而不是 80？**
   前面通常前置 Nginx 反向代理/负载均衡，Tomcat 只在局域网被访问，用 8080 即可。

7. **AccessLogValve 的 pattern 里 %h 在什么情况下不是真实客户端 IP？**
   当 Tomcat 前面有 Nginx 等反向代理时，`%h` 记录的是代理 IP；要拿真实 IP 需配 `remoteIpHeader="x-forwarded-for"`（见《nginx+tomcat+https》）。

---

> 原文参考：<http://www.cnblogs.com/kismetv/p/7228274.html>
