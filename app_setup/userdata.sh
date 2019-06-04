#!/bin/bash

#Install the required packages
apt-get update -y
apt-get install apache2 -y
sudo ufw allow in "Apache Full"
sudo apt install php libapache2-mod-php php-mysql mysql-client -y

#Wait until RDS is up,sometimes during first install race condition can occur causing failure
until mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -e "show processlist"; do echo 'sleeping 1 minute'; sleep 1m ; done

#Install the application
cd /var/www/html
git clone https://github.com/xxxVxxx/crud-php-simple.git
cd /var/www/html/crud-php-simple

#Populate and create the custom config.php file
cat << EOF > config.php
<?php

\$databaseHost = '${DB_HOST}';
\$databaseName = '${DB_NAME}';
\$databaseUsername = '${DB_USER}';
\$databasePassword = '${DB_PASSWORD}';

\$mysqli = mysqli_connect(\$databaseHost, \$databaseUsername, \$databasePassword, \$databaseName); 
 
?>
EOF
chmod 644 config.php

#Work on the database
DBEXISTS=$(mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -e "SHOW DATABASES LIKE '"${DB_NAME}"';" | grep "$DBNAME" > /dev/null; echo "$?")
if [ $DBEXISTS -eq 0 ];then
    echo "A database with the name ${DB_NAME} already exists."
else
    echo "Creating the mysql database ${DB_NAME}"
    mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -e "create database ${DB_NAME}"
    mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} ${DB_NAME} < database.sql    
fi

