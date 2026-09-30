# SLB + ECS + HTTPS 公有云实践（阿里云）

> 本文是在阿里云上用 **SLB（负载均衡）+ ECS（云主机）** 实现 HTTPS 的实战流程。核心思路：证书只在 SLB 上管理，SLB 以 HTTPS 对外、以 HTTP 转发后端（SSL 卸载），后端 ECS 只需监听 80。

---

## 一、购买 SLB 负载均衡

1. 进入控制台 → 左侧「负载均衡」→ 创建负载均衡。
   ![创建SLB](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-01.png)
2. 选择负载均衡套餐（按业务需求选）。
   ![套餐](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-02.png)
   ![套餐2](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-03.png)
3. 确认无误，开通服务。
   ![开通](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-04.png)

---

## 二、购买 ECS 云主机

4. 购买 ECS 云主机。
   ![购买ECS](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-05.png)
5. 自定义 ECS 配置（镜像、规格、网络等）。
   ![ECS配置1](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-06.png)
   ![ECS配置2](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-07.png)
   ![ECS配置3](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-08.png)
   ![ECS配置4](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-09.png)
   ![ECS配置5](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-10.png)

---

## 三、后端多台服务器配置支持 HTTPS

> ⚠️ **ECS 要支持 HTTPS，必须同时监听 80 和 443 端口**（后端 ECS 直接对外时才需要；若只作 SLB 后端转发，可只留 80）。

```bash
# 1. 安装 Nginx
yum install nginx -y

# 2. 配置 HTTP 访问
cat > /etc/nginx/conf.d/http.conf <<EOF
server {
  listen 80;
  server_name nginx.bjstack.com;
  root /code;
  index index.html;
}
EOF
mkdir /code && echo "Aliyum_SLB" > /code/index.html
systemctl restart nginx

# 3. 准备 HTTPS 证书文件
mkdir /etc/nginx/ssl_key/
# 下载阿里云 SSL 证书并解压到 /etc/nginx/ssl_key/
# 没有阿里云证书时可自签（黑户，仅学习用）

# 4. 配置 Nginx 提供 HTTPS
cat > /etc/nginx/conf.d/http.conf <<EOF
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
EOF

# 5. 把配置下发到其他后端节点
scp -rp /etc/nginx root@192.168.56.6:/etc/

# 6. 重启所有后端 Web
systemctl restart nginx
netstat -lntp
# 0.0.0.0:80    nginx
# 0.0.0.0:443   nginx
```

> 注：当采用 SLB + SSL 卸载时，后端 ECS 其实**无需**配置 443（SLB 用 HTTP 转发到后端 80 即可），上面是「后端也直接支持 HTTPS」的写法。

---

## 四、前端 SLB 配置负载均衡

1. 配置 SLB。
   ![SLB配置](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-11.png)
2. 在 SLB 上加入 ECS 云主机。
   ![加入ECS](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-12.png)
3. 定义 SLB 后端资源池（相当于 upstream）。
   ![资源池](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-13.png)
4. 定义后端 Web 服务 80 端口。
   ![后端80](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-14.png)

---

## 五、SLB 负载均衡实现 HTTPS（SSL 卸载）

> ⚠️ **核心**：前端 SLB 用 HTTPS 协议调用后端 Web 的 80 端口来实现 HTTPS 请求。
> 官方说明：**证书上传到负载均衡后，由 SLB 管理证书，后端 ECS 不需要绑定证书**。
> <https://help.aliyun.com/document_detail/54512.html>

```bash
# 9. 后端 ECS 只需要保留 80 即可（证书交给 SLB）
cat > /etc/nginx/conf.d/http.conf <<EOF
server {
  listen 80;
  server_name nginx.bjstack.com;
  location / {
    root /code;
    index index.html;
  }
}
EOF
systemctl restart nginx
```

10. 把 SSL 证书推送到 SLB（SLB 使用证书，后端 Web 节点不需要）。
    ![推送证书1](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-15.png)
    ![推送证书2](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-16.png)

11. 创建虚拟服务器组（后端填 80 端口）。
    ![虚拟服务器组](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-17.png)

