# 21天Python入门必备 · 第四章

> 本章目标：搞懂模块和包的概念、会用 pip 装第三方库；掌握运维最常用的标准库——os、sys、time/datetime、json、random、re、subprocess、shutil、hashlib、logging；最后写一个能跑的系统巡检脚本。

---

# 一、模块与包

## 1.1 什么是模块

随着代码越写越多，全堆在一个文件里又乱又难找。我们把相关的函数、变量拆到单独的 `.py` 文件里，这个文件就是一个**模块（module）**。

Python 强大的一个重要原因就是"自带电池"：**标准库**内置了大量模块，直接 import 就能用，不用自己造轮子。

## 1.2 模块的导入方式

假设有个文件 `mytools.py`：

```python
# mytools.py
def sayhi(name):
    print("hi", name)

PI = 3.14
```

在另一个文件里导入使用：

```python
# 方式一：导入整个模块，使用时要带模块名
import mytools
mytools.sayhi("Alex")
print(mytools.PI)

# 方式二：只导入需要的东西
from mytools import sayhi
sayhi("Alex")

# 方式三：导入并起别名（名字太长时常用）
import mytools as mt
mt.sayhi("Alex")

# 一次导入多个
import os, sys
from mytools import sayhi, PI
```

`from mytools import *` 可以导入全部，但不推荐（名字容易冲突、看不出变量从哪来）。

## 1.3 包（package）

模块多了，可以用文件夹组织，这种放着多个 `.py` 文件的文件夹叫**包**。文件夹里有个 `__init__.py`（Python 3.3+ 中可省略）就表示这是一个包。

```python
# 目录结构
mypackage/
    __init__.py
    monitor.py
    report.py

# 使用
import mypackage.monitor
from mypackage import report
```

导入模块时 Python 的查找顺序（`sys.path`）：当前目录 → 环境变量 PYTHONPATH 指定目录 → Python 安装目录。同名文件不要和标准库重名（比如别把自己的文件叫 `os.py`），否则会把标准库盖住。

## 1.4 程序入口：`__name__`

每个模块都有个内置变量 `__name__`：

- 直接运行这个文件时，`__name__` 等于 `"__main__"`；
- 被别人 import 时，`__name__` 等于模块名。

所以经常看到这句：

```python
def main():
    print("程序开始")

if __name__ == "__main__":
    main()
```

作用：写在它下面的代码只在"直接运行"时执行，被 import 时不会自动跑。写工具脚本时强烈建议这么组织。

## 1.5 用 pip 安装第三方模块

标准库之外的库，用包管理工具 **pip** 安装（Python 3.4+ 自带）：

```bash
pip install requests            # 安装
pip install requests==2.31.0    # 指定版本
pip uninstall requests          # 卸载
pip list                        # 查看已安装的包
pip install --upgrade requests  # 升级
pip freeze > requirements.txt   # 导出依赖清单
pip install -r requirements.txt # 按清单批量安装
```

- Linux / Mac 上可能要用 `pip3`；
- 国内服务器下载慢时可用镜像加速：
  `pip install requests -i https://pypi.tuna.tsinghua.edu.cn/simple`
- 建议在**虚拟环境**里装项目依赖（`python -m venv venv`），避免不同项目的库版本互相打架。

---

# 二、os —— 操作系统与文件交互

`os` 模块让脚本能操作文件、目录和环境变量，是运维使用频率最高的模块。

```python
import os
```

## 2.1 目录操作

```python
os.getcwd()                 # 当前工作目录
os.chdir("/tmp")            # 切换工作目录
os.listdir("/etc")          # 列出目录下所有条目（返回列表）
os.mkdir("test")            # 创建目录（上级不存在会报错）
os.makedirs("a/b/c")        # 递归创建多级目录
os.rmdir("test")            # 删除空目录
os.rename("a.txt", "b.txt") # 重命名 / 移动
os.remove("b.txt")          # 删除文件
os.stat("/etc/hosts")       # 查看文件属性（大小、修改时间等）
```

## 2.2 os.path —— 路径处理（最常用）

```python
os.path.join("/etc", "hosts")     # 智能拼接路径 → '/etc/hosts'
os.path.exists("/etc/hosts")      # 路径是否存在 → True
os.path.isfile("/etc/hosts")      # 是不是文件
os.path.isdir("/etc")             # 是不是目录
os.path.abspath("a.txt")          # 转成绝对路径
os.path.dirname("/etc/hosts")     # 所在目录 → '/etc'
os.path.basename("/etc/hosts")    # 文件名 → 'hosts'
os.path.splitext("a.txt")         # 拆分扩展名 → ('a', '.txt')
os.path.getsize("/etc/hosts")     # 文件大小（字节）
```

