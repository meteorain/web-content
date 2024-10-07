---
id: fSn
title: 'OL Search - 一个 Openlayers API 快速访问拓展'
title-en: 'OL Search - A Quick Access Extension for Openlayers API'
pubDate: 2022-06-16T02:00:29.000Z
isDraft: false
summary: ' '
tags: ['openlayers', 'spatial']
categories: ['shares']
---

## 为什么

openlayers的API文档内容是极好的，然而使用起来却一言难尽。

一般的查api的方式有以下两种：

-   搜索引擎 👉 openlayers + 关键字 👉 打开指定链接
-   打开api doc页面 👉 搜索关键字 👉 通过搜索结果到达指定结果

## OL Search [^1]

OL Search是一款浏览器拓展（目前只上架了Edge add-ons[^2]），可以通过浏览器地址栏快捷搜索openlayers api，步骤如下：

1. <kbd>control</kbd>+<kbd>L</kbd> 或者 <kbd>cmd</kbd>+<kbd>L</kbd> 进入搜索栏。
2. 输入`ol`关键字，<kbd>tab</kbd> 或者 <kbd>space</kbd> 进入 OL Search。
3. 输入目标api （方法、成员变量、触发器等）的关键字，选择指定链接直达。

## 实现

主要分三步：

### 解析api文档

> https://openlayers.org/en/latest/apidoc/navigation.tmpl.html

文档的导航栏部分镶嵌了一个HTML，来自上面的地址。
这里本来有两个思路。
一是通过修改openlayers自己的 `api build`的脚本生成一组与上述HTML内容一致的JSON格式的api文档信息。
但考虑到两点：

-   后期维护问题，如果这么做，每个小版本更新需要重新更新插件。-插件体积变大。
    另一种是直接解析上面的HTML的导航信息文件，这里遇到了问题，因为在浏览器的插件中，`backgroud.js`里无法访问`DOMParser`对象，这里走了弯路，最开始曲线救国，通过`popup`(点击拓展图标显示的小弹窗)加载数据。这种方式缺点很明显，用户安装完插件后无法直接使用，需要点击拓展图标等待索引文件初始化后才能使用。之后找到了一个纯`javascript`的DOM解析库，才解决了该问题。

### 模糊搜索

最开始的时候采用硬搜索，自己使用起来都不满意，因为打字偶尔的typo不可避免，因此模糊搜索应该是刚需。
这里参考了[mdn-search](https://github.com/hanguokai/mdn-search) 的做法，引入了`fuse.js` 。也做了一些多关键字的增强。
比如在搜索`readFeatures`这个方法的时候，各种格式例如`EsriJSON`、`KML`、`WKT`等都有`readFeatures`方法，而默认搜索结果`WKT`在后面，假如我想找`WKT`的`readFeatures`的话就会影响体验。
通过`fuse.js`的`search.$or`，实现了多关键字的复合搜索。
这样只需要输入`readFeatures wkt` 就可以将包含`WKT`的结果提到第一个候选。

### 干掉默认推荐

在监听地址栏`omnibox`内容变化事件的回调函数中，浏览器默认会在你给的推荐结果前面默认加一条默认推荐，其内容是你键入的内容，指向的地址是你拓展的地址加上该内容。默认行为即`File not found`。
这部分思路来自[rust-search-extension](https://github.com/huhu/rust-search-extension) ，首先根据用户的键入内容结合搜索结果，将默认推荐设置为原本的第二条结果（真正搜索结果的第一顺位），之后在用户回车后判断该选项是否是默认建议，如果是，则指向真正搜索结果的第一顺位的地址。

## 最后

希望该工具给重度使用openlayers api doc的各位同仁带来帮助。

[^1]: OL Search repo: https://github.com/yuhangch/ol-search
[^2]: Edge Add-ons: https://microsoftedge.microsoft.com/addons/detail/ol-search/feooodhgjmplabaneabphdnbljlelgka
