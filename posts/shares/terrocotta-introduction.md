---
id: bat
title: 'Terrocotta :一个轻量的瓦片服务'
title-en: 'Terrocotta :A lightweight tile server'
pubDate: 2020-03-01T08:35:30.000Z
isDraft: false
tags: ['python', 'cog', 'map server']
categories: ['map']
---

## Introduction

最近一直想找一个轻量的影像瓦片的服务端，上周一直在看[@Vincent Sarago](https://github.com/vincentsarago) 基于其自己一套工具 [rio-tiler]() , [lambda-proxy]() 的的瓦片服务的provider，前前后后看了衍生的几个项目，包括[lambda-tiler](https://github.com/vincentsarago/lambda-tiler)，[landsat-tiler](https://github.com/mapbox/landsat-tiler)，[rio-viz](https://github.com/vincentsarago/rio-viz)等等，经过简单的测试，感觉前两个工具均需要借助lambda才能发挥正常的性能，第三个应用框架用的tornado，考虑了并发问题，但是个单机应用，“移植”起来工程量挺大的，自己试了试放弃了。在单节点的情况下，请求阻塞问题非常严重，自己试着换了几个应用和服务端的组合，都没太大的改善。另外在单节点情况下，这种每个请求都要重新访问一次数据的方式并不经济。

简单的应用不行，在COG详情页看到了，[Geotrellis](https://github.com/locationtech/geotrellis)项目，框架用scala实现的，在projects里发现了一个和需求很相近的实验项目，clone下来运行，并不能成功，好像是应用入口有变化，失败了，自己懒的上手改（不知道怎么改），就想着去quick start 里找个小例子，跑个tiles服务应该挺容易的（呸），scala在国内的新手使用体验是真的难，甚至比golang还难，构建工具sbt从maven中心仓库拉文件，乌龟似的启动速度，自己找了那寥寥无几的几篇更换国内源的方法，中间一度想吐🤮，最后换了华为云的源终于能接受了，sbt.build的诡异语法，硬着头皮坚持到io影像，最新版本的api根本跟docs大不一样了，自己照着api东改西改，又被魔鬼般的implict参数坑了十几分钟后：

```shell
$ rm -rf repos/geotrellis-test ~/.sbt
$ brew rmtree sbt
```

溜了溜了。

## Terracotta

Github的feed真是个好东西，替我推荐了好多有用的玩意，[Terracotta](https://github.com/DHI-GRAS/terracotta/)也是（太难打了，就叫他陶罐吧）。官方描述如下：

> Terracotta is a pure Python tile server that runs as a WSGI app on a dedicated webserver or as a serverless app on AWS Lambda. It is built on a modern Python 3.6 stack, powered by awesome open-source software such as [Flask](http://flask.pocoo.org/), [Zappa](https://github.com/Miserlou/Zappa), and [Rasterio](https://github.com/mapbox/rasterio).

提供传统部署和Lambda两种方式，轻量，pure python，都挺符合我的口味，“技术栈”也相对新。

陶罐与同样基于函数计算的lambda-tiler相比，不管是从结构来讲，或是理解起来，都是后者更简单。后者的整个流程非常直接，基于COG的portion请求特性和GDAL的[VFS](https://gdal.org/user/virtual_file_systems.html)(Virtual File Systems)，不管你的数据在哪，多大，只要告诉我它数据的本地地址或者HTTP地址，它就可以实时的拉取切片。在lambda的环境下，这种方式在性能上不会有太大问题。但对于在国内使用、部署有两个问题。

-   AWS在国内严重水土不服，给国内使用Lambda造成障碍，Aliyun等国内厂商也有函数计算的服务，但还不太成熟，移植proxy等成本也很高。
-   一些open access 的数据比如[Landsat 8](https://registry.opendata.aws/landsat-8/) ，[Sentinel-2](https://registry.opendata.aws/sentinel-2/)都托管在S3对象存储上，使用Lambda切片很大程度依赖在AWS各部件上快速访问，但如果在国内提供服务在访问速度上会受很大的影响。

当然，陶罐也是推荐部署在Lambda函数上的，的确，这种方式非常适合动态切片服务，但比Lambda-tiler，它加了一个易用、可靠的头文件的“缓存机制”。

在使用rio-tiler想实现一个可以快速部署在单机上、支持少用户，低请求的动态切片服务时，就曾经想在内存中对同源的数据的头文件缓存下来，因为每一张瓦片都要请求一次源数据获取头文件，在单机环境来看是很浪费的，当时自己的想法有建一个dict，根据数据源地址存储头文件或者建一个sqlite数据库来存储，试了建个dict的方式，但效果并不明显。

而陶罐在业务流程设计上就强制加入了这一点，这使得他在新增数据时会有一个预处理的过程，这比起直接处理有一个延后，但正所谓磨刀不误砍柴工，不得不说，这比起传统的预切片可要快出不少。

除此之外，对数据cog化，头文件注入等流程，陶罐都有很好的api支持。

## Quick Start

试用非常简单，先切换到使用的环境，然后

```shell
$ pip install -U pip
$ pip install terracotta
```

查看一下版本

```shell
$ terracotta --version
$ terracotta, version 0.5.3.dev20+gd3e3da1
```

进入存放tif的目标文件夹，以cog格式对影像进行优化。

```shell
$ terracotta optimize-rasters *.tif -o optimized/
```

然后将希望serve的影像根据模式匹配存进sqlite数据库文件。

这里想吐槽一下这个功能，开始的时候我以为是一般的正则匹配，搞半天发现是{}的简单匹配，还不能不使用匹配，醉醉哒。

```shell
$ terracotta ingest optimized/LB8_{date}_{band}.tif -o test.sqlite
```

注入数据库完成后，启动服务

```shell
$ terracotta serve -d test.sqlite
```

服务默认在:5000启动，还提供了Web UI，需要另行启动，开另一个session：

```shell
$ terracotta connect localhost:5000
```

这样Web UI也就启动了。这样可以在提示的地址中访问到了。

## Deployment

没看lambda的部署方式，因为大致和lambda-tiler方式差不多，因为国内aws访问半身不遂，移植到阿里云，腾讯云的serverless的成本又太高了，所以才放弃了这种方式。

传统的部署方式如下：

我是在centos的云主机上部署的，和docs里的大同小异。

首先新建环境，安装软件和依赖。

```shell
$ conda create --name gunicorn
$ source activate gunicorn
$ pip install cython
$ git clone https://github.com/DHI-GRAS/terracotta.git
$ cd /path/to/terracotta
$ pip install -e .
$ pip install gunicorn
```

准备数据，例子假设影像文件存放在`/mnt/data/rasters/`

```shell
$ terracotta optimize-rasters /mnt/data/rasters/*.tif -o /mnt/data/optimized-rasters
$ terracotta ingest /mnt/data/optimized-rasters/{name}.tif -o /mnt/data/terracotta.sqlite
```

新建服务，这里自己踩了两个坑，官方例子使用的是nginx反向代理到sock的方式，自己试了多个方法，没成功，也不想深入了解了。

```nginx
server {
    listen 80;
    server_name VM_IP;

    location / {
        include proxy_params;
        proxy_pass http://unix:/mnt/data/terracotta.sock;
    }
}
```

另一个是，应用入口里的入口 版本更新过，service里的和上下文的不一样，修改之后如下

```ini
[Unit]
Description=Gunicorn instance to serve Terracotta
After=network.target

[Service]
User=root
WorkingDirectory=/mnt/data
Environment="PATH=/root/.conda/envs/gunicorn/bin"
Environment="TC_DRIVER_PATH=/mnt/data/terracotta.sqlite"
ExecStart=/root/.conda/envs/gunicorn/bin/gunicorn \
            --workers 3 --bind 0.0.0.0:5000  -m 007 terracotta.server.app:app

[Install]
WantedBy=multi-user.target
```

另外一个地方，使用"0.0.0.0"，使外网可以访问。

官方解释如下：

> -   Absolute path to Gunicorn executable
> -   Number of workers to spawn (2 \* cores + 1 is recommended)
> -   Binding to a unix socket file `terracotta.sock` in the working directory
> -   Dotted path to the WSGI entry point, which consists of the path to the python module containing the main Flask app and the app object: `terracotta.server.app:app`

服务里需要指定Gunicorn的执行路径，设置workers数量，绑定socket file，指定应用入口。

设置开机启动，启动服务。

```shell
$ sudo systemctl start terracotta
$ sudo systemctl enable terracotta
$ sudo systemctl restart terracotta
```

这样就能看到服务的表述了。

```shell
$ curl localhost:5000/swagger.json
```

![](https://static.yuhang.ch/blog/terrocotta-introduction_1.png)

当然，也可以用terracotta自带的client来看一下效果：

```shell
$ terracotta connect localhost:5000
```

## Workflow

对与头文件存储方式的选择，sqlite自然是更方便，但mysql的灵活性和稳定性更高了，在线数据可以实现远程注入。

这里碰到点问题，driver的create方法新建失败，自己没看出问题在哪，就从driver里找出表定义，手动新建所需表。

```python
from typing import Tuple

import terracotta as tc
import pymysql


# driver = tc.get_driver("mysql://root:password@ip-address:3306/tilesbox'")
key_names = ('type', 'date', 'band')
keys_desc = {'type': 'type', 'date': 'data\'s date', 'band': 'raster band'}

_MAX_PRIMARY_KEY_LENGTH = 767 // 4  # Max key length for MySQL is at least 767B
_METADATA_COLUMNS: Tuple[Tuple[str, ...], ...] = (
    ('bounds_north', 'REAL'),
    ('bounds_east', 'REAL'),
    ('bounds_south', 'REAL'),
    ('bounds_west', 'REAL'),
    ('convex_hull', 'LONGTEXT'),
    ('valid_percentage', 'REAL'),
    ('min', 'REAL'),
    ('max', 'REAL'),
    ('mean', 'REAL'),
    ('stdev', 'REAL'),
    ('percentiles', 'BLOB'),
    ('metadata', 'LONGTEXT')
)
_CHARSET: str = 'utf8mb4'
key_size = _MAX_PRIMARY_KEY_LENGTH // len(key_names)
key_type = f'VARCHAR({key_size})'

with pymysql.connect(host='ip-address', user='root',
                     password='password', port=3306,
                     binary_prefix=True, charset='utf8mb4', db='tilesbox') as cursor:
    cursor.execute(f'CREATE TABLE terracotta (version VARCHAR(255)) '
                   f'CHARACTER SET {_CHARSET}')

    cursor.execute('INSERT INTO terracotta VALUES (%s)', [str('0.5.2')])

    cursor.execute(f'CREATE TABLE key_names (key_name {key_type}, '
                   f'description VARCHAR(8000)) CHARACTER SET {_CHARSET}')
    key_rows = [(key, keys_desc[key]) for key in key_names]
    cursor.executemany('INSERT INTO key_names VALUES (%s, %s)', key_rows)

    key_string = ', '.join([f'{key} {key_type}' for key in key_names])
    cursor.execute(f'CREATE TABLE datasets ({key_string}, filepath VARCHAR(8000), '
                   f'PRIMARY KEY({", ".join(key_names)})) CHARACTER SET {_CHARSET}')

    column_string = ', '.join(f'{col} {col_type}' for col, col_type
                              in _METADATA_COLUMNS)
    cursor.execute(f'CREATE TABLE metadata ({key_string}, {column_string}, '
                   f'PRIMARY KEY ({", ".join(key_names)})) CHARACTER SET {_CHARSET}')
```

瓦罐的头文件存储共需要四个表。

| Table      | Describe                  |
| ---------- | ------------------------- |
| terracotta | 存储瓦罐版本信息          |
| metadata   | 存储数据头文件            |
| Key_names  | key类型及描述             |
| Datasets   | 数据地址及（key）属性信息 |

服务启动修改如下：

```ini
[Unit]
Description=Gunicorn instance to serve Terracotta
After=network.target

[Service]
User=root
WorkingDirectory=/mnt/data
Environment="PATH=/root/.conda/envs/gunicorn/bin"
Environment="TC_DRIVER_PATH=root:password@ip-address:3306/tilesbox"
Environment="TC_DRIVER_PROVIDER=mysql"

ExecStart=/root/.conda/envs/gunicorn/bin/gunicorn \
            --workers 3 --bind 0.0.0.0:5000  -m 007 terracotta.server.app:app

[Install]
WantedBy=multi-user.target
```

对于注入本地文件，可参照如下方法：

```python
import os
import terracotta as tc
from terracotta.scripts import optimize_rasters, click_types
import pathlib

driver = tc.get_driver("/path/to/data/google/tc.sqlite")
print(driver.get_datasets())

local = "/path/to/data/google/Origin.tiff"
outdir = "/path/to/data/google/cog"
filename = os.path.basename(os.path.splitext(local)[0])
seq = [[pathlib.Path(local)]]
path = pathlib.Path(outdir)
# 调用click方法
optimize_rasters.optimize_rasters.callback(raster_files=seq, output_folder=path, overwrite=True)

outfile = outdir + os.sep + filename + ".tif"

driver.insert(filepath=outfile, keys={'nomask': 'yes'})

print(driver.get_datasets())

```

运行如下

```shell
Optimizing rasters:   0%|          | [00:00<?, file=Origin.tiff]

Reading:   0%|          | 0/992
Reading:  12%|█▎        | 124/992
Reading:  21%|██▏       | 211/992
Reading:  29%|██▉       | 292/992
Reading:  37%|███▋      | 370/992
Reading:  46%|████▌     | 452/992
Reading:  54%|█████▍    | 534/992
Reading:  62%|██████▏   | 612/992
Reading:  70%|██████▉   | 693/992
Reading:  78%|███████▊  | 771/992
Reading:  87%|████████▋ | 867/992

Creating overviews:   0%|          | 0/1

Compressing:   0%|          | 0/1
Optimizing rasters: 100%|██████████| [00:06<00:00, file=Origin.tiff]
{('nomask',): '/path/to/data/google/nomask.tif', ('yes',): '/path/to/data/google/cog/Origin.tif'}

Process finished with exit code 0

```

稍加修改就可以传入input 文件名 和 output的文件夹名，就能实现影像优化、注入的工作流。

## Reference

-   [A traditional Terracotta deployment with Nginx and Gunicorn](https://terracotta-python.readthedocs.io/en/latest/tutorials/wsgi.html#a-traditional-terracotta-deployment-with-nginx-and-gunicorn)
-   [Running Gunicorn](http://docs.gunicorn.org/en/latest/run.html)
