---
id: bAt
title: 'TMS逆向到WMTS'
title-en: 'TMS to WMTS'
pubDate: 2023-03-17T00:55:54.000Z
description: 'tms to wms'
categories: ['shares']
tags: ['ogc', 'web tile map']
---

> 有一个 TMS 的瓦片数据源，需要“模拟”一个 WMTS 服务出来，需要怎么做？

这个情况，其实有现成的基础设施或者说轮子来解决，比如各个地图服务器等，.net生态也有 [tile-map-service-net5](https://github.com/apdevelop/tile-map-service-net5)这种开源工具，这个问题之所以是个问题在于两个限制条件。

1. 所用客户端不支持加载XYZ/TMS格式的数据，只能加载 WMS 和 WMTS 格式的数据。
2. 使用的数据是切好片的 TMS 结构的数据。
3. 客户端不方便依赖外部地图服务器。

## 模仿资源链接

一些我们熟悉的互联网地图，用的都是 XYZ 或者 TMS的方式，例如OSM、Google Map 和Mapbox 等等，从之前的栅格瓦片到如今矢量瓦片更为常见，想要用TMS “模仿” WMTS 的请求格式，需要先了解他们直接有啥不一样。

### XYZ（slippy map tilename）

-   256\*256 像素的图片
-   每个 Zoom 层级是一个文件夹，每个Column 是个子文件夹，每个瓦片是一个用 Row 命名的图片文件
-   格式类似`/zoom/x/y.png`
-   x 在 (`180°W ~ 180°E`)，y 在（`85.0511°N ~85.0551°S`），Y轴从顶部向下。

可以从[Openlayers TileDebug Example](https://openlayers.org/en/latest/examples/canvas-tiles.html)，看到一个简单的 XYZ 瓦片的示例。

### TMS

TMS的 Wiki [wikipedia](https://en.wikipedia.org/wiki/Tile_Map_Service)没涉及什么细节、[osgeo-specification](https://wiki.osgeo.org/wiki/Tile_Map_Service_Specification)
只描述了协议的一些应用细节。反倒是 [geoserver docs](https://www.geowebcache.org/docs/current/services/tms.html) 关于 TMS 的部分写的更务实一些。 TMS 是 WMTS 的前身，也是 OSGeo 制定的标准。

请求形如：
`http://host-name/tms/1.0.0/layer-name/0/0/0.png`

为了支持多种文件格式和空间参考系统，也可以指定多个参数：
`http://host-name/tms/1.0.0/layer-name@griset-id@format-extension/z/x/y`

TMS 标准的瓦片格网从左下角开始，Y轴从底部向上。有的地图服务器，例如geoserver，就支持一个额外的参数`flipY=true` 来翻转 Y 坐标，这样就可以兼容Y 轴从顶部向下的服务类型，比如 WMTS 和 XYZ。

![tms-grid](https://static.yuhang.ch/blog/tms-to-wmts/tms-grid.png)

### WMTS

WMTS 相较上述两个直观的协议，内容更复杂，支持的场景也更多。2010 年由[OGC](https://en.wikipedia.org/wiki/Open_Geospatial_Consortium)第一次公布。起始在此之前，1997年 Allan Doyle的论文“[Www mapping framework](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=Wap3yU4AAAAJ&citation_for_view=Wap3yU4AAAAJ:UeHWp8X0CEIC)” 之后，OGC就开始谋划网络地图相关标准的制定了。在 WMTS 之前，最早的，也是应用最广泛的网络地图服务标准是 [WMS](https://en.wikipedia.org/wiki/Web_Map_Service)。因为WMS每个请求是依据用户地图缩放级别和屏幕大小来组织地图响应，这些响应大小各异，在多核CPU还没那么普及的当年，这种按需实时生成地图的方式非常奢侈, 同时想要提升响应速度非常困难。于是有开发者开始尝试预先生成瓦片的方式，于是涌现出了许多方案，前面提到的 TMS 就是其中的一个，后面WMTS 应运而生，开始被广泛应用。 WMTS 支持键值对(kvp)和 Restful 的方式对请求参数编码。

KVP 形如：

```xml
<baseUrl>/layer=<full layer name>&style={style}&tilematrixset={TileMatrixSet}}&Service=WMTS&Request=GetTile&Version=1.0.0&Format=<imageFormat>&TileMatrix={TileMatrix}&TileCol={TileCol}&TileRow={TileRow}
```

Restful形如：

```xml
<baseUrl>/<full layer name>/{style}/{TileMatrixSet}/{TileMatrix}/{TileRow}/{TileCol}?format=<imageFormat>
```

由于是栅格瓦片，这里只需要找到 XYZ 与 瓦片矩阵和瓦片行列号的对应关系就好了。

-   TileMatrix
-   TileRow
-   TileCol

这里的瓦片行列号是从左上角开始的，Y 轴从顶部向下。

![wmts-grid](https://static.yuhang.ch/blog/tms-to-wmts/wmts-grid.png)

这样，就找到了 TMS 与 WMTS 的各参数对应关系，接下来就是如何把 TMS 转换成 WMTS 的请求了，如下：

-   TileRow = 2^zoom - 1 - y = (1 << zoom) - 1 - y
-   TileCol = x
-   TileMatrix = zoom

在不考虑其他空间参考的情况下，缩放层级对应瓦片矩阵，x对应瓦片列号，y取反（因为起始方向相反）。

## 模拟一个 WMTS Capabilities 描述文件

WMTS规范的要求，几乎可以说是细到头发丝，所以各个客户端，不管是Web端的 Openlayers ，还是桌面端的QGIS或Skyline等，都支持直接解析Capabilities 描述文件，然后根据描述文件的内容来选择图层、样式和空间参考，所以我们这里还要模拟一个 WMTS Capabilities 描述文件出来。

### Capabilities 描述文件的构成

一个WMTS Capabilities描述文件的例子可以在[opengis schema](http://schemas.opengis.net/wmts/1.0/wmtsGetCapabilities_response.xsd),[天地图山东](http://www.sdmap.gov.cn/tileservice/SDRasterPubMap?service=WMTS&request=Getcapabilities/1.0.0/wmtscapabilities.xml)找到。

Capabilities 描述文件的内容非常多，这里只列出一些重要的部分（忽略标题，联系方式等）：

```yaml
OperationsMetadata:
    - GetCapabilities >> 获取 Capabilities 描述文件的方式
    - GetTile >> 获取瓦片的方式

Contents:
    - Layer
      - boundingBox >> 图层的经纬度范围
      - Style
      - TileMatrixSetLink >> 图层支持的空间参考
      - TileMatrixSet >> 空间参考
      - TileMatrixSetLimits >> 空间参考的缩放层级范围
      - TileMatrixLimits >> 每个缩放层级的瓦片行列号范围
    - Style
    - TileMatrixSet
      - TileMatrix
```

关键的部分就是 boundingBox、TileMatrixSetLimits、TileMatrixLimits ，只需要根据图层的空间参考和缩放层级来计算出来就好了。

boundingBox 的计算比较简单，就是图层的经纬度范围，这里就不展开了。

TileMatrixSetLimits 的计算比较简单，就是图层的空间参考的缩放层级范围。

TileMatrixLimits 的计算比较复杂，可以只在图层范围比较小的时候再弄，全球地图就没必要了，需要根据图层的空间参考和缩放层级来计算出来，下面是一段伪代码（4326 到 3857）。

```python
FUNCTION GetTileRange(minLon, maxLon, minLat, maxLat, zoom, tile_size = 256)

minLonRad = minLon * PI / 180
maxLonRad = maxLon * PI / 180
minLatRad = minLat * PI / 180
maxLatRad = maxLat * PI / 180

tile_min_x = Floor((minLonRad + PI) / (2 * PI) * Pow(2, zoom))
tile_max_x = Floor((maxLonRad + PI) / (2 * PI) * Pow(2, zoom))
tile_min_y = Floor((PI - Log(Tan(minLatRad) + 1 / Cos(minLatRad))) / (2 * PI) * Pow(2, zoom))
tile_max_y = Floor((PI - Log(Tan(maxLatRad) + 1 / Cos(maxLatRad))) / (2 * PI) * Pow(2, zoom))

// adjust tile range based on tile size
tile_min_x = Floor((double)tile_min_x * tile_size / 256)
tile_max_x = Ceiling((double)tile_max_x * tile_size / 256)
tile_min_y = Floor((double)tile_min_y * tile_size / 256)
tile_max_y = Ceiling((double)tile_max_y * tile_size / 256)

RETURN  (tile_min_x, tile_max_x, tile_min_y, tile_max_y)
```

### 生成 WMTS Capabilities 描述文件

生成一个最小化的 WMTS Capabilities 描述文件，把上面的关键部分填充上，之后构造一个指向标准描述文件地址的的 Restful 风格的 URL。

## 后话

以上是一个简单的 TMS 转 WMTS 的思路，实际上还有很多细节需要考虑，比如空间参考的转换，缩放层级的转换，瓦片行列号的转换，瓦片的格式转换等等。
期间也踩了一些坑，感觉这部分更有意思。

第一部分，很快就参考 [tile-map-service-net5](https://github.com/apdevelop/tile-map-service-net5) 的思路，完成了 `y >> tileRow`的转换。代码在[WebMercator.cs](https://github.com/apdevelop/tile-map-service-net5/blob/227456463f0b69acf3e9350779c7f926ea96107f/Src/TileMapService/Utils/WebMercator.cs#L155) ，其实在StackOverflow上也有人问过这个问题，是有答案的，但我还是选择从软件里找答案，因为这样自己心里更踏实。

第二部分就很头大，首先模拟出了资源链接，构建了一个简单的 XML，但是在目标客户端上不能直接加载，很直接的想到了通过标准服务测试一下，然后哪来一个Capabilities 描述文件来修改。己想首先在比较熟悉的Openlayers上测试，然后再去修改Capabilities 描述文件。Openlayers的加载方式还是很灵活的，在没有Capabilities 描述文件的情况下，可以直接通过配置参数访问。

```javascript
// fetch the WMTS Capabilities parse to the capabilities
const options = optionsFromCapabilities(capabilities, {
    layer: 'nurc:Pk50095',
    matrixSet: 'EPSG:900913',
    format: 'image/png',
    style: 'default'
})
const wmts_layer = new TileLayer({
    opacity: 1,
    source: new WMTS(options)
})
```

很遗憾，瓦片没有加载上，甚至`networks`里没有发送请求。于是又去另一个WMTS相关的例子哪里，自定义了一个 TileGrid，然后把瓦片的行列号转换成了3857的行列号，这时候可以加载了。

```javascript
const projection = getProjection('EPSG:3857')
const projectionExtent = projection.getExtent()
const size = getWidth(projectionExtent) / 256
const resolutions = new Array(31)
const matrixIds = new Array(31)
for (let z = 0; z < 31; ++z) {
    // generate resolutions and matrixIds arrays for this WMTS
    resolutions[z] = size / Math.pow(2, z)
    matrixIds[z] = `EPSG:900913:${z}`
}
var wmtsTileGrid = new WMTSTileGrid({
    origin: getTopLeft(projectionExtent),
    resolutions: resolutions,
    matrixIds: matrixIds
})
```

在确认了是 TileGrid 的问题之后，首先将自己生成的TileGrid与Openlayers从Capabilities解析出来的TileGrid进行对比。发现自己生成的TileGrid有一些字段是空的，于是挨个测试，最后发现设置`fullTileRanges_`和`extent_`两个内部参数为空时，影像可以加载。

去翻OL源码，发现`fullTileRanges_`和`extent_`在 [getFullTileRange](https://github.com/openlayers/openlayers/blob/766bf3b710991e2f31fb4c68527261f8c8be8035/src/ol/tilegrid/TileGrid.js#L617)中被用到。

也就是说，当`fullTileRanges_`和`extent_`为空时，`getFullTileRange`会返回一个空的范围。

而`getFullTileRange`在[withinExtentAndZ](https://github.com/openlayers/openlayers/blob/b7d6f4404cad8b9acd56726cd51055af9f9ee2c0/src/ol/tilecoord.js#L83)中用到了，这里是用来判断当前可视区域是否有该图层的瓦片。
也就是说，当`fullTileRanges_`和`extent_`为空时，获取不到 `TileRange`，`withinExtentAndZ`会一直返回`true`，这样就会一直加载瓦片了，也就是加载成功的原因。

相反，从Capabilities解析出来的`fullTileRanges_`和`extent_`指向了错误的`TileRange`，导致`withinExtentAndZ`一直返回`false`，这样就不会加载瓦片了，也就是加载失败的原因。

终于找到了原因，但这里又被骗了。在[wmts.js](https://github.com/openlayers/openlayers/blob/b7d6f4404cad8b9acd56726cd51055af9f9ee2c0/src/ol/source/WMTS.js#L75)，构造函数上有一行注释:

```javascript
class WMTS extends TileImage {
    /**
     * @param {Options} options WMTS options.
     */
    constructor(options) {
        // TODO: add support for TileMatrixLimits
    }
}
```

这使我开始的时候误以为，`fullTileRanges_`和`extent_`是根据经纬度范围（boundingBox）计算出来的，而不是根据`TileMatrixLimits`算的，于是乎又检查了一遍boundingBox，确认无误后，才开始着手修改`TileMatrixLimits`。

开始的时候，以为 TileMatrixLimits 是每个层级的瓦片范围，而不是图层的范围，所以没注意到这个参数，这才走了弯路。

写在 2023 年，WMTS 已经不是一个新的协议了，OGC Tile API 已经成为正式标准了，自己对WMTS了解还是半瓶水，真是汗颜😅。
