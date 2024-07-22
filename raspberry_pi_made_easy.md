# Raspberry Pi made easy
## _Platform: Raspberry Pi_ 
## _Operating system: Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-1069-raspi aarch64)_
___
### Install docker Engine on ubuntu 20.04 (64 bit)
```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
___
### Setup wifi on Pi
1. Open file using nano
```sh
nano /etc/netplan/50-cloud-init.yaml
```
2. Write text mentioned below in the opened file, main text is from wifis. replace wlan0 with your wifi interface name, access-point name and your password.
```
network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
    wifis:
        wlan0:
            optional: true
            access-points:
              "ROS_TP-Link_BD46_24G":
                password: "Ros@1234"
            dhcp4: true
```




### Internet not working check
# operation for /etc/resolv.conf.

nameserver 8.8.8.8
nameserver 192.168.0.1

___
# Setup hotspot on raspberry pi 4 ubuntu 20.04 server
# Introduction

This tutorial for setting up Ubuntu Server (RPi 4B) as Wifi access point 

# Overview:
The main steps can be listed as following:
1. Install required packages
1. Setup hostapd
1. Setup DNSmasq
1. Configure AP IP Address

## Install required packages
`sudo apt-get install hostapd dnsmasq`

## Hostapd
- The purpose of Hostapd is to set WiFi as an access point
- we need to write a new config file for hostapd
`sudo vi /etc/hostapd/hostapd.conf`

    ```
    interface=wlan0
    driver=nl80211
    ssid=MyWiFiNetwork
    hw_mode=g
    channel=7
    wmm_enabled=0
    macaddr_acl=0
    auth_algs=1
    ignore_broadcast_ssid=0
    wpa=2
    wpa_passphrase=12345678
    wpa_key_mgmt=WPA-PSK
    wpa_pairwise=TKIP
    rsn_pairwise=CCMP

    ```

- Then we need to tell hostapd to use our config file, edit `/etc/default/hostapd` and change the line starts with `#DAEMON_CONF`, remember to remove `#`

    ```
    DAEMON_CONF="/etc/hostapd/hostapd.conf"
    ```
- Then Let's start hostapd
    ```bash
    sudo systemctl unmask hostapd
    sudo systemctl enable hostapd
    sudo systemctl start hostapd
    ```

## Set wlan0 interface IP
### First check what ip is assigned using
```sh
ifconfig
```
#### If no ip is assigned to the wlan0 interface then use below command and change IP
```sh
sudo ifconfig wlan0 192.168.150.1 up
```

## dnsmasq
- The purpose of dnsmasq is to act as DHCP Server, so when a devies connects to Raspberry Pi it can get an IP assigned to it.

- make a backup of default config by:
`sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.org`

- Create a new config file by:
`sudo vi /etc/dnsmasq.conf`

- This config file will automatically assign addresses between `192.168.4.2` and `192.168.4.20` with lease time `24` hours.

    ```
    interface=wlan0
    dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h

    ```
- Then Let's reload dnsmasq config
    ```bash
    sudo systemctl reload dnsmasq
    ```

## Solving startup Error:
- On System startup, dnsmasq will not wait for wlan0 interface to initialize and will fail with error `wlan0 not found`.

- We need to tell systemd to launch it after network get ready, so we will modify dnsmasq service file by adding `After=` and `Wants=` under `[Unit]` section.

    `sudo vi /lib/systemd/system/dnsmasq.service`

    ```
    [Unit]
    ...
    After=network-online.target
    Wants=network-online.target
    
    ```

## Config static IP
- Ubuntu uses cloud-init for initial setup, so will modify the following file to set wlan0 IP.
- `DON'T USE TABS IN THIS FILE, IT WILL NOT WORK, EVER!!`
- Modify the cloud-init file by `sudo vi /etc/netplan/50-cloud-init.yaml`
- Add the following content to the file:
    ```
            wlan0:
                dhcp4: false
                addresses:
                - 192.168.4.1/24
    ```
    
- The file will finally looks like this:
    ```
    # This file is generated from information provided by
    # the datasource.  Changes to it will not persist across an instance.
    # To disable cloud-init's network configuration capabilities, write a file
    # /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
    # network: {config: disabled}
    network:
        version: 2
        ethernets:
            eth0:
                dhcp4: true
                match:
                    macaddress: 12:34:56:78:ab:cd
                set-name: eth0
            wlan0:
                dhcp4: false
                addresses:
                - 192.168.4.1/24

    ```
## Finally:
- Reboot your Raspberry Pi and check if you can connect to it over WiFi and can SSH.

## Notes:
- if you can't see Raspberry Pi Hot spot then `hostapd` is not working, you can check its logs by `sudo systemctl status hostapd`.

- if you can coonect to Raspberry Pi but can't get an IP then `dnsmasq` is not working, you can check its logs by `sudo systemctl status dnsmasq`.

___
# Device: Raspberry Pi 4 
# Os: Raspbian
#### Setup wifi on raspbian
https://linuxhint.com/create-wifi-hotspot-raspberry-pi/#:~:text=Step%203%3A%20Create%20Wi%2DFi,the%20%E2%80%9CAdvanced%20Options%E2%80%9D%20section.
___