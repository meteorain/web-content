---
title: Untitled
---
## openwrt

1、 静态IP
```bash
vim /etc/config/network
```

static ip

2、登录webui，设置dns

3、设置清华源

```bash
sed -i 's_downloads.openwrt.org_mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/opkg/distfeeds.conf
```

4、下载挂载点工具

```bash
opkg update
opkg install block-mount
```

5、
```
opkg install cfdisk
```

6、挂载到 overlay

## passwall

1、安装依赖包

2、卸载dnsmasq 安装passwall app

```
Configuring luci-app-passwall.
Collected errors:
 * resolve_conffiles: Existing conffile /etc/config/dhcp is different from the conffile in the new package. The new conffile will be placed at /etc/config/dhcp-opkg.
root@OpenWrt:~/passwall# sed -i 's_downloads.openwrt.org_mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/opkg/distfeeds.conf
root@OpenWrt:~/passwall# cp /etc/config/dhcp /etc/config/dhcp-bak
root@OpenWrt:~/passwall# mv /etc/config/dhcp-opkg /etc/config/dhcp
```


### 旁路网关自身的基础设置

刷好固件的新 Openwrt 网关，一般默认的IP地址是192.169.1.1。你可以通过WiFi或网线，**确保电脑只连接了它**，就可以访问该管理地址了。

1. 在“网络”-“接口”的“常规设置”中给 Openwrt 的 LAN 网络接口设置一个和现有局域网同网段的静态 IP 地址，注意不要和现有设备的 IP 地址冲突。然后应用设置。
2. 将 LAN 网络接口的“默认网关”设为主路由的 IP 地址。
3. 在“高级设置”中找到“使用自定义的 DNS 服务器”设为主路由的 IP 地址。
4. 在“DHCP 服务器”中勾选“忽略此接口”。
5. 在“DHCP 服务器”-“IPv6 设置”中禁用所有IPv6服务。
6. 点击“保存”以及“保存并应用”。
7. 在“网络”-“防火墙”中，关闭“SYN-flood 防御”，点击“保存并应用”。
8. 建议重启一次。