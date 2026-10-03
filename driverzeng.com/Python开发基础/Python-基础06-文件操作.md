# Python-基础06-文件操作

## Python-基础06-文件操作

2019-04-28 分类：[Linux](https://www.driverzeng.com/zenglaoshi/category/linux), [Python](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80/python), [脚本语言](https://www.driverzeng.com/zenglaoshi/category/linux/%e8%84%9a%e6%9c%ac%e8%af%ad%e8%a8%80) 阅读(59) 评论(0)

* [文件操作](https://www.driverzeng.com/zenglaoshi/1342.html#toc_0)

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

# 文件操作

| 介绍 |
| :--- |

计算机系统分为：计算机硬件，操作系统，应用程序三部分。

我们用python或其他语言编写的应用程序若想要把数据永久保存下来，必须要保存于硬盘中，这就涉及到应用程序要操作硬件，众所周知，应用程序是无法直接操作硬件的，这就用到了操作系统。操作系统把复杂的硬件操作封装成简单的接口给用户/应用程序使用，其中文件就是操作系统提供给应用程序来操作硬盘虚拟概念，用户或应用程序通过操作文件，可以将自己的数据永久保存下来。

有了文件的概念，我们无需再去考虑操作硬盘的细节，只需要关注操作文件的流程：

```plain
#1. 打开文件，得到文件句柄并赋值给一个变量
#2. 通过句柄对文件进行操作
#3. 关闭文件
```

| python操作文件 |
| :--- |

```plain
#windows
f=open(r'D:\python\a.txt',encoding='UTF-8')
print(f.read())
f.close()
#linux一定要在程序结束前，关闭打开的文件
f=open(r'/Users/driverzeng/PycharmProjects/untitled1/a.txt',encoding='UTF-8')
print(f.read())
f.close()
#上下文管理
with open(r'/Users/driverzeng/PycharmProjects/untitled1/a.txt',encoding='UTF-8') as f:
    print(f.read())
#打开多个文件，并自动close
with open(r'/Users/driverzeng/PycharmProjects/untitled1/a.txt',encoding='UTF-8') as f,\
        open(r'/Users/driverzeng/PycharmProjects/untitled1/b.txt',encoding='UTF-8') as f1:
    print(f.read())
    print(f1.read())
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- 基础.py
- 01与用户交互.py
- a.py x
- a.txt X
- Project
- untitled1 ~/PycharmProjects/untitled1
- 230
- 231
- f=open(r'/Users/driverzeng/PycharmProjects/untitled1/a.txt',encoding='UTF-8')
- 1
- 232
- print(f.read())
- 233
- a.txt
- 234
- 235
- 236
- lliExternal Libraries
- 237
- Scratches and Consoles
- 238
- 239
- 240
- 241
- 242
- 243
- 244
- 245
- 246
- 247
- 248
- 249
- 250
- 251
- 252
- 253
- 254
- 255
- 256
- 257
- 258
- 259
- Run:
- 2变量X
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- 你好
- 哈哈
- Process finished with exit code 0
<!-- OCR_END -->

￼

***

| 对文件的详细操作 |
| :--- |

文件的打开模式：

1.r：只读模式(默认)

2.w：只写模式

3.a：只追加写模式

控制读写文件单位的方式

1.t：文本模式（默认）

优点：操作系统会将硬盘中二进制数字解码成unicode然后返回

强调：只针对文本文件有效

2.b：二进制模式

优点：通用模式，不仅可以操作图片视频，还可以操作文本模式

```plain
with open(r'/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='r',encoding='UTF-8') as f:
    print(f.read())
with open('/Users/driverzeng/PycharmProjects/untitled1/1.png',mode='rb') as f:
    print(f.read())
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rb') as f:
    data=f.read()
    print(data.decode('utf-8'))
```

```plain
#r模式
#1.当文件不存在时会报错
#2.当文件存在时，文件指针指向文件的开头
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    res=f.read()
    print('1====>',res)
    res2=f.read()
    print('2====>',res2)
#判断是否可读
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    print(f.readable())
#判断是否可写
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    print(f.writable())
#readline,读取一行内容
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    print(f.readline())
    
#每一行都读出来
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    for line in f:
        print(line)
#每一行内容放入列表
l=[]
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    for line in f:
        l.append(line)
    print(l)
#自带方法，搞定每一行内容放入列表
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    print(f.readlines())
```

```plain
#w模式
#1.当文件存在时,清空文件内容，文件指针跑到文件的开头
#2.当文件不存在时,新建一个空文档
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='wt',encoding='utf-8') as f:
    pass
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wt',encoding='utf-8') as f:
    pass
#判断可读，可写
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wt',encoding='utf-8') as f:
    print(f.readable())
    print(f.writable())
#写入内容
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wt',encoding='utf-8') as f:
    f.write('哈哈哈')
    f.write('你瞅啥')
    f.write('瞅你咋地')
#换行写入
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wt',encoding='utf-8') as f:
    f.write('哈哈哈\n')
    f.write('你瞅啥\n')
    f.write('瞅你咋地\n')
#如果换成b模式...
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wb',encoding='utf-8') as f:
    f.write('哈哈哈\n')
    f.write('你瞅啥\n')
    f.write('瞅你咋地')
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wb') as f:
    f.write('哈哈哈'.encode('utf-8'))
#换行符，这个概念是跨平台的。最早来自于打印机。
#\r跳到行首，\n换行，简化====》以前存储太贵了。
#老的mac系统，都是\r做换行符，linux系统统一用\n，Windows系统：\r\n
#writelines
info=['zls','oldboy','bgx']
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wt',encoding='utf-8') as f:
    f.writelines(info)
```

```plain
#a模式
#1.当文件不存在时：新建一个空文件，文件指针跑到文件末尾
#2.当文件存在时：文件指针跑到文件末尾
with open('/Users/driverzeng/PycharmProjects/untitled1/c.txt',mode='at',encoding='utf-8') as f:
    pass
    
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='at',encoding='utf-8') as f:
    pass
#判断可读可写
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='at',encoding='utf-8') as f:
    print(f.readable())
    print(f.writable())
