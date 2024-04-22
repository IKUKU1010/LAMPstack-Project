#!/bin/bash

# Function to install packages
install_packages() {
    sudo apt update
    sudo apt install -y apache2
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt update
    sudo apt install -y php8.2 php8.2-curl php8.2-dom php8.2-mbstring php8.2-xml php8.2-mysql php8.2-fpm zip unzip
    sudo a2enmod rewrite
    sudo systemctl restart apache2
}

# Function to install Composer
install_composer() {
    cd /usr/bin
    sudo curl -sS https://getcomposer.org/installer | sudo php
    sudo mv composer.phar composer
}

# Function to clone Laravel repository and set up permissions
setup_laravel() {
    cd /var/www/
    export GIT_HTTP_LOW_SPEED_LIMIT=10240 
    sudo git clone https://github.com/laravel/laravel.git
    sudo chown -R $USER:$USER /var/www/laravel
    cd laravel
    composer install --optimize-autoloader --no-dev --no-interaction
    composer update --no-interaction
    sudo cp .env.example .env
}

# Function to set permissions for directories and files
set_permissions() {
    sudo find /var/www/laravel -type d -exec chmod 755 {} \;
    sudo find /var/www/laravel -type f -exec chmod 644 {} \;
    sudo chown -R www-data:www-data /var/www/laravel/storage
    sudo chmod -R 775 /var/www/laravel/storage
    sudo chown -R www-data /var/www/laravel/bootstrap/cache
}

# Function to install and configure MySQL
install_mysql() {
    sudo apt install -y mysql-server mysql-client
    sudo systemctl start mysql
    sudo mysql -uroot -e "CREATE DATABASE Thankg;"
    sudo mysql -uroot -e "CREATE USER 'Wisdomar'@'localhost' IDENTIFIED BY 'nuhaven';"
    sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON Thankg.* TO 'Wisdomar'@'localhost';"
    sudo mysql -uroot -e "FLUSH PRIVILEGES;"
 cd /var/www/laravel
    sudo sed -i "23 s/^#//g" /var/www/laravel/.env
    sudo sed -i "24 s/^#//g" /var/www/laravel/.env
    sudo sed -i "25 s/^#//g" /var/www/laravel/.env
    sudo sed -i "26 s/^#//g" /var/www/laravel/.env
    sudo sed -i "27 s/^#//g" /var/www/laravel/.env
    sudo sed -i '22 s/=sqlite/=mysql/' /var/www/laravel/.env
    sudo sed -i '23 s/=127.0.0.1/=localhost/' /var/www/laravel/.env
    sudo sed -i '24 s/=3306/=3306/' /var/www/laravel/.env
    sudo sed -i '25 s/=laravel/=Thankg/' /var/www/laravel/.env
    sudo sed -i '26 s/=root/=Wisdomar/' /var/www/laravel/.env
    sudo sed -i '27 s/=/=nuhaven/' /var/www/laravel/.env
    sudo php artisan key:generate
    sudo php artisan storage:link
    sudo php artisan migrate
    sudo php artisan db:seed
}

# Function to configure Apache VirtualHost
configure_apache() {
    sudo tee /etc/apache2/sites-available/myskrippt.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/laravel/public

    <Directory /var/www/laravel>
        AllowOverride All
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/laravel-error.log
    CustomLog \${APACHE_LOG_DIR}/laravel-access.log combined
</VirtualHost>
EOF
    sudo a2ensite myskrippt.conf
    sudo a2dissite 000-default.conf
    sudo ufw allow "Apache Full"
    sudo a2enmod rewrite
    sudo systemctl restart apache2
}

# Main script
install_packages
install_composer
setup_laravel
set_permissions
install_mysql
configure_apache
