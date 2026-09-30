# Linux系统符号系列

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- Linux系统符号系列
- 如何证明自己有经验？
- 搜索技巧
- 基础正则 （BRE Basic Regular Expression)
- 扩展正则 （ERE Extented Regular Expression)
  - 预定义字符类
- 案例
  - 匹配身份证号码
  - 取出网卡的ip地址
  - 正则表达式取权限
  - 如何把文件中的空行过滤掉（要求命令行实现）。
  - # 请使用grep或egrep正则匹配的方式过滤出前两行内容
- 其他符号
- 四剑客 find  grep sed awk
  - find 使用
  - sed
  - sed 练习
  - awk  模式匹配与处理语言
    - (运算%) 显示出磁盘使用率大于20%的磁盘分区名称和挂载点
    - 计算内存的使用率（使用率）
    - 范围
    - 特殊模式BEGIN{} END{}
    - 练习题
- awk 判断中循环与判断
- awk循环
- awk 数组  统计
  - ## ```bash
- 请给出输出test.txt文件内容时，不包含oldboy字符串的命令。
- 方法2 -head 显示前两行
- !取反
- -n = 关闭默认自动打印，只打印你用 p 指定的内容
- 准备环境
- 有oldboy字符的行
- m开头的行
- m结尾的行  m后面又空格不会显示
- 显示文件中所有符号， -A每行结尾会有个 $
- ' $' 空格结尾的行
- ^$ 表示空格  什么符号都没有
- -n 显示行号
- 排除空行
- . 任意一个字符  不会匹配空行
- grep -o 输出匹配到的部分
- grep -o '.' oldboy.txt
- 以. 结尾的行, \转义字符
- 所有回车换行符 替换成tab
- 正则表达式 坑1      0*   会把文件都显示出来
- 0次   没有         会把文件内容都显示出来
- 0次以上  					 00000000000000
- ^.*o 贪婪性  按最大的范围匹配
- my blo 算是符合匹配的, 实际按最大范围: my blog is http://oldboy.blog.51cto
- -o, --only-matching       show only the part of a line matching PATTERN
- 显示匹配模式的 部分内容,匹配一个换一行, 没匹配的不显示
- a-z的所有小写字母
- 所有大写字母
- -i 不区分大小写

# Linux系统符号系列

![1546507679173-8dabaed9-7d6c-465c-ae16-5e2df24e6ce2.png](img/Linux%E7%B3%BB%E7%BB%9F%E7%AC%A6%E5%8F%B7%E7%B3%BB%E5%88%97-01.webp)

# 如何证明自己有经验？

1. 说出来
2. 处理过的故障
3. 项目
4. 特长  -  画图
   1. 演讲
   2. 三剑客
   3. 排版哥

# 搜索技巧

```bash
	1 linux + 关键词（词语）    例如  linux  command not found
	2 关键词+ zh                     例如 awk zh   一般搜索结果都是中文的
	3 指定网站搜索: inurl:lidao.blog.51cto.com 关键词   
    例如： 快捷键 inurl:lidao.blog.51cto.com  //在lidao博客里搜索快捷键 关键词
    site:(cloud.tencent.com) go       //指定cloud.tencent.com 搜索go有关的信息
```

通配符 VS 正则

通配符：找出文件名 大部分命令可以使用

正则：  精确的过滤 三剑客使用

# 基础正则 （BRE Basic Regular Expression)

| 符号 | 含义 | 用法示例 | 匹配结果 |
| --- | --- | --- | --- |
| `.` | 匹配**任意单个字符**（除换行） | `grep "a.c"` | 匹配 abc、a1c、a\&c |
| `*` | 匹配**前一个字符 0 次 或 多次** | `grep "ab*c"` | 匹配 ac、abc、abbc |
| .\* | 匹配 所有 |  |  |
| `^` | 匹配**行首**（以 xx 开头） | `grep "^hello"` | 匹配以 hello 开头的行 |
| `$` | 匹配**行尾**（以 xx 结尾） | `grep "world$"` | 匹配以 world 结尾的行 |
| `^$` | 匹配**空行** | `grep "^$"` | 匹配没有内容的空行 |
| `[]` | 匹配**括号内任意一个字符**<br/>\*\* \[a-z] \[A-Z]  \[0-9]    相当于一个符号，每次匹配一个字符\*\* | `grep "[aA]pple"` | 匹配 apple / Apple |
| `[^]` | 匹配**不在括号内的字符**<br/>**排除** | `grep "[^0-9]"` | 匹配非数字字符 |
| `[a-z]` | 匹配小写字母 | `grep "[a-z]"` | 匹配 a-z 任意字母 |
| `\` | 转义符（取消特殊符号含义） | `grep "\."` | 匹配真正的点号 . |

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
# 正则表达式-坑2 [oldoby]  
# o或l或d或o或b或y 匹配了, oldboy连续的也会匹配
grep '[oldboy]' oldboy.txt

grep '[oldboy]' oldboy.txt -o  #查看匹配过程

# 匹配 m或,或n
grep '[m,n]' oldboy.txt

# 找出oldboy.txt中以m或n开头的行
grep '^[mn]' oldboy.txt

# 找出oldboy.txt中以m或n开头并且以m或n结尾的行
grep '^[mn].*[mn]$' oldboy.txt

[^] [^abc] 相当于是一个符号（每次匹配1个字符） 找出除了a或除了b或除了c
grep '[^abc]' oldboy.txt

#排除文件中的数字和大小写字母
grep '[^0-Z]' oldboy.txt


```

