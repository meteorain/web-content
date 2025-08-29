---
title: "二〇〇六年十一月二十一日，加速加速!!"
pubDate: 2006-11-21T14:58:00.000Z
categories: 
  - "freebsd"
---

εїз　 二〇〇六年十一月二十一日，星期二，天气：阴，气温：11℃－16℃，心情：( εїз

  

很久都没为我的FreeBSD写点儿什么了，只是最近和她相处得还算融洽，Windows已被我打入冷宫，除了想起LaTeX时才会去看看它。

中午在Google上搜到FB.Org的邮件列表，无意中看到了一个Ports：graphics/dri，原来我的ATI 9700显卡的3D加速功能是在这打开。

首先确定Xorg的版本大于6.9，安装graphics/dri  
_cd /usr/ports/graphics/dri && make install clean_

在/etc/X11/xorg.conf中插入  
_Load "dri"_  
到 Section "Module"内，再将  
_Section "DRI"  
Mode 0666  
EndSection_  
输入到文件的底部。

重新启动X Server，在一个console中执行“glxinfo | fgrep direct”，如果有如下输出就证明3D加速功能打开了：  
_direct rendering: Yes_

Have a good time :)

![](http://files.myopera.com/meteorain/images/logo_di-logout-bor-10.png)

FreeBSD下打开ATI Mobility Radeon 9700/9600显卡的3D加速功能
