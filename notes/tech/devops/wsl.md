---
title: wsl
---
## 远程WSL的SSH

1、安装WSL
2、配置sshd
启用密码登录，公钥登录，更换端口，监听地址。
3、完成端口转发
```powershell
netsh interface portproxy set v4tov4 listenport=23 listenaddress=0.0.0.0 connectport=23 connectaddress=169.254.83.107
```