#验证写入
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='at',encoding='utf-8') as f:
    f.write('\nzls')
#w与a的区别
#在文件打开不关闭的情况下，连续写入，下一次写入一定是基于上一次写入指针的位置而继续的
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wt',encoding='utf-8') as f:
    f.write('bgx1\n')
    f.write('bgx2\n')
    f.write('bgx3\n')
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='wt',encoding='utf-8') as f:
    f.write('bgx4\n')
    
#a模式每次都是在末尾接着去写，不会覆盖源文件
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='at',encoding='utf-8') as f:
    f.write('bgx4\n')
    f.write('bgx5\n')
    f.write('bgx6\n')
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='at',encoding='utf-8') as f:
    f.write('bgx7\n')
    f.write('bgx8\n')
    f.write('bgx9\n')
```

***

| 可读可写模式 |
| :--- |

在开发过程中，一般都是纯净模式，要么只读，要么只写，要么只追加写，几乎不会用到可读可写模式。

r+：可读可写

w+：可读可写

a+：可读可写

他们的原理都没有变，只不过是在原来基础上，附加一个原来没有的模式。

```plain
#验证是否可写，但是这样往里写数据，不会像你想象那样写入
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='r+t',encoding='utf-8') as f:
    print(f.writable())
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='r+t',encoding='utf-8') as f:
    msg=f.readline()
    print(msg)
    f.write('zls\n')
#验证是否可读，但是如果这么操作...啧啧啧，文件空了
with open('/Users/driverzeng/PycharmProjects/untitled1/b.txt',mode='w+t',encoding='utf-8') as f:
    print(f.readable())
