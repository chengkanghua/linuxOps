# Go语言基础之函数

<font style="color:rgb(68, 68, 68);">函数是组织好的、可重复使用的、用于执行指定任务的代码块。本文介绍了Go语言中函数的相关内容。</font>

# <font style="color:rgb(68, 68, 68);">函数</font>
<font style="color:rgb(68, 68, 68);">Go语言中支持函数、匿名函数和闭包，并且函数在Go语言中属于“一等公民”。</font>

## <font style="color:black;">函数定义</font>
<font style="color:rgb(68, 68, 68);">Go语言中定义函数使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">func</font><font style="color:rgb(68, 68, 68);">关键字，具体格式如下：</font>

```go
func 函数名(参数)(返回值){
    函数体
}
```

<font style="color:rgb(68, 68, 68);">其中：</font>

+ <font style="color:rgb(68, 68, 68);">函数名：由字母、数字、下划线组成。但函数名的第一个字母不能是数字。在同一个包内，函数名也称不能重名（包的概念详见后文）。</font>
+ <font style="color:rgb(68, 68, 68);">参数：参数由参数变量和参数变量的类型组成，多个参数之间使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">,</font><font style="color:rgb(68, 68, 68);">分隔。</font>
+ <font style="color:rgb(68, 68, 68);">返回值：返回值由返回值变量和其变量类型组成，也可以只写返回值的类型，多个返回值必须用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">()</font><font style="color:rgb(68, 68, 68);">包裹，并用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">,</font><font style="color:rgb(68, 68, 68);">分隔。</font>
+ <font style="color:rgb(68, 68, 68);">函数体：实现指定功能的代码块。</font>

<font style="color:rgb(68, 68, 68);">我们先来定义一个求两个数之和的函数：</font>

```go
func intSum(x int, y int) int {
	return x + y
}
```

<font style="color:rgb(68, 68, 68);">函数的参数和返回值都是可选的，例如我们可以实现一个既不需要参数也没有返回值的函数：</font>

```go
func sayHello() {
	fmt.Println("Hello 沙河")
}
```

## <font style="color:black;">函数的调用</font>
<font style="color:rgb(68, 68, 68);">定义了函数之后，我们可以通过</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">函数名()</font><font style="color:rgb(68, 68, 68);">的方式调用函数。 例如我们调用上面定义的两个函数，代码如下：</font>

```go
func main() {
	sayHello()
	ret := intSum(10, 20)
	fmt.Println(ret)
}
```

<font style="color:rgb(68, 68, 68);">注意，调用有返回值的函数时，可以不接收其返回值。</font>

## <font style="color:black;">参数</font>
### <font style="color:rgb(186, 57, 37);">类型简写</font>
<font style="color:rgb(68, 68, 68);">函数的参数中如果相邻变量的类型相同，则可以省略类型，例如：</font>

```go
func intSum(x, y int) int {
	return x + y
}
```

<font style="color:rgb(68, 68, 68);">上面的代码中，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">intSum</font><font style="color:rgb(68, 68, 68);">函数有两个参数，这两个参数的类型均为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">int</font><font style="color:rgb(68, 68, 68);">，因此可以省略</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">x</font><font style="color:rgb(68, 68, 68);">的类型，因为</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">y</font><font style="color:rgb(68, 68, 68);">后面有类型说明，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">x</font><font style="color:rgb(68, 68, 68);">参数也是该类型。</font>

### <font style="color:rgb(186, 57, 37);">可变参数</font>
<font style="color:rgb(68, 68, 68);">可变参数是指函数的参数数量不固定。Go语言中的可变参数通过在参数名后加</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">...</font><font style="color:rgb(68, 68, 68);">来标识。</font>

