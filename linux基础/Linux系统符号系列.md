# Linux 系统符号系列（正则与四剑客）

> 本文系统讲解 Linux 中的**特殊符号、正则表达式（BRE/ERE）、通配符**，以及**四剑客 find / grep / sed / awk** 的用法与实战练习。

![符号系列](img/Linux%E7%B3%BB%E7%BB%9F%E7%AC%A6%E5%8F%B7%E7%B3%BB%E5%88%97-01.webp)

---

## 一、写在前面

### 1. 如何证明自己有经验？
1. 说出来
2. 处理过的故障
3. 项目
4. 特长
   1. 画图
   2. 演讲
   3. 三剑客
   4. 排版

### 2. 搜索技巧
```bash
# 1 linux + 关键词（词语）    例如： linux  command not found
# 2 关键词 + zh              例如： awk zh   （搜索结果一般是中文的）
# 3 指定网站搜索：inurl:lidao.blog.51cto.com 关键词
#    例如：快捷键 inurl:lidao.blog.51cto.com   // 在 lidao 博客里搜索"快捷键"
#    site:(cloud.tencent.com) go               // 指定 cloud.tencent.com 搜索 go 相关信息
```

### 3. 通配符 VS 正则
| 类型 | 用途 | 使用者 |
| --- | --- | --- |
| **通配符** | 找出文件名 | 大部分命令可以使用 |
| **正则** | 精确的过滤 | 三剑客使用 |

---

## 二、正则表达式基础

### 1. 基础正则 BRE（Basic Regular Expression）

| 符号 | 含义 | 用法示例 | 匹配结果 |
| --- | --- | --- | --- |
| `.` | 匹配**任意单个字符**（除换行） | `grep "a.c"` | abc、a1c、a&c |
| `*` | 匹配**前一个字符 0 次或多次** | `grep "ab*c"` | ac、abc、abbc |
| `.*` | 匹配**所有** | | |
| `^` | 匹配**行首**（以 xx 开头） | `grep "^hello"` | 以 hello 开头的行 |
| `$` | 匹配**行尾**（以 xx 结尾） | `grep "world$"` | 以 world 结尾的行 |
| `^$` | 匹配**空行** | `grep "^$"` | 没有内容的空行 |
| `[]` | 匹配括号内**任意一个字符**（`[a-z]` `[A-Z]` `[0-9]`，相当于一个符号，每次匹配一个字符） | `grep "[aA]pple"` | apple / Apple |
| `[^]` | 匹配**不在括号内**的字符（排除） | `grep "[^0-9]"` | 非数字字符 |
| `\` | 转义符（取消特殊符号含义） | `grep "\."` | 匹配真正的点号 `.` |

**练习环境**：
```bash
cat > oldboy.txt <<EOF
I am oldboy teacher!
I teach linux.


I like badminton ball ,billiard ball and chinese chess!
my blog is http://oldboy.blog.51cto.com
our size is http://blog.oldboyedu.com
my qq is 49000448


not 4900000448.
my god ,i am not oldbey,but OLDBOY!
EOF
```

**基础正则示例与易错点**：
```bash
# 坑2：[oldboy] 表示 o 或 l 或 d 或 o 或 b 或 y，连续的 oldboy 也会被匹配
grep '[oldboy]' oldboy.txt
grep '[oldboy]' oldboy.txt -o      # 查看匹配过程

# 匹配 m 或 , 或 n
grep '[m,n]' oldboy.txt

# 找出以 m 或 n 开头的行
grep '^[mn]' oldboy.txt

# 找出以 m 或 n 开头、并且以 m 或 n 结尾的行
grep '^[mn].*[mn]$' oldboy.txt

# [^abc] 相当于一个符号（每次匹配 1 个字符），找出除了 a / b / c 的字符
grep '[^abc]' oldboy.txt

# 排除文件中的数字和大小写字母
grep '[^0-Z]' oldboy.txt
```

### 2. 扩展正则 ERE（Extended Regular Expression）

| 符号 | 含义 | 示例 | 匹配结果 |
| --- | --- | --- | --- |
| **基础正则（BRE/ERE 通用）** | | | |
| `.` | 匹配任意单个字符 | `gr.y` | gray、grey、gr2y、gr@y |
| `*` | 前一个字符 0 次或多次 | `go*d` | gd、god、good、goooood |
| `^` | 匹配行首 | `^start` | 以 start 开头的行 |
| `$` | 匹配行尾 | `end$` | 以 end 结尾的行 |
| `[]` | 匹配括号内任意一个字符 | `[Aa]pple` | Apple、apple |
| `[^]` | 匹配不在括号内的字符 | `[^0-9]` | 非数字字符 |
| `\` | 转义符 | `\.` | 匹配真正的点 `.` |
| **ERE 专属（需加 -E 或用 egrep）** | | | |
| `+` | 前一个字符 **1 次或多次** | `go+d` | god、good、goooood |
| `?` | 前一个字符 **0 次或 1 次** | `colou?r` | color、colour |
| `\|` | 或者 | `oldboy\|linux` | 含 oldboy 或 linux |
| `()` | **分组 / 整体** + 后向引用 | `(ab)+` | ab、abab、ababab |
| `{n}` | 精确匹配 **n 次** | `go{2}d` | good |
| `{n,}` | 至少匹配 **n 次** | `go{2,}d` | good、goooood |
| `{n,m}` | 匹配 **n~m 次** | `go{2,3}d` | good、goood |

**扩展正则示例**：
```bash
# + 前一个字符连续出现 1 次或 1 次以上
grep -E '0+' oldboy.txt
grep '0\+' oldboy.txt      # 效果与上面一样

# 取出连续出现的小写字母（egrep 等于 grep -E）
egrep '[a-z]+' oldboy.txt

egrep 'oldboy|linux' oldboy.txt

# 排除文件中的 # 号行或空行
cp /etc/ssh/sshd_config{,.bak}
egrep -v '^$|#' /etc/ssh/sshd_config
```

**坑 3：[] 中 `$` `.` 没有特殊含义**
```bash
echo '+++++\\\\\\!!!!$$$$$$^^^' >> oldboy.txt
echo '####!!!^^^^^$$$$@@@@@####' >> oldboy.txt

# 排除 # 或 $
grep '[^#^$]' oldboy.txt   # 排除了 # ^ $
grep '[^#$]' oldboy.txt
grep '[^$]' oldboy.txt

# 匹配以 . 结尾的行
grep '\.$' oldboy.txt
grep '[.]$' oldboy.txt
```

**坑 4：`[^abc]` 与 `grep -v` 的区别**
```bash
# [^a-z] 按"字符"排除（某个/某些字符）
grep '[^a-z]' oldboy.txt

# grep -v '[a-z]' 按"行"排除（一行里含 a-z 任一字符则不匹配，空行也会显示）
grep -v '[a-z]' oldboy.txt
```

**`()` 分组与后向引用**：
```bash
# oldboy 和 oldbey 都能匹配出来
egrep 'oldb(o|e)y' oldboy.txt

# 后向引用思路：用 () 把想要的内容保护起来，sed 在 's###g' 后两个井号间用 \数字 引用
# -r, --regexp-extended  使用扩展正则
echo 123456|sed -r 's#(.*)#\1#g'          # \1 取前面第一个 () 匹配的内容 → 123456
echo 123456|sed -r 's#(.*)#<\1>#g'        # <123456>
echo 123456|sed -r 's#(34)#<\1>#g'        # 12<34>56
echo 132456|sed -r 's#(..)(..)(..)#\3\2#g'   # 5624
echo 123456|sed -r 's#(..)(..)(..)#\3\2\1#g' # 563412
echo 123456|sed -r 's#(..)(..)(..)#\3<\2>\1#g' # 56<34>12

