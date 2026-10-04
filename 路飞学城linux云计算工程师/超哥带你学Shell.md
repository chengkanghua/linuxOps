# 超哥带你学Shell

# Shell条件测试
注意bash执行脚本是开启子shell

source在当前shell执行

exit是退出shell环境

从shell变量学到现在，我们发现bash的脚本开发，需要结合if语句，进行条件判断，根据不同的结果，执行不同的操作。

说到条件判断，也就是生活里的，真，假。

在这一节，超哥给大家讲讲，条件测试

能够提供条件测试的语法，有如下

test命令

[ ] 中括号

| 语法 | 说明 |
|---|---|
| 语法 1：`test <测试表达式>` | 利用 test 命令进行条件测试。test 命令和表达式之间至少有一个空格。 |
| 语法 2：`[ <测试表达式> ]` | 通过单中括号进行条件测试，用法和 test 命令相同。`[ ]` 的边界和内容之间至少有一个空格。 |
| 语法 3：`[[ <测试表达式> ]]` | 通过双中括号进行条件测试，是比 test 和 `[ ]` 更新的语法格式。`[[ ]]` 的边界和内容之间至少有一个空格。 |
| 语法 4：`((<测试表达式>))` | 通过双小括号进行条件测试，一般用在 if 语句里。`(())` 两端不需要空格。 |

## test条件测试
test 命令最短的定义可能是评估一个表达式；如果条件为真，则返回一个 0 值。如果表达式不为真，则返回一个大于 0 的值 — 也可以将其称为假值。检查最后所执行命令的状态的最简便方法是使用 $? 值。

### 语法
```plain
语法
. 关于某个文件名的『类型』侦测(存在与否)，如 test -e filename 

-e 该『文件名』是否存在？(常用) 
-f 该『文件名』是否为文件(file)？(常用) 
-d 该『文件名』是否为目录(directory)？(常用) 
-b 该『文件名』是否为一个 block device 装置？ 
-c 该『文件名』是否为一个 character device 装置？ 
-S 该『文件名』是否为一个 Socket 文件？ 
-p 该『文件名』是否为一个 FIFO (pipe) 文件？ 
-L 该『文件名』是否为一个连结档？ 

2. 关于文件的权限侦测，如 test -r filename 

-r 侦测该文件名是否具有『可读』的属性？ 
-w 侦测该文件名是否具有『可写』的属性？ 
-x 侦测该文件名是否具有『可执行』的属性？ 
-u 侦测该文件名是否具有『SUID』的属性？ 
-g 侦测该文件名是否具有『SGID』的属性？ 
-k 侦测该文件名是否具有『Sticky bit』的属性？ 
-s 侦测该文件名是否为『非空白文件』？ 

3. 两个文件之间的比较，如： test file1 -nt file2 

-nt (newer than)判断 file1 是否比 file2 新 
-ot (older than)判断 file1 是否比 file2 旧 
-ef 判断 file2 与 file2 是否为同一文件，可用在判断 hard link 的判定上。 主要意义在判定，两个文件是否均指向同一个 inode 哩！ 

4. 关于两个整数之间的判定，例如 test n1 -eq n2 

-eq 两数值相等 (equal) 
-ne 两数值不等 (not equal) 
-gt n1 大于 n2 (greater than) 
-lt n1 小于 n2 (less than) 
-ge n1 大于等于 n2 (greater than or equal) 
-le n1 小于等于 n2 (less than or equal) 

5. 判定字符串的数据 

test -z string 判定字符串是否为 0 ？若 string 为空字符串，则为 true 
test -n string 判定字符串是否非为 0 ？若 string 为空字符串，则为 false。
注： -n 亦可省略 
test str1 = str2 判定 str1 是否等于 str2 ，若相等，则回传 true 
test str1 != str2 判定 str1 是否不等于 str2 ，若相等，则回传 false 

6. 多重条件判定，例如： test -r filename -a -x filename 

-a (and)两状况同时成立！例如 test -r file -a -x file，则 file 同时具有 r 与 x 权限时，才回传 true。 
-o (or)两状况任何一个成立！例如 test -r file -o -x file，则 file 具有 r 或 x 权限时，就可回传 true。 
! 反相状态，如 test ! -x file ，当 file 不具有 x 时，回传 true
```

### 案例
-f 是否是普通文件类型

```plain
[root@chaogelinux shell_program]# test -f str1
[root@chaogelinux shell_program]# echo $?
1

# && 并且，|| 否则
# -f 是否是普通文件类型
[root@chaogelinux shell_program]# test -f hello.txt && echo ok || echo no
no

[root@chaogelinux shell_program]# test -f t1.sh  && echo ok || echo no
ok
```

-z 字符串长度是否为0

```plain
[root@chaogelinux shell_program]# test -z "" && echo ok || echo no
ok
[root@chaogelinux shell_program]# test -z "超哥带你学Shell" && echo ok || echo no
no
```

### 中括号测试[ ]
脚本常用[ ] 中括号语法，进行条件测试，用的人是最多的

test和[ ] 作用是一样的，用哪个都可以

注意，中括号，前后的空格！！

```plain
[root@chaogelinux shell_program]# [ -f hello ] && echo ok || echo no
no
[root@chaogelinux shell_program]# [ -f hello.py ] && echo ok || echo no
ok
```

利用-f严谨点创建文件

```plain
[root@chaogelinux shell_program]# [ -f happy.txt ] && echo "已存在" || touch happy.txt
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# [ -f happy.txt ] && echo "已存在" || touch happy.txt
已存在
```

  
-d 测试目录

```plain
[root@chaogelinux shell_program]# ls
2                      del_data.sh   expr1.sh         hello.py     length_word.sh  str1       test_date.sh    鸡你太美.jppg
Calculation2.sh        different.sh  file_houzhui.sh  hello.sh     make_var.sh     sub_str    test.txt        吴亦凡.jpg
Calculation.sh         echo_test.sh  happy.txt        jisuan.sh    nohup.out       t1.sh      word_length.sh
check_nginx_status.sh  echo_var.sh   hello            learn_if.sh  special_var.sh  test1.txt  蔡徐坤.jpg
[root@chaogelinux shell_program]# [ -d hello ] || echo "该目录不存在"
```

### 双中括号 [[ ]]
语法

```plain
[[ 条件表达式 ]]

[root@chaogelinux shell_program]# [[ -f hello.shh ]] || echo "条件不成立"
条件不成立

[root@chaogelinux shell_program]# [[ -f hello.sh ]] && echo "该文件已存在"
该文件已存在
```

## 文件测试表达式
为什么要测试？就是为了严谨，如果王者荣耀游戏不测试，上线一堆bug，用户那肯定得骂街，我们运维写脚本，为了更高的严谨性，需要对文件操作测试。

| 常用文件测试操作符 | 说明 |
|---|---|
| `-d 文件`（d = directory | 文件存在且为目录则为真 |
| `-f 文件`（f = file） | 文件存在且为普通文件则为真 |
| `-e 文件`（e = exist） | 文件存在则为真（不区分目录还是文件 |
| `-r 文件`（r = read） | 文件存在且可读则为真 |
| `-s 文件`（s = size） | 文件存在且大小不为 0 则为真 |
| `-w 文件`（w = write） | 文件存在且可写则为真 |
| `-x 文件`（x = executable） | 文件存在且可执行则为真 |
| `-L 文件`（L = link） | 文件存在且为软链接则为真 |
| `f1 -nt f2`（nt = newer than） | 文件 f1 比 f2 新则为真（按修改时间） |
| `f1 -ot f2`（ot = older than） | 文件 f1 比 f2 旧则为真（按修改时间） |

-e 无论是文件，目录，是否存在  

```plain
[root@chaogelinux shell_program]# [ -e apple ] && echo "已存在" || echo "不存在"
不存在
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# mkdir apple
[root@chaogelinux shell_program]# [ -e apple ] && echo "已存在" || echo "不存在"
已存在
```

-d 目录测试

```plain
[root@chaogelinux shell_program]# [ -d apple ] && echo "已存在" || echo "不存在"
已存在
[root@chaogelinux shell_program]# rm -rf apple
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# [ -d apple ] && echo "已存在" || echo "不存在"
不存在
```

-r 文件可读属性测试(注意别用root，特殊)

```plain
[root@chaogelinux shell_program]# [ -r hello.sh ] && echo "可读" || echo "没阅读权限"
可读
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# chmod 0 hello.sh
[root@chaogelinux shell_program]# [ -r hello.sh ] && echo "可读" || echo "没阅读权限"
可读

# 用户yuchao用户
[root@chaogelinux shell_program]# su - yuchao
上一次登录：四 3月  4 16:25:40 CST 2021pts/0 上
[yuchao@chaogelinux ~]$
[yuchao@chaogelinux ~]$
[yuchao@chaogelinux ~]$ ls
[yuchao@chaogelinux ~]$ touch hello.sh
[yuchao@chaogelinux ~]$ chmod 0 hello.sh
[yuchao@chaogelinux ~]$
[yuchao@chaogelinux ~]$ [ -r hello.sh ] && echo "可读" || echo "权限不够"
权限不够
[yuchao@chaogelinux ~]$ chmod 777 hello.sh
[yuchao@chaogelinux ~]$ [ -r hello.sh ] && echo "可读" || echo "权限不够"
可读
```

-w 是否可写，同样的玩法，验证文件是否有w权

### 变量测试
所谓变量测试，在这里就是变量存储着文件名，效果还是一样的  
 

```plain
[root@chaogelinux shell_program]# [ -f $file1 ] && echo ok || echo no
ok
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# [ -f $file1 ] && echo ok || echo no^C
[root@chaogelinux shell_program]# mv t1.sh t1.sh.bak
[root@chaogelinux shell_program]# [ -f $file1 ] && echo ok || echo no
no
```

### 测试变量的特殊写法
对变量测试，必须加上双引号

```plain
[root@chaogelinux shell_program]# echo $pyyu

[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# [ -f $pyyu ] && echo ok || echo no
ok
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# # 你看上面的结果，就是有问题的
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# [ -f "$pyyu" ] && echo ok || echo no
no
```

### 看系统自带的脚本模板
很多linux自带的shell脚本，都是大佬给你写好的参考模板，非常值得学习

/etc/init.d/network  
 

```plain
 16 # Source function library.
 17 . /etc/init.d/functions
 18
 19 if [ ! -f /etc/sysconfig/network ]; then
 20     exit 6
 21 fi
 22
 23 . /etc/sysconfig/network
 24
 25 if [ -f /etc/sysconfig/pcmcia ]; then
 26     . /etc/sysconfig/pcmcia
 27 fi
 28
```

/etc/init.d/mysql

```plain
su_kill() {
  if test "$USER" = "$user"; then
    kill $* >/dev/null 2>&1
  else
    su - $user -s /bin/sh -c "kill $*" >/dev/null 2>&1
  fi
}
```

## 字符串测试
字符串是运维日常操作的数据类型，在脚本开发里用的也很多，例如判断两个字符串是否相等，字符串是否为空等

<!-- OCR_START -->
- 常用字符串测试操作符
- 说明

```text
-n"字符串"
若字符串的长度不为0，则为真，即测试表达式成立，n可以理解为nozero
-z"字符串"
若字符串的长度为0，则为真，即测试表达式成立，z可以理解为zero的缩写
"串1"="串2"
若字符串1等于字符串2，则为真，即测试表达式成立，可使用“==”代替“=”
"串1"!="串2"
若字符串1不等于字符串2，则为真，即测试表达式成立，但不能用“!==”代替“!=”
```
<!-- OCR_END -->

上面超哥列出来的mysql脚本，正式用的该条件，对用户测试。

注意官方的mysql脚本如何写的  
   

```plain
su_kill() {
  if test "$USER" = "$user"; then
    kill $* >/dev/null 2>&1
  else
    su - $user -s /bin/sh -c "kill $*" >/dev/null 2>&1
  fi
}
```

+ if test "$USER" = "$user"; then
+ 字符串的测试，一定要添加双引号
+ 比较符号的两端，一定得有空格
+ != 和 =用于比较两个字符串是否相同

### 实践
-n 判断字符串长度，有内容就真，没内容就假

```plain
[root@chaogelinux ~]# [ -n "yuchao" ] && echo ok || echo no
ok
# 注意空格，也有东西，长度就为1
[root@chaogelinux ~]# [ -n " " ] && echo ok || echo no
ok
[root@chaogelinux ~]# [ -n "" ] && echo ok || echo no
no

# 求长度
[root@chaogelinux ~]# expr length " "
1
[root@chaogelinux ~]# expr length ""
0
```

-z 和-n反过来的，只要为空，就为真，反之为假

```plain
[root@chaogelinux ~]# name="chaoge666"
[root@chaogelinux ~]# [ -z "$name" ] && echo ok || echo no
no
[root@chaogelinux ~]# unset name
[root@chaogelinux ~]# [ -z "$name" ] && echo ok || echo no
ok
```

求变量是否相等

```plain
[root@chaogelinux ~]# [ "yuchao" = "yucha" ] && echo ok || echo no
no
[root@chaogelinux ~]# [ "yuchao" = "yuchao" ] && echo ok || echo no
ok

[root@chaogelinux ~]# # 变量值判断
[root@chaogelinux ~]#
[root@chaogelinux ~]# name="yuchao"
[root@chaogelinux ~]#
[root@chaogelinux ~]# [ "$name" = "yuchao" ] && echo ok || echo no
ok
[root@chaogelinux ~]# [ "$name" = "yuchaoo" ] && echo ok || echo no
no
```

  
判断不相等

```plain
[root@chaogelinux ~]# [ "pyyu" != "py" ] && echo ok || echo no
ok
[root@chaogelinux ~]# [ "pyyu" != "pyyu" ] && echo ok || echo no
no
```

结果取反

```plain
[ ! -f "hello.txt" ] && echo "ok" || echo no

```

### 提示
条件测试中

+ 变量必须有双引号
+ 等于号两边得有空格

语法不对，结果必然有误。

错误示范，-n 参数判断字符串必须有值

```plain
[root@chaogelinux ~]# unset hometown
[root@chaogelinux ~]# [ -n "$hometown" ] && echo ok || echo no
no
[root@chaogelinux ~]#
[root@chaogelinux ~]#
# 这里就出错了
[root@chaogelinux ~]# [ -n $hometown ] && echo ok || echo no
ok
```

> 查看大神开发的mysql脚本
>
> 这里就是判断，当该crash_protection变量非空时，将其置空
>
> 这里的逻辑我们不用过多关注，从注释可以得知
>
> 该代码作用是，当mysql的pid-file存在，但是mysql进程不存在，这就证明mysql异常挂掉了，mysql应该重启。
>

```plain
233       # pid-file exists, the server process doesn't.
234       # it must've crashed, and mysqld_safe will restart it
235       if test -n "$crash_protection"; then
236         crash_protection=""
237         sleep 5
238         continue  # Check again.
239       fi
```

## 整数比较符测试
我们在脚本开发中，会用到对数值的比较判断，也就是常见的大于，小于，等于之类

<!-- OCR_START -->
- 在[以及test中使用的比较符号
- 在(())和[]]中使用的比较符号
- 说明
- -eq
- ==或=
- 相等，全拼为equal
- -ne
- !=
- 不相等，全拼为notequal
- -gt
- 大于，全拼为 greater than
- -ge
- V=
- 大于等于，全拼为 greaterequal
- -1t
- 小于，全拼为less than
- -le
- 小于等于，全拼为less equal
<!-- OCR_END -->

> 语法注意：在中括号里，数值条件测试，大于，小于号，需要用转义符号
>
> 1.在中括号，以及test的用法
>

### 中括号
```plain
[root@chaogelinux ~]# # 中括号
[root@chaogelinux ~]# # 正确用法
[root@chaogelinux ~]# [ 2 \> 1 ] && echo yes || echo no
yes
[root@chaogelinux ~]# [ 2 > 1 ] && echo yes || echo no
yes
# 错误用法，可见，必须加上转义符
[root@chaogelinux ~]# [ 2 < 1 ] && echo yes || echo no
yes
[root@chaogelinux ~]# [ 2 \< 1 ] && echo yes || echo no
no

# 数值比较
[root@chaogelinux ~]# [ 2 = 2 ] && echo yes || echo no
yes
[root@chaogelinux ~]# [ 2 != 2 ] && echo yes || echo no
no

# 比较符号
[root@chaogelinux ~]#
[root@chaogelinux ~]# [ 2 -gt 1 ] && echo yes || echo no
yes
[root@chaogelinux ~]# [ 2 -ge 1 ] && echo yes || echo no
yes
[root@chaogelinux ~]# [ 2 -le 1 ] && echo yes || echo no
no
[root@chaogelinux ~]# [ 2 -lt 1 ] && echo yes || echo no
no

# 变量比较大小
[root@chaogelinux ~]# n1=98;n2=99
[root@chaogelinux ~]#
[root@chaogelinux ~]# [ $n1 -eq $n2 ] && echo yes || echo no
no
[root@chaogelinux ~]# [ $n1 -gt $n2 ] && echo yes || echo no
no
[root@chaogelinux ~]# [ $n1 -lt $n2 ] && echo yes || echo no
yes
[root@chaogelinux ~]# [ $n1 != $n2 ] && echo yes || echo no
yes
[root@chaogelinux ~]# [ $n1 = $n2 ] && echo yes || echo no
no
```

  
2.比较符，在双中括号的用法 [[]]

### 双中括号
```plain
[root@chaogelinux ~]# [[ 5 > 6  ]] && echo yes || echo no
no
[root@chaogelinux ~]# [[ 5 < 6  ]] && echo yes || echo no
yes
[root@chaogelinux ~]# [[ 5 != 6  ]] && echo yes || echo no
yes
[root@chaogelinux ~]# [[ 5 = 6  ]] && echo yes || echo no
no
[root@chaogelinux ~]# [[ 5 -gt  6  ]] && echo yes || echo no
no
[root@chaogelinux ~]# [[ 5 -lt  6  ]] && echo yes || echo no
yes
```

工作中用的最多的是中括号进行条件测试[]，双中括号属于扩展特殊用法，知道其存在就好

### 双小括号
```plain
[root@chaogelinux ~]#
[root@chaogelinux ~]# ((3>2)) && echo yes || echo no
yes
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]# ((3<2)) && echo yes || echo no
no

# 比较等于，不等于，注意，只能使用2个等于号

[root@chaogelinux ~]# (( 3 == 2 )) && echo yes || echo no
no

[root@chaogelinux ~]# (( 3 != 2 )) && echo yes || echo no
yes
```

### 总结
+ 注意语法，[]和test为一类，可以用-gt -lt 以及< > !=等符号
+ 而 [[ ]] (())属于一类，不能用 -gt -lt这样的符号

系统自带的network脚本案例参考  

```plain
112         if [ "$TYPE" = "IPSEC" ] || [ "$TYPE" = "IPIP" ] || [ "$TYPE" = "GRE" ]; then
113             vpninterfaces="$vpninterfaces $i"
114             continue
115         fi
116
117         if [ "${DEVICE%%.*}" != "$DEVICE"  -o  "${DEVICE##vlan}" != "$DEVICE" ] ; then
118             vlaninterfaces="$vlaninterfaces $i"
119             continue
120         fi
121
122         if LANG=C grep -EL "^ONBOOT=['\"]?[Nn][Oo]['\"]?" ifcfg-$i > /dev/null ; then
123             # this loads the module, to preserve ordering
124             is_available $i
125             continue
126         fi
127         action $"Bringing up interface $i: " ./ifup $i boot
128         [ $? -ne 0 ] && rc=1
129     done
```

## 逻辑操作符
逻辑运算，也就是生活里的 真，假概念

<!-- OCR_START -->
- 在[]和test中使用的操作符
- 在[]]和（()）中使用的操作符
- 说明
- -a
- &&
- and，与，两端都为真，则结果为真
- -0
- 1
- or，或，两端有一个为真，则结果为真
- not，非，两端相反，则结果为真
<!-- OCR_END -->

> ! 取反，也就是结果相反的值
>
> -a 是“与”的意思（等同 && 和and），要求，左右两个逻辑值都为真，结果才为真，否则为假
>
> -o 是或者的意思，（or 和 ||），左右两个逻辑，只要有一个真，结果就为真
>
> 结果为真，对应计算机数字是1
>
> 结果为假，计算机数字为0
>
> 注意：选用不同的语法，对应的测试符号不一样!!!
>

