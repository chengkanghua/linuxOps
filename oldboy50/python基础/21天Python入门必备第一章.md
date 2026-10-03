# 21天Python入门必备 · 第一章

> 本章目标：搞懂 Python 是什么、能做什么；装好环境，写出第一个程序；学会变量、输入输出、基本数据类型、运算符和最基础的流程控制。

---

# 一、课程介绍

## 1.1 Python 是什么

Python 是一门**高级通用编程语言**，最大的特点是：语法简单、读起来像英语，新手也能很快用它做出能用的工具。

> "Life is short, you need Python."（人生苦短，我用 Python。）

## 1.2 Python 能做什么

| 方向 | 说明 |
| --- | --- |
| 自动化运维 | 批量操作服务器、巡检、告警、日志分析（运维必备） |
| 数据分析 / 科学计算 | NumPy、Pandas、Matplotlib 等强大的库 |
| 人工智能 | PyTorch、TensorFlow 等主流框架都以 Python 为主 |
| Web 网站开发 | Django、Flask、FastAPI 等框架 |
| 网络爬虫 | Requests、Scrapy、BeautifulSoup |
| 自动化测试、云计算、游戏脚本等 | 应用面非常广 |

对运维人员来说，Python 最大的价值是：**把重复、繁琐的手动操作写成脚本，让机器自动完成**。

Google、YouTube、Dropbox、NASA、Instagram、知乎、豆瓣、腾讯等大量公司都在使用 Python。

## 1.3 Python 和其他语言的区别

| 语言 | 特点 |
| --- | --- |
| C / C++ | 贴近底层、速度快，但学习成本高；用于驱动、嵌入式、游戏引擎等 |
| Java | 使用广泛、跨平台；用于大型企业系统、安卓 App、网站后端 |
| PHP | 适合中小型 Web 网站开发 |
| **Python** | 应用领域和 Java 一样广，开发效率更高、学习成本更低 |

---

# 二、编程语言是怎么回事

计算机只认识 `0` 和 `1`。编程语言从底层到高级，可以分成三类：

| 类别 | 说明 | 优点 | 缺点 |
| --- | --- | --- | --- |
| 机器语言 | 直接就是 0/1 指令 | 最底层、执行最快 | 最复杂、开发效率最低 |
| 汇编语言 | 用助记符代替 0/1 | 比较底层、较快 | 仍然复杂、开发效率低 |
| 高级语言 | 接近人类语言，如 C、Java、Python | 对人友好、开发效率高 | 需要"翻译"成机器码才能运行 |

## 2.1 编译型 vs 解释型

高级语言编写的程序不能直接被计算机识别，必须经过"翻译"。按翻译方式分成两类：

**编译型**（如 C、C++）：运行前，先用编译器把整个程序一次性翻译成机器码文件，以后直接运行这个文件。

```
人写的源码                机器码文件
print(...)  ──编译器──▶  0101010101...  ──▶ CPU 直接运行
            （编译一次）   （以后可反复运行）
```

- 优点：运行速度快，不依赖语言环境
- 缺点：改一次代码就要重新编译；跨平台性差

**解释型**（如 Python、PHP）：运行时，解释器一边把源码逐句翻译成机器指令，一边交给 CPU 执行。

```
人写的源码            解释器             CPU
print(...)  ──▶  边解释边执行  ──▶  每次运行都要重新解释
```

- 优点：天生跨平台（一份代码到处运行）；改完立刻能看到效果
- 缺点：运行速度相对慢，机器上必须装解释器

---

# 三、Python 简介与发展史

Python 的作者是荷兰人 **吉多·范罗苏姆（Guido van Rossum）**。

- 1989 年圣诞节，Guido 为了打发假期开始编写这门语言。
- 名字来自他喜欢的英国喜剧《Monty Python's Flying Circus》，不是"蟒蛇"的意思。
- 1991 年，第一个 Python 解释器诞生。
- 2000 年 Python 2.0 发布；2008 年 Python 3.0 发布。
- Python 2 已于 **2020 年停止维护**，本教程全部使用 **Python 3**。

## Python 解释器的几种实现

| 解释器 | 说明 |
| --- | --- |
| **CPython** | 官方解释器，用 C 语言开发，使用最广。命令行运行 `python` 启动的就是它 |
| IPython | 基于 CPython 的增强交互界面 |
| PyPy | 采用 JIT 即时编译，运行速度更快 |
| Jython / IronPython | 分别运行在 Java 平台和微软 .NET 平台 |

