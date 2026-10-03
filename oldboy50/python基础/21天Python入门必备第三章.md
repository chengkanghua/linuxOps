# 21天Python入门必备 · 第三章

> 本章目标：学会读写文件；真正掌握函数（参数、作用域、递归、匿名函数、闭包、装饰器）；理解列表生成式、生成器和迭代器；熟悉常用内置函数。

---

# 一、三元表达式

简单的 if...else 可以压缩成一行：

```python
# 普通写法
if 条件:
    val = 1
else:
    val = 2

# 三元表达式
val = 1 if 条件 else 2
```

例子：

```python
age = 20
status = "成年" if age >= 18 else "未成年"
```

一行搞定简单的二选一，逻辑复杂时还是用完整的 if，别强行压缩。

---

# 二、文件操作

## 2.1 打开文件的基本套路

操作文件分三步：**打开 → 读/写 → 关闭**。

```python
f = open("test.txt", mode="r", encoding="utf-8")
data = f.read()
f.close()
```

- `mode`：打开方式（读 / 写 / 追加，文本 / 二进制）；
- `encoding`：文本编码，处理中文一般用 `"utf-8"`。

更推荐用 `with`，它会在代码块结束后**自动关闭文件**，不用担心忘记 close：

```python
with open("test.txt", mode="r", encoding="utf-8") as f:
    data = f.read()
```

## 2.2 打开模式

| 模式 | 含义 | 文件不存在时 |
| --- | --- | --- |
| `r` | 只读（文本），默认 | 报错 |
| `w` | 只写，**会先清空原内容** | 创建新文件 |
| `a` | 追加，只在末尾写 | 创建新文件 |
| `r+` | 读写，不清空 | 报错 |
| `w+` | 写读，会先清空 | 创建新文件 |
| 加 `b`，如 `rb` / `wb` / `ab` | 二进制模式，读写的是 bytes | — |

二进制模式用于图片、压缩包、可执行文件等非文本内容。用 `rb` 读进来直接是 bytes，不需要指定 encoding。

## 2.3 读取内容

```python
f.read()          # 一次读取全部内容，返回一个字符串
f.readline()      # 只读一行
f.readlines()     # 读全部行，返回列表（每行是一个元素）
```

**推荐的逐行读取方式**——直接循环文件对象，省内存，大文件也不怕：

```python
with open("test.txt", encoding="utf-8") as f:
    for line in f:
        line = line.strip()     # 去掉行尾换行符
        print(line)
```

> 为什么逐行 print 时行间会多出一个空行？因为每行本身带一个 `\n`，而 `print` 还会再加一个换行。用 `strip()` 去掉行尾，或 `print(line, end="")` 即可。

## 2.4 写入内容

```python
with open("test.txt", mode="w", encoding="utf-8") as f:
    f.write("第一行内容\n")
    f.writelines(["第二行\n", "第三行\n"])
```

注意 `w` 模式会**清空原文件**。想保留原内容、在末尾添加要用 `a` 模式：

```python
with open("test.txt", mode="a", encoding="utf-8") as f:
    f.write("\n追加的一行")
```

写入二进制（如 GBK 编码或图片字节）：

```python
with open("test.txt", "wb") as f:
    f.write("路飞学城".encode("gbk"))
```

## 2.5 其他常用方法

| 方法 | 作用 |
| --- | --- |
| `f.seek(0)` | 把读写光标移动到指定位置（**按字节**计算） |
| `f.tell()` | 返回当前光标的字节位置 |
| `f.flush()` | 强制把内存缓冲区的数据刷到硬盘 |
| `f.truncate()` | 从当前位置截断文件 |
| `f.readable()` / `f.writable()` | 判断是否可读 / 可写 |

`seek` 按字节算，多字节编码（GBK 一字 2 字节、UTF-8 一字 3 字节）下，光标如果落在一个汉字中间，读取会报解码错误，使用时要小心。

## 2.6 修改文件

Python 没有直接"原地改一行"的操作，标准做法是：**读旧文件 → 替换内容 → 写一个新文件 → 用新文件替换旧文件**。

