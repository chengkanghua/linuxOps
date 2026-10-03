# Go语言基础之切片



<font style="color:rgb(68, 68, 68);">本文主要介绍Go语言中切片（slice）及它的基本使用。</font>

# <font style="color:rgb(68, 68, 68);">引子</font>
<font style="color:rgb(68, 68, 68);">因为数组的长度是固定的并且数组长度属于类型的一部分，所以数组有很多的局限性。 例如：</font>

```go
func arraySum(x [3]int) int{
    sum := 0
    for _, v := range x{
        sum = sum + v
    }
    return sum
}
```

<font style="color:rgb(68, 68, 68);">这个求和函数只能接受</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">[3]int</font><font style="color:rgb(68, 68, 68);">类型，其他的都不支持。 再比如，</font>

```go
a := [3]int{1, 2, 3}
```

<font style="color:rgb(68, 68, 68);">数组a中已经有三个元素了，我们不能再继续往数组a中添加新元素了。</font>

# <font style="color:rgb(68, 68, 68);">切片</font>
<font style="color:rgb(51, 51, 51);">Go 语言切片是对数组的抽象。</font>

<font style="color:rgb(51, 51, 51);">Go 数组的长度不可改变，在特定场景中这样的集合就不太适用，Go 中提供了一种灵活，功能强悍的内置类型切片("动态数组")，与数组相比切片的长度是不固定的，可以追加元素，在追加时可以使切片的容量增大。</font>

<font style="color:rgb(51, 51, 51);"></font>

<font style="color:rgb(68, 68, 68);">切片（Slice）是一个拥有相同类型元素的可变长度的序列。它是基于数组类型做的一层封装。它非常灵活，支持自动扩容。</font>

<font style="color:rgb(68, 68, 68);">切片是一个，它的内部结构包含</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">地址</font><font style="color:rgb(68, 68, 68);">、</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">长度</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">容量</font><font style="color:rgb(68, 68, 68);">。切片一般用于快速地操作一块数据集合。</font>

## <font style="color:black;">切片的定义</font>
<font style="color:rgb(68, 68, 68);">声明切片类型的基本语法如下：</font>

```go
var name []T
```

<font style="color:rgb(68, 68, 68);">其中，</font>

+ <font style="color:rgb(68, 68, 68);">name:表示变量名</font>
+ <font style="color:rgb(68, 68, 68);">T:表示切片中的元素类型</font>

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func main() {
	// 声明切片类型
	var a []string              //声明一个字符串切片
	var b = []int{}             //声明一个整型切片并初始化
	var c = []bool{false, true} //声明一个布尔切片并初始化
	var d = []bool{false, true} //声明一个布尔切片并初始化
	fmt.Println(a)              //[]
	fmt.Println(b)              //[]
	fmt.Println(c)              //[false true]
	fmt.Println(a == nil)       //true
	fmt.Println(b == nil)       //false
	fmt.Println(c == nil)       //false
	// fmt.Println(c == d)   //切片不支持直接比较，只能和nil比较
}