### 逻辑操作案例
### 中括号
```plain
[root@chaogelinux ~]# file1=/etc/init.d/network
[root@chaogelinux ~]# file2=/etc/hostname

[root@chaogelinux ~]# echo "$file1" $file2
/etc/init.d/network /etc/hostname

# 条件测试
# 并且
[root@chaogelinux ~]# [ -f "$file1" -a -f "$file2"  ] && echo "都是普通文件，条件成立" || echo "不成 立"
都是普通文件，条件成立

# 或者
[root@chaogelinux ~]# [ -f "$file1" -o -f "$file2"  ] && echo "都是普通文件，条件成立" || echo "不成  立"
都是普通文件，条件成立

# 两边条件都不成立
[root@chaogelinux ~]# [ -f "$file11"  -o -f "$file22"  ] && echo "都是普通文件，条件成立" || echo "不成立"
不成立
[root@chaogelinux ~]# [ -f "$file11"  -a -f "$file22"  ] && echo "都是普通文件，条件成立" || echo "不成立"
不成立

# 只有一个成立条件
[root@chaogelinux ~]# [ -f "$file1"  -a -f "$file22"  ] && echo "都是普通文件，条件成立" || echo "不成立"
不成立
[root@chaogelinux ~]#
[root@chaogelinux ~]# [ -f "$file1"  -o -f "$file22"  ] && echo "都是普通文件，条件成立" || echo "不成立"
都是普通文件，条件成立
```

注意，test，和[]是不支持 && 和｜｜的

```plain
[root@chaogelinux ~]# [ -f "$file1"  &&  -f "$file22"  ] && echo "都是普通文件，条件成立" || echo "不成立"
-bash: [: 缺少 `]'
不成立
[root@chaogelinux ~]# [ -f "$file1"  ||  -f "$file22"  ] && echo "都是普通文件，条件成立" || echo "不成立"
-bash: [: 缺少 `]'
-bash: -f: 未找到命令
不成立
```

### 双中括号
-n 判断字符串是否为空，有内容则真

```plain
# 条件，a不为空，且a等于b
[root@chaogelinux ~]# [[ -n "$a" && "$a" = "$b"  ]] && echo yes || echo no
no

# a不为空，且a不等于b
[root@chaogelinux ~]# [[ -n "$a" && "$a" != "$b"  ]] && echo yes || echo no
yes

# 结果取反
# 该条件，本身是为真的，被感叹号，取反，改为了假
[root@chaogelinux ~]# [[ ! -n "$a" && "$a" != "$b"  ]] && echo yes || echo no
no
```

双中括号不支持 -a -o条件参数用法

### 混合练习
```plain
# n1 小于20，且n2大于30

[root@chaogelinux ~]# n1=18
[root@chaogelinux ~]# n2=30
[root@chaogelinux ~]# [ $n1 -lt 20 -a $n2  -ge 30  ]  && echo yes || echo no
yes

# n1大于20，n2小于30
[root@chaogelinux ~]# [ $n1 -gt 20 ] || [ $n2 -lt 30 ] && echo yes || echo no
no
# 条件改一下
[root@chaogelinux ~]# n1=23
[root@chaogelinux ~]# n2=19
[root@chaogelinux ~]# [ $n1 -gt 20 ] || [ $n2 -lt 30 ] && echo yes || echo no
yes
```

  

## 逻辑操作脚本开发
### 输入判断
```plain
[root@chaogelinux shell_program]# cat and_or_test.sh
#!/bin/bash
read -p "pls input a char: " var1

[ "$var1" -eq "1"  ] && {
    echo $var1
    exit 0 
}

[ "$var1" = "2" ] && {
    echo $var1
    exit 0
}

[ "$var1" != "2" -a "$var1" != "1"  ] && {
    echo "script error!!"
    exit 1
}
```

  
执行

```plain
[root@chaogelinux shell_program]# bash and_or_test.sh
pls input a char: 3
script error!!
[root@chaogelinux shell_program]# echo $?
1

[root@chaogelinux shell_program]# bash and_or_test.sh
pls input a char: 2
2
[root@chaogelinux shell_program]# echo $?
0

[root@chaogelinux shell_program]# bash and_or_test.sh
pls input a char: 1
1
[root@chaogelinux shell_program]# echo $?
0
```

### 安装脚本开发
```plain
1.模拟创建lnmp，lamp脚本创建
[root@chaogelinux ~]# cd /shell_program/
[root@chaogelinux shell_program]# mkdir scripts
[root@chaogelinux shell_program]# cd scripts/
[root@chaogelinux scripts]# echo "echo LAMP is installed" > lamp.sh
[root@chaogelinux scripts]# echo "echo LNMP is installed" > lnmp.sh
[root@chaogelinux scripts]#
[root@chaogelinux scripts]# chmod +x lnmp.sh lamp.sh
[root@chaogelinux scripts]# ls
lamp.sh  lnmp.sh

2.逻辑判断脚本开发
[root@chaogelinux shell_program]# cat lnmp_or_lamp.sh
#!/bin/bash
path=/shell_program/scripts
# 条件判断，如果该目录不存在，则创建，尽量减少脚本可能出现的bug
[ ! -d "$path" ] && mkdir $path -p

# start script
# 利用cat命令打印菜单
cat << END
    1.[install lanmp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
END
read num
# 根据命令执行结果判断是否正确，得知是否是数字
expr $num + 1 &> /dev/null

# 上条命令正确则继续,判断返回值
# -ne 两数值不等 (not equal)
[ $? -ne 0 ] && {
    echo "The num you input must be {1|2|3}"
    exit 1
}

[ $num -eq 1  ] && {
    echo "start installing lamp...waiting..."
    sleep 2;
    # 如果该脚本没权限
    [ -x "$path/lamp.sh" ] || {
        echo "The file does not exist or can't be exec."
        exit 1
    }
    # 安装脚本
    source $path/lamp.sh
    exit $?
}

# 如果选择lnmp
[ $num -eq 2 ] && {
    echo "start installing LNMP.."
    sleep 2;
    [ -x "$path/lnmp.sh" ] || {
        echo "The file does not exist or can't be exec."
        exit 1
    }
    source $path/lnmp.sh
    exit $?

}
# 如果要退出
[ $num -eq 3 ] && {
    echo byebye.
    exit 3
}
# 上述只限制了输入的是数字
# 限制必须是1，2，3
# =~ 正则表达式匹配运算符，用于匹配正则表达式的,配合[[]]使用
# 如果用户输入的数字，不在1，2，3中
[[ ! $num =~ [1-3]  ]] && {
    echo "The num you input must be {1|2|3}"
    echo "Input ERROR!"
    exit 4
}
```

执行脚本安装结果

```plain
[root@chaogelinux shell_program]# bash lnmp_or_lamp.sh
    1.[install lanmp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
1
start installing lamp...waiting...
LAMP is installed
[root@chaogelinux shell_program]# bash lnmp_or_lamp.sh
    1.[install lanmp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
2
start installing LNMP..
LNMP is installed
[root@chaogelinux shell_program]# bash lnmp_or_lamp.sh
    1.[install lanmp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
3
byebye.
[root@chaogelinux shell_program]# bash lnmp_or_lamp.sh
    1.[install lanmp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
4
The num you input must be {1|2|3}
Input ERROR!
[root@chaogelinux shell_program]# bash lnmp_or_lamp.sh
    1.[install lanmp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
q
The num you input must be {1|2|3}
```

### 总结
记住，最常用的就是，中括号，搭配 -gt -lt 如此用法即可

> [ $a -gt $b ] 
>

表参考

<!-- OCR_START -->
- 测试表达式符号
- test
- []]
- (0)
- 边界为是否需要空格
- 需要
- 不需要
- 逻辑操作符
- !、-a、-0
- !、&&、
- !、&&、II
- -eq、-gt、-lt、-
- -eq、-gt、-lt、-ge、-le
- 、、、
- >=
- 整数比较操作符
- ge、-le
- 或=、>、、>=、<=
- <n
- 字符串比较操作符
- =、==、!=
- =、==、=
- 不支持
- 支持
- 是否支持通配符匹配
<!-- OCR_END -->

  
 

# if语句

<!-- OCR_START -->
- 如果你有我一半帅，那
- 么你就不可能单身了
<!-- OCR_END -->

  
 if在脚本开发中用的特别多，最频繁的语句，让超哥带你起飞吧！

语法

> if <条件表达式>
>
> then
>
> 代码
>
> fi
>
> 简写
>
> if <条件表达式>;then
>
> 代码
>
> fi
>

条件表达式，可以是超哥所教的[] test [[]] (())都可以。

<!-- OCR_START -->
- 开始
- ifthen
- 条件表达式
- 命令集
- f结束
<!-- OCR_END -->

## 双分支
```plain
if    <条件表达式>
    then
        if    <条件表达式>
            then
                指令
        fi
fi
```

尽量用注释，看起来美观点

> 双分支嵌套结构
>
> 语法
>
> if 我有房
>
> 那么
>

```plain
if    <条件表达式>
    then
        代码1
else
        代码2
fi
```

<!-- OCR_START -->
- 开始
- else
- 条件表达式
- then
- 命令集1
- 命令集2
- 五结束
<!-- OCR_END -->

## 多个分支
多个分支，就是当你需要多次逻辑判断，就会用到

你可以理解为，这个人有纠结选择困难症

```plain
if <条件表达式>
    then
        代码1
elif    <条件表达式2>
    then
        代码2
else
    代码3
fi
```

多个if,elif

```plain
if    <条件表达式>
    then
            代码1
elif    <条件表达式>
    then
        代码2
elif    <条件表达式>
    then
        代码3
else
    代码3
fi
```

<!-- OCR_START -->
- 开始
- elif
- else
- 条件表达式
- 条件表达式2
- then
- 命令集1
- 命令集2
- 命令集3
- 结束
<!-- OCR_END -->

  

## 单分支实践
1.将超哥之前教的条件测试语句，改造为if条件语句

```plain
[root@chaogelinux ~]# [ -f /etc/hosts ] && echo yes
yes
[root@chaogelinux ~]# [[ -f /etc/hosts ]] && echo yes
yes
[root@chaogelinux ~]# test -f /etc/hosts && echo yes
yes
```

改造脚本

```plain
[root@chaogelinux shell_program]# cat if_1.sh
#!/bin/bash

if [ -f /etc/hosts ]
    then
        echo "[ ] ok "
fi

if [[ -f /etc/hosts ]]
    then
       echo "[[ ]] ok"
fi

if test -f /etc/hosts
    then
        echo "test ok"
fi
```

  
执行

```plain
[root@chaogelinux shell_program]# bash if_1.sh
[ ] ok
[[ ]] ok
test ok
```

## 开发系统监控脚本
分析需求，开发shell脚本，检测内存剩余，可用内存小于100M的时候，发邮件报警给管理员，且加入crontab，每三分钟检查一次内存情况。

1. 获取当前内存
2. 配置邮件报警
3. 判断内存值是否小于100M，if判断
4. 开发shell脚本
5. 脚本加入crontab

### 开发过程
```plain
1.获取内存
total 系统总的可用物理内存大小
used 已被使用的物理内存大小
free 还有多少物理内存可用
shared 被共享使用的物理内存大小
buff/cache 被 buffer 和 cache 使用的物理内存大小
available 还可以被 应用程序 使用的物理内存大小

# 命令
[root@chaogelinux shell_program]# free -m
              total        used        free      shared  buff/cache   available
Mem:           1838        1315          78          16         444         328
Swap:             0           0           0

注意，不同电脑看到的结果不一样
超哥这里的电脑
# awk NR==行号，$NF最后一个字段

# 获取可用内存
[root@chaogelinux shell_program]# free -m| awk 'NR==2 {print $NF}'
328

# 脚本开发
# 这里需要提前配置好mail发邮件的设置，超哥就不演示了
[root@chaogelinux shell_program]# cat free_1.sh
#!/bin/bash
FreeMem=`free -m|awk 'NR==2 {print $NF}'`
CHARS="Current memory is $FReeMem."

if [ "$FreeMem" -lt 100 ]
    then
        echo $CHARS|tee /tmp/messages.txt
        mail -s "`date +%F-%T`$CHARS" yc_uuu@163.com < /tmp/messages.txt
fi

# 脚本加入定时任务
[root@chaogelinux shell_program]# crontab -l
*/3 * * * * /bin/bash /shell_program/free_1.sh &>/dev/null
```

## 读数比较大小
单分支脚本

```plain
[root@chaogelinux shell_program]# cat if_read.sh
#!/bin/bash
a=$1
b=$2
if [ $a -lt $b ];then
    echo "yes,$a less than $b"
    exit 0
fi

if [ $a -eq $b ];then
    echo "yes,$a equal $b"
    exit 0
fi

if [ $a -gt $b ];then
    echo "yes,$a grather than $b"
    exit 0
fi
```

执行

```plain
[root@chaogelinux shell_program]# bash if_read.sh 4 3
yes,4 grather than 3
[root@chaogelinux shell_program]# bash if_read.sh 1 3
yes,1 less than 3
```

  
多分支脚本

```plain
[root@chaogelinux shell_program]# cat if_read2.sh
#!/bin/bash

a=$1
b=$2
if [ $a -lt $b ];then
    echo "yes, $a less than $b"
elif [ $a -eq $b ];then
    echo "yes, $a equal $b"
else [ $a -gt $b ]
    echo "yes,$a greater than $b"
fi
```

执行  

```plain
[root@chaogelinux shell_program]# bash if_read2.sh 3 4
yes, 3 less than 4
[root@chaogelinux shell_program]# bash if_read2.sh 3 3
yes, 3 equal 3
[root@chaogelinux shell_program]# bash if_read2.sh 3 1
yes,3 greater than 1
```

## if实战开发
### 开发nginx以及mysql监控脚本
监控服务的理念

监控mysql的思路

+ 端口netstat，ss，lsof监控

```plain
[root@chaogelinux ~]# netstat -tunlp|grep 3380 |wc -l
1

# 通过名字找更为合适
[root@chaogelinux ~]# netstat -tunlp|grep mysql |wc -l
1

# ss
[root@chaogelinux ~]# ss -tunlp|grep mysql | wc -l
1

# lsof命令
[root@chaogelinux ~]# lsof -i tcp:3380
COMMAND   PID  USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
mysqld  20327 mysql   61u  IPv6 3356432      0t0  TCP *:sns-channels (LISTEN)
```

远程监测mysql的端口方法

```plain
[root@chaogelinux ~]# yum install telnet nmap nc -y
# nmap
[root@chaogelinux ~]# nmap 127.0.0.1 -p 3380 |grep open |wc -l
1

#telnet
[root@chaogelinux ~]# echo -e "\n" |telnet 127.0.0.1 3380 2>/dev/null|grep Connected |wc -l
1
```

检查进程

```plain
[root@chaogelinux ~]# ps -ef|grep mysql|grep -v grep |wc -l
1
```

  

## 开发代码连接数据库
> 通过访问应用程序接口，读取数据库，查看是否正确读取
>
> 通过编写php，python代码，尝试连接数据库
>

前提，搞好linux的数据库依赖环境

php

```plain
yum remove php-mysql
yum install php-mysqlnd php

[root@chaogelinux shell_program]# cat mysql_test.php
<?php
$link_id=mysql_connect('localhost','root','chaoge888') or mysql_error();
if ($link_id){
    echo "mysql successful,chaoge 666~~!";
}else{
    echo mysql_error();
}
?>

# 运行

[root@chaogelinux shell_program]# php mysql_test.php
mysql successful,chaoge 666~~![root@chaogelinux shell_program]#
```

python

```plain
1.安装依赖
[root@chaogelinux shell_program]# yum install python3 python3-devel python3-pip

[root@chaogelinux shell_program]# pip3 install PyMySQL

2.开发代码，注意python代码，缩进关系要明确
[root@chaogelinux shell_program]# cat test_python_mysql.py
import pymysql

db = pymysql.connect(host='localhost',
                             port=3380,
                             user='root',
                             password='chaoge888',
                             db='mysql',
                             charset='utf8')

cursor=db.cursor()
cursor.execute("Select version()")

data=cursor.fetchone()

print("数据库连接正确，数据库版本是：%s"%data)
db.close()
```

  

## Shell监控mysql脚本开发
这里小于老师给出多种答案，提供大家参考学习

```plain
#!/bin/bash
echo "-----方法1----"
if [ `netstat -tunlp|grep mysql |wc -l` = "1" ]
    then
        echo "MySQL is running。"
else
    echo "MySQL is Stopped。"
    #systemctl start mariadb
fi

echo "-----方法2----"
if [  `ss -tunlp|grep mysql | wc -l` -eq "1" ]
    then
        echo "MySQL is running。"
else
    echo "MySQL is Stopped。"
    #systemctl start mariadb
fi

echo "-----方法3----"
if [  `lsof -i tcp:3380|wc -l` -gt 0 ]
    then
        echo "MySQL is running。"
else
    echo "MySQL is Stopped。"
    #systemctl start mariadb
fi

echo "-----方法4----"
python3 /shell_program/test_python_mysql.py

if [ "$?"  -eq 0 ]
    then
        echo "MySQL is running。"
else
    echo "MySQL is Stopped。"
    #systemctl start mariadb
fi

echo "-----方法5----"
php /shell_program/mysql_test.php

if [ "$?"  -eq 0 ]
    then
        echo "MySQL is running。"
else
    echo "MySQL is Stopped。"
    #systemctl start mariadb
fi
```

## rsync启动脚本开发
1.rsync基础环境监察

```plain
[root@chaogelinux shell_program]# rpm -qa rsync
rsync-3.1.2-6.el7_6.1.x86_64

[root@chaogelinux shell_program]# ls -l  /etc/rsyncd.conf
-rw-r--r-- 1 root root 458 4月  26 2019 /etc/rsyncd.conf

# 启动服务
[root@chaogelinux shell_program]# /usr/bin/rsync --daemon

# 检查服务
[root@chaogelinux shell_program]# netstat -tunlp|grep 873
tcp        0      0 0.0.0.0:873             0.0.0.0:*               LISTEN      1809/rsync
tcp6       0      0 :::873                  :::*                    LISTEN      1809/rsync

# 停止rsync
[root@chaogelinux shell_program]# pkill rsync
[root@chaogelinux shell_program]# netstat -tunlp|grep 873
```

完整rsync脚本，可以模仿/etc/init.d/network开发

```plain
#!/bin/bash
# author: yuchao
# -ne 不等于  $# 传递给脚本或函数的参数个数。
# $0 脚本名
if [ $# -ne 1 ]
    then
        echo "Usage: $0 {start|stop|restart}"
        exit 1
fi

if [ "$1" = "start" ]
    then 
        /usr/bin/rsync --daemon
        sleep 2
        if [ `netstat -tunlp|grep rsync|wc -l` -ge 1 ]
            then    
                echo "Rsync is started."
                exit 0
        fi
elif [  "$1" = "stop" ]
    then
        killall rsync &>/dev/null
        sleep 2
        if [ `netstat -tunlp|grep rsync|wc -l` -eq 0 ]
            then
                echo "Rsync is stopped."
                exit 0
        fi
elif    [ "$1" = "restart" ]
    then
        killall rsync
        sleep 1
        killpro=`netstat -tunlp|grep rsync|wc -l`
        /usr/bin/rsync --daemon
        sleep 1
        startpro=`netstat -tunlp|grep rsync|wc -l`
        if [ $killpro -eq 0 -a $startpro -ge 1 ]
            then
                echo "rsyncd is restarted."
                exit 0
        fi
else
    echo "Usage: $0 {start|stop|restart}"
        exit 1
fi

# 添加开机自启脚本
chkconfig --list rsyncd
```

## 作业练习
同理，大家也可以自行扩展，例如nginx，redis服务的状态监控  

# 03函数shell开发
## 函数是什么

先看linux的别名

```plain
[root@chaogelinux ~]# alias
alias cls='clear'
alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
```

别名的功能是简化命令操作，这个大家都知道，让命令更易读，易用。

> 函数，就是将shell脚本里需要多次被调用的相同代码，组合起来，称之为函数体。
>
> 并且我们要给这个函数体，起个别名，就叫做，函数名。
>
> 以后想要用这个函数体时，使用这个函数名，就可以了。
>

## 使用函数好处
+ 相同的程序定义为函数，减少整个程序的代码数量，提高开发效率，让你少写点代码，有时间早点下班回家休息
+ 增加程序可读性，易读性，容易管理

## 定义函数
通过function系统关键字定义函数

```plain
# 标准shell语法
function 函数名(){
    代码。。。
    return 返回值
}

# 简写，省去括号，不建议这么用

function 函数名{
    代码。。。
    return 返回值
}

# 更简化的写法，
函数名(){
    代码。。。
    return 返回值
}
```

