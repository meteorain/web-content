:::note{.info}
English version was translated by AI.
:::

After review the `git` record, the first version of the blog based on `Astro` was roughly completed in mid-July last year, and it was patched up to the end of 2023 to form a rudimentary shape.

From `hello world` to the completion of several core sections, I have met many new friends in the process, and I have also had many new ideas about blogs and building blogs.

## Why Choose Astro

Actually, after saying goodbye to [Hugo](https://gohugo.io/), my first choice was [Nuxt](https://nuxt.com/), and I posted a post [Talk about the experience of writing a blog with nuxt](https://www.v2ex.com/t/952490) during the period. , And the reason for bidding farewell to [Hugo](https://gohugo.io/)
The reason is that although the template language maintains the efficiency of packaging, it is really too costly to modify it, and I didn’t find a good IDE plugin at that time, and I also thought about writing a [Hugo](https://gohugo.io/)
The theme always ends in failure.

In the post, the positive feedback [Nuxt](https://nuxt.com/) gave during development made me addicted, but there were also several problems:

1. In a pure and beautiful HTML page, when viewing the source code of the web page, it appears to be very messy under the packaging of various Vue components.
2. SPA application (it's not wrong but I don't like it very much).

In the end, I was bluffed by the [2023 Web Framework Performance Report](https://astro.build/blog/2023-web-framework-performance-report/) on the [Astro](https://astro.build/) page.

After simple use, there are not big problems with both documentation and IDE development experience, which is considered as formal pit entry. At that time, [Astro](https://astro.build/) was still in rapid iteration, which also catered to my desire to toss.

## Why Like Bearblog

A long time ago, when I was looking up information, I found this blogger [Mike - Line Simplification](https://bost.ocks.org/mike/simplify/), from which I stole the simple and elegant design of the page, and also learned D3.js, with great gains.

Afterwards, I saw bearblog from [Hacker News - Bear Blog – A privacy-first, fast blogging platform](https://news.ycombinator.com/item?id=32127363), and I fell in love with it at first sight. The previous Hugo blog was also based on bearblog's theme.

The simple page design and the original buttons of the webpage are directly hitting my heart, and the page has only content as much as possible, even the navigation bar is hidden, all from here.

## What to do for simplicity

This story, I also posted a post, [Feel that tailwindcss is not fragrant suddenly](https://www.v2ex.com/t/994735#reply59).

> A static website made with astro, the main content is text based.
When using tw, it is mainly to improve productivity, such as light/dark conversion, prose typesetting, etc.
Now that the functions are basically completed and want to do some optimization, I found that the index.html of a certain article:
The total size is ~ 78kb. After removing the tw declaration and class definition, the size is only ~ 24kb...
I tried to use purgecss, but the effect was not very obvious (maybe the posture was wrong)?

I want to enjoy the convenience of tailwindcss and don't want to pay such a big price for it (almost three times the size). Some V friends suggested [Unocss](https://unocss.dev/).

There is no big problem in migration, the usage is basically compatible with tailwindcss, and when I look back at myself, the size of a single page on the homepage is only `11kb`, I think it is worth it to make a tossing.

## My Favorite Multilingual Organization

When tossing over the part of multilingualism, I have been wavering. On the one hand, it is indeed a lot of work, and on the other hand, I also can't help but ask myself, are there really friends whose mother tongue is English reading my blog?

In the end, the longing and tossing myself defeated the "insecure" self, and this function was still made.

Although `Astro` now supports multiple languages, I still use third-party plugins [astro-i18n-aut](https://github.com/jlarmstrongiv/astro-i18n-aut).

The reason is that the official multilingual language, whether it is a component or content, needs to be organized in different directories, and I don't like this design.

The implementation of my multilingualism is roughly divided into two parts, the first is the multilingual text, stored in `YAML`. Although this requires another package `@rollup/plugin-yaml`, I really don't like `JSON`.

```yaml
layout:
    title: Chen Yuhang's Blog
    description: Chen Yuhang's personal blog, writing and drawing in places where no one can see. Less technology, more life. Here I learn and live, occasionally sharing my views on this world.
nav:
    posts: Essays
footer:
    home: Home
    rss: Subscribe
    timeline: Timeline
```

The second part is the content part. Considering that I will be lazy, I can't guarantee that all content has two languages. But I want to show all content regardless of the Chinese or English interface.

So I thought of such a design, using the extension suffix to distinguish the Chinese and English content, and the English content ends with `.en.md` or `.en.mdx`. If there is a specified content, it will be displayed. Otherwise, it will fallback to the Chinese content.

In the frontmatter, the English title is forced to be increased, so at least the homepage is all in English, which looks more comfortable.

## From pseudo-dynamic to true dynamic

The gossip section originated from [Twittering](https://www.giki.app/zh-CN), but later it was not so stable. I also wanted to hold the data in my own hands, so I made a similar thing on my own. [Live](https://github.com/yuhangch/live)

This time, I took advantage of the blog reconstruction and integrated this part of the content.

At the beginning, there are two solutions:

1. Like before, using leancloud to store data.
2. Make this part of the content in a static way and store it in a text file.

Finally, after a round of investigation, I found `cloudflare D1`. The good news is that the `Free Plan` can also be used, so I will no longer hesitate.

```sql
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

Use `cloudflare worker` to make a simple interface to fetch data.

On the client side, data is pulled through the SSR method and rendered in pages. The advantage of this is that the interface is not exposed to the outside world. The disadvantage is that if someone wants to brush a certain interface, directly brushing the web page, I have no choice but to.

## Based on TMDB movie review

Actually, I still want to use imdb or Douban to do it. On the one hand, I can reuse the client, and secondly, the content is very complete.

However, the anti-crawling of both interfaces is too strict, there is no angle at all. I have tried to access IMDB's `rating` export `csv` interface through the headless method, and it ended in failure. I had to choose TMDB.

The advantage of self-maintenance is that I can interact with my own `gossip`, and link my own movie reviews with specific `gossip` entries.

```sql
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

## Short chain

A function better than nothing, with form over substance, the general idea is as follows:

1. Add a hook at the stage of the site construction completion, and create a short chain for links that do not exist in the database.
2. Add [id] route to handle short links.

### uuid

The short chain is composed of a fixed prefix and three random numbers. For me, it is absolutely sufficient.

- The beginning of [b] stands for the link of the blog
- The beginning of [o] means the link to the draft

```typescript
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

### Persistence of short chains

I also hesitated for a while on this part. I used `vercel kv` directly. The monthly free quota is limited. I finally combined `cloudflare D1`:

```sql
DROP TABLE IF EXISTS shorts;
CREATE TABLE IF NOT EXISTS shorts (
  id text PRIMARY KEY NOT NULL,
  url text NOT NULL,
  created_at text NOT NULL,
  deleted_at text WITH NULL
);
CREATE INDEX idx_shorts_id ON shorts (id);
```

### Build a short link route

With everything in place, all you need to do is to make a routing to parse the short link.

```javascript
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

## Code block

It has gone through three twists and turns, and at the beginning I had my eye on [code-hike](https://codehike.org/docs/introduction). Unfortunately, due to [#255](https://github.com/code-hike/codehike/issues/255),
I haven't used it all the time.

Later, I referred to [Highlight a line on code block with Astro](https://sat0shi.dev/posts/highlight-line-on-codeblock-with-astro/) and migrated some styles. It's actually pretty good-looking, but I think my style processing is a bit complicated, I feel polluted by CSS.

Finally, I saw the solution of [starlight - expressive code ](https://starlight.astro.build/reference/configuration/#expressivecode), which solved almost all the pain points, and the style was copied without problems.

```typescript
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

// Plugin configuration
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

At the beginning, I used the component form to add prompts, but the problem was that just because of this component, I had to change `md` to `mdx`. I think the cost is a bit high. Afterwards, I still use [remark-directive](https://github.com/remarkjs/remark-directive).

:::note{.info}
Tips: This is a tip
:::

The way to use the code is as follows, and the usage is based on the example of `remark-directive`.

```markdown
:::note{.info}
Tips: This is a tip
:::
```

In addition, there is a blog post with embedded B station videos, so I also use `remark-directive` to implement it.

```javascript
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

## Why no comments



I saw a blogger with a big "Please contact by email" in the comment area, and I thought it was cool.

On the other hand, it is a problem that I haven’t figured out. First of all, I don’t like anonymous comments. But if I adopt the certification method, whether it is Github or other third-party logins, I can’t cover all readers anyway.

So if you have something to do, please send me an email ღ( ´･ᴗ･` ) It's also good


## From blog framework to personal skill

From using Astro to make a blog, from preferring to choosing it as the preferred static build tool, everything seems to happen naturally.

- Personal page [chenyuhang.com](https://chenyuhang.com)
- Collection of articles  [chenyuhang.cn](https://chenyuhang.cn)
- Draft book  [open.yuhang.ch](https://open.yuhang.ch)