<font style="color:rgb(68, 68, 68);">注意：可变参数通常要作为函数的最后一个参数。</font>

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func intSum2(x ...int) int {
	fmt.Println(x) //x是一个切片
	sum := 0
	for _, v := range x {
		sum = sum + v
	}
	return sum
}
```

<font style="color:rgb(68, 68, 68);">调用上面的函数：</font>

```go
ret1 := intSum2()
ret2 := intSum2(10)
ret3 := intSum2(10, 20)
ret4 := intSum2(10, 20, 30)
fmt.Println(ret1, ret2, ret3, ret4) //0 10 30 60
```

<font style="color:rgb(68, 68, 68);">固定参数搭配可变参数使用时，可变参数要放在固定参数的后面，示例代码如下：</font>

```go
func intSum3(x int, y ...int) int {
	fmt.Println(x, y)
	sum := x
	for _, v := range y {
		sum = sum + v
	}
	return sum
}
```

<font style="color:rgb(68, 68, 68);">调用上述函数：</font>

```go
ret5 := intSum3(100)
ret6 := intSum3(100, 10)
ret7 := intSum3(100, 10, 20)
ret8 := intSum3(100, 10, 20, 30)
fmt.Println(ret5, ret6, ret7, ret8) //100 110 130 160
```

<font style="color:rgb(68, 68, 68);">本质上，函数的可变参数是通过切片来实现的。</font>

## <font style="color:black;">返回值</font>
<font style="color:rgb(68, 68, 68);">Go语言中通过</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">return</font><font style="color:rgb(68, 68, 68);">关键字向外输出返回值。</font>

### <font style="color:rgb(186, 57, 37);">多返回值</font>
<font style="color:rgb(68, 68, 68);">Go语言中函数支持多返回值，函数如果有多个返回值时必须用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">()</font><font style="color:rgb(68, 68, 68);">将所有返回值包裹起来。</font>

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func calc(x, y int) (int, int) {
	sum := x + y
	sub := x - y
	return sum, sub
}
```

### <font style="color:rgb(186, 57, 37);">返回值命名</font>
<font style="color:rgb(68, 68, 68);">函数定义时可以给返回值命名，并在函数体中直接使用这些变量，最后通过</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">return</font><font style="color:rgb(68, 68, 68);">关键字返回。</font>

<font style="color:rgb(68, 68, 68);">例如：</font>

```go
func calc(x, y int) (sum, sub int) {
	sum = x + y
	sub = x - y
	return
}
```

### <font style="color:rgb(186, 57, 37);">返回值补充</font>
<font style="color:rgb(68, 68, 68);">当我们的一个函数返回值类型为slice时，nil可以看做是一个有效的slice，没必要显示返回一个长度为0的切片。</font>

```go
func someFunc(x string) []int {
	if x == "" {
		return nil // 没必要返回[]int{}
	}
	...
}
```

# <font style="color:rgb(68, 68, 68);">函数进阶</font>
## <font style="color:black;">变量作用域</font>
### <font style="color:rgb(186, 57, 37);">全局变量</font>
<font style="color:rgb(68, 68, 68);">全局变量是定义在函数外部的变量，它在程序整个运行周期内都有效。 在函数中可以访问到全局变量。</font>

```go
package main

import "fmt"

//定义全局变量num
var num int64 = 10

func testGlobalVar() {
	fmt.Printf("num=%d\n", num) //函数中可以访问全局变量num
}
func main() {
	testGlobalVar() //num=10
}

```

### <font style="color:rgb(186, 57, 37);">局部变量</font>
<font style="color:rgb(68, 68, 68);">局部变量又分为两种： 函数内定义的变量无法在该函数外使用，例如下面的示例代码main函数中无法使用testLocalVar函数中定义的变量x：</font>

```go
func testLocalVar() {
	//定义一个函数局部变量x,仅在该函数内生效
	var x int64 = 100
	fmt.Printf("x=%d\n", x)
}

func main() {
	testLocalVar()
	fmt.Println(x) // 此时无法使用变量x
}
```

<font style="color:rgb(68, 68, 68);">如果局部变量和全局变量重名，优先访问局部变量。</font>

```go
package main

import "fmt"

//定义全局变量num
var num int64 = 10

func testNum() {
	num := 100
	fmt.Printf("num=%d\n", num) // 函数中优先使用局部变量
}
func main() {
	testNum() // num=100
}
```

<font style="color:rgb(68, 68, 68);">接下来我们来看一下语句块定义的变量，通常我们会在if条件判断、for循环、switch语句上使用这种定义变量的方式。</font>

```go
func testLocalVar2(x, y int) {
	fmt.Println(x, y) //函数的参数也是只在本函数中生效
	if x > 0 {
		z := 100 //变量z只在if语句块生效
		fmt.Println(z)
	}
	//fmt.Println(z)//此处无法使用变量z
}
```

