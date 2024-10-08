---
title: postgis
---
## 空间方法

一些方法的组合

### 交换图形的 X，Y 坐标
```sql 'postgis.sql'
update point set geom = st_flipcoordinates(geom);
```

###  找到一组点的中心点

```sql get-centeroid.sql
SELECT ST_Centroid(ST_Collect(array_agg(v.geom)));
```


