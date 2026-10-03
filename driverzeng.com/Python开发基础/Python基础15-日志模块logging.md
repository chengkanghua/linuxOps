# Python基础15-日志模块logging

## Python基础15-日志模块logging

2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(3) 评论(0)

* [logging模块介绍](https://blog.driverzeng.com/zenglaoshi/5335.html#toc_0)
* [logging模块配置](https://blog.driverzeng.com/zenglaoshi/5335.html#toc_1)
* [日志格式模板](https://blog.driverzeng.com/zenglaoshi/5335.html#toc_2)
* [在软件开发目录规范中使用日志模板](https://blog.driverzeng.com/zenglaoshi/5335.html#toc_3)

>  
>
> -曾老湿, 江湖人称曾老大。
>
> -笔者QQ：133411023、253097001
>
> -笔者交流群：198571640
>
> -笔者微信：z133411023

***

> -多年互联网运维工作经验，曾负责过大规模集群架构自动化运维管理工作。
>
> -擅长Web集群架构与自动化运维，曾负责国内某大型金融公司运维工作。
>
> -devops项目经理兼DBA。
>
> -开发过一套自动化运维平台（功能如下）：
>
> 1\)整合了各个公有云API，自主创建云主机。
>
> 2\)ELK自动化收集日志功能。
>
> 3\)Saltstack自动化运维统一配置管理工具。
>
> 4\)Git、Jenkins自动化代码上线及自动化测试平台。
>
> 5\)堡垒机，连接Linux、Windows平台及日志审计。
>
> 6\)SQL执行及审批流程。
>
> 7\)慢查询日志分析web界面。

***

## logging模块介绍

额..这个没啥太多好介绍的，看名字就能看出来，跟日志有关。

日志级别：

```plain
CRITICAL = 50 #FATAL = CRITICAL
ERROR = 40
WARNING = 30 #WARN = WARNING
INFO = 20
DEBUG = 10
NOTSET = 0 #不设置
# 默认级别是FBI WARNING
import logging
logging.debug('调试debug')
logging.info('消息info')
logging.warning('警告warn')
logging.error('错误error')
logging.critical('严重critical')
```

