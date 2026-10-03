# Go语言基础之map



<font style="color:rgb(68, 68, 68);">Go语言中提供的映射关系容器为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">map</font><font style="color:rgb(68, 68, 68);">，其内部使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">散列表（hash）</font><font style="color:rgb(68, 68, 68);">实现。</font>

# <font style="color:rgb(68, 68, 68);">map</font>
<font style="color:rgb(68, 68, 68);">map是一种无序的基于</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">key-value</font><font style="color:rgb(68, 68, 68);">的数据结构，必须初始化才能使用。</font>

## <font style="color:black;">map定义</font>
<font style="color:rgb(68, 68, 68);">Go语言中</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">map</font><font style="color:rgb(68, 68, 68);">的定义语法如下：</font>

```go
map[KeyType]ValueType
```

<font style="color:rgb(68, 68, 68);">其中，</font>

+ <font style="color:rgb(68, 68, 68);">KeyType:表示键的类型。</font>
+ <font style="color:rgb(68, 68, 68);">ValueType:表示键对应的值的类型。</font>

<font style="color:rgb(68, 68, 68);">map类型的变量默认初始值为nil，需要使用make()函数来分配内存。语法为：</font>

```go
make(map[KeyType]ValueType, [cap])
```

<font style="color:rgb(68, 68, 68);">其中cap表示map的容量，该参数虽然不是必须的，但是我们应该在初始化map的时候就为其指定一个合适的容量。</font>

## <font style="color:black;">map基本使用</font>
<font style="color:rgb(68, 68, 68);">map中的数据都是成对出现的，map的基本使用示例代码如下：</font>

```go
func main() {
	scoreMap := make(map[string]int, 8)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	fmt.Println(scoreMap)
	fmt.Println(scoreMap["小明"])
	fmt.Printf("type of a:%T\n", scoreMap)
}
```

<font style="color:rgb(68, 68, 68);">输出：</font>

```go
map[小明:100 张三:90]
100
type of a:map[string]int
```

<font style="color:rgb(68, 68, 68);">map也支持在声明的时候填充元素，例如：</font>

```go
func main() {
	userInfo := map[string]string{
		"username": "沙河小王子",
		"password": "123456",
	}
	fmt.Println(userInfo) //
}
```

## <font style="color:black;">判断某个键是否存在</font>
<font style="color:rgb(68, 68, 68);">Go语言中有个判断map中键是否存在的特殊写法，格式如下:</font>

```go
value, ok := map[key]
```

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func main() {
	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	// 如果key存在ok为true,v为对应的值；不存在ok为false,v为值类型的零值
	v, ok := scoreMap["张三"]
	if ok {
		fmt.Println(v)
	} else {
		fmt.Println("查无此人")
	}
}

```

## <font style="color:black;">map的遍历</font>
<font style="color:rgb(68, 68, 68);">Go语言中使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">for range</font><font style="color:rgb(68, 68, 68);">遍历map。</font>

```go
func main() {
	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	scoreMap["娜扎"] = 60
	for k, v := range scoreMap {
		fmt.Println(k, v)
	}
}
```

<font style="color:rgb(68, 68, 68);">但我们只想遍历key的时候，可以按下面的写法：</font>

```go
func main() {
	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	scoreMap["娜扎"] = 60
	for k := range scoreMap {
		fmt.Println(k)
	}
}
```

**<font style="color:red;">注意：</font>**<font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">遍历map时的元素顺序与添加键值对的顺序无关。</font>

## <font style="color:black;">使用delete()函数删除键值对</font>
<font style="color:rgb(68, 68, 68);">使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">delete()</font><font style="color:rgb(68, 68, 68);">内建函数从map中删除一组键值对，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">delete()</font><font style="color:rgb(68, 68, 68);">函数的格式如下：</font>

```go
delete(map, key)
```

<font style="color:rgb(68, 68, 68);">其中，</font>

+ <font style="color:rgb(68, 68, 68);">map:表示要删除键值对的map</font>
+ <font style="color:rgb(68, 68, 68);">key:表示要删除的键值对的键</font>

<font style="color:rgb(68, 68, 68);">示例代码如下：</font>

```go
func main(){
	scoreMap := make(map[string]int)
	scoreMap["张三"] = 90
	scoreMap["小明"] = 100
	scoreMap["娜扎"] = 60
	delete(scoreMap, "小明")//将小明:100从map中删除
	for k,v := range scoreMap{
		fmt.Println(k, v)
	}
}

