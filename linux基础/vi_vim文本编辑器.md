# vi/vim 文本编辑器

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">一、Vim 三大核心模式（必背）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Vim 所有操作都基于这 3 种模式，切换逻辑是核心</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">模式名称</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">核心作用</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">进入 / 切换方式</font>** |
| :--- | :--- | :--- |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令模式</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">(默认模式)</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">执行快捷键（复制、删除、跳转、搜索）</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">无法输入文字</font>** | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 打开文件默认进入</font><br/><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 编辑模式按 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ESC</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">回到</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">输入模式</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">(编辑模式)</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">正常输入、修改文本内容</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令模式按：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">i / a / o</font></code><br/><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 等快捷键</font> |
| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">底线模式</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">(末行模式)</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">执行保存、退出、替换、显示行号等操作</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令模式按 </font><code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:</font>**</code>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">(冒号)</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 进入</font> |

###

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">二、基础操作：打开 / 保存 / 退出（底线模式命令）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">在</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令模式</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">下按 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 输入，执行后回车生效</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:w</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">仅保存文件</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:w 文件名</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">另存为新文件</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:q</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">退出 Vim（未修改时可用）</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:q!</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">强制退出，</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">不保存</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">修改</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:wq</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">保存并退出</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:x</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">保存并退出（简写，和 wq 功能一致）</font> |

## <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">三、高频快捷键大全（命令模式下使用）</font>

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1. 快速进入输入模式（最常用）</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">快捷键</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">i</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">在光标</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">左侧</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">插入（最常用）</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">a</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">在光标</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">右侧</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">插入</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">I</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">在当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">行首</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">插入</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">A</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">在当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">行尾</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">插入</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">o</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">在当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">下方</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">新建一行</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">O</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">在当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">上方</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">新建一行</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">cc</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">删除整行并直接进入编辑模式</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">C</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">删除光标到行尾，并进入编辑模式</font> |

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2. 光标移动（高效操作）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">快捷键</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">h</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">← </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">j</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">↓ </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">k</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">↑ </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">l</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> →</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">上下左右移动（替代方向键）</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">gg</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跳转到</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">文件第一行</font>** |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">G</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跳转到</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">文件最后一行</font>** |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">nG</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> / </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ngg</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跳转到指定行（例：10G → 第 10 行）</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">0</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跳转到当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">绝对行首</font>** |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">$</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">跳转到当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">行尾</font>** |

***

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3. 删除 / 撤销 / 恢复</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">快捷键</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">x</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">删除光标所在字符</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">dd</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">删除</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">当前整行</font>** |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ndd</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">删除连续 n 行（例：3dd → 删除 3 行）</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">dG</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">删除光标所在行 → 文件末尾</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">u</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">撤销上一步操作（必备）</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">U</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">撤销对当前行的所有修改</font> |

***

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">4. 显示 / 隐藏行号</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:set nu</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">显示行号</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:set nonu</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">隐藏行号</font> |

***

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">5. 文本搜索</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">快捷键</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">/关键词</font></code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">向下</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">搜索关键词</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">?关键词</font></code> | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">向上</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">搜索关键词</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">n</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">查找</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">下一个</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配内容</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">N</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">查找</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">上一个</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配内容</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:noh</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">临时取消搜索高亮</font> |

***

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">6. 文本替换（底线命令）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:s/旧内容/新内容</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">替换当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">第一个</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配内容</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:s/旧内容/新内容/g</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">替换当前行</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">所有</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">匹配内容</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:n,ms/旧内容/新内容/g</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">替换 n~m 行的所有内容</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:%s/旧内容/新内容/g</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">替换</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">整个文件</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">所有匹配内容</font> |

***

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">7. 批量列编辑（批量修改神器）</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">步骤</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">操作</font>** |
| :--- | :--- |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">1</font> | <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">Ctrl + v</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);"> 进入</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">列编辑模式</font>**<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，选中目标区域</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">2</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">按 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">I</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">（大写 i）进入编辑</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">3</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">输入要添加的内容</font> |
| <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">4</font> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">按 </font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">ESC</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">，批量生效</font> |

***

### <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">8. 帮助文档</font>

<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">表格</font>

| **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">命令</font>** | **<font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">功能说明</font>** |
| :--- | :--- |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:help</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">打开 Vim 帮助文档</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:help 快捷键</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">查看指定快捷键说明（例：</font><code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:help G</font></code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">）</font> |
| <code><font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">:q</font></code> | <font style="color:rgb(0, 0, 0);background-color:rgba(0, 0, 0, 0);">退出帮助文档</font> |

####

# 退出文件的恢复

# 会在当前文件夹下产生.swp 的隐藏文件

vim -r index.html.swp

# vim 个性化

```bash
# 编辑一个代码文件，代码长度越长越好
vim test.c
ctrl+w+v  #屏幕一分二  再次按一分三了
:vsp     #命令行模式一样  长格式 :vsplit
:sp      # 横屏      :split

#屏幕之间切换
ctrl+w+l   # 最后一个l是方向  lhkj

#编辑方式方式和平常一样

#在同一个窗口下打开多个不同的文件
:e<path_to_file>/filename.extension
:e~/.vimrc
:sp<file_path>
:vsp<file_path>

#vim 开启语法高亮
echo "syntax on" >> /root/.vimrc  # syntax off 是关闭

#改变配色方案
[root@m01 ~]# ls /usr/share/vim/vim74/colors/
blue.vim      default.vim  desert.vim   evening.vim  morning.vim  pablo.vim      README.txt  shine.vim  torte.vim
darkblue.vim  delek.vim    elflord.vim  koehler.vim  murphy.vim   peachpuff.vim  ron.vim     slate.vim  zellner.vim

vim hello.html
:colorscheme morning  #临时更改配色方案

#更改配色方案
vim /root/.vimrc
syntax on
color evening
set background=dark

```


> 更新: 2026-04-27 00:23:47  
> 原文: <https://www.yuque.com/chengkanghua/oldboy50/ashe0w>