# 0{3,4} 匹配 0 连续出现 3 到 4 次
egrep '0{3,4}' oldboy.txt
```

### 3. 预定义字符类

```bash
# 正则表达式的预定义字符类
[:alnum:]   字母数字字符。ASCII 中等价于 [A-Za-z0-9]
[:word:]    与 [:alnum:] 相同，但增加了下划线
[:alpha:]   字母字符。ASCII 中等价于 [A-Za-z]
[:blank:]   包含空格和 tab 字符
[:cntrl:]   ASCII 控制码，包含 0 到 31 和 127
[:digit:]   数字 0 到 9
[:graph:]   可视字符，ASCII 中包含 33 到 126
[:lower:]   小写字母
[:punct:]   标点符号字符
[:print:]   可打印字符，等于 [:graph:] 所有字符再加空格
[:space:]   空白字符：空格、tab、回车、换行、vertical tab、form feed（ASCII 中等价于 [ \t\r\n\v\f]）
[:upper:]   大写字母
[:xdigit:]  十六进制数字，ASCII 中等价于 [0-9A-Fa-f]
```

---

## 三、正则实战案例

### 1. 匹配身份证号码
```bash
cat > id.txt <<EOF
金 211324198705244720
万 500224197105168312
任 1231231231old        boy
任 3oldboy
任 lidao97303136098
任 alex2197303136098
任 350182197303oldgir
吕 211282199209113038
孔 150000198309176071
邹 371001197412221284
贺 130185200011215926
杜 362522198711278101
向 14052219961008852X
EOF

egrep '[0-9X]{18}' id.txt
egrep '[0-9]{17}[0-9X]' id.txt
```

### 2. 取出网卡的 IP 地址
```bash
[root@m01 ~]# ip a s eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:d7:d0:86 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.3/24 brd 10.0.0.255 scope global dynamic eth0
       valid_lft 1362sec preferred_lft 1362sec
    inet6 fe80::20c:29ff:fed7:d086/64 scope link
       valid_lft forever preferred_lft forever

ip a s eth0 | awk 'NR==3' | awk -F"[ /]+" '{print $3}'
ip a s eth0 | awk -F'[ /]+' 'NR==3{print $3}'
ip a s eth0 | sed -n 3p |sed 's#^.*t ##g'|sed 's#/.*$##g'
ip a s eth0 | sed -n 3p |sed -r 's#^.*t |/.*$##g'
ip a s eth0 | sed -n 3p |sed -r 's#^.*inet (.*)/.*$#\1#g'

# 第三行 inet 替换成 oldboy
ip a s eth0|sed -n 3p|sed 's#inet#oldboy#g'
ip a s eth0|sed -n '3s#inet#oldboy#gp'
```

**取出 ifconfig eth0 的 IP 和子网掩码**：
```bash
[root@m01 ~]# ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.3  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::20c:29ff:fed7:d086  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:d7:d0:86  txqueuelen 1000  (Ethernet)
        ...

ifconfig eth0|awk 'NR==2' |awk -F"[ :]+" '{print $3,$5}'
ifconfig eth0|awk 'NR==2' |awk -F"inet |netmask" '{print $2}'
ifconfig eth0|sed -n 2p|awk -F '[ ]+' '{print $3,$5}'

# awk 默认分隔符"最聪明"，会吃掉开头空格
ifconfig eth0|awk 'NR==2{print $2}'
# awk 指定分隔符时开头空格会算进去，所以是 $3（$1 是空格）
ifconfig eth0|awk -F'[ ]+' 'NR==2{print $3}'
ifconfig eth0|awk 'NR==2'|awk -F'[: ]+' '{print $3}'
# sed 后向引用：先用 () 保护想要的内容，后面用 \数字 取用
ifconfig eth0|sed -n 2p|sed -r 's#.*inet (.*)  net.*$#\1#g'

# 只通过正则取出 IP（了解）
ip a s eth0 |egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
ip a s eth0 |egrep '([0-9]{1,3}\.){3}[0-9]{1,3}'
ip a s eth0 |egrep '([0-9]{1,3}\.?){4}'
hostname -I
```

### 3. 正则取文件权限
```bash
# 取出 stat /etc/hosts 的文件权限 644 / 0644
[root@m01 ~]# stat /etc/hosts
  File: '/etc/hosts'
  Size: 158             Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 33555401    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
...

stat /etc/hosts | awk -F '[(/]' 'NR==4{print $2}'
stat /etc/hosts | sed -n 4p|sed -r 's#^.* \((.*)/-.*$#\1#g'
stat /etc/hosts | sed -n 4p|sed -r 's#^.*\(([0-9]{4})/.*$#\1#g'
stat /etc/hosts | sed -n 4p|sed -r 's#^.*\(([0-9]+)/.*$#\1#g'
stat /etc/hosts | sed -n 4p |sed -r 's#(^.*\()([0-9]+)(/.*$)#\2#g'
stat -c%a /etc/hosts        # 644
```

### 4. 过滤文件中的空行
```bash
cat > test.txt<<EOF
oldboy

xizi

xiaochao
EOF

# 通过三剑客实现
grep -v '^$' test.txt
sed '/^$/d' test.txt          # d = delete，按行为单位
sed -n '/^$/!p' test.txt      # !p 不显示
awk '!/^$/' test.txt

# 只显示带 o 的（排除空行和 xizi）
egrep -v '^$|xizi' test.txt
sed -r '/^$|xizi/d' test.txt
awk '!/^$|xizi/' test.txt
sed -n '/o/p' test.txt        # -p 显示带 o 的行，-n 取消默认输出
```

### 5. 过滤前两行内容
```bash
cat > ett.txt<<EOF
oldboy
olldboooy
test
EOF

egrep 'oldboy' ett.txt
egrep 'ol+dbo+y' ett.txt
sed -nr '/ol+dbo+y/p' ett.txt
awk '/ol+dbo+y/' ett.txt
grep '[^test]' ett.txt
sed  -n '/test/!p' ett.txt
awk '!/test/' ett.txt
```

---

## 四、四剑客概述（find / grep / sed / awk）

```bash
grep    过滤（显示执行过程、加颜色）
sed     过滤、替换、修改文件内容、取行
awk     过滤、取列（-F）、计算、统计
find    查找文件
```

---

## 五、Shell 核心符号

### 1. 引号系列（最重要）

| 引号 | 名称 | 作用 | 示例 |
| --- | --- | --- | --- |
| `' '` | 单引号 | **所见即所得**，里面内容原封不动输出，不解析变量与命令 | `echo '$LANG $(hostname)'` → `$LANG $(hostname)` |
| `" "` | 双引号 | 里面的**特殊符号会被解析**（变量、命令） | `echo "$LANG $(hostname)"` → `en_US.UTF8 oldboy` |
| `` ` ` `` | 反引号 | **优先执行命令**，等价于 `$( )` | ``echo `date +%F` `` |
| `$( )` | 命令替换 | 先执行括号内命令，再把结果拿来用（推荐写法） | `tar zcf /tmp/etc-$(date +%F).tar.gz /etc` |
| 不加引号 | —— | 支持通配符 `{}`、`*` 等 | —— |

```bash
# 单引号：所见即所得
echo 'oldboy $LANG $PS1 $(hostname) `pwd`'
# oldboy $LANG $PS1 $(hostname) `pwd`

# 双引号：解析变量与命令
echo "oldboy $LANG $PS1 $(hostname) `pwd`"
# oldboy en_US.UTF8 [\u@\h \W]\$ oldboy /oldboy

# 命令替换：反引号 与 $() 等价
ip=`hostname -I|awk '{print $1}'`
ip=$(hostname -I|awk '{print $1}')
```

> **要点**：定义变量、写脚本时，尽量用双引号包裹变量（如 `"$var"`），避免空格导致的问题；纯字符串用单引号。

### 2. 重定向与管道

| 符号 | 作用 |
| --- | --- |
| `>` | 标准输出重定向（覆盖） |
| `>>` | 标准输出追加重定向 |
| `2>` | 错误输出重定向 |
| `2>>` | 错误输出追加重定向 |
| `<` | 标准输入重定向 |
| `<<` | 标准输入追加重定向（Here Document，如 `cat >> f <<EOF ... EOF`） |
| `2>&1` | 把错误输出合并到标准输出 |
| `&>` / `>/dev/null 2>&1` | 丢弃全部输出（`/dev/null` 是黑洞） |
| `\|` | 管道：把前一个命令的结果传给后一个命令 |

```bash
# 覆盖写入
echo "oldboy" > /tmp/test.txt
# 追加写入
echo "oldboy" >> /tmp/test.txt

# 只保留正确输出，丢弃错误
find / -name "*.sh" 2>/dev/null

# 正确+错误都重定向到同一个文件（定时任务必加）
*/2 * * * * /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2>&1
00 01 * * * /bin/sh /server/scripts/bak.sh >>/tmp/bak.log 2>&1