```

***

| 控制文件内指针的移动 |
| :--- |

<!-- OCR_START -->
- untitled1
- a.txt
- Project
- 基础.py
- 01与用户交互.py
- a.py
- 自a.txt
- untitled1 ~/PycharmProjects/untitled1
- 你好‘hello
- venv
- 省b.txt
- c.txt
- lliExternal Libraries
- Scratches and Consoles
- Run:
- 变量x
- a(1）x
- /Users/driverzeng/PycharmProjects/untitled1/vehttbsn//wthow
<!-- OCR_END -->

￼

```plain
#read指定参数
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    msg=f.read(1)
    print(msg)
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础pyX
- 01与用户交互.py
- a.pyx
- a.txtx
- b.txtx
- untitled1~/PycharmProjects/untitled1
- 259
- with open(/Users/driverzeng/PycharmProjects/untitled1/a.txt'mode='rt'encoding='utf-8') as f:
- 260
- msg=f.read（1)
- 261
- print(msg)
- 262
- a.txt
- 263
- b.txt
- 264
- c.txt
- 265
- 266
- 基础.py
- 267
- IliExternal Libraries
- 268
- ScratchesandConsoles
- 269
- 270
- 271
- 272
- 273
- 274
- 275
- 276
- 277
- 278
- 279
- 280
- 281
- 282
- 283
- 284
- 285
- 286
- 287
- 080
- Run:
- 变量×
- a(1）x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python/Users/driverzeng/PycharmProjects/untitled1/venv/a.py
<!-- OCR_END -->

￼

文件内指针移动，只有t模式下的read(n)比较特殊，n代表的是字符的个数，其余，都是以字节为单位。

```plain
#b模式下 如何把 第一个字，读出来？？？？
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rb') as f:
    msg=f.read(1)
    print(msg)
```

<!-- OCR_START -->
- untitled1
- venv
- a.py
- Project
- 基础.py
- 01与用户交互.py
- 自a.txt X
- 自b.txt X
- a.pyX
- untitled1 ~/PycharmProjects/untitled1
- 259
- with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt'mode='rb') as f:
- 260
- msg=f.read(1)
- 261
- print(msg)
- 262
- 自a.txt
- 263
- 自b.txt
- 264
- c.txt
- 265
- 266
- 267
- Illi External Libraries
- 268
- Scratches and Consoles
- 269
- 270
- 271
- 272
- 273
- 274
- 275
- 276
- 277
- 278
- 279
- 280
- 281
- 282
- 283
- 284
- 285
- 286
- 287
- Run:
- 变量x
- 2a(1)x
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
- b'\xe4'
- Process finished with exit code 0
<!-- OCR_END -->

￼

```plain
#f.seek(offset,whence)有两个参数
#offset：代表指针移动的字节数
#whence：参照位置
#       0:参照文件开头（默认）,特殊：在t和b模式都可以使用
#       1:参照当前所在位置，必须在b模式下使用
#       2:参照文件结尾，必须在b模式下使用
#读取‘好’这个字
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    f.seek(3,0)
    print(f.read(1))
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rt',encoding='utf-8') as f:
    f.seek(1)
    print(f.tell())
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rb') as f:
    f.read(3)
    print(f.tell())
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rb') as f:
    f.seek(0,2)
    print(f.tell())
```

***

| 实现tail -f功能 |
| :--- |

```plain
#写日志
import time
t=time.strftime('%Y-%m-%d %H:%M:%S')
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='a') as f:
    f.write('%s oldboy给zls转账了1个亿\n' %t)
    
#读取
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rb') as f:
    f.seek(0, 2)
    while True:
        line=f.readline()
        if len(line) == 0:
            continue
        else:
            print(line.decode('utf-8'),end='')
#改进
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='rb') as f:
    f.seek(0, 2)
    while True:
        line=f.readline()
        if len(line) != 0:
            print(line.decode('utf-8'),end='')
```

***

| 截断文件 |
| :--- |

```plain
with open('/Users/driverzeng/PycharmProjects/untitled1/a.txt',mode='r+t',encoding='utf-8') as f:
    f.truncate(6)
```

***

| 修改文件的两种方式 |
| :--- |

先创建一个文件，d.txt

论颜值zls秒杀一切，论才华更是无人能敌

<!-- OCR_START -->
- untitled1
- venv
- d.txt
- Project
- 基础.py
- 01与用户交互.py
- a.py
- 自d.txt
- a.txtX
- b.txt
- Iuntitled1~/PycharmProjects/untitled1
- 论颜值zls秒杀一切，论才华更是无人能敌
- a.txt
- c.txt
- Ili External Libraries
- oScratchesandConsoles
- Run:
- 变量X
- a(1)
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python /Users/driverzeng/PycharmProjects/untitled1/venv/a.py
<!-- OCR_END -->

￼

需求，在zls后面加上`在老男孩`

```plain
#如果硬盘可以完成修改，执行下面内容，就会发生指针平移
with open('d.txt',mode='r+t',encoding='utf8') as f:
    f.seek(12,0)
    f.write('在老男孩')
with open('d.txt',mode='r+t',encoding='utf8') as f:
    f.seek(12,0)
    f.write('h')
```

<!-- OCR_START -->
- untitled1）
- d.txt
- a（）
- Project
- 田小
- 基础pyX
- 01与用户交互.py×
- a.py
- a.txt
- b.txt
- ects/untitled1
- File was loaded in the wrong encoding:UTF-8
- Reload in another encoding
- venv
- 论颜值zlsh老男孩，论才华更是无人能甜
- c.txt
- 基础.py
- IllExternal Libraries
- Scratches and Consoles
- Run:
- 变量×
- a（1）
- edw.driverzeng.com
<!-- OCR_END -->

￼

为什么平时看到的文件可以修改？

1.将文件内容全部加载到内存

2.在内存中修改

3.修改完之后，从内存保存到硬盘中，重新覆盖

修改以下文件内容：将bgx 都修改为 dsb（大帅比）

bgx is a dsb

dsb is bgx

bgx say bgx is a beautifull boy

**方法一：**

```plain
#先读取文件
with open('d.txt',mode='rt',encoding='utf8') as f:
    all_msg=f.read()
print(all_msg)
#将数据读取并修改
with open('d.txt',mode='rt',encoding='utf8') as f:
    all_msg=f.read()
all_msg=all_msg.replace('bgx','dsb')
print(all_msg)
#写入文件
with open('d.txt',mode='rt',encoding='utf8') as f:
    all_msg=f.read()
all_msg=all_msg.replace('bgx','dsb')
print(all_msg)
with open('d.txt',mode='wt',encoding='utf-8') as f:
    f.write(all_msg)
#简化
with open('d.txt',mode='rt',encoding='utf8') as f:
    all_msg=f.read()
with open('d.txt',mode='wt',encoding='utf-8') as f:
    f.write(all_msg.replace('bgx','dsb')
#错误做法
with open('d.txt',mode='rt',encoding='utf8') as f1, \
        open('d.txt', mode='wt', encoding='utf-8') as f2:
    all_msg=f1.read()
    f2.write(all_msg.replace('bgx', 'dsb'))
```

总结：

优点：在文件修改的过程中，硬盘上始终是一份数据

缺点：首先要将内容全部都读取到内存，如果文件特别大...GG，不适用于大文件

word、notepad++这种文本编辑工具，就是这样工作的，先全部读取，然后再写入

所以，咱们在打开过大的word或者notepad++文件，就会出现卡的状态

**方法二：**

```plain
#1.以读的方式，打开文件读入一行内容到内存，以写的方式打开一个临时文件
#2.从原文件中每读一行内容，修改完毕后，写入临时文件，知道源文件读取完毕
#3.删掉源文件，重命名
import os
with open('d.txt',mode='rt',encoding='utf8') as read_f, \
        open('d.txt.swap',mode='wt',encoding='utf-8') as write_f:
    for line in read_f:
        write_f.write(line.replace('bgx','dsb'))
os.remove('d.txt')
os.rename('d.txt.swap','d.txt')
```

总结：

优点：同一时刻在内存中只存在源文件的一行内容，不会占用太多内存

缺点：在硬盘上，在修改的过程中会有两份数据，会过多的占用硬盘

如果以后在开发过程中，需要开发一个文本编辑器，可以使用第一种方式。

如果以后在开发过程中，（程序）需要修改大文件，或者配置文件等，尽量使用第二种方式。

未经允许不得转载，欢迎技术交流，QQ：133411023：[DBA老司机带你删库到跑路.](https://www.driverzeng.com/) » [Python-基础06-文件操作](https://www.driverzeng.com/zenglaoshi/1342.html)

> 更新: 2019-05-28 15:19:24  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/ftb6r9>