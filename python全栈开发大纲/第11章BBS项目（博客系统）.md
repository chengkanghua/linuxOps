# 第11章  BBS项目（博客系统）

#   11.1 需求分析和表结构设计
## 一 项目开发流程
## 1.1 需求分析
```plain
(1) 基于用户认证组件和Ajax实现登录验证(图片验证码)
(2) 基于forms组件和Ajax实现注册功能
(3) 设计系统首页（文章列表渲染）
(4) 设计个人站点页面
(5) 文章详情页
(6) 实现文章点赞功能
(7) 实现文章的评论
      －－－文章的评论
      －－－评论的评论
(8) 富文本编辑框和防止xss攻击
```

## 1.2 表结构设计
```plain
博客系统的表关系：
from django.db import models
# Create your models here.
from django.contrib.auth.models import AbstractUser
class UserInfo(AbstractUser):
    """
    用户信息
    """
    nid = models.AutoField(primary_key=True)
    telephone = models.CharField(max_length=11, null=True, unique=True)
    avatar = models.FileField(upload_to='avatars/', default="/avatars/default.png")
    create_time = models.DateTimeField(verbose_name='创建时间', auto_now_add=True)
    blog = models.OneToOneField(to='Blog', to_field='nid', null=True, on_delete=models.CASCADE)
    def __str__(self):
        return self.username
class Blog(models.Model):
    """
    博客信息
    """
    nid = models.AutoField(primary_key=True)
    title = models.CharField(verbose_name='个人博客标题', max_length=64)
    site_name = models.CharField(verbose_name='站点名称', max_length=64)
    theme = models.CharField(verbose_name='博客主题', max_length=32)
    def __str__(self):
        return self.title
class Category(models.Model):
    """
    博主个人文章分类表
    """
    nid = models.AutoField(primary_key=True)
    title = models.CharField(verbose_name='分类标题', max_length=32)
    blog = models.ForeignKey(verbose_name='所属博客', to='Blog', to_field='nid', on_delete=models.CASCADE)
    def __str__(self):
        return self.title
class Tag(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(verbose_name='标签名称', max_length=32)
    blog = models.ForeignKey(verbose_name='所属博客', to='Blog', to_field='nid', on_delete=models.CASCADE)
    def __str__(self):
        return self.title
class Article(models.Model):
    nid = models.AutoField(primary_key=True)
    title = models.CharField(max_length=50, verbose_name='文章标题')
    desc = models.CharField(max_length=255, verbose_name='文章描述')
    create_time = models.DateTimeField(verbose_name='创建时间', auto_now_add=True)
    content = models.TextField()
    comment_count = models.IntegerField(default=0)
    up_count = models.IntegerField(default=0)
    down_count = models.IntegerField(default=0)
    user = models.ForeignKey(verbose_name='作者', to='UserInfo', to_field='nid', on_delete=models.CASCADE)
    category = models.ForeignKey(to='Category', to_field='nid', null=True, on_delete=models.CASCADE)
    tags = models.ManyToManyField(
        to="Tag",
        through='Article2Tag',
        through_fields=('article', 'tag'),
    )
    def __str__(self):
        return self.title
class Article2Tag(models.Model):
    nid = models.AutoField(primary_key=True)
    article = models.ForeignKey(verbose_name='文章', to="Article", to_field='nid', on_delete=models.CASCADE)
    tag = models.ForeignKey(verbose_name='标签', to="Tag", to_field='nid', on_delete=models.CASCADE)
    class Meta:
        unique_together = [
            ('article', 'tag'),
        ]
    def __str__(self):
        v = self.article.title + "---" + self.tag.title
        return v
class ArticleUpDown(models.Model):
    """
    点赞表
    """
    nid = models.AutoField(primary_key=True)
    user = models.ForeignKey('UserInfo', null=True, on_delete=models.CASCADE)
    article = models.ForeignKey("Article", null=True, on_delete=models.CASCADE)
    is_up = models.BooleanField(default=True)
    class Meta:
        unique_together = [
            ('article', 'user'),
        ]
class Comment(models.Model):
    """
    评论表
    """
    nid = models.AutoField(primary_key=True)
    article = models.ForeignKey(verbose_name='评论文章', to='Article', to_field='nid', on_delete=models.CASCADE)
    user = models.ForeignKey(verbose_name='评论者', to='UserInfo', to_field='nid', on_delete=models.CASCADE)
    content = models.CharField(verbose_name='评论内容', max_length=255)
    create_time = models.DateTimeField(verbose_name='创建时间', auto_now_add=True)
    parent_comment = models.ForeignKey('self', null=True, on_delete=models.CASCADE)
    def __str__(self):
        return self.content
```

#  11.2 业务实现-数据库迁移
## 业务实现
## 2.1 创建项目
通过命令来创建一个django项目

```plain
dajngo-admin startproject cnblog
```

当然，也可以借助pycharmIDE来快速创建一个项目。

数据库因为选择mysql，所以需要重新配置一下settings文件：

```plain
创建django默认使用的是sqlite3
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
#     }
# }
# 配置mysql数据库连接参数
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME':'cnblog', # 要连接的数据库，连接前需要创建好
        'USER':'root',# 连接数据库的用户名
        'PASSWORD':'',# 连接数据库的密码
        'HOST':'127.0.0.1', # 连接主机，默认本级
        'PORT':3306 #  端口 默认3306
    }
}
```

接下里将我们设计好的模型表写入到项目的models文件中，然后数据库迁移

```plain
python3 manage.py makemigrations
python3 manage.py migrate
```

这时项目可能会报一个错误：

这是因为我们的模型表中UserInfo表继承了原生用户表，即后面以Userinfo表作为默认的用户表，但必须在配置文件中告诉django，所有需要添加配置：

```plain
AUTH_USER_MODEL = "blog.UserInfo"
```

其中，blog是userinfo所在app的名称。

然后再重新数据库迁移即可。

# 11.3 业务实现-登陆、注册
## 1 登陆功能
基于用户认证组件与Ajax实现登录功能,首先创建路由映射表：

