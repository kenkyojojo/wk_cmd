#! /bin/bash

# 設定版本編號及 MySQL 安裝路徑
ApacheVersion="httpd-2.2.11"
PHPVersion="php-5.3.0"
MYSQLHOME="/usr/local/mysql"

# 解壓
tar xvzf $ApacheVersion.tar.gz &&
tar xvzf $PHPVersion.tar.gz &&

# 設定 Apache
echo "Configure apache ...." &&
cd $ApacheVersion &&
./configure --prefix=/usr/local/apache2 --enable-so &&
make &&
make install &&

# 設定/編譯/安裝 PHP
cd ../$PHPVersion &&
./configure \
           --with-apxs2=/usr/local/apache2/bin/apxs \
           --with-mysql=$MYSQLHOME &&
make &&
make install &&

# 拷貝 php.ini 到 /usr/local/lib
cp -f php.ini-production /usr/local/lib/php.ini &&

echo
echo 'Done!'
echo
