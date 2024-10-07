---
id: aoV
title: '使用openlayers的vector source loader'
title-en: 'Use openlayers vector source loader'
pubDate: 2022-05-30T05:58:54.000Z
isDraft: false
tags: ['gis', 'spatial']
categories: ['shares']
---

The vector source's `url` option is the first choice for loading vector data, but it doesn't work when a special post-processing or loading strategy required.

> https://openlayers.org/en/latest/apidoc/module-ol_source_Vector-VectorSource.html

## Loading strategy

First, we should learn about loading strategy in openlayers. there are 3 standard loading strategy in openlayers.

-   `all`: loading all features in a request.
-   `bbox`: loading features according to current view's extent and resolution.
-   `tile`: loading features based on a tile grid, difference between `all` or `bbox`, it takes a `TileGrid` as parameter.
    Obviously, the `bbox` is the most suitable one for loader, because when we accept the `all` strategy, the `url` option seems ok.

## Misunderstanding

Suppose such a feature, our data according to zoom level, when zoom changed, we have to request data again for current zoom level.

```javascript
...
loader:function(extent,resolution,projection){
	console.log("loading data in resolution",resolution);
	getData(resoluton).then(response=>{
		let features = source.getFormat().readFeatures(response);
		source.clear();
		source.addFeatures(features);
	})
}
...
```

The demo code, we expect loader triggered when view's zoom changed, clear previous features and load new features at new zoom. but when scroll the wheel, It is not the case.
The log message show the `loader` only triggered in the first few times, when we keep increasing the zoom level (resolution), `loader` is no longer triggered.
But why?
The extent is the main controller of the `loader`, when `loader(extent...)` called, the extent will add to the source's loaded extent ([code](https://github.com/openlayers/openlayers/blob/main/src/ol/source/Vector.js#L1015)in Vector.js), so ,if resolution changed but new extent is within loaded extent, `loader` will not be triggered.
It's clear now, the extents in the first few time contain follows, so when we keep increasing zoom level, the vector source doesn't invoke its loader unless the extent exceed loaded extent.
