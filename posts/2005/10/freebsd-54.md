---
title: "FreeBSD 5.4中文安装手册,新手必看!!!"
pubDate: 2005-10-02T23:42:00.000Z
categories: 
  - "freebsd"
---

　　　　　FreeBSD 5.4中文安装手册,新手必看

　　　　　　　　　　　　　　　　　　　　　　by Meteorain (05.10.03)

玩FreeBSD已经三个多月了，现在基本能使用FB满足日常的需要。在刚开始学的时候的确像很多新手一样走了不少弯路，为了一个中文环境在Baidu上搜索几个小时，为了为Win共享文件，把samba整的死去活来……现在我写这篇文章是为了像我从前一样的新手，能更快更便捷的感受到FB为你带来的方便与舒适。前提是你的电脑不是很怪，不会不是少了光驱，不能上网，或者电脑太老等怪怪的毛病!

这是我本本的配置：Acer TravalMate 3200,　　COMBO,　　ATI Mobility Radeon 9700,　　Realtek AC'97 Audio。硬盘有四个分区，用windows的话说，第一个分区是Acer的系统恢复隐藏分区,格式未知,1Gb;第二个分区是主分区C,fat32,8Gb,安装了Win XP;第三个分区是逻辑分区d,fat32;第四个分区是逻辑分区e,fat32;第五个分区是为FB留的主分区（注：FreeBSD只能装在主分区中，分区时请把它分成主分区，另外，一块硬盘上最多只能有四个主分区，但逻辑分区可以多多），用PowerQuest PartitionMagic分的,7Gb。我认为7G可以满足你的需要，一般来说，少于5G是不可以的,除非你不打算安装桌面环境。用Unix的话说呢，Acer的系统恢复隐藏分区是ad0s1,Win XP的所在分区是ad0s2，FB的分区是ad0s3,（注：主分区的标号从1开如，一直到4，最多也只能有4个主分区，在这里，我的硬盘里只有3个主分区，所以只排到了3）。逻辑分区d是ad0s5,逻辑分区e是ad0s6（注：逻辑分区的标号从5开始，依次下排）。

