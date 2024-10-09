---
id: fkP
title: 'GeoServer 多波段影像使用同个样式'
title-en: 'Using the Same Style for Multiple Bands in GeoServer'
pubDate: 2020-07-18T03:01:10.000Z
isDraft: false
tags: ['geoserver']
categories: ['shares']
---

## 引子

需求是有一幅海洋要素的数据，数据有12个`channel`，12个`channel`对应12个月份的数据。图层发布后，可以使用样式选择相应出channel，显示某月的数据。简单粗暴的方式是复制12份`style`，为了利于以后的维护(多半要自己维护)，遂想找一种方式类似“动态样式”的东西，可以从外部获取参数，使用同个`style`通过不同的参数选择不同的`channel`。

这里被自己的自以为是小坑了一下：生产环境用的`GeoServer`版本比较低，`2.11.x`。自己看文档的时候看的最新的文档，测试不行后，又看了`2.11`的文档，文档里虽然有类似的用法，但在`channal`选择的时候不可用。

所以这个方式只适用于较新的版本。

## 图层发布

图层发布，多`channel`的影像理论都可以。

## 设置样式

一般的波段融合的`channel` select是这种形式[^1]

[^1]: [GeoServer : RasterSymbolizer](https://docs.geoserver.org/stable/en/user/styling/sld/reference/rastersymbolizer.html)

```xml
<ChannelSelection>
  <RedChannel>
    <SourceChannelName>1</SourceChannelName>
  </RedChannel>
  <GreenChannel>
    <SourceChannelName>2</SourceChannelName>
  </GreenChannel>
  <BlueChannel>
    <SourceChannelName>3</SourceChannelName>
  </BlueChannel>
</ChannelSelection>
```

`style`中1，2，3 `channel`对应 `（R，G，B）`。

对于选择单`channel`显示，使用`Function`获取“环境变量”，替换默认值

```xml
<RasterSymbolizer>
  <Opacity>1.0</se:Opacity>
  <ChannelSelection>
    <GrayChannel>
      <SourceChannelName>
            <Function name="env">
             <ogc:Literal>m</ogc:Literal>
             <ogc:Literal>1</ogc:Literal>
          </ogc:Function>
      </SourceChannelName>
    </GrayChannel>
  </ChannelSelection>
</RasterSymbolizer>
```

其中，`channel` name 中包裹了一个Function对象，它在`env`中的`m`的值为空时候提供`1`作为默认值，若m非空，则使用`m`的值作为 `channel` name。

在`wms`请求中添加&env=m:2 即可选择编号为2的`channel`显示。

```http
http://localhost:8083/geoserver/wms?service=WMS&version=1.1.0&request=GetMap&layers=geosolutions:usa&styles=&bbox=-130.85168,20.7052,-62.0054,54.1141&width=768&height=372&srs=EPSG:4326&format=application/openlayers&env=m:2
```

以下是一个完整的样式：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/sld
http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd" version="1.0.0">
  <NamedLayer>
    <Name>saltsld</Name>
    <UserStyle>
      <Title>A raster style</Title>
      <FeatureTypeStyle>
        <Rule>
          <RasterSymbolizer>
            <Opacity>1.0</Opacity>
            <ChannelSelection>
                <GrayChannel>
                        <SourceChannelName><ogc:Function name="env">
                    <ogc:Literal>m</ogc:Literal>
                    <ogc:Literal>1</ogc:Literal>
            </ogc:Function></SourceChannelName>
                </GrayChannel>
        </ChannelSelection>
            <ColorMap>
           <ColorMapEntry color="#0000ff" quantity="28.0"/>
           <ColorMapEntry color="#009933" quantity="30.0"/>
           <ColorMapEntry color="#ff9900" quantity="32.0" />
           <ColorMapEntry color="#ff0000" quantity="34.0"/>
 </ColorMap>
          </RasterSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>


```

![9月](https://static.yuhang.ch/blog/gs-multiband-in-one-style_1.png)

![3月](https://static.yuhang.ch/blog/gs-multiband-in-one-style_2.png)

## 后话

最终因为生产环境版本不容易更新，还是自己复制了12\*2个样式。
