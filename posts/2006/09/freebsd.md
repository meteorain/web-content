---
title: "分享：在FreeBSD下玩蓝迪游戏大厅。"
pubDate: 2006-09-28T07:01:00.000Z
categories: 
  - "freebsd"
---

首先去蓝迪下载Linux版的游戏程序， 也可在这点击下载\[URL=http://www.bluedj.com/download/linner-3.0.1-full.tar.gz\]http://www.bluedj.com/download/linner-3.0.1-full.tar.gz\[/URL\] 下载回来后解压：# tar -xf linner-3.0.1-full.tar.gz 编辑文件：# ee BlueDJGames-3.0.1/install 将第一行的 #! /bin/bash 改成 #! /bin/sh 然后安装，它会把程序装在你的主目录中。 # ./BlueDJGames-3.0.1/install 回到你的主目录中把文件 ~/djgame2/startdjg 第一行的 #! /bin/bash 改成 #! /bin/sh 启动：# ~/djgame2/startdjg 如果在启动游戏时提示缺少库文件，就需要 # cd /usr/ports # make search name=linux 会出现很多。把自己需要的安装上就行了。 比如提示缺少libpng12.so就用关键字linux-png搜索。 (PS：记得要装linux\_base-fc4)