> 拼路径**永远用 `os.path.join`**，不要手写 `"/" +`，因为 Windows 用 `\`、Linux 用 `/`，交给它自动处理。

## 2.3 环境变量与其他

```python
os.environ                  # 所有环境变量（字典样）
os.environ.get("HOME")      # 读取某个环境变量
os.environ["PATH"]          # PATH
os.name                     # 'posix'（Linux/Mac）或 'nt'（Windows）
os.system("ls")             # 执行 shell 命令（拿不到输出，推荐用 subprocess）
os.walk("/tmp")             # 递归遍历目录树（见下）
```

递归遍历目录，常用于批量找文件：

```python
for dirpath, dirnames, filenames in os.walk("/var/log"):
    for name in filenames:
        full = os.path.join(dirpath, name)
        print(full)
```

---

# 三、sys —— Python 解释器相关

```python
import sys

sys.version          # Python 版本
sys.platform         # 平台：'linux'、'win32'、'darwin'
sys.path             # 模块搜索路径列表
sys.argv             # 命令行参数（脚本名在后）
sys.exit(1)          # 退出程序（0 正常，非 0 异常）
```

`sys.argv` 让脚本可以接收外部参数：

```python
# args.py
import sys
print(sys.argv)
```

```bash
$ python args.py /tmp 80
['args.py', '/tmp', '80']
```

`sys.argv[0]` 是脚本名，真正的参数从 `[1]` 开始。注意先判断长度，参数没传会 IndexError。

---

# 四、time 与 datetime —— 时间处理

## 4.1 time

```python
import time

time.time()              # 当前时间戳（1970 年至今的秒数，浮点数）
time.sleep(2)            # 暂停 2 秒（轮询脚本里控制间隔）
time.localtime()         # 当前本地时间（结构化时间）
time.strftime("%Y-%m-%d %H:%M:%S")     # 格式化成字符串
time.strptime("2026-09-30", "%Y-%m-%d") # 字符串解析回结构化时间
```

常用格式符：

| 符号 | 含义 |
| --- | --- |
| `%Y` | 四位年份 |
| `%m` | 月（01～12） |
| `%d` | 日 |
| `%H` `%M` `%S` | 时、分、秒 |

## 4.2 datetime

做日期加减更方便：

```python
from datetime import datetime, timedelta

datetime.now()                       # 当前时间
datetime.now().strftime("%Y-%m-%d")  # 格式化
datetime.strptime("2026-09-30", "%Y-%m-%d")  # 字符串转日期

now + timedelta(days=3)              # 3 天后
now - timedelta(hours=2)             # 2 小时前
```

日志按日期命名文件、判断文件是几小时前修改的，都靠这两个模块。

---

# 五、json —— 数据的序列化

程序里的数据（字典、列表）只存在内存里。要存到文件或通过网络发送，需要转成文本——**JSON** 是最通用的格式。

```python
import json

info = {"name": "Alex", "age": 22, "skills": ["linux", "python"]}

json.dumps(info)            # Python 对象 → JSON 字符串
json.loads('{"name": "Alex"}')  # JSON 字符串 → Python 对象

# 直接读写文件
with open("info.json", "w", encoding="utf-8") as f:
    json.dump(info, f, ensure_ascii=False, indent=2)

with open("info.json", encoding="utf-8") as f:
    data = json.load(f)
```

- `ensure_ascii=False`：中文不要转成 `\uXXXX`，直接显示中文；
- `indent=2`：缩进，文件更好读；
- JSON 和 Python 对象的对应：对象 ↔ dict、数组 ↔ list、true/false ↔ True/False、null ↔ None。

`pickle` 是 Python 专用的序列化，支持几乎所有 Python 对象，但只能在 Python 之间用、且**不要加载来源不可信的 pickle 文件**（有安全风险）。跨程序、跨语言传数据一律用 JSON。

---

# 六、random —— 随机数

```python
import random

random.random()            # 0～1 之间随机小数
random.randint(1, 100)     # 1～100 随机整数（含两端）
random.choice(["a", "b"])  # 从序列里随机挑一个
random.sample(range(100), 5)  # 随机取 5 个不重复的
random.uniform(1, 5)       # 1～5 随机小数
random.shuffle(mylist)     # 把列表原地打乱
random.seed(42)            # 固定随机种子（结果可复现，测试用）
```

实用例子：生成 4 位随机验证码

```python
import random, string

