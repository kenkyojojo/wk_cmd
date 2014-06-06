#! /bin/bash

# 解壓
tar xvzf httpd-2.2.11.tar.gz &&
tar xvzf php-5.3.0.tar.gz &&

# 設定 Apache
echo "Configure apache ...." &&
cd  httpd-2.2.11 &&
./configure --prefix=/usr/local/apache2 --enable-so &&
make &&
make install &&

# 設定/編譯/安裝 PHP
cd ../php-5.3.0 &&
./configure \
           --with-apxs2=/usr/local/apache2/bin/apxs \
           --with-mysql=/usr/local/mysql &&
make &&
make install &&

# 拷貝 php.ini 到 /usr/local/lib
cp -f php.ini-production /usr/local/lib/php.ini &&

echo
echo 'Done!'
echo
