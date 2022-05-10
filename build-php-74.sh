#!/bin/bash -e

PHP_MINOR_VERSION=4

echo "Building layer for PHP 7.$PHP_MINOR_VERSION - using amazon linux extras repository"

yum install -y amazon-linux-extras wget yum-utils
amazon-linux-extras enable php7.4
yum clean metadata

yum install -y  php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap}

yum install -y httpd postgresql-devel libargon2-devel oniguruma5php

mkdir /tmp/layer
cd /tmp/layer
cp /opt/layer/bootstrap bootstrap
sed "s/PHP_MINOR_VERSION/${PHP_MINOR_VERSION}/g" /opt/layer/php.ini >php.ini

mkdir bin
cp /usr/bin/php bin/

/usr/bin/php -v

ls -lh /lib64/

mkdir lib
for lib in libncurses.so.6 libtinfo.so.6 libpcre.so.1; do
  cp "/lib64/${lib}" lib/
done

ls -lh /usr/lib64/

cp /usr/lib64/libedit.so.0 lib/
#cp /usr/lib64/libargon2.so.0 lib/
cp /usr/lib64/libpq.so.5 lib/
cp /usr/lib64/libonig.so.2 lib/

mkdir -p lib/php/7.${PHP_MINOR_VERSION}
cp -a /usr/lib64/php/modules lib/php/7.${PHP_MINOR_VERSION}/

zip -r /opt/layer/php7${PHP_MINOR_VERSION}.zip .