从下载安装镜像文件开始，到新浪上看看，HTTP下载比较快，两张盘用200KB的速度两个小时就能下好了，下载下来后刻成光盘，如果没有刻录机也没关系，看看这篇文章：[http://njust.81088.net/freebsd/From\_hard\_install\_FB.txt](http://njust.81088.net/freebsd/From_hard_install_FB.txt)　　（《如何从硬盘安装FreeBSD》，文章里面需要的eum程序从这里下载，我给大家准备了一下：[http://meteorain.go.zhaoxi.net/emu.rar](http://meteorain.go.zhaoxi.net/emu.rar))。其实只要把系统的X Window环境（Gnome/KDE）装上就好了，其它的程序用Ports安装，不需要光盘。

其实安装FB系统是很简单的，需要很少的设置，15分钟就可以装好，这里我也不想多讲，详细的大家可以看中文手册，地址在这里：[http://www.freebsd.org.cn/snap/doc/zh\_CN.GB2312/books/handbook/](http://www.freebsd.org.cn/snap/doc/zh_CN.GB2312/books/handbook/)　　。这里声名一下，如果你没有方便快捷的网络，那就不要想用FB了，没有网络，FB就如废物一个，无法发挥她的的价值！安装系统时我只提几点，分配磁盘空间是很简单的，也没什么危险，不太容易把所有硬盘数据删掉。在我这，因为ad0s3是为FB准备的，所以我在ad0s3上按下D键，删除ad0s3分区,再按下C键，把删除ad0s3分区后所留下的空间分给FB，点三下回车就好。然后按Q键，退出分区。

然后会提示你是否安装多重引导管理程序，选第一个选项。  
下一步是使用Disklabel 创建分区，自动就好，自动分区按A键，然后按Q键退出（自动分区所默认的分区方案基本能满足大多数人的需要，如果你想改也可以，把安装手册看懂了自己分区就是了）。

然后是选择要安装的软件包，在这里最好选择ALL，就是把所以的软件包都安装上，这点对新手很重要，省着以后麻烦，现在还是全都安上吧，不太占空间的，几百兆而己。

最后是选择您要使用的安装介质，用光盘安装的请选择CD/DVD，如是从硬盘安装的，请选择DOS，我想没有从FTP安装的吧，那也太慢了，等死你！！！

下一步安装确认，如果你对你前面的设置不满意，或认为你的设置有危险，大可以这退出，干脆点直接按下Power键关机重启，在这不选择确定，你前面的设置都不会生效的^ ^。

安装后的配置也很简单，没什么好研究的，如不熟悉的话，多装几遍也就熟能生巧了。

  
配置网卡，一般第一个选项就是你的网卡了，除非你有双网卡。  
“ User Confirmation Requested  
Do you want to try IPv6 configuration of the interface?”  
IP4就足够用了，选NO。

“; User Confirmation Requested  
Do you want to try DHCP configuration of the interface?”  
DHCP随便了。

配置网络接口，Host是主机名，如我写的就是Meteorain.VerySoft，Domain是域名，我的例子就是VerySoft。IPv4 Gateway（IPv4网关），用ADSL猫的可能是192.168.1.1，按你的实际情况写。Name Server是DNS服务器地址，写上你的DNS，如是DNS自动分配的话可能默认已经给你填好了。IPv4 Address是你的电脑的IP号，随你怎么写了，我寝室里是组的局域网，ADSL猫连八口交换机，在我这，可以写192.168.1.120。子网掩码按实际情况写，一般是255.255.255.0。

是否做网关选NO;配置网络服务自己改配置文件，很简单;匿名 FTP也是自己改，一般用不到，选NO就好。NFS 服务器选NO，NFS 客户端选NO。配置系统终端里面，配置一下Saver就好，手册上写的很清楚。然后是配置时区，Linux 兼容性选YES，配置鼠标一般默认的就能用，什么Type,Port,Flags都不用改，直接选Enable测试一下就行了。对了，中文手册上安装的FB版本不是5.4，所以没有配置其他网络服务、配置 X Server、选择默认的桌面之类的选项，大家不要奇怪。安装软件包时，装上Cvsup,桌面随你喜欢了，光盘里自带了Gnome和KDE，我选了Gnome，因以它的简洁，快速和强大的定制能力（KDE的Fans表打我）。在这强调一下，像桌面环境这种大型的软件最好不要用Pors安装，慢不说，还经常自己配置不好。

添加用户/组，随你了；下一步是设置 root 密码，设个简单点的，电脑是自己日常生活用，又不是当服务器用。最后一步：退出安装，  
“ User Confirmation Requested  
Visit the general configuration menu for a chance to set any last  
options?

Yes \[ No \]”  
如果你对你前面的设置不满意，可以在这改一改。然后退出重启，用光盘安装的退出光盘。

  
第一次启动会慢些，耐心等待……

安装后的第一步，配置内核，可以让你的机器运行的更快速稳定些。这个新手不要害怕，其实是很简单的，十五分钟，几个命令的事。这个我也不多说，其实一个人一个样，我也说不过来，我给大家准备了一个通用些的内核配置文件，大家可以试试，如果自己动手丰衣足食更好，内核文件地址如下：[http://njust.81088.net/freebsd/meteorain](http://njust.81088.net/freebsd/meteorain)大家下到自己机器里就可以了。如果用windows下载到Win分区里，可以用mount命令挂上分区。使用方法如下：  
#cd /mnt  
#mkdir c  
#mkdir d  
#mkdir e  
#mkdir u  
以我的机器为例，如果下载到D盘里，(D:\\meteorain)，可以这么做，  
#mount\_msdosfs -L zh\_CN.eucCN /dev/ad0s5 /mnt/d  
#cp /mnt/d/meteorain /sys/i386/conf/  
如果下载到C盘里，(C:\\meteorain)，可以这么做，  
#mount\_msdosfs -L zh\_CN.eucCN /dev/ad0s1 /mnt/c  
#cp /mnt/c/meteorain /sys/i386/conf/  
如果下载到U盘里，(例如g:\\meteorain)，可以这么做，  
#mount\_msdosfs -L zh\_CN.eucCN /dev/da0 /mnt/u　　（也可能是#mount\_msdosfs -L zh\_CN.eucCN /dev/da0s1 /mnt/u）  
#cp /mnt/u/meteorain /sys/i386/conf/  
（注：nfts分区的mount命令是：#mount\_ntfs -C gbk /dev/ad0s1 /mnt/c，具体命令请大家自己去琢磨，可以从我的例子中举一反三。）  
接下来是编译内核，命令如下：  
#cd /sys/i386/conf  
#/usr/sbin/config meteorain  
#cd ../compile/meteorain  
#make depend  
五分钟的等待……  
#make  
十分钟的等待……  
#make install clean  
一分钟的等待……  
大功告成，重启，如果你的电脑启动失败，说明你的内核配置失败，这不在本文的说明范畴，请自行解决。不过大家不要怕了，绝大多数不会启动不成功，如果真是错了，编译内核时就不会通过的。启动失败的是绝少数，希望你不是其中的一个，如果是，那恭喜你中头彩了。  
重启后，配置c shell，下载[http://njust.81088.net/freebsd/cshrc](http://njust.81088.net/freebsd/cshrc)到硬盘中，如D:\\cshrc  
#mount\_msdosfs -L zh\_CN.eucCN /dev/ad0s5 /mnt/d（如果前面mount过D盘就不用执行这个命令了，会执行失败）  
#cp /mnt/d/cshrc ~/.cshrc（注意有个小点）  
直接修改它也行：  
#ee ~/.cshrc  
加入以下代码：  
setenv LANG zh\_CN.eucCN  
setenv LC\_LANG zh\_CN.eucCN  
setenv LC\_CTYPE zh\_CN.eucCN  
setenv LC\_MESSAGES zh\_CN.eucCN  
setenv LC\_TIME en\_US.ISO8859-1  
setenv XMODIFIERS @im=fcitx

升级Ports软件目录，在升级之前，请连上互联网，如果是在局域网中并且局域网连上了互联网，那插上网线就可以用了，有问题可以重启电脑后再试试（注：有一些问题如果实在解决不了，有个办法就是重新启动电脑，有时可以解决一些问题^ ^）,如果是ADSL直接拨号，可以这么做：  
编辑ppp配置文件，  
#ee /etc/ppp/ppp.conf  
删掉ppp.conf中的所有内容，  
复制这些代码（注意set前面有一个空格，必需！）

default:  
set log Phase tun command # you can add more detailed logging if you wish  
\# set ifaddr 10.0.0.1/0 10.0.0.2/0

adsl:  
set device PPPoE:bge0 # replace xl1 with your Ethernet device  
set authname F01234567　　#（你的ADSL帐号）  
set authkey 87654321　　#（你的ADSL密码）  
set dial  
set login  
add default HISADDR

保存退出，拨号，  
#ppp -ddial adsl  
看看网络接口状态  
#ifconfig  
一般情况下应该可以拨上了。

  
联网升级Ports软件目录，下载[http://njust.81088.net/freebsd/myports](http://njust.81088.net/freebsd/myports)到硬盘中，如D:\\myports  
#cp /mnt/d/myports ~/myports  
#cd  
#cvsup -g -L 2 myports  
这个步骤所需要的时间视网速而定，200Kb下行速度的ADSL一般十五分钟就好。等待ing...

  
安装中文宋体：mount上MS windows所在的分区，如C盘  
#mount\_msdosfs -L zh\_CN.eucCN /dev/ad0s1 /mnt/c  
#mkdir /usr/X11R6/lib/X11/fonts/TrueType/  
把Windows中fonts下的simsun.ttc复制到/usr/X11R6/lib/X11/fonts/TrueType/下  
如：#cd /usr/X11R6/lib/X11/fonts/TrueType  
#cp /mnt/c/WINDOWS/Fonts/simsun.ttc ./simsun.ttf

安装小企鹅输入法，如果你喜欢其它输入法可以去/usr/ports/chinese/下自己找。  
代码：#cd /usr/ports/chinese/fcitx  
#make install clean　　记得连上internet。

  
安装声卡，#ee /boot/defaults/loader.conf，把snd\_ich\_load="NO"　　# Intel ICH的"NO"改为"YES"，声卡即可发声了，当然，电脑需要重启。

配置X Window：  
代码：  
#cd /usr/X11R6/bin/  
\# xorgcfg -testmode  
剩下的自己来吧……结束后会生成/etc/X11/xorg.conf

我的ATI 9700在Xorg下可以使用，驱动选ATI就可以了。

让FB支持鼠标滚轮:  
编辑/etc/X11/xorg.conf  
#ee /etc/X11/xorg.conf  
把  
Section "InputDevice"  
Identifier "Mouse0"  
Driver "mouse"  
Option "Protocol" "Auto"  
Option "Emulate3Buttons"  
Option "Device" "/dev/sysmouse"  
EndSection  
改成：  
Section "InputDevice"  
Identifier"Mouse0"  
Driver "mouse"  
Option "Protocol" "Auto"  
Option "Emulate3Buttons"  
Option "Device" "/dev/sysmouse"  
Option "ZAxisMapping" "4 5"  
EndSection  
保存退出。

启动Gnome(或KDE)  
编辑启动文件。  
#ee ~/.xinitrc  
加入以下代码：  
xsetroot -solid black  
exec fcitx &  
exec gnome-session  
（如果是启动KDE请把exec gnome-session换成exec startkde）  
保存退出，键入startx命令后即可启动Gnome（或KDE）

  
美化Gnome，（KDE不在本文的讨论范畴）  
其实很简单，就是改一下字体，换个壁纸，下载个主题就好了。刚才我们不是把windows下的宋体simsun.ttc复制到FB下了吗！现在派上用场了。进入更改字体程序，把所有选项的字体都改成simsun，字号不用改，默认即可，可以考虑把平滑改成无，这样文字就清晰了……现在你的FB的文字就好看很多了，如果想让FB拥有更多字体，可以把Windows下的字体都复制到/usr/X11R6/lib/X11/fonts/TrueType/下。主题和壁纸可以来这：[http://www.gnome-look.org/](http://www.gnome-look.org/)。  
KDE的用户可以来这[http://www.kde-look.org/](http://www.kde-look.org/)。主题安装很简单，我就不多说了。

  
＃＃＃安装应用软件部分＃＃＃

在这我向大家介绍一些比较好的软件。

GIMP，图像设计软件，与PhotoShop一样好用，也一样强大。可以这样安装，时间比较长。  
#cd /usr/ports/graphics/gimp  
#make install clean

Gaim\_OpenQ，支持多种聊天协议，如OICQ,MSN,ICQ等等。  
#cd /usr/ports/net/gaim-openq  
#make install clean

JDK,这个很麻烦，强烈建议不要从Ports安装，太慢了，最好的办法是从Package安装  
下载jdk-1.4.2p7.tbz（自己去搜，[ftp.cn.freebsd.org](ftp://ftp.cn.freebsd.org/)上也有。）到/usr/ports/distfiles/下，然后  
#cd /usr/ports/distfiles/  
#pkg\_add jdk-1.4.2p7.tbz  
三分钟就搞定了，多...方便!!!!!!

  
EIOffice，永中Office，比OpenOffice更好的支持微软的Office系列文件，如Word，Excel，PowerPoint。  
安装比较麻烦，因为Ports中没有，所以要手动安装，方法如下：  
下载[http://njust.81088.net/freebsd/eioffice.shar](http://njust.81088.net/freebsd/eioffice.shar)到/usr/ports/chinese/  
下载永中Office2004，大家自己去找，把下载回来的EIOffice2004\_For\_Linux.tar.gz放到/usr/ports/distfiles/下  
#cd /usr/ports/chinese/  
#sh eioffice.shar  
#cd eioffice  
#make install clean  
三分钟就好了，因为永中Office是基于JAVA的，所以记得要装JDK。

  
XMMS，非常好用的MP3播放器。  
#cd /usr/ports/multimedia/xmms  
#make install clean  
#cd  
#ee .gtkrc.mine  
加入以下代码：  
style "gtk-default-zh-cn" {  
fontset = "-\*-simsun-medium-r-normal--12-\*-\*-\*-\*-\*-iso8859-1,\\  
\-\*-simsun-medium-r-normal--12-\*-\*-\*-\*-\*-gb2312.1980-0,\*-r-\*"  
}  
class "GtkWidget" style "gtk-default-zh-cn"  
保存退出  
ee ~/.xmms/config  
加入以下代码：  
playlist\_font="-misc-simsun-medium-r-normal-\*-\*-120-\*-\*-p-\*-gb2312.1980-0",\*-r-\*  
use\_fontsets=FALSE  
mainwin\_use\_xfont=FALSE  
mainwin\_font="-misc-simsun-medium-r-normal-\*-\*-120-\*-\*-p-\*-gb2312.1980-0"  
保存退出  
打开xmms，然后，\[首选项\]-->\[字体\]-->\[播放清单“浏览”\]-->\[filter\]-->charset中选择gb2312.1980-0，然后在播放清单选项中的"-misc-simsun-medium-r-normal-\*-\*-120-\*-\*-p-\*-gb2312.1980-0"的未尾加上\*-r-\*，最后变成："-misc-simsun-medium-r-normal-\*-\*-120-\*-\*-p-\*-gb2312.1980-0",\*-r-\*  
保存后退出。  
让XMMS支持WMA格式的文件：下载xmms-wma-1.0.4\_1.tbz到/usr/ports/distfiles/，然后pkg\_add xmms-wma-1.0.4\_1.tbz，你的XMMS可以支持Wma了!

  
mplayer,影视播放软件，几乎支持所有的音频视频格式，个人认为没有比它更好用的了，realplayer就是垃圾，不好用不说，界面也“贼”难看。  
安装方法如下：  
#cd /usr/ports/multimedia/win32-codecs  
#make install clean  
#cd /usr/ports/multimedia/mplayer  
#make WITH\_GTK2=yes WITH\_LANG=zh\_CN WITH\_FREETYPE=yes WITH\_REALPLAYER=yes install clean  
#rehash  
#mplayer  
字符界面用mplayer启动。图形界面用gmplayer命令启动,mplayer有很多很好看的皮肤，大家试试看。

  
OPERA，浏览器，支持Flash，相信我没错的^ ^  
cd /usr/ports/www/linux-opera　　（注意是www/linux-opera，www/opera是不支持Flash的。）  
make install clean  
安装后的美化，Tools->Preference->Advanced->Fonts，把所有的项目的字体都改成Simsun，Minimum font size 大小设成12。

  
gFTP，图形界面的FTP软件。  
#cd /usr/ports/ftp/gftp  
#make install clean

  
Samba，文件共享服务器。  
#cd /usr/ports/japanese/samba  
#make install clean  
#ee /etc/services  
加入以下代码：  
swat ; 901/tcp  
保存退出  
ee /etc/inetd.conf  
加入以下代码：  
netbios-ssn stream tcp nowait root /usr/local/sbin/smbd smbd  
netbios-ns dgram udp wait root /usr/local/sbin/nmbd nmbd  
swat stream tcp nowait root /usr/local/sbin/swat swat  
保存退出  
下载[http://njust.81088.net/freebsd/smb.conf](http://njust.81088.net/freebsd/smb.conf)  
cp smb.conf /etc/local/etc/（显示中文文件名。）  
重启！  
添加共享可以在浏览器中进入以下地址：[http://127.0.0.1:901](http://127.0.0.1:901/)，在这可以添加删除共享文件夹或进行一些其它的设置。

  
prozilla 多线程下载工具。  
安装目录用whereis prozilla寻找。

  
amule 电驴，很好用。  
安装目录用whereis amule寻找。

其它的我就不说了，余下的自己去研究吧，实践才能出真知，真理!  
  
\======================================  
  
我的一些配置文件我都打成压缩包，有兴趣的人可以下载回去看看。[http://njust.81088.net/freebsd/freebsd.rar](http://njust.81088.net/freebsd/freebsd.rar)

强烈向大家推荐FreeBSD论坛：[www.freebsdchina.org](http://www.freebsdchina.org/)，在这你可以找到很多问题的答案，也可以找到和你志同道合的朋友!

  
祝大家国庆快乐!!!  
　　　　　　　　　　　　　　　　　by Meteorain (05.10.03) Q:6062348

  
  
更清晰的版本请看这里：[http://www.freebsdchina.org/forum/viewtopic.php?p=137208](http://www.freebsdchina.org/forum/viewtopic.php?p=137208)  
  
![](http://storage.msn.com/x1pxOYwqu4SjF5Qg1gUIBUpErE3PO_qgMk_BhxbtR_RFx5Uk1A0dvQmFEXK1qhZKBwWT1Ta9hccjdqEd8HBrc-iuW4HvRvumuY3nypwOb8NTIxDopNl-nlg2Q5NAi0kLEwXvp3bIw3U381spG9eOuIPYpwwzJOcvGqC)