```python
import os

old_file = "test.txt"
new_file = "test.txt.new"

with open(old_file, "r", encoding="utf-8") as f, \
     open(new_file, "w", encoding="utf-8") as f_new:
    for line in f:
        if "旧内容" in line:
            line = line.replace("旧内容", "新内容")
        f_new.write(line)

os.replace(new_file, old_file)   # 原子替换
```

---

# 三、函数基础

## 3.1 为什么需要函数

需求：写一个 7×24 小时监控程序，CPU、硬盘、内存超阈值就发邮件报警。

如果不用函数，每加一个监控项就要把"连接邮箱 → 发邮件 → 关闭连接"重写一遍。问题很明显：

- 重复代码太多；
- 哪天要把邮件告警改成微信告警，得在所有地方各改一遍。

解决办法：**把重复代码提取出来，起个名字，谁用谁调用**。这就是函数。

## 3.2 定义和调用

```python
def sayhi():                 # 定义函数
    print("Hello, I'm nobody!")

sayhi()                      # 调用函数
```

函数的三大好处：**减少重复代码、易扩展、易维护**。

## 3.3 参数和返回值

```python
def calc(x, y):              # x、y 是形参
    res = x ** y
    return res               # 把结果返回给调用者

c = calc(5, 8)               # 5、8 是实参
print(c)
```

- **形参**：函数定义里的占位变量，只在函数内部有效，调用结束即释放；
- **实参**：调用时真正传进去的值，可以是常量、变量、表达式；
- **return**：把函数结果返回外部；一旦执行到 return，函数立刻结束。
- 函数里没有 return（或 return 后什么都不写），默认返回 `None`。

return 可以返回多个值（本质是一个元组）：

```python
def get_user():
    return "Alex", 22

name, age = get_user()       # 解包接收
```

---

# 四、函数的参数

参数让函数能根据调用时传入的值做不同的事。

## 4.1 位置参数、关键字参数、默认参数

```python
def stu_register(name, age, course, country="CN"):
    print(name, age, course, country)
```

- **位置参数**：按顺序对应。`stu_register("Alex", 22, "Python")`；
- **关键字参数**：用"参数名=值"传递，可以不按顺序：`stu_register("Alex", course="Py", age=22)`；
- **默认参数**：调用时不传就用默认值。上例不传 country 时就是 `"CN"`。

规则：

1. 默认参数要放在普通位置参数**后面**；
2. 关键字参数也要放在位置参数后面，一旦开始用关键字，后面不能再出现纯位置参数。

```python
stu_register("王山炮", course='PY', age=22, country='JP')   # 正确
stu_register("王山炮", course='PY', 22)                     # 错误
```

## 4.2 不定长参数：*args 和 **kwargs

参数个数不确定时：

```python
def send_alert(msg, *users):          # *users 把多余的位置参数收进一个元组
    for u in users:
        print("报警发送给", u)

send_alert("出事了", "alex", "jack", "rain")
# msg = "出事了"，users = ("alex", "jack", "rain")
```

`**kwargs` 把多余的关键字参数收进一个字典：

```python
def func(name, *args, **kwargs):
    print(name, args, kwargs)

func("Alex", 22, 33, addr="山东", num=123)
# Alex (22, 33) {'addr': '山东', 'num': 123}
```

记忆：`*args` 收位置参数（元组），`**kwargs` 收关键字参数（字典）。两者配合可以让函数接受任意形式的参数。

调用时也能"拆开"传：

```python
func("Alex", *[1, 2], **{"addr": "山东"})
```

---

# 五、局部变量与全局变量

- **全局变量**：定义在函数外面（最外层）的变量，全局都能读；
- **局部变量**：定义在函数内部的变量，只在函数内部生效。

```python
name = "Black Girl"          # 全局变量

def change_name():
    name = "黑色的菇凉"       # 局部变量，和外面的 name 不是同一个
    print("函数内：", name)

change_name()
print("函数外：", name)       # 仍然是 Black Girl
```

当局部和全局同名时，函数**由内向外**查找，优先用局部的。