# 输入重定向
tr 'a-z' 'A-Z' < /tmp/test.txt
# Here Document 追加多行
cat >> /tmp/test.txt <<EOF
第一行
第二行
EOF

# 管道：取 IP
ip a s eth0 | awk 'NR==3' | awk -F'[ /]+' '{print $3}'
```

> **定时任务规范**：结尾必须加 `>/dev/null 2>&1` 或 `>>/tmp/xxx.log 2>&1`，否则会产生大量邮件小文件，最终占满 inode。

### 3. Shell 特殊变量（脚本必用）

| 变量 | 含义 |
| --- | --- |
| `$0` | 脚本/命令本身的名称 |
| `$1 $2 … $n` | 第 1、2…n 个参数 |
| `$#` | 参数的**个数** |
| `$?` | **上一条命令的退出状态**，`0` 成功，非 0 失败 |
| `$@` | 所有参数（每个参数独立，推荐） |
| `$*` | 所有参数（合并成一个整体） |
| `$$` | 当前脚本的 PID |
| `$!` | 上一个后台进程的 PID |
| `$PS1` | 命令提示符格式 |

```bash
cat > /tmp/arg.sh <<'EOF'
#!/bin/bash
echo "脚本名: $0"
echo "第1个参数: $1"
echo "第2个参数: $2"
echo "参数个数: $#"
echo "所有参数: $@"
EOF
sh /tmp/arg.sh oldboy lidao
# 脚本名: /tmp/arg.sh
# 第1个参数: oldboy
# 第2个参数: lidao
# 参数个数: 2
# 所有参数: oldboy lidao

# $? 判断上一条命令是否成功
ls /oldboy
echo $?          # 0 成功；非 0 失败
ls /notexist 2>/dev/null
echo $?          # 非 0

# 结合 if 判断参数个数
if [ $# -ne 2 ];then
    echo "参数个数必须是 2 个"
    exit
fi
```

### 4. 通配符（用于找文件名，区别于正则）

| 符号 | 含义 |
| --- | --- |
| `*` | 匹配任意多个字符 |
| `?` | 匹配**任意单个**字符 |
| `[]` | 匹配括号内任意一个字符，如 `[abc]` |
| `[!]` / `[^]` | 匹配**不在**括号内的字符（排除） |
| `{}` | 生成序列 / 组合 |

```bash
ls *.txt                       # 所有 .txt 文件
ls ?.txt                       # 单个字符开头的 .txt，如 a.txt
ls [abc].txt                   # a.txt / b.txt / c.txt
ls [!a].txt                    # 除 a.txt 以外的单字符名 .txt
find / -type f -name "*.conf"
find / -type f -name "*ifconfig*"

# {} 生成序列
echo stu{01..10}
echo {1,5,100}
echo stu{001..5}
echo stu{01..10..2}            # 步长 2
echo A{B,C}
echo oldboy.txt{,.bak}
cp a.txt{,.bak}                # 等价于 cp a.txt a.txt.bak
```

> **注意**：通配符用于**找文件名**（`ls`/`find`），正则用于**过滤内容**（三剑客）。`[!]` 是通配符的排除写法，正则里排除用 `[^]`。

### 5. 逻辑与控制符号

```bash
# &&  前面命令成功（$?=0）才执行后面的命令
ifdown eth0 && ifup eth0        # 重启网卡

# ||  前面命令失败（$?≠0）才执行后面的命令
ls /tmp/ccc || echo 目录不存在

# ;   在同一行分割多个命令（不管成败都执行）
echo a; echo b; echo c

# &   放到后台运行
sleep 100 &
# $$  当前脚本 PID；$! 上一个后台进程 PID

# #   注释；也是 root 用户的命令提示符
# $   普通用户命令提示符
echo $PS1 $PATH $LANG           # 环境变量
# awk 中取列：$0 一整行，$NF 最后一列

# !命令  执行最近一次以该字符串开头的命令（如 !ls）
history | grep awk
# !!     运行上一次命令
# find / awk 中 ! 表示取反；vim 中表示强制
```

---

## 六、find 使用

### 1. 基本查找与执行
```bash
find /oldboy/ -type f -name "*.sh"
find /oldboy/ -type f -name "*.sh" | xargs ls -l

# $() / `` 反引号：先运行括号里的命令，再执行其他命令
ll $(find /root/ -type f -name "*.sh")
ll `find /root/ -type f -name "*.sh"`

# -exec：把前面命令的结果放到 {}，交给后面的命令处理
find /root/ -type f -name "*.sh" -exec ls -l {} \;
# 备注：-exec 接收前面结果放到 {} 交给 ls -l 处理；-exec/xargs 不识别 ll 之类的别名
```

### 2. 管道 `|` 与 `| xargs` 的区别
```bash
# | 管道：把前一个命令的结果传递给后面命令，传递的是"文字/文本"
# | xargs：把前一个命令的结果传递给后面命令，传递的是"文件名"

# 下面会报错，因为 sed 收到的是文本而不是文件名
find /oldboy/ -type f -name "*.sh" |sed -i 's#old#you#g'
# sed: no input files

# 用 xargs 才有结果
find /oldboy/ -type f -name "*.sh" |xargs sed -i 's#old#you#g'

# sed -i 修改文件内容时后面必须跟文件名，否则报 no input file
find /root/ -type f -name "*.sh" |sed -i 's#oldboy#oldgirl#g'     # 只有一个管道，只传文本
find /root/ -type f -name "*.sh" |xargs sed -i 's#oldboy#oldgirl#g'
```

**grep 从管道取文本 vs 从文件取内容**：
```bash
find /data/ -type f -name "*.txt" |grep ".txt"
find /data/ -type f -name "*.txt" |grep -o ".txt"
# 上面表示 grep 从管道中获取"文本"，在这些文本里查找 .（此处表示任意一个字符）txt

find /data/ -type f -name "*.txt" |xargs grep ".txt"
# 上面表示 grep 从 find 找到的"文件名"中查找想要的内容
```

### 3. 批量替换案例
```bash
# 把 /oldboy 目录及其子目录下所有 .sh 结尾文件中，包含 oldboy 的字符串全部替换为 oldgirl
mkdir -p /oldboy/test
cd /oldboy
echo "oldboy" > test/del.sh
echo "oldboy" > test.sh
echo "oldboy" > t.sh
touch oldboy.txt
touch alex.txt

find /oldboy/ -type f -name "*.sh" |xargs sed 's#oldboy#oldgirl#g'
find /oldboy/ -type f -name "*.sh" |xargs sed -i 's#oldboy#oldgirl#g'
find /oldboy/ -type f -name "*.sh" |xargs cat
```

### 4. 文件名含特殊符号（空格）的处理
```bash
# 环境准备
touch "oldboy_ "{01..04}.jgp
find ./ -type f -name "*.jgp" |xargs ls -l    # 文件名含空格会报错

# -print0 指定结束标记，-0 接收结束标记
find ./ -type f -name "*.jgp" -print0 |xargs -0 ls -l
# -rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  01.jgp
# -rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  02.jgp
# -rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  03.jgp
# -rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  04.jgp
```

### find 常用条件全集（补充）

| 条件 / 动作 | 作用 | 示例 |
| --- | --- | --- |
| `-name` | 按名称查找（区分大小写） | `find / -name "*.conf"` |
| `-iname` | 按名称查找（不区分大小写） | `find / -iname "*.CONF"` |
| `-type` | 按类型：`f` 文件、`d` 目录、`l` 软链接 | `find /tmp -type f` |
| `-mtime` | 按**修改时间**（天）：`+7` 7天前、`-7` 7天内、`7` 第7天 | `find /tmp -mtime +7` |
| `-atime` / `-ctime` | 按访问时间 / 属性变更时间 | `find / -atime -1` |
| `-size` | 按大小：`+100k` `-10k` `+1M` `+1G` | `find / -size +100M` |
| `-perm` | 按权限 | `find / -perm 644`；`find / -perm -4000`（含 suid） |
| `-user` / `-group` | 按属主 / 属组 | `find / -user oldboy` |
| `-maxdepth` / `-mindepth` | 限制查找深度 | `find / -maxdepth 2 -name "*.sh"` |
| `-newer` | 比某个文件更新的 | `find / -newer /tmp/a.txt` |
| `!` / `-a` / `-o` | 取反 / 与(and) / 或(or) | `find / ! -name "*.txt"` |
| `-delete` | 直接删除找到的文件 | `find /tmp -type f -mtime +7 -delete` |
| `-print` / `-print0` | 输出（`print0` 用 `\0` 分隔，处理含空格文件名） | `find . -name "*.jpg" -print0` |
| `-ok` | 与 `-exec` 相同，但执行前**逐一确认** | `find . -name "*.sh" -ok rm {} \;` |

