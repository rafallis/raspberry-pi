# alterar senha com sudo rasp-config
# localisation options > change local > escolher opção correta
# advanced options > memory split > 16
# finish > reboot

sudo su
apt update && apt upgrade -y

apt install -y apache2
systemctl start apache2
systemctl enable apache2
# verificar endereço no browser

apt install -y apache2 mariadb-server libapache2-mod-php7.0 \
    php7.0-gd php7.0-json php7.0-mysql php7.0-curl \
    php7.0-intl php7.0-mcrypt php-imagick \
    php7.0-zip php7.0-xml php7.0-mbstring

cd /tmp
wget https://download.owncloud.org/community/owncloud-10.0.3.tar.bz2
tar -xvf ***

chown -R www-data:www-data owncloud
mv owncloud /var/www/html

#configure web server
nano /etc/apache2/sites-available/owncloud.conf

#escrever no arquivo
Alias /owncloud "/var/www/html/owncloud"
<Directory /var/www/html/owncloud/>
    Options +FollowSymlinks
    AllowOverride All

    <IfModule mod_dav.c>
        Dav off
    </IfModule>

    SetEnv Home /var/www/html/owncloud
    SetEnv HTTP_HOME /var/www/html/owncloud
</Directory>

#create a symlink
ln -s /etc/apache2/sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf

#enable some modules
a2enmod headers
systemctl restart apache2
a2enmod env
a2enmod dir
a2enmod mime

#configuring mysql
mysql -u root -p
create user owncloud@localhost identified by '12345';
grant all privileges on owncloud.* to owncloud@localhost identified by '12345';
flush privileges;
exit;

#acessar a instância do owncloud
http://ip.do.rasp.berry/owncloud/

#create admin acc

#configuring external hard drive
sudo apt-get isntall ntfs-3g
sudo mkdir /media/ownclouddrive

#get gid and uid from server
id -g www-data
id -u www-data

#copy uuid of hard drive
ls -l /dev/disk/by-uuid

#include hard drive to boot
sudo nano /etc/fstab
    UUID=000000000000 /media/ownclouddrive auto nofail,uid=00,gid=00,umask=0027,dmask=0027,noatime 0 0

sudo reboot

sudo ls /media/ownclouddrive
#configurar DATA FOLDER na primeira inicialização do owncloud no browser

#ssl configuration
sudo nano /var/www/owncloud/config/config.php
    array(
        0 => '10.0.0.15',
        1 => 'external.ip',
    )

    'overwrite.cli.url' => 'http>//external.ip/owncloud',

#port forward on router
use port 443 TCP/UDP
