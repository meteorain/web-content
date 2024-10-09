---
id: cck
title: '图层控制几点问题 Openlayers[2]'
title-en: 'Issues with Layer Control in Openlayers [Part 2]'
pubDate: 2020-03-13T09:53:07.000Z
isDraft: false
tags: ['javascript', 'openlayers']
categories: ['map']
---

openlayers图层控制其实挺易用，使用图层visibility的getter和setter就能实现。但如果考虑组件的绑定，树状控制和同个图层不同属性的控制，问题就麻烦了。

### 图层与控制器的绑定

首先，怎么实现图层和组件控制器的键值绑定就很棘手，图层数量不多的情况还可以手动的添加图层，一一的将图层和开关绑定。但图层多起来显得就没那么优雅了，维护起来也相当麻烦。

我的解决方法是这样，首先对图层没有固定的id的问题，在加载图层时，为其添加name属性：

```js title="ol-example.js" {2-4}
let testLayer = new VectorLayer({
    visible: true,
    name: 'test-layer',
    source: testSource
})
```

有了唯一name之后，可以遍历地图中的图层，找到期望的图层，今而对其操作。

```js
map.getLayers().forEach((layer) => {
    let layerName = layer.values_.name;
		if (layerName !== undefined && layerName === "test-layer" {
        console.log(layer)
	}
});
```

这样只需将自定的图层名称与控制器绑定，就可以使用控制器的状态来同步图层的显示状态了。

### 树状控制器

树状控制器不像单一的控制，有父节点和子节点两种，父节点控制整个图层组的显示状态，子节点控制其单个图层，但也受父节点的控制。

一开始的时候我的想法是在id中设置标志符，区分子节点或是父节点，后来一想其实是没必要的，因为对于独立的几个图层来说，只要控制好子节点的状态，组件会自动更新父节点的状态。

例如，在我使用的antd组件中，每次check事件都会产生一个已选项目的id集合，这个集合也就标志着当前地图应该显示的图层，这时候我们只要把集合中包含的，显示状态为隐藏的图层激活显示，将集合中未包含的，显示状态为激活显示的图层隐藏即可，结合之前图层的遍历方法。

```js title="ol-example.js"
function setVisible(keyset) {
//			keyset = ['layer1','layer2',...]
        map.getLayers().forEach(function (layer) {
            let layerName = layer.values_.name;
//			把集合中包含的，显示状态为隐藏的图层激活显示
            if (layerName !== undefined && keyset.includes(layerName)) {
                if (!layer.getVisible()) {
                    layer.setVisible(true);
                }
//			将集合中未包含的，显示状态为激活显示的图层隐藏
            } else if (layerName !== undefined) {
                if (layer.getVisible()) {
                    layer.setVisible(false);
                }
            }
        });
    }
```

### 同一图层不同属性要素的控制

#### 对于矢量图层

采用的是更新style的方式，和在前文Openlayers[1]中提到的方法，给未设置显示的要素设置透明的symbol。

以字段 `name` 为例 ，`names`为需要显示要素的对应属性值的集合。

```js title="ol-example.js"
export function createStyleDisplay(names) {
    return function (feature) {
        const type = feature.get('name');
        const display = names.includes(type);
        if (display) {
            return new Style({
                stroke: new Stroke({
                    color: '#ffcc33',
                    width: 0
                }),
                image: new Icon({
                    //color: [113, 140, 0],
                    size: 0,
                    crossOrigin: 'anonymous',
                    //  对应类型的个性图标
                    src: `/label/${type}.png`
                })
            })
        } else {
  			//... 透明样式
        }
    }
}
```

#### 对于栅格图层

我使用的是GeoServer作为服务端，对于栅格瓦片图层，可以采用更新请求参数的方法。

使用cql_filter ,GeoServer有官方说明[[link]](https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html)：对于图层控制的需要，可使用以下语法：

```text
test_field IN ('type1','type2',...,'typeN')
```

对于一个当前显示的类型集合，应用图层改变示例如下：

```js title="ol-example.js"
export function doCQL(src, field_name, keys) {
    let ql = `${field_name} IN (`
    for (let k in keys) {
        ql += `'keys[k]', `
    }
    ql = ql.substr(0, ql.length - 2)
    ql += ')'
    let pms = src.getParams()
    pms.CQL_FILTER = ql
    src.updateParams(pms)
}
```

### 后话

在图层属性中添加name字段其实是无奈之举，没有getter，setter，只是强行从图层对象中获取。但没找到适应以下情况的方法：既可以将图层与唯一ID绑定，又可以通过ID直接获取图层，从而对其操作。

当前对图层操作中，需要当前地图的图层集合来选定某图层，并不是很高效。或许可以建一个hash表，key -> layer，有机会会在下个项目中尝试一下。希望大家如果有更好的解决方法的话，可以与在留言报分享😘。