```

### <font style="color:rgb(186, 57, 37);">切片的长度和容量</font>
<font style="color:rgb(68, 68, 68);">切片拥有自己的长度和容量，我们可以通过使用内置的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">len()</font><font style="color:rgb(68, 68, 68);">函数求长度，使用内置的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">cap()</font><font style="color:rgb(68, 68, 68);">函数求切片的容量。</font>

### <font style="color:rgb(186, 57, 37);">切片表达式</font>
<font style="color:rgb(68, 68, 68);">切片表达式从字符串、数组、指向数组或切片的指针构造子字符串或切片。它有两种变体：一种指定low和high两个索引界限值的简单的形式，另一种是除了low和high索引界限值外还指定容量的完整的形式。</font>

#### <font style="color:rgb(186, 57, 37);">简单切片表达式</font>
<font style="color:rgb(68, 68, 68);">切片的底层就是一个数组，所以我们可以基于数组通过切片表达式得到切片。 切片表达式中的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">low</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">high</font><font style="color:rgb(68, 68, 68);">表示一个索引范围（左包含，右不包含），也就是下面代码中从数组a中选出</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">1<=索引值<4</font><font style="color:rgb(68, 68, 68);">的元素组成切片s，得到的切片</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">长度=high-low</font><font style="color:rgb(68, 68, 68);">，容量等于得到的切片的底层数组的容量。</font>

```go
func main() {
	a := [5]int{1, 2, 3, 4, 5}
	s := a[1:3]  // s := a[low:high]  //cap计算容量是从起始位置算到结尾 结果是4
	fmt.Printf("s:%v len(s):%v cap(s):%v\n", s, len(s), cap(s)) 
}
```

<font style="color:rgb(68, 68, 68);">输出：</font>

```go
s:[2 3] len(s):2 cap(s):4
```

<font style="color:rgb(68, 68, 68);">为了方便起见，可以省略切片表达式中的任何索引。省略了</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">low</font><font style="color:rgb(68, 68, 68);">则默认为0；省略了</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">high</font><font style="color:rgb(68, 68, 68);">则默认为切片操作数的长度:</font>

```go
a[2:]  // 等同于 a[2:len(a)]
a[:3]  // 等同于 a[0:3]
a[:]   // 等同于 a[0:len(a)]
```

**<font style="color:red;">注意：</font>**

<font style="color:rgb(68, 68, 68);">对于数组或字符串，如果</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">0 <= low <= high <= len(a)</font><font style="color:rgb(68, 68, 68);">，则索引合法，否则就会索引越界（out of range）。</font>

<font style="color:rgb(68, 68, 68);">对切片再执行切片表达式时（切片再切片），</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">high</font><font style="color:rgb(68, 68, 68);">的上限边界是切片的容量</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">cap(a)</font><font style="color:rgb(68, 68, 68);">，而不是长度。</font>**<font style="color:red;">常量索引</font>**<font style="color:rgb(68, 68, 68);">必须是非负的，并且可以用int类型的值表示;对于数组或常量字符串，常量索引也必须在有效范围内。如果</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">low</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">high</font><font style="color:rgb(68, 68, 68);">两个指标都是常数，它们必须满足</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">low <= high</font><font style="color:rgb(68, 68, 68);">。如果索引在运行时超出范围，就会发生运行时</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">panic</font><font style="color:rgb(68, 68, 68);">。</font>

```go
func main() {
	a := [5]int{1, 2, 3, 4, 5}
	s := a[1:3]                                                       // s := a[low:high]
	fmt.Printf("s:%v len(s):%v cap(s):%v\n", s, len(s), cap(s))       // s:[2 3] len(s):2 cap(s):4
	s2 := s[3:4]                                                      // 索引的上限是cap(s)而不是len(s)
	fmt.Printf("s2:%v len(s2):%v cap(s2):%v\n", s2, len(s2), cap(s2)) // s2:[5] len(s2):1 cap(s2):1
}
```

<font style="color:rgb(68, 68, 68);">输出：</font>

```go
s:[2 3] len(s):2 cap(s):4
s2:[5] len(s2):1 cap(s2):1
```

#### <font style="color:rgb(186, 57, 37);">完整切片表达式</font>
<font style="color:rgb(68, 68, 68);">对于数组，指向数组的指针，或切片a(</font>**<font style="color:red;">注意不能是字符串</font>**<font style="color:rgb(68, 68, 68);">)支持完整切片表达式：</font>

```go
a[low : high : max]
```

<font style="color:rgb(68, 68, 68);">上面的代码会构造与简单切片表达式</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">a[low: high]</font><font style="color:rgb(68, 68, 68);">相同类型、相同长度和元素的切片。另外，它会将得到的结果切片的容量设置为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">max-low</font><font style="color:rgb(68, 68, 68);">。在完整切片表达式中只有第一个索引值（low）可以省略；它默认为0。</font>

```go
func main() {
	a := [5]int{1, 2, 3, 4, 5}
	t := a[1:3:5]
	fmt.Printf("t:%v len(t):%v cap(t):%v\n", t, len(t), cap(t))
}
```

<font style="color:rgb(68, 68, 68);">输出结果：</font>

```go
t:[2 3] len(t):2 cap(t):4
```

<font style="color:rgb(68, 68, 68);">完整切片表达式需要满足的条件是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">0 <= low <= high <= max <= cap(a)</font><font style="color:rgb(68, 68, 68);">，其他条件和简单切片表达式相同。</font>

### <font style="color:rgb(186, 57, 37);">使用make()函数构造切片</font>
<font style="color:rgb(68, 68, 68);">我们上面都是基于数组来创建的切片，如果需要动态的创建一个切片，我们就需要使用内置的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">make()</font><font style="color:rgb(68, 68, 68);">函数，格式如下：</font>

```go
make([]T, size, cap)
```

<font style="color:rgb(68, 68, 68);">其中：</font>

+ <font style="color:rgb(68, 68, 68);">T:切片的元素类型</font>
+ <font style="color:rgb(68, 68, 68);">size:切片中元素的数量</font>
+ <font style="color:rgb(68, 68, 68);">cap:切片的容量</font>

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func main() {
	a := make([]int, 2, 10)
	fmt.Println(a)      //[0 0]
	fmt.Println(len(a)) //2
	fmt.Println(cap(a)) //10
}
```

