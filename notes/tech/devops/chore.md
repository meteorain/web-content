---
title: 堆放在一起毫无条理的脚本
---
## 一些可能会复用的脚本

### 构建静态网站并上传到服务器

```bash title=".publish/publish.sh"
#!/usr/bin/env bash  

cd ../  
  
remote_dist_path="/home/lighthouse/www/dist"  
# clear remote dist  
ssh root@lighthouse "rm -rf $remote_dist_path"  
# mkdir remote dist  
ssh root@lighthouse "mkdir $remote_dist_path"  
# build and scp  
pnpm build && scp -r dist/* usr@lighthouse:$remote_dist_path
```


## split ttc to ttf(s)

[fonttools(issue#2647)](https://github.com/fonttools/fonttools/discussions/2647)

```python
#!/usr/bin/env python

from fontTools.ttLib.ttCollection import TTCollection
import os
import sys

filename = sys.argv[1]
ttc = TTCollection(filename)
basename = os.path.basename(filename)
for i, font in enumerate(ttc):
    font.save(f"{basename}#{i}.ttf")
```