```bash
# 综合示例：删除 /tmp 下 7 天前的 .log 文件（删除前务必先打印确认）
find /tmp -type f -name "*.log" -mtime +7 -print
find /tmp -type f -name "*.log" -mtime +7 -delete

# 查找大于 100M 的文件
find / -type f -size +100M 2>/dev/null

# 按深度查找，避免全盘扫描
find /etc -maxdepth 1 -type f

# 组合条件：属主是 oldboy 且大于 10k 的普通文件
find /home -type f -user oldboy -size +10k

# 查找含 suid 的文件（安全排查）
find / -type f -perm -4000 2>/dev/null
```

### xargs 详解（补充）

**作用**：把管道传来的"文本"转换成后面命令的**参数**（文件名）。

| 选项 | 作用 |
| --- | --- |
| `-n N` | 每 N 个参数执行一次命令 |
| `-I{}` | 用 `{}` 作占位符，可**多次引用**该参数（批量改名/复制必备） |
| `-0` | 接收以 `\0` 结尾的参数（配合 `find -print0`，处理含空格文件名） |
| `-p` | 交互式，执行前逐一询问确认 |
| `-t` | 先打印要执行的命令，再执行（调试用） |

```bash
# -n 分组：每 3 个文件执行一次 echo
find . -name "*.txt" | xargs -n3 echo

# -I{} 占位符：批量重命名（引用同一个文件名两次）
find . -name "*.jpg" | xargs -I{} mv {} {}.bak
# 等价于： mv a.jpg a.jpg.bak

# 批量复制并保持原名
ls *.conf | xargs -I{} cp {} /backup/{}

# -0 处理含空格的文件名
find . -name "*.jgp" -print0 | xargs -0 ls -l

# -t 调试：先显示命令再执行
find . -name "*.sh" | xargs -t chmod +x

# -p 确认后再删除
find . -name "*.tmp" | xargs -p rm -f
```

> **管道 `|` vs `| xargs` 回顾**：
> - `|` 传递的是**文本/字符串**，命令需从标准输入读（如 `grep`、`awk`、`sed` 默认）
> - `| xargs` 传递的是**参数（文件名）**，适用于 `ls -l`、`rm`、`cp`、`mv` 这类"需要文件名作参数"的命令

---

## 七、grep 过滤（含常用选项）

**准备环境**：
```bash
cat > oldboy.txt <<EOF
I am oldboy teacher!
I teach linux.


I like badminton ball ,billiard ball and chinese chess!
my blog is http://oldboy.blog.51cto.com 
our size is http://blog.oldboyedu.com 
my qq is 49000448


not 4900000448.
my god ,i am not oldbey,but OLDBOY!
EOF
```

**基础正则速查**：
```bash
^   以什么开头
$   以什么结尾
^$  空行（什么符号都没有）
.   任意一个字符（不会匹配空行）
\   转义字符
*   前一个字符连续出现 0 次或 0 次以上
.*  任意字符任意次数（表示所有）
^.*o  贪婪性（按最大范围匹配）
[]  将匹配一个字符范围，如 [abc] 相当于一个符号，每次匹配一个字符（a 或 b 或 c）
```

**grep 常用示例**：
```bash
# 含有 oldboy 字符的行
grep oldboy oldboy.txt

# 以 m 开头的行
grep '^m' oldboy.txt

# 以 m 结尾的行（m 后面有空格则不会显示）
grep 'm$' oldboy.txt

# 显示文件中所有符号（cat -A 每行结尾会显示 $）
cat -A oldboy.txt

# 以空格结尾的行
grep ' $' oldboy.txt

# ^$ 空行，并显示行号
cat -An oldboy.txt
grep -n '^$' oldboy.txt

# 排除空行
grep -v '^$' oldboy.txt

# . 任意一个字符（不会匹配空行）
grep '.' oldboy.txt

# -o, --only-matching：只显示匹配到的部分（匹配一个换一行，没匹配的不显示）
grep -o '.' oldboy.txt
grep -o '[abc]' oldboy.txt

# 以 . 结尾的行（\ 转义）
grep -e "\.$" oldboy.txt

# 把所有回车换行符替换成 tab
tr "\n" "\t" < oldboy.txt

# 坑1：0* 会把文件内容都显示出来（0 次=没有，也匹配）
grep '0*' oldboy.txt

# .* 任意字符任意次数（表示所有）
grep '.*' oldboy.txt

# ^.*o 贪婪性：按最大范围匹配
grep '^.*o' oldboy.txt
# 说明：my blo 本也符合，但实际按最大范围匹配 → my blog is http://oldboy.blog.51cto.com

grep '^o' oldboy.txt
# our size is http://blog.oldboyedu.com

# 字符类：每次匹配一个字符
grep '[abc]' oldboy.txt        # 找出 a 或 b 或 c
grep '[a-z]' oldboy.txt        # 所有小写字母
grep '[A-Z]' oldboy.txt        # 所有大写字母
grep '[0-9]' oldboy.txt
grep '[a-zA-Z]' oldboy.txt
grep '[a-Z]' oldboy.txt

# -i 不区分大小写
grep -i '[a-z]' oldboy.txt
```

### grep 常用选项全集（补充）

| 选项 | 作用 | 示例 |
| --- | --- | --- |
| `-v` | 反向选择（排除匹配的行） | `grep -v 'oldboy' file` |
| `-n` | 显示行号 | `grep -n 'root' /etc/passwd` |
| `-i` | 忽略大小写 | `grep -i 'root' file` |
| `-o` | 只显示匹配到的部分 | `grep -o '[0-9]\+' file` |
| `-c` | 只统计匹配的行数 | `grep -c 'error' file` |
| `-l` | 只显示**包含匹配内容的文件名** | `grep -l 'oldboy' *.txt` |
| `-L` | 只显示**不包含**匹配内容的文件名 | `grep -L 'oldboy' *.txt` |
| `-r` / `-R` | 递归搜索目录下所有文件 | `grep -r 'oldboy' /etc/` |
| `-w` | 按**整词**匹配 | `grep -w 'old' file`（不匹配 oldboy） |
| `-A n` | 显示匹配行及其**后 n 行**（After） | `grep -A2 'error' file` |
| `-B n` | 显示匹配行及其**前 n 行**（Before） | `grep -B2 'error' file` |
| `-C n` | 显示匹配行**前后各 n 行**（Context） | `grep -C2 'error' file` |
| `-q` | 静默模式（不输出，用 `$?` 判断结果） | `grep -q 'oldboy' file && echo 存在` |
| `-m n` | 最多匹配 n 行后停止（大文件提速） | `grep -m1 'error' file` |
| `-E` | 使用扩展正则（等价 `egrep`） | `grep -E 'a\|b' file` |
| `-P` | 使用 Perl 正则（支持 `\d` `\w` 等） | `grep -P '\d+' file` |
| `-f file` | 从文件读取多个匹配模式 | `grep -f pattern.txt file` |
| `--color` | 高亮显示匹配内容 | `grep --color 'oldboy' file` |

```bash
# 递归搜索并只列出文件名
grep -rl 'oldboy' /server/scripts/

# 静默判断（常用于脚本）
grep -q 'oldboy' /tmp/test.txt && echo "存在" || echo "不存在"

# 带上下文查看日志
grep -C3 'Failed password' /var/log/secure

# 整词匹配（避免 oldboy 被 old 匹配到）
grep -w 'old' oldboy.txt
```

### 正则贪婪性详解与解法（扩展）

**问题**：`.*`、`+` 等默认是**贪婪**的，会尽可能多地匹配。
```bash
grep '^.*o' oldboy.txt
# my blog is http://oldboy.blog.51cto.com
```
说明：`my blo` 本也符合，但实际按**最大范围**匹配到了最后一个 `o`。

**解法 1：用"排除字符类"限制范围**（最常用、兼容性最好）
```bash
# 只匹配到第一个 o（中间不能有 o）
grep '^[^o]*o' oldboy.txt

# 取 IP：用排除法避免贪婪
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' file

# 取 HTML 标签内容（排除 > ）
grep -o '<title>[^<]*</title>' index.html
```