<font style="color:rgb(68, 68, 68);">上面代码中</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">a</font><font style="color:rgb(68, 68, 68);">的内部存储空间已经分配了10个，但实际上只用了2个。 容量并不会影响当前元素的个数，所以</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">len(a)</font><font style="color:rgb(68, 68, 68);">返回2，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">cap(a)</font><font style="color:rgb(68, 68, 68);">则返回该切片的容量。</font>

### <font style="color:rgb(186, 57, 37);">切片的本质</font>
<font style="color:rgb(68, 68, 68);">切片的本质就是对底层数组的封装，它包含了三个信息：底层数组的指针、切片的长度（len）和切片的容量（cap）。</font>

<font style="color:rgb(68, 68, 68);">举个例子，现在有一个数组</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">a := [8]int{0, 1, 2, 3, 4, 5, 6, 7}</font><font style="color:rgb(68, 68, 68);">，切片</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">s1 := a[:5]</font><font style="color:rgb(68, 68, 68);">，相应示意图如下。</font>

<!-- OCR_START -->
> 长度
> 容量
> s2 := a[3:6]
> 指针
> 3
> 5
> 底层数组:a
> 0
> 1
> 2
> 3
> 4
> 5
> 6
> 7
> len=3
> g=des
<!-- OCR_END -->

<font style="color:rgb(68, 68, 68);">切片</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">s2 := a[3:6]</font><font style="color:rgb(68, 68, 68);">，相应示意图如下：</font>

<!-- OCR_START -->
> 长度
> 容量
> s2 := a[3:6]
> 指针
> 3
> 5
> 底层数组:a
> 0
> 1
> 2
> 3
> 4
> 5
> 6
> 7
> len=3
> g=des
<!-- OCR_END -->



### <font style="color:rgb(186, 57, 37);">判断切片是否为空</font>
<font style="color:rgb(68, 68, 68);">要检查切片是否为空，请始终使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">len(s) == 0</font><font style="color:rgb(68, 68, 68);">来判断，而不应该使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">s == nil</font><font style="color:rgb(68, 68, 68);">来判断。</font>

## <font style="color:black;">切片不能直接比较</font>
<font style="color:rgb(68, 68, 68);">切片之间是不能比较的，我们不能使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">==</font><font style="color:rgb(68, 68, 68);">操作符来判断两个切片是否含有全部相等元素。 切片唯一合法的比较操作是和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">nil</font><font style="color:rgb(68, 68, 68);">比较。 一个</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">nil</font><font style="color:rgb(68, 68, 68);">值的切片并没有底层数组，一个</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">nil</font><font style="color:rgb(68, 68, 68);">值的切片的长度和容量都是0。但是我们不能说一个长度和容量都是0的切片一定是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">nil</font><font style="color:rgb(68, 68, 68);">，例如下面的示例：</font>

```go
var s1 []int         //len(s1)=0;cap(s1)=0;s1==nil
s2 := []int{}        //len(s2)=0;cap(s2)=0;s2!=nil
s3 := make([]int, 0) //len(s3)=0;cap(s3)=0;s3!=nil



fmt.Printf("len:%v cap:%v v:%v \n", len(s1), cap(s1), s1 == nil)
fmt.Printf("len:%v cap:%v v:%v \n", len(s2), cap(s2), s2 == nil)
fmt.Printf("len:%v cap:%v v:%v \n", len(s3), cap(s3), s3 == nil)
//len:0 cap:0 v:true 
//len:0 cap:0 v:false 
//len:0 cap:0 v:false 
```

<font style="color:rgb(68, 68, 68);">所以要判断一个切片是否是空的，要是用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">len(s) == 0</font><font style="color:rgb(68, 68, 68);">来判断，不应该使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">s == nil</font><font style="color:rgb(68, 68, 68);">来判断。</font>

## <font style="color:black;">切片的赋值拷贝</font>
<font style="color:rgb(68, 68, 68);">下面的代码中演示了拷贝前后两个变量共享底层数组，对一个切片的修改会影响另一个切片的内容，这点需要特别注意。</font>

