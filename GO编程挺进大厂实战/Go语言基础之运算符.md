# Go语言基础之运算符

<font style="color:rgb(68, 68, 68);">运算符用于在程序运行时执行数学或逻辑运算。</font>

# <font style="color:rgb(68, 68, 68);">运算符</font>
<font style="color:rgb(68, 68, 68);">Go 语言内置的运算符有：</font>

1. <font style="color:rgb(68, 68, 68);">算术运算符</font>
2. <font style="color:rgb(68, 68, 68);">关系运算符</font>
3. <font style="color:rgb(68, 68, 68);">逻辑运算符</font>
4. <font style="color:rgb(68, 68, 68);">位运算符</font>
5. <font style="color:rgb(68, 68, 68);">赋值运算符</font>

## <font style="color:black;">算术运算符</font>
| <font style="color:rgb(255, 255, 255);">运算符</font> | <font style="color:rgb(255, 255, 255);">描述</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">+</font> | <font style="color:rgb(68, 68, 68);">相加</font> |
| <font style="color:rgb(68, 68, 68);">-</font> | <font style="color:rgb(68, 68, 68);">相减</font> |
| <font style="color:rgb(68, 68, 68);">*</font> | <font style="color:rgb(68, 68, 68);">相乘</font> |
| <font style="color:rgb(68, 68, 68);">/</font> | <font style="color:rgb(68, 68, 68);">相除</font> |
| <font style="color:rgb(68, 68, 68);">%</font> | <font style="color:rgb(68, 68, 68);">求余</font> |


**<font style="color:red;">注意：</font>**<font style="color:rgb(68, 68, 68);"> </font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">++</font><font style="color:rgb(68, 68, 68);">（自增）和</font><font style="color:rgb(68, 68, 68);background-color:rgb(248, 248, 248);">--</font><font style="color:rgb(68, 68, 68);">（自减）在Go语言中是单独的语句，并不是运算符。</font>

## <font style="color:black;">关系运算符</font>
| <font style="color:rgb(255, 255, 255);">运算符</font> | <font style="color:rgb(255, 255, 255);">描述</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">==</font> | <font style="color:rgb(68, 68, 68);">检查两个值是否相等，如果相等返回 True 否则返回 False。</font> |
| <font style="color:rgb(68, 68, 68);">!=</font> | <font style="color:rgb(68, 68, 68);">检查两个值是否不相等，如果不相等返回 True 否则返回 False。</font> |
| <font style="color:rgb(68, 68, 68);">></font> | <font style="color:rgb(68, 68, 68);">检查左边值是否大于右边值，如果是返回 True 否则返回 False。</font> |
| <font style="color:rgb(68, 68, 68);">>=</font> | <font style="color:rgb(68, 68, 68);">检查左边值是否大于等于右边值，如果是返回 True 否则返回 False。</font> |
| <font style="color:rgb(68, 68, 68);"><</font> | <font style="color:rgb(68, 68, 68);">检查左边值是否小于右边值，如果是返回 True 否则返回 False。</font> |
| <font style="color:rgb(68, 68, 68);"><=</font> | <font style="color:rgb(68, 68, 68);">检查左边值是否小于等于右边值，如果是返回 True 否则返回 False。</font> |


## <font style="color:black;">逻辑运算符</font>
| <font style="color:rgb(255, 255, 255);">运算符</font> | <font style="color:rgb(255, 255, 255);">描述</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">&&</font> | <font style="color:rgb(68, 68, 68);">逻辑 AND 运算符。 如果两边的操作数都是 True，则为 True，否则为 False。</font> |
| <font style="color:rgb(68, 68, 68);">||</font> | <font style="color:rgb(68, 68, 68);">逻辑 OR 运算符。 如果两边的操作数有一个 True，则为 True，否则为 False。</font> |
| <font style="color:rgb(68, 68, 68);">!</font> | <font style="color:rgb(68, 68, 68);">逻辑 NOT 运算符。 如果条件为 True，则为 False，否则为 True。</font> |


## <font style="color:black;">位运算符</font>
<font style="color:rgb(68, 68, 68);">位运算符对整数在内存中的二进制位进行操作。</font>

