# Go语言基础之基本数据类型

<font style="color:rgb(68, 68, 68);">Go语言中有丰富的数据类型，除了基本的整型、浮点型、布尔型、字符串外，还有数组、切片、结构体、函数、map、通道（channel）等。Go 语言的基本类型和其他语言大同小异。</font>

# <font style="color:rgb(68, 68, 68);">基本数据类型</font>
## <font style="color:black;">整型</font>
<font style="color:rgb(68, 68, 68);">整型分为以下两个大类： 按长度分为：int8、int16、int32、int64 对应的无符号整型：uint8、uint16、uint32、uint64</font>

<font style="color:rgb(68, 68, 68);">其中，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">uint8</font><font style="color:rgb(68, 68, 68);">就是我们熟知的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">byte</font><font style="color:rgb(68, 68, 68);">型，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int16</font><font style="color:rgb(68, 68, 68);">对应C语言中的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">short</font><font style="color:rgb(68, 68, 68);">型，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int64</font><font style="color:rgb(68, 68, 68);">对应C语言中的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">long</font><font style="color:rgb(68, 68, 68);">型。</font>

| <font style="color:rgb(255, 255, 255);">类型</font> | <font style="color:#FFFFFF;">内存占用情况</font> | <font style="color:rgb(255, 255, 255);">描述</font> |
| --- | --- | --- |
| <font style="color:rgb(68, 68, 68);">uint8</font> | 8位(1字节) | <font style="color:rgb(68, 68, 68);">无符号 8位整型 (0 到 255)</font> |
| <font style="color:rgb(68, 68, 68);">uint16</font> | 16位(2字节) | <font style="color:rgb(68, 68, 68);">无符号 16位整型 (0 到 65535)</font> |
| <font style="color:rgb(68, 68, 68);">uint32</font> | 32位(4字节） | <font style="color:rgb(68, 68, 68);">无符号 32位整型 (0 到 4294967295)</font> |
| <font style="color:rgb(68, 68, 68);">uint64</font> | 64位(8个字节) | <font style="color:rgb(68, 68, 68);">无符号 64位整型 (0 到 18446744073709551615)</font> |
| <font style="color:rgb(68, 68, 68);">int8</font> | 8位(1字节) | <font style="color:rgb(68, 68, 68);">有符号 8位整型 (-128 到 127)</font> |
| <font style="color:rgb(68, 68, 68);">int16</font> | 16位(2字节) | <font style="color:rgb(68, 68, 68);">有符号 16位整型 (-32768 到 32767)</font> |
| <font style="color:rgb(68, 68, 68);">int32</font> | 32位(4字节） | <font style="color:rgb(68, 68, 68);">有符号 32位整型 (-2147483648 到 2147483647)</font> |
| <font style="color:rgb(68, 68, 68);">int64</font> | 64位(8个字节) | <font style="color:rgb(68, 68, 68);">有符号 64位整型 (-9223372036854775808 到 9223372036854775807)</font> |


### <font style="color:rgb(186, 57, 37);">特殊整型</font>
| <font style="color:rgb(255, 255, 255);">类型</font> | <font style="color:rgb(255, 255, 255);">描述</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">uint</font> | <font style="color:rgb(68, 68, 68);">32位操作系统上就是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">uint32</font><font style="color:rgb(68, 68, 68);">，64位操作系统上就是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">uint64</font> |
| <font style="color:rgb(68, 68, 68);">int</font> | <font style="color:rgb(68, 68, 68);">32位操作系统上就是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int32</font><font style="color:rgb(68, 68, 68);">，64位操作系统上就是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int64</font> |
| <font style="color:rgb(68, 68, 68);">uintptr</font> | <font style="color:rgb(68, 68, 68);">无符号整型，用于存放一个指针</font> |


**<font style="color:red;">注意：</font>**<font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">在使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">uint</font><font style="color:rgb(68, 68, 68);">类型时，不能假定它是32位或64位的整型，而是考虑</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">uint</font><font style="color:rgb(68, 68, 68);">可能在不同平台上的差异。</font>

**<font style="color:red;">注意事项</font>**<font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">获取对象的长度的内建</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">len()</font><font style="color:rgb(68, 68, 68);">函数返回的长度可以根据不同平台的字节长度进行变化。实际使用中，切片或 map 的元素数量等都可以用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int</font><font style="color:rgb(68, 68, 68);">来表示。在涉及到二进制传输、读写文件的结构描述时，为了保持文件的结构不会受到不同编译目标平台字节长度的影响，不要使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">uint</font><font style="color:rgb(68, 68, 68);">。</font>

### <font style="color:rgb(186, 57, 37);">数字字面量语法（Number literals syntax）</font>
<font style="color:rgb(68, 68, 68);">Go1.13版本之后引入了数字字面量语法，这样便于开发者以二进制、八进制或十六进制浮点数的格式定义数字，例如：</font>

<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">v := 0b00101101</font><font style="color:rgb(68, 68, 68);">， 代表二进制的 101101，相当于十进制的 45。</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">v := 0o377</font><font style="color:rgb(68, 68, 68);">，代表八进制的 377，相当于十进制的 255。</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">v := 0x1p-2</font><font style="color:rgb(68, 68, 68);">，代表十六进制的 1 除以 2²，也就是 0.25。</font>

<font style="color:rgb(68, 68, 68);">而且还允许我们用</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">_</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">来分隔数字，比如说：</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">v := 123_456</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">表示 v 的值等于 123456。</font>

<font style="color:rgb(68, 68, 68);">我们可以借助fmt函数来将一个整数以不同进制形式展示。</font>

```go
package main
 
import "fmt"
 
func main(){
	// 十进制
	var a int = 10
	fmt.Printf("%d \n", a)  // 10
	fmt.Printf("%b \n", a)  // 1010  占位符%b表示二进制
 
	// 八进制  以0开头
	var b int = 077
	fmt.Printf("%o \n", b)  // 77
 
	// 十六进制  以0x开头
	var c int = 0xff
	fmt.Printf("%x \n", c)  // ff
	fmt.Printf("%X \n", c)  // FF
}
```

## <font style="color:black;">浮点型</font>
<font style="color:rgb(68, 68, 68);">Go语言支持两种浮点型数：</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">float32</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">float64</font><font style="color:rgb(68, 68, 68);">。这两种浮点型数据格式遵循</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">IEEE 754</font><font style="color:rgb(68, 68, 68);">标准：</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">float32</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">的浮点数的最大范围约为</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">3.4e38</font><font style="color:rgb(68, 68, 68);">，可以使用常量定义：</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">math.MaxFloat32</font><font style="color:rgb(68, 68, 68);">。</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">float64</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);">的浮点数的最大范围约为</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">1.8e308</font><font style="color:rgb(68, 68, 68);">，可以使用一个常量定义：</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">math.MaxFloat64</font><font style="color:rgb(68, 68, 68);">。</font>

<font style="color:rgb(68, 68, 68);">打印浮点数时，可以使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">fmt</font><font style="color:rgb(68, 68, 68);">包配合动词</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">%f</font><font style="color:rgb(68, 68, 68);">，代码如下：</font>

```go
package main
import (
        "fmt"
        "math"
)
func main() {
        fmt.Printf("%f\n", math.Pi)
        fmt.Printf("%.2f\n", math.Pi)
}
```

## <font style="color:black;">复数</font>
（基本用不到，略过）

<font style="color:rgb(68, 68, 68);">complex64和complex128</font>

```go
var c1 complex64
c1 = 1 + 2i
var c2 complex128
c2 = 2 + 3i
fmt.Println(c1)
fmt.Println(c2)
```

<font style="color:rgb(68, 68, 68);">复数有实部和虚部，complex64的实部和虚部为32位，complex128的实部和虚部为64位。</font>

## <font style="color:black;">布尔值</font>
<font style="color:rgb(68, 68, 68);">Go语言中以</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">bool</font><font style="color:rgb(68, 68, 68);">类型进行声明布尔型数据，布尔型数据只有</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">true（真）</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">false（假）</font><font style="color:rgb(68, 68, 68);">两个值。</font>

**<font style="color:red;">注意：</font>**

1. <font style="color:rgb(68, 68, 68);">布尔类型变量的默认值为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">false</font><font style="color:rgb(68, 68, 68);">。</font>
2. <font style="color:rgb(68, 68, 68);">Go 语言中不允许将整型强制转换为布尔型.</font>
3. <font style="color:rgb(68, 68, 68);">布尔型无法参与数值运算，也无法与其他类型进行转换。</font>

## <font style="color:black;">字符串</font>
<font style="color:rgb(68, 68, 68);">Go语言中的字符串以原生数据类型出现，使用字符串就像使用其他原生数据类型（int、bool、float32、float64 等）一样。 Go 语言里的字符串的内部实现使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">UTF-8</font><font style="color:rgb(68, 68, 68);">编码。 字符串的值为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">双引号(")</font><font style="color:rgb(68, 68, 68);">中的内容，可以在Go语言的源码中直接添加非ASCII码字符，例如：</font>

```go
s1 := "hello"
s2 := "你好"
```

### <font style="color:rgb(186, 57, 37);">字符串转义符</font>
<font style="color:rgb(68, 68, 68);">Go 语言的字符串常见转义符包含回车、换行、单双引号、制表符等，如下表所示。</font>

| <font style="color:rgb(255, 255, 255);">转义符</font> | <font style="color:rgb(255, 255, 255);">含义</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">\r</font> | <font style="color:rgb(68, 68, 68);">回车符（返回行首）</font> |
| <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">\n</font> | <font style="color:rgb(68, 68, 68);">换行符（直接跳到下一行的同列位置）</font> |
| <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">\t</font> | <font style="color:rgb(68, 68, 68);">制表符</font> |
| <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">\'</font> | <font style="color:rgb(68, 68, 68);">单引号</font> |
| <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">\"</font> | <font style="color:rgb(68, 68, 68);">双引号</font> |
| <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">\\</font> | <font style="color:rgb(68, 68, 68);">反斜杠</font> |


<font style="color:rgb(68, 68, 68);">举个例子，我们要打印一个Windows平台下的一个文件路径：</font>

```go
package main
import (
    "fmt"
)
func main() {
    fmt.Println("str := \"c:\\Code\\lesson1\\go.exe\"")
}
```

### <font style="color:rgb(186, 57, 37);">多行字符串</font>
<font style="color:rgb(68, 68, 68);">Go语言中要定义一个多行字符串时，就必须使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">反引号</font><font style="color:rgb(68, 68, 68);">字符：</font>

```go
s1 := `第一行
第二行
第三行
`
fmt.Println(s1)
```

<font style="color:rgb(68, 68, 68);">反引号间换行将被作为字符串中的换行，但是所有的转义字符均无效，文本将会原样输出。</font>

### <font style="color:rgb(186, 57, 37);">字符串的常用操作</font>
| <font style="color:rgb(255, 255, 255);">方法</font> | <font style="color:rgb(255, 255, 255);">介绍</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">len(str)</font> | <font style="color:rgb(68, 68, 68);">求长度</font> |
| <font style="color:rgb(68, 68, 68);">+或fmt.Sprintf</font> | <font style="color:rgb(68, 68, 68);">拼接字符串</font> |
| <font style="color:rgb(68, 68, 68);">strings.Split</font> | <font style="color:rgb(68, 68, 68);">分割</font> |
| <font style="color:rgb(68, 68, 68);">strings.contains</font> | <font style="color:rgb(68, 68, 68);">判断是否包含</font> |
| <font style="color:rgb(68, 68, 68);">strings.HasPrefix,strings.HasSuffix</font> | <font style="color:rgb(68, 68, 68);">前缀/后缀判断</font> |
| <font style="color:rgb(68, 68, 68);">strings.Index(),strings.LastIndex()</font> | <font style="color:rgb(68, 68, 68);">子串出现的位置</font> |
| <font style="color:rgb(68, 68, 68);">strings.Join(a[]string, sep string)</font> | <font style="color:rgb(68, 68, 68);">join操作</font> |


## <font style="color:black;">byte和rune类型</font>
<font style="color:rgb(68, 68, 68);">组成每个字符串的元素叫做“字符”，可以通过遍历或者单个获取字符串元素获得字符。 字符用单引号（’）包裹起来，如：</font>

```go
var a = '中'
var b = 'x'
```

<font style="color:rgb(68, 68, 68);">Go 语言的字符有以下两种：</font>

1. <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">uint8</font><font style="color:rgb(68, 68, 68);">类型，或者叫 byte 型，代表了</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">ASCII码</font><font style="color:rgb(68, 68, 68);">的一个字符。</font>
2. <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">rune</font><font style="color:rgb(68, 68, 68);">类型，代表一个</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">UTF-8字符</font><font style="color:rgb(68, 68, 68);">。</font>

<font style="color:rgb(68, 68, 68);">当需要处理中文、日文或者其他复合字符时，则需要用到</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">rune</font><font style="color:rgb(68, 68, 68);">类型。</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">rune</font><font style="color:rgb(68, 68, 68);">类型实际是一个</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int32</font><font style="color:rgb(68, 68, 68);">。</font>

<font style="color:rgb(68, 68, 68);">Go 使用了特殊的 rune 类型来处理 Unicode，让基于 Unicode 的文本处理更为方便，也可以使用 byte 型进行默认字符串处理，性能和扩展性都有照顾。</font>

```go
// 遍历字符串
func traversalString() {
	s := "hello沙河"
	for i := 0; i < len(s); i++ { //byte
		fmt.Printf("%v(%c) ", s[i], s[i])
	}
	fmt.Println()
	for _, r := range s { //rune
		fmt.Printf("%v(%c) ", r, r)
	}
	fmt.Println()
}
```

<font style="color:rgb(68, 68, 68);">输出：</font>

```plain
104(h) 101(e) 108(l) 108(l) 111(o) 230(æ) 178(²) 153() 230(æ) 178(²) 179(³) 
104(h) 101(e) 108(l) 108(l) 111(o) 27801(沙) 27827(河) 
```

<font style="color:rgb(68, 68, 68);">因为UTF8编码下一个中文汉字由3~4个字节组成，所以我们不能简单的按照字节去遍历一个包含中文的字符串，否则就会出现上面输出中第一行的结果。</font>

<font style="color:rgb(68, 68, 68);">字符串底层是一个byte数组，所以可以和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">[]byte</font><font style="color:rgb(68, 68, 68);">类型相互转换。字符串是不能修改的 字符串是由byte字节组成，所以字符串的长度是byte字节的长度。 rune类型用来表示utf8字符，一个rune字符由一个或多个byte组成。</font>

### <font style="color:rgb(186, 57, 37);">修改字符串</font>
<font style="color:rgb(68, 68, 68);">要修改字符串，需要先将其转换成</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">[]rune</font><font style="color:rgb(68, 68, 68);">或</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">[]byte</font><font style="color:rgb(68, 68, 68);">，完成后再转换为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">string</font><font style="color:rgb(68, 68, 68);">。无论哪种转换，都会重新分配内存，并复制字节数组。</font>

```go
func changeString() {
	s1 := "big"
	// 强制类型转换
	byteS1 := []byte(s1)
	byteS1[0] = 'p'
	fmt.Println(string(byteS1))

	s2 := "白萝卜"
	runeS2 := []rune(s2)
	runeS2[0] = '红'
	fmt.Println(string(runeS2))
}

```

小笔记：

```go
	// byte 和 rune
	var s1 = "你:好:啊"
	fmt.Println([]rune(s1)) // [20320 58 22909 58 21834]
	fmt.Println([]byte(s1)) // [228 189 160 58 229 165 189 58 229 149 138]
```

## <font style="color:black;">类型转换</font>
<font style="color:rgb(68, 68, 68);">Go语言中只有强制类型转换，没有隐式类型转换。该语法只能在两个类型之间支持相互转换的时候使用。</font>

<font style="color:rgb(68, 68, 68);">强制类型转换的基本语法如下：</font>

```go
T(表达式)
```

<font style="color:rgb(68, 68, 68);">其中，T表示要转换的类型。表达式包括变量、复杂算子和函数返回值等.</font>

<font style="color:rgb(68, 68, 68);">比如计算直角三角形的斜边长时使用math包的Sqrt()函数，该函数接收的是float64类型的参数，而变量a和b都是int类型的，这个时候就需要将a和b强制类型转换为float64类型。</font>

```go
func sqrtDemo() {
	var a, b = 3, 4
	var c int
	// math.Sqrt()接收的参数是float64类型，需要强制转换  
    // Math.sqrt() 函数返回一个数的平方根
	c = int(math.Sqrt(float64(a*a + b*b)))
	fmt.Println(c)
}
```



小笔记：

```go
	s1 := 97
	fmt.Println(string(s1)) // ascci 对照表的 a
```

# <font style="color:rgb(68, 68, 68);">练习题</font>
1. <font style="color:rgb(68, 68, 68);">编写代码分别定义一个整型、浮点型、布尔型、字符串型变量，使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">fmt.Printf()</font><font style="color:rgb(68, 68, 68);">搭配</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">%T</font><font style="color:rgb(68, 68, 68);">分别打印出上述变量的值和类型。</font>

```go
	s1 := 100
	s2 := 2.11
	s3 := true
	s4 := "中"

	fmt.Printf("s1: %T \n", s1)
	fmt.Printf("s2: %T \n", s2)
	fmt.Printf("s3: %T \n", s3)
	fmt.Printf("s4: %T \n", s4)
---------------------
s1: int 
s2: float64 
s3: bool 
s4: string 
```

2. <font style="color:rgb(68, 68, 68);">编写代码统计出字符串</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">"hello沙河小王子"</font><font style="color:rgb(68, 68, 68);">中汉字的数量。</font>

```go
package main

import "fmt"

func main() {
	words := "hello沙河小王子"
	count := 0
	const startCode = 0x2E88
	const endCode = 0x9FFF
	for _, w := range words {
		if startCode < w && endCode > w {
			count++
		}
	}
	fmt.Println("中文字符数：", count)
}

```



> 更新: 2022-06-02 12:06:10  
> 原文: <https://www.yuque.com/chengkanghua/go/kh5w6m>