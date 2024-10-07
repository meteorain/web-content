---
id: auP
title: '那些相见恨晚的小技巧'
pubDate: 2020-04-11T05:07:37.000Z
isDraft: true
tags: ['OS X', 'Shell', 'Softwares']
categories: ['技巧']
---

# MAC相关

## 相同应用不同窗口切换

-   ⌘ + _`_

## Spotlight Search

-   ⌘ + ␣

这是默认按键，之前不经常用是因为习惯了快捷键要左手同时按。

突发奇想左手`cmd`加右手`space`就顺手多了。如果有一样之前只左手快捷键的有点启发。

## Safari将标签页pin住

将标签页向左拖拽，会将标签页pin住，只展示图标，适合经常用的标签页。

# GIT相关

## stash\commit\push 一步执行

```bash
git config --global alias.cmp '!f() { git add -A && git commit -m "$@" && git push; }; f'
```
