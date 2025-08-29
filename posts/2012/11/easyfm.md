---
title: "在Symbian3上用移动网络收听CRI Easy FM轻松调频"
pubDate: 2012-11-08T08:28:08.000Z
categories: 
  - "live"
tags: 
  - "702t"
  - "cri"
  - "easyfm"
  - "symbian3"
---

发个技术贴，原来的小三(E63)进水坏了，最近入了一个Nokia 702T移动定制机，看上了它的小巧省电全键盘，兜里不能总揣着两个大手机吧……最重要的702T是TD 3G机，和我的10元CMWAP包月南神卡一起用简直是天衣无缝啊！！

既然小N用无限卡，那大M只能使用小N共享出来的无线热点上网了。这几天一直琢磨着直接用小N收听每天早晨必听的EasyFM飞鱼秀，可惜Symbian^3和S60v5软件匮乏，找了半天都没有找到可以成功收听轻松调频的网络广播软件或流媒体播放软件。昨天接入公司的无线热点，用Core Player突然可以打开轻松调频了，下班路上用移动网络又打不开，回家后尝试电信网络还是不行，百思不得其解。突然想起来公司的网络出口在美国，难道轻松调频在国内国外使用的是不同的流媒体服务器？！今天一试果然不同，服务器上做了均衡负载，国内的几台服务器WMServer版本是9.1.1.5000，用国外IP共Ping到六台机器，流媒体服务器的版本都是9.5.6001.18223。看来只要像电脑上一样给手机系统加一个hosts文件就行了。废话少说，下面转入正题。

在网上搜到S60v3以后的hosts文件是在C:\\private\\10000882\\，打开安全管家的文件管理，建一个名为hosts无扩展名的文件，内容如下：

> 65.32.34.100 enmms.chinabroadcast.cn 65.32.34.109 enmms.chinabroadcast.cn 81.52.170.31 enmms.chinabroadcast.cn 81.52.170.37 enmms.chinabroadcast.cn 209.18.41.95 enmms.chinabroadcast.cn 209.18.41.101 enmms.chinabroadcast.cn

将它复制到C:\\private\\10000882\\下，如果找不到10000882目录就自己建一个。然后用CorePlayer打开流媒体网址：mms://enmms.chinabroadcast.cn/fm91.5.wsx，接下来飞鱼秀还是摩天轮都可以随便听啦 ^ ^

技术宅拯救世界吧！ [![](https://blog.liuweinan.com/wp-content/uploads/2012/11/702T.jpg "702T")](https://blog.liuweinan.com/wp-content/uploads/2012/11/702T.jpg)