```plain
path('login/', views.login),
```

然后创建视图:

```plain
def login(request):
    return render(request,"blog/login.html")
```

再实现具体逻辑前先将静态文件配置好,再static文件夹下创建一个blog的文件夹，将与blog功能相关的静态文件放在这个包下，实现一定的解耦，另外需要配置信息：

```plain
STATIC_URL = '/static/'
STATICFILES_DIRS=[
    os.path.join(BASE_DIR,"static"),
]
```

接下来就是完成templates文件夹下的login.html页面的设计了

```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="/static/blog/bs/css/bootstrap.css">
</head>
<body>
<h3>登录页面</h3>
<div class="container">
    <div class="row">
        <div class="col-md-6 col-lg-offset-3">
            <form>
                {% csrf_token %}
                <div class="form-group">
                    <label for="user">用户名</label>
                    <input type="text" id="user" class="form-control">
                </div>
                <div class="form-group">
                    <label for="pwd">密码</label>
                    <input type="password" id="pwd" class="form-control">
                </div>
                <div class="form-group">
                    <label for="pwd">验证码</label>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="valid_code">
                        </div>
                        <div class="col-md-6">
                            
                        </div>
                    </div>
                </div>
                <input type="button" class="btn btn-default login_btn" value="submit"><span class="error"></span>
                <a href="/register/" class="btn btn-success pull-right">注册</a>
            </form>
        </div>
    </div>
</div>
    <script src="/static/js/jquery-3.2.1.min.js"></script>
<script>
    // 刷新验证码
    $("#valid_code_img").click(function () {
        $(this)[0].src += "?"
    });
    // 登录验证
    $(".login_btn").click(function () {
        $.ajax({
            url: "",
            type: "post",
            data: {
                user: $("#user").val(),
                pwd: $("#pwd").val(),
                valid_code: $("#valid_code").val(),
                csrfmiddlewaretoken: $("[name='csrfmiddlewaretoken']").val(),
            },
            success: function (data) {
                console.log(data);
                if (data.user) {
                    if (location.search){
                        location.href = location.search.slice(6)
                    }
                    else {
                         location.href = "/index/"
                    }
                }
                else {
                    $(".error").text(data.msg).css({"color": "red", "margin-left": "10px"});
                    setTimeout(function(){
                         $(".error").text("");
                    },1000)
                }
            }
        })
    })
</script>
</body>
</html>
```

涉及到动态验证码的获取，视图函数如下：

```plain
from blog.utils import validCode
def get_valid_code_img(request):
    """
    基于PIL模块动态生成响应状态码图片
    :param request:
    :return:
    """
    img_data = validCode.get_valid_code_img(request)
    return HttpResponse(img_data)
# blog.utils
import random
def get_random_color():
        return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
def get_valid_code_img(request):
    # 方式1:
    # with open("lufei.jpg","rb") as f:
    #     data=f.read()
    # 方式2: # pip install pillow
    # from PIL import Image
    # img=Image.new("RGB",(270,40),color=get_random_color())
    #
    # with open("validCode.png","wb") as f:
    #     img.save(f,"png")
    #
    # with open("validCode.png","rb") as f:
    #     data=f.read()
    # 方式3:
    # from PIL import Image
    # from io import BytesIO
    #
    # img=Image.new("RGB",(270,40),color=get_random_color())
    # f=BytesIO()
    # img.save(f,"png")
    # data=f.getvalue()
    # 方式4:
    from PIL import Image, ImageDraw, ImageFont
    from io import BytesIO
    import random
    img = Image.new("RGB", (270, 40), color=get_random_color())
    draw = ImageDraw.Draw(img)
    kumo_font = ImageFont.truetype("static/font/kumo.ttf", size=32)
    valid_code_str = ""
    for i in range(5):
        random_num = str(random.randint(0, 9))
        random_low_alpha = chr(random.randint(95, 122))
        random_upper_alpha = chr(random.randint(65, 90))
        random_char = random.choice([random_num, random_low_alpha, random_upper_alpha])
        draw.text((i * 50 + 20, 5), random_char, get_random_color(), font=kumo_font)
        # 保存验证码字符串
        valid_code_str += random_char
    # width=270
    # height=40
    # for i in range(10):
    #     x1=random.randint(0,width)
    #     x2=random.randint(0,width)
    #     y1=random.randint(0,height)
    #     y2=random.randint(0,height)
    #     draw.line((x1,y1,x2,y2),fill=get_random_color())
    #
    # for i in range(100):
    #     draw.point([random.randint(0, width), random.randint(0, height)], fill=get_random_color())
    #     x = random.randint(0, width)
    #     y = random.randint(0, height)
    #     draw.arc((x, y, x + 4, y + 4), 0, 90, fill=get_random_color())
    print("valid_code_str", valid_code_str)
    request.session["valid_code_str"] = valid_code_str
    '''
    1 sdajsdq33asdasd
    2 COOKIE {"sessionid":sdajsdq33asdasd}
    3 django-session
      session-key       session-data
      sdajsdq33asdasd   {"valid_code_str":"12345"}
    '''
    f = BytesIO()
    img.save(f, "png")
    data = f.getvalue()
    return data
```

当浏览器加载 标签时即向服务器相应视图函数获取动态验证码。

最后完成视图函数的逻辑：

```plain
def login(request):
    """
    登录视图函数:
       get请求响应页面
       post(Ajax)请求响应字典
    :param request:
    :return:
    """
    if request.method == "POST":
        response = {"user": None, "msg": None}
        user = request.POST.get("user")
        pwd = request.POST.get("pwd")
        valid_code = request.POST.get("valid_code")
        valid_code_str = request.session.get("valid_code_str")
        if valid_code.upper() == valid_code_str.upper():
            user = auth.authenticate(username=user, password=pwd)
            if user:
                auth.login(request, user)  # request.user== 当前登录对象
                response["user"] = user.username
            else:
                response["msg"] = "用户名或者密码错误!"
        else:
            response["msg"] = "验证码错误!"
        return JsonResponse(response)
    return render(request, "login.html")
```

