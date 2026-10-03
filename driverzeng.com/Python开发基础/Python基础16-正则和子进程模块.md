# Python基础16-正则和子进程模块

## Python基础16-正则和子进程模块
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(4) 评论(0)

+ [re模块](https://blog.driverzeng.com/zenglaoshi/5347.html#toc_0)
+ [subprocess模块](https://blog.driverzeng.com/zenglaoshi/5347.html#toc_1)

>  
>
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

## re模块
---

| re模块介绍 |
| :--- |

正则就是用一些具有特殊含义的符号组合到一起（称为正则表达式）来描述字符或者字符串的方法。或者说：正则就是用来描述一类事物的规则。（在Python中）它内嵌在Python中，并通过 re 模块实现。正则表达式模式被编译成一系列的字节码，然后由用 C 编写的匹配引擎执行。

**生活中处处都是正则：**

比如我们描述：4条腿

你可能会想到的是四条腿的动物或者桌子，椅子等

继续描述：4条腿，活的

就只剩下四条腿的动物这一类了

---

| 常用匹配模式(元字符) |
| :--- |

<!-- OCR_START -->
- 模式
- 描述
- Iw
- 匹配字母数字及下划线
- 匹配非字母数字下划线
- Is
- 匹配任意空白字符，等价于tin\rf
- 匹配任意非空字符
- Vd
- 匹配任意数字，等价于[0-9]
- 匹配任意非数字
- 匹配字符串开始
- 匹配字符串结束，如果是存在换行，只匹配到换行前的结束字符串
- 匹配字符串结束
- \G
- 匹配最后匹配完成的位置
- 匹配一个换行符
- it
- 匹配一个制表符
- 匹配字符串的开头
- 匹配字符串的末尾。
- 匹配任意字符，除了换行符，当re.DOTALL标记被指定时，则可以匹配包括换行符的任意字符
- [.]
- 用来表示一组字符，单独列出：[amk]匹配'a'，'m或k
- [^.]
- 不在中的字符：[abc]匹配除了ab.c之外的字符。
- 匹配0个或多个的表达式。
- 匹配1个或多个的表达式。
- 匹配0个或1个由前面的正则表达式定义的片段，非贪婪方式
- 精确匹配n个前面表达式。
- [n.m}
- 匹配n到m次由前面的正则表达式定义的片段，贪婪方式
- 曾老湿
- Driver Zeng
- 也表示一个组
<!-- OCR_END -->

￼

---

| re模块的使用 |
| :--- |

```plain
# =================================匹配模式=================================
#一对一的匹配
# 'hello'.replace(old,new)
# 'hello'.find('pattern')
#正则匹配
import re
#\w与\W
print(re.findall('\w','hello zls 123')) #['h', 'e', 'l', 'l', 'o', 'e', 'g', 'o', 'n', '1', '2', '3']
print(re.findall('\W','hello zls 123')) #[' ', ' ']
#\s与\S
print(re.findall('\s','hello  zls  123')) #[' ', ' ', ' ', ' ']
print(re.findall('\S','hello  zls  123')) #['h', 'e', 'l', 'l', 'o', 'e', 'g', 'o', 'n', '1', '2', '3']
#\n \t都是空,都可以被\s匹配
print(re.findall('\s','hello \n zls \t 123')) #[' ', '\n', ' ', ' ', '\t', ' ']
#\n与\t
print(re.findall(r'\n','hello zls \n123')) #['\n']
print(re.findall(r'\t','hello zls\t123')) #['\n']
#\d与\D
print(re.findall('\d','hello zls 123')) #['1', '2', '3']
print(re.findall('\D','hello zls 123')) #['h', 'e', 'l', 'l', 'o', ' ', 'e', 'g', 'o', 'n', ' ']
#\A与\Z
print(re.findall('\Ahe','hello zls 123')) #['he'],\A==>^
print(re.findall('123\Z','hello zls 123')) #['he'],\Z==>$
#^与$
print(re.findall('^h','hello zls 123')) #['h']
print(re.findall('3$','hello zls 123')) #['3']
# 重复匹配：| . | * | ? | .* | .*? | + | {n,m} |
#.
print(re.findall('a.b','a1b')) #['a1b']
print(re.findall('a.b','a1b a*b a b aaab')) #['a1b', 'a*b', 'a b', 'aab']
print(re.findall('a.b','a\nb')) #[]
print(re.findall('a.b','a\nb',re.S)) #['a\nb']
print(re.findall('a.b','a\nb',re.DOTALL)) #['a\nb']同上一条意思一样
#*
print(re.findall('ab*','bbbbbbb')) #[]
print(re.findall('ab*','a')) #['a']
print(re.findall('ab*','abbbb')) #['abbbb']
#?
print(re.findall('ab?','a')) #['a']
print(re.findall('ab?','abbb')) #['ab']
#匹配所有包含小数在内的数字
print(re.findall('\d+\.?\d*',"asdfasdf123as1.13dfa12adsf1asdf3")) #['123', '1.13', '12', '1', '3']
#.*默认为贪婪匹配
print(re.findall('a.*b','a1b22222222b')) #['a1b22222222b']
#.*?为非贪婪匹配：推荐使用
print(re.findall('a.*?b','a1b22222222b')) #['a1b']
#+
print(re.findall('ab+','a')) #[]
print(re.findall('ab+','abbb')) #['abbb']
#{n,m}
print(re.findall('ab{2}','abbb')) #['abb']
print(re.findall('ab{2,4}','abbb')) #['abb']
print(re.findall('ab{1,}','abbb')) #'ab{1,}' ===> 'ab+'
print(re.findall('ab{0,}','abbb')) #'ab{0,}' ===> 'ab*'
#[]
print(re.findall('a[1*-]b','a1b a*b a-b')) #[]内的都为普通字符了，且如果-没有被转意的话，应该放到[]的开头或结尾
print(re.findall('a[^1*-]b','a1b a*b a-b a=b')) #[]内的^代表的意思是取反，所以结果为['a=b']
print(re.findall('a[0-9]b','a1b a*b a-b a=b')) #[]内的^代表的意思是取反，所以结果为['a=b']
print(re.findall('a[a-z]b','a1b a*b a-b a=b aeb')) #[]内的^代表的意思是取反，所以结果为['a=b']
print(re.findall('a[a-zA-Z]b','a1b a*b a-b a=b aeb aEb')) #[]内的^代表的意思是取反，所以结果为['a=b']
#\# print(re.findall('a\\c','a\c')) #对于正则来说a\\c确实可以匹配到a\c,但是在python解释器读取a\\c时，会发生转义，然后交给re去执行，所以抛出异常
print(re.findall(r'a\\c','a\c')) #r代表告诉解释器使用rawstring，即原生字符串，把我们正则内的所有符号都当普通字符处理，不要转义
print(re.findall('a\\\\c','a\c')) #同上面的意思一样，和上面的结果一样都是['a\\c']
#():分组
print(re.findall('ab+','ababab123')) #['ab', 'ab', 'ab']
print(re.findall('(ab)+123','ababab123')) #['ab']，匹配到末尾的ab123中的ab
print(re.findall('(?:ab)+123','ababab123')) #findall的结果不是匹配的全部内容，而是组内的内容,?:可以让结果为匹配的全部内容
print(re.findall('href="(.*?)"','<a href="http://www.baidu.com">点击</a>'))#['http://www.baidu.com']
print(re.findall('href="(?:.*?)"','<a href="http://www.baidu.com">点击</a>'))#['href="http://www.baidu.com"']
#|
print(re.findall('compan(?:y|ies)','Too many companies have gone bankrupt, and the next one is my company'))
```

---

| re模块提供的方法 |
| :--- |

```plain
# ===========================re模块提供的方法介绍===========================
import re
#1
print(re.findall('e','alex make love') )   #['e', 'e', 'e'],返回所有满足匹配条件的结果,放在列表里
#2
print(re.search('e','alex make love').group()) #e,只到找到第一个匹配然后返回一个包含匹配信息的对象,该对象可以通过调用group()方法得到匹配的字符串,如果字符串没有匹配，则返回None。
#3
print(re.match('e','alex make love'))    #None,同search,不过在字符串开始处进行匹配,完全可以用search+^代替match
#4
print(re.split('[ab]','abcd'))     #['', '', 'cd']，先按'a'分割得到''和'bcd',再对''和'bcd'分别按'b'分割
#5
print('===>',re.sub('a','A','alex make love')) #===> Alex mAke love，不指定n，默认替换所有
print('===>',re.sub('a','A','alex make love',1)) #===> Alex make love
print('===>',re.sub('a','A','alex make love',2)) #===> Alex mAke love
print('===>',re.sub('^(\w+)(.*?\s)(\w+)(.*?\s)(\w+)(.*?)$',r'\5\2\3\4\1','alex make love')) #===> love make alex
print('===>',re.subn('a','A','alex make love')) #===> ('Alex mAke love', 2),结果带有总共替换的个数
#6
obj=re.compile('\d{2}')
print(obj.search('abc123eeee').group()) #12
print(obj.findall('abc123eeee')) #['12'],重用了obj
# 补充一
import re
print(re.findall("<(?P<tag_name>\w+)>\w+</(?P=tag_name)>","<h1>hello</h1>")) #['h1']
print(re.search("<(?P<tag_name>\w+)>\w+</(?P=tag_name)>","<h1>hello</h1>").group()) #<h1>hello</h1>
print(re.search("<(?P<tag_name>\w+)>\w+</(?P=tag_name)>","<h1>hello</h1>").groupdict()) #<h1>hello</h1>
print(re.search(r"<(\w+)>\w+</(\w+)>","<h1>hello</h1>").group())
print(re.search(r"<(\w+)>\w+</\1>","<h1>hello</h1>").group())
# 补充二
import re#使用|，先匹配的先生效，|左边是匹配小数，而findall最终结果是查看分组，所有即使匹配成功小数也不会存入结果#而不是小数时，就去匹配(-?\d+)，匹配到的自然就是，非小数的数，在此处即整数#print(re.findall(r"-?\d+\.\d*|(-?\d+)","1-2*(60+(-40.35/5)-(-4*3))")) #找出所有整数['1', '-2', '60', '', '5', '-4', '3']#找到所有数字:print(re.findall('\D?(\-?\d+\.?\d*)',"1-2*(60+(-40.35/5)-(-4*3))")) # ['1','2','60','-40.35','5','-4','3']
#计算器作业参考：http://www.cnblogs.com/wupeiqi/articles/4949995.html
expression='1-2*((60+2*(-3-40.0/5)*(9-2*5/3+7/3*99/4*2998+10*568/14))-(-4*3)/(16-3*2))'
content=re.search('\(([\-\+\*\/]*\d+\.?\d*)+\)',expression).group() #(-3-40.0/5)
```

**search和findall**

```plain
#为何同样的表达式search与findall却有不同结果:
print(re.search('\(([\+\-\*\/]*\d+\.?\d*)+\)',"1-12*(60+(-40.35/5)-(-4*3))").group()) #(-40.35/5)
print(re.findall('\(([\+\-\*\/]*\d+\.?\d*)+\)',"1-12*(60+(-40.35/5)-(-4*3))")) #['/5', '*3']
#看这个例子:(\d)+相当于(\d)(\d)(\d)(\d)...,是一系列分组
print(re.search('(\d)+','123').group()) #group的作用是将所有组拼接到一起显示出来
print(re.findall('(\d)+','123')) #findall结果是组内的结果,且是最后一个组的结果
search与findall
```

```plain
#_*_coding:utf-8_*_
__author__ = 'DriverZeng'
#在线调试工具:tool.oschina.net/regex/#
import re
s='''
http://www.baidu.com
zls@driverzeng.com
你好
010-3141
'''
#最常规匹配
# content='Hello 123 456 World_This is a Regex Demo'
# res=re.match('Hello\s\d\d\d\s\d{3}\s\w{10}.*Demo',content)
# print(res)
# print(res.group())
# print(res.span())
#泛匹配
# content='Hello 123 456 World_This is a Regex Demo'
# res=re.match('^Hello.*Demo',content)
# print(res.group())
#匹配目标,获得指定数据
# content='Hello 123 456 World_This is a Regex Demo'
# res=re.match('^Hello\s(\d+)\s(\d+)\s.*Demo',content)
# print(res.group()) #取所有匹配的内容
# print(res.group(1)) #取匹配的第一个括号内的内容
# print(res.group(2)) #去陪陪的第二个括号内的内容
#贪婪匹配:.*代表匹配尽可能多的字符
# import re
# content='Hello 123 456 World_This is a Regex Demo'
#
# res=re.match('^He.*(\d+).*Demo$',content)
# print(res.group(1)) #只打印6,因为.*会尽可能多的匹配,然后后面跟至少一个数字
#非贪婪匹配:?匹配尽可能少的字符
# import re
# content='Hello 123 456 World_This is a Regex Demo'
#
# res=re.match('^He.*?(\d+).*Demo$',content)
# print(res.group(1)) #只打印6,因为.*会尽可能多的匹配,然后后面跟至少一个数字
#匹配模式:.不能匹配换行符
content='''Hello 123456 World_This
is a Regex Demo
'''
# res=re.match('He.*?(\d+).*?Demo$',content)
# print(res) #输出None
# res=re.match('He.*?(\d+).*?Demo$',content,re.S) #re.S让.可以匹配换行符
# print(res)
# print(res.group(1))
#转义:\
# content='price is $5.00'
# res=re.match('price is $5.00',content)
# print(res)
#
# res=re.match('price is \$5\.00',content)
# print(res)
#总结:尽量精简,详细的如下
    # 尽量使用泛匹配模式.*
    # 尽量使用非贪婪模式:.*?
    # 使用括号得到匹配目标:用group(n)去取得结果
    # 有换行符就用re.S:修改模式
#re.search:会扫描整个字符串,不会从头开始,找到第一个匹配的结果就会返回
# import re
# content='Extra strings Hello 123 456 World_This is a Regex Demo Extra strings'
#
# res=re.match('Hello.*?(\d+).*?Demo',content)
# print(res) #输出结果为None
#
# import re
# content='Extra strings Hello 123 456 World_This is a Regex Demo Extra strings'
#
# res=re.search('Hello.*?(\d+).*?Demo',content) #
# print(res.group(1)) #输出结果为
#re.search:只要一个结果,匹配演练,
import re
content='''
<tbody>
<tr id="4766303201494371851675" class="even "><td><div class="hd"><span class="num">1</span><div class="rk "><span class="u-icn u-icn-75"></span></div></div></td><td class="rank"><div class="f-cb"><div class="tt"><a href="/song?id=476630320"><img class="rpic" src="http://p1.music.126.net/Wl7T1LBRhZFg0O26nnR2iQ==/19217264230385030.jpg?param=50y50&quality=100"></a><span data-res-id="476630320" "
# res=re.search('<a\shref=.*?<b\stitle="(.*?)".*?b>',content)
# print(res.group(1))
#re.findall:找到符合条件的所有结果
# res=re.findall('<a\shref=.*?<b\stitle="(.*?)".*?b>',content)
# for i in res:
#     print(i)
#re.sub:字符串替换
import re
content='Extra strings Hello 123 456 World_This is a Regex Demo Extra strings'
# content=re.sub('\d+','',content)
# print(content)
#用\1取得第一个括号的内容
#用法:将123与456换位置
# import re
# content='Extra strings Hello 123 456 World_This is a Regex Demo Extra strings'
#
# # content=re.sub('(Extra.*?)(\d+)(\s)(\d+)(.*?strings)',r'\1\4\3\2\5',content)
# content=re.sub('(\d+)(\s)(\d+)',r'\3\2\1',content)
# print(content)
# import re
# content='Extra strings Hello 123 456 World_This is a Regex Demo Extra strings'
#
# res=re.search('Extra.*?(\d+).*strings',content)
# print(res.group(1))
# import requests,re
# respone=requests.get('https://book.douban.com/').text
# print(respone)
# print('======'*1000)
# print('======'*1000)
# print('======'*1000)
# print('======'*1000)
# res=re.findall('<li.*?cover.*?href="(.*?)".*?title="(.*?)">.*?more-meta.*?author">(.*?)</span.*?year">(.*?)</span.*?publisher">(.*?)</span.*?</li>',respone,re.S)
# # res=re.findall('<li.*?cover.*?href="(.*?)".*?more-meta.*?author">(.*?)</span.*?year">(.*?)</span.*?publisher">(.*?)</span>.*?</li>',respone,re.S)
#
#
# for i in res:
#     print('%s    %s    %s   %s' %(i[0].strip(),i[1].strip(),i[2].strip(),i[3].strip()))
```

---

| 举例 |
| :--- |

```plain
import re
# 待处理字符串
src = "abcdef \t 12121gaa1a _ - a * / \n a"
#在字符串中查找所有满足条件的
print(re.findall("ab",src))
#\w字母数字下划线    \W非字母数字下划线  与前面相反
print(re.findall("\w",src))
print(re.findall("\W",src))
\s 所有不可见字符   \S 可见字符
print(re.findall("\s",src))
print(re.findall("\S",src))
# \d 所有数字    \D所有非数字
print(re.findall("\d",src))
print(re.findall("\d",src))
#特殊字符直接匹配
print(re.findall("\n",src))
print(re.findall("\t",src))
# . 除了\n以外任意字符
print(re.findall(".",src))
#
print(re.findall("\d","abcdef \t 12121gaa1a _ - a * / \n a"))
#  \s \w \d . 都是匹配单个字符
# 匹配重复字符   *  +  ? {}
#  * 前面的表达式出现任意次
print(re.findall("\w\d*","1 12 aa"))
#  +重复1次或多次
print(re.findall("\d+","1 12121272163871asas6378232678a aa"))
# ?表示重复0次或1次
print(re.findall("\d?","aa bb a1c 1c1  123"))
# {m,n} 最少m次 最多n次
print(re.findall("\d{1,3}","1  12  123 1234 "))
# {m} 必须是m次
print(re.findall("[a-z]{2}","a aa aaa ssss"))
# {,m} 最大m次  0-m
print(re.findall("[a-z]{,3}","a aa aaa a1aa"))
# 从字符串1982asasa中找到所有0 1 2
# 匹配范围
# |       0|1|2   或
print(re.findall("0|1|2","1982asasa"))
# [] 字符集合  括号内的符号不是整体
print(re.findall("[012]","1982asasa"))
# ============================================ 在范围匹配时使用脱字符表示取反
# 在这里表示除了0-9之外的任意字符
print(re.findall("[^012]","1982asasa"))
# 请找出 所有的数字0-9和字母a-z A-Z  注意 减号只有在两个字符中间才有范围的意思 在两边都是普通字符
print(re.findall("[0-9a-zA-Z]","1982asa+sa"))
# ^ 匹配行首
print(re.findall("^h","hellohello"))
# # $ 匹配行未  注意写在表达式后面
print(re.findall("[a-z]oh$","lohhel9ohelloh"))
# 单词边界  指的是单词的末尾
print(re.findall("h\\b","helloh hih"))
print(re.findall("h\\B","hellhoh  hih"))
# 双斜杠??
print(re.findall("a\\\\c","aakakja\c"))
# 贪婪匹配  *  +    不是固定的特殊符号  只是一种现象
# 会一直匹配到不满足条件为止 用问号来阻止贪婪匹配(匹配最少满足条件的字符数)
print(re.findall("\w+?","ajshsjkdsd"))
print(re.findall("\w*?","ajshsjkdsd"))
# 说明时候需要阻止贪婪
src = ""
# () 用于给正则表达式分组(group) 不会改变原来的表达式逻辑意义
# 效果 优先取出括号内的内容
# 请用正则表达式取图片地址
print(re.findall("src='(.+?)'",src))
# 了解 加上?: 可以取消括号中的优先级
print(re.findall("src='(?:.+?)'",src))
print(re.findall("src='(?:www).(?:baidupic)",src))
```

---

| re模块常用方法 |
| :--- |

```plain
findall   从左往右查找所有满足条件的字符  返回一个列表
search    返回第一个匹配的字符串  结果封装为对象 span=(0, 5) 匹配的位置 match匹配的值
match     匹配行首  返回值与search相同
对于search  match 匹配的结果通过group来获取
compile  将正则表达式 封装为一个正则对象 好处是可以重复使用这个表达式
import re
print(re.search("hello"," world hello python"))
print(re.match("hello"," world hello python"))
print(re.split("hello","world hello python",maxsplit=0))
#
pattern = re.compile("hello")
print(pattern.search("world hello python",3))
print(re.sub("hello","gun","world hello Java"))
# 现有字符串如下
src = "c++|java|python|shell"
# 用正则表达式将c 和shell换位置
# 先用分组将 内容 分为三个  1.c++  2.|java|python| 3.shell
print(re.findall("(.+?)(\|.+\|)(.+)",src))
print(re.sub("(.+?)(\|.+\|)(.+)",r"\3\2\1",src))
print(re.search("(.+?)(\|.+)\|(.+)",src).group(3))
print(re.sub("(.+)(\|.+\|)(.+)",r"\3\2\1",src))
print(re.search("(.+?)\|",src))
```

## subprocess模块
---

| subprocess模块介绍 |
| :--- |

```plain
sub       子
        process  进程
    什么是进程
        正在进行中的程序   每当打开一个程序就会开启一个进程
        每个进程包含运行程序所需的所有资源
        正常情况下 不可以跨进程访问数据
        但是有些情况就需要访问别的进程数据   提供一个叫做管道的对象 专门用于跨进程通讯
    作用:用于执行系统命令
    常用方法
        run     返回一个表示执行结果的对象
        call    返回的执行的状态码
    总结  subprocess的好处是可以获取指令的执行结果
          subprocess执行指令时 可以在子进程中 这样避免造成主进程卡死
    注意 管道的read方法和文件的read有相同的问题 read后光标会到文件末尾 导致第二次无法read到数据
```

---

| subprocess模块使用 |
| :--- |

```plain
import subprocess
res = subprocess.run("tasklist",shell=True,stdout=subprocess.PIPE)
print("=====================================================")
print(res.stdout.decode("gbk"))
print(res.stderr)
res = subprocess.call("tasklist",shell=True)
print(res)
#  第一个进程a读取tasklist的内容   将数据交给另一个进程b  进程b将数据写到文件中
res1 = subprocess.Popen("tasklist",stdout=subprocess.PIPE,shell=True,stderr=subprocess.PIPE)
print("hello")
print(res1.stdout.read().decode("gbk"))
print(res1.stderr.read().decode("gbk"))
#
res2 = subprocess.Popen("findstr cmd",stdout=subprocess.PIPE,shell=True,stderr=subprocess.PIPE,stdin=res1.stdout)
print(res2.stdout.read().decode("gbk"))
#########
import  subprocess
'''
sh-3.2# ls /Users/zls/Desktop |grep txt$
mysql.txt
tt.txt
事物.txt
'''
res1=subprocess.Popen('ls /Users/zls/Desktop',shell=True,stdout=subprocess.PIPE)
res=subprocess.Popen('grep txt$',shell=True,stdin=res1.stdout,
                 stdout=subprocess.PIPE)
print(res.stdout.read().decode('utf-8'))
#等同于上面,但是上面的优势在于,一个数据流可以和另外一个数据流交互,可以通过爬虫得到结果然后交给grep
res1=subprocess.Popen('ls /Users/zls/Desktop |grep txt$',shell=True,stdout=subprocess.PIPE)
print(res1.stdout.read().decode('utf-8'))
#windows下:
# dir | findstr 'test*'
# dir | findstr 'txt$'
import subprocess
res1=subprocess.Popen(r'dir C:\Users\Administrator\PycharmProjects\test\函数备课',shell=True,stdout=subprocess.PIPE)
res=subprocess.Popen('findstr test*',shell=True,stdin=res1.stdout,
                 stdout=subprocess.PIPE)
print(res.stdout.read().decode('gbk')) #subprocess使用当前系统默认编码，得到结果为bytes类型，在windows下需要用gbk解码
```

**接收运维人员的Linux命令**

```plain
import subprocess
cmd=input('请输入一个你要执行的linux命令： ')
res=subprocess.run(cmd,stdout=subprocess.PIPE,shell=True,stderr=subprocess.PIPE)
callback=subprocess.call(cmd,stdout=subprocess.PIPE,shell=True,stderr=subprocess.PIPE)
if callback == 0:
    print(res.stdout.decode('utf-8'))
else:
    print('请输入正确的指令')
```

<!-- OCR_START -->
- PYTHON[~/Desktop/PYTHON]-../O9subprocess模块.py[PYTHON]
- PYTHON
- 09 subprocess模块.py
- 08re模块.pyX
- re_常用方法.py
- subprocess_test.py
- re_test.pyX
- import subprocess
- cmd=input（‘请输入一个你要执行的linux命令：
- res=subprocess.run(cmd,stdout=subprocess.PIPE,shell=True,stderr=subprocess.PIPE)
- callback=subprocess.call(cmd,stdout=subprocess.PIPE,shell=Truestderr=subprocess.PIPE)
- 8
- 9
- if callback=0:
- 10
- print(res.stdout.decode('utf-8'))
- 11
- else:
- 12
- print（‘请输入正确的指令）
- Run:
- 09 subprocess模块
- /Users/driverzeng/PycharmProjects/untitled1/venv/bin/python"/Users/driverzeng/Desktop/PYTHoN/o9 subprocess模块.py”
- 请输入一个你要执行的linux命令：
- ls-l
- total 160
- -rw-r--r--
- 1driverzeng
- staff
- 87May3015:5101内置函数.py
- 1151May2816:2001函数对象.py
- 1
- driverzeng
- 2614May2920:2801装饰器.py
- 489May 2816:3102函数嵌套.py
- 1256May3009:2302函数的递归调用.py
- 253May3009:4203三元表达式.py
- 488May2820:4303名称空间与作用域.py
- 1630May3014:2504列表生成式.py
- 707May2821:3904闭包函数.py
- 0May3018:1605模块的使用.py
- 520 May3109:5506序列化.py
- 1274May3114:1307loggin模块.py
- 0May31 17:3408re模块.py
- 348May 3121:2809 subprocess模块.py
- drwxr-xr-x
- 288May3018:51ATM
- 3 driverzeng
- 96May3016:40pycache
- 89 May31 14:14a1.log
- 89 May 31 14:14 a2.log
- 350 May 31 13:36 access.log
- 26 May 30 18:20 run.py
- 178May 30 16:39 spam.py
- 133 May 31 09:55 user.json
- 65May 31 09:29 zls.txt
- 65 May 31 09:32 zls1.txt
- 0May3016:17 面向过程编程.py
- 曾老湿
- Process finished with exit code0
<!-- OCR_END -->

￼

> 更新: 2020-06-25 11:17:47  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/kpuerx>