# 扩展正则 （ERE Extented Regular Expression)

| 符号 | 含义 | 示例 | 匹配结果 |
| --- | --- | --- | --- |
| **基础正则（BRE/ERE 通用）** | | | |
| `.` | 匹配**任意单个字符** | `gr.y` | gray、grey、gr2y、gr@y |
| `*` | 前一个字符**0 次或多次** | `go*d` | gd、god、good、goooood |
| `^` | 匹配**行首** | `^start` | 以 start 开头的行 |
| `$` | 匹配**行尾** | `end$` | 以 end 结尾的行 |
| `[]` | 匹配**括号内任意一个字符** | `[Aa]pple` | Apple、apple |
| `[^]` | 匹配**不在括号内的字符** | `[^0-9]` | 非数字字符 |
| `\` | 转义符（还原特殊符号） | `\.` | 匹配真正的点 `.` |
| **ERE 专属新增符号（必须加 -E）** | | | |
| `+` | 前一个字符**1 次或多次** | `go+d` | god、good、goooood |
| `?` | 前一个字符**0 次或 1 次** | `colou?r` | color、colour |
| | | 或 |  |  |
| `()` | **分组 / 整体** + 后向引用<br/> 表示一个整体， 反向 后向引用 | `(ab)+` | ab、abab、ababab |
| `{n}` | 精确匹配 **n 次** | `go{2}d` | good |
| `{n,}` | 至少匹配 **n 次** | `go{2,}d` | good、goooood |
| `{n,m}` | 匹配 **n~m 次**<br/>\*\* {m,n} 指定次数  前一个字符至少出现次数，后一个字符最多出现次数\*\* | `go{2,3}d` | good、goood |

```bash
# +前一个字符连续出现1次或1次以上
grep -E '0+' oldboy.txt
grep  '0\+' oldboy.txt #效果和上面一样


# 取出连续出现的小写字母;  egrep 等于 grep -E
egrep '[a-z]+'  oldboy.txt  


egrep 'oldboy|linux' oldboy.txt


#先备份 /etc/ssh/sshd_config 然后 
# 排除 文件中的#号的行或空行
cp /etc/ssh/sshd_config{,.bak}
egrep -v '^$|#' /etc/ssh/sshd_config

# 正则表达式-坑3-  [^#^$]  [^$] [^#$]
# []中 $ . 没有特殊含义
echo '+++++\\\\\\!!!!$$$$$$^^^' >> oldboy.txt
echo '####!!!^^^^^$$$$@@@@@####' >> oldboy.txt

cat > oldboy.txt<<EOF
I am oldboy teacher!
I teach linux.

I like badminton ball ,billiard ball and chinese chess!
my blog is http://oldboy.blog.51cto.com 
our size is http://blog.oldboyedu.com 
my qq is 49000448
not 4900000448.
my god ,i am not oldbey,but OLDBOY!
+++++\\\\\\!!!!$$$$$$^^^
####!!!^^^^^$$$$@@@@@#### EOF

# 排除 #或$
grep '[^#^$]' oldboy.txt  # 排除了 #^$
grep '[^#$]' oldboy.txt
grep '[^$]' oldboy.txt


# 匹配.结尾的行
grep '\.$' oldboy.txt
grep '[.]$' oldboy.txt

# 正则表达式-坑4-  [^abc]  vs  grep -v
# [^a-z]          排除按字符 某个字符 某些字符
# grep -v [a-z]   	排除按行

# 按字符除了a-z 其他都显示
grep '[^a-z]' oldboy.txt

#按行排除 一行里有a-z中任一个字符 都不匹配; 空行也会显示出来.
grep -v '[a-z]' oldboy.txt

# () 表示一个整体  反向引用/后向引用

# oldboy 和 oldbey 都匹配出来.
egrep 'oldb(o|e)y' oldboy.txt

反向引用/后向引用
	思路：把你想要的内容保护起来 ()
		sed 在 's###g' 后两个井号之间使用  \数字 引用

# -r, --regexp-extended  use extended regular expressions in the script.
# echo 123456|sed -r 's#(.*)#\1#g'  # \1表示取前面第一个()里匹配的内容
123456   
# echo 123456|sed -r 's#(.*)#<\1>#g'
<123456>
# echo 123456|sed -r 's#(34)#<\1>#g'
12<34>56
# echo 132456|sed -r 's#(..)(..)(..)#\3\2#g'
5624
# echo 123456|sed -r 's#(..)(..)(..)#\3\2\1#g'
563412
# echo 123456|sed -r 's#(..)(..)(..)#\3<\2>\1#g'
56<34>12


# 0{3,4} 匹配0连续出现的3次到4次
egrep '0{3,4}' oldboy.txt


```

## 预定义字符类

```bash
正则表达式的预定义字符类。

[:alnum:] 字母数字字符。在 ASCII 中，等价于：[A-Za-z0-9]
[:word:] 与[:alnum:]相同, 但增加了下划线字符。
[:alpha:] 字母字符。在 ASCII 中，等价于[A-Za-z]
[:blank:] 包含空格和 tab 字符。
[:cntrl:] ASCII 的控制码。包含了0到31，和127的 ASCII 字符。
[:digit:] 数字0到9
[:graph:] 可视字符。在 ASCII 中，它包含33到126的字符。
[:lower:] 小写字母。
[:punct:] 标点符号字符。
[:print:] 可打印的字符。等于[:graph:]中的所有字符，再加上空格字符。
[:space:] 空白字符，包括空格，tab，回车，换行，vertical tab, 和 form feed.在 ASCII 中， 等价于[ \t\r\n\v\f]
[:upper:] 大写字母。
[:xdigit:] 用来表示十六进制数字的字符。在 ASCII 中，等价于[0-9A-Fa-f]