---

# 四、安装 Python 与 Hello World

## 4.1 安装

- **Windows**：到官网 <https://www.python.org/downloads/> 下载安装包，安装时**务必勾选 `Add Python to PATH`**，再点 Install Now。
- **Linux / Mac**：系统一般自带 Python 3，在终端输入 `python3 --version` 查看版本。

安装好后，验证一下：打开终端（Windows 按 `Win+R` 输入 `cmd`），执行：

```bash
python --version      # Windows
python3 --version     # Linux / Mac
```

能打印出版本号（如 `Python 3.12.x`）就说明安装成功。

## 4.2 第一个程序

用任意文本编辑器（记事本、VS Code 都可以）新建一个文件，写入：

```python
print("Hello World!")
print("Python 好简单呀！")
```

保存为 `hello.py`（**`.py` 是 Python 文件的后缀名**）。在终端里进入文件所在目录，执行：

```bash
python hello.py       # Windows
python3 hello.py      # Linux / Mac
```

屏幕上就会打印出：

```
Hello World!
Python 好简单呀！
```

> 文件名前加 `python`，意思是把这个文件交给 Python 解释器去解释执行。

## 4.3 交互模式

直接在终端输入 `python`（不带文件名）回车，就进入了**交互模式**：

```python
>>> print("hi")
hi
>>> 1 + 2
3
>>> exit()   # 退出交互模式
```

交互模式适合**临时测试一两行代码**，正式写程序还是要用 `.py` 文件。

---

# 五、变量

## 5.1 为什么需要变量

假设要算一天的花销：

```python
eat = 10 + 15 + 7 + 4 + 7 + 3     # 吃饭 46
cloth = 20                        # 买衣服
traffic = 6 + 6 + 6 + 6 + 6       # 交通 30
fun = 300 + 300 + 200 + 400       # 娱乐 1200

total = eat + cloth + traffic + fun
print("总消费", total)            # 总消费 1296
```

`eat`、`total` 这些名字，就是把计算的中间结果临时存到内存里，起个名字方便后面使用——这就是**变量**。

```
   变量名              变量值
 ┌────────┐         ┌───────────┐
 │  name  │ ──────▶ │ "Alex Li" │
 └────────┘         └───────────┘
  （标识符）          （存在内存里的数据）
```

> 变量必须**先赋值，再使用**。

## 5.2 变量定义规则

```python
name = "Alex Li"
age = 22
```

变量名的规则：

1. 只能包含**字母、数字、下划线**；
2. **不能以数字开头**（`1name` 是错的）；
3. 不能使用 Python 的关键字，如 `if`、`for`、`while`、`class`、`return` 等。

两种常见命名风格：

```python
# 驼峰体
AgeOfOldboy = 56

# 下划线（Python 官方推荐）
age_of_oldboy = 56
```

不推荐的写法：用中文或拼音命名、名字过长、词不达意。

## 5.3 常量

常量就是运行中不应该被改变的量，比如圆周率 3.14159。

Python 没有专门的常量语法，约定俗成用**全部大写**的变量名表示常量：

```python
PI = 3.1415926
AGE_OF_OLDBOY = 56
```

这只是君子协定，语法上仍然能改，靠的是程序员自觉。

---

# 六、用户输入与注释

## 6.1 读取用户输入

```python
name = input("What is your name? ")
print("Hello", name)
```

程序运行到 `input()` 会**停下来等用户输入**，回车后才继续往下走。

可以连续问多个信息：

```python
name = input("姓名：")
age = input("年龄：")
hometown = input("家乡：")
print("你好", name, "，你今年", age, "岁，来自", hometown)
```

> 注意：`input()` 得到的内容**永远是字符串**。如果要当数字用，需要转换：
> `age = int(input("年龄："))`

## 6.2 注释

注释是给人看的说明，解释器不会执行。

```python
# 这是单行注释

"""
这是多行注释，
可以写好几行。
"""
```

好的代码自己会说话，注释用来说明"为什么这么写"，而不是复述代码。

---

# 七、基本数据类型

计算机分不清 `1` 和 `"1"` 的区别，必须由程序员明确告诉它数据的类型。Python 最常用的基础类型：

