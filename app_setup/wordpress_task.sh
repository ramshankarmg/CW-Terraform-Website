#!/bin/bash

yum update -y
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install httpd php70w php70w-mysql  mysql -y

# Enable AllowOverride All in httpd.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd-backup.conf
sed -i '151s/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

#Wait for RDS to come up
until mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -e "show processlist"; do echo 'sleeping 1 minute'; sleep 1m ; done

# Install Wordpress using WP-CLI
cd /var/www/html/
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
DBEXISTS=$(mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -e "SHOW DATABASES LIKE '"${DB_NAME}"';" | grep "$DBNAME" > /dev/null; echo "$?")
if [ $DBEXISTS -eq 0 ];then
    echo "A database with the name ${DB_NAME} already exists."
else
    echo "Creating the mysql database ${DB_NAME}"
    mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -e "create database ${DB_NAME}"
fi

wp core download
wp core config --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=${DB_HOST}
wp core install --url="${elb_dns_name}" --title="${WP_TITLE}" --admin_user=${WP_USER} --admin_password=${WP_PASS} --admin_email=${WP_EMAIL}
chmod -R 755 wp-content
chown -R apache:apache wp-content

# Append to wp-config.php
cat <<EOF >> /var/www/html/wp-config.php
define('WP_HOME', '/');
define('WP_SITEURL', '/');
EOF

# Start httpd
service httpd start
chkconfig httpd on