```

# 案例

## 匹配身份证号码

```bash
# cat > id.txt <<EOF
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

# egrep '[0-9X]{18}' id.txt
# egrep '[0-9]{17}[0-9X]' id.txt

```

## 取出网卡的ip地址

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


# 第三行inet替换成oldboy
[root@m01 ~]# ip a s eth0|sed -n 3p|sed 's#inet#oldboy#g'
    oldboy 10.0.0.3/24 brd 10.0.0.255 scope global dynamic eth0
[root@m01 ~]# ip a s eth0|sed -n '3s#inet#oldboy#gp'
    oldboy 10.0.0.3/24 brd 10.0.0.255 scope global dynamic eth0





# 取出ifconfig eth0 ip地址和子网掩码
[root@m01 ~]# ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.3  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::20c:29ff:fed7:d086  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:d7:d0:86  txqueuelen 1000  (Ethernet)
        RX packets 3771  bytes 294807 (287.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2595  bytes 414021 (404.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        
ifconfig eth0|awk 'NR==2' |awk -F"[ :]+" '{print $3,$5}'
ifconfig eth0|awk 'NR==2' |awk -F"inet |netmask" '{print $2}'
ifconfig eth0|sed -n 2p|awk -F '[ ]+' '{print $3,$5}'

# awk 默认分隔符最聪明，会吃掉开头空格，
ifconfig eth0|awk 'NR==2{print$2}'
# awk指定的分隔符，开头的空格会算进去 所以是$3, $1是空格
ifconfig eth0|awk -F'[ ]+' 'NR==2{print $3}'
ifconfig eth0|awk 'NR==2'|awk -F'[: ]+' '{print $3}'
# sed 后向引用 # 在前面先保护(你想要的内容),在后面通过\数字使用
ifconfig eth0|sed -n 2p|sed -r 's#.*inet (.*)  net.*$#\1#g'



#只通过正则表达式取出ip(了解)
[root@m01 ~]# ip a s eth0 |egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
    inet 10.0.0.3/24 brd 10.0.0.255 scope global dynamic eth0
[root@m01 ~]# ip a s eth0 |egrep '([0-9]{1,3}\.){3}[0-9]{1,3}'
    inet 10.0.0.3/24 brd 10.0.0.255 scope global dynamic eth0
[root@m01 ~]# [root@m01 ~]# ip a s eth0 |egrep '([0-9]{1,3}\.?){4}'
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.0.0.3/24 brd 10.0.0.255 scope global dynamic eth0
[root@m01 ~]# hostname -I
10.0.0.3


```

## 正则表达式取权限

```bash
取出stat /etc/hosts 文件权限 644 0644  
[root@m01 ~]# stat /etc/hosts
  File: ‘/etc/hosts’
  Size: 158             Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 33555401    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2024-08-17 16:00:33.817000093 +0800
Modify: 2013-06-07 22:31:32.000000000 +0800
Change: 2024-08-10 12:27:59.248838008 +0800
 Birth: -
 
stat /etc/hosts | awk -F '[(/]' 'NR==4{print $2}'
stat /etc/hosts | sed -n 4p|sed -r 's#^.* \((.*)/-.*$#\1#g'
stat /etc/hosts | sed -n 4p|sed -r 's#^.*\(([0-9]{4})/.*$#\1#g'
stat /etc/hosts | sed -n 4p|sed -r 's#^.*\(([0-9]+)/.*$#\1#g'
stat /etc/hosts | sed -n 4p |sed -r 's#(^.*\()([0-9]+)(/.*$)#\2#g'
stat -c%a /etc/hosts  #644

```

## 如何把文件中的空行过滤掉（要求命令行实现）。

```bash
# 文件内容
cat > test.txt<<EOF
oldboy

xizi

xiaochao
EOF

通过三剑客实现
grep -v '^$' test.txt
sed '/^$/d' test.txt  #d  delete按照行位单位
sed -n  '/^$/!p' test.txt   //#!p   不显示  
awk '!/^$/' test.txt

# 只显示带o的
egrep -v '^$|xizi' test.txt
sed -r '/^$|xizi/d' test.txt
awk '!/^$|xizi/' test.txt
sed -n '/o/p' test.txt
sed -n '/o/p' test.txt # -p 显示 带o的   -n取消默认输出



```

## # 请使用grep或egrep正则匹配的方式过滤出前两行内容

```bash
# 文件内容
cat > ett.txt<<EOF
oldboy
olldboooy
test
EOF

egrep 'oldboy' ett.txt
egrep 'ol+dbo+y' ett.txt
sed -nr '/ol+dbo+y/p'  ett.txt
awk '/ol+dbo+y/' ett.txt
grep '[^test]' ett.txt
sed  -n '/test/!p' ett.txt
awk '!/test/' ett.txt


三剑客过滤
grep   过滤  显示执行过程 加上颜色
sed    过滤  替换 修改文件内容   取行 
awk    过滤  取列（-F）  计算 统计
```

# 其他符号