| 类型 | 例子 | 说明 |
| --- | --- | --- |
| int（整数） | `22`、`-5` | Python 3 的整数没有大小限制，也没有 long 类型 |
| float（浮点数） | `3.14`、`1.5` | 带小数点的数 |
| str（字符串） | `"你好"`、`'hi'` | 加了引号的内容 |
| bool（布尔） | `True`、`False` | 只有真 / 假两个值 |

## 7.1 字符串

在 Python 中，**加了引号的内容都是字符串**：

```python
name = "Alex Li"      # 双引号
age = "22"            # 加了引号，就是字符串
age2 = 22             # 没加引号，是整数
hometown = 'ShanDong' # 单引号也可以
```

单引号和双引号没有区别，当内容本身带单引号时，可以用双引号包裹：

```python
msg = "My name is Alex, I'm 22 years old!"
```

多行字符串使用**三个引号**：

```python
msg = """
今天我想写首小诗，
歌颂我的同桌，
你看他那乌黑的短发，
好像一只炸毛鸡。
"""
print(msg)
```

字符串可以**相加（拼接）**和**相乘（重复）**：

```python
>>> "Alex" + "Li"
'AlexLi'
>>> "abc" * 3
'abcabcabc'
```

但字符串**不能和数字直接相加**，类型不同会报错：

```python
>>> "abc" + 123
TypeError: can only concatenate str (not "int") to str
```

想知道一个值是什么类型，用 `type()`：

```python
>>> type(age)
<class 'str'>
>>> type(age2)
<class 'int'>
```

## 7.2 布尔类型

布尔类型只有两个值：`True`（真）和 `False`（假），主要用于条件判断：

```python
>>> a = 3
>>> b = 5
>>> a > b
False
>>> a < b
True
```

比较的结果是真是假，决定了程序接下来走哪条路：

```python
if a > b:
    print("a 比 b 大")
else:
    print("a 比 b 小")
```

---

# 八、格式化输出

我们想把用户输入的信息整齐地打印成一张"名片"：

```python
name = input("Name: ")
age = input("Age: ")
job = input("Job: ")

info = f"""
------------ info of {name} ------------
Name : {name}
Age  : {age}
Job  : {job}
---------------- end -------------------
"""
print(info)
```

这里用的是 **f-string**：在字符串前加 `f`，用 `{变量名}` 把变量填进去。这是 Python 3 最推荐的写法，最简单直观。

老代码里还会看到另外两种写法，认识即可：

```python
"%s, %d, %f" % (name, age, height)     # %s 字符串、%d 整数、%f 小数
"{} is {}".format(name, age)           # format 写法
```

---

# 九、运算符

## 9.1 算数运算符（a = 10，b = 20）

| 运算符 | 含义 | 例子 | 结果 |
| --- | --- | --- | --- |
| `+` | 加 | `a + b` | 30 |
| `-` | 减 | `a - b` | -10 |
| `*` | 乘 | `a * b` | 200 |
| `/` | 除 | `b / a` | 2.0 |
| `%` | 取余数 | `b % a` | 0 |
| `**` | 幂（次方） | `a ** 2` | 100 |
| `//` | 整除（取商的整数部分） | `9 // 2` | 4 |

## 9.2 比较运算符（结果是 bool 值）

| 运算符 | 含义 | 例子 | 结果 |
| --- | --- | --- | --- |
| `==` | 等于 | `a == b` | False |
| `!=` | 不等于 | `a != b` | True |
| `>` | 大于 | `a > b` | False |
| `<` | 小于 | `a < b` | True |
| `>=` | 大于等于 | `a >= 10` | True |
| `<=` | 小于等于 | `a <= 5` | False |

## 9.3 赋值运算符

| 运算符 | 含义 | 等价于 |
| --- | --- | --- |
| `=` | 赋值 | `a = 10` |
| `+=` | 加后赋值 | `a += 3` → `a = a + 3` |
| `-=` | 减后赋值 | `a -= 3` → `a = a - 3` |
| `*=` | 乘后赋值 | `a *= 3` |
| `/=` | 除后赋值 | `a /= 3` |
| `%=` | 取余后赋值 | `a %= 3` |
| `**=` | 取幂后赋值 | `a **= 3` |
| `//=` | 整除后赋值 | `a //= 3` |

## 9.4 逻辑运算符

| 运算符 | 含义 | 例子 |
| --- | --- | --- |
| `and` | 与：两边都为真，结果才为真 | `a == 10 and b == 20` → True |
| `or` | 或：任意一边为真，结果就为真 | `a == 11 or b == 20` → True |
| `not` | 非：取反 | `not a == 11` → True |

