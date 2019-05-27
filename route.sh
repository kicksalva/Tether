#!/bin/bash

sudo ifconfig ens33 192.168.17.2 netmask 255.255.255.0 up 

sudo route add default gw 10.0.0.1

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -I FORWARD -i ens33 -o tun -s 192.168.17.0/24 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -I FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -t nat -I POSTROUTING -o tun -j MASQUERADE