```bash
# &&  前面命令成功就执行后面的命令
ifdown eth0 && ifup eth0   //重启网卡

# ||    前面的命令失败就后面的命令
ls /tmp/ccc || echo 目录不存在

# 注释    root用户的命令提示符    
$ 普通用户命令提示符
    echo $PS1  $PATH  $LANG   坏境变量
	  AWK 中取出某一列   $0 一行  $NF 最后一列

!命令   # 执行最近一次 ！ls 开头的命令
history | grep awk

!!  # 运行上一次命令
	  find  awk 中 ！ 取反
		vim中 强制
    
; 在同一行中分割多个命令

通配符—找文件名
*.log  找文件  型号表示所有
ls *.txt
find / -type f -name "*.conf"

找出系统中文件名包含ifconfig (文件名中有ifconfig就行)
# find / -type f -name "*ifconfig*"

{} 生成序列
echo stu{01..10}
echo {1,5,100}
echo stu{001..5}
echo stu{01..10..2}  #2走2步
echo A{B,C}
echo A{,C}
echo oldboy.txt{,.bak}
cp a.txt{,.bak}


```

# 四剑客 find  grep sed awk

## find 使用

```bash
find /oldboy/ -type f  -name "*.sh"
find /oldboy/ -type f  -name "*.sh"|xargs ls -l


ll $(find /root/ -type f –name "*.sh")  or  ll `find /root/ -type f –name "*.sh"`
#$()  先运行括号里面的命令 然后再执行其他的命令
#$()   `` 反引号 


find /root/  -type f –name "*.sh" –exec ls –l {} \;
备注： -exec 接收前面命令结果放到{} 交给ls –l处理 ; -exec xarga 不识别 ll 别名机制。

| 与 |xargs 区别
| 管道  把前一个命令结果 通过管传递道给后面命令 传递的是文字 文本
| xargs 把前一个命令结果 通过管道传递给后面命令  传递的是为文件名
# find /oldboy/ -type f -name "*.sh"  
# find /oldboy/ -type f -name "*.sh" |sed -i 's#old#you#g'
sed: no input files

# find /oldboy/ -type f -name "*.sh" |xargs sed -i 's#old#you#g'
#find +|xargs 就有结果











sed -i参数修改文件内容，后面必须要加上文件名否则会报错。no input file
find /root/ -type f  -name "*.sh" |sed -i 's#oldboy#oldgirl#g' 
说明 只有一个管道的时候 传递的只是 文本 文字 字符串
find  /root/ -type f  -name "*.sh" |xargs sed -i 's#oldboy#oldgirl#g'


find /data/ -type f -name "*.txt" |grep ".txt"

find /data/ -type f -name "*.txt" |grep -o ".txt"
###上面的内容表示grep命令从管道中获取文本，在这些文本中查找.(此处表示任意一个字符）txt

find /data/ -type f -name "*.txt" |xargs grep ".txt"
###上面的表示grep命令从find命令的找到的文件名字中查找想要的内容
grep命令表示过滤 表示找东西，一重是从管道里面获取文字另一种方法是从文件中获取文件或文本。



# 把/oldboy目录及其子目录下所有以扩展名 .sh结尾的文件中，文件包含oldboy的字符串全部替换为oldgirl
# 准备环境
mkdir -p /oldboy/test
cd /oldboy
echo "oldboy">test/del.sh
echo "oldboy">test.sh
echo "oldboy">t.sh
touch oldboy.txt
touch alex.txt


find /oldboy/  -type f -name "*.sh"|xargs sed 's#oldboy#oldgirl#g'
find /oldboy/  -type f -name "*.sh"|xargs sed -i 's#oldboy#oldgirl#g'
find /oldboy/  -type f -name "*.sh"|xargs cat





```

## sed

