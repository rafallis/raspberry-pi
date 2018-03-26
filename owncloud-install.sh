#!/bin/bash

#--------------------INSTRUCTIONS--------------------------------
# 
# chmod +x owncloud-install.sh
#
# sudo ./owncloud-install.sh
#
#----------------------------------------------------------------

echo "#------------------------------------------------------------#"
echo "  Installing OWNCLOUD on the system... It may take some time  "
echo "#------------------------------------------------------------#"



# DOWNLOAD AND UNPACK OWNCLOUD
cd /tmp
wget https://download.owncloud.org/community/owncloud-10.0.3.tar.bz2
tar -xvf owncloud*
#wget https://download.owncloud.com/download/community/setup-owncloud.php
#curl https://download.owncloud.org/download/community/owncloud-latest.zip --output owncloud.zip | tar -xvf owncloud.zip

chown -R www-data:www-data owncloud
mv owncloud /var/www/html

echo "Alias /owncloud \"/var/www/html/owncloud\"
        <Directory /var/www/html/owncloud/>
        Options +FollowSymlinks
        AllowOverride All

        <IfModule mod_dav.c>
            Dav off
        </IfModule>

        SetEnv Home /var/www/html/owncloud
        SetEnv HTTP_HOME /var/www/html/owncloud
    </Directory>" >> owncloud.conf

ln -s /etc/apache2/sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf

echo -e "\n"
echo "Enabling some modules......"

a2enmod headers
systemctl restart apache2
a2enmod env
a2enmod dir
a2enmod mime

echo -e "\n"
echo "Configuring database......"

# user database password
PASSWDDB="MYSQLPASS123"

# database_username_here
MAINDB="owncloud"

# If /root/.my.cnf exists then it won't ask for root password
# if [ -f /root/.my.cnf ]; then

#     mysql -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
#     mysql -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
#     mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
#     mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
#else
    echo "Please enter root user MySQL password!"
    read rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p${rootpasswd} -e "CREATE USER '${MAINDB}'@'localhost' IDENTIFIED BY '${PASSWDDB}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
#fi

