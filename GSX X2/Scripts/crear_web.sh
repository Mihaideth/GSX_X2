sudo apt-get install apache2

echo "# envvars - default environment variables for apache2ctl

# this won't be correct after changing uid
unset HOME

# for supporting multiple apache2 instances
if [ \"\${APACHE_CONFDIR##/etc/apache2-}\" != \"\${APACHE_CONFDIR}\" ] ; then
	SUFFIX=\"-\${APACHE_CONFDIR##/etc/apache2-}\"
else
	SUFFIX=
fi

# Since there is no sane way to get the parsed apache2 config in scripts, some
# settings are defined via environment variables and then used in apache2ctl,
# /etc/init.d/apache2, /etc/logrotate.d/apache2, etc.
export APACHE_RUN_USER=milax
export APACHE_RUN_GROUP=root
# temporary state file location. This might be changed to /run in Wheezy+1
export APACHE_PID_FILE=/var/run/apache2/apache2\$SUFFIX.pid
export APACHE_RUN_DIR=/var/run/apache2\$SUFFIX
export APACHE_LOCK_DIR=/var/lock/apache2\$SUFFIX
# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
export APACHE_LOG_DIR=/var/log/apache2\$SUFFIX

## The locale used by some modules like mod_dav
export LANG=C
## Uncomment the following line to use the system default locale instead:
#. /etc/default/locale

export LANG

## The command to get the status for 'apache2ctl status'.
## Some packages providing 'www-browser' need '--dump' instead of '-dump'.
#export APACHE_LYNX='www-browser -dump'

## If you need a higher file descriptor limit, uncomment and adjust the
## following line (default is 8192):
#APACHE_ULIMIT_MAX_FILES='ulimit -n 65536'

## If you would like to pass arguments to the web server, add them below
## to the APACHE_ARGUMENTS environment.
#export APACHE_ARGUMENTS=''

## Enable the debug mode for maintainer scripts.
## This will produce a verbose output on package installations of web server modules and web application
## installations which interact with Apache
#export APACHE2_MAINTSCRIPT_DEBUG=1" > /etc/apache2/envvars

echo "
<VirtualHost *:80>
	ServerAdmin admin@milax
	ServerName www.taller.grup37.gsx
	DocumentRoot /var/www/taller
	ServerAlias www.taller.grup37.gsx www.taller
	<Directory /var/www/taller/admin>
        	Options Includes
        	AllowOverride All
	</Directory>
	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>" > /etc/apache2/sites-available/taller.conf

echo "
<VirtualHost *:80>

	ServerName www.tenda.grup37.gsx
	DocumentRoot /var/www/tenda
	ServerAlias www.tenda.grup37.gsx www.tenda
	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>" > /etc/apache2/sites-available/tenda.conf

mkdir /var/www/taller

echo "<!DOCTYPE html>
<html> 
	<head>
		<title>ERROR</title> 
	</head> 
	<body>
		<h1>ERROR: AQUI NO HAURIES D'HAVER ARRIBAT</h1>   
	</body>
</html>" > /var/www/html/index.html

echo "<!DOCTYPE html>
<html> 
	<head>
		<title>TALLER</title> 
	</head> 
	<body>
		<h1>WEB DE TALLER</h1>   
	</body>
</html>" > /var/www/taller/index.html

echo "<!DOCTYPE html>
<html> 
	<head>
		<title>TENDA</title> 
	</head> 
	<body>
		<h1>WEB DE TENDA</h1>   
	</body>
</html>" > /var/www/tenda/index.html