```bash
# 先备份t.sh.bak 再修改文件内容
sed -i.bak 's#girl#boy#g' t.sh

# sed 增加
增加 cai
  	c  replace 替换
  	a  append 追加   下
  	i  insert  插入	 上

#准备坏境
cat>person.txt<<EOF
101,oldboy,CEO
102,zhangyao,CTO
103,Alex,COO
104,yy,CFO
105,feixue,CIO
110,lidao,COCO
EOF

#文件尾部追加			
echo "12306,xiao,UF0">>person.txt  
cat >> person.txt <<EOF
12306,xiao,UFO
EOF

#第三行后面加内容  
sed  '3a12306,xiao,ufo' person.txt  
#每一行后增加一行:  a前面不加数字就是
sed 'a123' person.txt    
#替换第三行内容
sed '3c12306.xiao.ufo' person.txt  

在文件最后一行增加
sed '$a12306,xiao,UFO \n12580,tao,XO' person.txt

# 修改配置文件 常用方法
echo >>
cat >> oldboy.txt<<EOF
....
EOF
追加文件最后
sudo === /etc/sudoers
cron === /var/spool/cron/
挂载 === /etc/fstab
解析主机名 ===  /etc/hosts
网卡配置文件 ===/etc/sysconfig/network-scripts/ifcfg-eth0

# sed命令  删除  delete
sed '2,5d' person.txt   #删除第二行到第五行
sed '/yy/,$d' person.txt  # 删除yy到最后一行
sed '/lidao/!d' person.txt   #删除不包含lidao 

# 企业案例：不显示文件的空行
grep -v '^$'       lidao.txt  #前面有空格不算空行  cat –A  每行结束会显示$
sed     '/^$/d'    lidao.txt
awk     '!/^$/'    lidao.txt 
sed  -n '/^$/!p'   lidao.txt
awk  NF   lidao.txt  #带空格的空行也能过滤

# 文件中可能有空行 只包含空格的行  （有空格的空行）
#环境准备
echo -e 'oldboy\n\n     oldboy     \n     \nlidao   \n   lidao' >lidao.txt

egrep -v '^$|^ +$' lidao.txt  # 排除 空格 空行 +
egrep '[^ $]+' lidao.txt      # 排除空格 $符号 + 连续的
egrep -v '^$|^ *$' lidao.txt  # 排除空行  空格或连续的空格
sed -n '/^ *$/!p' lidao.txt   # 不显示空格开头的 或者是空行

*  前面字符0次0次以上，（不限次数）
+  前面字符自少1次或1次以上



's###g'
s  substitute
g  global   全局  # g  不写 只会替换第一个找到的

# -e 激活转义字符
echo -e 'oldboy\n\n     oldboy     \n     \nlidao   \n   lidao' >lidao.txt
sed '$d' person.txt    # $最后一行删除
sed 's#[0-9]##g' person.txt  # 0-9数字替换空
sed 's#[0-9]##' person.txt 	 # 没g只替换每一行的第一个字符

# sed命令中使用变量  #解析变量需要加双引号“”
x=oldboy;y=oldgirl; sed "s#$x#$y#g"  person.txt


#后相引用 取ip地址
ifconfig eth0|sed -nr '2s#^.*r:(.*)  Bc.*$#\1#gp'   # centos6
ifconfig eth0|sed -nr  '2s#^.*t (.*)  n.*$#\1#gp'   # centos7
ifconfig eth0|awk -F'addr:|  Bc' 'NR==2{print $2}'  #centos6
ifconfig eth0|awk -F"[ :]+" 'NR==2{print $3}'
ifconfig eth0 |awk -F'[^0-9.]+' 'NR==2{print $2}'



正则表达式
^      以...开始
$      以...结尾
^$     空行
.*	   任意字符任意次数
.      一个字符
*      0次或0次以上
[]    每次匹配单个字符  [abc]  a或b或c
+     1次 或1次以上
()    表示一个整体
|     或
{}    {n,m}  前面字符 n到m次
?     0次或1次


sed 增删该查
	格式： 找谁干啥
	查找 行号 行号范围  //  //,//
		grep –A
		找出有规律的行 1~2    1 3 5 7 9
	删除 d
	增加 c a i
	替换 s  ‘s###g’

# 准备数据
cat>person.txt<<EOF    
101,oldboy,CEO
102,zhangyao,CTO
103,Alex,COO
104,yy,CFO
105,feixue,CIO
110,lidao,COCO
EOF

# 替换每行的第二个数字开始 
sed 's#[0-9]##2' person.txt  
#替换每行第二个匹配的内容到最后
sed 's#[0-9]##2g' person.txt   


rename  找谁  替换为什么     替换哪些文件
								*.log   *.jpg
                
touch a_html.jpg; touch b_html.jpg;
rename html '' *.jpg

```

## sed 练习

```bash
# 把文件的person.txt文件中的每一行的内容 替换为对应的行号
#!/bin/bash
for n in {1..7}
do
     sed -i.bak "${n}s#.*#$n#g" person.txt 
done

# 批量重命名：删除文件名中的html
# 环境准备
touch oldboy_html{01..10}.jgp

方法1:sed  拼接
# mv  oldboy_html_01.jpg   oldboy_01.jpg 

ls *.jgp|sed -r 's#(.*)html(.*)#mv & \1\2#g'|bash

方法2： for循环
cat > oldboyhtml.sh<<EOF
#!/bin/bash
for name in `ls /server/scripts/name/`
do
	mv $name `echo $name|sed 's#html##g'`
done
EOF

方法3  rename
# rename oldboy oldgirl *.jpg
		找谁   替换什么  替换哪些文件
rename html '' *.jgp


方法4：
rename "html" "" oldboy_*
ls ./ | sed -rn 's#((.*_).*_(.*))#mv \1 \2\3#gp' |bash
ls ./|awk -F "_" '{print "mv "$0,$1"_"$3}' |bash
for NAME in `ls ./`; do mv  $NAME `echo $NAME | sed -n "s#html_##gp"`; done


# find命令找出包含特殊符号文件名案例
#环境准备
touch "oldboy_ "{01..04}.jgp
find ./ -type f -name "*.jgp" |xargs ls –l #文件名包含空格 提示报错

#-print0 结束标记   -0 接收结束标记
# find ./ -type f -name "*.jgp" -print0 |xargs -0 ls -l
-rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  01.jgp
-rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  02.jgp
-rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  03.jgp
-rw-r--r-- 1 root root 0 Aug 21 11:04 ./oldboy_  04.jgp


```

## awk  模式匹配与处理语言