## 2 注册功能
**基于forms组件和Ajax实现注册功能**

### 2.1 基于forms组件设计注册页面
```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="/static/blog/bs/css/bootstrap.css">
    <script src="/static/js/jquery-3.2.1.min.js"></script>
    <style>
        #avatar_img {
            margin-left: 20px;
        }
        #avatar {
            display: none;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
<h3>注册页面</h3>
<div class="container">
    <div class="row">
        <div class="col-md-6 col-lg-offset-3">
            <form id="form">
                {% csrf_token %}
                {% for field in form %}
                    <div class="form-group">
                        <label for="{{ field.auto_id }}">{{ field.label }}</label>
                        {{ field }} <span class="error pull-right"></span>
                    </div>
                {% endfor %}
                <div class="form-group">
                    <label for="avatar">
                        头像
                        
                    </label>
                    <input type="file" id="avatar" name="avatar">
                </div>
                <input type="button" class="btn btn-default reg_btn" value="submit"><span class="error"></span>
            </form>
        </div>
    </div>
</div>
</body>
</html>
```

### 2.2 头像的预览
```plain
<script>
    // 头像预览
    $("#avatar").change(function () {
        // 获取用户选中的文件对象
        var file_obj = $(this)[0].files[0];
        // 获取文件对象的路径
        var reader = new FileReader();
        reader.readAsDataURL(file_obj);
        // 修改img的src属性 ，src=文件对象的路径
        reader.onload = function () {
            $("#avatar_img").attr("src", reader.result)
        };
    });
</script>
```

### 2.3 ajax提交注册信息
```plain
<script>
    // 基于Ajax提交数据
    $(".reg_btn").click(function () {
        //console.log($("#form").serializeArray());
        var formdata = new FormData();
        var request_data = $("#form").serializeArray();
        $.each(request_data, function (index, data) {
            formdata.append(data.name, data.value)
        });
        formdata.append("avatar", $("#avatar")[0].files[0]);
        $.ajax({
            url: "",
            type: "post",
            contentType: false,
            processData: false,
            data: formdata,
            success: function (data) {
                //console.log(data);
                if (data.user) {
                    // 注册成功
                    location.href="/login/"
                }
                else { // 注册失败
                    //console.log(data.msg)
                    // 清空错误信息
                    $("span.error").html("");
                    $(".form-group").removeClass("has-error");
                    // 展此次提交的错误信息!
                    $.each(data.msg, function (field, error_list) {
                        console.log(field, error_list);
                        if (field=="__all__"){
                            $("#id_re_pwd").next().html(error_list[0]).parent().addClass("has-error");
                        }
                        $("#id_" + field).next().html(error_list[0]);
                        $("#id_" + field).parent().addClass("has-error");
                    })
                }
            }
        })
    })
</script>
```

### 2.4 FileField，ImageFiled与Media配置
**FileField与ImageFiled**

```plain
# 表模型
class UserInfo(AbstractUser):
      avatar = models.FileField(upload_to='avatars/', default="/avatars/default.png")
# 添加数据        
avatar_obj=request.FILES.get("avatar")
user_obj=UserInfo.objects.create_user(username=user,password=pwd,email=email,avatar=avatar_obj)
# 注解：
  Dajngo实现：
    会将文件对象下载到项目的根目录中avatars文件夹中（如果没有avatar文件夹，Django会自动建）,user_obj的avatar存的是文件的相对路径。
```

**meida配置**

```plain
Media 配置之MEDIA_ROOT：
Dajngo有两种静态文件：
     ／static／    ：  js，css，img
     ／media/      :   用户上传文件
一旦配置了
        MEDIA_ROOT=os.path.join(BASE_DIR,"media")
    Dajngo实现：
      会将文件对象下载到MEDIA_ROOT中avatars文件夹中（如果没有avatar文件夹，Django会自动创建）,user_obj的avatar存的是文件的相对路径。
Media 配置之MEDIA_URl：
浏览器如何能直接访问到media中的数据
   settings.py:
      MEDIA_URL="/media/"
   urls.pt:
      # media配置:
      re_path(r"media/(?P<path>.*)$",serve,{"document_root":settings.MEDIA_ROOT})
```

### 2.5 注册功能的视图逻辑
创建路由：

```plain
path('register/', views.register)
```

创建视图函数：

```plain
from django import forms
from django.forms import widgets
from blog.models import UserInfo
from django.core.exceptions import NON_FIELD_ERRORS, ValidationError
# 用户相关的form表单
class UserForm(forms.Form):
    user=forms.CharField(max_length=32,
                         error_messages={"required":"该字段不能为空"},
                         label="用户名",
                         widget=widgets.TextInput(attrs={"class":"form-control"},)
                         )
    pwd=forms.CharField(max_length=32,
                         label="密码",
                         widget=widgets.PasswordInput(attrs={"class":"form-control"},)
                        )
    re_pwd=forms.CharField(max_length=32,
                            label="确认密码",
                            widget=widgets.PasswordInput(attrs={"class":"form-control"},)
                           )
    email=forms.EmailField(max_length=32,
                            label="邮箱",
                            widget=widgets.EmailInput(attrs={"class":"form-control"},)
                            )
    def clean_user(self):
        val=self.cleaned_data.get("user")
        user=UserInfo.objects.filter(username=val).first()
        if not user:
            return val
        else:
            raise ValidationError("该用户已注册!")
    def clean(self):
        pwd=self.cleaned_data.get("pwd")
        re_pwd=self.cleaned_data.get("re_pwd")
        if pwd and re_pwd:
            if pwd==re_pwd:
                return self.cleaned_data
            else:
                raise ValidationError("两次密码不一致!")
        else:
            return self.cleaned_data
# 注册功能的视图函数        
def register(request):
    """
    注册视图函数:
       get请求响应注册页面
       post(Ajax)请求,校验字段,响应字典
    :param request:
    :return:
    """
    if request.is_ajax():
        print(request.POST)
        form = UserForm(request.POST)
        response = {"user": None, "msg": None}
        if form.is_valid():
            response["user"] = form.cleaned_data.get("user")
            # 生成一条用户纪录
            user = form.cleaned_data.get("user")
            print("user", user)
            pwd = form.cleaned_data.get("pwd")
            email = form.cleaned_data.get("email")
            avatar_obj = request.FILES.get("avatar")
            extra = {}
            if avatar_obj:
                extra["avatar"] = avatar_obj
            UserInfo.objects.create_user(username=user, password=pwd, email=email, **extra)
        else:
            print(form.cleaned_data)
            print(form.errors)
            response["msg"] = form.errors
        return JsonResponse(response)
    form = UserForm()
    return render(request, "register.html", {"form": form})
```

