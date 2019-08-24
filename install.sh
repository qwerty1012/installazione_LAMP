#!/bin/bash

f_check_root () {
if (( $EUID == 0 )); then
   f_sub_main
else
    echo "Utilizzare account ROOT!"
    exit
fi
}


f_update_os () {
    echo "Aggiornamento sistema operativo"
    sleep 1

    apt-get update
    apt-get upgrade -y

    echo "Sistema operativo aggiornato"
    sleep 1
}


f_install_lamp () {
   
    echo "Installo apache2 ..."
    sleep 1
    apt-get install apache2 -y
   
    sed -i '/<If/,/<\/If/{//!d}' /etc/apache2/mods-available/mpm_prefork.conf
    sed -i '/<If/a\ StartServers              4\n MinSpareServers           20\n MaxSpareServers           40\n MaxRequestWorkers         200\n MaxConnectionsPerChild    4500' /etc/apache2/mods-available/mpm_prefork.conf


    a2dismod mpm_event
    echo ""
    sleep 1
    a2enmod mpm_prefork
    echo ""
    sleep 1


    systemctl restart apache2
    echo ""
    sleep 1


    echo "Installo MariaDB server ..."
    sleep 1
    apt-get install mariadb-server mariadb-client -y
    echo ""
    sleep 1

    echo "Installo PHP 7 ..."
    sleep 1
    apt-get install php7.0 php7.0-fpm php7.0-gd php7.0-mysql -y
    # To enable PHP7.0 in Apache2
    a2enmod proxy_fcgi setenvif
    a2enconf php7.0-fpm
    systemctl restart apache2
    echo ""
    sleep 1

    echo "<?php phpinfo(); ?>" > /var/www/html/info.php
    echo ""
    echo "http://YOUR-SERVER-IP/info.php"
    sleep 1
}


f_sub_main () {
    f_update_os
    f_install_lamp
}

f_main () {
    f_check_root
}
f_main

exit