<font style="color:rgb(68, 68, 68);">还有我们之前讲过的for循环语句中定义的变量，也是只在for语句块中生效：</font>

```go
func testLocalVar3() {
	for i := 0; i < 10; i++ {
		fmt.Println(i) //变量i只在当前for语句块中生效
	}
	//fmt.Println(i) //此处无法使用变量i
}
```

## <font style="color:black;">函数类型与变量</font>
### <font style="color:rgb(186, 57, 37);">定义函数类型</font>
<font style="color:rgb(68, 68, 68);">我们可以使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">type</font><font style="color:rgb(68, 68, 68);">关键字来定义一个函数类型，具体格式如下：</font>

```go
type calculation func(int, int) int
```

<font style="color:rgb(68, 68, 68);">上面语句定义了一个</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">calculation</font><font style="color:rgb(68, 68, 68);">类型，它是一种函数类型，这种函数接收两个int类型的参数并且返回一个int类型的返回值。</font>

<font style="color:rgb(68, 68, 68);">简单来说，凡是满足这个条件的函数都是calculation类型的函数，例如下面的add和sub是calculation类型。</font>

```go
func add(x, y int) int {
	return x + y
}

func sub(x, y int) int {
	return x - y
}
```

<font style="color:rgb(68, 68, 68);">add和sub都能赋值给calculation类型的变量。</font>

```go
var c calculation
c = add
```

### <font style="color:rgb(186, 57, 37);">函数类型变量</font>
<font style="color:rgb(68, 68, 68);">我们可以声明函数类型的变量并且为该变量赋值：</font>

```go
func main() {
	var c calculation               // 声明一个calculation类型的变量c
	c = add                         // 把add赋值给c
	fmt.Printf("type of c:%T\n", c) // type of c:main.calculation
	fmt.Println(c(1, 2))            // 像调用add一样调用c

	f := add                        // 将函数add赋值给变量f1
	fmt.Printf("type of f:%T\n", f) // type of f:func(int, int) int
	fmt.Println(f(10, 20))          // 像调用add一样调用f
}
```

## <font style="color:black;">高阶函数</font>
<font style="color:rgb(68, 68, 68);">高阶函数分为函数作为参数和函数作为返回值两部分。</font>

### <font style="color:rgb(186, 57, 37);">函数作为参数</font>
<font style="color:rgb(68, 68, 68);">函数可以作为参数：</font>

```go
func add(x, y int) int {
	return x + y
}
func calc(x, y int, op func(int, int) int) int {
	return op(x, y)
}
func main() {
	ret2 := calc(10, 20, add)
	fmt.Println(ret2) //30
}
```

### <font style="color:rgb(186, 57, 37);">函数作为返回值</font>
<font style="color:rgb(68, 68, 68);">函数也可以作为返回值：</font>

```go
func do(s string) (func(int, int) int, error) {
	switch s {
	case "+":
		return add, nil
	case "-":
		return sub, nil
	default:
		err := errors.New("无法识别的操作符")
		return nil, err
	}
}
```

## <font style="color:black;">匿名函数和闭包</font>
### <font style="color:rgb(186, 57, 37);">匿名函数</font>
<font style="color:rgb(68, 68, 68);">函数当然还可以作为返回值，但是在Go语言中函数内部不能再像之前那样定义函数了，只能定义匿名函数。匿名函数就是没有函数名的函数，匿名函数的定义格式如下：</font>

```go
func(参数)(返回值){
    函数体
}
```

<font style="color:rgb(68, 68, 68);">匿名函数因为没有函数名，所以没办法像普通函数那样调用，所以匿名函数需要保存到某个变量或者作为立即执行函数:</font>

```go
func main() {
	// 将匿名函数保存到变量
	add := func(x, y int) {
		fmt.Println(x + y)
	}
	add(10, 20) // 通过变量调用匿名函数

	//自执行函数：匿名函数定义完加()直接执行
	func(x, y int) {
		fmt.Println(x + y)
	}(10, 20)
}
```

<font style="color:rgb(68, 68, 68);">匿名函数多用于实现回调函数和闭包。</font>