```bash

gnu awk  gawk
-F  指定分隔符
-v  定义变量
awk –F: ‘NR==1{print $1,$3}’ /etc/passwd
		‘条件{动作}’
     pattern{命令}
     模式
print
awk格式 
比较表达式
NR>1 
$5>500


#awk 内置变量（shell 环境变量）
#NR  行号 number of record 
#NF  每行有多少列 number of filed 
#FS  指定的分隔符  -F:    ====  -vFS=: 
#$1  $2  第1列 第2列
#$0     一整行的内容
#OFS     output 输出分隔符  显示每一列的时候 每一列之间通过什么分开
awk '{print $1,$2}'


#调换/etc/passwd第1列和最后1列内容
awk -F: -vOFS=: '{print $NF,$2,$3,$4,$5,$6,$1}' passwd.txt

awk  -F: -vOFS=: '{tmp=$1;$1=$NF;$NF=tmp;print $0}' passwd.txt





内置变量
FS(-F:)     输入字段（列）分隔符  菜刀
NR   				行号  :number  of  record 行号 （记录号）
NF   				列  默认最后一列: number  of filed  列  
OFS					输出 分隔符
RS    			每一行之间如何分割 record sepaator 每一行的结束标记  默认是回车
IGNORECASE  是否忽略大小写  1为忽略

awk  vRS 每一行的结束标记
每一行的默认换行  回车（\n）


cat > rs.txt <<EOF
1  oldboy.lidao 
2  oldboy.lidao 
3  oldboy.lidao 
4  oldboy.lidao 
5  oldboy.lidao 
EOF

# 更改换行符 .表示换行
awk -vRS=. '{print $0}' rs.txt    


# 以 / 作为换行符 显示行号和文件内容
head  /etc/passwd    >passwd.txt #测试数据
awk -vRS=/ '{print NR,$0}' passwd.txt



#awk 模式（条件）
模式-pattern 条件  帮助你找到想要的行

正则表达式

~   某一列中包含xxx
！~ 某一列中不包含
^   以..开头     awk中 以什么开头的字符（列）
$   以..结尾
.*  任意字符任意次数
^$  空行
\   脱掉马甲 打回原形 转义字符
[]  [abc] 每次匹配单个字符 a或b或c
[^abc]  排除a或b或c 
+   1次或1次以上
|   或
( ) 表示一个整体
*   0次 0次以上
{}  {n,m}
?	  0次1次

head  /etc/passwd    >passwd.txt #测试数据

# :号分割, 第三列中包含数字4    # ~匹配 包含
awk -F: '$3~/4/' passwd.txt


# 比较表达式
$5>500
NR>20
>
>=
==
!=
<=
<
运算 %



mkdir -p /server/files/
cat >>/server/files/reg.txt<<EOF
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
# 姓   名 		id		最后三列最后三次捐款数量



# 1 第三列中 以数字4开头的
awk '$3~/^4/' reg.txt

#2显示xiaoyu的姓氏和id号码
awk '$2~/Xiaoyu/{print $1,$2,$3}' reg.txt

# 3 显示所有以41开头的ID号码的人的全名和ID号码
awk '$3~/^41/{print $1,$2,$3}' reg.txt

awk '$3~/^41/' reg.txt

awk 默认动作
'$3~/^41/'  === '$3~/^41/{print $0}'
'/oldboy/'  === '$0~/oldboy/'
'!/oldboy/' === '$0!~/oldboy/'

#5 显示所有ID号码最后一位数字是1或5的人的全名
#条件 ‘$3~/[15]$’
#动作  print
awk '$3~/[15]$/{print $1,$2}' reg.txt

#6 显示Xiaoyu的捐款.每个值时都有以$开头.如$520$200$135 
# awk -F'[ :]+' 'NR==2{print "\$"$4"\$"$5"\$"$6}' reg.txt
awk: warning: escape sequence `\$' treated as plain `$'  //警告转义/ $变成普通字符
$155$90$201
调换 ‘s###g’

# gsub awk内置命令（函数）（awk中动作）
gsub（/找谁/，”替换为什么”，某一列）
gsub（/找谁/，”替换为什么”，某一列）=== gsub（/找谁/，”替换为什么”，$0）
awk 'NR==2{print $NF}' reg.txt |sed 's#:#$#g'
awk 'NR==2{gsub(/:/,"$",$4); print $NF}' reg.txt
awk  '$2~/Xiaoyu/{gsub(":","$",$NF);print $NF}' reg.txt

# 7 显示所有人的全名，以姓,名的格式显示，如Meng,Feixue
awk '{print $1","$2}' reg.txt

awk -vOFS=',' '{print $1,$2}' reg.txt  #-vOFS=',' 输出分隔符
```

### (运算%) 显示出磁盘使用率大于20%的磁盘分区名称和挂载点

```bash
$5>20  对比的是字符 字符串（字母）
df -h |awk '$5>20{print $1,$NF}'

方法0, 行号大于1 表示去掉head, 第5列百分比数字大于9
df -h |awk -F'[ %]+' 'NR>1 && $5+0>9'

解决方法一  指定分隔符只保留数字部分
df -h |awk -F'[ %]+' '$5>9{print $1,$NF}'

解决方法二  某一列+0
df -h|awk '$5+0>9'

#计算磁盘使用率
df |awk 'NR>1{print $3/$2}'
```

### 计算内存的使用率（使用率）

```bash
free -m | awk 'NR==2 {printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2}'
free -m|awk '/Mem/{print $3/$2*100"%"}'

计算内存剩余率
free -m|awk '/Mem/{print 100-$3/$2*100"%"}'

free|awk 'NR==2{sum=$3+$4;print $3/sum*100,$4/sum*100}' #内存使用率 和剩余率

ree|awk 'NR==2{sum=$3+$4;print sum}' #内存总容量


```

### 范围

从第1行到第5行内容

```bash
sed –n ‘1,5p’
awk ‘NR==1,NR==5’

# 显示文件中从oldboy行到yy行
sed -n '/oldboy/,/yy/p' person.txt
awk '/oldboy/,/yy/' person.txt

```

### 特殊模式BEGIN{} END{}

```bash
awk执行过程
1. 执行命令的参数（赋值）-F –v
2. BEGIN{}里面的内容（awk还没开始读取文件内容）
3. 读取文件内容
读取一行 判断是否满足条件（模式）
	  符合 执行命令（动作）
		不符合 读取下一行
		d) 文件内容读取完后，开始执行END{} 里面的内容

