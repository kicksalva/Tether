#!/bin/sh
# 
# rc.flush-iptables - Resets iptables to default values. 
# 
# Copyright (C) 2001 Oskar Andreasson <bluefluxATkoffeinDOTnet>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program or from the site that you downloaded it
# from; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA 02111-1307 USA
#
# Configurations
#
IPTABLES="iptables"
#
# reset the default policies in the filter table.
#
sudo $IPTABLES -P INPUT ACCEPT
sudo $IPTABLES -P FORWARD ACCEPT
sudo $IPTABLES -P OUTPUT ACCEPT
#
# reset the default policies in the nat table.
#
sudo $IPTABLES -t nat -P PREROUTING ACCEPT
sudo $IPTABLES -t nat -P POSTROUTING ACCEPT
sudo $IPTABLES -t nat -P OUTPUT ACCEPT
#
# reset the default policies in the mangle table.
#
sudo $IPTABLES -t mangle -P PREROUTING ACCEPT
sudo $IPTABLES -t mangle -P POSTROUTING ACCEPT
sudo $IPTABLES -t mangle -P INPUT ACCEPT
sudo $IPTABLES -t mangle -P OUTPUT ACCEPT
sudo $IPTABLES -t mangle -P FORWARD ACCEPT
#
# flush all the rules in the filter and nat tables.
#
sudo $IPTABLES -F
sudo $IPTABLES -t nat -F
sudo $IPTABLES -t mangle -F
#
# erase all chains that's not default in filter and nat table.
#
sudo $IPTABLES -X
sudo $IPTABLES -t nat -X
sudo $IPTABLES -t mangle -X
