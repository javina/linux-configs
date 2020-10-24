#!/bin/bash
#######################################################################################################
# Bash script to install and configure LEMP stack and PHPMyAdmin plus tweaks. For Ubuntu based systems.
# JLAM
# Inspired on @AamnahAkram script
#######################################################################################################

# Global Vars
USER='jpa'
MYSQL_ROOT_PASS='jpa123'

# Optional Params to configure git
GIT_USER=''
GIT_EMAIL=''

# Global Paths
COMPOSER_PATH="/home/$USER/.config/composer"
ALIASES="/home/$USER/.bash_aliases"

# COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

# [*]  Update packages and Upgrade Ubuntu system
echo -e "$Cyan \n Updating System ... $Color_Off"
sudo apt-get update -y && sudo apt-get upgrade -y
echo -e "$Cyan \n Installing: ZIP ... $Color_Off"
sudo apt-get install -y zip unzip 
echo -e "$Cyan \n Installing: build-essential tcl  ... $Color_Off"
sudo apt-get install -y build-essential tcl libssl-dev libffi-dev python3-dev
echo -e "$Cyan \n Installing: curl  ... $Color_Off"
sudo apt-get install -y curl
echo -e "$Cyan \n Installing: openssh-server  ... $Color_Off"
sudo apt-get install -y openssh-server
echo -e "$Green \n Updating System Done... $Color_Off"

# [*]  Install Nginx Server
echo -e "$Cyan \n Installing Nginx ... $Color_Off"
sudo apt-get -y install nginx
# sudo systemctl status nginx.service
echo -e "$Green \n Installing Nginx Done $Color_Off"

[*] Install PHP
echo -e "$Cyan \n Installing PHP & Extensions $Color_Off"
sudo apt-get -y install php-fpm php-mysql php-zip php-pdo php-intl php-gd php-mysql php-imap php-xml php-sybase php-odbc php-sqlite3 php-imagick php-memcached php-soap php-swiftmailer php-uuid 
echo -e "$Cyan \n Installing PHP Laravel Require Extensions $Color_Off"
sudo apt-get -y install php-curl php-bcmath php-tokenizer php-ctype php-json php-mbstring openssl php-redis 
echo -e "$Green \n Installing PHP Done $Color_Off"

# [*] Install Mysql
echo -e "$Cyan \n Installing MySQL ... $Color_Off"
sudo apt-get install -y mysql-server
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASS';
FLUSH PRIVILEGES;
exit
EOF

echo -e "$Yellow \n Restarting Mysql Service $Color_Off"
sudo service mysql restart
echo -e "$Green \n Installing Mysql Done $Color_Off"

# [*] Install PhpMyAdmin
echo -e "$Cyan \n Installing phpMyAdmin $Color_Off"
sudo apt-get install -y phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html
sudo systemctl restart nginx
echo -e "$Green \n Installing PhpMyAdmin Done $Color_Off"


# [*] Git
echo -e "$Cyan \n Installing Git ... $Color_Off"
sudo apt-get install -y git-core
[[ ! -z "$GIT_USER" ]] && git config --global user.name "$GIT_USER"
[[ ! -z "$GIT_EMAIL" ]] && git config --global user.email "$GIT_EMAIL" 
git config --list
echo -e "$Green \n Git has been Installed and Configured $Color_Off"


# [*] Installing Composer
echo -e "$Cyan \n Installing Composer ... $Color_Off"
# curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chown $USER $COMPOSER_PATH
[[ ! -f $ALIASES ]] && touch $ALIASES > /dev/null 2>&1 && echo "File $ALIASES created ..."
echo -e "$Cyan \n Getting Laravel installer ... $Color_Off"
composer global require "laravel/installer"
tee -a $ALIASES > /dev/null <<EOT
alias laravel="$COMPOSER_PATH/vendor/bin/laravel"
alias art="php artisan"
alias migrate="php artisan migrate"
alias db-reset="php artisan migrate:reset && php artisan migrate --seed"
alias laravel-clear="art view:clear && art clear && art route:clear && art cache:clear && art config:clear"
alias laravel-flush="art queue:flush && art queue:restart && art horizon:purge  && sudo supervisorctl restart all"
alias l-clear="sudo chmod -R 777 storage/ && sudo chmod -R 777 bootstrap/cache/ && laravel-clear && composer dump-autoload"
EOT
echo -e "$Yellow \n Reloading $USER Profile ... $Color_Off"
source ~/.bashrc
echo -e "$Green \n PHP Composer Installed $Color_Off"

# [*] Node JS
echo -e "$Cyan \n Installing Nodejs ... $Color_Off"
sudo apt-get install -y nodejs
echo -e "$Green \n Node JS Installed $Color_Off"
node -v
echo -e "$Cyan \n Installing NPM ... $Color_Off"
sudo apt install -y npm
echo -e "$Green \n NPM Installed $Color_Off"
npm -v

# [*] Firewall
echo -e "$Cyan \n Configuring FireWall ... $Color_Off"
sudo ufw enable
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw allow 1433
echo -e "$Green \n FireWall Configured $Color_Off"

# [*] Install REDIS
echo -e "$Cyan \n Installing Redis Server ... $Color_Off"
sudo apt-get install -y redis-server
echo -e "$Green \n Redis Installed $Color_Off"

# [*] Install Supervisord
echo -e "$Cyan \n Installing supervisor ... $Color_Off"
sudo apt-get install -y supervisor
echo -e "$Green \n Supervisor Installed $Color_Off"

# [*] Configure Permissions
echo -e "$Cyan \n Configuring Permissions for /var/www $Color_Off"
sudo usermod -aG www-data $USER
sudo chown -R www-data:www-data /var/www/
sudo chmod -R 775 /var/www/
groups $USER
echo -e "$Yellow \n Reloading $USER Profile ... $Color_Off"
source ~/.bashrc
echo -e "$Green \n Permissions to HTML Dir have been set sucessfully $Color_Off"


echo -e "$Red \n Installation Process Completed $Color_Off ... $Yellow Code something amazing !!!  $Color_Off"
