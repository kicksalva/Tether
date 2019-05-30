#!/bin/bash

interface=eth0
#interface=ens33

sudo ifconfig $interface 192.168.17.2 netmask 255.255.255.0 up 

sudo route add default gw 10.0.0.1

sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -I FORWARD -i $interface -o tun -s 192.168.17.0/24 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -I FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t nat -I POSTROUTING -o tun -j MASQUERADE

sudo iptables -v -t mangle -A POSTROUTING -o tun -j TTL --ttl-set 65
#sudo iptables -v -t mangle -A OUTPUT -o tun -j TTL --ttl-set 65
#sudo iptables -v -t mangle -A FORWARD -o tun -j TTL --ttl-set 65