# 11.4 业务实现-系统首页

## 1 系统首页
### 1.1 系统首页的页面设计
```plain
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="/static/blog/bs/css/bootstrap.css">
    <script src="/static/js/jquery-3.2.1.min.js"></script>
    <script src="/static/blog/bs/js/bootstrap.min.js"></script>
    <style>
        #user_icon {
            font-size: 18px;
            margin-right: 10px;
            vertical-align: -3px;
        }
        .pub_info{
            margin-top: 10px;
        }
        .pub_info .glyphicon-comment{
            vertical-align: -1px;
        }
    </style>
</head>
<body>
<nav class="tab navbar navbar-default">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">博客园</a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class="active"><a href="#">随笔 <span class="sr-only">(current)</span></a></li>
                <li><a href="#">新闻</a></li>
                <li><a href="#">博文</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                {% if request.user.is_authenticated %}
                    <li><a href="#"><span id="user_icon"
                                          class="glyphicon glyphicon-user"></span>{{ request.user.username }}</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                           aria-expanded="false">Dropdown <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">修改密码</a></li>
                            <li><a href="#">修改头像</a></li>
                            <li><a href="/cn_backend/">管理</a></li>
                            <li><a href="/logout/">注销</a></li>
                            <li role="separator" class="divider"></li>
                            <li><a href="#">Separated link</a></li>
                        </ul>
                    </li>
                {% else %}
                    <li><a href="/login/">登录</a></li>
                    <li><a href="/register/">注册</a></li>
                {% endif %}
            </ul>
        </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
</nav>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-warning">
                <div class="panel-heading">Panel heading without title</div>
                <div class="panel-body">
                    Panel content
                </div>
            </div>
            <div class="panel panel-info">
                <div class="panel-heading">Panel heading without title</div>
                <div class="panel-body">
                    Panel content
                </div>
            </div>
            <div class="panel panel-danger">
                <div class="panel-heading">Panel heading without title</div>
                <div class="panel-body">
                    Panel content
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="article_list">
                {% for article in article_list %}
                <div class="article-item small">
                    <h5><a href="/{{ article.user.username }}/articles/{{ article.pk }}">{{ article.title }}</a></h5>
                    <div class="article-desc">
                        <span class="media-left">
                            <a href="/{{ article.user.username }}/"></a>
                        </span>
                        <span class="media-right">
                            {{ article.desc }}
                        </span>
                    </div>
                    <div class="small pub_info">
                        <span><a href="/{{ article.user.username }}/">{{ article.user.username }}</a></span> &nbsp;&nbsp;&nbsp;
                        <span>发布于 &nbsp;&nbsp;{{ article.create_time|date:"Y-m-d H:i" }}</span>&nbsp;&nbsp;
                        <span class="glyphicon glyphicon-comment"></span>评论({{ article.comment_count }})&nbsp;&nbsp;
                        <span class="glyphicon glyphicon-thumbs-up"></span>点赞({{ article.up_count }})&nbsp;&nbsp;
                    </div>
                </div>
                    <hr>
                {% endfor %}
            </div>
        </div>
        <div class="col-md-3">
            <div class="panel panel-primary">
                <div class="panel-heading">Panel heading without title</div>
                <div class="panel-body">
                    Panel content
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">Panel heading without title</div>
                <div class="panel-body">
                    Panel content
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

### 1.2 基于admin组件录入数据
在blog/admin.py文件：

```plain
from django.contrib import admin
# Register your models here.
from blog import models
admin.site.register(models.UserInfo)
admin.site.register(models.Blog)
admin.site.register(models.Category)
admin.site.register(models.Tag)
admin.site.register(models.Article)
admin.site.register(models.ArticleUpDown)
admin.site.register(models.Article2Tag)
admin.site.register(models.Comment)
```

# 11.5 业务实现-个人站点页
## 1 个人站点页
### 1.**1 创建路由**
```plain
# 个人站点的跳转
re_path('^(?P<username>\w+)/(?P<condition>tag|category|archive)/(?P<param>.*)/$', views.home_site), # home_site(reqeust,username="yuan",condition="tag",param="python")
# 个人站点url
re_path('^(?P<username>\w+)/$', views.home_site), # home_site(reqeust,username="yuan")# 个人站点url
```

### 1**.2 创建视图函数**
```plain
def home_site(request, username, **kwargs):
    """
    个人站点视图函数
    :param request:
    :return:
    """
    print("kwargs", kwargs)  # 区分访问是的站点页面还是站点下的跳转页面
    print("username", username)
    user = UserInfo.objects.filter(username=username).first()
    # 判断用户是否存在!
    if not user:
        return render(request, "not_found.html")
    # 查询当前站点对象
    blog = user.blog
    # 1 当前用户或者当前站点对应所有文章
    # 基于对象查询
    # article_list=user.article_set.all()
    # 基于 __
    article_list = models.Article.objects.filter(user=user)
    if kwargs:
        condition = kwargs.get("condition")
        param = kwargs.get("param")  # 2012-12
        if condition == "category":
            article_list = article_list.filter(category__title=param)
        elif condition == "tag":
            article_list = article_list.filter(tags__title=param)
        else:
            year, month = param.split("/")
            article_list = article_list.filter(create_time__year=year, create_time__month=month)
    # 每一个后的表模型.objects.values("pk").annotate(聚合函数(关联表__统计字段)).values("表模型的所有字段以及统计字段")
    # 查询每一个分类名称以及对应的文章数
    # ret=models.Category.objects.values("pk").annotate(c=Count("article__title")).values("title","c")
    # print(ret)
    # 查询当前站点的每一个分类名称以及对应的文章数
    # cate_list=models.Category.objects.filter(blog=blog).values("pk").annotate(c=Count("article__title")).values_list("title","c")
    # print(cate_list)
    # 查询当前站点的每一个标签名称以及对应的文章数
    # tag_list=models.Tag.objects.filter(blog=blog).values("pk").annotate(c=Count("article")).values_list("title","c")
    # print(tag_list)
    # 查询当前站点每一个年月的名称以及对应的文章数
    # ret=models.Article.objects.extra(select={"is_recent":"create_time > '2018-09-05'"}).values("title","is_recent")
    # print(ret)
    # 方式1:
    # date_list=models.Article.objects.filter(user=user).extra(select={"y_m_date":"date_format(create_time,'%%Y/%%m')"}).values("y_m_date").annotate(c=Count("nid")).values_list("y_m_date","c")
    # print(date_list)
    # 方式2:
    # from django.db.models.functions import TruncMonth