```go
func main() {
	s1 := make([]int, 3) //[0 0 0]
	s2 := s1             //将s1直接赋值给s2，s1和s2共用一个底层数组
	s2[0] = 100
	fmt.Println(s1) //[100 0 0]
	fmt.Println(s2) //[100 0 0]
}
```

## <font style="color:black;">切片遍历</font>
<font style="color:rgb(68, 68, 68);">切片的遍历方式和数组是一致的，支持索引遍历和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">for range</font><font style="color:rgb(68, 68, 68);">遍历。</font>

```go
func main() {
	s := []int{1, 3, 5}

	for i := 0; i < len(s); i++ {
		fmt.Println(i, s[i])
	}

	for index, value := range s {
		fmt.Println(index, value)
	}
}
```

## <font style="color:black;">append()方法为切片添加元素</font>
<font style="color:rgb(68, 68, 68);">Go语言的内建函数</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">append()</font><font style="color:rgb(68, 68, 68);">可以为切片动态添加元素。 可以一次添加一个元素，可以添加多个元素，也可以添加另一个切片中的元素（后面加…）。</font>

```go
func main(){
	var s []int
	s = append(s, 1)        // [1]
	s = append(s, 2, 3, 4)  // [1 2 3 4]
	s2 := []int{5, 6, 7}  
	s = append(s, s2...)    // [1 2 3 4 5 6 7]
}
```

**<font style="color:red;">注意：</font>**<font style="color:rgb(68, 68, 68);">通过var声明的零值切片可以在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">append()</font><font style="color:rgb(68, 68, 68);">函数直接使用，无需初始化。</font>

```go
var s []int
s = append(s, 1, 2, 3)
```

<font style="color:rgb(68, 68, 68);">没有必要像下面的代码一样初始化一个切片再传入</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">append()</font><font style="color:rgb(68, 68, 68);">函数使用，</font>

```go
s := []int{}  // 没有必要初始化
s = append(s, 1, 2, 3)

var s = make([]int)  // 没有必要初始化
s = append(s, 1, 2, 3)
```

