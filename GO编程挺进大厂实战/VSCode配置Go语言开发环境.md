# VS Code配置Go语言开发环境

<font style="color:rgb(68, 68, 68);">VS Code是微软开源的一款编辑器，插件系统十分的丰富。本文就介绍了如何使用VS Code搭建Go语言开发环境。</font>

**<font style="color:red;">因为Go语言及相关编辑工具的更新迭代，本文已于2020/03/25更新，可能会和视频有所出入，请以更新后的本文为准。</font>**

# <font style="color:rgb(68, 68, 68);">VS Code配置Go语言开发环境</font>
<font style="color:rgb(68, 68, 68);">说在前面的话，Go语言是采用UTF8编码的，理论上使用任何文本编辑器都能做Go语言开发。大家可以根据自己的喜好自行选择。编辑器/IDE没有最好只有最适合。</font>

## <font style="color:black;">下载与安装</font>
<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VS Code</font><font style="color:rgb(68, 68, 68);">官方下载地址：</font>[https://code.visualstudio.com/Download](https://code.visualstudio.com/Download)

<font style="color:rgb(68, 68, 68);">三大主流平台都支持，请根据自己的电脑平台选择对应的安装包。</font><font style="color:rgb(68, 68, 68);">双击下载好的安装文件，双击安装即可。</font>

## <font style="color:black;">安装中文简体插件</font>
<font style="color:rgb(68, 68, 68);">点击左侧菜单栏最后一项</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">管理扩展</font><font style="color:rgb(68, 68, 68);">，在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">搜索框</font><font style="color:rgb(68, 68, 68);">中输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">chinese</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">，选中结果列表第一项，点击</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">install</font><font style="color:rgb(68, 68, 68);">安装。</font>

<font style="color:rgb(68, 68, 68);">安装完毕后右下角会提示</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">重启VS Code</font><font style="color:rgb(68, 68, 68);">，重启之后你的VS Code就显示中文啦！</font>

<!-- OCR_START -->
> File
> Edit
> Selection
> View
> Go
> Debug
> Terminal
> Help
> Welcome-VisualStudioCode
> EXPLORER
> Welcome
> OPEN EDITORS
> NO FOLDER OPENED
> Start
> Customize
> OUTLINE
> New file
> Open folder...
> Tools and languages
> Add workspace folder...
> Install support for JavaScript, TypeScri..
> Settings and keybindings
> Install the settings and keyboard short...
> Recent
> No recent folders
> Color theme
> Make the editor and your code look th.
> Help
> Learn
> Printable keyboard cheatsheet
> Introductory videos
> Find and run all commands
> Tips and Tricks
> Product documentation
> Rapidly access and search commands f..
> GitHub repository
> Stack Overflow
> Interfaceoverview
> Get a visual overlay highlighting the m...
> Showwelcomepageonstartup
> Interactive playground
> Try essential editor featuresout in a sh...
> X0AO
<!-- OCR_END -->

<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">VSCode</font><font style="color:rgb(68, 68, 68);">主界面介绍：</font>

## <font style="color:black;">安装Go开发扩展</font>
<font style="color:rgb(68, 68, 68);">现在我们要为我们的VS Code编辑器安装</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Go</font><font style="color:rgb(68, 68, 68);">扩展插件，让它支持Go语言开发。</font>

## <font style="color:black;">变更编辑器主题</font>
<font style="color:rgb(68, 68, 68);">依次点击</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">设置->颜色主题</font><font style="color:rgb(68, 68, 68);">，</font><font style="color:rgb(68, 68, 68);">会弹出如下窗口：</font><font style="color:rgb(68, 68, 68);">可以根据自己的喜好选择相应的主题。</font>

## <font style="color:black;">安装Go语言开发工具包</font>
<font style="color:rgb(68, 68, 68);">在座Go语言开发的时候为我们提供诸如代码提示、代码自动补全等功能。</font>

<font style="color:rgb(68, 68, 68);">在此之前请先设置</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">GOPROXY</font><font style="color:rgb(68, 68, 68);">，打开终端执行以下命令：</font>

```go
go env -w GOPROXY=https://goproxy.cn,direct
```

<font style="color:rgb(68, 68, 68);">Windows平台按下</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Ctrl+Shift+P</font><font style="color:rgb(68, 68, 68);">，Mac平台按</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Command+Shift+P</font><font style="color:rgb(68, 68, 68);">，这个时候VS Code界面会弹出一个输入框，如下图：</font>

<font style="color:rgb(68, 68, 68);">我们在这个输入框中输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">>go:install</font><font style="color:rgb(68, 68, 68);">，下面会自动搜索相关命令，我们选择</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Go:Install/Update Tools</font><font style="color:rgb(68, 68, 68);">这个命令，按下图选中并会回车执行该命令（或者使用鼠标点击该命令）</font><font style="color:rgb(68, 68, 68);">在弹出的窗口选中所有，并点击“确定”按钮，进行安装。</font>

<font style="color:rgb(68, 68, 68);">然后会弹出如下窗口，开始安装工具：</font>

<font style="color:rgb(68, 68, 68);">喝口水，等待所有工具都安装成功，如下图所示:</font>

## <font style="color:black;">配置VSCode开启自动保存</font>
<font style="color:rgb(68, 68, 68);">按下图依次点击</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">文件->首选项->设置</font><font style="color:rgb(68, 68, 68);">，</font><font style="color:rgb(68, 68, 68);">打开设置页面就能看到自动保存相关配置如下图，可以根据自己的喜好选择自动保存的方式：</font>

## <font style="color:black;">配置代码片段快捷键</font>
<font style="color:rgb(68, 68, 68);">还是按</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">Ctrl/Command+Shift+P</font><font style="color:rgb(68, 68, 68);">,按下图输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">>snippets</font><font style="color:rgb(68, 68, 68);">，选择命令并执行：</font>

<font style="color:rgb(68, 68, 68);">然后在弹出的窗口点击选择</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">go</font><font style="color:rgb(68, 68, 68);">选项：</font><font style="color:rgb(68, 68, 68);">然后弹出如下页面：</font>

<font style="color:rgb(68, 68, 68);">大家可以简单看下上面的注释，介绍了主要用法：</font>

```plain
“这里放个名字”:{
    "prefix": "这个是快捷键",
    "body": "这里是按快捷键插入的代码片段",
    "description": "这里放提示信息的描述"
}
```

<font style="color:rgb(68, 68, 68);">其中</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">$0</font><font style="color:rgb(68, 68, 68);">表示最终光标提留的位置。 举个例子，我这里创建了两个快捷方式，一个是输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">pln</font><font style="color:rgb(68, 68, 68);">就会在编辑器中插入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">fmt.Println()</font><font style="color:rgb(68, 68, 68);">代码；输入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">plf</font><font style="color:rgb(68, 68, 68);">，就会插入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">fmt.Printf("")</font><font style="color:rgb(68, 68, 68);">代码。</font>

```go
{
	"println":{
		"prefix": "pln",
		"body":"fmt.Println($0)",
		"description": "println"
	},
	"printf":{
		"prefix": "plf",
		"body": "fmt.Printf(\"$0\")",
		"description": "printf"
	}
}
```

<font style="color:rgb(68, 68, 68);">把上面的代码，按下图方式粘贴到配置文件中，保存并关闭配置文件即可。</font><font style="color:rgb(68, 68, 68);">添加如上配置后，保存。 我们打开一个go文件，测试一下效果：</font>

<!-- OCR_START -->
> 文件(F)
> 编辑(E)
> 选择(S)
> 查看(V)
> 转到(G
> 运行(R)
> 终端(T)
> main.go - Visual Studio ..
> 口
> X
> main.go
> X
> c: > Users > 01 > Desktop >
> main.go > {} main >  main
> 1
> package main
> 2
> 3
> func main()
> R9
> 4
> P
> panic
> 6
> print
> println
> plf
> printf（用户代码片①
> pln
> println（用户代码片
> package
> pkgm
> Snippet for main p
> pn
> Snippet for panic
> 行4，列6
> 制表符长度：4
> UTF-8
> CRLE
> Go
> Analysis Tools Missing
> C
<!-- OCR_END -->



---

  




> 更新: 2022-03-16 10:51:52  
> 原文: <https://www.yuque.com/chengkanghua/go/ncp29b>