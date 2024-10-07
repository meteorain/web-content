---
id: eYw
title: 'rio-tiler在windows中安装使用'
title-en: 'rio-tiler install in windows'
pubDate: 2020-12-09T06:19:26.000Z
isDraft: false
tags: ['python', 'cog']
categories: ['map']
---

之前用rio-tiler，参考rio-viz做了个可以针对多个影像同时提供WTMS服务的小应用，前段时间需要在一台windows服务器上部署，遇到一些问题，记录下来。

rio-tiler依赖于rasterio，rasterio依赖于gdal，在win上安装都有点费劲。

直接使用pip安装rio-tiler会在安装gdal及rasterio时报错，卡住。

最开始的时候在[Unofficial Windows Binaries for Python Extension Packages](https://www.lfd.uci.edu/~gohlke/pythonlibs/#rasterio)中找到了相对应版本的GDAL和rasterio，安装完成后依然有些问题，如rasterio引入时会报pyproj的CRS定义找不到的错误。

最开始使用conda的默认频道安装，在rio-tiler=2.0.0rc3版本中，依赖的rasterio≥1.1.7，而默认频道中没有该版本。使用conda-forge频道，发现版本比较全。

首先，我是用的miniconda3，体积更小，安装过程也没什么坑，新建环境，激活环境。

```bash
conda create -n rasterio python=3.7
conda activate rasterio
```

```bash
conda search rasterio -c conda-forge
Loading channels: done
# Name                       Version           Build  Channel
rasterio                      0.36.0  py27h43d01bd_1  pkgs/main
rasterio                      0.36.0  py35h49e1f75_1  pkgs/main
rasterio                      0.36.0  py36hb8ea33a_1  pkgs/main
rasterio                      1.0.13  py36h6bd7d87_0  pkgs/main
rasterio                      1.0.13  py37h6bd7d87_0  pkgs/main
rasterio                      1.0.18  py36h6bd7d87_0  pkgs/main
rasterio                      1.0.18  py37h6bd7d87_0  pkgs/main
rasterio                      1.0.21  py36h6bd7d87_0  pkgs/main
rasterio                      1.0.21  py37h6bd7d87_0  pkgs/main
rasterio                      1.0.23  py36hbf02ebe_0  conda-forge
rasterio                      1.0.24  py36h163c445_0  conda-forge
rasterio                      1.0.24  py37h163c445_0  conda-forge
rasterio                      1.0.25  py36h163c445_0  conda-forge
rasterio                      1.0.25  py37h163c445_0  conda-forge
rasterio                      1.0.25  py37he350917_1  conda-forge
rasterio                      1.0.26  py36h163c445_1  conda-forge
rasterio                      1.0.26  py37h163c445_1  conda-forge
rasterio                      1.0.27  py36h163c445_0  conda-forge
rasterio                      1.0.27  py37h163c445_0  conda-forge
rasterio                      1.0.28  py36h163c445_0  conda-forge
rasterio                      1.0.28  py36h163c445_1  conda-forge
rasterio                      1.0.28  py36h2617b1b_2  conda-forge
rasterio                      1.0.28  py37h163c445_0  conda-forge
rasterio                      1.0.28  py37h163c445_1  conda-forge
rasterio                      1.0.28  py37h2617b1b_2  conda-forge
rasterio                       1.1.0  py36h039b02d_0  pkgs/main
rasterio                       1.1.0  py36h2617b1b_0  conda-forge
rasterio                       1.1.0  py37h039b02d_0  pkgs/main
rasterio                       1.1.0  py37h2617b1b_0  conda-forge
rasterio                       1.1.1  py36h163c445_0  conda-forge
rasterio                       1.1.1  py36h2617b1b_0  conda-forge
rasterio                       1.1.1  py37h163c445_0  conda-forge
rasterio                       1.1.1  py37h2617b1b_0  conda-forge
rasterio                       1.1.1  py38h163c445_0  conda-forge
rasterio                       1.1.1  py38h2617b1b_0  conda-forge
rasterio                       1.1.2  py36h163c445_0  conda-forge
rasterio                       1.1.2  py37h163c445_0  conda-forge
rasterio                       1.1.2  py37h2617b1b_0  conda-forge
rasterio                       1.1.2  py38h163c445_0  conda-forge
rasterio                       1.1.3  py36h163c445_0  conda-forge
rasterio                       1.1.3  py36h2617b1b_0  conda-forge
rasterio                       1.1.3  py37h163c445_0  conda-forge
rasterio                       1.1.3  py37h2617b1b_0  conda-forge
rasterio                       1.1.3  py38h163c445_0  conda-forge
rasterio                       1.1.3  py38h2617b1b_0  conda-forge
rasterio                       1.1.4  py36h2409764_0  conda-forge
rasterio                       1.1.4  py36ha22ed69_0  conda-forge
rasterio                       1.1.4  py37h02db82b_0  conda-forge
rasterio                       1.1.4  py37h91b820b_0  conda-forge
rasterio                       1.1.4  py38h151dc71_0  conda-forge
rasterio                       1.1.4  py38hef609b1_0  conda-forge
rasterio                       1.1.5  py36h2409764_0  conda-forge
rasterio                       1.1.5  py36ha22ed69_0  conda-forge
rasterio                       1.1.5  py36ha22ed69_1  conda-forge
rasterio                       1.1.5  py37h02db82b_0  conda-forge
rasterio                       1.1.5  py37h02db82b_1  conda-forge
rasterio                       1.1.5  py37h91b820b_0  conda-forge
rasterio                       1.1.5  py38h151dc71_0  conda-forge
rasterio                       1.1.5  py38h151dc71_1  conda-forge
rasterio                       1.1.5  py38hef609b1_0  conda-forge
rasterio                       1.1.6  py36hc1acebe_0  conda-forge
rasterio                       1.1.6  py36hc1acebe_1  conda-forge
rasterio                       1.1.6  py37hce843d0_0  conda-forge
rasterio                       1.1.6  py37hce843d0_1  conda-forge
rasterio                       1.1.6  py38hf2e4ed7_0  conda-forge
rasterio                       1.1.6  py38hf2e4ed7_1  conda-forge
rasterio                       1.1.7  py36hc1acebe_0  conda-forge
rasterio                       1.1.7  py37hce843d0_0  conda-forge
rasterio                       1.1.7  py37hce843d0_1  conda-forge
rasterio                       1.1.7  py38hf2e4ed7_0  conda-forge
rasterio                       1.1.7  py38hf2e4ed7_1  conda-forge
rasterio                       1.1.7  py39h11aa1b2_1  conda-forge
rasterio                       1.1.8  py37hc4b0cd6_0  conda-forge
rasterio                       1.1.8  py38h5653988_0  conda-forge
rasterio                       1.1.8  py39hfec4536_0  conda-forge
```

之后直接指定版本安装

```bash
conda install rasterio=1.1.8
```

使用conda安装rasterio，顺便也解决了gdal的问题，而且安装过程中也没再遇到其他的问题。

到这一步，一般情况下可能会遇到rio-color装不上的问题，原因是有c++依赖，需要

> error: Microsoft Visual C++ 14.0 is required. Get it with "Microsoft Visual C++ Build Tools": [http://landinghub.visualstudio.com/visual-cpp-build-tools](http://landinghub.visualstudio.com/visual-cpp-build-tools)

这时候，按照提示，使用visual-cpp-build-tools将相关依赖装上即可（勾选以下两项）。

-   MSVC v142 – VS 2019 C++ x64/x86 生成工具
-   Windows 10 SDK (10.0.18362.0)

我在安装好依赖后，还遇到一个问题，大致是"rc.exe"找不到这个执行程序，经过搜索，发现在以下三个目录下都有“rc.exe”，我选择将x64的文件夹（系统为x64）加到了path环境变量里，问题解决。

```bash
C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\arm64\
C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x64\
C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x86\
```

至此，不出意外的话，使用以下命令就能将rio-tiler装好了。

```bash
pip install rio-tiler --pre
```
