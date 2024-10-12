---
title: Node custom build
---

## windows 

参照 [node/BUILDING.md at main · nodejs/node · GitHub](https://github.com/nodejs/node/blob/main/BUILDING.md)

```bat
set configure_flags=%configure_flags% --without-snapshot --without-npm --without-corepack --without-node-options --without-ssl
```
