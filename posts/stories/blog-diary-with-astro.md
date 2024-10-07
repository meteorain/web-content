---
id: dIr
title: "博客折腾日记"
title-en: "Blog diary with Astro"
pubDate: 2024-03-27T07:57:01.262Z
tags: ["astro"]
categories: ["stories"]
isDraft: false
---

翻了下`git`记录，基于`Astro`的第一版博客大致完成与去年七月中旬，修修补补到23年末算是有了雏形。

从`hello world`到几个核心栏目的完成，过程中自己新认识了很多朋友，交流中对博客和搭建博客这件事也有了很多新的想法。

## 为什么选择 Astro

其实告别[Hugo](https://gohugo.io/)之后，我的第一个选择是[Nuxt](https://nuxt.com/)，期间还发了个帖子[说说用 nuxt 写了个博客的体验](https://www.v2ex.com/t/952490)，而告别[Hugo](https://gohugo.io/)
的原因是，模板语言虽然保持了打包的高效，但魔改起来实在是太费心力了，而且那个时期自己也没找到好用的IDE插件，自己也动过从头写一个[Hugo](https://gohugo.io/)
主题的念头，每次都以失败告终。

帖子中，[Nuxt](https://nuxt.com/)在开发中给的正反馈开始让我欲罢不能，但也有几个问题：

1. 一个纯净美好的HTML页面，在各种Vue组件的包装下，查看网页源码的时候显得特别杂乱。
2. SPA应用（它没错但我不太喜欢）。

最后，被[Astro](https://astro.build/)页面的[2023 Web Framework Performance Report](https://astro.build/blog/2023-web-framework-performance-report/)唬住了。

简单使用后，不管是文档还是IDE的开发体验，都没啥大问题，算是正式入坑了，当时[Astro](https://astro.build/)还在快速迭代，也迎合了我折腾的欲望。

## 为什么喜欢 bearblog

很早之前，查资料找到这个博主[Mike - Line Simplification](https://bost.ocks.org/mike/simplify/)，从这既偷到了页面简洁素雅的设计，同时也学习到了D3.js，收获颇丰。

之后，从[Hacker News - Bear Blog – A privacy-first, fast blogging platform](https://news.ycombinator.com/item?id=32127363)上看到bearblog，就一眼爱上了，之前Hugo的博客也是基于bearblog的主题。

简洁的页面设计和网页原生的按钮直戳我心，页面尽量只有内容，甚至连导航栏都藏起来，都是源自这儿。

## 为了简洁做的事

这段故事，自己也发了个帖子，[突然感觉 tailwindcss 不香了](https://www.v2ex.com/t/994735#reply59)。

>用 astro 做了一个静态网站，内容主要是文字为主。
当时用 tw 的时候是提高生产力为主，比如 light/dark 转换，prose 排版等等。
现在功能基本完成，想做一些优化的时候，发现某篇文章的 index.html：
总大小 ～ 78kb ，移除 tw 声明的变量和 class 定义之后 大小只有～ 24kb 。。。
尝试用 purgecss ，作用不是很明显（可能姿势不对）？

自己既想使用tailwindcss的便捷性，又不想为此付出这么大的代价（接近三倍的体积），有V友建议了[Unocss](https://unocss.dev/)。

迁移起来没太大的问题，用法基本兼容tailwindcss，又回头看了下自己，首页单页面的体积只有`11kb`，此番折腾自己觉得还是值得的。

## 自己喜欢的多语言组织方式

在折腾多语言这一部分的时候，自己一直在动摇，一方面确实挺费劲的，另一方面，自己也忍不住的问自己，真的有英语为母语的朋友看我的博客吗？

最后，向往折腾的自己打败了“不自信”的自己，这个功能还是做出来了。

虽然目前`Astro`已经支持了多语言，但我还是在用第三方的插件[astro-i18n-aut](https://github.com/jlarmstrongiv/astro-i18n-aut)。

原因是，官方的多语言，不管是组件还是内容，都需要组织在不同的目录下，而我不喜欢这种设计。

我的多语言的实现大概分两个部分，一是多语言的文本，用`YAML`存储，虽然这样需要多安一个包 `@rollup/plugin-yaml`，但我实在不喜欢`JSON`。

```yaml title="zh.yml"
layout:
    title: 陈昱行博客
    description: 陈昱行的个人博客，在没人看到的地方写写画画。少些技术，多些生活。这里自己的学习生活，偶尔分享一下自己对这个世界的看法。
nav:
    posts: 随笔
footer:
    home: 首页
    rss: 订阅
    timeline: 时间线
```

第二部分，是内容的部分，考虑到自己会有懒的时候，所以无法保证所有的内容都有两种语言，而我想不管在中文还是英文界面都显示所有的内容。

于是想到了这么一种设计，用扩展后缀的方式区分中英文内容，英文内容以`.en.md`或者`.en.mdx`结尾，如果有指定的内容则显示，否则fallback回中文的内容。

在frontmatter里强制增加英文标题，这样可以保证至少首页做到都是英文，看起来舒服一些。

## 闲话从伪动态到真动态

闲话这个栏目，起源于[叽喳](https://www.giki.app/zh-CN)，后来迫于不太稳定，也想把数据掌握在自己手里，自己做了个类似的东西。[live](https://github.com/yuhangch/live)

这次借着博客重构的机会，把这部分内容也集成了进来。

开始之初，有两个方案：

1. 像之前一样，使用leancloud存储数据。
2. 将这部分内容也做成静态的方式，存在一个文本文件里。

最后调研了一圈，发现了`cloudflare D1`，好消息是`Free Plan`也可以用，于是也没再纠结。

```sql title="create-moment.sql"
DROP TABLE IF EXISTS moments;
CREATE TABLE IF NOT EXISTS moments (
  id integer PRIMARY KEY AUTOINCREMENT,
  body text NOT NULL,
  tags text WITH NULL,
  star integer NOT NULL default 0,
  created_at text NOT NULL
  deleted_at text WITH NULL
);
CREATE INDEX idx_moments_created_at ON moments (created_at);
```

使用`cloudflare worker`做了一个简单的接口，调取数据。

在客户端，通过SSR的方式拉取数据，并分页渲染，这样好处是不对外暴露接口，坏处是如果有人想刷某个接口，直接刷该网页我也没啥办法。

## 基于TMDB的影视评价

其实本意还是想通过，imdb或者豆瓣来做，一方面可以复用客户端，二是内容很全。

奈何两者的接口反爬都太严格了，完全没有角度，自己还尝试了通过headless的方式访问IMDB的`rating`导出`csv`的接口，以失败告终，值得选择了TMDB。

自己维护的好处是可以与自己的`闲话`互动，将自己的影视评论与具体的`闲话`条目联动。

```sql title="create-review.sql"
DROP TABLE IF EXISTS reviews;
CREATE TABLE IF NOT EXISTS reviews (
	id integer PRIMARY KEY AUTOINCREMENT,
	imdb_id text NOT NULL,
	title text NOT NULL,
	title_en text NOT NULL,
	media_type text NOT NULL,
	imdb_rating real NOT NULL,
	rating real NOT NULL,
	release_date text NOT NULL,
	rated_date text NOT NULL,
	moments_id integer NOT NULL,
	created_at text NOT NULL,
	deleted_at text WITH NULL
);
```

## 短链

聊胜于无的功能，形式大于内容，大致思路如下：

1. 在站点构建完成阶段，加入一段hook，为数据库中不存在的链接新建短链。
2. 增加[id]路由，处理短链。

### uuid

短链由一个固定前缀和三位随机数构成，对自己来说完全是够用的。

- [b] 开头代表是博客的链接
- [o] 开头代表是草稿本的链接

```typescript title="uuid.ts"
import shortUUID from "short-uuid";

const characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
const short3 = shortUUID(characters);

export function getOpenUUID(exist: string[]) {
    // generate a v4 uuid, subtract the first 3 characters, and then convert to base62
    let uuid = 'o' + short3.generate().slice(0, 3);
    while (exist.includes(uuid)) {
        uuid = 'o' + short3.generate().slice(0, 3);
    }
    return uuid
}
```

### 短链持久化

这部分也犹豫了好久，直接用`vercel kv`，每月免费额度有限，最终还是结合了`cloudflare D1`:

```sql title="create-short.sql"
DROP TABLE IF EXISTS shorts;
CREATE TABLE IF NOT EXISTS shorts (
  id text PRIMARY KEY NOT NULL,
  url text NOT NULL,
  created_at text NOT NULL,
  deleted_at text WITH NULL
);
CREATE INDEX idx_shorts_id ON shorts (id);
```

### 构建短链路由

完事具备，只需要做一个解析短链的路由即可大功告成。

```javascript title="[id].js"
import { createClient, kv as prodKV } from '@vercel/kv'

const notFound = new Response(null, {
    status: 404,
    statusText: 'Not found'
})
const getLink = async (id) => {
    const kv = DEV
        ? createClient({
            url: KV_REST_API_URL,
            token: KV_REST_API_TOKEN
        })
        : prodKV
    const cached = await kv.get(id)
    if (cached) {
        return cached
    }
    const apiURL = `api.blog.com`
    const headers = {
        Authorization: `Bearer ${BLOG_API_SECRET}`
    }
    const res = await fetch(apiURL, { headers })
    if (res.status === 404) {
        return null
    }
    const json = await res.json()
    const url = json.url
    await kv.set(id, url)
    return url
}
export const GET = async ({ params, redirect }) => {
    const { id } = params
    const type = id?.slice(0, 1)
    if (!type || !['o', 'b'].includes(type)) {
        return notFound
    }
    const link = await getLink(id)
    if (!link) {
        return notFound
    }
    return redirect(link, 308)
}
```

## 代码块

也是一波三折，最开始看上了[code-hike](https://codehike.org/docs/introduction)，无奈因为[#255](https://github.com/code-hike/codehike/issues/255)，
一直没用上。

后来参考[Highlight a line on code block with Astro](https://sat0shi.dev/posts/highlight-line-on-codeblock-with-astro/)，迁移了部分样式，其实也挺好看的，不过自己处理的样式有点复杂，感觉污染了CSS。

最后看到[starlight - expressive code ](https://starlight.astro.build/reference/configuration/#expressivecode)的解决方案，解决了几乎所有的痛点，样式复制过来也没问题。

```typescript title="astro.config.mts"
import expressiveCode from 'astro-expressive-code'
import {ExpressiveCodeTheme} from '@expressive-code/core'
import {readFileSync} from 'fs'
import {parse} from 'jsonc-parser'

const nightOwlDark = new ExpressiveCodeTheme(
    parse(readFileSync('./src/styles/expressive-code/night-owl-dark.jsonc', 'utf-8'))
)
const nightOwlLight = new ExpressiveCodeTheme(
    parse(readFileSync('./src/styles/expressive-code/night-owl-light.jsonc', 'utf-8'))
)

// 插件配置
···
expressiveCode({
    themes: [nightOwlDark, nightOwlLight],
    themeCssSelector: (theme) => {
        return '.' + theme.type
    }
})
···
```


## component or directive?

最开始的时候，采用的是组件的形式增加提示，但问题是仅仅因为这个组件，就需要将`md`变为`mdx`，觉得成本有点高，后面还是改为使用[remark-directive](https://github.com/remarkjs/remark-directive)。

:::note{.info}
提示：这是个提示
:::

使用的方式代码如下，使用方法参考`remark-directive`的例子即可。

```markdown title="notification.md"
:::note{.info}
提示：这是个提示
:::
```

除此之外，有篇博客有嵌入B站视频的需求，于是也用`remark-directive`来实现了。

```javascript title="bilibili.js"
export function RDBilibiliPlugin() {
    return (tree, file) => {
        visit(tree, function (node) {
            if (
                node.type === 'containerDirective' ||
                node.type === 'leafDirective'
            ) {
                if (node.name !== 'bilibili') return
                const data = node.data || (node.data = {})
                const attributes = node.attributes || {}
                const bvid = attributes.id
                if (!bvid) {
                    file.fail('Unexpected missing `id` on `youtube` directive', node)
                }
                data.hName = 'iframe'
                //<iframe src="//player.bilibili.com/player.html?bvid=BV1Zh411M7P7&autoplay=0" width="100%" allowfullscreen> </iframe>
                data.hProperties = {
                    src: `//player.bilibili.com/player.html?bvid=${bvid}&autoplay=0`,
                    width: '100%',
                    height: 400,
                    aspectRatio: '16 / 9',
                    // fit height
                    class: 'm-auto',
                    // height: 400,
                    frameBorder: 0,
                    allow: 'picture-in-picture',
                    allowFullScreen: true
                }
            }
        })
    }
}
```

## 为什么没有评论



看到一个博主，评论区是大大的 "请通过邮件联系" 的字，自己觉得很酷。

另一方面，是一个没想明白的问题，首先我不喜欢匿名评论，但如果采用认证的方式，不管是Github还是其他的第三方登录，还是仍然无法囊括所有的读者。

所以有事还是给我发邮件吧ღ( ´･ᴗ･` )比心


## 由博客框架到一项个人技能

从为了做博客接触Astro以来，从偏爱到现在选择它作为首选的静态构建工具，一切仿佛自然而然发生。

- 个人页 [chenyuhang.com](https://chenyuhang.com)
- 文集  [chenyuhang.cn](https://chenyuhang.cn)
- 草稿本  [open.yuhang.ch](https://open.yuhang.ch)