<!-- OCR_START -->
PYTHON[~/Desktop/PYTHON]-./O7loggin
PYTHoNO7 loggin模块.py
07loggin模块.py
import logging
logging.debug(‘调试debug'）
logging.info(消息info')
logging.warning（‘警告warn'）
logging.error（‘错误error'）
logging.critical(严重critical
Run:
07 loggin模块X
/Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/Desktop/PYTHoN/o7 loggin模块.py
WARNING:root：警告warn
ERROR:root：错误error
CRITICAL:root:严重critical
Process finished with exit code o
曾老湿
Driver Zeng
<!-- OCR_END -->

￼

但是，如果我们使用日志这么简单，那还讲个毛线，首先我们定义不了日志级别，定义不了日志的格式...

## logging模块配置

**所以需要解决如下问题：**

1.控制日志级别

2.控制日志格式

3.控制输出的目标为文件

***

| 设置日志格式 |
| :--- |

使用`logging.basicConfig()`

```plain
#可在logging.basicConfig()函数中通过具体参数来更改logging模块默认行为，可用参数有
#filename：用指定的文件名创建FiledHandler（后边会具体讲解handler的概念），这样日志会被存储在指定的文件中。
#filemode：文件打开方式，在指定了filename时使用这个参数，默认值为“a”还可指定为“w”。
#format：指定handler使用的日志显示格式。 
#datefmt：指定日期时间格式。 
#level：设置rootlogger（后边会讲解具体概念）的日志级别 
#stream：用指定的stream创建StreamHandler。可以指定输出到sys.stderr,sys.stdout或者文件，默认为sys.stderr。若同时列出了filename和stream两个参数，则stream参数会被忽略。
#格式
%(name)s：Logger的名字，并非用户名，详细查看
%(levelno)s：数字形式的日志级别
%(levelname)s：文本形式的日志级别
%(pathname)s：调用日志输出函数的模块的完整路径名，可能没有
%(filename)s：调用日志输出函数的模块的文件名
%(module)s：调用日志输出函数的模块名
%(funcName)s：调用日志输出函数的函数名
%(lineno)d：调用日志输出函数的语句所在的代码行
%(created)f：当前时间，用UNIX标准的表示时间的浮 点数表示
%(relativeCreated)d：输出日志信息时的，自Logger创建以 来的毫秒数
%(asctime)s：字符串形式的当前时间。默认格式是 “2003-07-08 16:49:45,896”。逗号后面的是毫秒
%(thread)d：线程ID。可能没有
%(threadName)s：线程名。可能没有
%(process)d：进程ID。可能没有
%(message)s：用户输出的消息
```

```plain
#========使用
import logging
logging.basicConfig(filename='access.log',
                    format='%(asctime)s - %(name)s - %(levelname)s -%(module)s:  %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S %p',
                    level=10)
## stream=True 将日志打印到终端，但是如果配置了filename就只会打到文件里
logging.debug('调试debug')
logging.info('消息info')
logging.warning('警告warn')
logging.error('错误error')
logging.critical('严重critical')
#========结果
access.log内容:
2017-07-28 20:32:17 PM - root - DEBUG -test:  调试debug
2017-07-28 20:32:17 PM - root - INFO -test:  消息info
2017-07-28 20:32:17 PM - root - WARNING -test:  警告warn
2017-07-28 20:32:17 PM - root - ERROR -test:  错误error
2017-07-28 20:32:17 PM - root - CRITICAL -test:  严重critical
part2: 可以为logging模块指定模块级的配置,即所有logger的配置
```

<!-- OCR_START -->
| 排名 | 07loggin模块.py | 07loggin模块.py |
| --- | --- | --- |
| 2020-05-3113:36:57PM-root-DEBUG -07 loggin模块: | 调试debug | 2020-05-31 13:36:57 PM-root-INF0-07 loggin模块:消息info |
| 2 | 2020-05-3113:36:57 PM-root -WARNING-07Loggin模块:警告warn | 2020-05-3113:36:57 PM-root-ERROR-07Loggin模块：错误error |
| 5 | 20-05-31 13:36:57 PM-root -CRITICAL -07 loggin模块: 严重critical | C |
<!-- OCR_END -->

￼

***

| 解决日志双向输出 |
| :--- |

想要解决日志同时输出到文件和终端的问题，我们需要了解几个对象

```plain
logger对象：负责生产各种级别的日志
filter对象：负责过滤日志的规则
handler对象：负责控制文件输出位置
formmater对象：负责控制日志格式（跟handler捆绑）
# 例如：我们可以给输出到文件的日志，只打印error级别的日志，输出到终端的日志，打印debug级别。
```

**获取对象，并设置**

```plain
# logger对象
logger1=logging.getLogger('用户交易')   # 日志名，通常与业务相关
# filter对象
# handler对象
fh1=logging.FileHandler('a1.log')
fh2=logging.FileHandler('a2.log')
sm = logging.StreamHandler()
# formmater对象
formatter1=logging.Formatter(
    fmt='%(asctime)s - %(name)s - %(levelname)s -%(module)s:  %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S %p'
)
## fmt:日志格式
## datefmt:时间格式
formatter2 = logging.Formatter(
    fmt='%(asctime)s - %(levelname)s: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S %p'
)
```

目前对象获取完了，并且也设置完了，但是他们之间好像还没有关联

**绑定logger对象与handler对象**

```plain
logger1.addHandler(fh1)
logger1.addHandler(fh2)
logger1.addHandler(sm)
```

**绑定handler对象与formatter对象**

```plain
fh1.setFormatter(formatter1)
fh2.setFormatter(formatter1)
sm.setFormatter(formatter2)
```

**设置日志级别**

设置级别这里，必须要logger对象和handler对象两层关卡都放行，日志才能放行，通常二者级别相同

```plain
logger1.setLevel(10)
fh1.setLevel(10)
fh2.setLevel(10)
sm.setLevel(10)
```

**设置字符编码**

在设置handler对象的时候，可以插入一个encoding

```plain
fh1 = logging.FileHandler('a1.log',encoding='utf-8')
fh2 = logging.FileHandler('a2.log',encoding='utf-8')
sm = logging.StreamHandler()
```

**使用logger对象产生日志**

```plain
logger1.info('zls给qls转了一个亿')
```

<!-- OCR_START -->
PYTHON~/DeSktop/PYTHON]-
PYTHON自a1.log
07loggin模块.pyX
自a1.log
自a2.logx
access.log
04logging模块.py
Plugins supporting *.log files found.
2020-05-31 14:14:14PM-用户交易-INF0 -07Loggin模块：zls给qls转了-个亿
Run:
07loggin模块
Ln/python "/Users/driverzeng/Desktop/PYTHoN/o7loggin模块.py
2020-05-31 14:14:14PM-INF0:zls给qls转了-个亿
曾老湿
rocess finished with exit code 0
Driver Zeng
<!-- OCR_END -->

￼

但是这样好麻烦，我得记住所有对象的名字...

## 日志格式模板

***

| 从字典中加入日志配置信息 |
| :--- |

创建一个settings.py文件，将日志格式配置进去

```plain
"""
logging配置
"""
import os
import logging.config
# 定义三种日志输出格式 开始
standard_format = '[%(asctime)s][%(threadName)s:%(thread)d][task_id:%(name)s][%(filename)s:%(lineno)d]' \
                  '[%(levelname)s][%(message)s]' #其中name为getlogger指定的名字
simple_format = '[%(levelname)s][%(asctime)s][%(filename)s:%(lineno)d]%(message)s'
id_simple_format = '[%(levelname)s][%(asctime)s] %(message)s'
# 定义日志输出格式 结束
logfile_dir = os.path.dirname(os.path.abspath(__file__))  # log文件的目录
logfile_name = 'all2.log'  # log文件名
# 如果不存在定义的日志目录就创建一个
if not os.path.isdir(logfile_dir):
    os.mkdir(logfile_dir)
# log文件的全路径
logfile_path = os.path.join(logfile_dir, logfile_name)
# log配置字典
LOGGING_DIC = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': standard_format
        },
        'simple': {
            'format': simple_format
        },
    },
    'filters': {},
    'handlers': {
        #打印到终端的日志
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',  # 打印到屏幕
            'formatter': 'simple'
        },
        #打印到文件的日志,收集info及以上的日志
        'default': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',  # 保存到文件
            'formatter': 'standard',
            'filename': logfile_path,  # 日志文件
            'maxBytes': 1024*1024*5,  # 日志大小 5M
            'backupCount': 5,
            'encoding': 'utf-8',  # 日志文件的编码，再也不用担心中文log乱码了
        },
    },
    'loggers': {
        #logging.getLogger(__name__)拿到的logger配置
        '': {
            'handlers': ['default', 'console'],  # 这里把上面定义的两个handler都加上，即log数据既写入文件又打印到屏幕
            'level': 'DEBUG',
            'propagate': True,  # 向上（更高level的logger）传递
        },
    },
}
def load_my_logging_cfg():
    logging.config.dictConfig(LOGGING_DIC)  # 导入上面定义的logging配置
    logger = logging.getLogger(__name__)  # 生成一个log实例
    logger.info('It works!')  # 记录该文件的运行状态
if __name__ == '__main__':
    load_my_logging_cfg()
```

改完的版本

```plain
standard_format = '%(asctime)s - task:%(name)s - %(filename)s:%(lineno)d -' \
                  ' %(levelname)s : [%(message)s]'
simple_format = '%(filename)s:%(lineno)d - %(levelname)s : [%(message)s]'
fh1_path = r'a1.log'
fh2_path = r'a2.log'
# log配置字典
LOGGING_DIC = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': standard_format
        },
        'simple': {
            'format': simple_format
        },
    },
    'filters': {},
    'handlers': {
        #打印到终端的日志
        'ch': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',  # 打印到终端
            'formatter': 'simple'
        },
        #打印到a1.log文件的日志
        'fh1': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',  # 保存到文件
            'formatter': 'standard',
            'filename': fh1_path,  # 日志文件的路径
            'encoding': 'utf-8',  # 日志文件的编码，再也不用担心中文log乱码了
        },
        # 打印到a2.log文件的日志
        'fh2': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',  # 保存到文件
            'formatter': 'simple',
            'filename': fh2_path,  # 日志文件的路径
            'encoding': 'utf-8',  # 日志文件的编码，再也不用担心中文log乱码了
        },
    },
    'loggers': {
        '': {
            'handlers': ['fh1', 'fh2', 'ch'],
            'level': 'DEBUG',
        },
    },
}
```

日志配置完了，那么如何使用日志呢？

run.py

```plain
import logging.config
import settings
logging.config.dictConfig(settings.LOGGING_DIC)
# 获取用户交易的logger对象
logger1=logging.getLogger('用户交易')
#logger1-> fh1,fh2,ch
logger1.info('zls给qls转账1个亿')
logger2=logging.getLogger('用户权限')
#logger2-> fh1,fh2,ch
logger2.error('lls没有执行权限')
```

## 在软件开发目录规范中使用日志模板

首先，我们要把运行的py文件，放到顶级目录，这样一来我们就不用再找顶级目录了。

<!-- OCR_START -->
- ATM[~/PycharmProjects/ATM]-../start.py[ATM]
- ATM
- start.py
- Project
- Readme X
- src.py
- settings.py
- ATM ~/PycharmProjects/ATM
- from core import src
- abin
- conf
- name_
- main
- core
- src.run()
- Ddb
- alib
- Dlog
- Readme
- llli External Libraries
- Scratches and Consoles
- 曾老湿
- DriverZeng
<!-- OCR_END -->

￼

**start.py**

```plain
from core import src
if __name__ == '__main__':
    src.run()
```

**src.py**

```plain
from lib import common
logger1=common.get_logger('交易')
def register():
    print('\033[45m注册\033[0m')
def login():
    print('\033[44m登录\033[0m')
def shopping():
    print('\033[43m购物\033[0m')
def pay():
    print('\033[42m支付\033[0m')
def transfer():
    print('\033[41m转账\033[0m')
    logger1.info('zls给qls转账两个亿')
func_dic={
    '1':register,
    '2':login,
    '3':shopping,
    '4':pay,
    '5':transfer
}
def run():
    while True:
        print("""
        0 退出
        1 注册
        2 登录
        3 购物
        4 支付
        5 转账
        """)
        choice=input('请输入您的操作: ').strip()
        if choice == '0':break
        if choice not in func_dic:
            print('输入错误指令')
            continue
        func_dic[choice]()
```

**settings.py**

```plain
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))
standard_format = '%(asctime)s - task:%(name)s - %(filename)s:%(lineno)d -' \
                  ' %(levelname)s : [%(message)s]'
simple_format = '%(filename)s:%(lineno)d - %(levelname)s : [%(message)s]'
fh1_path = os.path.join(BASE_DIR,'log','zls_access.log')
fh2_path = os.path.join(BASE_DIR,'log','zls_mode.log')
# log配置字典
LOGGING_DIC = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': standard_format
        },
        'simple': {
            'format': simple_format
        },
    },
    'filters': {},
    'handlers': {
        #打印到终端的日志
        'ch': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',  # 打印到终端
            'formatter': 'simple'
        },
        #打印到a1.log文件的日志
        'fh1': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',  # 保存到文件
            'formatter': 'standard',
            'filename': fh1_path,  # 日志文件的路径
            'encoding': 'utf-8',  # 日志文件的编码，再也不用担心中文log乱码了
        },
        # 打印到a2.log文件的日志
        'fh2': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',  # 保存到文件
            'formatter': 'simple',
            'filename': fh2_path,  # 日志文件的路径
            'encoding': 'utf-8',  # 日志文件的编码，再也不用担心中文log乱码了
        },
    },
    'loggers': {
        '': {
            'handlers': ['fh1', 'fh2', 'ch'],
            'level': 'DEBUG',
        },
    },
}
```

**common.py**

```plain
import logging.config
from conf import settings
def get_logger(name):
    logging.config.dictConfig(settings.LOGGING_DIC)
    logger=logging.getLogger(name)
    return logger
```

<!-- OCR_START -->
ATM[~/PycharmProjects/ATM]-../start.py[ATM]
ATMstart.py
Project
start.pyx
ReadmeX
src.py
settings.py
ATM ~/PycharmProjects/ATM
bin
from core import src
aconf
if_name_
main_'：
src.run()
core
bash
Ddb
C1
Lastlogin:ThuMay2817:59:03on ttys000
alib
MacBook-pro:~driverzeng$whichpython3
alog
/Library/Frameworks/Python.framework/Versions/3.6/bin/python3
Readme
MacBook-pro:~driverzengscd/Users/driverzeng/PycharmProjects/ATM/Log
start.py
MacBook-pro:log driverzeng$11
lll External Libraries
total16
Scratches and Consoles
-rw-r--r--
1driverzengstaff 8653115:08zls_access.log
-rw-r--r--1 driverzeng staff 46 5 31 15:08zls_mode.log
MacBook-pro:logdriverzeng$ cat zls_access.log
2020-05-3115:08:30,539-task：交易-src.py:22-INF0：[zls给qls转账两个亿]
MacBook-pro:log driverzeng$ catzls_mode.log
src.py：22-INFO：[zls给qls转账两个亿]
Run:
start
3
5转账
4
请输入您的操作：5
0退出
1
注册
2
登录
3购物
4支付
曾老湿
青输入您的操作：src.py:22-INFO：[zls给qls转账两个亿]
<!-- OCR_END -->

￼

<!-- OCR_START -->
- ATMstart.py
- Project
- start.pyx
- Readmex
- src.pyX
- settings.py
- ATM~/PycharmProjects/ATM
- ld
- bin
- fromcore import src
- conf
- i_name
- _main_':
- src.run（）
- core
- src.py
- db
- lib
- log
- zls_access.log
- zls_mode.log
- 自Readme
- start.py
- Ill External Libraries
- Scratches and Consoles
- Run:
- start
- 3购物
- 4支付
- 5转账
- 请输入您的操作：5
- 0退出
- 1注册
- 2
- 登录
- 3
- 购物
- 请输入您的操作：src.py:22-INFO：[zls给qls转账两个亿]
- 曾老湿
- Dri
- erZeng
<!-- OCR_END -->

￼

> 更新: 2020-06-25 11:16:53  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/wcugzc>