12. 添加监听 HTTPS 443，后端选择虚拟服务器池。
    ![监听443](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-18.png)

13. 服务器证书选第一步推送的证书。
    ![选择证书](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-19.png)

14. 域名填写、健康检查端口 80、路径 `/`。
    ![健康检查](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-20.png)

15. 此时完成，但**还缺一个 80→443 重定向**。
    ![缺重定向](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-21.png)

16. 浏览器访问 `https://nginx.bjstack.com` 已可正常访问。
    ![访问](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-22.png)

> ⚠️ **坑**：无法访问 HTTPS 时，先检查**阿里云安全组**是否放行 443/80。
> ![安全组](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-23.png)

> ⚠️ **坑**：HTTPS 能访问但 HTTP 不能跳 HTTPS——**必须先配置 HTTPS 监听，否则 HTTP 监听找不到转发目标**。
> 解决：监听 → 添加监听 `http:80` → 选择「监听转发」到 `https:443`。
> ![HTTP转发HTTPS](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-24.png)

17. 最终完成截图。
    ![完成](img/slb%2Besc%2Bhttps-HTTPS%E5%85%AC%E6%9C%89%E4%BA%91%E5%AE%9E%E8%B7%B5-25.png)

---

## 六、三种场景操作步骤总结

**#1 单台 WebServer 配置 HTTPS**
1. 阿里云需有已备案域名，且余额 ≥ 100。
2. 登录阿里云购买免费 SSL 证书。
3. 购买 ECS，配置 Nginx（HTTP 跳 HTTPS，证书用阿里云下载的、不要改名）。
4. 浏览器访问即可。

**#2 多台 WebServer（一台 proxy + 一台 web）配置 HTTPS**
1. 已备案域名 + 余额 ≥ 100。
2. 购买免费 SSL 证书。
3. 后端 Web 仅监听 HTTPS（证书用阿里云下载的、不要改名）。
4. Proxy 监听 80 跳 443，443 用 `proxy_pass` 调度后端。
5. 浏览器访问即可。

**#3 前端 SLB + 后端多台 WebServer 配置 HTTPS（本文主场景）**
1. 已备案域名 + 余额 ≥ 100。
2. 购买免费 SSL 证书。
3. 购买多台 ECS，配置 Nginx（后端仅 HTTP）。
4. 购买 SLB，添加服务器组 / 虚拟服务器组，监听后端所有服务器 80 端口（即定义 upstream 资源池）。
5. 配置 SLB 监听：前端协议 HTTPS 443，后端选虚拟服务器组。
6. 选择对应域名 SSL 证书（阿里云证书管理推送；第三方证书则在证书管理里手动添加）。
7. 配置健康检查（域名、端口、路径）。
8. HTTPS 能访问但 HTTP 不行时，需在 SLB 上配置强制跳转。
9. SLB 监听 → `http:80` → 监听转发 → 选已配好的 `https:443`。
10. 测试 HTTP、HTTPS 访问。

---

## 七、常见面试题

1. **公有云 SLB 实现 HTTPS，证书要装在后端 ECS 吗？**
   不用。证书上传到 SLB 由它管理，SLB 对外 HTTPS、对内用 HTTP 转发到后端 80（SSL 卸载），后端 ECS 无需绑证书。

2. **阿里云上 HTTP 无法跳 HTTPS 是怎么回事？**
   必须先有 HTTPS 监听，才能配置 80→443 的监听转发；顺序反了会找不到转发目标。

3. **配置好 HTTPS 却访问不通，先排查什么？**
   先查阿里云**安全组**是否放行 443/80，再查 SLB 健康检查与后端 Nginx 是否监听对应端口。

4. **SLB 相比自建 keepalived 高可用的优势？**
   SLB 由云厂商提供天然高可用（多可用区冗余），无需自建 keepalived、不用处理 VIP 漂移/脑裂；自建物理机才用 keepalived。

5. **后端只监听 80 时，SSL 卸载在哪个环节完成？**
   在 SLB 上完成（SLB 解密 HTTPS 后再以 HTTP 转发后端），因此后端无需处理证书和加解密，省 CPU。

---

> 原文：<https://www.yuque.com/chengkanghua/oldboy50/iyg5x1>
