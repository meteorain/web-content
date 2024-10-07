---
id: ass
title: 'Javascript Shapefile/kml/geojson 转换'
title-en: 'Javascript Shapefile/kml/geojson Conversion'
pubDate: 2021-01-16T06:23:44.000Z
isDraft: false
showTableOfContents: true
tags: ['spatial', 'gis', 'data format']
categories: ['shares']
---

## 三个需求

-   geojson -> shapefile 并下载
-   geojson -> kml 并下载
-   Shapefile (zipped) -> geojson

## geojson构建工具

这里选择常用的Javascript的几何计算类库[[turfjs/turf]](https://github.com/Turfjs/turf)

使用cdn引入：

```html
<script src="https://unpkg.com/@turf/turf/turf.min.js"></script>
<script>
    var bbox = turf.bbox(features)
</script>
```

或者：

```shell
npm install @turf/turf
```

```javascript
import * as turf from '@turf/turf'
```

以折线为例：

```javascript
let line_string = turf.lineString(
    [
        [-24, 63, 1],
        [-23, 60, 2],
        [-25, 65, 3],
        [-20, 69, 4]
    ],
    { name: 'line 1' }
)
let geojson_object = turf.featureCollection([line_string])
```

打印对象如下：

```json
{
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "properties": {
                "name": "line 1"
            },
            "geometry": {
                "type": "LineString",
                "coordinates": [
                    [-24, 63, 1],
                    [-23, 60, 2],
                    [-25, 65, 3],
                    [-20, 69, 4]
                ]
            }
        }
    ]
}
```

## geojson 转 shapefile

使用[[mapbox/shp-write]](https://github.com/mapbox/shp-write)包

使用npm安装：

```shell
npm install --save shp-write
```

或者直接引入，之后直接使用shpwrite变量：

```html
<script src='https://unpkg.com/shp-write@latest/shpwrite.js'>

```

API很直观：

```javascript
import shpwrite from 'shp-write'

// (optional) set names for feature types and zipped folder
var options = {
    folder: 'myshapes',
    types: {
        point: 'mypoints',
        polygon: 'mypolygons',
        line: 'mylines'
    }
}
// a GeoJSON bridge for features
shpwrite.download(geojson_object, options)
```

这里需注意一个问题，因为该包长时间没人维护，目前使用会出现以下问题：

```shell
Error: This method has been removed in JSZip 3.0, please check the upgrade guide.
```

参考[[issue 48]](https://github.com/mapbox/shp-write/issues/48)，将原shpwrite.js文件修改如下:

```javascript
// ##### replace this:
var generateOptions = { compression: 'STORE' }

if (!process.browser) {
    generateOptions.type = 'nodebuffer'
}

return zip.generate(generateOptions)

// ##### with this:
var generateOptions = { compression: 'STORE', type: 'base64' }

if (!process.browser) {
    generateOptions.type = 'nodebuffer'
}

return zip.generateAsync(generateOptions)

// ##### and this:
module.exports = function (gj, options) {
    var content = zip(gj, options)
    location.href = 'data:application/zip;base64,' + content
}

// ##### with this:
module.exports = function (gj, options) {
    zip(gj, options).then(function (content) {
        location.href = 'data:application/zip;base64,' + content
    })
}
```

## geojson转kml

使用[[mapbox/tokml]](https://github.com/mapbox/tokml)包和[[eligray/FileSaver]](https://github.com/eligrey/FileSaver.js)文件下载包

npm安装：

```shell
npm install --save tokml file-saver
```

使用cdn引入：

```html
<script src='https://unpkg.com/tokml@0.4.0/tokml.js'>
<script src='https://unpkg.com/file-saver@2.0.0-rc.2/dist/FileSaver.js'>

```

使用如下：

```javascript
var kml_doc = tokml(geojson_object, {
    documentName: 'doc name',
    documentDescription: 'doc description'
})
var file_name = 'polyline'
var kml_file = new File([kml_doc], `${file_name}.kml`, {
    type: 'text/xml;charset=utf-8'
})
// FileSaver.saveAs()
saveAs(kml_file)
```

## Shapefile(zipped) 转 geojson

使用[[calvinmetcalf/shapefile-js]](https://github.com/calvinmetcalf/shapefile-js)包，以cdn引入为例

```html
<script src="https://unpkg.com/shpjs@latest/dist/shp.js">
```

```html
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>shapefile to geojson</title>
    </head>

    <input type="file" id="upload" />
    <script src="https://unpkg.com/shpjs@latest/dist/shp.js"></script>

    <body>
        <script>
            var Upload = document.getElementById('upload')
            Upload.onchange = function () {
                var fileList = Upload.files
                if (fileList.length < 1) {
                    return
                }
                var zip_file = fileList[0]
                zip_file.arrayBuffer().then((file) => {
                    shp(file).then((geojson) => {
                        console.log(geojson)
                    })
                })
            }
        </script>
    </body>
</html>
```
