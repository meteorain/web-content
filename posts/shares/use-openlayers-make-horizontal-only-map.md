---
id: aTR
title: '使用Openlayers制作一个水平滚动地图'
title-en: 'An horizontal-pan-only map in openlayers'
pubDate: 2022-05-12T03:42:02.000Z
tags: ['map']
categories: ['shares']
---

We usually use 2d map, actually, there are many avaliable web map library such like [openlayers](https://openlayers.org), [leaflet,](https://leafletjs.com) or [mapbox-gl-js](https://docs.mapbox.com/mapbox-gl-js/). I'll introduce a method to make a horizontal only map in openlayers.
To control map horizontal only, we have to hook these interactions: `pan`, `wheel scroll zoom`.
The default interaction openlayers use above can be found in follow link:

-   dragPan: [DragPan.js](https://github.com/openlayers/openlayers/blob/main/src/ol/interaction/DragPan.js)
-   mouseWheelZoom: [MouseWheelZoom.js](https://github.com/openlayers/openlayers/blob/main/src/ol/interaction/MouseWheelZoom.js)

## disable default interaction

The first step, we disable the default interaction of map.

```javascript
const map = new Map({
  ...
  interactions: defaultInteractions({
    dragPan: false,
    mouseWheelZoom: false,
    doubleClickZoom: false
  })
  ...
}
```

After apply this option, the map can't be controlled anymore, this what we suppose.

## hook interaction

### drag pan

We first create a custom pan interaction extented from `DragPan`.
The default interaction implement 3 method to handle `Drag Event`, `Pointer Up`, `Pointer Down` event. The `Drag Event` handler contains the [coordinate compute](https://github.com/openlayers/openlayers/blob/main/src/ol/interaction/DragPan.js#L102-L105). in other word, we need overide a new `handleDragEvent` .

```javascript
class Drag extends DragPan {
  constructor() {
    super();
    this.handleDragEvent = function (mapBrowserEvent) {
      ...
          const delta = [
            this.lastCentroid[0] - centroid[0],
            // centroid[1] - this.lastCentroid[1],
            0
          ];
     ...
    }
```

The centroid second element storage the y coordinate, thus ,we comment the line about y delta and set zero to it.

```javascript
const map = new Map({
...
interactions: defaultInteractions({
  dragPan: false,
  mouseWheelZoom: false,
  doubleClickZoom: false
}).extend([new Drag()]),
...
})
```

Add the custom drag interaction after `defaultInteractions` funtion, and our map now can be paned use mouse drag.

### mouse wheel zoom

According the drag pan section, we can easily found the coordinate compute line of the `MouseWheelZoom`.
They appearing at [L187-L189](https://github.com/openlayers/openlayers/blob/main/src/ol/interaction/MouseWheelZoom.js#L187-L189), do a little tweak in `handleEvent` method:

```javascript
const coordinate = mapBrowserEvent.coordinate
const horizontalCoordinate = [coordinate[0], 0]
this.lastAnchor_ = horizontalCoordinate
```

Same as dragPan, we add custom `MouseWheelZoom` interaction `Zoom` after default interactions.

```javascript
const map = new Map({
...
interactions: defaultInteractions({
  dragPan: false,
  mouseWheelZoom: false,
  doubleClickZoom: false
}).extend([new Drag(),new Zoom]),
...
})
```

Now our map can zoom use mouse wheel, and it only work in horizontal direction.
