# 从零开始搭建Go语言开发环境

<font style="color:rgb(68, 68, 68);">Go1.14版本，一步一步，从零搭建Go语言开发环境。</font>

**<font style="color:red;">因为Go语言及相关编辑工具的更新迭代，本文已于2021/05/12更新，可能会和视频有所出入，请以更新后的本文为准。</font>**

# <font style="color:rgb(68, 68, 68);">安装Go语言及搭建Go语言开发环境</font>
**<font style="color:red;">注意：</font>**<font style="color:rgb(68, 68, 68);">Go语言1.14版本之后推荐使用go modules管理依赖，也不再需要把代码写在GOPATH目录下了，之前旧版本的教程戳这个</font>[链接](https://www.liwenzhou.com/posts/Go/install_go_dev_old/)<font style="color:rgb(68, 68, 68);">。</font>

## <font style="color:black;">下载</font>
### <font style="color:rgb(186, 57, 37);">下载地址</font>
<font style="color:rgb(68, 68, 68);">Go官网下载地址：</font>[https://golang.org/dl/](https://golang.org/dl/)

<font style="color:rgb(68, 68, 68);">Go官方镜像站（推荐）：</font>[https://golang.google.cn/dl/](https://golang.google.cn/dl/)

### <font style="color:rgb(186, 57, 37);">版本的选择</font>
<font style="color:rgb(68, 68, 68);">Windows平台和Mac平台推荐下载可执行文件版，Linux平台下载压缩文件版。</font>

**<font style="color:red;">下图中的版本号可能并不是最新的，但总体来说安装教程是类似的。Go语言更新迭代比较快，推荐使用较新版本，体验最新特性。</font>**



<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



## <font style="color:black;">安装</font>
### <font style="color:rgb(186, 57, 37);">Windows安装</font>
<font style="color:rgb(68, 68, 68);">此安装实例以</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">64位Win10</font><font style="color:rgb(68, 68, 68);">系统安装</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Go1.14.1可执行文件版本</font><font style="color:rgb(68, 68, 68);">为例。</font>

<font style="color:rgb(68, 68, 68);">将上一步选好的安装包下载到本地。</font>



<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



<font style="color:rgb(68, 68, 68);">双击下载好的文件，然后按照下图的步骤安装即可。</font>



<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



### <font style="color:rgb(186, 57, 37);">Linux下安装</font>
<font style="color:rgb(68, 68, 68);">如果不是要在Linux平台敲go代码就不需要在Linux平台安装Go，我们开发机上写好的go代码只需要跨平台编译（详见文章末尾的跨平台编译）好之后就可以拷贝到Linux服务器上运行了，这也是go程序跨平台易部署的优势。</font>

<font style="color:rgb(68, 68, 68);">我们在版本选择页面选择并下载好</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go1.14.1.linux-amd64.tar.gz</font><font style="color:rgb(68, 68, 68);">文件：</font>

<font style="color:rgb(221, 74, 104);">wget</font><font style="color:rgb(68, 68, 68);"> https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz </font>

<font style="color:rgb(68, 68, 68);">将下载好的文件解压到</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">/usr/local</font><font style="color:rgb(68, 68, 68);">目录下：</font>

<font style="color:rgb(221, 74, 104);">tar</font><font style="color:rgb(68, 68, 68);"> -zxvf go1.14.1.linux-amd64.tar.gz -C /usr/local  </font><font style="color:slategray;"># 解压</font><font style="color:rgb(68, 68, 68);"> </font>

<font style="color:rgb(68, 68, 68);">如果提示没有权限，加上</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">sudo</font><font style="color:rgb(68, 68, 68);">以root用户的身份再运行。执行完就可以在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">/usr/local/</font><font style="color:rgb(68, 68, 68);">下看到</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go</font><font style="color:rgb(68, 68, 68);">目录了。</font>

<font style="color:rgb(68, 68, 68);">配置环境变量： Linux下有两个文件可以配置环境变量，其中</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">/etc/profile</font><font style="color:rgb(68, 68, 68);">是对所有用户生效的；</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">$HOME/.profile</font><font style="color:rgb(68, 68, 68);">是对当前用户生效的，根据自己的情况自行选择一个文件打开，添加如下两行代码，保存退出。</font>

<font style="color:rgb(221, 74, 104);">export</font><font style="color:rgb(68, 68, 68);"> GOROOT</font><font style="color:rgb(154, 110, 58);">=</font><font style="color:rgb(68, 68, 68);">/usr/local/go </font><font style="color:rgb(221, 74, 104);">export</font><font style="color:rgb(68, 68, 68);"> PATH</font><font style="color:rgb(154, 110, 58);">=</font><font style="color:rgb(238, 153, 0);">$PATH</font><font style="color:rgb(0, 119, 170);">:</font><font style="color:rgb(238, 153, 0);">$GOROOT</font><font style="color:rgb(68, 68, 68);">/bin </font>

<font style="color:rgb(68, 68, 68);">修改</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">/etc/profile</font><font style="color:rgb(68, 68, 68);">后要重启生效，修改</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">$HOME/.profile</font><font style="color:rgb(68, 68, 68);">后使用source命令加载</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">$HOME/.profile</font><font style="color:rgb(68, 68, 68);">文件即可生效。 检查：</font>

<font style="color:rgb(68, 68, 68);">~ go version go version go1.14.1 linux/amd64 </font>

### <font style="color:rgb(186, 57, 37);">Mac下安装</font>
<font style="color:rgb(68, 68, 68);">下载可执行文件版，直接点击</font>**<font style="color:red;">下一步</font>**<font style="color:rgb(68, 68, 68);">安装即可，默认会将go安装到</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">/usr/local/go</font><font style="color:rgb(68, 68, 68);">目录下。</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



### <font style="color:rgb(186, 57, 37);">检查</font>
<font style="color:rgb(68, 68, 68);">上一步安装过程执行完毕后，可以打开终端窗口，输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go version</font><font style="color:rgb(68, 68, 68);">命令，查看安装的Go版本。</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



## <font style="color:black;">GOROOT和GOPATH</font>
<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOROOT</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPATH</font><font style="color:rgb(68, 68, 68);">都是环境变量，其中</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOROOT</font><font style="color:rgb(68, 68, 68);">是我们安装go开发包的路径，而从Go 1.8版本开始，Go开发包在安装完成后会为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPATH</font><font style="color:rgb(68, 68, 68);">设置一个默认目录，并且在Go1.14及之后的版本中启用了Go Module模式之后，不一定非要将代码写到GOPATH目录下，所以也就</font>**<font style="color:red;">不需要我们再自己配置GOPATH</font>**<font style="color:rgb(68, 68, 68);">了，使用默认的即可。</font>

### <font style="color:rgb(186, 57, 37);">GOPROXY 非常重要</font>
<font style="color:rgb(68, 68, 68);">Go1.14版本之后，都推荐使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go mod</font><font style="color:rgb(68, 68, 68);">模式来管理依赖环境了，也不再强制我们把代码必须写在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPATH</font><font style="color:rgb(68, 68, 68);">下面的src目录了，你可以在你电脑的任意位置编写go代码。（网上有些教程适用于1.11版本之前。）</font>

<font style="color:rgb(68, 68, 68);">默认GoPROXY配置是：</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPROXY=https://proxy.golang.org,direct</font><font style="color:rgb(68, 68, 68);">，由于国内访问不到</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">https://proxy.golang.org</font><font style="color:rgb(68, 68, 68);">，所以我们需要换一个PROXY，这里推荐使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">https://goproxy.io</font><font style="color:rgb(68, 68, 68);">或</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">https://goproxy.cn</font><font style="color:rgb(68, 68, 68);">。</font>

<font style="color:rgb(68, 68, 68);">可以执行下面的命令修改GOPROXY：</font>

<font style="color:rgb(68, 68, 68);">go </font><font style="color:rgb(221, 74, 104);">env</font><font style="color:rgb(68, 68, 68);"> -w GOPROXY</font><font style="color:rgb(154, 110, 58);">=</font><font style="color:rgb(68, 68, 68);">https://goproxy.cn,direct </font>

## <font style="color:black;">Go开发编辑器</font>
<font style="color:rgb(68, 68, 68);">Go采用的是UTF-8编码的文本文件存放源代码，理论上使用任何一款文本编辑器都可以做Go语言开发，这里推荐使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VS Code</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Goland</font><font style="color:rgb(68, 68, 68);">。</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VS Code</font><font style="color:rgb(68, 68, 68);">是微软开源的编辑器，而</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Goland</font><font style="color:rgb(68, 68, 68);">是jetbrains出品的付费IDE。</font>

<font style="color:rgb(68, 68, 68);">我们这里使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VS Code</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">加插件做为go语言的开发工具。</font>

### <font style="color:rgb(186, 57, 37);">VS Code介绍</font>
<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VS Code</font><font style="color:rgb(68, 68, 68);">全称</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Visual Studio Code</font><font style="color:rgb(68, 68, 68);">，是微软公司开源的一款</font>**<font style="color:red;">免费</font>**<font style="color:rgb(68, 68, 68);">现代化轻量级代码编辑器，支持几乎所有主流的开发语言的语法高亮、智能代码补全、自定义热键、括号匹配、代码片段、代码对比 Diff、GIT 等特性，支持插件扩展，支持 Win、Mac 以及 Linux平台。</font>

<font style="color:rgb(68, 68, 68);">虽然不如某些IDE功能强大，但是它添加Go扩展插件后已经足够胜任我们日常的Go开发。</font>

### <font style="color:rgb(186, 57, 37);">下载与安装</font>
<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VS Code</font><font style="color:rgb(68, 68, 68);">官方下载地址：</font>[https://code.visualstudio.com/Download](https://code.visualstudio.com/Download)

<font style="color:rgb(68, 68, 68);">三大主流平台都支持，请根据自己的电脑平台选择对应的安装包。</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->

<font style="color:rgb(68, 68, 68);">双击下载好的安装文件，双击安装即可。</font>

### <font style="color:rgb(186, 57, 37);">配置</font>
#### <font style="color:rgb(186, 57, 37);">安装中文简体插件</font>
<font style="color:rgb(68, 68, 68);">点击左侧菜单栏最后一项</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">管理扩展</font><font style="color:rgb(68, 68, 68);">，在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">搜索框</font><font style="color:rgb(68, 68, 68);">中输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">chinese</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">，选中结果列表第一项，点击</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">install</font><font style="color:rgb(68, 68, 68);">安装。</font>

<font style="color:rgb(68, 68, 68);">安装完毕后右下角会提示</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">重启VS Code</font><font style="color:rgb(68, 68, 68);">，重启之后你的VS Code就显示中文啦！</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->

<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VSCode</font><font style="color:rgb(68, 68, 68);">主界面介绍：</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



#### <font style="color:rgb(186, 57, 37);">安装go扩展</font>
<font style="color:rgb(68, 68, 68);">现在我们要为我们的VS Code编辑器安装</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Go</font><font style="color:rgb(68, 68, 68);">扩展插件，让它支持Go语言开发。</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



## <font style="color:black;">第一个Go程序</font>
### <font style="color:rgb(186, 57, 37);">Hello World</font>
<font style="color:rgb(68, 68, 68);">现在我们来创建第一个Go项目——</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">hello</font><font style="color:rgb(68, 68, 68);">。在我们桌面创建一个</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">hello</font><font style="color:rgb(68, 68, 68);">目录。</font>

#### <font style="color:rgb(186, 57, 37);">go mod init</font>
<font style="color:rgb(68, 68, 68);">使用go module模式新建项目时，我们需要通过</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go mod init 项目名</font><font style="color:rgb(68, 68, 68);">命令对项目进行初始化，该命令会在项目根目录下生成</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go.mod</font><font style="color:rgb(68, 68, 68);">文件。例如，我们使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">hello</font><font style="color:rgb(68, 68, 68);">作为我们第一个Go项目的名称，执行如下命令。</font>

```go
go mod init hello

```

#### <font style="color:rgb(186, 57, 37);">编写代码</font>
<font style="color:rgb(68, 68, 68);">接下来在该目录中创建一个</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">main.go</font><font style="color:rgb(68, 68, 68);">文件：</font>

```go
package main  // 声明 main 包，表明当前是一个可执行程序

import "fmt"  // 导入内置 fmt 包

func main(){  // main函数，是程序执行的入口
	fmt.Println("Hello World!")  // 在终端打印 Hello World!
}
```

**<font style="color:red;">非常重要！！！</font>**<font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">如果此时VS Code右下角弹出提示让你安装插件，务必点</font><font style="color:rgb(68, 68, 68);"> </font>**<font style="color:red;">install all</font>**<font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">进行安装。</font>

### <font style="color:rgb(186, 57, 37);">编译</font>
<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go build</font><font style="color:rgb(68, 68, 68);">命令表示将源代码编译成可执行文件。</font>

<font style="color:rgb(68, 68, 68);">在hello目录下执行：</font>

```go
go build
```

<font style="color:rgb(68, 68, 68);">或者在其他目录执行以下命令：</font>

```go
go build hello
```

<font style="color:rgb(68, 68, 68);">go编译器会去</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPATH</font><font style="color:rgb(68, 68, 68);">的src目录下查找你要编译的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">hello</font><font style="color:rgb(68, 68, 68);">项目</font>

<font style="color:rgb(68, 68, 68);">编译得到的可执行文件会保存在执行编译命令的当前目录下，如果是windows平台会在当前目录下找到</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">hello.exe</font><font style="color:rgb(68, 68, 68);">可执行文件。</font>

<font style="color:rgb(68, 68, 68);">可在终端直接执行该</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">hello.exe</font><font style="color:rgb(68, 68, 68);">文件：</font>

```go
c:\desktop\hello>hello.exe
Hello World!
```

<font style="color:rgb(68, 68, 68);">我们还可以使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">-o</font><font style="color:rgb(68, 68, 68);">参数来指定编译后得到的可执行文件的名字。</font>

```go
go build -o heiheihei.exe
```

### <font style="color:rgb(186, 57, 37);">Windows下VSCode切换cmd.exe作为默认终端</font>
<font style="color:rgb(68, 68, 68);">如果你打开VS Code的终端界面出现如下图场景（注意观察红框圈中部分），那么你的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VS Code</font><font style="color:rgb(68, 68, 68);">此时正使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">powershell</font><font style="color:rgb(68, 68, 68);">作为默认终端：</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->

<font style="color:rgb(68, 68, 68);">十分推荐你按照下面的步骤，选择</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">cmd.exe</font><font style="color:rgb(68, 68, 68);">作为默认的终端工具：</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->

<font style="color:rgb(68, 68, 68);">此时，VS Code正上方中间位置会弹出如下界面，参照下图挪动鼠标使光标选中后缀为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">cmd.exe</font><font style="color:rgb(68, 68, 68);">的那一个，然后点击鼠标左键。</font>

<font style="color:rgb(68, 68, 68);">最后</font>**<font style="color:red;">重启VS Code中已经打开的终端</font>**<font style="color:rgb(68, 68, 68);">或者</font>**<font style="color:red;">直接重启VS Code</font>**<font style="color:rgb(68, 68, 68);">就可以了。</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->

<font style="color:rgb(68, 68, 68);">如果没有出现下拉三角，也没有关系，按下</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Ctrl+Shift+P</font><font style="color:rgb(68, 68, 68);">，VS Code正上方会出现一个框，你按照下图输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">shell</font><font style="color:rgb(68, 68, 68);">，然后点击指定选项即可出现上面的界面了。</font>

<!-- OCR_START -->
> 文件(E)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G)
> main.go - go-workspace (工作区) -
> 口
> X
> main.go
> >shell
> 输入 shell
> 日
> go > src > liv
> 终端：选择默认Shell
> 最近使用
> 1
> Terminal:Select Default Shell
> 2鼠标点击这一项
> 2
> 终端：管理工作区Shell权限
> 其他命令
> 3
> Terminal: Manage Workspace Shell Permissions
> 4
> mai
<!-- OCR_END -->



### <font style="color:rgb(186, 57, 37);">go run</font>
<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go run main.go</font><font style="color:rgb(68, 68, 68);">也可以执行程序，该命令本质上也是先编译再执行。</font>

### <font style="color:rgb(186, 57, 37);">go install</font>
<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go install</font><font style="color:rgb(68, 68, 68);">表示安装的意思，它先编译源代码得到可执行文件，然后将可执行文件移动到</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPATH</font><font style="color:rgb(68, 68, 68);">的bin目录下。因为我们的环境变量中配置了</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPATH</font><font style="color:rgb(68, 68, 68);">下的bin目录，所以我们就可以在任意地方直接执行可执行文件了。</font>

### <font style="color:rgb(186, 57, 37);">跨平台编译</font>
<font style="color:rgb(68, 68, 68);">默认我们</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go build</font><font style="color:rgb(68, 68, 68);">的可执行文件都是当前操作系统可执行的文件，Go语言支持跨平台编译——在当前平台（例如Windows）下编译其他平台（例如Linux）的可执行文件。</font>

#### <font style="color:rgb(186, 57, 37);">Windows编译Linux可执行文件</font>
<font style="color:rgb(68, 68, 68);">如果我想在Windows下编译一个Linux下可执行文件，那需要怎么做呢？只需要在编译时指定目标操作系统的平台和处理器架构即可。</font>

<font style="color:rgb(68, 68, 68);"></font>

<font style="color:rgb(68, 68, 68);">注意：无论你在Windows电脑上使用VsCode编辑器还是Goland编辑器，都要注意你使用的终端类型，因为不同的终端下命令不一样！！！目前的Windows通常默认使用的是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">PowerShell</font><font style="color:rgb(68, 68, 68);">终端。</font>

<font style="color:rgb(68, 68, 68);"></font>

<font style="color:rgb(68, 68, 68);">如果你的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Windows</font><font style="color:rgb(68, 68, 68);">使用的是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">cmd</font><font style="color:rgb(68, 68, 68);">，那么按如下方式指定环境变量。</font>

```go
SET CGO_ENABLED=0  // 禁用CGO
SET GOOS=linux  // 目标平台是linux
SET GOARCH=amd64  // 目标处理器架构是amd64
```

<font style="color:rgb(68, 68, 68);">如果你的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Windows</font><font style="color:rgb(68, 68, 68);">使用的是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">PowerShell</font><font style="color:rgb(68, 68, 68);">终端，那么设置环境变量的语法为</font>

```go
$ENV:CGO_ENABLED=0
$ENV:GOOS="linux"
$ENV:GOARCH="amd64"
```

<font style="color:rgb(68, 68, 68);">在你的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Windows</font><font style="color:rgb(68, 68, 68);">终端下执行完上述命令后，再执行下面的命令，得到的就是能够在Linux平台运行的可执行文件了。</font>

```go
go build
```

#### <font style="color:rgb(186, 57, 37);">Windows编译Mac可执行文件</font>
<font style="color:rgb(68, 68, 68);">Windows下编译Mac平台64位可执行程序：</font>

<font style="color:rgb(68, 68, 68);">cmd终端下执行：</font>

```go
SET CGO_ENABLED=0
SET GOOS=darwin
SET GOARCH=amd64
go build
```

<font style="color:rgb(68, 68, 68);">PowerShell终端下执行：</font>

```go
$ENV:CGO_ENABLED=0
$ENV:GOOS="darwin"
$ENV:GOARCH="amd64"
go build
```

#### <font style="color:rgb(186, 57, 37);">Mac编译Linux可执行文件</font>
<font style="color:rgb(68, 68, 68);">Mac电脑编译得到Linux平台64位可执行程序：</font>

```go
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build
```

#### <font style="color:rgb(186, 57, 37);">Mac编译Windows可执行文件</font>
<font style="color:rgb(68, 68, 68);">Mac电脑编译得到Windows平台64位可执行程序：</font>

```go
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build
```

#### <font style="color:rgb(186, 57, 37);">Linux编译Mac可执行文件</font>
<font style="color:rgb(68, 68, 68);">Linux平台下编译Mac平台64位可执行程序：</font>

```go
CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build
```

#### <font style="color:rgb(186, 57, 37);">Linux编译Windows可执行文件</font>
<font style="color:rgb(68, 68, 68);">Linux平台下编译Windows平台64位可执行程序：</font>

```go
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build
```

<font style="color:rgb(68, 68, 68);">现在，开启你的Go语言学习之旅吧。人生苦短，let’s Go.</font>

  




> 更新: 2022-03-16 10:49:35  
> 原文: <https://www.yuque.com/chengkanghua/go/kwg0kg>