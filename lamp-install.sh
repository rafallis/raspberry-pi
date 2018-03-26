#!/bin/bash

#--------------------INSTRUCTIONS--------------------------------
# 
# chmod +x lamp-install.sh
#
# sudo ./lamp-install.sh
#
#----------------------------------------------------------------

echo "#------------------------------------------------------------#"
echo "    Installing LAMP on the system... It may take some time    "
echo "#------------------------------------------------------------#"

#APACHE
echo -e "\n"
echo "Installing APACHE server......"
apt-get install -y apache2
systemclt start apache2
systemclt enable apache2

#PHP MYSQL 
apt-get install -y install -y apache2 mariadb-server libapache2-mod-php7.0 \
    php7.0-gd php7.0-json php7.0-mysql php7.0-curl \
    php7.0-intl php7.0-mcrypt php-imagick \
    php7.0-zip php7.0-xml php7.0-mbstring

apt-get install -f

# INSTALLING AND CONFIGURING MYSQL-SERVER
echo "#------------------------------------------------------------#"
echo "Configuring mysql server to use MYSQLPASS123 as root password"
echo "#------------------------------------------------------------#"
echo debconf mysql-server/root_password password MYSQLPASS123 | sudo debconf-set-selections
echo debconf mysql-server/root_password_again password MYSQLPASS123 | sudo debconf-set-selections
#debconf-set-selections <<< 'mysql-server mysql-server/root_password password MYSQLPASS123'
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password MYSQLPASS123'
apt-get -y install mysql-server

# RESTART SERVICES
echo -e "\n"
service apache2 restart && service mysql restart >> /dev/null
echo -e "\n"

if [ $? -ne 0 ]; then
    echo "Some service is not working properly."
else
    echo "Services are succefully installed and running."
fi

echo -e "\n"
