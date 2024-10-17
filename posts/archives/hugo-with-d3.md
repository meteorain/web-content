---
id: avb
title: 在hugo中集成d3.js/Observable Notebook
title-en: hugo integrate d3.js/Observable Notebook
pubDate: 2020-08-11T13:49:02.000Z
isDraft: true
tags:
  - hugo
  - blog
categories:
  - archive
---

> 以下图来自https://observablehq.com/@d3/zoom-to-bounding-box

我首先是看到了一篇博文[Line Simplify](https://bost.ocks.org/mike/simplify/)，本来以为是单纯的加载的图片。

在屏幕上点来点去发现地图并不是渲染的图片，而是直接渲染的svg，效果很棒，清晰度也好，所以想着是否可以移植到自己的博文中。

Inspect了一下，找到了工具是用的d3.js，顺藤摸瓜找到了强大的[observable notebook](https://observablehq.com/)。

谷歌了一下，是否有集成的可能性，Jeremy的一篇博文提出了用shortcode来集成的方法[^1]。

根据官方文档[^2]，可以方便的获取`Embed Code`，示例如下：

```html
<div id="observablehq-9415c34d"></div>
<script type="module">
    import { Runtime, Inspector } from 'https://cdn.jsdelivr.net/npm/@observablehq/runtime@4/dist/runtime.js'
    import define from 'https://api.observablehq.com/@gengtianuiowa/homework-2.js?v=3'
    const inspect = Inspector.into('#observablehq-9415c34d')
    new Runtime().module(define, (name) => (name === 'choropleth' ? inspect() : undefined))
</script>
```

理论上，将上述代码集成到页面即可完成显示。

## 新建shortcode模板

新建模板文件：在`layout/shortcodes/observablenotebook.html`或者`themes/yourtheme/layout/shortcodes/observablenotebook.html`

分析`Embed Code`,变量只需设`<div>`的`id`和渲染的代码块。

```html
<div id="observablehq-{{.Get 0}}"></div>
<script type="module">
    import { Runtime, Inspector } from 'https://cdn.jsdelivr.net/npm/@observablehq/runtime@4/dist/runtime.js'
    import define from '{{.Get 1}}'
    const inspect = Inspector.into('#observablehq-{{.Get 0}}')
    new Runtime().module(define, (name) => (name === 'chart' ? inspect() : undefined))
</script>
```

## 引入notebook.js文件

```markdown
---
title: '在hugo中集成d3.js/Observable Notebook'
pubDate: 2020-08-11T21:49:02+08:00
isDraft: false
tags: ['hugo']
categories: ['笔记']
---

> 以下图来自https://observablehq.com/@gengtianuiowa/homework-2
```

[^1]: [Embed an Observable Notebook in a Hugo site](https://kinson.io/post/embed-observable-notebook/)
[^2]: [Downloading and Embedding Notebooks](https://observablehq.com/@observablehq/downloading-and-embedding-notebooks)
