#!/bin/bash -e

PHP_MINOR_VERSION=$1

echo "Building layer for PHP 7.$PHP_MINOR_VERSION - using Remi repository"

yum install -y wget
yum install -y yum-utils
wget https://archives.fedoraproject.org/pub/archive/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget https://rpms.remirepo.net/enterprise/remi-release-6.rpm --no-check-certificate
rpm -Uvh epel-release-6-8.noarch.rpm
rpm -Uvh remi-release-6.rpm

yum-config-manager --enable remi-php7${PHP_MINOR_VERSION}

yum install -y httpd
yum install -y postgresql-devel
yum install -y libargon2-devel
yum install -y oniguruma5php
yum install -y --disablerepo="*" --enablerepo="remi,remi-php7${PHP_MINOR_VERSION}" php php-mbstring php-pdo php-mysql php-pgsql php-xml php-process


mkdir /tmp/layer
cd /tmp/layer
cp /opt/layer/bootstrap bootstrap
sed "s/PHP_MINOR_VERSION/${PHP_MINOR_VERSION}/g" /opt/layer/php.ini >php.ini

mkdir bin
cp /usr/bin/php bin/

mkdir lib
for lib in libncurses.so.5 libtinfo.so.5 libpcre.so.0; do
  cp "/lib64/${lib}" lib/
done

cp /usr/lib64/libedit.so.0 lib/
cp /usr/lib64/libargon2.so.0 lib/
cp /usr/lib64/libpq.so.5 lib/
cp /usr/lib64/libonig.so.105 lib/

mkdir -p lib/php/7.${PHP_MINOR_VERSION}
cp -a /usr/lib64/php/modules lib/php/7.${PHP_MINOR_VERSION}/

zip -r /opt/layer/php7${PHP_MINOR_VERSION}.zip .

