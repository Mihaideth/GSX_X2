#!/bin/bash
#Made by Sergi Cugat, Mihai Copil and Jordi Borrell
#25/02/17

#Comprovem si es executa com a root
ROOT_UID="0"
 
if [ "$UID" -ne "$ROOT_UID" ] ; then 
	echo -e "Has de ser ROOT per fer aixo!" 
	exit 1 
fi

#Activem el forwarding
sudo echo "1" > /proc/sys/net/ipv4/ip_forward


echo "Vols instalar els seguents paquets: bind9, bind9-doc i dnsutils? (escriu si en cas afirmatiu)"

read -r instalar

if [ $instalar == "si" ];then
	sudo apt-get install bind9
	sudo apt-get install bind9-doc
	sudo apt-get install dnsutils	
	echo "Paquets instalats"
fi

sudo rm /etc/bind/named.conf.local

echo "
view\"intranet\" {
	match-clients { 192.168.148.0/23; localhost; };
	recursion yes;

	// We are the master server
	zone \"interna\" {
	type master;
	file \"interna.db\";
	};

	// nom de zona inclou els bytes d'identificacio de xarxa
	// en ordre invers
	zone \"148.168.192.in-addr.arpa\" {
	type master;
	file \"db.192.168.148\";
	notify no;
	};

	// nom de zona inclou els bytes d'identificacio de xarxa
	// en ordre invers
	zone \"149.168.192.in-addr.arpa\" {
	type master;
	file \"db.192.168.149\";
	notify no;
	};

	// We are the master server
	zone \"grup37.gsx\" {
	type master;
	file \"grup37.gsx.db\";
	};


	// nom de zona inclou els bytes d'identificacio de xarxa
	// en ordre invers
	zone \"172.in-addr.arpa\" {
	type master;
	file \"db.172\";
	notify no;
	};
	include \"/etc/bind/named.conf.default-zones\";
};
view\"public\" {
	match-clients { any;};
	recursion yes;

	// We are the master server
	zone \"grup37.gsx\" {
	type master;
	file \"grup37externa.gsx.db\";
	};

	// nom de zona inclou els bytes d'identificacio de xarxa
	// en ordre invers
	zone \"10.21.1.in-addr.arpa\" {
	type master;
	file \"db.10.21.1\";
	notify no;
	};

};
view\"dmz\" {
	match-clients { 172.17.37.0/24; };
	recursion no;

	// We are the master server
	zone \"grup37.gsx\" {
	type master;
	file \"grup37.gsx.db\";
	};

	// nom de zona inclou els bytes d'identificacio de xarxa
	// en ordre invers
	zone \"172.in-addr.arpa\" {
	type master;
	file \"db.172\";
	notify no;
	};
};

" > /etc/bind/named.conf.local


sudo rm /etc/bind/named.conf.options

echo "options {
	directory \"/var/cache/bind\";

	// If there is a firewall between you and nameservers you want
	// to talk to, you may need to fix the firewall to allow multiple
	// ports to talk.  See http://www.kb.cert.org/vuls/id/800113

	// If your ISP provided one or more IP addresses for stable
	// nameservers, you probably want to use them as forwarders.
	// Uncomment the following block, and insert the addresses replacing
	// the all-0's placeholder.

	forwarders {
	  10.45.1.2;
	  10.40.1.2;
	  10.40.1.108;
	};

	//========================================================================
	// If BIND logs error messages about the root key being expired,
	// you will need to update your keys.  See https://www.isc.org/bind-keys
	//========================================================================
	dnssec-validation yes;

	auth-nxdomain no;    # conform to RFC1035
	listen-on-v6 { any; };
};" > /etc/bind/named.conf.options


echo "// This is the primary configuration file for the BIND DNS server named.
//
// Please read /usr/share/doc/bind9/README.Debian.gz for information on the 
// structure of BIND configuration files in Debian, *BEFORE* you customize 
// this configuration file.
//
// If you are just adding zones, please do that in /etc/bind/named.conf.local

include \"/etc/bind/named.conf.options\";
include \"/etc/bind/named.conf.local\";
//include \"/etc/bind/named.conf.default-zones\";" >/etc/bind/named.conf

echo "domain grup37.gsx
search grup37.gsx interna
nameserver 127.0.0.1
nameserver 10.45.1.2
nameserver 10.40.1.2
nameserver 10.40.1.108" > /etc/resolv.conf


apt-get install openssh-server

service ssh restart

#FEM UNA COPIA DE LES IPTABLES ACTUALS
sudo iptables-save > iptablesGuardatComprovar

#SNAT
iptables -t nat -A POSTROUTING -s 172.17.37.2/24 -o eth1 -j MASQUERADE

iptables -t nat -A POSTROUTING -s 192.168.148.4/23 -o eth1 -j MASQUERADE


#DNAT

iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j DNAT --to-destination 172.17.37.2:80

iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 443 -j DNAT --to-destination 172.17.37.2:443

iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 23 -j DNAT --to-destination 172.17.37.2:22

service bind9 restart

named -u bind -4 -f -g