## 执行函数
有关函数执行的基础概念

+ 执行shell函数，直接写函数名字即可，无需添加其他内容
+ 函数必须先定义，再执行，shell脚本自上而下加载
+ 函数体内定义的变量，称之为局部变量
+ 函数体内需要添加return语句，作用是退出函数，且赋予返回值给调用该函数的程序，也就是shell脚本
+ return语句和exit不同
- return是结束函数的执行，返回一个（退出值、返回值）
- exit是结束shell环境，返回一个（退出值、返回值）给当前的shell
+ 函数如果单独写入一个文件里，需要用source读取
+ 函数内，使用local关键字，定义局部变量。

## 函数基础实践
> 先定义函数、再执行函数
>
> 场景1.
>
> 函数体，和调用函数，写在同一个脚本
>

```plain
[root@chaogelinux shell_program]# cat func1.sh
#!/bin/bash

pyyu(){
    echo "超哥你好，你的linux讲的蛮有意思的"
}

function chaochao(){
    echo "努力学好shell编程自动化，奥力给"
}

# 执行函数
pyyu
chaochao
```

执行

```plain
[root@chaogelinux shell_program]# bash func1.sh
超哥你好，你的linux讲的蛮有意思的
努力学好shell编程自动化，奥力给
```

> 场景2:
>
> 函数定义，执行不在一个脚本，更为专业的操作
>
> 从文件中读取函数，加载
>

```plain
1.自定义函数，函数体写入文件中
[root@chaogelinux shell_program]# cat my_func.sh
#!/bin/bash

pyyu(){
    echo "Hello~pyyu"
}

2.开发一个脚本，调用该函数
[root@chaogelinux shell_program]# cat func2.sh
#!/bin/bash
# 判断该文件是否存在，在则加载，否则退出
[ -f /shell_program/my_func.sh ] && . /shell_program/my_func.sh || exit

# 读取该文件后，该文件中定义的函数，会被加载到当前shell环境
# 可以执行自定义的函数
pyyu

[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# bash func2.sh
Hello~pyyu
```

加载该函数到当前的shell环境

```plain
[root@chaogelinux shell_program]# pyyu
-bash: pyyu: 未找到命令
[root@chaogelinux shell_program]# source /shell_program/my_func.sh
[root@chaogelinux shell_program]# pyyu
Hello~pyyu
[root@chaogelinux shell_program]# set |grep pyyu
_=pyyu
pyyu ()
    echo "Hello~pyyu"
```

### 给脚本传入参数
修改自定义函数的文件  

```plain
[root@chaogelinux shell_program]# cat my_func.sh
#!/bin/bash

pyyu(){
    echo "Hello~pyyu"
}

helloPyyu(){
    echo "你给脚本传入的参数依次是：$1 、$2、$3、参数个数一共：$#"
}
```

开发执行函数的脚本func2.sh

```plain
[root@chaogelinux shell_program]# cat func2.sh
#!/bin/bash
# 判断该文件是否存在，在则加载，否则退出
[ -f /shell_program/my_func.sh ] && . /shell_program/my_func.sh || exit

# 读取该文件后，该文件中定义的函数，会被加载到当前shell环境
# 可以执行自定义的函数
pyyu

# 执行第二个函数，且给函数传入参数
helloPyyu $1 $2 $3
```

执行脚本

```plain
[root@chaogelinux shell_program]# bash func2.sh yu chao heihei
Hello~pyyu
你给脚本传入的参数依次是：yu 、chao、heihei、参数个数一共：3
```

图解  