ret=models.Article.objects.filter(user=user).annotate(month=TruncMonth("create_time")).values("month").annotate(c=Count("nid")).values_list("month","c")
    # print("ret----->",ret)
    return render(request, "home_site.html", {"username": username, "blog": blog, "article_list": article_list,})
```

### 1**.3 创建模板**
```plain
# base.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="/static/blog/css/home_site.css">
    <link rel="stylesheet" href="/static/theme/{{ blog.theme }}">
    <link rel="stylesheet" href="/static/blog/css/article_detail.css">
    <link rel="stylesheet" href="/static/blog/bs/css/bootstrap.css">
    <script src="/static/js/jquery-3.2.1.min.js"></script>
</head>
<body>
<div class="header">
    <div class="content">
        <p class="title">
            <span>{{ blog.title }}</span>
            <a href="/cn_backend/" class="backend">管理</a>
        </p>
    </div>
</div>
<div class="container">
    <div class="row">
        <div class="col-md-3 menu">
             {% load my_tags %}
             {% get_classification_style username %}
        </div>
        <div class="col-md-9">
            {% block content %}
            {% endblock %}
        </div>
    </div>
</div>
</body>
</html>
```

```plain
# home_site.html
{% extends 'base.html' %}
{% block content %}
 <div class="article_list">
                {% for article in article_list %}
                    <div class="article-item clearfix">
                        <h5><a href="/{{ article.user.username }}/articles/{{ article.pk }}">{{ article.title }}</a></h5>
                        <div class="article-desc">
                            {{ article.desc }}
                        </div>
                        <div class="small pub_info pull-right">
                            <span>发布于 &nbsp;&nbsp;{{ article.create_time|date:"Y-m-d H:i" }}</span>&nbsp;&nbsp;
                            <span class="glyphicon glyphicon-comment"></span>评论({{ article.comment_count }})&nbsp;&nbsp;
                            <span class="glyphicon glyphicon-thumbs-up"></span>点赞({{ article.up_count }})&nbsp;&nbsp;
                        </div>
                    </div>
                    <hr>
                {% endfor %}
            </div>
{% endblock %}
```

# 11.6 业务实现-文章详情页
## 1 文章详情页
创建路由：

```plain
re_path('^(?P<username>\w+)/articles/(?P<article_id>\d+)$', views.article_detail),
 # article_detail(request,username="yuan","article_id":article_id)
```

创建视图：

```plain
def article_detail(request, username, article_id):
    """
    文章详情页
    :param request:
    :param username:
    :param article_id:
    :return:
    """
    user = UserInfo.objects.filter(username=username).first()
    blog = user.blog
    article_obj = models.Article.objects.filter(pk=article_id).first()
    comment_list = models.Comment.objects.filter(article_id=article_id)
    return render(request, "article_detail.html", locals())
```

### 1.1 文章详情页的设计
```plain
{% extends "base.html" %}
{% block content %}
    {% csrf_token %}
    <div class="article_info">
        <h3 class="text-center title">{{ article_obj.title }}</h3>
        <div class="cont">
            {{ article_obj.content|safe }}
        </div>
    </div>
{% endblock %}
```

### 1.2 详情页的inclution_tag
因为详情页与个人站点页的模板一致，所以可以直接继承base.html，但是同样会遇到一个问题，即在个人站点视图函数中获取的数据要再写一遍传给模板才能渲染数据出来，这样就会出现代码的复用，所以这里的解决方案用的是django自带的一个inclution_tag功能，类似于我们之前学习过的django自定义标签

在blog应用下创建templatetags文件夹，创建一个py文件，比如my_tags.py，在该文件中自定义标签

```plain
from django import template
from django.db.models import Count
from blog import models
register=template.Library()
@register.inclusion_tag("classification.html")
def get_classification_style(username):
    user = models.UserInfo.objects.filter(username=username).first()
    blog = user.blog
    cate_list=models.Category.objects.filter(blog=blog).values("pk").annotate(c=Count("article__title")).values_list("title","c")
    tag_list=models.Tag.objects.filter(blog=blog).values("pk").annotate(c=Count("article")).values_list("title","c")
    date_list=models.Article.objects.filter(user=user).extra(select={"y_m_date":"date_format(create_time,'%%Y/%%m')"}).values("y_m_date").annotate(c=Count("nid")).values_list("y_m_date","c")
    return {"blog":blog,"cate_list":cate_list,"date_list":date_list,"tag_list":tag_list}
