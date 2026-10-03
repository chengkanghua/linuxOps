# Python入门-虚拟环境

+ [虚拟环境](https://blog.driverzeng.com/zenglaoshi/5643.html#toc_0)

> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023
>

---

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1)整合了各个公有云API，自主创建云主机。
>
> 2)ELK自动化收集日志功能。
>
> 3)Saltstack自动化运维统一配置管理工具。
>
> 4)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6)SQL执行及审批流程。
>
> 7)慢查询日志分析web界面。
>

---

## 虚拟环境
---

| 需求 |
| :--- |

公司之有一台服务器

1.目前运行这一个5年前开发的Django项目，基于1.5

2.现在要基于Django2.0开发一套程序

3.无法卸载原来的版本，必须还要安装新版本

---

| 命令创建虚拟环境 |
| :--- |

通过virtualenv软件创建

```bash

# 安装：

pip3 install virtualenv

# 创建虚拟环境：

virtualenv env_django（创建虚拟环境）

virtualenv env_django(创建纯净环境)

virtualenv --system-site-packages env_django（创建环境，继承原安装的模块）

# 激活该虚拟环境：

1.windows进到目录里，的Script文件夹输入：activate

2.Linux：soruse env1/Script/activate

# 退出虚拟环境：

deactivate

# 在pycharm中使用虚拟环境

files--settings--Project--Project Interpreter--add选择虚拟环境路径下的python.exe即可

```

----

| 在Pycharm下创建新建项目 |
| :--- |

File--->New Project--> 出现如下图，点击Project Interpreter：New Virtualenv environment

<!-- OCR_START -->
- PC
- NewProject
- PurePython
- Location:
- C:\Users\Administrator\PycharmProjects\untitled11
- dj Django
- Flask
- ProjectInterpreter:NewVirtualenvenvironment
- GoogleAppEngine
- ONewenvironment using
- Virtualenv
- ：Pyramid
- WWeb2Py
- Scientific
- Baseinterpreter:
- Python3.6.5(D:python3\python.exe)
- Angular CLI
- Inheritglobalsite-packages
- AAngularJS
- Makeavailabletoallprojects
- Foundation
- Existinginterpreter
- 曾老湿
- Interpreter:
- Driver Zeng
- MoreSettings
<!-- OCR_END -->

￼

---

| 已有项目使用和创建虚拟环境 |
| :--- |

1.打开Project Interpreters页面：文件(file)——>设置(setting)——>项目(Project)——>Project Interpreters；

<!-- OCR_START -->
- Project:untitledlo>ProjectInterpreter
- 咱Forcurrentproject
- ProjectInterpreter:
- Python3.6(venv)C:\Users\Administrator\PycharmProjects\untitled10\venv\Scripts\python.exe
- Package
- Version
- Latest
- Django
- 2.1
- pip
- 10.0.1
- pytz
- 2018.5
- setuptools
- 39.1.0
<!-- OCR_END -->

￼

2.点击右边的配置按钮，选择**Add**。这时会弹出**Virtual Environment**的对话框；

<!-- OCR_START -->
- AddPythonInterpreter
- VirtualenvEnvironment
- ONewenvironment
- OCondaEnvironment
- Location:
- C:\Users\Administrator\PycharmProjects\untitled10\venv
- SystemInterpreter
- Baseinterpreter:
- Python3.6.5(D:\python3\python.exe)
- SSHInterpreter
- Inherit global site-packages
- Vagrant
- Makeavailabletoallprojects
- Docker
- OExistingenvironment
- DockerCompose
- Interpreter:
- <Nointerpreter>
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

---

| 参数说明 |
| :--- |

1.Name中填写新虚拟环境的名字，或者使用默认名字，方便以后安装第三方包和其他项目使用；

2.在Location中填写新环境的文件目录;

3.在Base interpreter下拉框中选择Python解释器；

4.勾选Inherit global site-packages可以使用base interpreter中的第三方库，不选将和外界完全隔离；

5.勾选Make available to all projects可将此虚拟环境提供给其他项目使用。

> 更新: 2020-06-25 10:45:10  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ih0qof>