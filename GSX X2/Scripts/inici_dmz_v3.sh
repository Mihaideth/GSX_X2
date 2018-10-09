cd /
tar -xzf /home/milax/Desktop/websites.tgz
cd /etc/apache2
. ./envvars
a2ensite taller.conf
a2ensite tenda.conf
service apache2 restart

