---
title: 疑难杂症
---
## caddy file_server 403

```bash
chmod -R a+x $remote_dist_path
```

症状大致为，使用`caddy start`，一切正常，使用`systemctl start caddy` 会是`403`的错误。

修改静态文件目录地址，解决了问题，说起来不太优雅，然而不想再折腾了🤦‍♂️。