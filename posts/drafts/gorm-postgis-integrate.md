---
id: aYI
title: 'Gorm + Postgis 存取空间地理数据'
pubDate: 2019-12-10T12:24:46.000Z
isDraft: true
tags: ['openlayers']
Categories: ['笔记']
---

之前一直在写Spring Boot做一些小项目，用起来确实方便但总有种云里雾里的感觉。前段时间自己学了一段时间**golang**。尽管有些功能实现起来稍微有点繁琐，但自己能看库的源码来解决自己的一些需求，这种感觉在学习的过程中还挺棒的。

### 需求

-   [ ] PostgreSQL作为数据源。
-   [ ] 数据以PostGIS作为储存在GeoServer发布。
-   [ ] 前端对点增删改查，数据库和前端显示同步。

### 碰到的问题

#### 1.Model中Geom的类型选择。

因为考虑到之后要WKT和WKB的相互转换的问题，简单找了一下，选择了[github.com/paulmach/orb](github.com/paulmach/orb) 这个库，提供了WKT和WKB的解码。

最先类型选择了直接用`orb.Point`，很自然的扑街了。

因为Postgis对`geom` 字段的存取外面要套函数，例如：

```sql
st_geomfromewkt()
st_geomfromewkb()
```

既然直接使用类型不行（极可能是自己的使用方式不对，因为`orb.Point`理论上已经实现了`Scanner()`和`Value()`方法），第二个思路是直接跳过gorm的封装，使用pure sql直接插入算了。

这样就变得简单了，语句如下：

```go
err = db.Exec(fmt.Sprintf("update workareas set geom = ST_GeomFromEWKT('SRID=4326;%s') where id = %d",wkt.MarshalString(*point),wa.ID)).Error
```

这里因为想用到gorm的model特性和软删除，先将非`geom` 字段存入，然后继续执行更新，这中方法在未将表与geoserver链接时可用，但当执行发布图层后，表的geom字段自动设置为了`Not Null`,非常蛋疼，这个路子看来是不行了。

现在的问题主要是使用gorm的`Create()`方法无法跳过使用postgis存储geom字段的函数。看了一些方法都不行。于是自己连上数据库开始试。发现使用WKT存储，不加外置的方法可用，如下：

```sql
update workareas set geom = 'SRID=4326;POINT(111 55)' where id = 17
```

这种语法和下面的方式等效：

```sql
update workareas set geom = st_geomfromewkt('SRID=4326;POINT(111 55)') where id = 17
```

这就变得简单了，最终样例点的类型定义如下。

```go
type Model struct {
	ID        uint       `gorm:"primary_key" json:"id"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
	DeletedAt *time.Time `sql:"index" json:"deleted_at"`
}

type Workarea struct {
	Model
	Geom string
	Name string
}
```

这样就可以使用以下方法存储了：

```go
point := &orb.Point{lon, lat}
wa := model.Workarea{Name: "wode", Geom: fmt.Sprintf("SRID=4326;%s", wkt.MarshalString(*point))}
err := db.Create(&wa).Error
//异常处理省略
```

存储的问题解决，更新和删除就都没有问题了。

#### 2.前端遇到的问题

主要是Openlayers 的 `draw`和`modify`事件的相关操作。

新增点、修改后的点的坐标的获取

```javascript
//移动后的点的坐标获取，较为麻烦，是从event的object里找到的。
gModify.on(['modifyend'], function (e) {
    //被修改的feature
    let mFeature
    //这里获取的是source里所有的feature
    let features = e.features.getArray()
    //这就是移动后的坐标
    let tcr = e.target.lastPointerEvent_.coordinate
    //因为没找到方法直接获取修改后的feature
    //使用``Revision()``方法对修改多个后无法准确找到
    for (let i = 0; i < features.length; i++) {
        if (
            tcr[0] === features[i].getGeometry().getCoordinates()[0] &&
            tcr[1] === features[i].getGeometry().getCoordinates()[1]
        )
            mFeature = features[i]
    }
    //存进数据库的坐标要进行坐标转换
    //这里不用使用geo.transform(**)
    //因为这里geo其实是新画的feature的引用
    //直接坐标转换会改变新增点的feature因为坐标系的不同无法显示
    let tcr2 = transform(tcr, new Projection({ code: 'EPSG:3857' }), new Projection({ code: 'EPSG:4326' }))
    //注释里的方法是不对的
    //会使得画出的feature因为坐标不对无法正常显示
    //geo.transform(new Projection({code:"EPSG:4326"}),new Projection({code:"EPSG:3857"}))
    //let coords = geo.getCoordinates();
    //console.log(coords)

    console.log(mFeature.getId())
    //获取feature的id更新数据库数据
    const id = mFeature.getId().split('.')[1]
    //console.log(id)
    //这是个fetch请求
    modifyFeature('work-area', id, tcr2)
})
```

新增点无法立即修改

```javascript
//新增点的坐标获取
featureDraw.on(['drawend'], function (e) {
    let feature = e.feature
    let geo = feature.getGeometry()
    console.log(geo.getCoordinates())
    //存进数据库的坐标要进行坐标转换
    //这里不用使用geo.transform(**)
    //因为这里geo其实是新画的feature的引用
    //直接坐标转换会改变新增点的feature因为坐标系的不同无法显示
    let newPoint = transform(
        geo.getCoordinates(),
        new Projection({ code: 'EPSG:3857' }),
        new Projection({ code: 'EPSG:4326' })
    )
    //这里是fetch异步请求
    CreateFeature(layerName, newPoint)
        .then(function (r) {
            if (r.status === 404) {
                return false
            }
            console.log(`${pgUrlTable[layerName]}.${r.id}`)
            //请求成功，将请求返回的id赋给feature以便之后的修改和删除
            feature.setId(`${pgUrlTable[layerName]}.${r.id}`)
            return true
        })
        .then((bool) => {
            if (bool) console.log('ok')
            //请求失败，移除已经新增的feature
            else currentSrc.removeFeature(feature)
        })
})
```

以上就是结合gorm 与 postgis 实现点的前端动态更新小例子过程中遇到的一些小问题，做个记录。