<!-- OCR_START -->
修改自定义函数的文件
[root@chaogelinux
shell_program]# cat my_func.sh
#!/bin/bash
pyyu(){
echo "Hello~pyyu"
helloPyyu(){
echo
你给脚本传入的参数依次是：$1、$2、$3、参数个数一共：$#"
开发执行函数的脚本func2.sh
[root@chaogelinux shell_program]# cat func2.sh
#判断该文件是否存在，在则加载，否则退出
[ -f /shell_program/my_func.sh ] && . /shell_program/my_func.sh Il exit
#读取该文件后，该文件中定义的函数，会被加载到当前shell环境
#可以执行自定义的函数
#执行第二个函数，且给函数传入参数
helloPyyu $1 $2 $3
执行脚本
[root@chaogelinux shell_program]# bash func2.sh yu chao heihei
你给脚本传入的参数依次是：yu、chao、heihei、参数个数一共：3
<!-- OCR_END -->

  

## 开发URL检测脚本
功能：给脚本传入参数，检测url是否正常

```plain
#!/bin/bash
if  [ "$#" -ne 1 ]
    then
        echo "Usage: $0 url"
        exit 1
fi

# 利用wget命令测试访问
wget --spider -q -o /dev/null --tries=1 -T 5 $1

if [ "$?" -eq 0 ]
    then
        echo "$1 is yes."
else
    echo "$1 is no."
fi
```

> 现在超哥希望大家能给该脚本，改造为函数执行
>
> 思考，函数是干什么的？封装功能的
>

函数版本shell脚本

check_url_func3.sh

```plain
#!/bin/bash

# 帮助函数
function usage(){
    echo "Usage: $0 url"
    exit 1
}

# 检测url的函数
check_url_func(){

  # 利用wget命令测试访问
  wget --spider -q -o /dev/null --tries=1 -T 5 $1

  if [ "$?" -eq 0 ]
    then
      echo "$1 is yes."
  else
    echo "$1 is no."
  fi
}

# 程序开发的习惯，设置一个入口函数，对需要执行的函数统一管理
# 我们可以在脚本中定义很多函数，到底执行哪一个，进行管理
main(){
    # 如果用户传入的参数数量不等于1，表示用法有误
    if [ $# -ne 1 ]
        then
            usage # 执行该帮助函数
    fi
    # 否则就执行正确的函数，以及传入的参数
    check_url_func $1
}

# 这里的特殊变量$*，是将所有传入进来的参数，当作一个整体，是常见用法
main $*
```

执行脚本

```plain
# 正确执行
[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cn
www.pythonav.cn is yes.

# 参数传入个数不正确的情况
[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cn 123
Usage: check_url_func3.sh url
[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cn 123 qweqwe
Usage: check_url_func3.sh url

# 演示网站挂了
[root@chaogelinux shell_program]# nginx -s stop
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cn
www.pythonav.cn is no.
[root@chaogelinux shell_program]# nginx
[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cn
www.pythonav.cn is yes.
```

添加功能，让结果显示的更专业

```plain
#!/bin/bash
# Use LSB init script functions for printing messages, if possible
#
lsb_functions="/lib/lsb/init-functions"
if test -f $lsb_functions ; then
  . $lsb_functions
else
  # Include non-LSB RedHat init functions to make systemctl redirect work
  init_functions="/etc/init.d/functions"
  if test -f $init_functions; then
    . $init_functions
  fi
  log_success_msg()
  {
    echo " SUCCESS! $@"
  }
  log_failure_msg()
  {
    echo " ERROR! $@"
  }
fi

# 帮助函数
function usage(){
    echo "Usage: $0 url"    
    exit 1
}

# 检测url的函数
check_url_func(){

  # 利用wget命令测试访问
  wget --spider -q -o /dev/null --tries=1 -T 5 $1

  if [ "$?" -eq 0 ]
    then
    log_success_msg   "$1 is yes."  
  else
    log_failure_msg "$1 is no."        
  fi
}

# 程序开发的习惯，设置一个入口函数，对需要执行的函数统一管理
# 我们可以在脚本中定义很多函数，到底执行哪一个，进行管理
main(){
    # 如果用户传入的参数数量不等于1，表示用法有误
    if [ $# -ne 1 ]
        then
            usage # 执行该帮助函数
    fi
    # 否则就执行正确的函数，以及传入的参数
    check_url_func $1
}

# 这里的特殊变量$*，是将所有传入进来的参数，当作一个整体，是常见用法
main $*
```

执行结果

```plain
[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cn
www.pythonav.cn is yes.                                    [  确定  ]

[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cnw
www.pythonav.cnw is no.                                    [失败]
```

<!-- OCR_START -->
[root@chaogelinux shell_program]# bash check_url_func3.sh www.pythonav.cn
www.pythonav.cn is yes.
[确定]
www.pythonav.cnwisno.
[失败]
<!-- OCR_END -->

## 开发rsync起停脚本
当然超哥这里讲的是函数版本  

```plain
[root@chaogelinux shell_program]# touch /etc/init.d/cc_rsyncd

#!/bin/bash
# Use LSB init script functions for printing messages, if possible
# 
lsb_functions="/lib/lsb/init-functions"
if test -f $lsb_functions ; then
  . $lsb_functions
else
  # Include non-LSB RedHat init functions to make systemctl redirect work
  init_functions="/etc/init.d/functions"
  if test -f $init_functions; then
    . $init_functions
  fi
  log_success_msg()
  {
    echo " SUCCESS! $@"
  }
  log_failure_msg()
  {
    echo " ERROR! $@"
  }
fi

function usage(){
    echo "Usage: $0 {start|stop|restart}"
    exit 1
}

function start(){
        /usr/bin/rsync --daemon
        sleep 1
        if [ `netstat -tunlp|grep rsync|wc -l` -ge "1" ]
            then
                log_success_msg "rsyncd is started."
        else
              log_failure_msg "Rsyncd isn't started. "
        fi    
}

function stop(){
    killall rsync &>/dev/null
    sleep 2
    if [ `netstat -tunlp|grep rsync|wc -l` -eq "0" ]
        then
            log_success_msg "Rsyncd is stopped"
    else
            log_failure_msg "Rsyncd isn't stopped. "
    fi
    }

function main(){
    if [ "$#" -ne "1" ]
        then
            usage
    fi

    if [ "$1" = "start" ]
        then
            start
    elif [ "$1" = "stop" ]
        then    
            stop
    elif [ "$1" = "restart" ]
        then
            stop
            sleep 1
            start
    else
        usage
    fi
}    

# 程序入口
main $*
```

执行脚本

```plain
[root@chaogelinux shell_program]# /etc/init.d/cc_rsyncd stop
Rsyncd is stopped                                          [  确定  ]
[root@chaogelinux shell_program]# /etc/init.d/cc_rsyncd start
rsyncd is started.                                         [  确定  ]
[root@chaogelinux shell_program]# /etc/init.d/cc_rsyncd restart
Rsyncd is stopped                                          [  确定  ]
rsyncd is started.                                         [  确定  ]
```

希望大家学习超哥开发脚本的习惯，实现高度的模块化，对功能封装，这样观看美观，且专业规范。  

# 04多分支case语句
## case语句开发


<!-- OCR_START -->
> 超哥要开始讲CASE语句了
<!-- OCR_END -->



case语句用在当脚本中需要频繁使用if、elif、else时候，能够简化繁琐的if判断。

## case语法
```plain
case "变量"    in 
    值1)
            代码1。。
            ;;
    值2)
            代码2。。
            ;;
    *)
            代码3。。
esac
```

> 解释：
>
> case将获取的变量的值和表达式的条件值比较，匹配上了就执行对应的代码，到分号结束。
>

特殊理解下

```plain
case "找老公" in
     家里十套房)
             没问题，嫁了!
             ;;
     家里有背景)
             没问题，嫁了！
             ;;
     男孩在努力的拼搏)
             先加个微信，聊一聊！
             ;;
         *)
             我还有事，先走了！886
esac
```

图解

<!-- OCR_START -->
- 开始
- case“变量”
- 匹配值1
- 假→匹配值2
- 假一>匹配值3
- 假—
- 匹配
- 命令集1
- 命令集2
- 命令集3
- 命令集4
- esac结束
<!-- OCR_END -->

  
 

## case条件语句实践
猜用户输入的数字

```plain
[root@chaogelinux shell_program]# cat case_1.sh
#!/bin/bash

read -p "Please input a number:" num
case "$num" in
    1)
        echo "你输入的是1"
        ;;
    2)
        echo "你输入的是2"
        ;;
    [3-9])
        echo "你输入的是3～9的数字：$num"
        ;;
    *)
        echo "你输入的全不对，退下吧"
        exit;
        ;;
esac
```

执行结果

```plain
[root@chaogelinux shell_program]# bash case_1.sh
Please input a number:2
你输入的是2
[root@chaogelinux shell_program]# bash case_1.sh
Please input a number:1
你输入的是1
[root@chaogelinux shell_program]# bash case_1.sh
Please input a number:3
你输入的是3～9的数字：3
[root@chaogelinux shell_program]# bash case_1.sh
Please input a number:5
你输入的是3～9的数字：5
[root@chaogelinux shell_program]# bash case_1.sh
Please input a number:0
你输入的全不对，退下吧
```

大家会发现，case语句，笔记if简单了

### 开发一个菜单脚本
学一个字体加颜色  

```plain
[root@chaogelinux shell_program]# echo -e "\E[1;31m红色字\E[0m"
红色字

[root@chaogelinux shell_program]# echo -e "\033[31m红色字\033[0m"
红色字
```

有关linux输出颜色，大家可以自行搜索语法，无需记忆，搜索使用即可

脚本代码如下

```plain
[root@chaogelinux shell_program]# cat case_menu.sh
#!/bin/bash
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
RES='\E[0m'

# 帮助函数
usage(){
    echo "Usage: $0 {1|2|3|4}"
    exit 1
}

menu(){
    cat <<END
        1.apple
        2.banana
        3.orange
END
}

choose(){
    read -p "请选择一种水果：" fruit
    case "$fruit" in
        1)
            echo -e "${RED_COLOR}allple${RES}"
            ;;
        2)
            echo -e "${GREEN_COLOR}pear${RES}"
            ;;
        3)
            echo -e "${YELLOW_COLOR}banana${RES}"
            ;;
        *)
            usage
    esac
}

main(){
    menu
    choose
}

main
```

<!-- OCR_START -->
- [root@chaogelinux shell_program]# bash case_menu.sh
- 1.apple
- 2.banana
- 3.orange
- 请选择一种水果：a
- Usage: case_menu.sh {1121314}
- [root@chaogelinux shell_program]#
- 请选择一种水果：1
- allple
- 请选择一种水果：2
- pear
- 请选择一种水果：3
- banana
<!-- OCR_END -->

### Linux系统脚本范例
case主要还是用于起停脚本，适合变量值较少，且为固定数字或字符的情况。

如/etc/init.d/mysql部分case语句代码

```plain
# source other config files
[ -f /etc/default/mysql ] && . /etc/default/mysql
[ -f /etc/sysconfig/mysql ] && . /etc/sysconfig/mysql
[ -f /etc/conf.d/mysql ] && . /etc/conf.d/mysql

case "$mode" in
  'start')
    # Start daemon

    # Safeguard (relative paths, core dumps..)
    cd $basedir

    echo $echo_n "Starting MariaDB"
    if test -x $bindir/mysqld_safe
    then
      # Give extra arguments to mysqld with the my.cnf file. This script
      # may be overwritten at next upgrade.
      $bindir/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path" "$@" &
      wait_for_ready; return_value=$?

      # Make lock for RedHat / SuSE
      if test -w "$lockdir"
      then
        touch "$lock_file_path"
      fi

      exit $return_value
    else
      log_failure_msg "Couldn't find MariaDB server ($bindir/mysqld_safe)"
    fi
    ;;

  'stop')
    # Stop daemon. We use a signal here to avoid having to know the
    # root password.

    if test -s "$mysqld_pid_file_path"
    then
      mysqld_pid=`cat "$mysqld_pid_file_path"`

      if su_kill -0 $mysqld_pid ; then
        echo $echo_n "Shutting down MariaDB"
        su_kill $mysqld_pid
        # mysqld should remove the pid file when it exits, so wait for it.
        wait_for_gone $mysqld_pid "$mysqld_pid_file_path"; return_value=$?
      else
        log_failure_msg "MariaDB server process #$mysqld_pid is not running!"
        rm "$mysqld_pid_file_path"
      fi

      # Delete lock for RedHat / SuSE
      if test -f "$lock_file_path"
      then
        rm -f "$lock_file_path"
      fi
      exit $return_value
    else
      log_failure_msg "MariaDB server PID file could not be found!"
    fi
    ;;

  'restart')
    # Stop the service and regardless of whether it was
    # running or not, start it again.
    if $0 stop  "$@"; then
      if ! $0 start "$@"; then
        log_failure_msg "Failed to restart server."
        exit 1
      fi
    else
      log_failure_msg "Failed to stop running server, so refusing to try to start."
      exit 1
    fi
    ;;

  'reload'|'force-reload')
    if test -s "$mysqld_pid_file_path" ; then
      read mysqld_pid <  "$mysqld_pid_file_path"
      su_kill -HUP $mysqld_pid && log_success_msg "Reloading service MariaDB"
      touch "$mysqld_pid_file_path"
    else
      log_failure_msg "MariaDB PID file could not be found!"
      exit 1
    fi
    ;;
  'status')
    # First, check to see if pid file exists
    if test -s "$mysqld_pid_file_path" ; then
      read mysqld_pid < "$mysqld_pid_file_path"
      if su_kill -0 $mysqld_pid ; then
        log_success_msg "MariaDB running ($mysqld_pid)"
        exit 0
      else
        log_failure_msg "MariaDB is not running, but PID file exists"
        exit 1
      fi
    else
      # Try to find appropriate mysqld process
      mysqld_pid=`pgrep -f $libexecdir/mysqld`

      # test if multiple pids exist
      pid_count=`echo $mysqld_pid | wc -w`
      if test $pid_count -gt 1 ; then
        log_failure_msg "Multiple MariaDB running but PID file could not be found ($mysqld_pid)"
        exit 5
      elif test -z $mysqld_pid ; then
        if test -f "$lock_file_path" ; then
          log_failure_msg "MariaDB is not running, but lock file ($lock_file_path) exists"
          exit 2
        fi
        log_failure_msg "MariaDB is not running"
        exit 3
      else
        log_failure_msg "MariaDB is running but PID file could not be found"
        exit 4
      fi
    fi
    ;;
  'configtest')
    # Safeguard (relative paths, core dumps..)
    cd $basedir
    echo $echo_n "Testing MariaDB configuration syntax"
    daemon=$bindir/mysqld
    if test -x $libexecdir/mysqld
    then
      daemon=$libexecdir/mysqld
    elif test -x $sbindir/mysqld
    then
      daemon=$sbindir/mysqld
    elif test -x `which mysqld`
    then
      daemon=`which mysqld`
    else
      log_failure_msg "Unable to locate the mysqld binary!"
      exit 1
    fi
    help_out=`$daemon --help 2>&1`; r=$?
    if test "$r" != 0 ; then
      log_failure_msg "$help_out"
      log_failure_msg "There are syntax errors in the server configuration. Please fix them!"
    else
      log_success_msg "Syntax OK"
    fi
    exit $r
    ;;
  'bootstrap')
      if test "$_use_systemctl" == 1 ; then
        log_failure_msg "Please use galera_new_cluster to start the mariadb service with --wsrep-new-cluster"
        exit 1
      fi
      # Bootstrap the cluster, start the first node
      # that initiate the cluster
      echo $echo_n "Bootstrapping the cluster.. "
      $0 start $other_args --wsrep-new-cluster
      exit $?
      ;;
  *)
      # usage
      basename=`basename "$0"`
      echo "Usage: $basename  {start|stop|restart|reload|force-reload|status|configtest|bootstrap}  [ MariaDB server options ]"
      exit 1
    ;;
esac
```

# 05_while循环语句
## 循环

循环非常重要，且常见

+ 你每天循环的路线去上班
+ 你每天都要吃一个煎饼果子
+ 你每天都要洗头
+ 。。。

遇见特殊情况，循环中断

+ 公司今天放假
+ 煎饼果子没出摊
+ 你今天偷懒不想洗头
+ 。。

## while循环
循环语句在shell中有

+ While
+ until
+ for
+ select

while常用于守护进程，持续运行的程序

语法

```plain
while <条件表达式>
do
    代码。。。
done
```

<!-- OCR_START -->
- While循环开始
- While循环条件
- 表达式
- 持续
- 循环，
- do
- 直到
- 条件
- 表达
- 式不
- 命令集
- 满足
- done
- done结束
<!-- OCR_END -->

## until循环
until循环和while循环类似，但是until是直到的含义

+ 在条件不成立时，执行循环体
+ 条件成立后，循环结束

## shell循环实践
每两秒输出一次系统负载

```plain
[root@chaogelinux shell_program]# cat while_1.sh
#!/bin/bash

while [ 1 -lt 2 ]
do
    uptime
    sleep 2
done

# 执行
[root@chaogelinux shell_program]# bash while_1.sh
 21:30:14 up 16 days,  7:51,  1 user,  load average: 0.00, 0.01, 0.05
 21:30:16 up 16 days,  7:51,  1 user,  load average: 0.00, 0.01, 0.05
^C
```

负载信息写入文件，且在后台运行

```plain
[root@chaogelinux shell_program]# cat while_1.sh
#!/bin/bash

while true
do
    uptime >> /tmp/uptime.log
    sleep 2
done
```

后台运行脚本

```plain
[root@chaogelinux shell_program]# bash while_1.sh &
[1] 21535

# 查看任务
[root@chaogelinux shell_program]# jobs
[1]+  运行中               bash while_1.sh &

# 查看日志

[root@chaogelinux shell_program]# tail -f /tmp/uptime.log
 21:32:29 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:31 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:33 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:35 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:37 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:39 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:41 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:43 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:45 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:47 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:49 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
 21:32:51 up 16 days,  7:53,  1 user,  load average: 0.00, 0.01, 0.05
```

## 后台运行命令的方法
+ command &
+ nohup command &
+ screen命令保持会话

<!-- OCR_START -->
- 用法
- 说明
- sh while1.sh &
- 把脚本while1.sh放到后台执行（在后台运行脚本时常用的方法）
- ctl+c
- 停止执行当前脚本或任务
- ctl+z
- 暂停执行当前脚本或任务
- bg
- 把当前脚本或任务放到后台执行，bg可以理解为background
- 把当前脚本或任务放到前台执行，如果有多个任务，可以使用fg加任务编号调出对应
- fg
- 的脚本任务，如fg2，是指调出第二个脚本任务，fg可以理解为frontground
- jobs
- 查看当前执行的脚本或任务
- 关闭执行的脚本任务，即以“kill%任务编号”的形式关闭脚本，这个任务编号，可以
- kill
- 通过jobs来获得
<!-- OCR_END -->

## 进程管理命令
+ Kill,killall,pkill
+ ps,pstree
+ top
+ nohup，用户退出系统后继续后台工作
+ pgrep，进行匹配过滤
+ strace，进程追踪
+ ltrace，进程调用函数追踪

## 实践循环
打印数字54321

单中括号  

```plain
[root@chaogelinux shell_program]# cat while_2.sh
#!/bin/bash
i=5

while [ $i -gt 0 ]  # 条件判断，变量大于0时成立
do
    echo "$i"
    ((i--))  # i变量的自减一
done
```

双小括号

```plain
[root@chaogelinux shell_program]# cat while_2.sh
#!/bin/bash
i=5

while (( i > 0 ))  # 双小括号条件判断，变量大于0时成立
do
    echo "$i"
    ((i--))  # i变量的自减一
done
```

双中括号

```plain
[root@chaogelinux shell_program]# cat while_2.sh
#!/bin/bash
i=5

while [[ $i > 0 ]]  # 条件判断，变量大于0时成立
do
    echo "$i"
    ((i--))  # i变量的自减一
done
```

  
脚本传递数字

```plain
[root@chaogelinux shell_program]# cat while_2.sh
#!/bin/bash
i="$1"
while [ $i -gt 0 ]
do
    echo $i
    ((i--))
done
[root@chaogelinux shell_program]# bash while_2.sh 10
10
9
8
7
6
5
4
3
2
1
```

### 使用until命令
可以看出就是和while相反的条件  

```plain
[root@chaogelinux shell_program]# cat until_1.sh
#!/bin/bash
i=5
until [ $i -lt 1  ]
do
    echo $i
    ((i--))
done
[root@chaogelinux shell_program]# bash until_1.sh
5
4
3
2
1
```

## 实践循环二
> 求1～100的和
>
> 提示：双括号用于变量计算
>

```plain
[root@chaogelinux shell_program]# cat while_3.sh
#!/bin/bash
i=1
sum=0
while [ $i -le 100  ]
do
    ((sum=sum+i)) # 把i当前值和sum相加，且重新赋值
    ((i++))# 每次加一，也就是1，2，3，4.。。
done
[ "$sum" -ne 0 ] && printf "1～100总和：$sum\n"
[root@chaogelinux shell_program]#

# 执行
[root@chaogelinux shell_program]# bash while_3.sh
1～100总和：5050
```

### While生产实践
while监控网站，每隔10s确定一次

```plain
#!/bin/bash
if [ $# -ne 1 ]
    then
        echo "Usage: $0 url"
        exit 1
fi
while true
do
    # 如果结果非1行，表示网站由问题
    if [ `curl -o /dev/null --connect-timeout 5 -s -w "%{http_code}" $1|egrep -w "200|301|302"|wc -l` -ne 1 ]
        then
            echo "$1 website error."
    else
        echo "$1 is ok!"
    fi
sleep 10
done
```

执行

```plain
[root@chaogelinux shell_program]# bash while_check_url.sh www.pythonav.cn
www.pythonav.cn is ok!
www.pythonav.cn is ok!
```

检测多个网站是否正常  

```plain
#!bin/bash
# 定义shell数组
url_list=(
    http://www.pythonav.cn
    http://www.baidu.com
    http://www.taobao.com
)

# 定义一个倒计时的函数
wait(){
    echo  "3秒后，对url进行检查"
    echo
    # for循环
    for i in $(seq 3 -1 1)
    do
        echo "$i"
        sleep 1
    done
    echo "--程序开始开始--"
}

check_url(){
    wait
    for ((i=0;i<`echo ${#url_list[*]}`;i++))
        do
            wget -o /dev/null -T 3 --tries=1 --spider ${url_list[$i]} >/dev/null 2>&1
            if  [ $? -eq 0  ]
                then
                    echo "${url_list[$i]}  is working!!!"
            else
                echo "${url_list[$i]}  is error!!!"

            fi
        done
       ((check_count++))

}

main(){
    while true
        do
            check_url
            echo "-------检查次数是：${check_count}-----------"
            sleep 3
        done
}

main
```

### while读取web日志
> 需求：分析ngixn的日志，把每一行的访问记录，
>
> 计算body_bytes_sent，nginx返回给客户端的响应体的字节数
>
> 计算综合
>

文件资源如下

```plain
[root@chaogelinux logs]# ls -lh access.log
-rw-r--r-- 1 root root 42M 3月  19 21:23 access.log
```

开发while脚本

### shell读取文件的方式
### exec命令读取文件
```plain
exec 执行完命令后，退出所在用户权限

# exec读入文件
exec <FILE
```

exec读取文件

```plain
exec <FILE
sum=0
while read line
do
    cmd
done
```

### cat读取文件
```plain
cat FILE|while read line
do
    cmd
done
```

### while结合done读取数据
在while循环结尾done处，通过输入重定向，读取指定文件

```plain
while read line
do
    cmd
done<FILE
```

## 模拟cat命令
```plain
[root@chaogelinux scripts]# cat cat_while.sh
#!/bin/bash
while read line
do
    echo $line
done<$1
```

执行

```plain
[root@chaogelinux scripts]# bash cat_while.sh /etc/hosts
127.0.0.1 VM_32_137_centos VM_32_137_centos
127.0.0.1 localhost.localdomain localhost
127.0.0.1 localhost4.localdomain4 localhost4

::1 VM_32_137_centos VM_32_137_centos
::1 localhost.localdomain localhost
::1 localhost6.localdomain6 localhost6
```

## 分析nginx日志
利用exec读取文件内容  

```plain
[root@chaogelinux scripts]# cat while_access.sh
#!/bin/bash
sum=0
exec <$1
while read line
do
    size=`echo $line|awk '{print $10}'` # awk截取数据大小
    expr $size + 1 &>/dev/null          # 判断是否是数字
    if [ $? -ne 0  ];then
        continue
    fi
    ((sum=sum+$size)) # 循环的值，累加且赋值
done
echo "${1}:total: ${sum}bytes=`echo $((${sum}/1024))`KB"
```

执行

```plain
[root@chaogelinux scripts]# bash while_access.sh  /opt/ngx112/logs/500-access.log
/opt/ngx112/logs/500-access.log:total:2200902bytes=2149KB
```

## 防DDOS攻击脚本
![1671609123371-d8aae75e-ffa3-4108-91ce-16f64074ddb5.png](img/超哥带你学Shell/image21.png)

分布式拒绝服务（DDoS）攻击是通过大规模互联网流量淹没目标服务器或其周边基础设施，以破坏目标服务器、服务或网络正常流量的恶意行为。

<!-- OCR_START -->
- DDoS攻击示意图
- 装有DDoS攻击程序的
- 主机
- 二级肉鸡，它接受从跳
- 跳板肉鸡
- 板肉鸡发送的命令，执
- 行对服务器的攻击
- 29
- 被攻击
- 服务器
- 黑客
- 受害者
<!-- OCR_END -->

> 作为运维，也需要从一些基础手段，减少服务器被恶意访问，减轻服务器的压力
>
> 思路：
>
> 根据web日志统计网络链接数，监控某个IP的并发连接数，若是短时间内PV达到100，可以证明非正常人发出的请求，如网络爬虫，可以将其流量封禁。
>
> iptables -I INPUT -s ip -j DROP
>
> shell防ddos攻击脚本
>

```plain
#!/bin/bash
file=$1
while true
do
    #过滤出日志的客户端ip地址
    awk "{print $1}" $1|grep -v "^$"|sort|uniq -c >/tmp/access_ip.log
    # 对ip地址文件分析
    exec </tmp/access_ip.log
    while read line
    do
        ip=`echo $line|awk '{print $2}'`
        count=`echo $line|awk '{print $1}'`
        if [ $count -gt 500 ] && [ `iptables -L -n|grep "$ip"|wc -l` -lt 1 ]
            # 如果pv大于500，并且iptables没有封禁该ip
            then
                iptables -I INPUT -s $ip -j DROP
                echo "$line is dropped" >>/tmp/droplist_$(date +%F).log
    fi
  done
  sleep 3600
done
```

### 总结
+ while循环一般用于希望循环运行，持续运行，不退出的应用，例如守护进程在后台运行
+ case语句可以用if语句代替，而当如启停脚本开发时，对固定规则的字符串判断，可以用case

# 06_for循环开发
## for循环


<!-- OCR_START -->
> for循环很强大
<!-- OCR_END -->



for循环语句和while循环类似，但是for主要用于有次数限制的循环，而不是无限循环。

### 语法
> 语法
>
> for循环语句跟着的变量，变量会依次获取in后面的变量值列表内容，以空格分割
>
> 每次取一个，然后进入循环，执行do；done之间的代码
>
> 然后继续循环
>

```plain
for 变量 in 变量取值列表
do
    代码。。
done
```

> for语法2
>
> 还有一种C语言风格的for循环
>

```plain
for ((expr1;expr2;expr3))
do
    代码。。
done
```

<!-- OCR_START -->
- for循环开始
- for循环条件表达式
- 持续
- 循环,
- do
- 直到
- 条件
- 表达
- 式不
- 命令集
- 满足
- done
- 结束
<!-- OCR_END -->

示例

```plain
[root@chaogelinux shell_program]# cat for_test_1.sh
#!/bin/bash

for ((i=1;i<=3;i++))
do
    echo $i
done

# 执行脚本
[root@chaogelinux shell_program]# bash for_test_1.sh
1
2
3
```

解释：

for循环关键字后面的双括号是固定语法，第一个表达式是变量的初始化；第二个是变量的范围设置；第三个变量是变量的自增，自减。

第一个表达式的初始化值，符合第二个的时候，进入循环，执行代码，否则不满足就退出循环。

脚本可以改造为while形式

```plain
[root@chaogelinux shell_program]# cat for_test_while.sh
#!/bin/bash
i=1
while ((i<=3))
do
    echo $i
    ((i++))
done
```

执行结果

```plain
[root@chaogelinux shell_program]# bash for_test_while.sh
1
2
3
```

### 实践
> 竖着、倒序打印10~1
>
> 多种方法
>

```plain
# 1
[root@chaogelinux shell_program]# cat for_test_2.sh
for num in 10 9 8 7 6 5 4 3 2 1
do
    echo $num
done

# 2
[root@chaogelinux shell_program]# cat for_test_2.sh
for num in  {10..1}
do
    echo $num
done

# 3
# -1 步长，也就是倒序，到1结束
[root@chaogelinux shell_program]# cat for_test_2.sh
for num in `seq 10 -1 1`
do
    echo $num
done
```

for循环遍历目录，及其子目录内容

```plain
[root@chaogelinux shell_program]# mkdir -p /tmp/shell_test/{yu,chao,hehe}
[root@chaogelinux shell_program]# ls /tmp/shell_test/
chao  hehe  yu
[root@chaogelinux shell_program]# touch /tmp/shell_test/{1.txt,2.txt}
[root@chaogelinux shell_program]# ls /tmp/shell_test/
1.txt  2.txt  chao  hehe  yu

# 代码
[root@chaogelinux shell_program]# cat for_test_3.sh
for file in `ls /tmp/shell_test/`
do
    echo $file
done
[root@chaogelinux shell_program]# bash for_test_3.sh
1.txt
2.txt
chao
hehe
yu

# 完整脚本
[root@chaogelinux shell_program]# cat for_3.sh
#!/bin/bash

function list_file(){
    for file in `ls $1`
    do
        dir_or_file=$1"/"$file
        # 判断如果该文件是目录类型，就继续寻遍该目录
        if [ -d $dir_or_file ]
            then
                list_file $dir_or_file
            else
                ls $dir_or_file
        fi
   done
}

list_file $1
```

批量修改.txt为.log后缀

```plain
[root@chaogelinux shell_program]# cat for_test_3.sh
cd /tmp/shell_test/
for file in `ls .  |grep "txt$"`
do
    rename "txt" "log" $file
done
[root@chaogelinux shell_program]# ls /tmp/shell_test/
1.txt  2.txt  chao  hehe  yu
[root@chaogelinux shell_program]# bash for_test_3.sh
[root@chaogelinux shell_program]# ls /tmp/shell_test/
1.log  2.log  chao  hehe  yu
```

批量修改文件名，数据源

```plain
[root@chaogelinux shell_test]# touch chaoge{1..10}_666.txt
[root@chaogelinux shell_test]# ls -l
总用量 12
-rw-r--r-- 1 root root    0 3月  24 21:06 1.log
-rw-r--r-- 1 root root    0 3月  24 21:06 2.log
drwxr-xr-x 2 root root 4096 3月  24 21:06 chao
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge10_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge1_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge2_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge3_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge4_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge5_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge6_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge7_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge8_666.txt
-rw-r--r-- 1 root root    0 3月  24 21:21 chaoge9_666.txt
drwxr-xr-x 2 root root 4096 3月  24 21:06 hehe
drwxr-xr-x 2 root root 4096 3月  24 21:06 yu
```

批量修改所有txt文件，666改为777

```plain
[root@chaogelinux shell_program]# cat for_test_4.sh
cd /tmp/shell_test/
for file in `ls *.txt`
do
    mv $file `echo $file|sed 's/666/777/g'`
done
```

> 批量替换所有的*.txt文件，替换例如为chaoge1.txt
>
> 不用for循环，如何操作？
>

```plain
# 直接操作当前目录下所有文件
# 所以不用限制方案，高效即可
[root@chaogelinux shell_test]# rename "_777" "" *.txt
```

打印乘法表

语法备注

```plain
$[] $(()) 

它们是一样的，都是进行数学运算的。支持+ - * / %：分别为 “加、减、乘、除、取模”。但是注意，bash只能作整数运算，对于浮点数是当作字符串处理的。
```

代码

```plain
for ((a=1;a<=9;a++))
do
    for ((b=1;b<=9;b++))
        do
            # 如果a大于等于b
            if [[ a -ge b ]]
                then
                    echo -n "$b * $a = $[a*b]  "
            fi
        done
        echo " "
done
```

每隔两秒访问一次www.pythonav.cn，访问5次

```plain
[root@chaogelinux shell_program]# cat for_test_6.sh
#!/bin/bash
for ((i=0;i<5;i++))
do
        # -s 不输出 -w格式化输出 -o 写入文件
    curl -s -w %{http_code} www.pythonav.cn -o /dev/null
    echo
    sleep 2
done
```

### 高级实践
#### 开发mysql分库备份脚本
开发mysql分库备份脚本  

```plain
UPDATE mysql.user 
SET authentication_string = PASSWORD('chaoge999')
WHERE user = 'root' AND 
      host = 'localhost';

FLUSH PRIVILEGES;
```

脚本

```plain
$(命令) 
`命令`
获取命令执行结果
```

  

```plain
[root@chaogelinux shell_program]# cat mysql_for.sh
#!/bin/bash
MYUSER=root
MYPWD=chaoge999
DBPATH=/mysql_db_back/
MYCMD="mysql -u$MYUSER -p$MYPWD"
MYDUMP="mysqldump -u$MYUSER -p$MYPWD"
[ ! -d "$DBPATH" ] && mkdir $DBPATH
for dbname in `$MYCMD -e "show databases;"|sed '1d'|egrep -v "mysql|schema"`
    do
            # 创建数据库同名文件夹
            mkdir ${DBPATH}/${dbname}_$(date +%F) -p
            # 循环找出所有数据表
            for table in `$MYCMD -e "show tables from $dbname;"|sed '1d'`
            do
            $MYDUMP $dbname $table|gzip > $DBPATH/${dbname}_$(date +%F)/${dbname}_${table}.sql.gz
          done
         done
```

### 批量创建账号，设置密码
```plain
#/bin/bash
# author:超哥
# Use LSB init script functions for printing messages, if possible
#
lsb_functions="/lib/lsb/init-functions"
if test -f $lsb_functions ; then
  . $lsb_functions
else
  # Include non-LSB RedHat init functions to make systemctl redirect work
  init_functions="/etc/init.d/functions"
  if test -f $init_functions; then
    . $init_functions
  fi
  log_success_msg()
  {
    echo " SUCCESS! $@"
  }
  log_failure_msg()
  {
    echo " ERROR! $@"
  }
fi

# 上面是结果美化
user="pyyu"
pwdfile="/tmp/pwd.file"
# seq -w 数字补0
for num in `seq -w 10`
do
    # cut -c3-11 输出字符串的3~11位的数字
    pwd="`echo '$RANDOM'|md5sum|cut -c3-11`"
    useradd $user$num &>/dev/null && \
    echo -e "$user${num}:$pwd" >> $pwdfile
    if [ $? -eq 0 ]
        then
            log_success_msg "$user$num is success create."
    else
          log_failure_msg "$user$num isn't create, fail."
    fi
done
echo "----------------分割线"
chpasswd < $pwdfile

cat $pwdfile && >$pwdfile

# 备注，一键删除该测试数据
# for u in `awk -F ':' '{print $1}'  /etc/passwd|grep pyyu`;do userdel -rf $u;done
```

执行结果

```plain
[root@chaogelinux shell_program]# bash for_pwd.sh
pyyu01 is success create.                                  [  确定  ]
pyyu02 is success create.                                  [  确定  ]
pyyu03 is success create.                                  [  确定  ]
pyyu04 is success create.                                  [  确定  ]
pyyu05 is success create.                                  [  确定  ]
pyyu06 is success create.                                  [  确定  ]
pyyu07 is success create.                                  [  确定  ]
pyyu08 is success create.                                  [  确定  ]
pyyu09 is success create.                                  [  确定  ]
pyyu10 is success create.                                  [  确定  ]
----------------分割线
pyyu01:400a275f1
pyyu02:400a275f1
pyyu03:400a275f1
pyyu04:400a275f1
pyyu05:400a275f1
pyyu06:400a275f1
pyyu07:400a275f1
pyyu08:400a275f1
pyyu09:400a275f1
pyyu10:400a275f1
pyyu01:400a275f1
pyyu02:400a275f1
pyyu03:400a275f1
pyyu04:400a275f1
pyyu05:400a275f1
pyyu06:400a275f1
pyyu07:400a275f1
pyyu08:400a275f1
pyyu09:400a275f1
pyyu10:400a275f1
```

### shell生成随机数
在很多场景下，会用到随机数，掌握随机数生成是很有必要

```plain
Unix和Linux支持多种校验和程序，但强健性最好且使用最为广泛的校验和算法是MD5和SHA-1。md5sum和sha1sum程序可以对数据应用对应的算法来生成校验和。

使用下列命令计算md5sum：

[root@chaogelinux shell_program]# md5sum 吴亦凡.jpg
d41d8cd98f00b204e9800998ecf8427e  吴亦凡.jpg

如上所示，md5sum是一个长度为32个字符的十六进制串。
我们可以将输出的校验和重定向到一个文件中，以备后用：
[root@chaogelinux shell_program]# expr  length 107e4777794da97b144844dc1cf3bb66
32

[root@chaogelinux shell_program]# md5sum 吴亦凡.jpg > 吴亦凡.md5

[root@chaogelinux shell_program]# cat 吴亦凡.md5
d41d8cd98f00b204e9800998ecf8427e  吴亦凡.jpg

# 校验文件 -c, --check           从文件中读取MD5 的校验值并予以检查
[root@chaogelinux shell_program]# md5sum -c 吴亦凡.md5
吴亦凡.jpg: 确定
```

1.通过RANDOM变量实现

RANDOM变量随机数范围在0~32767，可以添加一些字符串增加密码复杂度。  

```plain
[root@chaogelinux shell_program]# for ((i=1;i<=10;i++));do echo $RANDOM;done
7614
25608
27755
29856
20608
17067
9519
21753
23631
28249
```

结合md5sum与RANDOM随机数，并且截取部分字符串

```plain
[root@chaogelinux shell_program]# echo "chao$RANDOM"
chao27691
[root@chaogelinux shell_program]# echo "chao$RANDOM"|md5sum
cf0907be522efe40b2bac9cdcca8071e  -
[root@chaogelinux shell_program]# echo "chao$RANDOM"|md5sum
9cb4d17c30ef1794159b5fc8ffbaad4c  -
# 截取8~15位字符串
[root@chaogelinux shell_program]# echo "chao$RANDOM"|md5sum|cut -c 8-15
3dc1c0c3
[root@chaogelinux shell_program]# echo "chao$RANDOM"|md5sum|cut -c 8-15
d52ff363
```

通过UUID生成

超哥只在这里讲解最常用的方式，生成随机数  

```plain
[root@chaogelinux shell_program]# cat /proc/sys/kernel/random/uuid
455baec7-8b9b-48f9-941e-850d326d6b3e
[root@chaogelinux shell_program]# cat /proc/sys/kernel/random/uuid
edd7711a-e79b-402c-8014-0beb00df3329
```

  
UUID意思是全球通用唯一识别码，其作用是让分布式系统中所有元素都有唯一的辨识信息，它能够使得网络中的任意一台机器都有唯一的UUID编码，因为加入了硬件、时间、机器运行状态等信息计算得出。

# 07_ shell循环控制语句
## 循环控制
前面超哥讲了for、while循环，目前已知for循环可以设置一个边界的条件，用于结束循环。

循环固然很重要，学会中断循环、设置条件也很重要，可以进行复杂的逻辑控制。

来学这几个特殊命令

+ break，中断循环
+ continue，跳过本次循环
+ Exit，退出脚本
+ return，退出函数

break、continue主要用于for、while、if控制程序的走向、

exit用于终止所有语句，退出当前脚本，以及给当前shell返回状态值

return只用在函数内，返回函数执行的状态值

<!-- OCR_START -->
命令
说明
break n
如果省略n，则表示跳出整个循环，n表示跳出循环的层数
如果省略n，则表示跳过本次循环，忽略本次循环的剩余代码，进人循环的下一次循环。
continue n
n表示退到第n层继续循环
退出当前Shell程序，n为上一次程序执行的状态返回值。n也可以省略，在下一个Shell
exit n
里可通过“$?”接收exitn的n值
用于在函数里作为函数的返回值，以判断函数执行是否正确。在下一个Shell里可通过
return n
“$?”接收exitn的n值
<!-- OCR_END -->

## 图解循环控制
break解释

<!-- OCR_START -->
- while循环开始
- for循环开始
- while循环条件表达式
- for循环条件表达式
- 持续
- do
- 循环，
- 直到
- 条件
- 命令集1
- 表达
- 跳出循环
- 式不
- break
- 满足
- 命令集2
- done
- 循环结束
<!-- OCR_END -->

continue解释

<!-- OCR_START -->
- while循环开始
- for循环开始
- while循环条件表达式
- for循环条件表达式
- 持续
- 循环，
- 直到
- 条件
- do
- 表达
- 式不
- 满足
- 命令集1
- 终止本次循
- 命令集2
- 环，继续下
- 一次循环
- done
- 循环结束
<!-- OCR_END -->

exit解释

<!-- OCR_START -->
- while循环开始
- for循环开始
- while循环条件表达式
- for循环条件表达式
- 持续
- do
- 循环，
- 直到
- 条件
- 命令集1
- 表达
- 退出脚本
- 式不
- exit
- 满足
- 命令集2
- done
- 循环结束
<!-- OCR_END -->

## 实践
用于测试 break，continue、exit，return的脚本

```plain
[root@chaogelinux shell_program]# cat break_1.sh
if [ $# -ne 1  ];then
    echo "Usage:$0 {break|continue|exit|return}"
    exit 1
fi

test(){
    for ((i=0;i<=5;i++))
    do
            # 当循环变量i，等于3的时候，执行脚本接收的参数
        if [ $i -eq 3  ];then
            $*; # 这里可能是break，continue，exit，return，看不同的结果
        fi
        echo $i
   done
   echo "我是超哥写的函数，我被执行了"
}
# 执行函数，传入参数
test $*
func_ret=$?
# 如果传入的参数是return，执行下属代码
if [ `echo $*|grep return|wc -l` -eq 1  ]
    then
        echo "return's exit status:$func_ret"
fi
echo "script done."
```

### 不同的执行结果
什么都不加

```plain
[root@chaogelinux shell_program]# bash break_1.sh
Usage:break_1.sh {break|continue|exit|return}
```

break，到3循环结束

```plain
[root@chaogelinux shell_program]# bash break_1.sh break
0
1
2
我是超哥写的函数，我被执行了
script done.
```

continue，循环跳过了3

```plain
[root@chaogelinux shell_program]# bash break_1.sh continue
0
1
2
4
5
我是超哥写的函数，我被执行了
script done.
```

exit，退出脚本，不再执行后续代码

```plain
[root@chaogelinux shell_program]# bash break_1.sh exit
0
1
2
```

指定exit 状态码

```plain
[root@chaogelinux shell_program]# bash break_1.sh "exit 2"
0
1
2
[root@chaogelinux shell_program]# echo $?
2
```

Return，结束当前函数执行

```plain
[root@chaogelinux shell_program]# bash break_1.sh return
0
1
2
return's exit status:0
script done.
```

  

## 分析nginx日志
分析access.log日志，把每一条访问的记录对应的数据大小统计，计算总和。

1.while循环，结合exec，expr命令  

```plain
[root@chaogelinux shell_program]# cat while_nginx.sh
#!/bin/bash
sum=0
exec <$1 # 传入文件数据
while read line
do
    size=`echo $line|awk '{print $10}'`
    expr $size + 1 &>/dev/null
    if [ $? -ne 0  ];then
        continue
    fi
    ((sum=sum+size))
done
echo "$1 总共处理的字节数是：`echo $(($sum/1024/1024))`KB"
[root@chaogelinux shell_program]#
```

执行

```plain
[root@chaogelinux shell_program]# ls
break_1.sh  ngx.log  while_nginx.sh

[root@chaogelinux shell_program]# bash while_nginx.sh ngx.log
ngx.log 总共处理的字节数是：10096KB

[root@chaogelinux shell_program]# bash while_nginx.sh ngx.log
ngx.log 总共处理的字节数是：9MB
```

while循环，结合bash exec，变量子串

```plain
[root@chaogelinux shell_program]# cat while_nginx2.sh
#!/bin/bash
exec <$1
sum=0
while read line
do
    num=`echo $line|awk '{print $10}'`
    [ -n "$num" -a "$num" = "${num//[^0-9]}"  ] || continue
    ((sum=sum+num))
done
echo "$1 总共处理的字节数：`echo $((${sum}/1024/1024))`MB"
```

执行

```plain
[root@chaogelinux shell_program]# bash while_nginx2.sh ngx.log
ngx.log 总共处理的字节数：9MB
```

  

## 破解md5sum
例如如下的字符串，是RANDOM随机数结合md5sum加密后得出的连续10位结果，想要破解，如何实现？  

```plain
4fe8bf20ed
```

提示：RANDOM范围0~32767，将其所有的数字，通过md5sum加密，得到一个结果数据库，然后进行数据比对。

1.生成RANDOM所有数字的md5sum结果  

```plain
[root@chaogelinux shell_program]# cat random_md5sum.sh
#!/bin/bash
for n in {0..32767}
do
    echo "`echo $n|md5sum` $n" >> /tmp/random_md5sum.db
done

# 执行
[root@chaogelinux shell_program]# bash random_md5sum.sh
# 查看
[root@chaogelinux shell_program]# ls -lh /tmp/random_md5sum.db
-rw-r--r-- 1 root root 1.4M 3月  25 17:20 /tmp/random_md5sum.db

[root@chaogelinux shell_program]# tail /tmp/random_md5sum.db
dd63f11786fc184c90f2ec5e0c4e50e7  - 32758
f8650e27447828dbed4ef1022fc34a54  - 32759
687028853d14e1493cefc48e4f4466a4  - 32760
0b3906ec27507e2fd86d5fcde7a1ab91  - 32761
7faf9205b42eb316cdf34f7f41a0abcd  - 32762
a192ee21829ee00faf2fb95708b5b18f  - 32763
a7bc9db1c5d7d3a5bb85ea9abbe65f57  - 32764
21d4a02fdd7c330fbc27e79ade953f2d  - 32765
de50e2ca2c30a982d886b19f6198cc69  - 32766
63fceb28a8c4c72fd3b2f5d71950ee08  - 32767
```

此时将字符串和数据库比对，过滤

```plain
[root@chaogelinux shell_program]# cat check_random.sh
#!/bin/bash

md5char="4fe8bf20ed"
while read line
do
    if [ `echo $line|grep "$md5char"|wc -l` -eq 1  ]
        then
            echo $line
            # 找到后立即结束循环
            break
    fi
done </tmp/random_md5sum.db
```

  
执行结果

```plain
[root@chaogelinux shell_program]# bash check_random.sh
1dcca23355272056f04fe8bf20edfce0 - 5
```

#   
08_shell数组开发
## 为什么要学shell数组

所谓数组，就是由一组数据，不再是单个数据

```plain
# 普通变量
name="yuchao"
echo $name

# 数组变量
[root@chaogelinux shell_program]# names=(yu chao 666)
[root@chaogelinux shell_program]# echo ${names[*]}
yu chao 666
```

> 数组就是多个元素的集合，把多个元素，用一个变量名存储，然后再挨个给元素标记序号。
>
> 因此数组包含了
>
> 数组内的变量
>
> 每一个变量的下标
>

<!-- OCR_START -->
- 数组
- hero=（诸葛亮安其拉白起不知火舞如己）
- hero=（[0]=诸葛亮[1]=安其拉[2]=白起[3]=不知火舞[4]=姐己）
- 诸葛亮安其拉白起不知火舞姐己
- 索引
- 2
- 3
- 元素
<!-- OCR_END -->

```plain
[root@chaogelinux tmp]# heros=([1]=程咬金 [0]=鲁班 [2]=后裔 )
[root@chaogelinux tmp]# echo ${heros[*]}
鲁班 程咬金 后裔
```

## 数组
### 再看数组定义
> 方式1：小括号将变量值括起来，赋值给数组变量，注意变量之间空格分隔。
>

最常用的写法，注意语法一致

```plain
[root@chaogelinux tmp]# students=(zhangsan lisi erdan)
[root@chaogelinux tmp]#
[root@chaogelinux tmp]# echo ${students[*]}
zhangsan lisi erdan
```

  
方法2：键值对赋值，根据下标位置添加

```plain
[root@chaogelinux tmp]# students=([0]=erdan [1]=sanpang [2]=sansha)
[root@chaogelinux tmp]#
[root@chaogelinux tmp]# echo ${students[*]}
erdan sanpang sansha

# 根据下标获取值
[root@chaogelinux tmp]# echo ${students[*]}
erdan sanpang sansha
[root@chaogelinux tmp]# echo ${students[3]}

[root@chaogelinux tmp]# echo ${students[2]}
sansha
[root@chaogelinux tmp]# echo ${students[1]}
sanpang
[root@chaogelinux tmp]# echo ${students[0]}
erdan
```

方法3：通过下标，挨个添加

```plain
[root@chaogelinux tmp]# teachers[0]=wupeiqi
[root@chaogelinux tmp]# teachers[1]=alex
[root@chaogelinux tmp]# teachers[2]=yuchao
[root@chaogelinux tmp]# echo ${teachers[*]}
wupeiqi alex yuchao
```

方法4：动态定义数组变量的值

如，存储所有txt文件的数组  

```plain
[root@chaogelinux shell_test]# ls *.txt
chaoge10.txt  chaoge2.txt  chaoge4.txt  chaoge6.txt  chaoge8.txt
chaoge1.txt   chaoge3.txt  chaoge5.txt  chaoge7.txt  chaoge9.txt
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]# txt_files=($(ls *.txt))
# 默认显示第一个
[root@chaogelinux shell_test]# echo ${txt_files}
chaoge10.txt
[root@chaogelinux shell_test]# echo ${txt_files[*]}
chaoge10.txt chaoge1.txt chaoge2.txt chaoge3.txt chaoge4.txt chaoge5.txt chaoge6.txt chaoge7.txt chaoge8.txt chaoge9.txt
[root@chaogelinux shell_test]#
```

方法5：采用declare -a array，创建数组变量

用的很少，无须关注了  

### 看看shell是如何存储数组的
```plain
# 导出所有变量
[root@chaogelinux shell_test]# set > all_vars.txt

# 过滤出变量

88 heros=([0]="鲁班" [1]="程咬金" [2]="后裔")
89 students=([0]="erdan" [1]="sanpang" [2]="sansha")
90 teachers=([0]="wupeiqi" [1]="alex" [2]="yuchao")
91 txt_files=([0]="chaoge10.txt" [1]="chaoge1.txt" [2]="chaoge2.txt" [3]="chaoge3.txt" [4]="chaoge4.txt" [5]="ch     aoge5.txt" [6]="chaoge6.txt" [7]="chaoge7.txt" [8]="chaoge8.txt" [9]="chaoge9.txt")
```

### 数组的输出
多种取值方式

```plain
[root@chaogelinux shell_test]# heros=(程咬金 后裔 鲁班 大鱼)
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]# echo ${heros[0]}
程咬金
[root@chaogelinux shell_test]# echo ${heros[1]}
后裔
[root@chaogelinux shell_test]# echo ${heros[2]}
鲁班
[root@chaogelinux shell_test]# echo ${heros[3]}
大鱼
[root@chaogelinux shell_test]# echo ${heros[*]}
程咬金 后裔 鲁班 大鱼
[root@chaogelinux shell_test]# echo ${heros[@]}
程咬金 后裔 鲁班 大鱼
```

>   
获取数组元素个数，和变量子串一样玩法，也就是获取数组的长度
>
> 数组也是变量，只不过有点特殊
>

```plain
[root@chaogelinux shell_test]# addrs="shahe"
[root@chaogelinux shell_test]# echo ${#addrs}
5
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]# echo ${#heros[*]}
4
```

### 数组单独赋值
修改数组的值

```plain
[root@chaogelinux shell_test]# set |grep heros
heros=([0]="程咬金" [1]="后裔" [2]="鲁班" [3]="大鱼")
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]# heros[0]="项羽"
[root@chaogelinux shell_test]# set |grep heros
heros=([0]="项羽" [1]="后裔" [2]="鲁班" [3]="大鱼")

