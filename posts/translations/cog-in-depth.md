---
id: bev
title: 'Cloud Optimized GeoTIFF (COG) 概述|简介'
title-en: 'Cloud Optimized GeoTIFF (COG) In Depth'
pubDate: 2020-02-24T03:36:49.000Z
isDraft: false
tags: ['cog', 'data format']
categories: ['translation']
---

## 概述

Cloud Optimized GeoTIFF (COG) 依赖两种辅助技术。

-   第一种是GeoTiff的存储能力：用特殊方式存储像素，而不仅仅是将未处理的像素直接存储起来。

-   第二种是HTTP Get 支持的范围请求，这种能力可以让client只请求文件中需要的那部分。

    前者的GeoTIFF存储方式，使后者的请求能方便的获取文件中需要被处理的那部分数据。

## GeoTIFF的组织方式

COG使用的两种主要的数据组织技术是瓦片和概览图，数据的压缩也使得数据在线传输变得更高效。

**瓦片切片**在影像中创建了内置了切片，而不是简单的运用数据的条纹，使用数据的条纹的话，想要获取指定的数据需要读取整个数据，当切片可以被在指定区域快速被获取到成为可能之后，同样的需求只需要访问数据的特定部分就可以了。

**概览图**创建了同个影像的向下采样的多个版本。向下采样的意思是当从一个原始影像'缩小'时，有很多细节消失掉了（当前的1个像素在原始影像中可能存在100个甚至1000个像素），同时它的数据量也更小。通常一个GeoTIFF会有多个概览图来匹配不同缩放等级。这使得服务端的响应变得更快，因为渲染时只需要返回这个特定的像素值即可，无需再来找出用哪个像素值来表示这1000个像素，但是这也会使得整个文件的体积变大。

通过数据的压缩，会使软件能够快速获取影像，通常会有更好的用户体验，但是使HTTP GET的范围请求的工作更有效率依然是非常重要的。

## HTTP Get 范围请求

HTTP的1.1版本引入了一个非常牛的功能：范围请求，在client请求服务端数据的GET请求时使用。如果服务端在response的header中有`Accept-Ranges: bytes`，这就说明数据中的bytes可以被客户端用任何想用的方式分块的请求。这通常也被称为"Byte Serving", 维基百科中有[文章](https://en.wikipedia.org/wiki/Byte_serving)详细解释了其工作原理。client可以从服务端请求需要的bytes，在Web领域，这被广泛地应用，例如视频服务，这样，client就不需要下载下整个文件就可以来操作它了。

范围请求是一个*可选*的字段，所以服务端并非必须要实现它。但是大多数的云服务提供商（Amazon, Google, Microsoft, OpenStack etc）的对象存储工具提供了这个选项。所以大多数的存储在云上的数据已经能够提供范围请求的服务。

## 整合

介绍过这两个技术之后，两个部分之间如何一起工作就变得很明显了。GeoTIFF中的瓦片和概览图以确定的结构存储在云端的文件中，这样，范围请求就能请求到文件中相关的部分了。

概览图在client想要渲染一个整幅影像的快视图时起作用，整个过程不需要下载每一个像素，这样一来，请求变成请求体积更小、预先创建的概览图。GeoTIFF文件特定的结构在支持HTTP范围请求的服务端就能使client轻松的获取整个文件中需要的那部分。

切片在一些整幅影像的局部需要被处理或者可视化的时候发挥作用。这可以是概览图的一部分，也可以是全分辨率的。需要注意的是，瓦片组织所有的相关数据的区域在文件中的相同位置，所以范围请求可以在需要的时候获取它。

如果GeoTIFF没有被用概览图和切片 ‘cloud optimized’ 过，同样也能进行一些远程操作，但是它们需要下载整个数据或者需要下载的数据量超过实际需求的的数据。

## 优势

越来越多的地理信息数据被迁移到了云端☁️，而且其中大多数被存储在基于云服务的对象存储中，比如 [S3](https://aws.amazon.com/s3/) or [Google Cloud Storage](https://cloud.google.com/storage/)，传统的GIS文件格式能够方便的存储在云端，但是对于提供Web地图瓦片服务或者执行快速的数据处理时，这些格式就不再保持高效了，通常需要将数据全部下载到另一个地方，之后再转换为更优化的格式或者读入内存中。

Cloud Optimized GeoTIFF 通过一些 [小技术](https://www.cogeo.org/in-depth.html)使得使得数据流更高效，使得基于云服务的地理数据工作流成为可能。在线影像平台比如 [Planet Platform](https://www.planet.com/explorer/) 和 [GBDX](https://platform.digitalglobe.com/gbdx/) 使用这种方式提供影像服务从而使影像处理非常快速。使用COG技术的软件能通过获取需要的数据的那部分来优化执行时间。

许多新的地理信息软件比如[GeoTrellis](http://geotrellis.io/), [Google Earth Engine](http://earthengine.google.com/) 和 [IDAHO](https://gbdxdocs.digitalglobe.com/docs/idaho-course) 同样在他们的软件架构中使用了COG的理念。每一个处理节点高速执行影像处理通过获取COG的部分的文件流。

对于现有的GeoTIFF标准的影响，不像引入一个新的文件格式。因为当前的软件不需要任何的修改也能够读取COG。它们不需要具备处理流文件的能力，只需要简单地将整个文件下载下来并且读取即可。

在云端提供Cloud Optimized GeoTIFF格式的文件能够帮助减少大量的文件拷贝。因为在线的软件能使用流文件而不需要保留其自己的副本，这就变得更加高效，也是当今一种通用的模式。此外，数据提供商无需提供多种格式的数据，因为老式软件和新式软件同样能读取这些数据。数据提供商只需要更新一个版本的数据，与此同时，无需多余的拷贝和下载，多种在线软件都能够同时使用它。

## QUICK START

### 前言

这个教程说明开发者如何使用和生产Cloud Optimized GeoTIFF。

### 读取

最简单的使用方式是使用GDAL的[VSI Curl](http://gdal.org/cpl__vsi_8h.html#a4f791960f2d86713d16e99e9c0c36258) 功能。可以阅读GDAL Wiki在[How to read it with GDAL](https://trac.osgeo.org/gdal/wiki/CloudOptimizedGeoTIFF#HowtoreaditwithGDAL)小节。当今大多数的地理信息软件都在使用GDAL作为依赖库，所以引入GDAL是读取COG功能的最快方式。

[Planet](http://planet.com/) 上，所有的数据都已经是COG格式，关于下载有一个小教程： [download part of an image](https://www.planet.com/docs/guides/quickstart-subarea/) 。 大多数教程只讲了关于Planet API 的使用方法，但也说明了GDAL Warp怎样从大的COG文件中提取单个工作区域。

### 创建

同样在GDAL wiki关于COG的页面，[How to generate it with GDAL](https://trac.osgeo.org/gdal/wiki/CloudOptimizedGeoTIFF#HowtogenerateitwithGDAL)。

```shell
$ gdal_translate in.tif out.tif -co TILED=YES -co COPY_SRC_OVERVIEWS=YES -co COMPRESS=DEFLATE
```

或者使用[rio-cogeo](https://github.com/cogeotiff/rio-cogeo) plugin:

```shell
$ rio cogeo create in.tif out.tif --cog-profile deflate
```

与多其他的地理信息软件应该也能够添加合适的略缩图和切片。

### 验证

使用rio-cogeo plugin:

```shell
$ rio cogeo validate test.tif
```

## 参考

https://www.cogeo.org/