想在函数内部修改全局变量，需要先用 `global` 声明（**能不用就不用**，会让程序难以追踪）：

```python
def change_name():
    global name
    name = "黑色的菇凉"
```

注意区别：全局的列表、字典，修改**其内部元素**不需要 global（没有改变量本身，只改了内容）：

```python
names = ['Alex', 'Tom']

def change():
    names[0] = "Alexander"   # 直接可以改
    del names[1]
```

---

# 六、嵌套函数与作用域

## 6.1 嵌套函数

函数里面可以再定义函数：

```python
def func1():
    age = 73
    def func2():             # 内部函数
        print(age)           # 可以访问外层的变量
    func2()

func1()
```

## 6.2 作用域与 LEGB 规则

Python 中，**每个函数就是一个作用域**。代码定义完成时，作用域就已经确定，与在哪里调用无关。

查找变量的顺序（由内向外）：

```
L (Local)      函数内部局部
E (Enclosing)  外层嵌套函数
G (Global)     全局
B (Built-in)   内置（len、print 等）
       ┌──────────────────────────┐
   L ─▶│ 找不到就向外层 E 找       │
       └──────────────────────────┘
          E ─▶ G ─▶ B（内置）
```

## 6.3 闭包

内部函数引用了外层函数的变量，并且外层函数把内部函数返回出去，就形成了**闭包**。

```python
def func():
    n = 10
    def func2():
        print("func2", n)     # 用到了外层的 n
    return func2             # 把内部函数返回

f = func()
f()                            # func2 10
```

为什么 `func()` 已经执行完，`f()` 还能访问变量 `n`？因为内部函数还在用，外层作用域就不会被回收。

闭包的意义：**返回的不只是一个函数，还带着它专属的那层作用域**，无论在哪里调用都优先使用这层作用域。

---

# 七、匿名函数与高阶函数

## 7.1 匿名函数 lambda

`lambda` 用来定义**一次性的简单函数**，没有名字：

```python
# 普通函数
def calc(x, y):
    return x * y if x < y else x / y

# 等价的匿名函数
f = lambda x, y: x * y if x < y else x / y
```

语法：`lambda 参数: 返回值表达式`。它常作为参数传给别的函数。

## 7.2 高阶函数

满足以下任一条件就是**高阶函数**：把另一个函数当参数接收，或返回另一个函数。

```python
def add(x, y):
    return x + y

def calc(func, x, y):        # 接收一个函数作为参数
    return func(x, y)

calc(add, 5, 9)              # 14
```

配合 lambda 最常用的三个：

```python
# map：对每个元素做变换
list(map(lambda x: x * x, [1, 2, 3]))       # [1, 4, 9]

# filter：保留满足条件的元素
list(filter(lambda x: x > 2, [1, 2, 3, 4])) # [3, 4]

# sorted：按指定规则排序
sorted([-5, 3, -2], key=abs)                # [-2, 3, -5]
sorted(d.items(), key=lambda x: x[1])       # 按字典的 value 排序
```

## 7.3 递归

函数内部调用自己，就是递归。例：不断把一个数除以 2：

```python
def calc(n):
    n = n // 2
    print(n)
    if n > 0:               # 必须有结束条件
        calc(n)

calc(10)                    # 5 2 1 0
```

递归三原则：

1. **必须有明确的结束条件**，否则永远递归下去；
2. 每次递归，问题规模都要比上一次小；
3. 递归层次过深会**栈溢出**（Python 默认递归深度约 1000，可用 `sys.setrecursionlimit` 调整，但更应该先想算法是否合理）。

递归返回值要注意逐层 return：

```python
def calc(n, count):
    if count < 5:
        return calc(n / 2, count + 1)   # 不加 return，最外层拿不到结果
    else:
        return n
```

能用循环解决的问题，新手优先用循环，递归更适合处理天然分层的数据（如目录树、菜单树）。

---

# 八、装饰器

## 8.1 需求与"开放封闭"原则

视频网站有多个版块，后来要给部分版块加"登录验证"。

最笨的办法是去每个版块函数里加一段验证代码。这违反了**开放封闭原则**：