### <font style="color:rgb(186, 57, 37);">闭包</font>
<font style="color:rgb(68, 68, 68);">闭包指的是一个函数和与其相关的引用环境组合而成的实体。简单来说，</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">闭包=函数+引用环境</font><font style="color:rgb(68, 68, 68);">。 首先我们来看一个例子：</font>

```go
func adder() func(int) int {
	var x int
	return func(y int) int {
		x += y
		return x
	}
}
func main() {
	var f = adder()
	fmt.Println(f(10)) //10
	fmt.Println(f(20)) //30
	fmt.Println(f(30)) //60

	f1 := adder()
	fmt.Println(f1(40)) //40
	fmt.Println(f1(50)) //90
}
```

<font style="color:rgb(68, 68, 68);">变量</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">f</font><font style="color:rgb(68, 68, 68);">是一个函数并且它引用了其外部作用域中的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">x</font><font style="color:rgb(68, 68, 68);">变量，此时</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">f</font><font style="color:rgb(68, 68, 68);">就是一个闭包。 在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">f</font><font style="color:rgb(68, 68, 68);">的生命周期内，变量</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">x</font><font style="color:rgb(68, 68, 68);">也一直有效。 闭包进阶示例1：</font>

```go
func adder2(x int) func(int) int {
	return func(y int) int {
		x += y
		return x
	}
}
func main() {
	var f = adder2(10)
	fmt.Println(f(10)) //20
	fmt.Println(f(20)) //40
	fmt.Println(f(30)) //70

	f1 := adder2(20)
	fmt.Println(f1(40)) //60
	fmt.Println(f1(50)) //110
}
```

<font style="color:rgb(68, 68, 68);">闭包进阶示例2：</font>

```go
func makeSuffixFunc(suffix string) func(string) string {
	return func(name string) string {
        //判断字符串name是否是 suffix结尾
		if !strings.HasSuffix(name, suffix) {
			return name + suffix
		}
		return name
	}
}

func main() {
	jpgFunc := makeSuffixFunc(".jpg")
	txtFunc := makeSuffixFunc(".txt")
	fmt.Println(jpgFunc("test")) //test.jpg
	fmt.Println(txtFunc("test")) //test.txt
}
```

<font style="color:rgb(68, 68, 68);">闭包进阶示例3：</font>

```go
func calc(base int) (func(int) int, func(int) int) {
	add := func(i int) int {
		base += i
		return base
	}

	sub := func(i int) int {
		base -= i
		return base
	}
	return add, sub
}

func main() {
	f1, f2 := calc(10)
	fmt.Println(f1(1), f2(2)) //11 9
	fmt.Println(f1(3), f2(4)) //12 8
	fmt.Println(f1(5), f2(6)) //13 7
}
```

<font style="color:rgb(68, 68, 68);">闭包其实并不复杂，只要牢记</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">闭包=函数+引用环境</font><font style="color:rgb(68, 68, 68);">。</font>

## <font style="color:black;">defer语句</font>
<font style="color:rgb(68, 68, 68);">Go语言中的</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">语句会将其后面跟随的语句进行延迟处理。在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">归属的函数即将返回时，将延迟处理的语句按</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">定义的逆序进行执行，也就是说，先被</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">的语句最后被执行，最后被</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">的语句，最先被执行。</font>

<font style="color:rgb(68, 68, 68);">举个例子：</font>

```go
func main() {
	fmt.Println("start")
	defer fmt.Println(1)
	defer fmt.Println(2)
	defer fmt.Println(3)
	fmt.Println("end")
}
```

<font style="color:rgb(68, 68, 68);">输出结果：</font>

```go
start
end
3
2
1
```

<font style="color:rgb(68, 68, 68);">由于</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">语句延迟调用的特性，所以</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">语句能非常方便的处理资源释放问题。比如：资源清理、文件关闭、解锁及记录时间等。</font>

### <font style="color:rgb(186, 57, 37);">defer执行时机</font>
<font style="color:rgb(68, 68, 68);">在Go语言的函数中</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">return</font><font style="color:rgb(68, 68, 68);">语句在底层并不是原子操作，它分为给返回值赋值和RET指令两步。而</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">语句执行的时机就在返回值赋值操作后，RET指令执行前。具体如下图所示：</font>

<!-- OCR_START -->
> 函数中return语句底层实现
> defer语句执行的时机
> 返回值=x
> 返回值=x
> returnx
> returnx
> 运行defer
> RET指令
> RET指令
<!-- OCR_END -->