```

```plain
# classification.html文件
 <div>
    <div class="panel panel-warning">
                <div class="panel-heading">我的标签</div>
                <div class="panel-body">
                    {% for tag in tag_list %}
                        <p><a href="/{{ username }}/tag/{{ tag.0 }}">{{ tag.0 }}({{ tag.1 }})</a></p>
                    {% endfor %}
                </div>
            </div>
    <div class="panel panel-danger">
        <div class="panel-heading">随笔分类</div>
        <div class="panel-body">
            {% for cate in cate_list %}
                <p><a href="/{{ username }}/category/{{ cate.0 }}">{{ cate.0 }}({{ cate.1 }})</a></p>
            {% endfor %}
        </div>
    </div>
    <div class="panel panel-success">
        <div class="panel-heading">随笔归档</div>
        <div class="panel-body">
            {% for date in date_list %}
                <p><a href="/{{ username }}/archive/{{ date.0 }}">{{ date.0 }}({{ date.1 }})</a></p>
            {% endfor %}
        </div>
    </div>
 </div>
```

这个自定义的标签get_classification_style一旦在模板中被调用，首先会执行get_classification_style函数内的逻辑然后将返回的数据传送给模板classification.html去渲染，渲染完的结果就是这次get_classification_style标签调用的返回值。

### 1.3 django的渲染转义问题
当我们在数据库输入的文章标签字符串在渲染时出于安全的考虑，dajngo会将标签这样敏感的字符进行转义，防止xss攻击，所以这就导致我们发送给客户端的数据是转义后特殊符号，正文没有任何样式，无法阅读，为了解决这个问题，我们需要对渲染的数据进行safe过滤，无非就是告诉django我们信赖该数据，不需要转义，这样显示就不会有任何问题了。

```plain
<div class="cont">
            {{ article_obj.content|safe }}
 </div>
```

有同学会问，那xss攻击怎么办，其实很简单，我们存在数据库的数据本身就要确保它是以安全的，即数据在入库前是一定要进行筛选的。

### 1.4 文章点赞
#### **创建路由**
```plain
# 点赞
path("digg/",views.digg),
```

#### **点赞样式的构建**
```plain
{% extends "base.html" %}
{% block content %}
    {% csrf_token %}
    <div class="article_info">
        <h3 class="text-center title">{{ article_obj.title }}</h3>
        <div class="cont">
            {{ article_obj.content|safe }}
        </div>
        <div class="clearfix">
            <div id="div_digg">
                <div class="diggit action">
                    <span class="diggnum" id="digg_count">{{ article_obj.up_count }}</span>
                </div>
                <div class="buryit action">
                    <span class="burynum" id="bury_count">{{ article_obj.down_count }}</span>
                </div>
                <div class="clear"></div>
                <div class="diggword" id="digg_tips" style="color: red;"></div>
            </div>
        </div>
    </div>
{% endblock %}
```

#### **点赞按钮的事件绑定**
```plain
<script>
// 点赞请求
$("#div_digg .action").click(function () {
var is_up = $(this).hasClass("diggit");
$obj = $(this).children("span");
$.ajax({
    url: "/digg/",
    type: "post",
    data: {
        "csrfmiddlewaretoken": $("[name='csrfmiddlewaretoken']").val(),
        "is_up": is_up,
        "article_id": "{{ article_obj.pk }}",
    },
    success: function (data) {
        console.log(data);
        if (data.state) {
            var val = parseInt($obj.text());
            $obj.text(val + 1);
        }
        else {
            var val = data.handled ? "您已经推荐过!" : "您已经反对过!";
            $("#digg_tips").html(val);
            setTimeout(function () {
                $("#digg_tips").html("")
            }, 1000)
        }
    }
})
})
</script>
```

#### **点赞的后端视图函数**
```plain
def digg(request):
    """
    点赞功能
    :param request:
    :return:
    """
    print(request.POST)
    article_id = request.POST.get("article_id")
    is_up = json.loads(request.POST.get("is_up"))  # "true"
    # 点赞人即当前登录人
    user_id = request.user.pk
    obj = models.ArticleUpDown.objects.filter(user_id=user_id, article_id=article_id).first()
    response = {"state": True}
    if not obj:
        ard = models.ArticleUpDown.objects.create(user_id=user_id, article_id=article_id, is_up=is_up)
        queryset = models.Article.objects.filter(pk=article_id)
        if is_up:
            queryset.update(up_count=F("up_count") + 1)
        else:
            queryset.update(down_count=F("down_count") + 1)
    else:
        response["state"] = False
        response["handled"] = obj.is_up
    return JsonResponse(response)
```

### 1.5 文章评论
#### **创建路由**
```plain
# 评论
path("comment/",views.comment),
```

#### **创建评论样式**
```plain
{% extends "base.html" %}
{% block content %}
    {% csrf_token %}
    <div class="article_info">
        <h3 class="text-center title">{{ article_obj.title }}</h3>
        <div class="cont">
            {{ article_obj.content|safe }}
        </div>
        <div class="clearfix">
            <div id="div_digg">
                <div class="diggit action">
                    <span class="diggnum" id="digg_count">{{ article_obj.up_count }}</span>
                </div>
                <div class="buryit action">
                    <span class="burynum" id="bury_count">{{ article_obj.down_count }}</span>
                </div>
                <div class="clear"></div>
                <div class="diggword" id="digg_tips" style="color: red;"></div>
            </div>
        </div>
        <div class="comments list-group">
            <p>发表评论</p>
            <p>昵称：<input type="text" id="tbCommentAuthor" class="author" disabled="disabled" size="50"
                         value="{{ request.user.username }}">
            </p>
            <p>评论内容:</p>
            <textarea name="" id="comment_content" cols="60" rows="10"></textarea>
            <p>
                <button class="btn btn-default comment_btn">提交评论</button>
            </p>
        </div>
    </div>
{% endblock %}
```

#### **绑定评论提交事件**
```plain
<script>
    // 评论请求
    var pid = "";
    $(".comment_btn").click(function () {
        var content = $("#comment_content").val();
        if (pid) {
            var index = content.indexOf("\n");
            content = content.slice(index + 1)
        }
        $.ajax({
            url: "/comment/",
            type: "post",
            data: {
                "csrfmiddlewaretoken": $("[name='csrfmiddlewaretoken']").val(),
                "article_id": "{{ article_obj.pk }}",
                "content": content,
                pid: pid
            },
            success: function (data) {
                console.log(data);
                var create_time = data.create_time;
                var username = data.username;
                var content = data.content;
                var s = `
                   <li class="list-group-item">
                      <div>
                          <span>${create_time}</span>&nbsp;&nbsp;
                          <a href=""><span>${username}</span></a>
                      </div>
                      <div class="comment_con">
                          <p>${content}</p>
                      </div>
                    </li>`;
                $("ul.comment_list").append(s);
                // 清空评论框
                pid = "",
                        $("#comment_content").val("");
            }
        })
    });
    // 回复按钮事件
    $(".reply_btn").click(function () {
        $('#comment_content').focus();
        var val = "@" + $(this).attr("username") + "\n";
        $('#comment_content').val(val);
        pid = $(this).attr("comment_pk");
    })