- **封闭**：已经写好、能正常运行的功能代码，不应该被修改；
- **开放**：功能可以被扩展。

用高阶函数可以不改原函数，但调用处要写成 `login(america)`，**改变了调用方式**，100 个版块就得改 100 处。理想方案是：原函数不动、调用方式也不动，还能加上验证——这就是**装饰器**。

## 8.2 装饰器的本质

利用嵌套函数：写一个外层函数接收原函数，返回一个"包了一层"的新函数。

```python
user_status = False

def login(func):                       # func 是被装饰的原函数
    def inner(*args, **kwargs):
        global user_status
        if not user_status:
            username = input("user: ")
            password = input("password: ")
            if username == "alex" and password == "abc!23":
                user_status = True
            else:
                print("用户名或密码错误")
        if user_status:
            return func(*args, **kwargs)   # 验证通过后才执行原函数
    return inner                          # 返回包装后的新函数
```

使用时在原函数上方加 `@login` 即可，**原函数和调用方式都不用改**：

```python
@login
def america():
    print("----欧美专区----")

@login
def henan(style):
    print("----河南专区----", style)

america()
henan("3p")
```

`@login` 只是下面这句的简写（语法糖）：

```python
america = login(america)
```

执行流程理解：

```
调用 america()
   │
   ▼
inner()：先做登录验证
   │ 验证通过
   ▼
func()：执行真正的 america
```

`inner(*args, **kwargs)` 和 `func(*args, **kwargs)` 是为了让被装饰的函数带任意参数都能正常透传。

> 建议补上 `from functools import wraps` 并在 inner 上加 `@wraps(func)`，保留原函数的名字和文档（进阶习惯，初学知道即可）。

## 8.3 带参数的装饰器

如果装饰器自己还需要参数（比如选择用 QQ 还是微博认证），就再套一层：

```python
def login(auth_type):                # 多一层，接收装饰器参数
    def auth(func):
        def inner(*args, **kwargs):
            if auth_type == "qq":
                return func(*args, **kwargs)
            else:
                print("only support qq")
        return inner
    return auth

@login("qq")                         # 用参数指定认证方式
def america():
    print("欧美专区")

@login("weibo")
def henan(style):
    print("河南专区", style)
```

记忆结构：带参数装饰器是**三层嵌套**——最外层收装饰器参数，中间层收原函数，最内层放真正逻辑。

---

# 九、列表生成式、生成器、迭代器

## 9.1 列表生成式

需求：把列表里每个数加 1。最简洁的写法：

```python
a = [i + 1 for i in range(10)]
# [1, 2, 3, ..., 10]
```

这就是**列表生成式（推导式）**，相当于把 for 循环压缩进方括号。还可以带条件：

```python
[x * x for x in range(10) if x % 2 == 0]   # 只保留偶数再平方
```

字典、集合也有推导式：`{k: v for ...}`、`{x for ...}`。

## 9.2 生成器 generator

列表会一次性占满内存。如果有 100 万个元素、实际只用到前几个，就很浪费。

**生成器**：保存"推算算法"，一边循环一边计算，用到才算。把列表生成式的 `[]` 换成 `()`：

```python
g = (x * x for x in range(10))
print(g)                  # <generator object <genexpr>>
```

用 `next()` 取一个、算一个，取完了会抛 `StopIteration`：

```python
>>> next(g)
0
>>> next(g)
1
```

实际上几乎不手动调 next，直接用 for 循环：

```python
for n in g:
    print(n)
```

## 9.3 yield：用函数写生成器

复杂的推算逻辑用 yield 实现。例：斐波那契数列（1, 1, 2, 3, 5, 8...）：

```python
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b            # 遇到 yield 就"返回并暂停"，下次从这里继续
        a, b = b, a + b
        n += 1

for x in fib(6):
    print(x)               # 1 1 2 3 5 8
```

函数里只要有 `yield`，它就变成生成器。执行流程和普通函数不同：

- 普通函数从头跑到 return；
- 生成器每次 `next()` 执行到 `yield` 就暂停并返回一个值，下次从暂停处继续。