```

## <font style="color:black;">按照指定顺序遍历map</font>
```go
package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixNano()) //初始化随机数种子

	var scoreMap = make(map[string]int, 200)

	for i := 0; i < 100; i++ {
		key := fmt.Sprintf("stu%02d", i) //生成stu开头的字符串
		value := rand.Intn(100)          //生成0~99的随机整数
		scoreMap[key] = value
	}
	//取出map中的所有key存入切片keys
	var keys = make([]string, 0, 200)
	for key := range scoreMap {
		keys = append(keys, key)
	}
	//对切片进行排序
	sort.Strings(keys)
	//按照排序后的key遍历map
	for _, key := range keys {
		fmt.Println(key, scoreMap[key])
	}
}
```

## <font style="color:black;">元素为map类型的切片</font>
<font style="color:rgb(68, 68, 68);">下面的代码演示了切片中的元素为map类型时的操作：</font>

```go
func main() {
	var mapSlice = make([]map[string]string, 3)
	for index, value := range mapSlice {
		fmt.Printf("index:%d value:%v\n", index, value)
	}
	fmt.Println("after init")
	// 对切片中的map元素进行初始化
	mapSlice[0] = make(map[string]string, 10)
	mapSlice[0]["name"] = "小王子"
	mapSlice[0]["password"] = "123456"
	mapSlice[0]["address"] = "沙河"
	for index, value := range mapSlice {
		fmt.Printf("index:%d value:%v\n", index, value)
	}
}
```

## <font style="color:black;">值为切片类型的map</font>
<font style="color:rgb(68, 68, 68);">下面的代码演示了map中值为切片类型的操作：</font>

```go
func main() {
	var sliceMap = make(map[string][]string, 3)
	fmt.Println(sliceMap)
	fmt.Println("after init")
	key := "中国"
	value, ok := sliceMap[key]
	if !ok {
		value = make([]string, 0, 2)
	}
	value = append(value, "北京", "上海")
	sliceMap[key] = value
	fmt.Println(sliceMap)
}
```

# <font style="color:rgb(68, 68, 68);">练习题</font>
1. <font style="color:rgb(68, 68, 68);">写一个程序，统计一个字符串中每个单词出现的次数。比如：”how do you do”中how=1 do=2 you=1。</font>

```go
// 写一个程序，统计一个字符串中每个单词出现的次数。
	// 比如：”how do you do”中how=1 do=2 you=1。
	s := "how do you do"

	// 1.用map存数据，key是单词，value是单词出现的次数
	// 2.将字符串分成一个一个的单词
	// 3.把上一步得到的单词挨个存放到map里
	// 4.遍历map打印结果

	// 迎刃而解
	var m map[string]int
	m = make(map[string]int)
	s1 := strings.Split(s, " ") // 切片
	for _, v := range s1 {
		// m[v] = 1  // m["do"] = 1
		num := m[v]
		m[v] = num + 1

		// m[v]++

		// if ok{
		// 	m[v] = num+1
		// }else{
		// 	m[v] = 0+1
		// }
	}

	for k, v := range m {
		fmt.Println(k, v)
	}
```

2. <font style="color:rgb(68, 68, 68);">观察下面代码，写出最终的打印结果。</font>

```go
func main() {
	type Map map[string][]int
	m := make(Map)
	s := []int{1, 2}
	s = append(s, 3)
	fmt.Printf("%+v\n", s) //[1 2 3]
	m["q1mi"] = s
	s = append(s[:1], s[2:]...)
	fmt.Printf("%+v\n", s)         // [1 3]
	fmt.Printf("%+v\n", m["q1mi"]) // [1 3 3 ] 底层共用一个内存地址
}

```



  




> 更新: 2022-04-20 10:38:22  
> 原文: <https://www.yuque.com/chengkanghua/go/dzbk2g>