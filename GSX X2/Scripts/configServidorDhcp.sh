#!/bin/bash
#vigilar amb MAC del servidor en cas d'usar un altre ordinador
sudo ifconfig docker0 down
sudo ifdown --force eth0
sudo ifdown --force eth1

sudo echo "auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet dhcp" > /etc/network/interfaces

ifup eth0

apt-get install openssh-server
service ssh restart