### <font style="color:rgb(186, 57, 37);">defer经典案例</font>
<font style="color:rgb(68, 68, 68);">阅读下面的代码，写出最后的打印结果。</font>

```go
func f1() int {
	x := 5
	defer func() {
		x++
	}()
	return x  //5 返回值=x=5 -> defer操作 -> 底层RET返回
}

func f2() (x int) {
	defer func() {
		x++
	}()
	return 5  //6 返回值x=5 -〉 defer操作 -> 底层的RET返回
}

func f3() (y int) {
	x := 5
	defer func() {
		x++
	}()
	return x   //5 返回值=y=x=5 -> defer操作 -> 底层RET返回
}
func f4() (x int) {
	defer func(x int) {
		x++
	}(x)       // x当成参数传进匿名函数中
	return 5   //5
}
func main() {
	fmt.Println(f1())  //5
	fmt.Println(f2())  //6
	fmt.Println(f3())  //5
	fmt.Println(f4())  //5
}
```

### <font style="color:rgb(186, 57, 37);">defer面试题</font>
```go
func calc(index string, a, b int) int {
	ret := a + b
	fmt.Println(index, a, b, ret)
	return ret
}

func main() {
	x := 1
	y := 2
	defer calc("AA", x, calc("A", x, y))  // x 1 y 2
	x = 10
	defer calc("BB", x, calc("B", x, y))  // x 10 y 2
	y = 20
}

-----------------
A 1 2 3
B 10 2 12
BB 10 12 22
AA 1 3 4

--------------------------课堂例子
func sub(x, y int) int {
	return x - y
}

func deferDemo5() {
	x := 10
	defer func() {
		res := sub(x, sub(10, 2)) // x 100
		fmt.Println(res)
	}()
	x = 100
}

func main() {
	deferDemo5()    // 92
}


```

<font style="color:rgb(68, 68, 68);">问，上面代码的输出结果是？（提示：defer注册要延迟执行的函数时该函数所有的参数都需要确定其值）</font>

# <font style="color:rgb(68, 68, 68);">内置函数介绍</font>
| <font style="color:rgb(255, 255, 255);">内置函数</font> | <font style="color:rgb(255, 255, 255);">介绍</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">close</font> | <font style="color:rgb(68, 68, 68);">主要用来关闭channel</font> |
| <font style="color:rgb(68, 68, 68);">len</font> | <font style="color:rgb(68, 68, 68);">用来求长度，比如string、array、slice、map、channel</font> |
| <font style="color:rgb(68, 68, 68);">new</font> | <font style="color:rgb(68, 68, 68);">用来分配内存，主要用来分配值类型，比如int、struct。返回的是指针</font> |
| <font style="color:rgb(68, 68, 68);">make</font> | <font style="color:rgb(68, 68, 68);">用来分配内存，主要用来分配引用类型，比如chan、map、slice</font> |
| <font style="color:rgb(68, 68, 68);">append</font> | <font style="color:rgb(68, 68, 68);">用来追加元素到数组、slice中</font> |
| <font style="color:rgb(68, 68, 68);">panic和recover</font> | <font style="color:rgb(68, 68, 68);">用来做错误处理</font> |


### <font style="color:rgb(186, 57, 37);">panic/recover</font>
<font style="color:rgb(68, 68, 68);">Go语言中目前（Go1.12）是没有异常机制，但是使用</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">panic/recover</font><font style="color:rgb(68, 68, 68);">模式来处理错误。</font><font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">panic</font><font style="color:rgb(68, 68, 68);">可以在任何地方引发，但</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">recover</font><font style="color:rgb(68, 68, 68);">只有在</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">调用的函数中有效。 首先来看一个例子：</font>

```go
func funcA() {
	fmt.Println("func A")
}

func funcB() {
	panic("panic in B")
}

func funcC() {
	fmt.Println("func C")
}
func main() {
	funcA()
	funcB()
	funcC()
}
```

<font style="color:rgb(68, 68, 68);">输出：</font>

```go
func A
panic: panic in B

goroutine 1 [running]:
main.funcB(...)
        .../code/func/main.go:12
main.main()
        .../code/func/main.go:20 +0x98
```

