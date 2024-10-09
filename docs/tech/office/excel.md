---
title: Excel
---


## 条件格式

以每行的最大值最小值为例

`new rule` -> `classic` -> `Use a formula to determine which cells to format`

```text
=A3=MAX($A3:$C3)
=A3=MIN($A3:$C3)
```