**解法 2：GNU grep -P 的"非贪婪"量词**
```bash
# .*?  表示尽可能少地匹配（需 -P）
grep -oP '^.*?o' oldboy.txt
grep -oP '<title>.*?</title>' index.html
```

**解法 3：awk/sed 中精确控制**
```bash
# sed 后向引用精确取中间内容
echo '<title>oldboy</title>' | sed -r 's#.*<title>(.*)</title>.*#\1#g'
# oldboy
```

> **要点**：写正则时优先用"排除字符类 `[^x]*`"来界定边界，比依赖贪婪/非贪婪更可控、跨工具兼容。

---

## 八、sed 流编辑器

### 1. 备份与修改
```bash
# 先备份为 t.sh.bak，再修改文件内容
sed -i.bak 's#girl#boy#g' t.sh
```

### 2. 增加内容（c / a / i）
```bash
# c  replace 替换
# a  append  追加（下方）
# i  insert  插入（上方）

cat > person.txt <<EOF
101,oldboy,CEO
102,zhangyao,CTO
103,Alex,COO
104,yy,CFO
105,feixue,CIO
110,lidao,COCO
EOF

# 文件尾部追加
echo "12306,xiao,UF0" >> person.txt
cat >> person.txt <<EOF
12306,xiao,UFO
EOF

# 第三行后面加内容
sed '3a12306,xiao,ufo' person.txt
# 每一行后增加一行（a 前面不加数字）
sed 'a123' person.txt
# 替换第三行内容
sed '3c12306.xiao.ufo' person.txt
# 在文件最后一行增加
sed '$a12306,xiao,UFO \n12580,tao,XO' person.txt
```

**修改配置文件的常用方式**：
```bash
echo >>
cat >> oldboy.txt <<EOF
....
EOF

# 追加文件最后位置
sudo   === /etc/sudoers
cron   === /var/spool/cron/
挂载   === /etc/fstab
解析主机名 === /etc/hosts
网卡配置文件 === /etc/sysconfig/network-scripts/ifcfg-eth0
```

### 3. 删除（d）
```bash
sed '2,5d' person.txt        # 删除第 2 到 5 行
sed '/yy/,$d' person.txt     # 从 yy 删除到最后一行
sed '/lidao/!d' person.txt   # 删除不包含 lidao 的行
sed '$d' person.txt          # 删除最后一行
```

### 4. 替换（s###g）
```bash
# 格式：'s###g'
# s  substitute（替换）
# g  global（全局）；不写 g 则只替换每行第一个

sed 's#[0-9]##g' person.txt   # 0-9 数字替换为空
sed 's#[0-9]##' person.txt    # 没 g，只替换每行第一个

# 替换每行第 2 个匹配的内容
sed 's#[0-9]##2' person.txt
# 替换每行第 2 个匹配到最后
sed 's#[0-9]##2g' person.txt
```

### 5. 企业案例：不显示文件空行
```bash
grep -v '^$'     lidao.txt   # 前面有空格不算空行；cat -A 每行结束显示 $
sed '/^$/d'      lidao.txt
awk '!/^$/'      lidao.txt
sed -n '/^$/!p'  lidao.txt
awk NF           lidao.txt   # 带空格的空行也能过滤
```

**文件中"只包含空格的行"处理**：
```bash
echo -e 'oldboy\n\n     oldboy     \n     \nlidao   \n   lidao' > lidao.txt

egrep -v '^$|^ +$' lidao.txt   # 排除空行和空格行（+ 表示连续）
egrep '[^ $]+' lidao.txt       # 排除空格、$ 符号
egrep -v '^$|^ *$' lidao.txt   # 排除空行、空格或连续空格
sed -n '/^ *$/!p' lidao.txt    # 不显示空格开头或空行

# * 前一个字符 0 次或 0 次以上（不限次数）
# + 前一个字符至少 1 次或 1 次以上
```

### 6. sed 中使用变量（需双引号）
```bash
x=oldboy; y=oldgirl; sed "s#$x#$y#g" person.txt
```

### 7. 后向引用取 IP 地址
```bash
ifconfig eth0|sed -nr '2s#^.*r:(.*)  Bc.*$#\1#gp'    # CentOS 6
ifconfig eth0|sed -nr '2s#^.*t (.*)  n.*$#\1#gp'     # CentOS 7
ifconfig eth0|awk -F'addr:|  Bc' 'NR==2{print $2}'   # CentOS 6
ifconfig eth0|awk -F"[ :]+" 'NR==2{print $3}'
ifconfig eth0|awk -F'[^0-9.]+' 'NR==2{print $2}'
```

### 8. sed 正则速查与"增删查改"
```bash
# 正则符号
^    以...开始
$    以...结尾
^$   空行
.*   任意字符任意次数
.    一个字符
*    0 次或 0 次以上
[]   每次匹配单个字符，如 [abc] 表示 a 或 b 或 c
+    1 次或 1 次以上
()   表示一个整体
|    或
{}   {n,m} 前一个字符 n 到 m 次
?    0 次或 1 次

# sed 增删查改格式：找谁干啥
#   查找：行号、行号范围、//、//,//
#        grep -A、找出有规律的行（1~2 表示 1 3 5 7 9）
#   删除：d
#   增加：c a i
#   替换：s  's###g'
```

### 9. sed 练习

**① 把 person.txt 每一行替换为对应的行号**：
```bash
#!/bin/bash
for n in {1..7}
do
     sed -i.bak "${n}s#.*#$n#g" person.txt
done
```

**② 批量重命名：删除文件名中的 html**
```bash
# 环境准备
touch oldboy_html{01..10}.jgp

# 方法1：sed 拼接
# mv oldboy_html_01.jpg  oldboy_01.jpg
ls *.jgp|sed -r 's#(.*)html(.*)#mv & \1\2#g'|bash

# 方法2：for 循环
cat > oldboyhtml.sh <<EOF
#!/bin/bash
for name in \`ls /server/scripts/name/\`
do
    mv \$name \`echo \$name|sed 's#html##g'\`
done
EOF

# 方法3：rename
# rename 找谁 替换成什么 替换哪些文件
rename html '' *.jgp

# 方法4：rename 指定文件
rename "html" "" oldboy_*
ls ./ | sed -rn 's#((.*_).*_(.*))#mv \1 \2\3#gp' |bash
ls ./|awk -F "_" '{print "mv "$0,$1"_"$3}' |bash
for NAME in \`ls ./\`; do mv $NAME \`echo $NAME | sed -n "s#html_##gp"\`; done
```

**③ rename 命令格式**：
```bash
rename  找谁  替换成什么  替换哪些文件
#                        *.log  *.jpg
touch a_html.jpg; touch b_html.jpg;
rename html '' *.jpg
```

---

## 九、awk（模式匹配与处理语言）

### 1. 格式与选项
```bash
# gnu awk = gawk
# -F 指定分隔符
# -v 定义变量

awk -F: 'NR==1{print $1,$3}' /etc/passwd
#      '条件{动作}'
#      pattern{命令}
#      模式
```

### 2. 内置变量
```bash
# NR  行号（number of record）
# NF  每行有多少列（number of filed），$NF 即最后一列
# FS  输入字段（列）分隔符，-F: 等价于 -vFS=:
# $1 $2  第 1 列、第 2 列
# $0     一整行内容
# OFS    输出分隔符（显示每一列时，列之间用什么分开）
# RS     每一行之间如何分割（记录分隔符，默认回车 \n）
# IGNORECASE  是否忽略大小写（1 为忽略）

awk '{print $1,$2}'
```

**内置变量速查**：
```bash
FS(-F:)    输入字段（列）分隔符 —— "菜刀"
NR         行号（记录号）
NF         列数，默认最后一列
OFS        输出分隔符
RS         每一行的结束标记（默认是回车）
IGNORECASE 是否忽略大小写，1 为忽略
```

**调换 /etc/passwd 第 1 列和最后一列**：
```bash
awk -F: -vOFS=: '{print $NF,$2,$3,$4,$5,$6,$1}' passwd.txt
awk -F: -vOFS=: '{tmp=$1;$1=$NF;$NF=tmp;print $0}' passwd.txt
```

