
echo "\$TTL	604800
@	IN	SOA	ns.grup37.gsx.	root.ns.grup37.gsx. (
			1		; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )       	; Negative Cache TTL
;
@	IN	NS	ns.grup37.gsx.
1	IN	PTR	ns.grup37.gsx.
6	IN	PTR	correu.grup37.gsx.
2	IN	PTR	www.taller.grup37.gsx." > /var/cache/bind/db.172

echo "\$TTL	604800
@	IN	SOA	ns.interna.	root.ns.interna. (
			1		; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )       	; Negative Cache TTL
;
@	IN	NS	ns.interna.
1	IN	PTR	ns.interna.
6	IN	PTR	pc1.interna.
7	IN	PTR	pc2.interna.
8	IN	PTR	pc3.interna." > /var/cache/bind/db.192.168.148

echo "\$TTL	604800
@	IN	SOA	ns.interna.	root.ns.interna. (
			1		; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )       	; Negative Cache TTL
;
@	IN	NS	ns.interna.
1	IN	PTR	ns.interna.
3	IN	PTR	pc4.interna." > /var/cache/bind/db.192.168.149

echo "\$TTL	604800
@	IN	SOA	ns.grup37.gsx.	root.ns.grup37.gsx. (
			1		; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )       	; Negative Cache TTL
;
@	IN	NS	ns
	IN	MX  10	correu.grup37.gsx.
ns	IN	A	172.17.37.1
www.taller	IN	A	172.17.37.2
www.botiga		CNAME	www.taller
www.tenda		CNAME	www.taller
correu	IN	A	172.17.37.6
smtp		CNAME	correu
pop3		CNAME	correu" > /var/cache/bind/grup37.gsx.db

echo "\$TTL	604800
@	IN	SOA	ns.interna.	root.ns.interna. (
			1		; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )       	; Negative Cache TTL
;
@	IN	NS	ns
ns	IN	A	192.168.148.1
pc1	IN	A	192.168.148.6
pc2	IN	A	192.168.148.7
pc3	IN	A	192.168.148.8
pc4	IN	A	192.168.149.3" > /var/cache/bind/interna.db

echo "\$TTL	604800
@	IN	SOA	ns.grup37externa.gsx.	root.ns.grup37externa.gsx. (
			1		; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )       	; Negative Cache TTL
;
@	IN	NS	ns
ns	IN	A	10.21.1.2
www.taller	CNAME	ns
www.tenda	CNAME	ns
www.botiga	CNAME   ns
correu		CNAME	ns
smtp		CNAME	ns
pop3		CNAME	ns" > /var/cache/bind/grup37externa.gsx.db

echo "\$TTL	604800
@	IN	SOA	ns.grup37externa.gsx.	root.ns.grup37externa.gsx. (
			1		; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )       	; Negative Cache TTL
;
@	IN	NS	ns.grup37externa.gsx.
1	IN	PTR	ns.grup37externa.gsx.
2	IN	PTR	www.taller.grup37.gsx." > /var/cache/bind/db.10.21.1