BEGIN{} 里面的内容， 会在awk读取文件之前 执行
1# 显示标题
2# 修改awk内置变量 创建变量
		awk ‘BEGIN{OFS=:}’
		awk –vOFS=:
3# 测试 计算

END{} ******** awk读取完文件之后 执行
	1# 显示计算结果
		先计算， END显示结果

i=i+1 === i++    统计次数  一共有多少次

# 统计/etc/passwd 中 nologin 用户数量
awk '/nologin$/{i++}END{print i}' passwd.txt #条件 动作 end最后输出结果

awk '/nologin$/{i++;print i}' passwd.txt  #显示了执行过程

# 统计/etc/services 文件中空行的数量
awk '/^$/{i++}END{print i}' /etc/services

# seq 100 通过awk计算 1+。。。+100
seq 100| awk '{sum+=$1}END{print sum}'
```

awk执行过程

![1547275063529-b2011b62-69a4-4dd9-9456-77554a62b894.png](img/Linux%E7%B3%BB%E7%BB%9F%E7%AC%A6%E5%8F%B7%E7%B3%BB%E5%88%97-02.png)

```bash
cat > reg.txt<<EOF
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

# awk '/Xiaoyu/ {print $4}' reg.txt |awk -F: -v OFS=$ '{print $2,$3,$4}'
155$90$201

# # awk在修改OFS的时候如果你显示$1,$2$3正常显示;  $0 OFS是不生效
# awk '/Xiaoyu/ {print $4}' reg.txt |awk -F: -v OFS=$ '{print $0}'
:155:90:201

awk -vOFS=#### '{print $1,$2}' reg.txt
awk -vOFS=#### '{$1=$1;print $0}' reg.txt


```

![1553425100244-de04ee66-5b3f-4ac9-b0da-2e10a40cd892.png](img/Linux%E7%B3%BB%E7%BB%9F%E7%AC%A6%E5%8F%B7%E7%B3%BB%E5%88%97-03.png)

### 练习题

```bash
# 取出/etc/passwd中uid在1到500之间的用户名和uid号码	
# 条件：uid 1-500
# 动作 打印出来
awk -F: '$3>=1 && $3<500' passwd.txt  # 1到499
awk -F: '$3<1 || $3>500' passwd.txt   # 小于1 或大于500的


# 显示系统最近一分钟 五分钟 十五分钟的负载
w |awk -F'[ ,]+' '/load/{print $(NF-2),$(NF-1),$NF}'

# 3.显示你系统中所有的非虚拟用户的用户名和使用的shell并统计数量
awk -F: '/bash$/{i++;print $1,$NF}END{print i}' passwd.txt

# seq 100 通过awk计算 1+。。。+100
seq 100 |awk '{i+=$1}END{print i}'

# 统计access.log中所有流量总和（第10列）
awk '$10{i++}END{print i}' access.log
awk '{i+=$10}END{print i}' access.log
awk '{i+=$10}END{print i/1024^3"G"}' access.log

```

# awk 判断中循环与判断

```bash
shell编程中
if  [   ];then
xxxx
fi
awk中的显示第一行
if（NR==1）
print $0

# if(NR==1) print $0
awk  'NR==1' reg.txt 
awk  '{if(NR==1) print}' reg.txt 

# 统计{}包含 oldboy的行有多少
cat > range.txt<<EOF
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

# awk循环

```bash
shell循环

for((i=1;i<=100;i++))
do
	echo $i
done

for i in 110 120 12306
do
	echo $i
done

awk循环
for(i=1;i<=100;i++)
sum=sum+1

awk数组专用循环
for(i in h)
  print i
  
awk 'BEGIN{for(i=1;i<=100;i++)sum+=i; print sum}'
awk 'BEGIN{for(i=1;i<=100;i++){sum+=i; print sum}}'  # 加{} 显示执行过程


awk -F: '/bash$/{i++;print $NF,$1}END{print i}' /etc/passwd
# 条件：、bash$/
# 动作： {i++;print $NF,$1}
awk -F: '/bash$/{i++}{print $NF,$1}END{print i}' /etc/passwd
#条件1： /bash$/
#动作1： {i++}
#动作2： {print $NF,$1}



```

# awk 数组  统计

```bash
awk 'BEGIN{h[110] }'
  数组名称【下标】
	酒店【房间号码】
	#进行分类统计
		{h[$2]++}
	# 统计之后显示
		END {for(i in h)print i,h[i]}

awk 'BEGIN{h[110]="laowang";h[120]="tao"; print h[110],h[120]}'

# 处理以下文件内容，将域名取出并根据域名进行计数排序处理：（百度sohu面试题）
cat > url.log<<EOF
http://www.etiantian.org/index.html
http://www.etiantian.org/1.html
http://post.etiantian.org/index.html
http://mp3.etiantian.org/index.html
http://www.etiantian.org/3.html
http://post.etiantian.org/2.html
EOF

# awk -F'[/.]+' '{ h[$2]++}END{for(i in h)print i,h[i] }' url.log
www 3
mp3 1
post 2

# 统计Secure（给大家发送的）文件每个ip地址破解你密码次数显示前十名
Failed
sort –rnk2
	-r  逆序
	-n  按照数字 顺序排序
	-k  根据某一列的内容排序
  
awk '/Failed/{h[$(NF-3)]++}END{for(i in h) print i,h[i]}' secure-20161219 |sort -rnk2|head


awk -F"[/.]+"  '{h[$2]++}  END{for(i in h) print i,h[i] }'    url.txt
awk  '/Failed/{h[$(NF-3)]++}END{for(i in h) print i,h[i] }'    secure-20161219

# 统计Secure中每个用户破解的次数 显示前10
awk '/Failed/{h[$(NF-5)]++}END{for(i in h)print i,h[i]}' secure-20161219|sort -rnk2|head



```

