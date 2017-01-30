#!/usr/bin/env bash

echo "Update package"
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update

echo "Install Aapache"
sudo apt-get install -y apache2
if ! [ -L /var/www ]; then
  sudo rm -rf /var/www/html
  sudo ln -fs /vagrant /var/www/html
fi
echo 'ServerName Localhost' >> /etc/apache2/apache2.conf

echo "Install MySQL"
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
sudo apt-get install -y mysql-server

echo "Install PHP"
sudo apt-get install -y php7.1 php7.1-cli php7.1-mbstring php7.1-xml php7.1-gettext

echo "Install Utilities"
sudo apt-get install -y git unzip
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mkdir /usr/local/bin/composer
sudo mv ~/composer.phar /bin/composer
sudo apt-get install -y phpmyadmin

echo "Restart Server"
sudo systemctl restart apache2

echo "Initialize Laravel"
composer create-project laravel/laravel project1 "5.1.*"

echo "Done"