| <font style="color:rgb(255, 255, 255);">运算符</font> | <font style="color:rgb(255, 255, 255);">描述</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">&</font> | <font style="color:rgb(68, 68, 68);">参与运算的两数各对应的二进位相与。   </font><font style="color:rgb(68, 68, 68);">（两位均为1才为1）</font> |
| <font style="color:rgb(68, 68, 68);">|</font> | <font style="color:rgb(68, 68, 68);">参与运算的两数各对应的二进位相或。   </font><font style="color:rgb(68, 68, 68);">（两位有一个为1就为1）</font> |
| <font style="color:rgb(68, 68, 68);">^</font> | <font style="color:rgb(68, 68, 68);">参与运算的两数各对应的二进位相异或，当两对应的二进位相异时，结果为1。   </font><font style="color:rgb(68, 68, 68);">（两位不一样则为1）</font> |
| <font style="color:rgb(68, 68, 68);"><<</font> | <font style="color:rgb(68, 68, 68);">左移n位就是乘以2的n次方。   </font><font style="color:rgb(68, 68, 68);">“a<<b”是把a的各二进位全部左移b位，高位丢弃，低位补0。</font> |
| <font style="color:rgb(68, 68, 68);">>></font> | <font style="color:rgb(68, 68, 68);">右移n位就是除以2的n次方。   </font><font style="color:rgb(68, 68, 68);">“a>>b”是把a的各二进位全部右移b位。</font> |


## <font style="color:black;">赋值运算符</font>
| <font style="color:rgb(255, 255, 255);">运算符</font> | <font style="color:rgb(255, 255, 255);">描述</font> |
| --- | --- |
| <font style="color:rgb(68, 68, 68);">=</font> | <font style="color:rgb(68, 68, 68);">简单的赋值运算符，将一个表达式的值赋给一个左值</font> |
| <font style="color:rgb(68, 68, 68);">+=</font> | <font style="color:rgb(68, 68, 68);">相加后再赋值</font> |
| <font style="color:rgb(68, 68, 68);">-=</font> | <font style="color:rgb(68, 68, 68);">相减后再赋值</font> |
| <font style="color:rgb(68, 68, 68);">*=</font> | <font style="color:rgb(68, 68, 68);">相乘后再赋值</font> |
| <font style="color:rgb(68, 68, 68);">/=</font> | <font style="color:rgb(68, 68, 68);">相除后再赋值</font> |
| <font style="color:rgb(68, 68, 68);">%=</font> | <font style="color:rgb(68, 68, 68);">求余后再赋值</font> |
| <font style="color:rgb(68, 68, 68);"><<=</font> | <font style="color:rgb(68, 68, 68);">左移后赋值</font> |
| <font style="color:rgb(68, 68, 68);">>>=</font> | <font style="color:rgb(68, 68, 68);">右移后赋值</font> |
| <font style="color:rgb(68, 68, 68);">&=</font> | <font style="color:rgb(68, 68, 68);">按位与后赋值</font> |
| <font style="color:rgb(68, 68, 68);">|=</font> | <font style="color:rgb(68, 68, 68);">按位或后赋值</font> |
| <font style="color:rgb(68, 68, 68);">^=</font> | <font style="color:rgb(68, 68, 68);">按位异或后赋值</font> |


# <font style="color:rgb(68, 68, 68);">练习题</font>
<font style="color:rgb(68, 68, 68);">有一堆数字，如果除了一个数字以外，其他数字都出现了两次，那么如何找到出现一次的数字？</font>

```go
// 一堆数找出只出现一次的那个
func f11() {
	nums := []int{17, 4, 3, 3, 9, 11, 9, 11, 17}
	if len(nums)%2 == 0 {
		return
	}
	ret := nums[0]
	for _, num := range nums[1:] {
		ret ^= num // 异或
	}
	fmt.Println(ret)

}
```



小笔记：

```go
	nums := []int{17, 4, 3, 3, 9, 11, 9, 11, 17} // int 类型数组
	s1 := 99
	fmt.Println(reflect.TypeOf(nums))
	fmt.Println(reflect.TypeOf(s1))
```

  




> 更新: 2022-03-16 16:15:44  
> 原文: <https://www.yuque.com/chengkanghua/go/qorl59>