生成器也可以有 return，但它的返回值要通过捕获 `StopIteration` 才能拿到（日常很少需要）。

`yield` 还能实现单线程下的任务切换（协程雏形），用 `.send()` 可以给 yield 传值，了解即可。

## 9.4 迭代器 Iterator

- **可迭代对象 Iterable**：能直接用在 for 循环里的对象，如 list、tuple、dict、set、str，以及生成器；
- **迭代器 Iterator**：不但能 for 循环，还能被 `next()` 不断调用的对象。

```python
from collections.abc import Iterable, Iterator

isinstance([], Iterable)             # True
isinstance([], Iterator)             # False：列表不是迭代器
isinstance((x for x in range(3)), Iterator)  # True：生成器是
```

列表等可用 `iter()` 转成迭代器：

```python
it = iter([1, 2, 3])
next(it)                             # 1
```

为什么 list 不是 Iterator？因为迭代器表示一个**惰性数据流**，不知道总长度，只在 next 时才算下一个，甚至能表示无限数列（如全体自然数），这是列表做不到的。

小结：

- 能 for 循环 → Iterable；
- 能 next() → Iterator，是惰性序列；
- list/dict/str 是 Iterable 但不是 Iterator，用 `iter()` 转换；
- Python 的 for 循环本质上就是在背后不断调 `next()`。

---

# 十、常用内置函数速查

| 函数 | 作用 |
| --- | --- |
| `len(x)` | 长度 / 元素个数 |
| `range(n)` | 生成 0～n-1 序列 |
| `enumerate(x)` | 循环时同时给索引和值 |
| `type(x)` / `isinstance(x, T)` | 查看 / 判断类型 |
| `int / float / str / list / tuple / dict / set` | 类型转换 |
| `min / max / sum` | 最小、最大、求和 |
| `sorted(x, key=, reverse=)` | 排序 |
| `map / filter` | 变换、过滤 |
| `zip(a, b)` | 把多个序列按位置配对 |
| `abs / round` | 绝对值、四舍五入 |
| `bin / oct / hex` | 转二 / 八 / 十六进制 |
| `ord / chr` | 字符 ↔ 编码数字 |
| `bool / all / any` | 真值判断；全为真 / 任一为真 |
| `callable(x)` | 是否可调用 |
| `repr(x)` | 转成"表示形式"字符串 |
| `dir(x) / help(x)` | 查看对象的属性 / 帮助 |
| `eval / exec` | 执行字符串代码（**危险，别用来跑外部输入**） |

几点说明：

```python
>>> list(zip([1, 2], ['a', 'b']))
[(1, 'a'), (2, 'b')]

>>> divmod(10, 3)          # 商和余数
(3, 1)

>>> all([1, True, 0])      # 全部为真才 True（0 是假）
False
>>> any([0, None, 1])      # 任一为真即 True
True
```

`print` 的两个常用参数：`sep`（多个值之间的分隔符）、`end`（结尾字符）：

```python
print("a", "b", sep="->")        # a->b
print("不换行", end="")
```

---

# 十一、本章作业

**作业：员工信息增删改查程序**

员工信息表字段：`staff_id, name, age, phone, dept, enroll_date`。

要求：

1. **模糊查询**，支持类似语法：
   - `find name,age from staff_table where age > 22`
   - `find * from staff_table where dept = "IT"`
   - `find * from staff_table where enroll_date like "2013"`
2. **新增员工**：`add staff Alex Li,25,134435344,IT,2015-10-29`，phone 不允许重复，staff_id 自增；
3. **删除**：`del staff 3`，按 id 删除；
4. **修改**：
   - `UPDATE staff_table SET dept="Market" WHERE dept="IT"`
   - `UPDATE staff_table SET age=25 WHERE name="Alex Li"`
5. 每条语句执行后，显示**影响（查询/新增/修改/删除）了多少条记录**。

提示：员工数据可用文件持久化（每行一条 JSON），命令解析可用字符串切分或正则（第四章学完会更轻松）。

---

> 更新: 2026-09-30
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/ae4neh>
