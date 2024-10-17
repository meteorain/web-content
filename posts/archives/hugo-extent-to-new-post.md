---
id: eBI
title: 更方便的创建hugo文章
title-en: Easier Article Creation for Hugo
pubDate: 2020-06-09T07:24:51.000Z
isDraft: true
tags:
  - shell
  - hugo
  - blog
categories:
  - shares
---

思路：

-   使用hugo的new命令的 --editer参数
-   新建指令默认输入--editor参数

以typora工具在macOS环境下为例，首先新建/usr/local/bin/typora，给予运行权限

```bash
#! /bin/bash
open -a typora $1
```

新建博文，快捷方式：

```bash
#! /bin/bash
blog_path=~/Codes/blog
cd $blog_path
hugo new --editor typora posts/$1.md
```

之后新建博客，只需：

```shell
blog content-title
```

此外，关于新建博文，自动添加tags和默认目录的问题：

修改$blog_path/archetypes/default.md即可

# 废弃

有这个想法很久了，开始的想法用`golang`写个小的`cli`工具，来更快的新建博文。

今天上手后感觉功能完全没必要，想到之前笔记上记得`sed`等工具，决定捡回来用一下。

## 痛点

日常使用，其实还好

```shell
$ j blog
$ hugo new posts/new-post.md
$ typora path/to/post.md
```

然后进入`Typora`

1. 修改自动生成的文章`Title`改成中文。
2. 从别的文章里复制`Tags`，`Categories`。
3. 填写`tags`、`categories`。

执行完以上步骤后才能开始写作，其过程也谈不上复杂，但总给人感觉还是有一部分重复劳动。

## 目标

我预期的目标

```shell
$ hugox new-post 新文章 随笔
```

然后弹出`Typora`,开始写作。

## 动手

逻辑很简单，使用脚本

1. 进入`blog`目录。
2. 新建`markdown`文档。
3. 将自动生成的英文`Title`改为自定义题目。
4. 新增`Tags`行。
5. 根据是否有归档名参数，新增`Categories`空行或指定归档名。
6. 使用`Typora`或`Code`打开指定文档。

## 传送门

[Hugox](https://gist.github.com/YuhangCh/fe251512391a4f590c582ea2d566f16a)
