---
title: "Raspberry Pi Zero W - WiFI AP+Client From Single Built-in WiFi"
pubDate: 2017-08-30T03:37:35.000Z
---

First update your Pi Zero W to latest Stretch release!

Create or edit your wpa\_supplicant configuration: sudo vi /etc/wpa\_supplicant/wpa\_supplicant.conf

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=GB

network={
    ssid="YOUR_WIFI"
    psk="wifi_password"
    key_mgmt=WPA-PSK
}
```

Edit the interfaces configuration: sudo vi /etc/network/interfaces

```
source-directory /etc/network/interfaces.d

auto lo
auto wlan0
auto wlan1

iface lo inet loopback

allow-hotplug wlan0

iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

iface wlan1 inet static
    address 192.168.10.1
    netmask 255.255.255.0
    network 192.168.10.0
    broadcast 192.168.10.255
    gateway 192.168.10.1
```

Install hostapd and dnsmasq: sudo apt-get install hostapd dnsmasq

Create a new hostapd configuration: sudo vi /etc/hostapd/hostapd.conf

The new configuration should look like this, change your wifi ssid and password as your wish: interface=wlan1 ssid=Pi0W hw\_mode=g channel=11 macaddr\_acl=0 auth\_algs=1 ignore\_broadcast\_ssid=0 wpa=2 wpa\_passphrase=new\_password wpa\_key\_mgmt=WPA-PSK wpa\_pairwise=TKIP rsn\_pairwise=CCMP

Modify the hostapd default configuration to use your new configuration file: sudo vi /etc/default/hostapd

Add the following line: DAEMON\_CONF="/etc/hostapd/hostapd.conf"

Modify the dnsmasq configuration: sudo vi /etc/dnsmasq.conf

```
interface=lo,wlan1
no-dhcp-interface=lo,wlan0
bind-interfaces
server=8.8.8.8
domain-needed
bogus-priv
dhcp-range=192.168.10.100,192.168.10.150,12h
```

Modify sysctl.conf: sudo vi /etc/sysctl.conf

Uncomment the next line to enable packet forwarding for IPv4: net.ipv4.ip\_forward=1

Modify the rc.local script to run some commands on boot up. sudo vi /etc/rc.local

Add the following line before "exit 0". service dnsmasq start iptables -t nat -A POSTROUTING -s 192.168.10.0/24 ! -d 192.168.10.0/24 -j MASQUERADE ifdown wlan0 ifup wlan0

Last step, reboot your Pi Zero W: sudo reboot

Enjoy your new AP designed by Rasyberry Pi :D