---

# 十、流程控制：if 分支

到目前为止程序都是从上到下顺序执行。分支语句让程序可以**根据条件选择走哪条路**。

## 10.1 单分支

```python
if 条件:
    条件成立时执行的代码
```

注意：条件后面有**冒号 `:`**，下一行要**缩进 4 个空格**。Python 靠缩进来区分代码块。

## 10.2 双分支

```python
age = 48
if age > 50:
    print("太老了，该退休啦")
else:
    print("还能再折腾几年！")
```

## 10.3 多分支

```python
if 条件1:
    条件1成立时执行
elif 条件2:
    条件1不成立、条件2成立时执行
elif 条件3:
    上面都不成立、条件3成立时执行
else:
    所有条件都不成立时执行
```

例子：成绩评级

```python
score = int(input("请输入分数："))

if score > 100:
    print("分数最多 100")
elif score >= 90:
    print("A")
elif score >= 80:
    print("B")
elif score >= 60:
    print("C")
elif score >= 40:
    print("D")
elif score >= 0:
    print("E")
else:
    print("分数不能是负数")
```

## 10.4 分支嵌套

if 里面还可以再写 if：

```python
name = input("name: ")
sex = input("sex (f/m): ")
age = int(input("age: "))

if sex == "f":
    if age < 28:
        print("I love girls")
    else:
        print("姐弟恋也很好")
else:
    print("一起来搞基")
```

---

# 十一、while 循环

如果想让程序重复执行一段代码，就用循环。

## 11.1 基本语法

```python
while 条件:
    条件成立就反复执行这里的代码
```

例子：从 0 打印到 100

```python
count = 0
while count <= 100:
    print("loop", count)
    count += 1      # 每次 +1，否则会变成死循环

print("循环结束")
```

只打印 1～100 的偶数：

```python
count = 0
while count <= 100:
    if count % 2 == 0:
        print(count)
    count += 1
```

## 11.2 死循环

条件永远为真，循环就会一直跑下去：

```python
while True:
    print("你是风儿我是沙……")
```

服务器程序（比如一直等待用户请求）经常故意写成死循环，但新手写循环时一定要确认条件最终会变成 False。

## 11.3 break 和 continue

- **`break`**：立刻结束整个循环，跳到循环后面的语句。
- **`continue`**：跳过本次循环剩下的代码，直接进入下一次循环。

break 示例：

```python
count = 0
while count <= 100:
    print("loop", count)
    if count == 5:
        break          # 到 5 就彻底退出
    count += 1

print("已跳出循环")
```

输出：`loop 0` 到 `loop 5`，然后打印"已跳出循环"。

continue 示例：

```python
count = 0
while count <= 100:
    count += 1
    if 5 < count < 95:
        continue       # 6～94 直接跳过，不打印
    print("loop", count)
```

输出：1～5，然后直接从 95 打印到 101。

## 11.4 while...else

```python
while 条件:
    循环体
else:
    循环正常结束后执行
```

else 里的代码只在循环**没有被 break 打断、正常结束**时才执行：

```python
count = 0
while count < 3:
    count += 1
else:
    print("循环正常跑完了")
```

---

# 十二、开发工具 PyCharm

写小脚本用记事本也行，但正式开发建议用专业 IDE（集成开发环境）。**PyCharm** 是最流行的 Python IDE（社区版免费）。

它能帮你：

- 代码自动补全；
- 实时提示语法错误；
- 单步调试、打断点，看变量中间值；
- 自动管理 Python 环境，支持 Git 等。

初学者也可以直接用 **VS Code** 配合 Python 插件，更轻量。

---

# 十三、本章练习

1. **猜年龄游戏**：程序里设定一个年龄（如 26），让用户输入猜测，提示"猜大了 / 猜小了 / 猜对了"。
2. **猜年龄升级版**：最多允许猜 3 次，猜对立即结束；3 次都错就退出。
3. **猜年龄 Plus**：猜满 3 次后询问"还想玩吗？"，输入 `y` 再给 3 次机会，输入 `n` 退出。
4. 输入姓名、性别、年龄，按需求打印不同结果（练习分支嵌套）。
5. 打印 1～100 中所有偶数；并思考：第 50 次循环不打印、其余正常打印该怎么写。

---

> 更新: 2026-09-30
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/smde5y>