</script>
```

#### **添加评论的视图函数**
```plain
def comment(request):
    """
    提交评论视图函数
    功能:
    1 保存评论
    2 创建事务
    3 发送邮件
    :param request:
    :return:
    """
    print(request.POST)
    article_id = request.POST.get("article_id")
    pid = request.POST.get("pid")
    content = request.POST.get("content")
    user_id = request.user.pk
    article_obj = models.Article.objects.filter(pk=article_id).first()
    # 事务操作
    with transaction.atomic():
        comment_obj = models.Comment.objects.create(user_id=user_id, article_id=article_id, content=content,
                                                    parent_comment_id=pid)
        models.Article.objects.filter(pk=article_id).update(comment_count=F("comment_count") + 1)
    response = {}
    response["create_time"] = comment_obj.create_time.strftime("%Y-%m-%d %X")
    response["username"] = request.user.username
    response["content"] = content
    # 发送邮件
    from django.core.mail import send_mail
    from cnblog import settings
    # send_mail(
    #     "您的文章%s新增了一条评论内容"%article_obj.title,
    #     content,
    #     settings.EMAIL_HOST_USER,
    #     ["916852314@qq.com"]
    # )
    import threading
    t = threading.Thread(target=send_mail, args=("您的文章%s新增了一条评论内容" % article_obj.title,
                                                 content,
                                                 settings.EMAIL_HOST_USER,
                                                 ["916852314@qq.com"])
                         )
    t.start()
    return JsonResponse(response)
```

#### **显示评论**
```plain
{% extends "base.html" %}
{% block content %}
    {% csrf_token %}
    <div class="article_info">
        <h3 class="text-center title">{{ article_obj.title }}</h3>
        <div class="cont">
            {{ article_obj.content|safe }}
        </div>
        <div class="clearfix">
            <div id="div_digg">
                <div class="diggit action">
                    <span class="diggnum" id="digg_count">{{ article_obj.up_count }}</span>
                </div>
                <div class="buryit action">
                    <span class="burynum" id="bury_count">{{ article_obj.down_count }}</span>
                </div>
                <div class="clear"></div>
                <div class="diggword" id="digg_tips" style="color: red;"></div>
            </div>
        </div>
        <div class="comments list-group">
            <p class="tree_btn">评论树</p>
            <div class="comment_tree">
            </div>
            <p>评论列表</p>
            <ul class="list-group comment_list">
                {% for comment in comment_list %}
                    <li class="list-group-item">
                        <div>
                            <a href=""># {{ forloop.counter }}楼</a> &nbsp;&nbsp;
                            <span>{{ comment.create_time|date:"Y-m-d H:i" }}</span>&nbsp;&nbsp;
                            <a href=""><span>{{ comment.user.username }}</span></a>
                            <a class="pull-right reply_btn" username="{{ comment.user.username }}"
                               comment_pk="{{ comment.pk }}">回复</a>
                        </div>
                        {% if comment.parent_comment_id %}
                            <div class="pid_info well">
                                <p>
                                    {{ comment.parent_comment.user.username }}: {{ comment.parent_comment.content }}
                                </p>
                            </div>
                        {% endif %}
                        <div class="comment_con">
                            <p>{{ comment.content }}</p>
                        </div>
                    </li>
                {% endfor %}
            </ul>
            <p>发表评论</p>
            <p>昵称：<input type="text" id="tbCommentAuthor" class="author" disabled="disabled" size="50"
                         value="{{ request.user.username }}">
            </p>
            <p>评论内容:</p>
            <textarea name="" id="comment_content" cols="60" rows="10"></textarea>
            <p>
                <button class="btn btn-default comment_btn">提交评论</button>
            </p>
        </div>
    </div>
{% endblock %}
```

#### **评论树**
```plain
def get_comment_tree(request):
    article_id = request.GET.get("article_id")
    response = list(models.Comment.objects.filter(article_id=article_id).order_by("pk").values("pk", "content", "parent_comment_id"))
    return JsonResponse(response, safe=False)
```

```plain
...               
<p class="tree_btn">评论树</p>
 <div class="comment_tree">
 </div>  
<script>
     $.ajax({
            url: "/get_comment_tree/",
            type: "get",
            data: {
                article_id: "{{ article_obj.pk }}"
            },
            success: function (comment_list) {
                console.log(comment_list);
                $.each(comment_list, function (index, comment_object) {
                    var pk = comment_object.pk;
                    var content = comment_object.content;
                    var parent_comment_id = comment_object.parent_comment_id;
                    var s = '<div class="comment_item" comment_id=' + pk + '><span>' + content + '</span></div>';
                    if (!parent_comment_id) {
                        $(".comment_tree").append(s);
                    } else {
                        $("[comment_id=" + parent_comment_id + "]").append(s);
                    }
                })
            }
        })
</script>
```

# 11.7 业务实现-后台管理

## 1 后台管理
### 1.1 页面设计
创建路由映射

```plain
# 后台管理url
re_path("cn_backend/$",views.cn_backend),
re_path("cn_backend/add_article/$",views.add_article),
```

创建后台管理首页的视图函数

```plain
@login_required
def cn_backend(request):
    """
    后台管理的首页
    :param request:
    :return:
    """
    article_list = models.Article.objects.filter(user=request.user)
    return render(request, "backend/backend.html", locals())
