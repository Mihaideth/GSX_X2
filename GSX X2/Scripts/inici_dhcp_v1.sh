#!/bin/bash
#Made by Sergi Cugat, Mihai Copil and Jordi Borrell
#22/03/17
#Configura el router perque assigni adreces IP utilitzant el protocol dhcp

#Instalació del paquet dhcp
sudo apt-get install isc-dhcp-server

#INTERFACES	

sudo ifdown --force eth0
sudo ifdown --force eth1
sudo ifdown --force eth2

#eliminem el docker0
sudo ifconfig docker0 down

echo "Connecta el cable del ethernet 0 que va al client i el ethernet 2 que va al servidor, tot segut escriu ok per continuar"

read -r enter

if [ $enter == "ok" ]; then

	sudo echo "#restaurat
allow-hotplug eth0
iface eth0 inet static
   address 192.168.148.1
   netmask 255.255.254.0
   network 192.168.148.0
   broadcast 192.168.149.255

allow-hotplug eth1
iface eth1 inet dhcp
   
allow-hotplug eth2
iface eth2 inet static
   address 172.17.37.1
   netmask 255.255.255.0
   network 172.17.37.0
   broadcast 172.17.37.255" > /etc/network/interfaces


	sudo echo "#
# Sample configuration file for ISC dhcpd for Debian
#
#

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name \"example.org\";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 608300;
max-lease-time 608300;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# No service will be given on this subnet, but declaring it helps the
# DHCP server to understand the network topology.

#subnet 10.152.187.0 netmask 255.255.255.0 {
#}

# This is a very basic subnet declaration.

#subnet 10.254.239.0 netmask 255.255.255.224 {
#  range 10.254.239.10 10.254.239.20;
#  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
#}

# This declaration allows BOOTP clients to get dynamic addresses,
# which we don't really recommend.

#subnet 10.254.239.32 netmask 255.255.255.224 {
#  range dynamic-bootp 10.254.239.40 10.254.239.60;
#  option broadcast-address 10.254.239.31;
#  option routers rtr-239-32-1.example.org;
#}

# A slightly different configuration for an internal subnet.
#subnet 10.5.5.0 netmask 255.255.255.224 {
#  range 10.5.5.26 10.5.5.30;
#  option domain-name-servers ns1.internal.example.org;
#  option domain-name 'internal.example.org';
#  option routers 10.5.5.1;
#  option broadcast-address 10.5.5.31;
#  default-lease-time 600;
#  max-lease-time 7200;
#}

# Hosts which require special configuration options can be listed in
# host statements.   If no address is specified, the address will be
# allocated dynamically (if possible), but the host-specific information
# will still come from the host declaration.

#host passacaglia {
#  hardware ethernet 0:0:c0:5d:bd:95;
#  filename 'vmunix.passacaglia';
#  server-name 'toccata.fugue.com';
#}

# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
#host fantasia {
#  hardware ethernet 08:00:07:26:c0:a5;
#  fixed-address fantasia.fugue.com;
#}

# You can declare a class of clients and then do address allocation
# based on that.   The example below shows a case where all clients
# in a certain class get addresses on the 10.17.224/24 subnet, and all
# other clients get addresses on the 10.0.29/24 subnet.

#class 'foo' {
#  match if substring (option vendor-class-identifier, 0, 4) = 'SUNW';
#}

#shared-network 224-29 {
#  subnet 10.17.224.0 netmask 255.255.255.0 {
#    option routers rtr-224.example.org;
#  }
#  subnet 10.0.29.0 netmask 255.255.255.0 {
#    option routers rtr-29.example.org;
#  }
#  pool {
#    allow members of 'foo';
#    range 10.17.224.10 10.17.224.250;
#  }
#  pool {
#    deny members of 'foo';
#    range 10.0.29.10 10.0.29.230;
#  }
#}
# SUBNET CLIENT 'xarxa1'
subnet 192.168.148.0 netmask 255.255.254.0 {
  range 192.168.148.2 192.168.149.254;
  option subnet-mask 255.255.254.0;
  option routers 192.168.148.1;
  option broadcast-address 192.168.149.255;
  option domain-name-servers 192.168.148.1;
  option domain-name \"interna\";
  option domain-search \"interna\",\"grup37.gsx\";
  default-lease-time 604800;
  max-lease-time 604800;
}

# SUBNET SERVIDOR 'xarxa2'
subnet 172.17.37.0 netmask 255.255.255.0 {
  range 172.17.37.3 172.17.37.254; #si es treu no te adreces aleatories per donar
  option subnet-mask 255.255.255.0;
  option routers 172.17.37.1;
  option broadcast-address 172.17.37.255;
  option domain-name-servers 172.17.37.1;
  option domain-name \"grup37.gsx\";
  option domain-search \"grup37.gsx\";
  default-lease-time 604800;
  max-lease-time 604800;
}

host servidor {
  hardware ethernet 00:0a:cd:21:ad:16;
  fixed-address 172.17.37.2;
}" > /tmp/dhcpdProva.conf

sudo cp -p /tmp/dhcpdProva.conf /etc/dhcp/dhcpd.conf

	echo "Vols activar el servei dhcp?, escriu si en cas afirmatiu"

	read -r activar

	if [ $activar == "si" ]; then
		sudo service isc-dhcp-server start
		echo "isc-dhcp-server activat"
	fi

#sudo echo "1" > /tmp/ip_forward_Prova

#sudo cp -p /tmp/ip_forward_Prova /proc/sys/net/ipv4/ip_forward

#Activem el forwarding
sudo echo "1" > /proc/sys/net/ipv4/ip_forward

sudo echo "#
# /etc/sysctl.conf - Configuration file for setting system variables
# See /etc/sysctl.d/ for additional system variables.
# See sysctl.conf (5) for information.
#

#kernel.domainname = example.com

# Uncomment the following to stop low-level messages on console
#kernel.printk = 3 4 1 3

##############################################################3
# Functions previously found in netbase
#

# Uncomment the next two lines to enable Spoof protection (reverse-path filter)
# Turn on Source Address Verification in all interfaces to
# prevent some spoofing attacks
#net.ipv4.conf.default.rp_filter=1
#net.ipv4.conf.all.rp_filter=1

# Uncomment the next line to enable TCP/IP SYN cookies
# See http://lwn.net/Articles/277146/
# Note: This may impact IPv6 TCP sessions too
#net.ipv4.tcp_syncookies=1

# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
#net.ipv6.conf.all.forwarding=1


###################################################################
# Additional settings - these settings can improve the network
# security of the host and prevent against some network attacks
# including spoofing attacks and man in the middle attacks through
# redirection. Some network environments, however, require that these
# settings are disabled so review and enable them as needed.
#
# Do not accept ICMP redirects (prevent MITM attacks)
#net.ipv4.conf.all.accept_redirects = 0
#net.ipv6.conf.all.accept_redirects = 0
# _or_
# Accept ICMP redirects only for gateways listed in our default
# gateway list (enabled by default)
# net.ipv4.conf.all.secure_redirects = 1
#
# Do not send ICMP redirects (we are not a router)
#net.ipv4.conf.all.send_redirects = 0
#
# Do not accept IP source route packets (we are not a router)
#net.ipv4.conf.all.accept_source_route = 0
#net.ipv6.conf.all.accept_source_route = 0
#
# Log Martian Packets
#net.ipv4.conf.all.log_martians = 1
#" > /tmp/sysctlProva.conf

sudo cp -p /tmp/sysctlProva.conf /etc/sysctl.conf

sudo echo "Forwarding activat"

fi

sudo ifup eth0
sudo ifup eth1
sudo ifup eth2


