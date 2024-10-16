---
title: Tech Stack
---
这个页面主要技术栈



```json title='astro.config.mjs' {3, 4, 11}
"dependencies": {  
  "@astrojs/check": "latest",  
  "@astrojs/starlight": "latest",  
  "d3": "latest",
  "astro": "latest",  
  "sharp": "latest",  
  "typescript": "latest"  
},  
"devDependencies": {  
  "@astrojs/starlight-docsearch": "^0.1.0",  
  "mdast-util-wiki-link": "latest",  
  "micromark-util-symbol": "latest"  
}

```


## why obsidian

我选择obsidian的原因可能只有这一个：

可能是笔记软件最好用的VIM键位绑定，相关插件也丰富。
- im-control 在`Normal`和`Insert`模式下切换IME。
- vimrc-support 支持自定义VIM快捷键。比如我定义`gd`在`wikilink`上直接打开。


## wikilink

使用 [remark-wiki-link]( https://github.com/datopian/portaljs/tree/main/packages/remark-wiki-link)  但由于 [issue#1059](https://github.com/datopian/portaljs/issues/1059)，自己做了些魔改。
## graph view

使用 [d3-force](https://d3js.org/d3-force)，主要解决的是 `backlinks` 的关联。

大致逻辑是：找到每个页面的包含的所有`wikilink`，借助之间的关系生成如下结构。

```typescript title='wikilink.ts'
interface GraphNode {  
    group: number,  
    parents: GraphNode[],  
    children: GraphNode[],  
    base?: boolean,  
    title?: string  
}
interface GraphLink {  
    source: string;  
    target: string;  
    value: number; 
}
```

根据一个`GraphNode[]`和`GraphLink[]` 绘制节点和连线。

之后再做一些显示优化，仿照的 [obsidian help](https://help.obsidian.md/Extending+Obsidian/Obsidian+URI) 的 Interactive Graph的样式和高亮行为。

完成的部分：
- 鼠标悬浮节点高亮，关联连接高亮。
- 节点可拖拽，支持任意的Zoom。

未实现的细节：
- 节点高亮时，Label会有段动画效果。
- ...

## short link

使用`cloudflare D1`做持久化，`vercel kv`做缓存。

写了个integration在每次构建的时候更新短链接。

```typescript title='integration-short.mts'
'astro:build:start': async (options: AstroServerStartOptions) => {  
    const allDocs = getPermalinks("src/content/docs", [  
        /\/.obsidian/,  
        /\/.DS_Store/,  
    ]).map(normalizeSlug)  
    const updateRedirect = // 与数据库对照，获取新增的页面。
    const updateResult = await updateDB(updateRedirect)  
    const all = // 所有的短链
    // 写到redirect中，以便在页面渲染的时候获取每个页面的短链
    writeFileSync('src/assets/redirect.json', JSON.stringify(all, null, 2))  
}
```

整个短链系统的可用性瓶颈就在于`cf workers`和`vercel kv`的免费额度，免费额度在就一切安好，免费额度没了就原地爆炸，考虑到访问人数有限，应该问题不大。

## edit and publish

关于发布，在[[obsidian]]中有写，通过command palette执行脚本提交`src/content`的内容，触发`cf pages`的自动构建。

编辑方面，通过魔改了[EditLink.astro](https://github.com/withastro/starlight/blob/main/packages/starlight/components/EditLink.astro) ，将编辑的链接替换为obsidian的 [URI Schema](https://help.obsidian.md/Extending+Obsidian/Obsidian+URI)。

这样点击编辑按钮通过 slug 检索 note ，直接打开指定的 note ，这样可以在本地调试的时候方便的打开指定的note。

```url
obsidian://open?vault=my%20vault&file=my%20note
```