code = ''.join(random.choices(string.digits, k=4))
```

---

# 七、re —— 正则表达式

正则用于按"模式"匹配、提取、替换文本，是**日志分析**的利器。

```python
import re
```

## 7.1 四个核心函数

```python
re.match(r"abc", "abcdef")    # 从字符串开头匹配，成功返回对象，否则 None
re.search(r"\d+", "a123b")    # 在整个文本里找第一个匹配
re.findall(r"\d+", "a1 b22")  # 找出所有匹配，返回列表
re.sub(r"\s", "-", "a b c")   # 替换 → 'a-b-c'
```

取匹配结果：

```python
m = re.search(r"(\d+)", "端口 8080")
m.group()       # '8080'
m.group(1)      # 第 1 个括号里的内容
```

> 加 `r"..."` 原始字符串，避免反斜杠被 Python 转义。

## 7.2 常用语法速查

| 模式 | 含义 |
| --- | --- |
| `.` | 任意一个字符（不含换行） |
| `\d` `\w` `\s` | 一个数字 / 字母数字 / 空白 |
| `\D` `\W` `\S` | 上面的反面 |
| `*` `+` `?` | 出现 0 次以上 / 1 次以上 / 0 或 1 次 |
| `{n}` `{n,m}` | 恰好 n 次 / n 到 m 次 |
| `[abc]` `[0-9]` | 括号内任意一个字符 |
| `[^0-9]` | 不是数字 |
| `^...` `...$` | 开头 / 结尾 |
| `(...)` | 分组，可单独提取 |
| `a\|b` | a 或 b |

## 7.3 实战：从日志里提取 IP

```python
import re

line = '2026-09-30 10:00:01 192.168.1.50 GET /index 200'
ip = re.search(r"(\d{1,3}\.){3}\d{1,3}", line)
print(ip.group())          # 192.168.1.50
```

提取键值、从杂乱输出里抠数字、校验输入格式，都靠它。建议在 <https://regex101.com> 上边测边写，效率最高。

---

# 八、subprocess —— 调用外部命令

Python 脚本经常需要调用系统命令（如 `df`、`systemctl`、`ip addr`）。用 `subprocess` 替代 `os.system`，能安全地拿到命令输出和返回码。

```python
import subprocess

result = subprocess.run(["df", "-h"], capture_output=True, text=True)
print(result.returncode)   # 返回码：0 成功，非 0 失败
print(result.stdout)       # 标准输出
print(result.stderr)       # 错误输出
```

参数说明：

- 命令和参数写成**列表** `["systemctl", "status", "sshd"]`，不要拼成一整行字符串；
- `capture_output=True`：捕获输出；`text=True`：按字符串返回（否则是 bytes）；
- 命令执行失败默认不抛异常，要自动检查可用加 `check=True`（失败抛 `CalledProcessError`）。

处理需要 shell 管道的命令时，可以用 `shell=True`：

```python
subprocess.run("df -h | grep sda", shell=True)
```

⚠️ **安全提醒：`shell=True` 时命令是字符串，如果其中拼进了用户输入，会有命令注入风险。** 生产脚本优先用列表形式，并自己对输入做校验。

运维习惯：先用只读命令（`df`、`uptime`、`systemctl status`）做自动化采集；涉及 restart、kill 等动作的命令，脚本上线前必须人工确认影响。

---

# 九、shutil —— 高级文件操作

`os` 能删文件，但复制整个目录、递归删除要靠 `shutil`：

```python
import shutil

shutil.copy("a.txt", "b.txt")        # 复制文件
shutil.copytree("dir1", "dir2")      # 递归复制整个目录
shutil.move("a.txt", "/tmp/")        # 移动 / 重命名
shutil.rmtree("dir2")                # 递归删除整个目录（危险！）
shutil.disk_usage("/")               # 磁盘使用情况：total/used/free
shutil.which("python3")              # 查命令的完整路径，类似 shell 的 which
```

⚠️ `rmtree` 等于 `rm -rf`，不可逆。脚本里删东西前先打印目标路径确认，或先做"干跑（dry-run）"。

---

# 十、hashlib —— 哈希校验

用于文件完整性校验、密码哈希：

```python
import hashlib

m = hashlib.sha256()
m.update("hello".encode("utf-8"))
print(m.hexdigest())          # 64 位十六进制摘要