## ## ```bash
# 请给出输出test.txt文件内容时，不包含oldboy字符串的命令。
mkdir -p /data
cat >/data/test.txt<<EOF
test
liyao
oldboy
EOF

方法1 -grep
#grep -v 过滤 显示不要的内容
grep -v "oldboy"  /data/test.txt


# 方法2 -head 显示前两行
head -n2 /data/test.txt
head -2 /data/test.txt
#head 显示文件的前几行内容 默认显示前10行

#tail 显示文件的最后几行内容 默认显示最后10行
#显示文件最后一行
tail -1 /data/test.txt


#方法3  awk
awk '/oldboy/'  /data/test.txt

# !取反
awk '!/oldboy/'  /data/test.txt

#方法4 sed   d删除 不显示了 标准输出屏幕的时候不显示了， 并没有修改文件里内容
sed '/oldboy/d'  /data/test.txt






#只查看ett.txt文件（共40行）内第20到第30行的内容
seq 40  >/data/ett.txt # 测试文件

head -30 /data/ett.txt |tail -11  

awk 'NR==20,NR==30' /data/ett.txt

# -n = 关闭默认自动打印，只打印你用 p 指定的内容
sed -n  '20,30p' /data/ett.txt





```

# 练习：

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
取出文件中正确的身份证号码的行
--------------------------------------------------------------
grep -E '[0-9]{17}[0-9X]' id.txt 

#正则表达式配合三剑客进行过滤
#配置 grep egrep 别名  过滤出来带颜色
#alias egrep='egrep --color'
#alias grep='grep --color'
#vim /etc/profile
#source /etc/profile
#cat /etc/profile | tail -n3
alias egrep='egrep --color'
alias grep='grep --color'




# 准备环境
cat >oldboy.txt <<EOF
I am oldboy teacher!
I teach linux.


I like badminton ball ,billiard ball and chinese chess!
my blog is http://oldboy.blog.51cto.com 
our size is http://blog.oldboyedu.com 
my qq is 49000448


not 4900000448.
my god ,i am not oldbey,but OLDBOY!
EOF

基础正则表达式: 
^   已什么 开头的
$  以什么结尾的
^$ 表示空格  什么符号都没有
.  任意一个字符  不会匹配空行
\  转义字符    
*  表示连续出现了0次或者0次以上      
.* 任意字符任意次数, 表示所有
^.*0  贪婪性
[ ]  将匹配一个字符范围


# 有oldboy字符的行
grep oldboy oldboy.txt
# m开头的行
grep '^m' oldboy.txt
# m结尾的行  m后面又空格不会显示
grep 'm$' oldboy.txt

# 显示文件中所有符号， -A每行结尾会有个 $
cat -A oldboy.txt

# ' $' 空格结尾的行
grep ' $' oldboy.txt

# ^$ 表示空格  什么符号都没有
cat -An oldboy.txt


# -n 显示行号 
grep -n '^$' oldboy.txt

# 排除空行
grep -v '^$' oldboy.txt

# . 任意一个字符  不会匹配空行
grep '.' oldboy.txt

# grep -o 输出匹配到的部分
# grep -o '.' oldboy.txt
I

a
m
.........

# 以. 结尾的行, \转义字符     
grep -e "\.$" oldboy.txt


# 所有回车换行符 替换成tab
tr "\n" "\t" < oldboy.txt

* 表示连续出现了0次或者0次以上

# 正则表达式 坑1      0*   会把文件都显示出来
# 0次   没有         会把文件内容都显示出来
# 0次以上  					 00000000000000
grep '0*' oldboy.txt

.* 任意字符任意次数, 表示所有
grep '.*' oldboy.txt

# ^.*o 贪婪性  按最大的范围匹配 
[root@m01 ~]# grep '^.*o' oldboy.txt
....
# my blo 算是符合匹配的, 实际按最大范围: my blog is http://oldboy.blog.51cto
my blog is http://oldboy.blog.51cto.com
....

[root@m01 ~]# grep '^o' oldboy.txt
our size is http://blog.oldboyedu.com


[] [abc] 相当与是一个符号（每次匹配一个字符）找出a或b 或c
# -o, --only-matching       show only the part of a line matching PATTERN
# 显示匹配模式的 部分内容,匹配一个换一行, 没匹配的不显示
grep -o '[abc]' oldboy.txt

 # [abc] 相当与是一个符号（每次匹配一个字符）找出a或b 或c
grep '[abc]' oldboy.txt

# a-z的所有小写字母
grep '[a-z]' oldboy.txt

# 所有大写字母
grep '[A-Z]' oldboy.txt

grep '[0-9]' oldboy.txt

grep '[a-zA-Z]' oldboy.txt
grep '[a-Z]' oldboy.txt

# -i 不区分大小写
grep -i '[a-z]' oldboy.txt


```

# 用户管理

```bash
#添加用户
useradd  oldboy
#password 设置密码
passwd oldboy

#切换用户
su - oldboy


ctrl + d 退出当前用户
```

# # > 更新: 2026-04-24 14:50:04  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/axtqt3>