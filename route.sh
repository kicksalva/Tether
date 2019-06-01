#!/bin/bash

# to router wan port (from raspberry pi)
router_interface=eth0
router_ip_address=192.168.2.1

# to router wan port (from vm)
#router_interface=ens33
#router_ip_address=192.168.17.2

# to phone (clockworkmod tether)
phone_interface=tun
phone_gateway=10.0.0.1

# to phone (built-in wifi hotspot)
#phone_interface=wlan0
#phone_gateway=192.168.43.1


sudo route add default gw $phone_gateway

sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o $phone_interface -j MASQUERADE

sudo iptables -I FORWARD -i $router_interface -o $phone_interface -s $router_ip_address/24 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -I FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -v -t mangle -A POSTROUTING -o $phone_interface -j TTL --ttl-set 65





# share internet with raspberry pi hotspot nic 
#router_interface=wlan0
#router_ip_address=192.168.3.1
#sudo iptables -I FORWARD -i $router_interface -o $phone_interface -s $router_ip_address/24 -m conntrack --ctstate NEW -j ACCEPT

# I think these are incorrect methods for setting ttl on the nic connected to the phone 
#sudo iptables -v -t mangle -A OUTPUT -o $phone_interface -j TTL --ttl-set 65
#sudo iptables -v -t mangle -A FORWARD -o $phone_interface -j TTL --ttl-set 65

