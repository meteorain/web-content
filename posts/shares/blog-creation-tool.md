---
id: fRW
title: '博文创建工具'
title-en: 'Blog Creation Tool'
pubDate: 2023-07-26T08:16:21.386Z
tags: ['javascript']
categories: ['shares']
isDraft: false
---

## 简短来说

相比WordPress这种博客平台，使用Git-based/Markdown管理自己的内容，毫无疑问可控性更强，在各个平台迁移更灵活，但也增大了创建一篇博文的心智负担。虽然有`hugo new`这种命令行工具，但分类和标签还是需要手动编辑fontmatters。

之前也做过类似的尝试，用`fish shell`做了个简单的工具。

```fish showLineNumbers {1-3} title="functions/blog.fish"
function blog
    cd /dest/to/blog
    set -Ux BLOG_SLUG $argv[2]

    set c $argv[1]
    argparse t/tag -- $argv
    or return

    set md (string split '"' (hugo new posts/$c/$argv[2].md) -f2)
    sed -i '' 5s/\"\"/\"$c\"/ $md
    if set -ql _flag_tag
        sed -i '' 6s/\"\"/\"$argv[3]\"/ $md
    end
    echo $md
    open $md

end
```

思路依然是通过slug创建文章，预先把现有的博文分类列出来，然后通过Tab完成补全，比在frontmatters里改，方便一些。

```shell title="completes/blog.fish"
complete -c blog  -xa "comments  drafts  shares  stories  thoughs  thoughts  translations " -n '__fish_is_first_arg'
```

最近使用astro重构了博客，新增了`i18n`支持和短链等功能，需要副标题和Id等更多的抬头，这样就需要修改这个脚本，但是`fish`脚本维护起来有点费劲，所以决定用`node`脚本重构一下。

## 新的功能需求

-   可交互的命令行工具
-   通过在线翻译或者调用大模型的方式翻译标题
-   自己生成短链、根据英文标题生成slug
-   分类和标签通过现有的博文获取
-   图片管理

## 实施路径

### 实现可交互的命令行工具

选择技术栈：

-   [Inquirer.js](https://www.npmjs.com/package/inquirer)
-   [commander](https://www.npmjs.com/package/commander)

`inquirer` 用于交互命令，`commander` 用于解析命令行参数，初期考虑两个命令。

1. create 创建博文
2. upload 上传图片, 一个option `--file -f` 用于判断是上传文件还是直接上传剪贴板的文件。
3. activate 切换当前编辑的文章（类似conda环境的管理）
4. translate 翻译指定文章 `//TODO`

### 实现标题的自动翻译

经过实验，直接调用翻译效果很差，最后选择还是用openai-3.5-turbo(azure)，根据输入的标题先判断一下是中英文，然后给出相反的prompt，根据输入的标题完成翻译。

```json
{
    "messages": [
        {
            "role": "system",
            "content": "你是一个中英翻译助手，将下面这个博客文章的标题翻译成${dest}文。"
        },
        { "role": "user", "content": "${title}" }
    ]
}
```

这样，不管是中文还是英文标题，只需要输入一次就好，另一个交给AI。

### 实现短链的自动生成

考虑到自己的博文数量不会太大，只用三位区分大小写的字母来生成短链，这样可以保证短链的唯一性，而且不会太长。
使用[short-uuid](https://www.npmjs.com/package/short-uuid)包，生成uuid，但只取前三位，然后判断该Id是否已经存在，如果存在，重新生成。

```javascript
const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
const translator = uuid(chars)
let id = translator.new().slice(0, 3)
while (keyExits(id)) {
    id = translator.new().slice(0, 3)
}
```

短链最终使用Vercel的[redirects](https://vercel.com/docs/concepts/projects/project-configuration#redirect-object-definition)来实现，这样只须更改根目录下的vercel.json，重新部署即可。

```json
{
    "redirects": [{ "source": "/${id}", "destination": "/posts/${slug}" }]
}
```

### 图片管理

至于为什么不用现有的图床管理工具。

1. 无法与现有的工作流完全适配
2. 文件命名不符合自己的习惯

于是这里多做了这一步，在前面生成文章的时候，存一个全局的环境变量，这样图片管理的时候就在根据文章slug生成的文件夹下操作。

-   已有的图片文件保存到一个指定的目录下，通过命令上传到对象存储。
-   在剪贴板中的图片，首先通过[pngpaste](https://formulae.brew.sh/formula/pngpaste)保存到本地，然后再上传到对象存储。

最后通过`pbcopy`将获取图片的链接，直接送到剪贴板里，这样就可以直接粘贴到博文中了，就像下面这样。

```shell
blog upload test-jpeg
URL: https://static.yuhang.ch/blog/blog-creation-tool/test-jpeg.jpeg
```

对于一个在剪切板中的截图来说，在这种模式下，自己只需要给他想一个slug就好了，工具帮助你把他传到对象储存的指定目录下，然后把链接放到剪贴板里。

## 结尾

这篇文章来自这个工具。
