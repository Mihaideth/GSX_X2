cd /var/www/taller
mkdir admin
cd admin
touch .htaccess
echo "AuthType Basic
AuthName \"Zona Privada. Si us plau introduiu el password\"
AuthUserFile /var/www/taller/admin/.htpasswd
Require valid-user" > .htaccess
htpasswd -c .htpasswd milax
cp /var/www/taller/index.html /var/www/taller/admin
rm /var/www/taller/index.html