# 数组再赋值
[root@chaogelinux shell_test]# heros[5]="蔡文姬"
[root@chaogelinux shell_test]# set |grep heros
heros=([0]="项羽" [1]="后裔" [2]="鲁班" [3]="大鱼" [5]="蔡文姬")

# 下标存在则取值，不存在就为空
```

### 数组清除
用法和清除变量是一样的，可以单独清除下标的值，也可以清除所有数组的值

```plain
[root@chaogelinux shell_test]# # 单独清除下标的值
[root@chaogelinux shell_test]# unset heros[5]
[root@chaogelinux shell_test]# set |grep heros
heros=([0]="项羽" [1]="后裔" [2]="鲁班" [3]="大鱼")
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]#
# 删除数组变量
[root@chaogelinux shell_test]# unset heros
[root@chaogelinux shell_test]# set |grep heros
```

### 数组的截取，替换(切片)
> 语法
>
> echo ${heros[*]:m:n}
>
> m是起点，n是元素个数
>

```plain
[root@chaogelinux shell_test]# heros=(程咬金 后裔 鲁班 大鱼 凯 小明)
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]# set |grep heros
heros=([0]="程咬金" [1]="后裔" [2]="鲁班" [3]="大鱼" [4]="凯" [5]="小明")
```

截取1~3号的元素，从1开始，取3个

```plain
[root@chaogelinux shell_test]# heros=(程咬金 后裔 鲁班 大鱼 凯 小明)
[root@chaogelinux shell_test]# set |grep heros
heros=([0]="程咬金" [1]="后裔" [2]="鲁班" [3]="大鱼" [4]="凯" [5]="小明")
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]# echo ${heros[*]:1:3}
后裔 鲁班 大鱼
```

> 替换元素，类似于sed语法
>
> 语法，但是不会修改原有数据
>
> ${数组名[*]/查找字符/替换字符}
>

```plain
[root@chaogelinux shell_test]# set |grep heros
heros=([0]="程咬金" [1]="后裔" [2]="鲁班" [3]="大鱼" [4]="凯" [5]="小明")
[root@chaogelinux shell_test]# echo ${heros[*]/大鱼/瑶}
程咬金 后裔 鲁班 瑶 凯 小明
```

### 数组特殊玩法
可以检索和打印在索引或关联数组中使用的键(而不是它们各自的值)。

可以通过添加!来执行。数组名称前的运算符如下：

```plain
${!ARRAY_NAME[index]}

[root@chaogelinux shell_test]# echo ${!heros[*]}
0 1 2 3 4 5
```

查找数组长度

```plain
[root@chaogelinux shell_test]# echo ${#heros[*]}
6
```

> 数组遍历，基于for遍历，基于所有的索引，获取值
>
> 这里就要注意，@ 和 *的区别
>
> 带有*的循环将产生单个结果，将数组的所有元素都保存为一个单词。
>
> 使用@时，数组需要使用双引号引起来，(使用@时)，扩展为数组的每个元素提供了一个单词的结果  

>

```plain
# 查看案例
heros=(程咬金 后裔 鲁班 大鱼)

# 如此可以看出区别
[root@chaogelinux shell_test]# for i in "${heros[@]}";do echo "$i";done
程咬金
后裔
鲁班
大鱼
凯
小明

[root@chaogelinux shell_test]# for i in "${heros[*]}";do echo "$i";done
程咬金 后裔 鲁班 大鱼 凯 小明
```

遍历数组

```plain
[root@chaogelinux shell_test]# cat for_array.sh
#!/bin/bash

heros=(程咬金 后裔 鲁班 大鱼)

for i in "${!heros[@]}"
do
    echo -e  数组元素，挨个是"${heros[$i]}\t\t" is "$i"
done
```

结果

```plain
[root@chaogelinux shell_test]# bash for_array.sh
数组元素，挨个是程咬金         is 0
数组元素，挨个是后裔         is 1
数组元素，挨个是鲁班         is 2
数组元素，挨个是大鱼         is 3
```

for遍历数组方式2

注意：此方案只能获取，连续key的数组  

```plain
[root@chaogelinux shell_test]# cat for_array2.sh
#!/bin/bash