```

创建后台管理页面

```plain
# base.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>博客后台管理 - 博客园</title>
    <link rel="stylesheet" href="/static/blog/bs/css/bootstrap.css">
    <script src="/static/js/jquery-3.2.1.min.js"></script>
    <script src="/static/blog/bs/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/static/blog/css/backend.css">
</head>
<body>
<div class="header">
    <p class="title">
        后台管理
        <a class="info" href="/logout/">注销</a>
        <span class="info"><span class="glyphicon glyphicon-user"></span>&nbsp;&nbsp;{{ request.user.username }}</span>
    </p>
</div>
<div class="container">
    <div class="col-md-3">
        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingOne">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne"
                           aria-expanded="true" aria-controls="collapseOne">
                            操作
                        </a>
                    </h4>
                </div>
                <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body">
                        <p><a href="/cn_backend/add_article/">添加文章</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-9">
        <div>
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab"
                                                          data-toggle="tab">文章</a></li>
                <li role="presentation"><a href="#profile" aria-controls="profile" role="tab"
                                           data-toggle="tab">日记</a></li>
                <li role="presentation"><a href="#messages" aria-controls="messages" role="tab" data-toggle="tab">眼镜</a>
                </li>
                <li role="presentation"><a href="#settings" aria-controls="settings" role="tab" data-toggle="tab">相册</a>
                </li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="home">
                    {% block content %}
                    {% endblock %}
                </div>
                <div role="tabpanel" class="tab-pane" id="profile">
                    
                    
                    
                </div>
                <div role="tabpanel" class="tab-pane" id="messages">
                    
                    
                    <br>
                    
                    
                    
                </div>
                <div role="tabpanel" class="tab-pane" id="settings">
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
```

```plain
{% extends 'backend/base.html' %}
{% block content %}
 <div class="article_list small">
     <table class="table table-hover table-striped">
         <thead>
             <th>标题</th>
             <th>评论数</th>
             <th>点赞数</th>
             <th>操作</th>
             <th>操作</th>
         </thead>
         <tbody>
             {% for article in article_list %}
             <tr>
                 <td>{{ article.title }}</td>
                 <td>{{ article.comment_count }}</td>
                 <td>{{ article.up_count }}</td>
                 <td><a href="">编辑</a></td>
                 <td><a href="">删除</a></td>
             </tr>
             {% endfor %}
         </tbody>
     </table>
</div>
{% endblock %}
```

创建添加文章页面

```plain
{% extends 'backend/base.html' %}
{% block content %}
<form action="" method="post">
    {% csrf_token %}
   <div class="add_article">
     <div class="alert-success text-center">添加文章</div>
     <div class="add_article_region">
          <div class="title form-group">
             <label for="">标题</label>
             <div>
                 <input type="text" name="title">
             </div>
         </div>
         <div class="content form-group">
             <label for="">内容(Kindeditor编辑器，不支持拖放/粘贴上传图片) </label>
             <div>
                 <textarea name="content" id="article_content" cols="30" rows="10"></textarea>
             </div>
         </div>
         <input type="submit" class="btn btn-default">
     </div>
</div>
</form>   
{% endblock %}
```

### 1.2 富文本编辑器
KindEditor 是一套开源的在线HTML编辑器，主要用于让用户在网站上获得所见即所得编辑效果，开发人员可以用 KindEditor 把传统的多行文本输入框(textarea)替换为可视化的富文本输入框。 KindEditor 使用 JavaScript 编写，可以无缝地与 Java、.NET、PHP、ASP 等程序集成，比较适合在 CMS、商城、论坛、博客、Wiki、电子邮件等互联网应用上使用。

为了能够更好地在后台编辑文章，我们在项目中引入富文本编辑器中的其中一款kindeditor

```plain
<script src="/static/js/jquery-3.2.1.min.js"></script>
<script charset="utf-8" src="/static/blog/kindeditor/kindeditor-all.js"></script>
<script>
    KindEditor.ready(function(K) {
            window.editor = K.create('#article_content',{
                width:"800",
                height:"600",
                resizeType:0,
                uploadJson:"/upload/",
                extraFileUploadParams:{
                    csrfmiddlewaretoken:$("[name='csrfmiddlewaretoken']").val()
                },
                filePostName:"upload_img"
            });
    });
</script>
```

后端对应设置：

路由：

```plain
# 文本编辑器上传图片url
path('upload/', views.upload),
```

视图：

```plain
def upload(request):
    """
    编辑器上传文件接受视图函数
    :param request:
    :return:
    """
    print(request.FILES)
    img_obj=request.FILES.get("upload_img")
    print(img_obj.name)
    path=os.path.join(settings.MEDIA_ROOT,"add_article_img",img_obj.name)
    with open(path,"wb") as f:
        for line in img_obj:
            f.write(line)
    return HttpResponse("ok")
```

### 1.3 添加文章的逻辑实现
```plain
from bs4 import BeautifulSoup
@login_required
def add_article(request):
    """
    后台管理的添加书籍视图函数
    :param request:
    :return:
    """
    if request.method == "POST":
        title = request.POST.get("title")
        content = request.POST.get("content")
        # 防止xss攻击,过滤script标签
        soup=BeautifulSoup(content,"html.parser")
        for tag in soup.find_all():
            print(tag.name)
            if tag.name=="script":
                tag.decompose()
        # 构建摘要数据,获取标签字符串的文本前150个符号
        desc=soup.text[0:150]+"..."
        models.Article.objects.create(title=title,desc=desc,content=str(soup), user=request.user)
        return redirect("/cn_backend/")
    return render(request, "backend/add_article.html")
```

OVER!

> 更新: 2021-01-16 21:33:33  
> 原文: <https://www.yuque.com/chengkanghua/kfeaim/kaiic4>