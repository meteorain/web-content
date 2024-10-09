---
id: esG
title: 'helix 爽点与痛点'
title-en: 'helix editor'
pubDate: 2022-04-25T03:13:00.000Z
tags: ['editor', 'vim']
categories: ['shares']
---

> helix editor : https://helix-editor.com/

一个 rust 写的命令行 vim-like 的编辑器(上面👆有简单的演示视频就不截图了)。前几天在 ytb 上刷到的，尝试了几天有爽点也有痛点。

自称“后现代”，更像是调侃那些自称“现代”的编辑器。

所谓 vim-like ，键位继承自 Vim 和 Kakoune ，了解 Vim 可以直接上手，（熟悉的命令大部分也能用比如 :vs ）但操作逻辑又有不同，是即爽又痛：

比如想 dd ，V 的时候会很难受 ：在 helix 的按键是 x 选中行，而 d 可以替换 x 的功能。helix 中 w ，b 等会默认选择文本，因此 dw 要变成 wd 。

至于 Multiple selections ，之前没用过其他的就谈不了体验了。（类似 idea 里 option 下拉？，如果是的话那确实还挺好用的）

至于爽点：

对于 vscode 来说，直接命令行启动，不用 code . 等窗口弹出来。

对于 vim/nvim 来说，你不需要考虑 XXX-complete ，XXX-line ，fzf 还是 leaderf ，helix 提供了一揽子支持。

自带的 file-picker ，buffer-picker 的设计又很符合我的审美，不花里胡哨，简单够用。

lsp 、tree-sitter 支持良好，经常需要编辑的 json ，toml lsp 配置简单。试了试在 rust-analyzer 下写 rust ，居然还挺好用。（我还是选择 IDE🙃️

基本功能节制、够用、易用，但另一面是几乎没啥拓展性，在文档中没看到什么 extension/plugin 的字样。

对我来说，之前一般用 vscode 来编辑简单文本，helix 未来应该会是编辑简单文本的首选，但痛点也很痛，与 vim 键位的一些差别有时会精神分裂：

```txt
dd uu xd
```

于是又去 nvim 尝试配置 helix 样式的 file-picker ，buffer-picker （然后放弃了，编辑个文本又不是不能用

顺便问问大家有没有类似得编辑器？

-   Vim-support,not LIKE
-   Built-in language server support.
-   Syntax highlighting and code editing using Tree-sitter.
-   Built with XXX. No Electron. No VimScript. No JavaScript.
-   Runs in a terminal.
