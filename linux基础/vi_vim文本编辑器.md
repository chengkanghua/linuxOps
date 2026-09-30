# vi_vim文本编辑器

> 本文档已做排版优化（清除样式标签、统一导航），全部内容原样保留。

## 目录
- vi/vim 文本编辑器
  - 一、Vim 三大核心模式（必背）
    - ## 二、基础操作：打开 / 保存 / 退出（底线模式命令）
  - 三、高频快捷键大全（命令模式下使用）
    - 1. 快速进入输入模式（最常用）
    - 2. 光标移动（高效操作）
    - 3. 删除 / 撤销 / 恢复
    - 4. 显示 / 隐藏行号
    - 5. 文本搜索
    - 6. 文本替换（底线命令）
    - 7. 批量列编辑（批量修改神器）
    - 8. 帮助文档
      - # 退出文件的恢复
- 会在当前文件夹下产生.swp 的隐藏文件
- vim 个性化

# vi/vim 文本编辑器

## 一、Vim 三大核心模式（必背）

Vim 所有操作都基于这 3 种模式，切换逻辑是核心

表格

| **模式名称** | **核心作用** | **进入 / 切换方式** |
| :--- | :--- | :--- |
| **命令模式**(默认模式) | 执行快捷键（复制、删除、跳转、搜索）**无法输入文字** | 1. 打开文件默认进入<br/>2. 编辑模式按 <code>ESC</code>回到 |
| **输入模式**(编辑模式) | 正常输入、修改文本内容 | 命令模式按：<code>i / a / o</code><br/> 等快捷键 |
| **底线模式**(末行模式) | 执行保存、退出、替换、显示行号等操作 | 命令模式按 <code>**:**</code>**(冒号)** 进入 |

### ## 二、基础操作：打开 / 保存 / 退出（底线模式命令）

在**命令模式**下按 <code>:</code> 输入，执行后回车生效

表格

| **命令** | **功能说明** |
| :--- | :--- |
| <code>:w</code> | 仅保存文件 |
| <code>:w 文件名</code> | 另存为新文件 |
| <code>:q</code> | 退出 Vim（未修改时可用） |
| <code>:q!</code> | 强制退出，**不保存**修改 |
| <code>:wq</code> | 保存并退出 |
| <code>:x</code> | 保存并退出（简写，和 wq 功能一致） |

## 三、高频快捷键大全（命令模式下使用）

### 1. 快速进入输入模式（最常用）

| **快捷键** | **功能说明** |
| :--- | :--- |
| <code>i</code> | 在光标**左侧**插入（最常用） |
| <code>a</code> | 在光标**右侧**插入 |
| <code>I</code> | 在当前行**行首**插入 |
| <code>A</code> | 在当前行**行尾**插入 |
| <code>o</code> | 在当前行**下方**新建一行 |
| <code>O</code> | 在当前行**上方**新建一行 |
| <code>cc</code> | 删除整行并直接进入编辑模式 |
| <code>C</code> | 删除光标到行尾，并进入编辑模式 |

### 2. 光标移动（高效操作）

表格

| **快捷键** | **功能说明** |
| :--- | :--- |
| <code>h</code>← <code>j</code>↓ <code>k</code>↑ <code>l</code> → | 上下左右移动（替代方向键） |
| <code>gg</code> | 跳转到**文件第一行** |
| <code>G</code> | 跳转到**文件最后一行** |
| <code>nG</code> / <code>ngg</code> | 跳转到指定行（例：10G → 第 10 行） |
| <code>0</code> | 跳转到当前行**绝对行首** |
| <code>$</code> | 跳转到当前行**行尾** |

***

### 3. 删除 / 撤销 / 恢复

表格

| **快捷键** | **功能说明** |
| :--- | :--- |
| <code>x</code> | 删除光标所在字符 |
| <code>dd</code> | 删除**当前整行** |
| <code>ndd</code> | 删除连续 n 行（例：3dd → 删除 3 行） |
| <code>dG</code> | 删除光标所在行 → 文件末尾 |
| <code>u</code> | 撤销上一步操作（必备） |
| <code>U</code> | 撤销对当前行的所有修改 |

***

### 4. 显示 / 隐藏行号

表格

| **命令** | **功能说明** |
| :--- | :--- |
| <code>:set nu</code> | 显示行号 |
| <code>:set nonu</code> | 隐藏行号 |

***

### 5. 文本搜索

表格

| **快捷键** | **功能说明** |
| :--- | :--- |
| <code>/关键词</code> | **向下**搜索关键词 |
| <code>?关键词</code> | **向上**搜索关键词 |
| <code>n</code> | 查找**下一个**匹配内容 |
| <code>N</code> | 查找**上一个**匹配内容 |
| <code>:noh</code> | 临时取消搜索高亮 |

***

### 6. 文本替换（底线命令）

表格

| **命令** | **功能说明** |
| :--- | :--- |
| <code>:s/旧内容/新内容</code> | 替换当前行**第一个**匹配内容 |
| <code>:s/旧内容/新内容/g</code> | 替换当前行**所有**匹配内容 |
| <code>:n,ms/旧内容/新内容/g</code> | 替换 n~m 行的所有内容 |
| <code>:%s/旧内容/新内容/g</code> | 替换**整个文件**所有匹配内容 |

***

### 7. 批量列编辑（批量修改神器）

表格

| **步骤** | **操作** |
| :--- | :--- |
| 1 | <code>Ctrl + v</code> 进入**列编辑模式**，选中目标区域 |
| 2 | 按 <code>I</code>（大写 i）进入编辑 |
| 3 | 输入要添加的内容 |
| 4 | 按 <code>ESC</code>，批量生效 |

***

### 8. 帮助文档

表格

| **命令** | **功能说明** |
| :--- | :--- |
| <code>:help</code> | 打开 Vim 帮助文档 |
| <code>:help 快捷键</code> | 查看指定快捷键说明（例：<code>:help G</code>） |
| <code>:q</code> | 退出帮助文档 |

#### # 退出文件的恢复

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