heros=(程咬金 后裔 鲁班 大鱼 孙悟空 李白)
length=${#heros[@]}

# Array loop
for ((i=0;i<${length};i++))
do
    echo $i ${heros[$i]}
done

[root@chaogelinux shell_test]# bash for_array2.sh
0 程咬金
1 后裔
2 鲁班
3 大鱼
4 孙悟空
5 李白
```

  

## 实际脚本开发
### 找出如下作文中，长度大于6的单词
数据

```plain
As the New Year has passed away, I think the cold weather will pass away and gets warm soon, but I am wrong. This morning, it snows again and I have to wear a lot of clothes. I guess this is the last snow and the summer is coming soon. I miss summer. I can swim and play with my friends in summer.
新年已经过去了，我觉得寒冷的天气很快就会过去，转而变暖，但是我错了。今天早上就下起了雪，我不得不穿很多衣服。我想这是最后一场雪了，夏天快要到了。我想念夏天。我可以在夏天游泳，和我的朋友们一起玩耍。
```

```plain
[root@chaogelinux shell_test]# cat word_array.sh
#!/bin/bash
words=(As the New Year has passed away, I think the cold weather will pass away and gets warm soon, but I am wrong. This morning, it snows again and I have to wear a lot of clothes. I guess this is the last snow and the summer is coming soon. I miss summer. I can swim and play with my friends in summer.)

for ((i=0;i<${#words[*]};i++))
do
    if [ ${#words[$i]} -gt 6  ]
        then
            echo "${words[$i]}"
    fi
done
echo "----------方案2"
for word in ${words[*]}
do
    if [ `expr length $word` -gt 6  ];then
        echo $word
    fi
done
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]#
```

执行

```plain
[root@chaogelinux shell_test]#
[root@chaogelinux shell_test]# bash word_array.sh
Hello
to
my
linux
class
----------方案2
Hello
to
my
linux
class
```

### 批量检查网站
1.采用shell数组，检测策略模拟用户访问

2.每隔10秒检测一次，无效站点报警

检测的网站，同学们可以自己准备

> [http://pythonav.cn](http://pythonav.cn)
>
> [http://pythonav.com](http://pythonav.com)
>
> [http://127.0.0.1](http://127.0.0.1)
>

脚本内容

```plain
# 
# Use LSB init script functions for printing messages, if possible
#
lsb_functions="/lib/lsb/init-functions"
if test -f $lsb_functions ; then
  . $lsb_functions
else
  # Include non-LSB RedHat init functions to make systemctl redirect work
  init_functions="/etc/init.d/functions"
  if test -f $init_functions; then
    . $init_functions
  fi
  log_success_msg()
  {
    echo " SUCCESS! $@"
  }
  log_failure_msg()
  {
    echo " ERROR! $@"
  }
fi

check_count=0
  url_list=(
  http://pythonav.cn
  http://pythonav.com
  http://127.0.0.1
)

function wait(){
    echo -n "3秒后，执行URL检查"
    for ((i=0;i<3;i++))
    do
        echo -n ".";
        sleep 1;
    done
    echo 
}

function check_url(){
    wait
    for ((i=0;i<`echo ${#url_list[*]}`;i++))
    do
        wget -o /dev/null -T 3 --tries=1 --spider ${url_list[$i]} >/dev/null 2>&1
        if [ $? -eq 0 ]
            then
                log_success_msg "${url_list[$i]}"
        else
              log_failure_msg "${url_list[$i]}"
        fi
    done
    ((check_count++)) # 每次检查次数+1
}

main(){
    while true
    do
        check_url
        echo "--------check count:${check_count}--------"
        sleep 10
    done
}
main
```

执行结果

# 

<!-- OCR_START -->
- [root@chaogelinux shell_test]# bash array_check_url.sh
- 3秒后，执行URL检查··
- 确定
- http://127.0.0.1
- -check count:1--:
- nttp://pythonav.cn
- check count:2-------:
- check count:3-------
- -check count:4--:
- -check count:5-------:
- [失败]
- nttp://pythonav.com
- 7
- check count:6-.
<!-- OCR_END -->

  
   
09_高级shell面试题
## shell实战开发

<!-- OCR_START -->
- 学啥呀？没意思，不如玩游戏
- 不妈妈
- 我没钱娶媳妇，我要和超哥
- 努力学Linux
<!-- OCR_END -->

## 批量生成随机文件名
在/chaoge目录下，创建10个log文件，每个文件得包含10个随机字符串，以及固定字符'pyyu'

```plain
# 1.生成10位随机小写字母
[root@chaogelinux shell_test]# echo chaoge$RANDOM|md5sum|cut -c5-14
ec4733aee0
[root@chaogelinux shell_test]# echo chaoge$RANDOM|md5sum|cut -c5-14
3e9b7749ae
[root@chaogelinux shell_test]# echo chaoge$RANDOM|md5sum|cut -c5-14
5200049d57

# 2.开发脚本
[root@chaogelinux shell_program]# cat random_filename.sh
dir_path="/chaoge"

[ -d "$dir_path" ] || mkdir -p $dir_path

# 执行10次命令
for n in `seq 10`
do
    random_str=$(echo chaoge$RANDOM|md5sum|cut -c5-14)
    # 创建文件
    touch $dir_path/${random_str}_pyyu.log
done
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# ls /chaoge
ls: 无法访问/chaoge: 没有那个文件或目录
[root@chaogelinux shell_program]# bash random_filename.sh
[root@chaogelinux shell_program]# tree /chaoge
/chaoge
├── 0d51cd36c1_pyyu.log
├── 1d1b551eb8_pyyu.log
├── 6414fc0540_pyyu.log
├── 81c65b22bc_pyyu.log
├── 8a13b1e929_pyyu.log
├── 91eeaf3b2f_pyyu.log
├── b6ef3153fe_pyyu.log
├── dbe950080e_pyyu.log
├── efc4ddcac5_pyyu.log
└── fee7f36df4_pyyu.log

0 directories, 10 files
```

## 批量改名
将上题所有文件中的pyyu字符，全部改为yuchao字符，且将所有的log后缀，改为html

```plain
# 思路，如何替换文件名，方法有很多，不唯一

[root@chaogelinux shell_program]# echo /chaoge/0d51cd36c1_pyyu.log |sed 's/pyyu/yuchao/;s/log/html/'
/chaoge/0d51cd36c1_yuchao.html
```

脚本开发

```plain
[root@chaogelinux shell_program]# cat rename_file.sh
#!/bin/bash
dir_path="/chaoge"

cd $dir_path || exit 1

for n in `ls .`
do
    # 批量替换
    new_filename=$(echo $n|sed 's/pyyu/yuchao/;s/log/html/')
    mv $n $new_filename
    if [ $? -eq 0  ];then
        echo "It's done."
    else
        echo "Bad rename, exit."
        exit 1
    fi
done
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# bash rename_file.sh
It's done.
It's done.
It's done.
It's done.
It's done.
It's done.
It's done.
It's done.
It's done.
It's done.
[root@chaogelinux shell_program]# ls /chaoge
0d51cd36c1_yuchao.html  81c65b22bc_yuchao.html  b6ef3153fe_yuchao.html  fee7f36df4_yuchao.html
1d1b551eb8_yuchao.html  8a13b1e929_yuchao.html  dbe950080e_yuchao.html
6414fc0540_yuchao.html  91eeaf3b2f_yuchao.html  efc4ddcac5_yuchao.html
```

如果出错了

```plain
[root@chaogelinux shell_program]# bash rename_file.sh
mv: "0d51cd36c1_yuchao.html" 与"0d51cd36c1_yuchao.html" 为同一文件
Bad rename, exit.
[root@chaogelinux shell_program]# echo $?
1
```

## 扫描网络主机
思路

1.判断网络中主机，简单的就是ping，高级的使用nmap  

```plain
[root@chaogelinux shell_program]# cat ping_network.sh
CMD="ping -W 2 -c 2" #  -W 2 主机不可达2秒后停止 -c 2收发两次请求
IP_hosts="123.206.16."
# 限制ip范围
for n in $(seq 254)
do
    {
        $CMD $IP_hosts$n &> /dev/null
        if [ $? -eq 0  ];then
            echo "$IP_hosts$n is working..."
        fi
    }&  # 采用shell多进程方式，命令全部放入后台运行
done
```

  
2.nmap命令检测

```plain
[root@chaogelinux shell_program]# cat nmap_network.sh

# 检测是否有nmap
which nmap &> /dev/null || yum install nmap -y

CMD="nmap -sP" # -sP nmap采用ping协议检测主机
IP_hosts="123.206.16.0/24"
CMD2="nmap -sS" # -sS  TCP的半开扫描
$CMD $IP_hosts|awk '/Nmap scan report for/{print $NF, "up.."}'
```

## 检测memcached缓存服务
检测memcached服务健康，主要模拟用户，读写数据

采用nc命令，结合set、get指令

服务端环境准备  

```plain
[root@chaogelinux shell_program]# yum install memcached nc -y
[root@chaogelinux ~]# systemctl start memcached
```

脚本开发

```plain
[root@chaogelinux shell_program]# cat memcached_status.sh
#!/bin/bash
if [ `netstat -tunlp|grep 11211|wc -l` -lt 1  ]
    then
        echo "Memcached service is error."
        exit 1
fi

printf "del name\r\n" |nc 127.0.0.1 11211 &>/dev/null
printf "set name 0 0 10 \r\nyuchao6666\r\n"|nc 127.0.0.1 11211 &>/dev/null

values=`printf "get name\r\n"|nc 127.0.0.1 11211|grep yuchao6666|wc -l`

if [ $values -eq 1  ]
    then
        echo "memcached is running.."
else
    echo "memcached error."
fi
```

  

## 服务器安全监控脚本
### 思路
需求

监控linux下某些重要的文件，是否被恶意篡改（文件内容发生变化），如果有文件异常变化，及时告知运维，加入定时任务，3分钟执行一次

可以监控如配置文件、数据文件、密码文件、启动脚本，一些脚本命令

运维需要对用户操作，进行安全审计，减少危险概率，不要当背锅侠

思考

+ 文件变化特征
- 大小容量变化
- 修改时间、访问时间变化
- 文件内容变化、利用md5sum校验文件指纹
- 文件数量变化，增加，删除了某文件

md5sum给linux文件添加指纹

```plain
# 创建测试数据
[root@chaogelinux shell_program]# mkdir /shell_program/test_file/ -p

[root@chaogelinux shell_program]# cp -a /etc/a* /shell_program/test_file/
[root@chaogelinux shell_program]# cp -a /etc/b* /shell_program/test_file/
[root@chaogelinux shell_program]# ls /shell_program/test_file/
abrt     aliases       anacrontab   at.deny  autofs.conf            auto.master    auto.net           bashrc
acpi     aliases.db    ansible      audisp   autofs_ldap_auth.conf  auto.master.d  auto.smb           binfmt.d
adjtime  alternatives  asound.conf  audit    auto.home              auto.misc      bash_completion.d
```

给所有文件添加指纹信息

```plain
[root@chaogelinux shell_program]# find /shell_program/test_file/ -type f |xargs md5sum > /tmp/fingerprint.db
[root@chaogelinux shell_program]#
[root@chaogelinux shell_program]# tail /tmp/fingerprint.db
53134d2979a5b91cf8f59fcf3561a674  /shell_program/test_file/abrt/plugins/CCpp.conf
2876e889d2a25c672819152946183cee  /shell_program/test_file/abrt/plugins/xorg.conf
1c9cf478bb79baae4939470b606609d0  /shell_program/test_file/asound.conf
a22d3adba71785330b99cb33de8dbc7c  /shell_program/test_file/autofs_ldap_auth.conf
f29f9bfd00dd416c97db8f738e5a9237  /shell_program/test_file/acpi/events/powerconf
c7e90504ce3c63d143c9bf4383ad3d02  /shell_program/test_file/acpi/events/videoconf
a6a89bcebb99368dc1fd31eabe29e949  /shell_program/test_file/acpi/actions/power.sh
8241db83d5edf01c71734e41e383e205  /shell_program/test_file/anacrontab
902656f15ce2cb2ea8defc63ea88ee94  /shell_program/test_file/auto.master
a182ac5e9f15f885d9593f7dd68adb1f  /shell_program/test_file/aliases.db
```

获取需要检验的文件名

```plain
[root@chaogelinux shell_program]# cat /tmp/fingerprint.db |awk '{print $2}' > /tmp/allfile.txt

```

  

### 手工验证，文件内容变化
-c 从文件读取md5校验值

--quiet 正确的指纹就不打印了

1.篡改文件内容  

```plain
[root@chaogelinux test_file]# echo "hello" >> bashrc
[root@chaogelinux test_file]#

[root@chaogelinux test_file]# md5sum -c --quiet /tmp/fingerprint.db
/shell_program/test_file/bashrc: 失败
md5sum: 警告：1 个校验和不匹配
```

2.添加文件，数量变化

md5sum不会检测未添加指纹的文件

```plain
[root@chaogelinux test_file]# md5sum -c  --quiet /tmp/fingerprint.db
/shell_program/test_file/bashrc: 失败
md5sum: 警告：1 个校验和不匹配
```

通过diff命令，比对文件数量的变化

```plain
# 1.明确旧的，存有文件名的信息
[root@chaogelinux test_file]# cat /tmp/allfile.txt |wc -l
42

# 2.再次统计新的目录文件内容数量
[root@chaogelinux test_file]# find /shell_program/test_file/ -type f > /tmp/newfile.txt
[root@chaogelinux test_file]# cat /tmp/newfile.txt |wc -l
43

# 比较文件变化
# 在第8~9行之间有变化
[root@chaogelinux test_file]# diff /tmp/allfile.txt /tmp/newfile.txt
8a9
> /shell_program/test_file/new_file.txt
```

### 脚本开发
提前准备好测试数据

```plain
[root@chaogelinux shell_program]# ls /shell_program/test_file/
abrt     aliases.db    asound.conf  autofs.conf            auto.master.d  bash_completion.d
acpi     alternatives  at.deny      autofs_ldap_auth.conf  auto.misc      bashrc
adjtime  anacrontab    audisp       auto.home              auto.net       binfmt.d
aliases  ansible       audit        auto.master            auto.smb       new_file.txt

# 准备好数据文件
find /shell_program/test_file/ -type f > /tmp/all_file_origin.txt

find /shell_program/test_file/ -type f |xargs md5sum > /tmp/all_file_fingerprint.txt
```

完整脚本代码

```plain
[root@chaogelinux shell_program]# cat file_safe.sh
#!/bin/bash
RETVAL=0
export LANG=en
CHECK_DIR=/shell_program/test_file/

[ -e $CHECK_DIR  ] || exit 1

AllFileOrigin="/tmp/all_file_origin.txt"
AllFileFingerprint="/tmp/all_file_fingerprint.txt"

ErrLog="/tmp/file_err.log"

# 下一步需要手动，提前创建好文件信息、指纹库

# 对文件判断存在，否则退出
[ -e $AllFileOrigin  ]  || exit 1
[ -e $AllFileFingerprint ] || exit 1

# md5sum校验
# 记录日志
# 命令记录
echo "开始校验：md5sum -c --quiet /tmp/all_file_fingerprint.txt" > $ErrLog

# 实际执行
md5sum -c --quiet /tmp/all_file_fingerprint.txt &>>$ErrLog
# 返回值
RETVAL=$?

# 统计文件数量信息
find $CHECK_DIR -type f > /tmp/all_file_count.txt

echo "统计文件数量："  &>> $ErrLog

diff $AllFileOrigin /tmp/all_file_count.txt &>>$ErrLog

if [ $RETVAL -ne 0 -o `diff $AllFileOrigin /tmp/all_file_count.txt|wc -l` -ne 0  ]
    then
        echo "系统异常，文件内容发生变化"
else
    echo "系统一切ok"
fi
```

执行测试脚本

1.模拟文件数据变化  

```plain
[root@chaogelinux test_file]# > asound.conf
[root@chaogelinux test_file]# bash /shell_program/file_safe.sh
系统异常，文件内容发生变化

# 查看日志记录
[root@chaogelinux test_file]# cat /tmp/file_err.log
开始校验：md5sum -c --quiet /tmp/all_file_fingerprint.txt
/shell_program/test_file/asound.conf: 失败
md5sum: 警告：1 个校验和不匹配
统计文件数量：
```

2.模拟文件新增

```plain
[root@chaogelinux test_file]# touch hehe.txt
[root@chaogelinux test_file]# bash /shell_program/file_safe.sh
系统异常，文件内容发生变化
[root@chaogelinux test_file]# cat /tmp/file_err.log
开始校验：md5sum -c --quiet /tmp/all_file_fingerprint.txt
/shell_program/test_file/asound.conf: 失败
md5sum: 警告：1 个校验和不匹配
统计文件数量：
40a41
> /shell_program/test_file/hehe.txt
```

3.加入定时任务

```plain
[root@chaogelinux test_file]# crontab -l
*/3 * * * * /bin/bash /shell_program/file_safe.sh >/dev/null 2>&1
```

  
  

## sed进阶
### 正则表达式练习题
### 计算PATH目录下的文件数
PATH目录下的都是二进制命令文件  
 

```plain
1.查看PATH值
[root@gitlab01 ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

2.获取每个目录的字符串，利用sed替换功能
[root@node02 ~]# echo $PATH|sed 's/:/ /g'
/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /root/bin

3.分离目录后，可以for循环遍历取值了
[root@node02 ~]# my_path=$(echo $PATH|sed 's/:/ /g')
[root@node02 ~]# for dir in $my_path;do echo $dir;done
/usr/local/sbin
/usr/local/bin
/usr/sbin
/usr/bin
/root/bin

4.最终计算文件脚本
[root@node02 tmp]# cat test.sh
#!/bin/bash
# 超哥带你学shell编程

my_path=$(echo $PATH|sed 's/:/ /g')
count=0
for dir in $my_path
do
    check_dir=$(ls $dir)
    for item in $check_dir
    do
        count=$[ $count + 1 ]
    done
    echo "$dir ---- $count"
    count=0 # 归零，否则影响全局的count数量
done

[root@node02 tmp]# bash test.sh
/usr/local/sbin ---- 0
/usr/local/bin ---- 0
/usr/sbin ---- 540
/usr/bin ---- 1139
/root/bin ---- 0
```

### 验证电话号码
```plain
# 对于一些数据表单的输入，例如电话号码，输入错误，需要进行检测
以下是美国电话号码格式
(123)456-7890
(123) 456-7890
123-456-7890 
123.456.7890

这也就表明了电话输入的格式，可以有四种，因此你的正则必须完美的校验上述电话形式。

1.正则构建，最好从左边开始，先判断是否有空格
^\(?   脱字符后面跟着转义符和括号,问号表示括号，可有可无 

2.紧接着是三位区号，美国区号从2开始，没有0或1，最大到9结束
[2-9][0-9]{2}  这表示第一个数字是2-9，第二个是0-9，第三个同样

3.区号后面的括号，也是可有可无的，因此
\)?

4.从上述的电话看出，区号后面，可能有单破折线，或者空格，或者什么都没有，或者小数点，可以这么写
(| |-|\.) 
如此的写法表示，首先括号分组，后面也是同样的规则
然后用管道符进行表示，四种状态，空，空格，横杠，小数点

5.再接着是三位电话交换机号码，数字即可
[0-9]{3}

6.在电话交换机号码后面，必须有一个空格，一个单破折现，或者一个点。（这次不存在没有空格的情况），因此
( |-|\.)

7.最后就是尾部匹配4位本地电话分机号
[0-9]{4}$
```

总结

```plain
完整的匹配模式
^\(?[2-9][0-9]{2}\)?(| |-|\.)[0-9]{3}( |-|\.)[0-9]{4}$
```

此时可以集合sed，awk进行对电话号码过滤验证。

```plain
[root@node02 tmp]# cat phone_list
000-000-0000
123-456-7890
212-555-1234
(317)555-1234
(202) 555-9876
33523
1234567890
234.123.4567
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# cat phone_list | awk '/^\(?[2-9][0-9]{2}\)?(| |-|\.)[0-9]{3}( |-|\.)[0-9]{4}$/{print $0}'
212-555-1234
(317)555-1234
(202) 555-9876
234.123.4567
```

### 解析邮件地址
> 邮件地址是手机号之外的另一大通信方式，也存在千奇百怪的格式。  
username@hostname
>
> 点号
>
> 单破折线
>
> 加号
>
> 下划线
>

有效的邮件用户名里，这些字符都有可能存在组合。

> 邮件地址hostname格式是 一个或多个域名和一个服务器名字组成，也有一定的规则。
>
> 点号
>
> 下划线
>

```plain
1.左侧的用户名正则，用户名里可以有多个有效字符
^([a-zA-Z0-9_\-\.\+]+)@. 中括号里的字符，匹配一次或者任意多次
这个分组指定了用户名中允许出现的字符，正则加号，确保至少有一个字符

2.hostname的匹配规则
([a-zA-Z0-9_\-\.]+)

这样的模式，可以匹配，例如
server
server.subdomain
server.subdomain.subdomain

3.顶级域名的匹配规则，也就是例如.cn .com .org此类
顶级域名只能是字母，不少于二个字符，长度不搞过五个字符。
\.([a-zA-Z]{2,5})$

4.因此整个的匹配邮箱的规则，可以是
^([a-zA-Z0-9_\-\.\+]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$
```

案例

```plain
使用该正则，就可以过滤掉不正确的邮件地址
[root@node02 tmp]# cat email_list
yuchao@163.com
yy@163.com.
yy@ee.n
yy.city@163.now
yy_city@163.cn
yy#city@163.cc
yy+city@163.cc
yy*city@163.org
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# cat email_list | awk '/^([a-zA-Z0-9_\-\.\+]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$/{print $0}'
yuchao@163.com
yy.city@163.now
yy_city@163.cn
yy+city@163.cc
```

  

### sed进阶
sed编辑器可以满足大多数日常文本需求，这里超哥在给大家讲讲些高级用法。

### 多行命令
sed命令的特点是单行数据操作，基于换行符的位置吧数据分成行。然后sed一行一行的处理，重复过程。

如果需要跨行对数据处理，这就麻烦了。

比如文本里找一个短语Linux System Administrators Group，这个长语句可能出现在两行，默认的sed就无法识别这种短语。

sed开发者也考虑到了这个情况，提供了处理方案。

> sed特殊指令
>
> N: 将数据流中的下一行加进来，创建一个多行组处理，multiline group
>
> D：删除多行组的一行
>
> P：打印多行组的一行
>

### next命令
sed小写的n命令会告诉sed编辑器移动到数据流中的下一行文本。

sed编辑器再移动到下一行文本前，会在当前行执行完毕所有定义好的命令。

单行next命令改变了这个流程。

看下案例。

```plain
# 数据文件
[root@node02 tmp]# cat data.txt
This is an apple.

This is a boy.

This is a gril.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/^$/d' data.txt
This is an apple.
This is a boy.
This is a gril.

这种写法是删除空行
```

若是我们想要指定删除某个语句后面的空行，可以用n指令。

```plain
# 删除apple下一行的空格
[root@node02 tmp]# cat data.txt
This is an apple.

This is a boy.

This is a gril.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/apple/{n;d}' data.txt
This is an apple.
This is a boy.

This is a gril.
```

  
此时sed编辑器匹配到apple这一行后，通过n指令，让sed编辑器移动到文本的下一行，也就是空行，然后通过d指令，删除了该行。

此时sed执行完毕命令后，继续重复查找apple，然后尝试删除apple的下一行。

如果找不到apple字符串，也就不会执行任何动作了。

### 合并文本行
刚才使用小写的n将文本的下一行移动到sed的模式空间，属于是单行处理。

大写的N指令将下一行文本添加到模式空间中已经有的文本的后面，实现多行文本处理。

这个作用是将数据流的两个文本行合并在同一个模式空间里处理。

```plain
[root@node02 tmp]# cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/first/{N;s/\n/ /}' data2.txt
This is the header line.
This is the first data line. This is the second data line.
This is the last line.
```

这里sed找到first一行后，用N指令把下一行合并到first该行，并且执行s替换指令，结果是如上合并了一行。

案例：在数据文件里，查找替换一个可能分散两行的文本短语

```plain
[root@node02 tmp]# cat data.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All System Administrators should attend.
Thank you for your attendance.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed 's/System Administrator/Desktop User/' data.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All Desktop Users should attend.
Thank you for your attendance.
[root@node02 tmp]#
```

这里发现没有变化，是因为该短语出现在了两行，替换命令无法识别

用N命令解决

```plain
[root@node02 tmp]# sed 'N;s/System.Administrator/Desktop User/' data.txt
On Tuesday, the Linux Desktop User's group meeting will be held.
All Desktop Users should attend.
Thank you for your attendance.
```

这里注意，是使用了两个点，一是N指令，二是通配符.来匹配空格和换行符的情况。

当匹配出现了换行符，它就从字符串里删除了换行符，缺导致了两行合并

想要解决这个办法，可以如此：

```plain
[root@node02 tmp]# cat data.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All System Administrators should attend.
Thank you for your attendance.
[root@node02 tmp]#

[root@node02 tmp]#
[root@node02 tmp]# sed '
> s/System Administrator/Desktop User/
> N
> s/System\nAdministrator/Desktop\nUser/
> ' data.txt
On Tuesday, the Linux Desktop
User's group meeting will be held.
All Desktop Users should attend.
Thank you for your attendance.
```

用这种写法，可以保证，先进行单行替换处理，即使在最后一行也可以工作，因为N指令在最后一行时会停止工作。

### 多行删除
sed基础中说了删除命令(d)，sed编辑器用于删除模式空间里的当前行，和N一起使用的时候，要小心点了。

```plain
#这里是坑了
[root@node02 tmp]# cat data.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All System Administrators should attend.
Thank you for your attendance.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed 'N;/System\nAdministrator/d' data.txt
All System Administrators should attend.
Thank you for your attendance.
```

这里会发现直接在模式空间里删除了两行。

sed提供了大写的D，只删除模式空间里的第一行，该指令会删除到换行符位置的所有字符。

```plain
[root@node02 tmp]# sed 'N;/System\nAdministrator/D' data.txt
Administrator's group meeting will be held.
All System Administrators should attend.
Thank you for your attendance.
```

这里就只删除了第一行。

用这个方式可以删除文件的开头空白行。

```plain
[root@node02 tmp]# cat data2.txt

This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/^$/{N;/header/D}' data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
[root@node02 tmp]#
```

sed编辑器会查找空白行，然后用N命令把下一行的文本添加到模式空间，如果新的模式空间里有单词header，D指令就删除模式空间的第一行，也就删除了空白行。

记住sed是按行处理，如果不结合N和D指令，很难做到不删除其他空白行情况下，只删除第一个空白行。

### 保持空间
sed我们已知有一块模式空间（pattern space）用于sed编辑器执行命令的时候，保存待检查的文本。

![]()

sed还有一块空间叫做保持空间的缓冲区域（hold space）。

sed之所以能以行为单位的编辑或修改文本，其原因在于它使用了两个空间：一个是活动的“模式空间（pattern space）”，另一个是起辅助作用的“保持空间（hold space）这2个空间的使用。

模式空间：可以想成工程里面的流水线，数据之间在它上面进行处理。 保持空间：可以想象成仓库，我们在进行数据处理的时候，作为数据的暂存区域。

正常情况下，如果不显示使用某些高级命令，保持空间不会使用到！

![]()

一般情况下，数据的处理只使用模式空间（pattern space），按照如上的逻辑即可完成主要任务。但是某些时候，通过使用保持空间（hold space），还可以带来意想不到的效果。

_sed编辑器的保持空间命令。_

![]()

这些命令可以将文本从模式空间复制到保持空间。

![]()

这些保持空间的命令用于将文本从模式空间复制到保持空间。这样就可以清空模式空间加载其他需要处理的字符串。

案例，理解如何用h和g命令将数据在两个缓冲空间移动。

[root@node02 tmp]# cat data2.txt  This is the header line. This is the first data line. This is the second data line. This is the last line. [root@node02 tmp]# [root@node02 tmp]# [root@node02 tmp]# [root@node02 tmp]# [root@node02 tmp]# sed -n '/first/{h;p;n;p;g;p}' data2.txt This is the first data line. This is the second data line. This is the first data line.

我们看下这个案例

1. sed过滤含有first的单词的行
2. 当出现含有first单词的行，h指令将该行复制到保持空间
3. p命令此时打印模式空间第一行的数据，也就是first的行
4. n命令提取数据流的下一行，并且也放到了模式空间
5. p命令再次打印模式空间的内容，也就是打印了second那一行。
6. g命令此时将保持空间的内容放回模式空间，替换当前文本
7. p命令再次打印模式空间的内容，又打印了first内容了。

此时可以看出，保持空间的指令，可以来回移动文本行，再看一个案例

```plain
[root@node02 tmp]# sed -n '/first/{h;n;p;g;p}' data2.txt
This is the second data line.
This is the first data line.
```

若是这里去掉一个p打印，则会看出不同的结果了。

### 排除命令
sed编辑会将一些处理命令应用到数据流中的每一个文本行，单个行，或者一些区间行。也支持排除某个区间。

sed支持用感叹号!来排除命令，让某个命令不起作用。  
 

```plain
[root@node02 tmp]# cat data2.txt

This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed -n '/header/p' data2.txt
This is the header line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed -n '/header/!p' data2.txt

This is the first data line.
This is the second data line.
This is the last line.
```

### sed实战
#### 向文本中插入空白行
```plain
[root@node02 tmp]# cat data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed 'G' data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
```

这里的技巧在于，sedG命令会简单的保持空间内容附加到模式空间后。

当sed启动时候，保持空间默认只有一个空行，将它附加到已有行后面，就是上述的效果了。

#### 向文本中插入空白行，去掉最后一行的空白
```plain
# 使用排除符号! 和尾行符号$确保sed不会在最后一行添加空白行
[root@node02 tmp]# sed '$!G' data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
```

这里的技巧在于，只要不是最后一行，G命令就会附加保持空间的内容，且忽略最后一行。

#### 对可能存在空白行的文件，加倍行间距
如果文件已经有了一些空白行，但是你想要给所有的行加倍间距怎么办？上面的案例没发用，因为会导致有些区域空白太多。

```plain
[root@node02 tmp]# cat data2.txt
This is the header line.
This is the first data line.

This is the second data line.
This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '$!G' data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
```

想要解决的办法是，先删除数据流所有的空白行，然后再用G加入新行。

答案如下

```plain
[root@node02 tmp]# sed '/^$/d' data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/^$/d;$!G' data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
```

#### 给文件中行编号
sed可以使用=命令打印当前行号。

```plain
[root@node02 tmp]# sed '=' data2.txt
1
This is the header line.
2
This is the first data line.
3
This is the second data line.
4
This is the last line.
```

这样太丑，你应该会想到可以用N命令合并行处理。

```plain
[root@node02 tmp]# sed '=' data2.txt | sed 'N;s/\n/ /'
1 This is the header line.
2 This is the first data line.
3 This is the second data line.
4 This is the last line.
```

你可能会想到其他有些linux命令也会显示行号，但是可能不那么合适  

```plain
[root@node02 tmp]# nl data2.txt
     1    This is the header line.
     2    This is the first data line.
     3    This is the second data line.
     4    This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# cat -n data2.txt
     1    This is the header line.
     2    This is the first data line.
     3    This is the second data line.
     4    This is the last line.

[root@node02 tmp]# grep '.' data2.txt -n
1:This is the header line.
2:This is the first data line.
3:This is the second data line.
4:This is the last line.
```

因此sed会是一个很合适的小工具。

### 删除行
若是用sed删除所有的空白行很简单，但是选择性的删除空白行，则麻烦了些

```plain
[root@node02 tmp]# cat data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.

[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/^$/d' data2.txt
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
```

#### 删除连续的空白行
有些文件里会有讨厌的多个空白行，删除连续的空白行是用地址区间检查数据流。

删除连续的空白行的关键在于创建一个非空白行和空白行的地址区间，sed碰到该区间，不删除，其他的空白行区间则删除。

```plain
sed语法
区间是/./到/^$/
sed '/./,/^$/!d'   !d这表示不删除该区间
这就好比sed '1,3p' 打印1到3行一样
```

案例

```plain
[root@node02 tmp]# cat data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/./,/^$/!d' data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
```

无论数据行之间有多少个空白行，都会只保留一个空白行了。

#### 删除开头的空白行
数据文件经常也会存在空白行，若是导入数据库也会生成空项，较为麻烦。

```plain
sed命令
/./,$!d
该sed命令表示不删除有益内容，删除开头空白行。
```

案例

```plain
[root@node02 tmp]# cat data2.txt

This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '/./,$!d' data2.txt
This is the header line.

This is the first data line.

This is the second data line.

This is the last line.
[root@node02 tmp]#
```

#### 删除HTML标签
现在从网站上下载html并且保存使用的场景还是较多，例如爬虫等场景，HTML的标签较多，如何筛选出有益的信息。

```plain
[root@node02 tmp]# cat data2.txt
<html>
<head>
<title>This is the page title</title> </head>
<body>
<p>
This is the <b>first</b> line in the Web page.
This should provide some <i>useful</i>
information to use in our sed script.
</body>
</html>
```

对HTML标签的删除大部分是成对的删除，例如

```plain
<b> </b>
```

对于标签的删除正则，要小心，否则会删错，例如这样的正则

```plain
s/<.*>//g 这样的正则是有问题的

```

```plain
[root@node02 tmp]# sed 's/<.*>//g' data2.txt

This is the  line in the Web page.
This should provide some
information to use in our sed script.
```

  
这里是有问题，发现titile标签整行被删除了，以及加粗，斜体的文本都不见了。

sed认为的是在大于号、小于号之间的文本都要被替换为空。

正确的正则改成如下

```plain
# 正确的思路应该是让sed编辑器忽略掉，嵌入在原始标签里的大于号，排除写法[^>]
[root@node02 tmp]# cat data2.txt
<html>
<head>
<title>This is the page title</title> </head>
<body>
<p>
This is the <b>first</b> line in the Web page.
This should provide some <i>useful</i>
information to use in our sed script.
</body>
</html>
[root@node02 tmp]#
[root@node02 tmp]# sed 's/<[^>]*>//g;/^$/d' data2.txt
This is the page title
This is the first line in the Web page.
This should provide some useful
information to use in our sed script.
```

### sed基本练习题
#### 以行为单位添加/删除
将/etc/passwd的内容输出并且打印行号，同时在第1行之前插入两行文本，第一行内容为"How are you?"，第二行内容为"How old are you?"：

```plain
[root@node02 tmp]# nl /etc/passwd | sed '1i How are you?\nHow old are you?' | head -5
How are you?
How old are you?
     1    root:x:0:0:root:/root:/bin/bash
     2    bin:x:1:1:bin:/bin:/sbin/nologin
     3    daemon:x:2:2:daemon:/sbin:/sbin/nologin
```

在/etc/passwd第2行之后追加文本"Drink tea?"：

```plain
[root@node02 tmp]# nl /etc/passwd|sed '2a Drink Tea?'  | head -5
     1    root:x:0:0:root:/root:/bin/bash
     2    bin:x:1:1:bin:/bin:/sbin/nologin
Drink Tea?
     3    daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4    adm:x:3:4:adm:/var/adm:/sbin/nologin
```

删除/etc/passwd第2行至第5行内容：

```plain
[root@node02 tmp]# nl /etc/passwd|sed '2,5d' | head -5
     1    root:x:0:0:root:/root:/bin/bash
     6    sync:x:5:0:sync:/sbin:/bin/sync
     7    shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8    halt:x:7:0:halt:/sbin:/sbin/halt
     9    mail:x:8:12:mail:/var/spool/mail:/sbin/nologin

 sed将2-5行匹配到模式空间，然后d命令删除了模式空间的内容，因此这几行没输出
```

题：把文本第二行之后的空白行删除

这里注意要用到next命令  

```plain
[root@node02 tmp]# cat data2.txt
<html>

<head>
<title>This is the page title</title> </head>
<body>

<p>

This is the <b>first</b> line in the Web page.

This should provide some <i>useful</i>
information to use in our sed script.
</body>
</html>
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed '2n;/^$/d' data2.txt
<html>

<head>
<title>This is the page title</title> </head>
<body>
<p>
This is the <b>first</b> line in the Web page.
This should provide some <i>useful</i>
information to use in our sed script.
</body>
</html>
```

  

#### {}提示
对某一行执行多次处理，用{}将命令扩起来，花括号内每个命令用分号分割。

#### 以行为单环替换/打印
将/etc/passwd第三行替换为文本"This is the third line."：

提示：

c \TEXT：将指定行的内容替换为文本TEXT；

```plain
[root@node02 tmp]# nl /etc/passwd | sed '3c This is the third line'
     1    root:x:0:0:root:/root:/bin/bash
     2    bin:x:1:1:bin:/bin:/sbin/nologin
This is the third line
     4    adm:x:3:4:adm:/var/adm:/sbin/nologin
     5    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
```

> 使用编辑命令y实现对应转换字符：
>
> 提示
>
> y：用于(对应)转换字符；
>
> 例如 a > A b > B，注意字符数对应
>

```plain
[root@node02 tmp]#
[root@node02 tmp]# cat data.txt
On Tuesday, the Linux System
Administrator's group meeting will be held.
All System Administrators should attend.
Thank you for your attendance.
[root@node02 tmp]# 
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed 'y/abc/ABC/' data.txt
On TuesdAy, the Linux System
AdministrAtor's group meeting will Be held.
All System AdministrAtors should Attend.
ThAnk you for your AttendAnCe.
```

> 显示/etc/passwd前十行
>
> 提示
>
> q：读取匹配到的行后退出；
>

```plain
# 注意，一个文件若是非常大，sed用p处理会处理每一行，因此用q节省cpu资源。
[root@node02 tmp]# nl /etc/passwd | sed '10q'
     1    root:x:0:0:root:/root:/bin/bash
     2    bin:x:1:1:bin:/bin:/sbin/nologin
     3    daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4    adm:x:3:4:adm:/var/adm:/sbin/nologin
     5    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6    sync:x:5:0:sync:/sbin:/bin/sync
     7    shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8    halt:x:7:0:halt:/sbin:/sbin/halt
     9    mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    10    operator:x:11:0:operator:/root:/sbin/nologin
```

搜索/etc/passwd中root用户对应的一行，将'bash'改为'blueshell'，再输出该行：

```plain
# -n 不自动打印模式空间的内容
[root@node02 ~]# nl /etc/passwd | sed '/^root/{s/bash/blueshell/;p}' /etc/passwd -n
root:x:0:0:root:/root:/bin/blueshell

# 替换后立即退出
[root@node02 ~]# nl /etc/passwd | sed '/^root/{s/bash/blueshell/;q}' /etc/passwd
root:x:0:0:root:/root:/bin/blueshell
```

在两个数字之间添加 : 符号

```plain
# -r, --regexp-extended  在脚本中使用扩展正则表达式
[root@node02 tmp]# cat num.txt
789

345
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]#
[root@node02 tmp]# sed -r 's/([0-9])([0-9])([0-9])/\1:\2:\3/' num.txt
7:8:9

3:4:5
```

输出ens33网卡ip

```plain
# 正则锚点用法
[root@node02 tmp]#  ifconfig ens33 | sed -n '/inet\>/p' | sed -e 's/^.*inet //' -e 's/netmask.*$//'
172.18.0.69
```

将/etc/passwd第1到第5行中shell为/bin/bash的用户的shell改为'/bin/greenshell'，再输出：  

```plain
# sed执行多次命令的花括号用法
[root@node02 tmp]# sed '1,5{s@/bin/bash@/bin/greenshell@;p}' /etc/passwd -n
root:x:0:0:root:/root:/bin/greenshell
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
```

  
  

## awk进阶
我们所学的centos7，awk，也就是gawk

```plain
[root@node02 tmp]# ll /usr/bin/awk
lrwxrwxrwx. 1 root root 4 Jun  4 19:05 /usr/bin/awk -> gawk
```

  
awk能够对原始数据进行格式化展示，适合处理各种数据格式化任务。

### 使用变量
awk该编程语言一特性就是使用变量存取值，支持两种类型变量

+ 内置变量
+ 自定义变量

awk的一些内置变量，存放处理数据文件中的数据字段和记录的信息。

### 内置变量
#### 字段和记录分隔符
已知awk使用$1 $2 $3的形式记录字段的位置，以此类推，awk默认分隔符是空格。

以及可以使用-F选项修改分隔符，NR内置变量指定行号。

```plain
[root@node02 tmp]# awk -F ":" 'NR==1,NR==5{print $1}' /etc/passwd
root
bin
daemon
adm
lp
```

awk数据字段和记录变量

![]()

案例

awk逐行处理文本的时候，以输入分割符为准，把文本切成多个片段，默认符号是空格

当我们处理特殊文件，没有空格的时候，可以自由指定分隔符特点

FS变量就是控制分隔符的作用

```plain
[root@node02 tmp]# cat num.txt
data11,data12,data13,data14,data15
data21,data22,data23,data24,data25
data31,data32,data33,data34,data35

[root@node02 tmp]# awk 'BEGIN{FS=","}{print $1,$2,$3}' num.txt
data11 data12 data13
data21 data22 data23
data31 data32 data33
```

还可以通过修改OFS变量，控制输出时的分隔符。

```plain
[root@node02 tmp]# gawk 'BEGIN{FS=",";OFS="|"}{print $1,$2,$3}' num.txt
data11|data12|data13
data21|data22|data23
data31|data32|data33

[root@node02 tmp]# gawk 'BEGIN{FS=",";OFS=" | "}{print $1,$2,$3}' num.txt
data11 | data12 | data13
data21 | data22 | data23
data31 | data32 | data33
```

### 数据变量
除了字段和记录分隔符变量，awk还提供了些内置变量用于了解数据的变化。

![]()

ARGC和ARGV变量允许awk从shell中获取命令行参数的总数，但是awk不会把脚本文件当作参数的一部分

ARGC变量表示命令行上的参数，包括awk命令和文件名

```plain
[root@node02 tmp]# awk 'BEGIN{print ARGC}'
1
[root@node02 tmp]#
[root@node02 tmp]# awk 'BEGIN{print ARGC}' data.txt
2
```

ARGV数组值从索引0开始，表示awk本身，索引1表示第一个命令行参数

```plain
[root@node02 tmp]# awk 'BEGIN{print ARGV[0]}' data.txt
awk
[root@node02 tmp]# awk 'BEGIN{print ARGV[0],ARGV[1]}' data.txt
awk data.txt
[root@node02 tmp]# awk 'BEGIN{print ARGV[0],ARGV[1],ARGV[2]}' data.txt
awk data.txt
[root@node02 tmp]# awk 'BEGIN{print ARGV[0],ARGV[1],ARGV[2]}' data.txt xxxx
awk data.txt xxxx
```

awk内置变量的引用不用加美元符。

### ENVIRON变量
该变量用关联数组提取shell环境变量，注意点：关联数组用文本字符串作为数组的索引值，而不是数值。

> 在[计算机科学](https://zh.wikipedia.org/wiki/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%A7%91%E5%AD%A6)中，**关联数组**（英语：**Associative Array**），又称**映射**（**Map**）、**字典**（**Dictionary**）是一个抽象的[数据结构](https://zh.wikipedia.org/wiki/%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84)，它包含着类似于（键，值）的有序对。一个关联数组中的有序对可以重复（如C++中的multimap）也可以不重复（如C++中的map）。
>

数组索引中的key是shell的环境变量名，值是shell环境变量的值。  

```plain
[root@node02 tmp]# awk 'BEGIN{print ENVIRON["HOME"],ENVIRON["PATH"]}'
/root /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

awk跟踪数据字段和记录时，变量FNR,NF和NR用起来就很方便了，比如你不知道awk到底分隔了多少个数据字段，可以根据NF变量获取最后一个数据字段。

```plain
FNR    FNR：各文件分别计数的行号
NF    NF：number of Field，当前行的字段的个数(即当前行被分割成了几列)，字段数量
NR    NR：行号，当前处理的文本行的行号。
```

案例

```plain
[root@chaogelinux ~]# awk 'BEGIN{FS=":";OFS=" - "}{print $1,$NF}' /etc/passwd | head -3
root - /bin/bash
bin - /sbin/nologin
daemon - /sbin/nologin
```

NF变量就记录了字段的数量，因此$NF也就是打印最后一个字段。

### NR和FNR变量
FNR和NR变量类似，FNR变量含有当前数据文件中已经被处理过的记录数量

NR变量含有已处理过的记录总数。

看下案例差别  

```plain
[root@chaogelinux ~]# awk 'BEGIN{FS=":"}{print $1,"FNR="FNR}' /etc/passwd | head -5
root FNR=1
bin FNR=2
daemon FNR=3
adm FNR=4
lp FNR=5
```

可以看出，FNR变量是记录处理的记录数量，也就是行数。

那NR和FNR的区别在哪?

```plain
[root@chaogelinux ~]# cat /tmp/pwd.txt
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

[root@chaogelinux ~]# awk 'BEGIN{FS=":"}{print $1,"FNR="FNR,"NR="NR}END{print "There ware",NR,"records processed"}' /tmp/pwd.txt /tmp/pwd.txt
root FNR=1 NR=1
bin FNR=2 NR=2
daemon FNR=3 NR=3
adm FNR=4 NR=4
lp FNR=5 NR=5
root FNR=1 NR=6
bin FNR=2 NR=7
daemon FNR=3 NR=8
adm FNR=4 NR=9
lp FNR=5 NR=10
There ware 10 records processed
```

我们会发现，FNR变量的值在awk处理第二个文件数据的时候被重置，而NR变量则在处理第二个数据文件时继续统计。

### 自定义变量
shell脚本与awk变量

awk允许自定义变量在程序中使用，awk自定义的变量可以是任意数目的字母，数字，下划线，不得已数字开头，而且区分大小写。

例如

```plain
[root@chaogelinux ~]# awk 'BEGIN{testing="Hello chaoge.";print testing}'
Hello chaoge.

[root@chaogelinux ~]# awk 'BEGIN{v1="超哥nb";print v1;v1="超哥不错哦";print v1}'
超哥nb
超哥不错哦
```

数值计算

```plain
[root@chaogelinux ~]# awk 'BEGIN{x=4;x=x*2+3;print x}'
11
```

> 命令行与变量赋值，花式用法
>
> 使用awk命令可以给脚本中的变量赋值
>
> 该作用可以不改变脚本的情况下，改变脚本的作用。
>

```plain
[root@chaogelinux ~]# cat data
data11,data12,data13,data14,data15
data21,data22,data23,data24,data25
data31,data32,data33,data34,data35
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]# awk -f script1 n=2 data
data12
data22
data32
[root@chaogelinux ~]#
[root@chaogelinux ~]# cat script1
BEGIN{FS=","}
{print $n}

[root@chaogelinux ~]# awk -f script1 n=3 data
data13
data23
data33
```

使用命令行参数定义变量会有一个问题，设置了变量之后，这个值在代码的BEGIN部分不可用。例如

```plain
[root@chaogelinux ~]# cat script2
BEGIN{print "The starting value is",n;FS=","}
{print $n}
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]# awk -f script2 n=3 data
The starting value is
data13
data23
data33
```

发现这里只是打印了第三列的值，但是明没有在BEGIN里输出n的值

这里可以用-v选项解决，允许在awk的BEGIN开始之前设定变量。

```plain
[root@chaogelinux ~]# awk -v n=3 -f script2 data
The starting value is 3
data13
data23
data33
```

### 处理数组
为了能够在单个变量中，存储多个值，许多编程语言都提供了数组，awk也支持关联数组功能，也就是可以理解为是字典的作用。

```plain
例如

"name":"chaoge"
"age":18
```

关联数组的索引可以是任意文本字符串，每一个字符串都可以对应一个数值。

> 定义数组变量
>
> 语法
>
> var[index]=element
>
> var是变量名字，index是索引，element是值
>

案例

```plain
[root@chaogelinux ~]# awk 'BEGIN{student["name"]="超哥";print student["name"]}'
超哥
```

关联数组计算

```plain
[root@chaogelinux ~]# awk 'BEGIN{num[1]=6;num[2]=7;sum=num[1]+num[2];print sum}'
13
```

#### 遍历数组变量
关联数组的问题是必须要知道索引是什么，否则无法取值。

可以利用for循环遍历出所有的索引。

```plain
for (var in array)
{
    语句
}
```

例如

```plain
[root@chaogelinux ~]# awk 'BEGIN{
> var["a"]=1
> var["b"]=2
> var["d"]=3
> var["h"]=4
> for (s in var)
> {print "Index: ",s," - Value:",var[s]}}'
Index:  h  - Value: 4
Index:  a  - Value: 1
Index:  b  - Value: 2
Index:  d  - Value: 3
```

注意，索引值的返回是没有顺序的，但是对应的值是唯一的。

  
 

#### 删除数组变量
```plain
语法
delete array[index]
```

一旦删除了索引，就无法用用它提取元素了。

```plain
[root@chaogelinux ~]# awk 'BEGIN{
var["a"]=1
var["b"]=2
var["d"]=3
var["h"]=4
for (s in var)
{print "Index: ",s," - Value:",var[s]};delete var["d"];print "----";for (s in var){print "Index:",s,"Value:",var[s]}}'
```

### 使用模式
awk的模式，我们已知有BEGIN和END俩关键字来处理，数据流开始与结束两个模式。

#### 正则表达式
正则表达式必须出现在要控制的脚本左花括号前面。  

```plain
# 匹配含有data的记录
[root@chaogelinux ~]# awk 'BEGIN{FS=","}/data/{print $1}' data
data11
data21
data31
```

#### 匹配操作符
(matching operator)匹配操作符是波浪线~，来看下如何用

```plain
$1 ~ /^data/

$1表示记录中的第一个数据字段，该正则会过滤出第一个字段以文本data开头的所有记录。
```

例如

```plain
[root@chaogelinux ~]# cat data
data11,data12,data13,data14,data15
data21,data22,data23,data24,data25
data31,data32,data33,data34,data35
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]# awk -F "," '$2 ~ /^data2/{print $1,$2,$3}' data
data21 data22 data23
```

该匹配操作符使用正则^data2来比较第二个数据字段。

再看个实际场景，搜索特定数据。

```plain
[root@chaogelinux ~]# awk -F : '$1 ~ /yu/{print $1,$NF}' /etc/passwd
yu /bin/bash
yu1 /bin/bash
yu2 /bin/bash
pyyu /bin/bash
pyyuc /bin/bash
[root@chaogelinux ~]# awk -F : '$1 ~ /^yu/{print $1,$NF}' /etc/passwd
yu /bin/bash
yu1 /bin/bash
yu2 /bin/bash
```

这个语法会在第一列中查找文本以yu开头。如果找到了该记录，打印该记录的第一个和最后一个字段。

#### 排除语法
搜索出除了以a,b,c开头的行  

```plain
[root@chaogelinux ~]# head -5 /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

[root@chaogelinux ~]# head -5 /etc/passwd | awk -F : '$1 !~ /^[a-c]/{print $1,$NF}'
root /bin/bash
daemon /sbin/nologin
lp /sbin/nologin
```

#### 数学表达式
除了正则，还可以用数学表达式，过滤如UID,GID寻找用户信息。  
  
 

```plain
# 找出所有组ID为0的用户。
[root@chaogelinux ~]# awk -F :  '$4==0{print $1}' /etc/passwd
root
sync
shutdown
halt
operator
```

常见的数学表达式

```plain
 x == y:值x等于y。
 x <= y:值x小于等于y。
 x < y:值x小于y。
 x >= y:值x大于等于y。 
 x > y:值x大于y。
```

例如找出uid大于1000的用户信息

```plain
[root@chaogelinux ~]# awk -F :  '$3>1000{print $0}' /etc/passwd
yu1:x:1001:1004::/home/yu1:/bin/bash
yu2:x:1002:1002::/home/yu2:/bin/bash
pyyu:x:1500:1500::/home/pyyu:/bin/bash
tom:x:1501:1500::/home/tom:/bin/bash
jerry:x:1502:1502::/var/jerry:/sbin/nologin
eva:x:1503:1503:The girl eva userinfo:/home/eva:/bin/bash
mjj:x:1504:1504::/home/mjj:/bin/bash
xiaomage:x:1505:1505::/home/xiaomage:/bin/bash
pyyuc:x:2000:2000::/home/pyyuc:/bin/bash
alex:x:2001:1500::/home/alex:/bin/bash
virtual_chao:x:2003:2003::/var/ftpdir:/sbin/nologin
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin
cc:x:2004:2004::/home/cc:/bin/bash
only:x:2005:2005::/home/only:/bin/bash
test1:x:2006:2006::/home/test1:/bin/bash
chaoge:x:2007:2007::/home/chaoge:/bin/bash
chao:x:2008:2008::/home/chao:/bin/bash
susu:x:2009:2010::/home/susu:/bin/bash
```

  

### 结构化命令
awk也支持逻辑判断

#### if语句
awk支持标准的if语句  

```plain
if (条件)
    语句
```

案例，如果uid在1000,2000之间就打印出用户信息

```plain
[root@chaogelinux ~]# awk -F: '{if ($3 > 1000 && $3 < 2000)print $0}' /etc/passwd
yu1:x:1001:1004::/home/yu1:/bin/bash
yu2:x:1002:1002::/home/yu2:/bin/bash
pyyu:x:1500:1500::/home/pyyu:/bin/bash
tom:x:1501:1500::/home/tom:/bin/bash
jerry:x:1502:1502::/var/jerry:/sbin/nologin
eva:x:1503:1503:The girl eva userinfo:/home/eva:/bin/bash
mjj:x:1504:1504::/home/mjj:/bin/bash
xiaomage:x:1505:1505::/home/xiaomage:/bin/bash
```

执行多条语句

```plain
[root@chaogelinux ~]# cat data
10
5
13
50
34
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]#
[root@chaogelinux ~]# awk '{
> if ($1>20)
> {
> x=$1*2
> print x
> }
> }' data
100
68
```

#### if else
awk也支持if语句不成立，执行其他语句。

```plain
[root@chaogelinux ~]# awk '{
> if ($1 > 20)
> { x= $1 *2;print x}
> else {x=$1/2;print x}
> }' data
5
2.5
6.5
100
68
```

#### 单行写法
单行写法，要注意分号;和花括号{}的使用。  

```plain
[root@chaogelinux ~]# awk '{if($1>20) print $1*2;else print $1/2}' data
5
2.5
6.5
100
68
```

#### while语句
awk也支持while的循环功能。  

```plain
语法
while (条件)
{
    语句
}
```

while循环会遍历数据，且检查结束条件。  

```plain
[root@chaogelinux ~]# cat data
130 120 135
160 113 140
145 170 215

# 该循环作用是相加三个列的值，求平均值
[root@chaogelinux ~]# awk '{
> total=0
> i=1
> while (i<4)
> {
> total+=$i
> i++
> }
> avg=total/3
> print "Average:",avg
> }' data
Average: 128.333
Average: 137.667
Average: 176.667
```

#### 循环中断
awk支持在while循环里使用break和continue跳出循环。

```plain
[root@chaogelinux ~]# awk '{
> total=0
> i=1
> while (i<4)
> {
> total+=$i
> if (i==2)
> break
> i++
> }
> avg=total/2
> print "The average of the first tow data elements is:",avg
> }' data

The average of the first tow data elements is: 125
The average of the first tow data elements is: 136.5
The average of the first tow data elements is: 157.5
```

#### for循环
awk也支持for循环，且是c语言风格。

```plain
[root@chaogelinux ~]# awk '{
> total=0
> for (i=1;i<4;i++)
> {
> total+=$i
> }
> avg=total/3
> print "Average:",avg
> }' data
Average: 128.333
Average: 137.667
Average: 176.667
```

for循环的计数器比起while要好用了。

  
 

### awk内置函数
awk内置的函数功能非常强大，可以进行常见的数学，字符串等运算。

### 数学函数
![]()

> int()函数用法，得到整数，如同其他编程语言的floor函数
>
> floor函数，其功能是“向下取整”，或者说“向下舍入”、“向零取舍”，即取不大于x的最大整数，与“四舍五入”不同，下取整是直接取按照数轴上最接近要求值的左边值，即不大于要求值的最大的那个整数值。
>
> Int()函数会生成值和0之间最接近该值整数。
>
> 例如int()函数值为5.6返回5，值为-5.6时取-5
>
> rand()函数用于创建随机数，但是只会在0和1之间，要得到更大的数，就要放大返回值。
>
> srand() 随机数种子，计算机无法产生绝对的随机数，生成只能是伪随机数，也就是根据某规则生成的，因此可以加入随机数种子，根据系统时间的变化，产生不同的随机数。
>

具体用法，注意随机数种子必须写在BEGIN里，这是awk的机制，我们必须在awk开始计算前，加入随机种子。

```plain
[root@chaogelinux ~]# awk -F "\t" 'BEGIN{
srand();
}{
value=int(rand()*100)
print value
if(value<=10)
print "值："value"\t次数："NR
}'
```

随机数简单写法

```plain
[root@chaogelinux ~]# awk 'BEGIN{srand();print rand()}'
0.547909
[root@chaogelinux ~]# awk 'BEGIN{srand();print rand()}'
0.999358

[root@chaogelinux ~]# awk 'BEGIN{srand();print int(100*rand())}'
29
[root@chaogelinux ~]# awk 'BEGIN{srand();print int(100*rand())}'
4
```

  

### 字符串函数
![]()

![]()

函数使用案例

大写转换，统计长度

```plain
[root@chaogelinux ~]# awk 'BEGIN{x="chaoge";print toupper(x);print length(x)}'
CHAOGE
6
```

全局替换函数

```plain
[root@chaogelinux ~]# awk '
BEGIN{
str="Hello,chaoge"
print "替换前的字符串：",str
gsub("chaoge","超哥",str)
print "替换后的字符串: ",str
}'
替换前的字符串： Hello,chaoge
替换后的字符串:  Hello,超哥
```

  
排序函数asort()，经过排序后的数组，索引会被重置

asort根据value进行排序

```plain
# 生成关联数组
[root@chaogelinux ~]# awk 'BEGIN{t["a"]=66;t["b"]=88;t["c"]=22;for(i in t){print i,t[i]}}'
a 66
b 88
c 22

# asort()排序，新数组
[root@chaogelinux ~]# awk 'BEGIN{t["a"]=66;t["b"]=88;t["c"]=22;asort(t,newt);for(i in newt){print i,newt[i]}}'
1 22
2 66
3 88
```

排序函数asorti()，排序的是索引

当关联数组的索引是字符串时，可以使用asorti()函数排序，如果是数字，直接for循环即可

```plain
# 当前关联数组
[root@chaogelinux ~]# awk 'BEGIN{t["z"]=66;t["q"]=88;t["a"]=3;for(i in t){print i,t[i]}}'
z 66
a 3
q 88

# 排序后
[root@chaogelinux ~]# awk 'BEGIN{t["z"]=66;t["q"]=88;t["a"]=3;\
> len=asorti(t,newt);\
> for(i=1;i<=len;i++){print i,newt[i]} }
> '
1 a
2 q
3 z

# 那么可以根据排序后的索引，对原关联数组再进行排序
[root@chaogelinux ~]# awk 'BEGIN{t["z"]=66;t["q"]=88;t["a"]=3;\
> len=asorti(t,newt);\
> for(i=1;i<=len;i++){print i,newt[i],t[newt[i]]}}'
1 a 3
2 q 88
3 z 66
```

### 时间函数
![]()

时间函数用在日志文件格式化处理非常有用。

```plain
[root@chaogelinux ~]# awk 'BEGIN{
> date=systime()
> day=strftime("%A,%B %d,%Y",date)
> print day
> }'
星期一,十月 12,2020
```

#### 自定义函数
自定义函数

```plain
function name([variables])
{
    语句
}
```

自定义函数必须写在awk最开始的地方。

定义awk脚本

```plain
[root@chaogelinux ~]# cat func.awk
function find_min(num1,num2)
{
    if (num1<num2)
        return num1
    return num2
}

function find_max(num1,num2)
{
    if (num1>num2)
        return num1
    return num2
}

function main(num1,num2)
{
    # 找最小值
    result=find_min(num1,num2)
    print "最小值= ",result

    # 找最大值
    result=find_max(num1,num2)
    print "最大值= ",result
}
BEGIN {
main(10,30)
}

# 执行
[root@chaogelinux ~]# awk -f func.awk
最小值=  10
最大值=  30
```

#### awk实践
现有一个数据文件，可以使用awk进行格式化数据处理。

```plain
[root@chaogelinux ~]# cat scores.txt
Rich Blum,team1,100,115,95
Barbara Blum,team1,110,115,100
Christine Bresnahan,team2,120,115,118
Tim Bresnahan,team2,125,112,116
```

对每只队伍的成绩排序，且计算总平均分

```plain
# 脚本
[root@chaogelinux ~]#
c[root@chaogelinux ~]# cat bowling.sh
#!/bin/bash
# for循环首先迭代出队名然后去重
for team in $(awk -F, '{print $2}' scores.txt|uniq)
do
    # 循环内部计算，传递shell变量给awk
    awk -v team=$team 'BEGIN{FS=",";total=0}
    {
        # 如果队名一致，就计算三场总分
        if ($2==team)
    {
        total+=$3+$4+$5;
}
}
    END {
        # 求平均数
        avg=total/6;
        print "Total for",team,"is",total,",the average is ",avg

}' scores.txt
done
```

执行结果

```plain
[root@chaogelinux ~]# bash bowling.sh
Total for team1 is 635 ,the average is  105.833
Total for team2 is 706 ,the average is  117.667
```

  
  

> 更新: 2022-12-21 16:43:50  
> 原文: <https://www.yuque.com/chengkanghua/awf7cm/hsfg7ldksh5o8q4n>