<font style="color:rgb(68, 68, 68);">每个切片会指向一个底层数组，这个数组的容量够用就添加新增元素。当底层数组不能容纳新增的元素时，切片就会自动按照一定的策略进行“扩容”，此时该切片指向的底层数组就会更换。“扩容”操作往往发生在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">append()</font><font style="color:rgb(68, 68, 68);">函数调用时，所以我们通常都需要用原变量接收append函数的返回值。</font>

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func main() {
	//append()添加元素和切片扩容
	var numSlice []int
	for i := 0; i < 10; i++ {
		numSlice = append(numSlice, i)
		fmt.Printf("%v  len:%d  cap:%d  ptr:%p\n", numSlice, len(numSlice), cap(numSlice), numSlice)
	}
}
```

<font style="color:rgb(68, 68, 68);">输出：</font>

```go
[0]  len:1  cap:1  ptr:0xc0000a8000
[0 1]  len:2  cap:2  ptr:0xc0000a8040
[0 1 2]  len:3  cap:4  ptr:0xc0000b2020
[0 1 2 3]  len:4  cap:4  ptr:0xc0000b2020
[0 1 2 3 4]  len:5  cap:8  ptr:0xc0000b6000
[0 1 2 3 4 5]  len:6  cap:8  ptr:0xc0000b6000
[0 1 2 3 4 5 6]  len:7  cap:8  ptr:0xc0000b6000
[0 1 2 3 4 5 6 7]  len:8  cap:8  ptr:0xc0000b6000
[0 1 2 3 4 5 6 7 8]  len:9  cap:16  ptr:0xc0000b8000
[0 1 2 3 4 5 6 7 8 9]  len:10  cap:16  ptr:0xc0000b8000
```

<font style="color:rgb(68, 68, 68);">从上面的结果可以看出：</font>

1. <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">append()</font><font style="color:rgb(68, 68, 68);">函数将元素追加到切片的最后并返回该切片。</font>
2. <font style="color:rgb(68, 68, 68);">切片numSlice的容量按照1，2，4，8，16这样的规则自动进行扩容，每次扩容后都是扩容前的2倍。</font>

<font style="color:rgb(68, 68, 68);">append()函数还支持一次性追加多个元素。 例如：</font>

```go
var citySlice []string
// 追加一个元素
citySlice = append(citySlice, "北京")
// 追加多个元素
citySlice = append(citySlice, "上海", "广州", "深圳")
// 追加切片
a := []string{"成都", "重庆"}
citySlice = append(citySlice, a...)
fmt.Println(citySlice) //[北京 上海 广州 深圳 成都 重庆]
```

## <font style="color:black;">切片的扩容策略</font>
<font style="color:rgb(68, 68, 68);">可以通过查看</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">$GOROOT/src/runtime/slice.go</font><font style="color:rgb(68, 68, 68);">源码，其中扩容相关代码如下：</font>

```go
newcap := old.cap
doublecap := newcap + newcap
if cap > doublecap {
	newcap = cap
} else {
	if old.len < 1024 {
		newcap = doublecap
	} else {
		// Check 0 < newcap to detect overflow
		// and prevent an infinite loop.
		for 0 < newcap && newcap < cap {
			newcap += newcap / 4
		}
		// Set newcap to the requested cap when
		// the newcap calculation overflowed.
		if newcap <= 0 {
			newcap = cap
		}
	}
}
```

<font style="color:rgb(68, 68, 68);">从上面的代码可以看出以下内容：</font>

+ <font style="color:rgb(68, 68, 68);">首先判断，如果新申请容量（cap）大于2倍的旧容量（old.cap），最终容量（newcap）就是新申请的容量（cap）。</font>
+ <font style="color:rgb(68, 68, 68);">否则判断，如果旧切片的长度小于1024，则最终容量(newcap)就是旧容量(old.cap)的两倍，即（newcap=doublecap），</font>
+ <font style="color:rgb(68, 68, 68);">否则判断，如果旧切片长度大于等于1024，则最终容量（newcap）从旧容量（old.cap）开始循环增加原来的1/4，即（newcap=old.cap,for {newcap += newcap/4}）直到最终容量（newcap）大于等于新申请的容量(cap)，即（newcap >= cap）</font>
+ <font style="color:rgb(68, 68, 68);">如果最终容量（cap）计算值溢出，则最终容量（cap）就是新申请容量（cap）。</font>

<font style="color:rgb(68, 68, 68);">需要注意的是，切片扩容还会根据切片中元素的类型不同而做不同的处理，比如</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int</font><font style="color:rgb(68, 68, 68);">和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">string</font><font style="color:rgb(68, 68, 68);">类型的处理方式就不一样。</font>

## <font style="color:black;">使用copy()函数复制切片</font>
<font style="color:rgb(68, 68, 68);">首先我们来看一个问题：</font>

```go
func main() {
	a := []int{1, 2, 3, 4, 5}
	b := a
	fmt.Println(a) //[1 2 3 4 5]
	fmt.Println(b) //[1 2 3 4 5]
	b[0] = 1000
	fmt.Println(a) //[1000 2 3 4 5]
	fmt.Println(b) //[1000 2 3 4 5]
}
```

<font style="color:rgb(68, 68, 68);">a和b其实都指向了同一块内存地址。修改b的同时a的值也会发生变化。</font>

<font style="color:rgb(68, 68, 68);">Go语言内建的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">copy()</font><font style="color:rgb(68, 68, 68);">函数可以迅速地将一个切片的数据复制到另外一个切片空间中，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">copy()</font><font style="color:rgb(68, 68, 68);">函数的使用格式如下：</font>

```go
copy(destSlice, srcSlice []T)
```

<font style="color:rgb(68, 68, 68);">其中：</font>

+ <font style="color:rgb(68, 68, 68);">srcSlice: 数据来源切片</font>
+ <font style="color:rgb(68, 68, 68);">destSlice: 目标切片</font>

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func main() {
	// copy()复制切片
	a := []int{1, 2, 3, 4, 5}
	c := make([]int, 5, 5)
	copy(c, a)     //使用copy()函数将切片a中的元素复制到切片c
	fmt.Println(a) //[1 2 3 4 5]
	fmt.Println(c) //[1 2 3 4 5]
	c[0] = 1000
	fmt.Println(a) //[1 2 3 4 5]
	fmt.Println(c) //[1000 2 3 4 5]
}
```

## <font style="color:black;">从切片中删除元素</font>
<font style="color:rgb(68, 68, 68);">Go语言中并没有删除切片元素的专用方法，我们可以使用切片本身的特性来删除元素。 代码如下：</font>

```go
func main() {
	// 从切片中删除元素
	a := []int{30, 31, 32, 33, 34, 35, 36, 37}
	// 要删除索引为2的元素
	a = append(a[:2], a[3:]...)
	fmt.Println(a) //[30 31 33 34 35 36 37]
}
```