**修改行分隔符 RS**：
```bash
cat > rs.txt <<EOF
1  oldboy.lidao 
2  oldboy.lidao 
3  oldboy.lidao 
4  oldboy.lidao 
5  oldboy.lidao 
EOF

# 更改换行符（以 . 作为行的结束标记）
awk -vRS=. '{print $0}' rs.txt

# 以 / 作为换行符，显示行号和文件内容
head /etc/passwd > passwd.txt
awk -vRS=/ '{print NR,$0}' passwd.txt
```

### 3. awk 模式（条件）
```bash
# 模式 pattern = 条件，帮助你找到想要的行
# 正则符号
~    某一列中包含 xxx
!~   某一列中不包含
^    以..开头
$    以..结尾
.*   任意字符任意次数
^$   空行
\    脱掉马甲，打回原形（转义字符）
[]   [abc] 每次匹配单个字符（a 或 b 或 c）
[^abc] 排除 a 或 b 或 c
+    1 次或 1 次以上
|    或
()   表示一个整体
*    0 次或 0 次以上
{}   {n,m}
?    0 次或 1 次
```

**示例（测试数据 reg.txt）**：
```bash
mkdir -p /server/files/
cat >>/server/files/reg.txt <<EOF
Zhang Dandan    41117397   :250:100:175
Zhang Xiaoyu    390320151  :155:90:201
Meng  Feixue    80042789   :250:60:50
Wu    Waiwai    70271111   :250:80:75
Liu   Bingbing  41117483   :250:100:175
Wang  Xiaoai    3515064655 :50:95:135
Zi    Gege      1986787350 :250:168:200
Li    Youjiu    918391635  :175:75:300
Lao   Nanhai    918391635  :250:100:175
EOF
# 格式：姓  名  id  最后三列为三次捐款数量

head /etc/passwd > passwd.txt

# : 分割，第三列中包含数字 4（~ 表示包含）
awk -F: '$3~/4/' passwd.txt

# 1. 第三列中以数字 4 开头的
awk '$3~/^4/' reg.txt

# 2. 显示 xiaoyu 的姓氏和 ID 号码
awk '$2~/Xiaoyu/{print $1,$2,$3}' reg.txt

# 3. 显示所有以 41 开头的 ID 号码的人的全名和 ID
awk '$3~/^41/{print $1,$2,$3}' reg.txt
awk '$3~/^41/' reg.txt

# awk 默认动作
# '$3~/^41/' === '$3~/^41/{print $0}'
# '/oldboy/' === '$0~/oldboy/'
# '!/oldboy/' === '$0!~/oldboy/'

# 5. 显示所有 ID 号码最后一位是 1 或 5 的人的全名
awk '$3~/[15]$/{print $1,$2}' reg.txt

# 6. 显示 Xiaoyu 的捐款，每个值以 $ 开头，如 $520$200$135
awk -F'[ :]+' 'NR==2{print "\$"$4"\$"$5"\$"$6}' reg.txt
# awk: warning: escape sequence `\$' treated as plain `$'
# $155$90$201

# gsub：awk 内置函数（动作）
# gsub(/找谁/, "替换成什么", 某一列) === gsub(/找谁/, "替换成什么", $0)
awk 'NR==2{print $NF}' reg.txt |sed 's#:#$#g'
awk 'NR==2{gsub(/:/,"$",$4); print $NF}' reg.txt
awk '$2~/Xiaoyu/{gsub(":","$",$NF);print $NF}' reg.txt

# 7. 显示所有人的全名，以"姓,名"格式，如 Meng,Feixue
awk '{print $1","$2}' reg.txt
awk -vOFS=',' '{print $1,$2}' reg.txt    # -vOFS=',' 输出分隔符
```

### 4. 比较表达式
```bash
$5>500
NR>20
>  >=  ==  !=  <=  <
# 运算 %
```

### 5. 实战：磁盘使用率大于 20%
```bash
# $5>20 默认对比的是"字符/字符串"（字母），会出错
df -h |awk '$5>20{print $1,$NF}'

# 方法0：行号大于 1 去掉表头，第 5 列百分比数字大于 9
df -h |awk -F'[ %]+' 'NR>1 && $5+0>9'

# 解决方法一：指定分隔符只保留数字部分
df -h |awk -F'[ %]+' '$5>9{print $1,$NF}'

# 解决方法二：某一列 +0（转为数字）
df -h|awk '$5+0>9'

# 计算磁盘使用率
df |awk 'NR>1{print $3/$2}'
```

### 6. 计算内存使用率
```bash
free -m | awk 'NR==2 {printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2}'
free -m|awk '/Mem/{print $3/$2*100"%"}'

# 计算内存剩余率
free -m|awk '/Mem/{print 100-$3/$2*100"%"}'

free|awk 'NR==2{sum=$3+$4;print $3/sum*100,$4/sum*100}'   # 内存使用率和剩余率
free|awk 'NR==2{sum=$3+$4;print sum}'                      # 内存总容量
```

### 7. 范围模式
```bash
# 第 1 行到第 5 行
sed -n '1,5p'
awk 'NR==1,NR==5'

# 显示文件中从 oldboy 行到 yy 行
sed -n '/oldboy/,/yy/p' person.txt
awk '/oldboy/,/yy/' person.txt
```

### 8. 特殊模式 BEGIN{} 与 END{}

**awk 执行过程**：
1. 执行命令的参数（赋值）：`-F`、`-v`
2. `BEGIN{}` 里面的内容（awk 还没开始读取文件）
3. 读取文件内容：读一行 → 判断是否满足模式 → 符合则执行动作，不符合则读下一行
4. 文件内容读完后，执行 `END{}` 里面的内容

```bash
# BEGIN{} 在 awk 读取文件之前执行：
#   1. 显示标题
#   2. 修改 awk 内置变量、创建变量（awk 'BEGIN{OFS=:}' / awk -vOFS=:）
#   3. 测试、计算

# END{} 在 awk 读取完文件之后执行：显示计算结果（先计算，END 显示结果）

# i=i+1 === i++  统计次数

# 统计 /etc/passwd 中 nologin 用户数量
awk '/nologin$/{i++}END{print i}' passwd.txt          # 最后输出结果
awk '/nologin$/{i++;print i}' passwd.txt              # 显示执行过程

# 统计 /etc/services 中空行的数量
awk '/^$/{i++}END{print i}' /etc/services

# seq 100 通过 awk 计算 1+...+100
seq 100| awk '{sum+=$1}END{print sum}'
```

![awk执行过程](img/Linux%E7%B3%BB%E7%BB%9F%E7%AC%A6%E5%8F%B7%E7%B3%BB%E5%88%97-02.png)

```bash
cat > reg.txt <<EOF
Zhang Dandan    41117397   :250:100:175
Zhang Xiaoyu    390320151  :155:90:201
Meng  Feixue    80042789   :250:60:50
Wu    Waiwai    70271111   :250:80:75
Liu   Bingbing  41117483   :250:100:175
Wang  Xiaoai    3515064655 :50:95:135
Zi    Gege      1986787350 :250:168:200
Li    Youjiu    918391635  :175:75:300
Lao   Nanhai    918391635  :250:100:175
EOF

awk '/Xiaoyu/ {print $4}' reg.txt |awk -F: -v OFS=$ '{print $2,$3,$4}'
# 155$90$201

# awk 修改 OFS 时，显示 $1,$2,$3 正常；但 $0 时 OFS 不生效
awk '/Xiaoyu/ {print $4}' reg.txt |awk -F: -v OFS=$ '{print $0}'
# :155:90:201

awk -vOFS=#### '{print $1,$2}' reg.txt
awk -vOFS=#### '{$1=$1;print $0}' reg.txt
```

![awk示例](img/Linux%E7%B3%BB%E7%BB%9F%E7%AC%A6%E5%8F%B7%E7%B3%BB%E5%88%97-03.png)

### 9. awk 判断与循环

**判断（对比 shell 的 if）**：
```bash
# shell 中
if [ ]; then
    xxxx
fi

# awk 中显示第一行
awk 'NR==1' reg.txt
awk '{if(NR==1) print}' reg.txt
```

**统计 `{}` 范围内包含 oldboy 的行数**：
```bash
cat > range.txt <<EOF
oldboy
oldboy
oldboy
{
lidao
oldboy
alex
oldboy oldboy
}
oldboy
oldboy
oldboy
{
lidao
oldboy
alex
oldboy oldboy
}
oldboy
{
lidao
oldboy
alex
oldboy oldboy
}
EOF

