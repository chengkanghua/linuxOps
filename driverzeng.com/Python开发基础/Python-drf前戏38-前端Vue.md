# Python-drf前戏38-前端Vue

## Python-drf前戏38-前端Vue
2019-04-29 分类：[Python](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91/python), [后端开发](https://blog.driverzeng.com/zenglaoshi/category/linux/%e5%90%8e%e7%ab%af%e5%bc%80%e5%8f%91) 阅读(2) 评论(0)

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

## Vue介绍
| Vue介绍 |
| :--- |

介绍个锤子，想看Vue，请前往我博客前端开发文章中查看

[https://blog.driverzeng.com/zenglaoshi/5120.html](https://blog.driverzeng.com/zenglaoshi/5120.html)

[Vue](https://cn.vuejs.org/)

### _渐进式 JavaScript 框架_
```plain
通过对框架的了解与运用程度，来决定其在整个项目中的应用范围，最终可以独立以框架方式完成整个web前端项目
```

## 一、走进Vue
#### 1、what -- 什么是Vue
```plain
可以独立完成前后端分离式web项目的JavaScript框架
```

#### 2、why -- 为什么要学习Vue
```plain
三大主流框架之一：Angular React Vue
先进的前端设计模式：MVVM
可以完全脱离服务器端，以前端代码复用的方式渲染整个页面：组件化开发
```

#### 3、special -- 特点
```plain
单页面web应用
数据驱动
数据的双向绑定
虚拟DOM
```

#### 4、how -- 如何使用Vue
+ 开发版本：[vue.js](https://vuejs.org/js/vue.js)
+ 生产版本：[vue.min.js](https://vuejs.org/js/vue.min.js)

```plain
<div id="app">
    {{ }}
</div>
<script src="js/vue.min.js"></script>
<script>
    new Vue({
        el: '#app'
    })
</script>
```

## 二、Vue实例
#### 1、el：实例
```plain
new Vue({
    el: '#app'
})
// 实例与页面挂载点一一对应
// 一个页面中可以出现多个实例对应多个挂载点
// 实例只操作挂载点内部内容
```

#### 2、data：数据
```plain
<div id='app'>
    {{ msg }}
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            msg: '数据',
        }
    })
    console.log(app.$data.msg);
    console.log(app.msg);
</script>
<!-- data为插件表达式中的变量提供数据 -->
<!-- data中的数据可以通过Vue实例直接或间接访问-->
```

#### 3、methods：方法
```plain
<style>
    .box { background-color: orange }
</style>
<div id='app'>
    <p class="box" v-on:click="pClick">测试</p>
    <p class="box" v-on:mouseover="pOver">测试</p>
</div>
<script>
    var app = new Vue({
        el: '#app',
        methods: {
            pClick () {
                // 点击测试
            },
            pOver () {
                // 悬浮测试
            }
        }
    })
</script>
<!-- 了解v-on:为事件绑定的指令 -->
<!-- methods为事件提供实现体-->
```

#### 4、computed：计算
```plain
<div id="app">
    <input type="text" v-model="a">
    <input type="text" v-model="b">
    <div>
        {{ c }}
    </div>
</div>
<script>
    // 一个变量依赖于多个变量
    new Vue({
        el: "#app",
        data: {
            a: "",
            b: "",
        },
        computed: {
            c: function() {
                // this代表该vue实例
                return this.a + this.b;
            }
        }
    })
</script>
```

#### 5、watch：监听
```plain
<div id="app">
    <input type="text" v-model="ab">
    <div>
        {{ a }}
        {{ b }}
    </div>
</div>
<script>
    // 多个变量依赖于一个变量
    new Vue({
        el: "#app",
        data: {
            ab: "",
            a: "",
            b: "",
        },
        watch: {
            ab: function() {
                // 逻辑根据需求而定
                this.a = this.ab[0];
                this.b = this.ab[1];
            }
        }
    })
</script>
```

#### 6、delimiters：分隔符
```plain
<div id='app'>
    ${ msg }
</div>
<script>
    new Vue({
        el: '#app',
        data: {
            msg: 'message'
        },
        delimiters: ['${', '}']
    })
</script>
```

## 三、[生命周期钩子](https://cn.vuejs.org/v2/api/#%E9%80%89%E9%A1%B9-%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E9%92%A9%E5%AD%90)
+ 表示一个vue实例从创建到销毁的这个过程,将这个过程的一些时间节点赋予了对应的钩子函数
+ 钩子函数: 满足特点条件被回调的方法

```plain
new Vue({
    el: "#app",
    data: {
        msg: "message"
    },
    beforeCreate () {
        console.log("实例刚刚创建");
        console.log(this.msg
                    
    },
    created () {
        console.log("实例创建成功, data, methods已拥有");
        console.log(this.msg);
    },
    mounted () {
        console.log("页面已被vue实例渲染, data, methods已更新");
    }
    // 拿到需求 => 确定钩子函数 => 解决需求的逻辑代码块
})
```

## 四、Vue指令
#### 1、文本相关指令
```plain
<div id="app">
    <!-- 插值表达式 -->
    <p>{{ msg }}</p>
    <!-- eg:原文本会被msg替换 -->
    <p v-text='msg'>原文本</p>
    <!-- 可以解析带html标签的文本信息 -->
    <p v-html='msg'></p>
    <!-- v-once控制的标签只能被赋值一次 -->
    <p v-once>{{ msg }}</p>
</div>
<script type="text/javascript">
    // 指令: 出现在html标签中可以被vue解析处理的全局属性
    new Vue({
        el: "#app",
        data: {
            msg: "message"
        }
    })
</script>
```

#### 2、斗篷指令
```plain
<style type="text/css">
    [v-cloak] { display: none; }
</style>
<div id="app" v-cloak>
    {{ msg }}
</div>
<script src="js/vue.min.js"></script>
<script type="text/javascript">
    new Vue({
        el: "#app",
        data: {
            msg: "message"
        }
    })
</script>
<!-- 避免页面闪烁-->
```

#### 3、属性指令
```plain
<!-- 给自定义全局属性绑定变量 -->
<p v-bind:abc="abc"></p>
<!-- 以原字符串形式绑定全局属性 -->
<p v-bind:title="'abc'"></p>
<!-- 单类名绑定 -->
<p v-bind:class="c1"></p>
<!-- 多类名绑定 -->
<p v-bind:class="[c2, c3]"></p>
<!-- 类名状态绑定 -->
<p v-bind:class="{c4: true|false|var}"></p>
<!-- 多类名状态绑定 -->
<p v-bind:class="[{c5: true}, {c6: flase}]"></p>
<!-- 样式绑定 -->
<div :style="div_style"></div>
<div :style="{width: '100px', height: '100px', backgroundColor: 'blue'}"></div>
<script type="text/javascript">
    new Vue({
        el:"#app",
        data: {
            abc: "abc",
            c1: "p1",
            c2: "p2",
            c3: "p3",
            div_style: {
                width: "200px",
                height: "200px",
                backgroundColor: "cyan"
            }
        }
    })
</script>
<!-- v-bind: 指令可以简写为 : -->
```

#### 4、事件指令
```plain
<!-- v-on: 指令 简写 @ -->
<!-- 不传参事件绑定，但事件回调方法可以获取事件对象 -->
<p @click="fn"></p>
<!-- ()可以传入具体实参 -->
<p @click="fn()"></p>
<!-- ()情况下，事件对象应该显式传入 -->
<p @click="fn($event)"></p>
```

#### 5、表单指令
```plain
<div id="app">
    <!-- v-model针对于表单元素 -->
    <form action="" method="get">
        <!-- 1、双向绑定：服务于文本输入框 -->
        <!-- v-model存储的值为输入框的value值 -->
        <div>
            <input type="text" name="usr" v-model="in_val">
            <input type="password" name="ps" v-model="in_val" >
            <textarea name="info" v-model="in_val"></textarea>
        </div>
        <!-- 2、单选框 -->
        <div>
            <!-- 单选框是以name进行分组，同组中只能发生单选 -->
            <!-- v-model存储的值为单选框的value值 -->
            男：<input type="radio" name="sex" value="男" v-model="ra_val">
            女：<input type="radio" name="sex" value="女" v-model="ra_val">
            {{ ra_val }}
        </div>
        <!-- 3、单一复选框 -->
        <!-- v-model存储的值为true|false -->
        <!-- 或者为自定义替换的值 -->
        <div>
            <input type="checkbox" v-model='sin_val' true-value="选中" false-value="未选中" />
            {{ sin_val }}
        </div>
        <!-- 4、多复选框 -->
        <!-- v-model存储的值为存储值多复选框value的数组 -->
        <div>
            <input type="checkbox" value="喜好男的" name="cless" v-model='more_val' />
            <input type="checkbox" value="喜好女的" name="cless" v-model='more_val' />
            <input type="checkbox" value="不挑" name="cless" v-model='more_val' />
            {{ more_val }}
        </div>
    </form>
</div>
<script type="text/javascript">
    new Vue({
        el: '#app',
        data: {
            in_val: '',
            // 默认值可以决定单选框默认选项
            ra_val: '男',
            // 默认值为true，单一复选框为选中，反之false为不选中
            sin_val: '',
            // 数组中存在的值对应的复选框默认为选中状态
            more_val: ['喜好女的','不挑']
        }
    })
</script>
```

#### 6、条件指令
```plain
<div id="app">
    <button @click="toggle">显隐切换</button>
    <!-- v-if -->
    <div class="box r" v-if="isShow"></div>
    <!-- v-show -->
    <div class="box o" v-show="isShow"></div>
    <!-- 1.条件渲染的值为true|false -->
    <!-- 2.true代表标签显示方式渲染 -->
    <!-- 3.false v-if不渲染到页面,v-show以display:none渲染到页面,但也不会显示 -->
    <!-- v-if v-else-if v-else 案例 -->
    <ul>
        <li @mouseover="changeWrap(0)">red</li>
        <li @mouseover="changeWrap(1)">green</li>
        <li @mouseover="changeWrap(2)">blue</li>
    </ul>
    <!-- red页面逻辑结构 -->
    <div class="wrap red" v-if="tag == 0" key="0">...</div>
    <!-- green页面逻辑结构 -->
    <div class="wrap green" v-else-if="tag == 1" key="1">...</div>
    <!-- blue页面逻辑结构 -->
    <div class="wrap blue" v-else key="2">...</div>
    <!-- v-if相关分支操作,在未显示情况下,是不会被渲染到页面中 -->
    <!-- 通过key全局属性操作后,渲染过的分支会建立key对应的缓存,提高下一次渲染速度 -->
    <!-- v-show 案例 -->
    <ul>
        <li @mouseover="changeMain(0)">red</li>
        <li @mouseover="changeMain(1)">green</li>
        <li @mouseover="changeMain(2)">blue</li>
    </ul>
    <!-- red页面逻辑结构 -->
    <div class="main red" v-show="whoShow(0)">...</div>
    <!-- green页面逻辑结构 -->
    <div class="main green" v-show="whoShow(1)">...</div>
    <!-- blue页面逻辑结构 -->
    <div class="main blue" v-show="whoShow(2)">...</div>
</div>
<script type="text/javascript">
    new Vue({
        el: "#app",
        data: {
            isShow: false,
            tag: 0,
            flag: 0
        },
        methods: {
            toggle () {
                this.isShow = !this.isShow;
            },
            changeWrap (num) {
                this.tag = num;
            },
            changeMain (num) {
                // this.flag num
                this.flag = num;
            },
            whoShow (num) {
                // this.flag num
                return this.flag == num;
            }
        }
    })
</script>
```

#### 7、循环指令
```plain
<div id="app">
    <h1>{{ msg }}</h1>
    <!-- v-for="item in items" -->
    <!-- 遍历的对象: 数组[] 对象(字典){} -->
    <ul>
        <li>{{ list[0] }}</li>
        <li>{{ list[1] }}</li>
        <li>{{ list[2] }}</li>
        <li>{{ list[3] }}</li>
        <li>{{ list[4] }}</li>
    </ul>
    <!-- n为遍历的元素值 -->
    <ul>
        <li v-for="n in list">{{ n }}</li>
    </ul>
    <!-- 一般列表渲染需要建立缓存 -->
    <!-- 列表渲染是循环,需要赋值变量给key,使用key需要v-bind:处理 -->
    <!-- v-for变量数组[]时,接收两个值时,第一个为元素值,第二个为元素索引 -->
    <ul>
        <li v-for="(n, i) in list" :key="i">value:{{ n }} | index: {{ i }}</li>
    </ul>
    <ul>
        <li>{{ dic['name'] }}</li>
        <li>{{ dic.age }}</li>
        <li>{{ dic.gender }}</li>
    </ul>
    <!-- v-for变量对象{}时,接收三个值时,第一个为元素值,第二个为元素键,第三个为元素索引 -->
    <ul>
        <li v-for="(v, k, i) in dic" :key="k">value:{{ v }} | key:{{ k }} | index: {{ i }}</li>
    </ul>
    <!-- 遍历的嵌套 -->
    <div v-for="(person, index) in persons" :key="index" style="height: 21px;">
        <div v-for="(v, k) in person" :key="k" style="float: left;">{{ k }} : {{ v }}&nbsp;&nbsp;&nbsp;</div>
    </div>
</div>
<script type="text/javascript">
    new Vue({
        el: "#app",
        data: {
            msg: "列表渲染",
            list: [1, 2, 3, 4, 5],
            dic: {
                name: 'zero',
                age: 88888,
                gender: 'god'
            },
            persons: [
                {name: "zero", age: 8},
                {name: "egon", age: 78},
                {name: "liuXX", age: 77},
                {name: "yXX", age: 38}
            ]
        }
    })
</script>
```

#### 8、todolist案例
```plain
<div id="app">
    <div>
        <input type="text" v-model="val">
        <button type="button" @click="submitMsg">提交</button>
    </div>
    <ul>
        <li v-for="(v, i) in list" :key="i" @click="removeMsg(i)">{{ v }}</li>
    </ul>
    {{ list }}
</div>
<script type="text/javascript">
    new Vue({
        el: "#app",
        data: {
            val: "",
            list: []
        },
        methods: {
            submitMsg () {
                if (this.val) {
                    this.list.push(this.val);
                    this.val = ""
                }
            },
            removeMsg(index) {
                this.list.splice(index, 1)
            }
        }
    })
</script>
```

## 五、组件
+ 每一个组件都是一个vue实例
+ 每个组件均具有自身的模板template，根组件的模板就是挂载点
+ 每个组件模板只能拥有一个根标签
+ 子组件的数据具有作用域，以达到组件的复用

#### 1、根组件
```plain
<div id="app">
    <h1>{{ msg }}</h1>
</div>
<script type="text/javascript">
    // 通过new Vue创建的实例就是根组件(实例与组件一一对应,一个实例就是一个组件)
    // 每个组件组件均拥有模板,template
    var app = new Vue({
        // 根组件的模板就是挂载点
        el: "#app",
        data : {
            msg: "根组件"
        },
        // 模板: 由""包裹的html代码块,出现在组件的内部,赋值给组件的$template变量
        // 显式书写模块,就会替换挂载点,但根组件必须拥有挂载点
        template: "<div>显式模板</div>"
    })
    // app.$template
</script>
```

#### 2、局部组件
```plain
<div id="app">
    <local-tag></local-tag>
    <local-tag></local-tag>
</div>
<script>
    var localTag = {
        data () {
            return {
                count: 0
            }
        },
        template: '<button @click="btnAction">局部{{ count }}</button>',
        methods: {
            btnAction () {
                this.count ++
            }
        }
    }
    new Vue({
        el: "#app",
        components: {
            'local-tag': localTag
        }
    })
</script>
```

#### 3、全局组件
```plain
<div id="app">
    <global-tag></global-tag>
    <global-tag></global-tag>
</div>
<script>
    Vue.component('global-tag', {
        data () {
            return {
                count: 0
            }
        },
        template: '<button @click="btnAction">全局{{ count }}</button>',
        methods: {
            btnAction () {
                this.count ++
            }
        }
    })
    new Vue({
        el: "#app"
    })
</script>
```

#### 4、父组件传递数据给子组件
+ 通过绑定属性的方式进行数据传递

```plain
<div id="app">
    <global-tag :sup_data1='sup_data1' :supData2='sup_data2'></global-tag>
</div>
<script type="text/javascript">
    Vue.component('global-tag', {
        props:['sup_data1', 'supdata2'],
        template: '<div>{{ sup_data1 }} {{ supdata2 }}</div>'
    })
    new Vue({
        el: '#app',
        data: {
            sup_data1: '数据1',
            sup_data2: '数据2'
        }
    })
</script>
```

#### 5、子组件传递数据给父组件
+ 通过发送事件请求的方式进行数据传递

```plain
<div id="app">
    <global-tag @send_action='receiveAction'></global-tag>
</div>
<script type="text/javascript">
    Vue.component('global-tag', {
        data () {
            return {
                sub_data1: "数据1",
                sub_data2: '数据2'
            }
        },
        template: '<div @click="clickAction">发生</div>',
        methods: {
            clickAction () {
                this.$emit('send_action', this.sub_data1, this.sub_data2)
            }
        }
    })
    new Vue({
        el: '#app',
        methods: {
            receiveAction (v1, v2) {
                console.log(v1, v2)
            }
        }
    })
</script>
```

#### 6、父子组件实现todoList
```plain
<div id="app">
    <div>
        <input type="text" v-model="val">
        <button type="button" @click="submitMsg">提交</button>
    </div>
    <ul>
        <!-- <li v-for="(v, i) in list" :key="i" @click="removeMsg(i)">{{ v }}</li> -->
        <todo-list v-for="(v, i) in list" :key="i" :v="v" :i="i" @delect_action="delect_action"></todo-list>
    </ul>
</div>
<script type="text/javascript">
    Vue.component("todo-list", {
        template: "<li @click='delect_action'><span>第{{ i + 1 }}条: </span><span>{{ v }}</span></li>",
        props: ['v', 'i'],
        methods: {
            delect_action () {
                this.$emit("delect_action", this.i)
            }
        }
    })
    
    new Vue({
        el: "#app",
        data: {
            val: "",
            list: []
        },
        methods: {
            submitMsg () {
                // 往list中添加input框中的value
                if (this.val) {
                    this.list.push(this.val);
                    this.val = ""
                }
            },
            delect_action(index) {
                this.list.splice(index, 1)
            }
        }
    })
</script>
```

## 六、Vue-CLI 项目搭建
#### 1、环境搭建
+ 安装node

```plain
官网下载安装包，傻瓜式安装：https://nodejs.org/zh-cn/
```

+ 安装cnpm

```plain
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

+ 安装脚手架

```plain
cnpm install -g @vue/cli
```

+ 清空缓存处理

```plain
npm cache clean --force
```

#### 2、项目的创建
+ 创建项目

```plain
vue creat 项目名
// 要提前进入目标目录(项目应该创建在哪个目录下)
// 选择自定义方式创建项目，选取Router, Vuex插件
```

+ 启动/停止项目

```plain
npm run serve / ctrl+c
// 要提前进入项目根目录
```

+ 打包项目

```plain
npm run build
// 要在项目根目录下进行打包操作
```

#### 3、认识项目
+ 项目目录

```plain
dist: 打包的项目目录(打包后会生成)
node_modules: 项目依赖
public: 共用资源
src: 项目目标,书写代码的地方
    -- assets:资源
    -- components:组件
    -- views:视图组件
    -- App.vue:根组件
    -- main.js: 入口js
    -- router.js: 路由文件
    -- store.js: 状态库文件
vue.config.js: 项目配置文件(没有可以自己新建)
```

+ 配置文件：vue.config.js

```plain
module.exports={
    devServer: {
        port: 8888
    }
}
// 修改端口,选做
```

+ main.js

```plain
new Vue({
    el: "#app",
    router: router,
    store: store,
    render: function (h) {
        return h(App)
    }
})
```

+ .vue文件

```plain
<template>
    <!-- 模板区域 -->
</template>
<script>
    // 逻辑代码区域
    // 该语法和script绑定出现
    export default {
        
    }
</script>
<style scoped>
    /* 样式区域 */
    /* scoped表示这里的样式只适用于组件内部, scoped与style绑定出现 */
</style>
```

#### 4、项目功能
+ vue-router

```plain
{
    path: '/',
    name: 'home',
    // 路由的重定向
    redirect: '/home'
}
{
    // 一级路由, 在根组件中被渲染, 替换根组件的<router-view/>标签
    path: '/one-view',
    name: 'one',
    component: () => import('./views/OneView.vue')
}
{
    // 多级路由, 在根组件中被渲染, 替换根组件的<router-view/>标签
    path: '/one-view/one-detail',
    component: () => import('./views/OneDetail.vue'),
    // 子路由, 在所属路由指向的组件中被渲染, 替换该组件(OneDetail)的<router-view/>标签
    children: [{
        path: 'show',
        component: () => import('./components/OneShow.vue')
    }]
}
```

```plain
<!-- router-link渲染为a标签 -->
<router-link to="/">Home</router-link> |
<router-link to="/about">About</router-link> |
<router-link :to="{name: 'one'}">One</router-link> |
<!-- 为路由渲染的组件占位 -->
<router-view />
```

```plain
a.router-link-exact-active {
    color: #42b983;
}
```

```plain
// router的逻辑转跳
this.$router.push('/one-view')
// router采用history方式访问上一级
this.$router.go(-1)
```

+ vuex

```plain
// 在任何一个组件中,均可以通过this.$store.state.msg访问msg的数据
// state永远只能拥有一种状态值
state: {
    msg: "状态管理器"
},
// 让state拥有多个状态值
mutations: {
    // 在一个一个组件中,均可以通过this.$store.commit('setMsg', new_msg)来修改state中的msg
    setMsg(state, new_msg) {
        state.msg = new_msg
    }
},
// 让mutations拥有多个状态值
actions: {
}
```

+ vue-cookie

```plain
// 安装cookie的命令
// npm install vue-cookie --save
// 为项目配置全局vue-cookie
import VueCookie from 'vue-cookie'
// 将插件设置给Vue原型,作为全局的属性,在任何地方都可以通过this.$cookie进行访问
Vue.prototype.$cookie = VueCookie
```

```plain
// 持久化存储val的值到cookie中
this.$cookie.set('val', this.val)
// 获取cookie中val字段值
this.$cookie.get('val')
```

+ axios

```plain
// 安装 axios(ajax)的命令
// npm install axios--save
// 为项目配置全局axios
import Axios from 'axios'
Vue.prototype.$ajax = Axios
```

```plain
let _this = this
this.$ajax({
    method: 'post',
    url: 'http://127.0.0.1:5000/loginAction',
    params: {
        usr: this.usr,
        ps: this.ps
    }
}).then(function(res) {
    // this代表的是回调then这个方法的调用者(axios插件),也就是发生了this的重指向
    // 要更新页面的title变量,title属于vue实例
    // res为回调的对象,该对象的data属性就是后台返回的数据
    _this.title = res.data
}).catch(function(err) {
    window.console.log(err)
})
```

```plain
# 用pycharm启动该文件模拟后台
from flask import Flask, request, render_template
from flask_cors import CORS
app = Flask(__name__)
CORS(app, supports_credentials=True)
@app.route('/')
def index():
    return "<h1>主页</h1>"
@app.route('/loginAction', methods=['GET', 'POST'])
def test_action():
    # print(request.args)
    # print(request.form)
    # print(request.values)
    usr = request.args['usr']
    ps = request.args['ps']
    if usr != 'abc' or ps != '123':
        return 'login failed'
    return 'login success'
if __name__ == '__main__':
    app.run()
```

关于 曾老湿

> 更新: 2020-06-25 12:07:57  
> 原文: <https://www.yuque.com/chengkanghua/zg4iuy/rzzgyy>