<font style="color:rgb(68, 68, 68);">程序运行期间</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">funcB</font><font style="color:rgb(68, 68, 68);">中引发了</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">panic</font><font style="color:rgb(68, 68, 68);">导致程序崩溃，异常退出了。这个时候我们就可以通过</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">recover</font><font style="color:rgb(68, 68, 68);">将程序恢复回来，继续往后执行。</font>

```go
func funcA() {
	fmt.Println("func A")
}

func funcB() {
	defer func() {
		err := recover()
		//如果程序出出现了panic错误,可以通过recover恢复过来
		if err != nil {
			fmt.Println("recover in B")
		}
	}()
	panic("panic in B")
}

func funcC() {
	fmt.Println("func C")
}
func main() {
	funcA()
	funcB()
	funcC()
}
```

**<font style="color:red;">注意：</font>**

1. <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">recover()</font><font style="color:rgb(68, 68, 68);">必须搭配</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">使用。</font>
2. <font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">defer</font><font style="color:rgb(68, 68, 68);">一定要在可能引发</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">panic</font><font style="color:rgb(68, 68, 68);">的语句之前定义。</font>

# <font style="color:rgb(68, 68, 68);">练习题</font>
1. <font style="color:rgb(68, 68, 68);">分金币</font>

```go
/*
你有50枚金币，需要分配给以下几个人：Matthew,Sarah,Augustus,Heidi,Emilie,Peter,Giana,Adriano,Aaron,Elizabeth。
分配规则如下：
a. 名字中每包含1个'e'或'E'分1枚金币
b. 名字中每包含1个'i'或'I'分2枚金币
c. 名字中每包含1个'o'或'O'分3枚金币
d: 名字中每包含1个'u'或'U'分4枚金币
写一个程序，计算每个用户分到多少金币，以及最后剩余多少金币？
程序结构如下，请实现 ‘dispatchCoin’ 函数
*/
var (
	coins = 50
	users = []string{
		"Matthew", "Sarah", "Augustus", "Heidi", "Emilie", "Peter", "Giana", "Adriano", "Aaron", "Elizabeth",
	}
	distribution = make(map[string]int, len(users))
)

func main() {
	left := dispatchCoin()
	fmt.Println("剩下：", left)
}
```

  
答案：

```go
package main

import "fmt"

/*
你有50枚金币，需要分配给以下几个人：Matthew,Sarah,Augustus,Heidi,Emilie,Peter,Giana,Adriano,Aaron,Elizabeth。
分配规则如下：
a. 名字中每包含1个'e'或'E'分1枚金币
b. 名字中每包含1个'i'或'I'分2枚金币
c. 名字中每包含1个'o'或'O'分3枚金币
d: 名字中每包含1个'u'或'U'分4枚金币
写一个程序，计算每个用户分到多少金币，以及最后剩余多少金币？
程序结构如下，请实现 ‘dispatchCoin’ 函数
*/
var (
	coins = 50
	users = []string{
		"Matthew", "Sarah", "Augustus", "Heidi", "Emilie", "Peter", "Giana", "Adriano", "Aaron", "Elizabeth",
	}
	distribution = make(map[string]int, len(users))
)

func main() {
	left := dispatchCoin()
	fmt.Println("剩下：", left)
	fmt.Println(distribution)
}

// dispatchCoin 按规则分金币，返回剩余的金币数
func dispatchCoin() int {
	// 1.依次给每个人(拿到每个人的名字)  // 0 Matthew  ...
	for _, name := range users {
		userNum := dispatchForUser(name)
		// 3.登记每个人分了多少金币
		distribution[name] = userNum
		// 4.计算剩下的金币数
		coins = coins - userNum
	}
	return coins
}

func dispatchForUser(name string) int {
	// 2.按规则分金币（对名字判断规则）
	// 2.1 记录下每个人分的金币数
	userNum := 0

	for _, c := range name { // Matthew
		switch c {
		case 'e', 'E':
			userNum = userNum + 1
		case 'i', 'I':
			userNum = userNum + 2
		case 'o', 'O':
			userNum = userNum + 3
		case 'u', 'U':
			userNum = userNum + 4
		}
	}
	return userNum
}

```



> 更新: 2022-03-25 11:02:51  
> 原文: <https://www.yuque.com/chengkanghua/go/whh1tp>