awk '/{/,/}/' range.txt |grep oldboy -c
awk '/{/,/}/' range.txt |awk '/oldboy/' |wc -l
awk '/{/,/}/{if(/oldboy/) i++}END{print i}' range.txt
```

**循环**：
```bash
# shell 循环
for((i=1;i<=100;i++))
do
    echo $i
done

for i in 110 120 12306
do
    echo $i
done

# awk 循环
for(i=1;i<=100;i++)
    sum=sum+1

# awk 数组专用循环
for(i in h)
    print i

awk 'BEGIN{for(i=1;i<=100;i++)sum+=i; print sum}'
awk 'BEGIN{for(i=1;i<=100;i++){sum+=i; print sum}}'   # 加 {} 显示执行过程

awk -F: '/bash$/{i++;print $NF,$1}END{print i}' /etc/passwd
#  条件：/bash$/
#  动作：{i++;print $NF,$1}
awk -F: '/bash$/{i++}{print $NF,$1}END{print i}' /etc/passwd
#  条件1：/bash$/   动作1：{i++}   动作2：{print $NF,$1}
```

### 10. awk 数组与统计

```bash
awk 'BEGIN{h[110] }'
#  数组名称[下标]
#  酒店[房间号码]
#  分类统计：{h[$2]++}
#  统计之后显示：END {for(i in h)print i,h[i]}

awk 'BEGIN{h[110]="laowang";h[120]="tao"; print h[110],h[120]}'
```

**案例 1：域名取出并按域名计数排序（百度/sohu 面试题）**：
```bash
cat > url.log <<EOF
http://www.etiantian.org/index.html
http://www.etiantian.org/1.html
http://post.etiantian.org/index.html
http://mp3.etiantian.org/index.html
http://www.etiantian.org/3.html
http://post.etiantian.org/2.html
EOF

awk -F'[/.]+' '{ h[$2]++}END{for(i in h)print i,h[i] }' url.log
# www 3
# mp3 1
# post 2

awk -F"[/.]+" '{h[$2]++} END{for(i in h) print i,h[i] }' url.txt
```

**案例 2：统计 Secure 日志中每个 IP 破解密码的次数（前 10）**：
```bash
# sort -rnk2
#   -r 逆序
#   -n 按数字排序
#   -k 根据某一列排序

awk '/Failed/{h[$(NF-3)]++}END{for(i in h) print i,h[i]}' secure-20161219 |sort -rnk2|head
```

**案例 3：统计 Secure 中每个用户破解的次数（前 10）**：
```bash
awk '/Failed/{h[$(NF-5)]++}END{for(i in h)print i,h[i]}' secure-20161219|sort -rnk2|head
```

### 11. awk 练习题
```bash
# 1. 取出 /etc/passwd 中 uid 在 1 到 500 之间的用户名和 uid
awk -F: '$3>=1 && $3<500' passwd.txt     # 1 到 499
awk -F: '$3<1 || $3>500' passwd.txt      # 小于 1 或大于 500 的

# 2. 显示系统最近 1 分钟、5 分钟、15 分钟的负载
w |awk -F'[ ,]+' '/load/{print $(NF-2),$(NF-1),$NF}'

# 3. 显示系统中所有非虚拟用户的用户名和使用的 shell，并统计数量
awk -F: '/bash$/{i++;print $1,$NF}END{print i}' passwd.txt

# 4. seq 100 通过 awk 计算 1+...+100
seq 100 |awk '{i+=$1}END{print i}'

# 5. 统计 access.log 中所有流量总和（第 10 列）
awk '$10{i++}END{print i}' access.log
awk '{i+=$10}END{print i}' access.log
awk '{i+=$10}END{print i/1024^3"G"}' access.log
```

### 12. awk 处理多个文件：`NR==FNR`（重点补充）

| 变量 | 含义 |
| --- | --- |
| `NR` | **全局**行号（读多个文件时累加） |
| `FNR` | **当前文件**自己的行号（每读一个新文件都从 1 开始） |

> **口诀**：`NR==FNR` 时表示**正在读第一个文件**；`NR!=FNR` 表示已在读第二个文件。

```bash
# 经典：把 file1 的密码关联到 file2 的用户上
cat > file1 <<EOF
oldboy 1234
alex   4567
lidao  9999
EOF
cat > file2 <<EOF
001 lidao
002 alex
003 oldboy
004 oldgirl
EOF

# 第一个文件建映射（用户名→密码），第二个文件取值，只输出"同时存在"的
awk 'NR==FNR{a[$1]=$2;next} $2 in a{print $2,a[$2]}' file1 file2
# lidao 9999
# alex 4567
# oldboy 1234

# 不带 next 的写法（效果类似）
awk 'NR==FNR{h[$1]=$2;next}{print $2,h[$2]}' file1 file2
```

> **要点**：第一个文件处理完要加 `next`，跳过后续动作，否则会把第一个文件也输出一遍。

### 13. awk 内置函数（补充）

**字符串函数**

| 函数 | 作用 | 示例 |
| --- | --- | --- |
| `length(s)` | 字符串/整行长度 | `awk '{print length($0)}' file` |
| `substr(s,i,n)` | 从第 i 个字符取 n 个 | `awk '{print substr($1,1,3)}' file` |
| `split(s,arr,sep)` | 按分隔符切分到数组 | `awk '{split($0,a,":");print a[1]}'` |
| `index(s,t)` | 返回 t 在 s 中的位置（0=不含） | `awk '{print index($0,"oldboy")}'` |
| `sub(r,s,t)` | 替换**第一次**匹配 | `awk '{sub(/old/,"new");print}'` |
| `gsub(r,s,t)` | 替换**所有**匹配 | `awk '{gsub(/old/,"new");print}'` |
| `match(s,r)` | 返回匹配位置，配合 `RSTART`/`RLENGTH` | |
| `toupper/tolower` | 转大写/小写 | `awk '{print toupper($1)}'` |
| `sprintf(fmt,…)` | 格式化（不打印，返回字符串） | `awk '{x=sprintf("%.2f",$1);print x}'` |

**数学 / 其他函数**

| 函数 | 作用 |
| --- | --- |
| `int(x)` | 取整 |
| `sqrt(x)` | 平方根 |
| `rand()` / `srand()` | 随机数（需先用 `srand()` 播种） |
| `systime()` / `strftime()` | 时间戳 / 格式化时间（gawk） |
| `system("cmd")` | 在 awk 中执行 shell 命令 |
| `close("cmd")` | 关闭由 `\| ` 打开的命令管道 |

```bash
# 取每行的前 3 个字符
awk '{print substr($0,1,3)}' oldboy.txt

# 统计每行长度超过 20 的行
awk 'length($0)>20' oldboy.txt

# 用 split 切分并取第 1 段
echo "a:b:c" | awk '{split($0,arr,":");print arr[1]}'

# gsub 批量替换后输出
awk '{gsub(/oldboy/,"oldgirl");print}' person.txt

# 格式化输出（类似 printf，但可赋值给变量）
awk '{rate=sprintf("%.1f%%",$3/$2*100);print rate}' file
```

### 14. awk 完整控制结构（补充）

```bash
# if / else if / else
awk '{ if($3>1000) print $1,"大"; else if($3>500) print $1,"中"; else print $1,"小" }' file

# while 循环
awk 'BEGIN{ i=1; while(i<=5){ print i; i++ } }'

# do while（至少执行一次）
awk 'BEGIN{ i=1; do{ print i; i++ }while(i<=5) }'

# for 循环（C 风格）
awk 'BEGIN{ for(i=1;i<=100;i++) sum+=i; print sum }'

# for in（遍历数组，顺序不保证）
awk '{h[$1]++}END{for(k in h) print k,h[k]}' file

# next：跳过本行后面的所有动作（提前进入下一行）
awk 'NR==1{next}{print $0}' file          # 跳过第 1 行（去表头）

# exit：提前结束 awk（可配合 END 输出结果）
awk 'NR==10{print;exit}' file              # 只取第 10 行，读完就退出（大文件提速）

