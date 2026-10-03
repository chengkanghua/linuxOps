# Python进阶37-smtp及Django发邮件

## Python进阶37-smtp及Django发邮件
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(2) 评论(0)

+ [一 使用SMTP模块发送邮件](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_0)
+ [二 发送html格式邮件](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_1)
+ [三 发送带附件的邮件](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_2)
+ [四 Django发送邮件](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_3)
        * [在setting中配置](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_4)
        * [view视图函数](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_5)
        * [一次性发多封邮件](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_6)
        * [携带附件或发送html（需要接收方支持）](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_7)
+ [各大邮箱smtp服务器及端口](https://blog.driverzeng.com/zenglaoshi/6129.html#toc_8)

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

## 一 使用SMTP模块发送邮件
```plain
import smtplib
from email.mime.text import MIMEText
from email.header import Header
msg_from = '***@qq.com'  # 发送方邮箱
passwd = '****'  # 填入发送方邮箱的授权码(填入自己的授权码，相当于邮箱密码)
msg_to = ['****@qq.com','**@163.com','*****@163.com']  # 收件人邮箱
# msg_to = '133411023@qq.com'  # 收件人邮箱
subject = "邮件标题"  # 主题
content = "邮件内容，我是邮件内容，哈哈哈"
# 生成一个MIMEText对象（还有一些其它参数）
msg = MIMEText(content)
# 放入邮件主题
msg['Subject'] = subject
# 也可以这样传参
# msg['Subject'] = Header(subject, 'utf-8')
# 放入发件人
msg['From'] = msg_from
# 放入收件人
# msg['To'] = '133411023@qq.com'
# msg['To'] = '发给你的邮件啊'
try:
    # 通过ssl方式发送，服务器地址，端口
    s = smtplib.SMTP_SSL("smtp.qq.com", 465)
    # 登录到邮箱
    s.login(msg_from, passwd)
    # 发送邮件：发送方，收件方，要发送的消息
    s.sendmail(msg_from, msg_to, msg.as_string())
    print('成功')
except s.SMTPException as e:
    print(e)
finally:
    s.quit()
```

## 二 发送html格式邮件
```plain
import smtplib
from email.mime.text import MIMEText
from email.header import Header
msg_from = '253097001@qq.com'  # 发送方邮箱
passwd = 'ldoetnwqdjqqbjjj'  # 填入发送方邮箱的授权码(填入自己的授权码，相当于邮箱密码)
msg_to = ['133411023@qq.com']  # 收件人邮箱
# msg_to = '133411023@qq.com'  # 收件人邮箱
subject = "邮件标题"  # 主题
# *************发送html的邮件**********
content = '''
<p>Python 邮件发送测试...</p>
<p><a href="http://www.baidu.com">这是一个链接</a></p>
'''
# 生成一个MIMEText对象
msg = MIMEText(content)
# 放入邮件主题
msg['Subject'] = subject
# 也可以这样传参
# msg['Subject'] = Header(subject, 'utf-8')
# 放入发件人
msg['From'] = msg_from
# 放入收件人
# msg['To'] = '133411023@qq.com'
# msg['To'] = '发给你的邮件啊'
try:
    # 通过ssl方式发送
    s = smtplib.SMTP_SSL("smtp.qq.com", 465)
    # 登录到邮箱
    s.login(msg_from, passwd)
    # 发送邮件：发送方，收件方，要发送的消息
    s.sendmail(msg_from, msg_to, msg.as_string())
    print('成功')
except s.SMTPException as e:
    print(e)
finally:
    s.quit()
```

## 三 发送带附件的邮件
```plain
import smtplib
from email.mime.text import MIMEText
from email.header import Header
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email import  encoders
msg_from = '253097001@qq.com'  # 发送方邮箱
passwd = '***'  # 填入发送方邮箱的授权码(填入自己的授权码，相当于邮箱密码)
msg_to = ['133411023@qq.com']  # 收件人邮箱
subject = "邮件标题"  # 主题
# 创建一个带附件的实例
msg = MIMEMultipart()
# 放入邮件主题
msg['Subject'] = subject
# 也可以这样传参
# msg['Subject'] = Header(subject, 'utf-8')
# 放入发件人
msg['From'] = msg_from
# 邮件正文内容
msg.attach(MIMEText('Python 邮件发送测试……', 'plain', 'utf-8'))
# 构造附件1，传送当前目录下的 test.txt 文件
att1 = MIMEText(open('test.txt', 'rb').read(), 'base64', 'utf-8')
att1["Content-Type"] = 'application/octet-stream'
# 这里的filename可以任意写，写什么名字，邮件中显示什么名字
att1["Content-Disposition"] = 'attachment; filename="test.txt"'
msg.attach(att1)
# 构造附件2，
with open('test.png', 'rb') as f:
    # 设置附件的MIME和文件名，这里是png类型:
    mime = MIMEBase('image', 'png', filename='test.png')
    # 加上必要的头信息:
    mime.add_header('Content-Disposition', 'attachment', filename='test.png')
    mime.add_header('Content-ID', '<0>')
    mime.add_header('X-Attachment-Id', '0')
    # 把附件的内容读进来:
    mime.set_payload(f.read())
    # 用Base64编码:
    encoders.encode_base64(mime)
    # 添加到MIMEMultipart:
    msg.attach(mime)
# 构造附件3，图片格式
fp = open('test.png', 'rb')
msgImage = MIMEImage(fp.read())
fp.close()
# 定义图片 ID，在 HTML 文本中引用
msgImage.add_header('Content-ID', '<image1>')
msg.attach(msgImage)
try:
    # 通过ssl方式发送
    s = smtplib.SMTP_SSL("smtp.qq.com", 465)
    # 登录到邮箱
    s.login(msg_from, passwd)
    # 发送邮件：发送方，收件方，要发送的消息
    s.sendmail(msg_from, msg_to, msg.as_string())
    print('成功')
except s.SMTPException as e:
    print(e)
finally:
    s.quit()
```

## 四 Django发送邮件
#### 在setting中配置
```plain
# EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.qq.com'  # 如果是 163 改成 smtp.163.com
EMAIL_PORT = 465
EMAIL_HOST_USER = '253097001@qq.com'  # 帐号
EMAIL_HOST_PASSWORD = '***'  # 密码
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
#这样收到的邮件，收件人处就会这样显示
#DEFAULT_FROM_EMAIL = 'zls<'253097001@qq.com>'
EMAIL_USE_SSL = True   #使用ssl
#EMAIL_USE_TLS = False # 使用tls
#EMAIL_USE_SSL 和 EMAIL_USE_TLS 是互斥的，即只能有一个为 True
```

#### view视图函数
```plain
from django.core.mail import send_mail
    import threading
    from mybbs import settings
    t = threading.Thread(target=send_mail, args=("您的文章%s新增了一条评论内容" ,
                                                 'ddd',
                                                 settings.EMAIL_HOST_USER,
                                                 ["133411023@qq.com"])
                         )
    t.start()
```

#### 一次性发多封邮件
```plain
from django.core.mail import send_mass_mail
message1 = ('第一封邮件标题', '这是邮件内容', 'from@example.com', ['first@example.com', 'other@example.com'])
message2 = ('第二封邮件标题', '这是邮件内容', 'from@example.com', ['second@test.com'])
'''
fail_silently: （可选）布尔值。为 False 时， send_mail 会抛出 smtplib.SMTPException 异常。smtplib 文档列出了所有可能的异常。 这些异常都是 SMTPException 的子类
'''
send_mass_mail((message1, message2), fail_silently=False)
'''
send_mail 每次发邮件都会建立一个连接，发多封邮件时建立多个连接。而 send_mass_mail 是建立单个连接发送多封邮件，所以一次性发送多封邮件时 send_mass_mail 要优于 send_mail。
'''
```

#### 携带附件或发送html（需要接收方支持）
```plain
from django.core.mail import EmailMultiAlternatives
# subject 主题 content 内容 to_addr 是一个列表，发送给哪些人
msg = EmailMultiAlternatives('邮件标题', '邮件内容', '发送方', ['接收方'])
msg.content_subtype = "html"
# 添加附件（可选）
msg.attach_file('test.txt')
# 发送
msg.send()
```

备注：send_mail 每次发邮件都会建立一个连接，发多封邮件时建立多个连接。而 send_mass_mail 是建立单个连接发送多封邮件，所以一次性发送多封邮件时 send_mass_mail 要优于 send_mail。

## 各大邮箱smtp服务器及端口
```plain
新浪邮箱smtp服务器
外发服务器:smtp.vip.sina.com
收件服务器:pop3.vip.sina.com
新浪免费邮件
外发服务器:smtp.sina.com.cn
收件服务器:pop3.sina.com.cn
163邮箱smtp服务器
pop： pop.163.com
smtp： smtp.163.com
QQ邮箱smtp服务器及端口
接收邮件服务器：imap.exmail.qq.com，使用SSL，端口号993
发送邮件服务器：smtp.exmail.qq.com，使用SSL，端口号465或587
yahoo邮箱smtp服务器
接：pop.mail.yahoo.com.cn
发：smtp.mail.yahoo.com
126邮箱smtp服务器
pop： pop.126.com
smtp： smtp.126.com
新浪免费邮箱
POP3：pop.sina.com
SMTP：smtp.sina.com
SMTP端口号：25
新浪VIP邮箱
POP3：pop3.vip.sina.com
SMTP：smtp.vip.sina.com
SMTP端口号：25
新浪企业邮箱
POP3：pop.sina.com
SMTP：smtp.sina.com
SMTP端口号：25
雅虎邮箱
POP3：pop.mail.yahoo.cn
SMTP：smtp.mail.yahoo.cn
SMTP端口号：25
搜狐邮箱
POP3：pop3.sohu.com
SMTP：smtp.sohu.com
SMTP端口号：25
TOM邮箱
POP3：pop.tom.com
SMTP：smtp.tom.com
SMTP端口号：25
Gmail邮箱
POP3：pop.gmail.com
SMTP：smtp.gmail.com
SMTP端口号：587 或 25
QQ邮箱
POP3：pop.exmail.qq.com
SMTP：smtp.exmail.qq.com
SMTP端口号：25
263邮箱
域名：263.net
POP3：263.net
SMTP：smtp.263.net
SMTP端口号：25
域名：x263.net
POP3：pop.x263.net
SMTP：smtp.x263.net
SMTP端口号：25
域名：263.net.cn
POP3：263.net.cn
SMTP：263.net.cn
SMTP端口号：25
域名：炫我型
POP3：pop.263xmail.com
SMTP：smtp.263xmail.com
SMTP端口号：25
21CN 免费邮箱
POP3：pop.21cn.com
SMTP：smtp.21cn.com
IMAP：imap.21cn.com
SMTP端口号：25
21CN 经济邮邮箱
POP3：pop.21cn.com
SMTP：smtp.21cn.com
SMTP端口号：25
21CN 商务邮邮箱
POP3：pop.21cn.net
SMTP：smtp.21cn.net
SMTP端口号：25
21CN 快感邮箱
POP3：vip.21cn.com
SMTP：vip.21cn.com
SMTP端口号：25
21CN Y邮箱
POP3：pop.y.vip.21cn.com
SMTP：smtp.y.vip.21cn.com
SMTP端口号：25
中华网任我邮邮箱
POP3：rwpop.china.com
SMTP：rwsmtp.china.com
SMTP端口号：25
中华网时尚、商务邮箱
POP3：pop.china.com
SMTP：smtp.china.com
SMTP端口号：25
```

> 更新: 2020-06-25 12:06:57  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/dgldsl>