<font style="color:rgb(68, 68, 68);">总结一下就是：要从切片a中删除索引为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">index</font><font style="color:rgb(68, 68, 68);">的元素，操作方法是</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">a = append(a[:index], a[index+1:]...)</font>

## <font style="color:black;">练习题</font>
<font style="color:rgb(68, 68, 68);">1.请写出下面代码的输出结果。</font>

```go
func main() {
	var a = make([]string, 5, 10)
    fmt.Println(a)     //[    ]
	for i := 0; i < 10; i++ {
		a = append(a, fmt.Sprintf("%v", i))
	}
	fmt.Println(a)  //[     0 1 2 3 4 5 6 7 8 9]
    fmt.Println(len(a)) // 15
}
```

<font style="color:rgb(68, 68, 68);">2.请使用内置的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">sort</font><font style="color:rgb(68, 68, 68);">包对数组</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">var a = [...]int{3, 7, 8, 9, 1}</font><font style="color:rgb(68, 68, 68);">进行排序（附加题，自行查资料解答）。</font>

```go
	var a = [...]int{3, 7, 8, 9, 1}
	x := a[:]

	// fmt.Println(x)
	// fmt.Println(sort.IntsAreSorted(x))

	sort.Ints(x) //默认升序
	// fmt.Println(sort.IntsAreSorted(x))
	fmt.Println(x) //[1 3 7 8 9]

	sort.Sort(sort.Reverse(sort.IntSlice(x))) //降序
	fmt.Println(x)    

https://blog.csdn.net/qq_33766994/article/details/107535954?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522164749820016780255266109%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=164749820016780255266109&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-107535954.142^v2^article_score_rank,143^v4^control&utm_term=go+sort+%E6%8E%92%E5%BA%8F&spm=1018.2226.3001.4187
```

  




# <font style="color:rgb(68, 68, 68);">Go语言fmt.Sprintf（格式化输出）</font>
<font style="color:rgb(68, 68, 68);">格式化在逻辑中非常常用。使用格式化函数，要注意写法：</font>

<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">fmt.Sprintf(格式化样式, 参数列表…)</font>

<font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);"></font>

<font style="color:rgb(68, 68, 68);">下表中标出了常用的一些格式化样式中的动词及功能。</font>

| <font style="color:rgb(68, 68, 68);">动  词</font> | <font style="color:rgb(68, 68, 68);">功  能</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">%v</font> | <font style="color:rgb(68, 68, 68);">按值的本来值输出</font> |
| <font style="color:rgb(68, 68, 68);">%+v</font> | <font style="color:rgb(68, 68, 68);">在 %v 基础上，对结构体字段名和值进行展开</font> |
| <font style="color:rgb(68, 68, 68);">%#v</font> | <font style="color:rgb(68, 68, 68);">输出 Go 语言语法格式的值</font> |
| <font style="color:rgb(68, 68, 68);">%T</font> | <font style="color:rgb(68, 68, 68);">输出 Go 语言语法格式的类型和值</font> |
| <font style="color:rgb(68, 68, 68);">%%</font> | <font style="color:rgb(68, 68, 68);">输出 % 本体</font> |
| <font style="color:rgb(68, 68, 68);">%b</font> | <font style="color:rgb(68, 68, 68);">整型以二进制方式显示</font> |
| <font style="color:rgb(68, 68, 68);">%o</font> | <font style="color:rgb(68, 68, 68);">整型以八进制方式显示</font> |
| <font style="color:rgb(68, 68, 68);">%d</font> | <font style="color:rgb(68, 68, 68);">整型以十进制方式显示</font> |
| <font style="color:rgb(68, 68, 68);">%x</font> | <font style="color:rgb(68, 68, 68);">整型以十六进制方式显示</font> |
| <font style="color:rgb(68, 68, 68);">%X</font> | <font style="color:rgb(68, 68, 68);">整型以十六进制、字母大写方式显示</font> |
| <font style="color:rgb(68, 68, 68);">%U</font> | <font style="color:rgb(68, 68, 68);">Unicode 字符</font> |
| <font style="color:rgb(68, 68, 68);">%f</font> | <font style="color:rgb(68, 68, 68);">浮点数</font> |
| <font style="color:rgb(68, 68, 68);">%p</font> | <font style="color:rgb(68, 68, 68);">指针，十六进制方式显示</font> |


参考地址 [http://c.biancheng.net/view/41.html](http://c.biancheng.net/view/41.html)  




> 更新: 2022-06-02 21:11:20  
> 原文: <https://www.yuque.com/chengkanghua/go/nik65h>