# break / continue（在循环内使用）
awk 'BEGIN{ for(i=1;i<=10;i++){ if(i==5) break; print i } }'
```

### 15. awk 数组排序（gawk 扩展补充）

`for(k in h)` 遍历数组是**无序**的，如需按次数排序可用 gawk 的 `asort` / `asorti`：

| 函数 | 作用 |
| --- | --- |
| `asort(arr)` | 按**值**排序（下标会重置为 1,2,3…） |
| `asort(arr,dest)` | 排序结果放入新数组 dest，保留原数组 |
| `asorti(arr,dest)` | 按**下标（key）**排序 |

```bash
# 按出现次数排序（倒序取 Top）
awk '{h[$1]++}END{ n=asort(h,sorted); for(i=n;i>=1;i--) print i,sorted[i] }' url.log

# 按下标排序（asorti）
awk '{h[$2]++}END{ n=asorti(h,idx); for(i=1;i<=n;i++) print idx[i],h[idx[i]] }' url.log

# 配合 sort 命令（更通用、兼容性最好）
awk -F'[/.]+' '{h[$2]++}END{for(i in h) print i,h[i]}' url.log | sort -rnk2 | head
# -r 逆序  -n 按数字  -k2 按第 2 列
```

> **实战建议**：普通 awk 没有排序函数时，用 `awk ... | sort -rnk2 | head` 最简单可靠。

---

## 十、综合练习

### 0. 三剑客综合实战：Nginx 访问日志分析

**Nginx 默认 combined 日志格式**（空格分隔后的常用列）：
```
$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"
```
| 列 | 含义 | 取值 |
| --- | --- | --- |
| `$1` | 客户端 IP | `122.71.226.14` |
| `$4` | 时间（带 `[`） | `[15/Aug/2018:10:20:31` |
| `$7` | 请求的 URL | `/index.html` |
| `$9` | HTTP 状态码 | `200` |
| `$10` | 响应字节数（流量） | `1024` |

```bash
# 样例日志
cat > access.log <<'EOF'
122.71.226.14 - - [15/Aug/2018:10:20:31 +0800] "GET /index.html HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
123.66.148.193 - - [15/Aug/2018:10:20:32 +0800] "GET /api/user HTTP/1.1" 200 2048 "-" "curl/7.29"
122.71.226.14 - - [15/Aug/2018:10:21:01 +0800] "GET /static/a.css HTTP/1.1" 304 0 "-" "Mozilla/5.0"
122.71.243.118 - - [15/Aug/2018:10:21:05 +0800] "POST /login HTTP/1.1" 302 512 "-" "Mozilla/5.0"
223.72.40.36 - - [15/Aug/2018:10:22:10 +0800] "GET /notfound HTTP/1.1" 404 128 "-" "Mozilla/5.0"
EOF
```

**① PV（总访问量）**
```bash
wc -l access.log
awk 'END{print NR}' access.log
```

**② UV（独立 IP 数）**
```bash
awk '{print $1}' access.log | sort -u | wc -l
awk '{h[$1]++}END{print "UV:",length(h)}' access.log   # 数组长度即独立 IP 数
```

**③ 访问量 Top 10 的 IP**
```bash
# 命令组合法（最常用）
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head

# 纯 awk 数组法
awk '{h[$1]++}END{for(i in h) print h[i],i}' access.log | sort -rn | head
```

**④ 总流量统计（第 10 列）**
```bash
awk '{sum+=$10}END{print sum" bytes"}' access.log
awk '{sum+=$10}END{print sum/1024" KB"}' access.log
awk '{sum+=$10}END{print sum/1024^2" MB"}' access.log
awk '{sum+=$10}END{printf "总流量: %.2f GB\n", sum/1024^3}' access.log
```

**⑤ 每个 IP 的流量 Top 10**
```bash
awk '{h[$1]+=$10}END{for(i in h) print h[i],i}' access.log | sort -rn | head
# 换算成 MB 显示
awk '{h[$1]+=$10}END{for(i in h) printf "%.2f MB  %s\n", h[i]/1024^2, i}' access.log | sort -rn | head
```

**⑥ 状态码分布（找出异常）**
```bash
awk '{h[$9]++}END{for(i in h) print i,h[i]}' access.log | sort -rnk2
# 200 3
# 404 1
# 302 1
# 304 1

# 只统计 5xx 错误
awk '$9>=500 && $9<600{print $7,$9}' access.log | sort | uniq -c
```

**⑦ 找出访问最多的 URL / 最耗流量的 URL**
```bash
# 访问次数 Top 10 的 URL
awk '{print $7}' access.log | sort | uniq -c | sort -rn | head

# 最耗流量 Top 10 的 URL
awk '{h[$7]+=$10}END{for(i in h) print h[i],i}' access.log | sort -rn | head

# 找出所有 404 的 URL
awk '$9==404{print $7}' access.log | sort | uniq -c | sort -rn
```

**⑧ 按时间段统计（每分钟 PV）**
```bash
# 截取到分钟：[15/Aug/2018:10:20
awk '{print substr($4,2,17)}' access.log | sort | uniq -c

# 取某一时间段的日志
awk '$4>="[15/Aug/2018:10:20:00" && $4<="[15/Aug/2018:10:22:00"' access.log
sed -n '/15\/Aug\/2018:10:20/,/15\/Aug\/2018:10:22/p' access.log
```

**⑨ 找出非 200 的请求（排障用）**
```bash
awk '$9!=200{print $1,$7,$9}' access.log
grep -v ' 200 ' access.log | awk '{print $9}' | sort | uniq -c
```

**⑩ 综合：一条命令出"IP + 次数 + 流量"报表**
```bash
awk '{cnt[$1]++; byte[$1]+=$10}END{
  for(i in cnt) printf "%-18s 次数:%-6d 流量:%.2f MB\n", i, cnt[i], byte[i]/1024^2
}' access.log | sort -rnk2
```

> **三剑客协作小结**
> | 工具 | 在本案例中承担的角色 |
> | --- | --- |
> | `grep` | 先粗筛（如排除静态资源、只留某状态码） |
> | `sed` | 清洗/提取字段（如取时间范围、替换分隔符） |
> | `awk` | 取列、计算、数组统计、格式化输出（核心） |
> | `sort/uniq` | 排序与去重（配合 awk 出 Top N） |

### 1. 输出 test.txt 中不包含 oldboy 字符串的行
```bash
mkdir -p /data
cat >/data/test.txt <<EOF
test
liyao
oldboy
EOF

# 方法1：grep -v（过滤，显示不要的内容）
grep -v "oldboy" /data/test.txt

# 方法2：head 显示前两行
head -n2 /data/test.txt
head -2 /data/test.txt
# head 显示文件前几行，默认前 10 行
# tail 显示文件最后几行，默认最后 10 行
tail -1 /data/test.txt        # 显示最后一行

# 方法3：awk（! 取反）
awk '/oldboy/' /data/test.txt
awk '!/oldboy/' /data/test.txt

# 方法4：sed（d 删除，只是屏幕不显示，并不修改文件内容）
sed '/oldboy/d' /data/test.txt
```

### 2. 查看 ett.txt（共 40 行）第 20 到 30 行
```bash
seq 40 >/data/ett.txt        # 测试文件

head -30 /data/ett.txt |tail -11
awk 'NR==20,NR==30' /data/ett.txt
# -n 关闭默认自动打印，只打印用 p 指定的内容
sed -n '20,30p' /data/ett.txt
```

### 3. 取出文件中正确的身份证号码
```bash
cat > id.txt <<EOF
金 211324198705244720
万 500224197105168312
任 1231231231old	boy
任 3oldboy
任 lidao97303136098
任 alex2197303136098
任 350182197303oldgir
吕 211282199209113038
孔 150000198309176071
邹 371001197412221284
贺 130185200011215926
杜 362522198711278101
向 14052219961008852X
EOF

grep -E '[0-9]{17}[0-9X]' id.txt
```

### 4. 给 grep / egrep 配置别名（过滤带颜色）

```bash
alias egrep='egrep --color'
alias grep='grep --color'
# 写入 /etc/profile 后 source /etc/profile
vim /etc/profile
source /etc/profile
cat /etc/profile | tail -n3
```

---

## 十一、附：用户管理（补充）

```bash
# 添加用户
useradd oldboy
# 设置密码
passwd oldboy

# 切换用户
su - oldboy

# ctrl + d 退出当前用户
```

> 更新: 2026-04-24 14:50:04
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/axtqt3>