hashlib.md5(b"hello").hexdigest()
```

实战：计算文件的 MD5（文件大要分块读，避免一次占满内存）

```python
import hashlib

def file_md5(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()
```

下载文件后比对官网哈希、判断两个文件内容是否相同、配置是否被改动，都用它。

> 注意：MD5 只适合**防意外损坏/校验**，不适合存密码（容易被碰撞和彩虹表破解）。存用户密码应使用 `bcrypt` 等专门算法。

---

# 十一、logging —— 写日志

脚本小用 print 看结果，正式工具要用 `logging` 记录日志：可分级、可同时输出到屏幕和文件、自带时间。

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    filename="app.log",          # 不写 filename 就只输出到屏幕
)

logging.debug("详细调试信息")
logging.info("正常运行信息")
logging.warning("警告")
logging.error("错误")
```

日志级别从低到高：`DEBUG < INFO < WARNING < ERROR < CRITICAL`。`level` 设成 INFO 后，DEBUG 信息就不会打印，线上排障时临时调成 DEBUG 即可看到详细过程。

运维脚本里建议把"采集到什么、判断结果、异常堆栈"都记进日志，方便事后回溯。

---

# 十二、综合实战：系统巡检脚本

把本章学的串起来：采集系统负载、磁盘使用、失败的系统服务，超阈值就告警，并把结果保存成 JSON 报告。

> 说明：脚本只执行**只读采集命令**（uptime、df、systemctl is-failed），不会对系统做任何修改。

```python
#!/usr/bin/env python3
# health_check.py —— 简易系统巡检
import json
import subprocess
from datetime import datetime

import shutil

DISK_WARN = 80          # 磁盘使用率告警阈值（%）


def run(cmd):
    """执行只读命令，返回去掉换行的输出；失败返回空字符串。"""
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else ""


def check_disk():
    total, used, free = shutil.disk_usage("/")
    percent = round(used / total * 100, 1)
    return {
        "percent": percent,
        "total_gb": round(total / 1e9, 1),
        "free_gb": round(free / 1e9, 1),
        "alarm": percent >= DISK_WARN,
    }


def check_load():
    # uptime 输出形如：... load average: 0.10, 0.05, 0.01
    out = run(["uptime"])
    return out.split("load average:")[-1].strip() if "load average:" in out else out


def check_failed_services():
    # --quiet 时没有输出；列出处于 failed 状态的服务（只读）
    out = run(["systemctl", "list-units", "--state=failed", "--no-legend"])
    return [line.split()[0] for line in out.splitlines()] if out else []


def main():
    report = {
        "time": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "disk": check_disk(),
        "load": check_load(),
        "failed_services": check_failed_services(),
    }

    # 落盘一份 JSON 报告
    with open("health_report.json", "w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    # 简单告警
    if report["disk"]["alarm"]:
        print(f"[告警] 根分区使用率 {report['disk']['percent']}%，已超阈值")
    if report["failed_services"]:
        print(f"[告警] 存在失败服务：{', '.join(report['failed_services'])}")
    print("巡检完成，报告已保存到 health_report.json")


if __name__ == "__main__":
    main()
```

运行与扩展思路：

```bash
python3 health_check.py
cat health_report.json
```

可以继续添加的检查项（都是只读）：

- 内存：读 `/proc/meminfo` 或执行 `free -m`；
- GPU 场景：`nvidia-smi --query-gpu=... --format=csv`；
- 关键进程是否存活：`pgrep -f xxx`；
- 配合 `logging` 按日期留存历史报告；想定时跑，可交给 crontab。

这样的小脚本就是运维日常自动化的起点：先把人工排查时敲的只读命令固化下来，再逐步加判断、加告警。

---

# 十三、本章练习

1. **日志关键字统计**：读取一个日志文件，统计 `ERROR` 出现次数，并用正则提取每行的时间戳和 IP。
2. **批量整理文件**：遍历某目录，按扩展名把文件分类到不同子目录（用 `shutil.move`，先只打印计划、确认后再真正移动）。
3. **配置文件完整性**：对 `/etc` 下指定文件计算 sha256，和上次保存的值对比，输出是否被改动。
4. **命令行小工具**：用 `sys.argv` 接收一个目录路径，打印该目录的磁盘占用和大文件 Top 5（`os.path.getsize`）。
5. **扩展巡检脚本**：给上面的 health_check.py 加上内存使用率检查和日志记录（logging）。

---

> 更新: 2026-09-30
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/eqx2yk>
