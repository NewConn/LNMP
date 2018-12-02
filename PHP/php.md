# 编译php

### 下载php源码
wget http://mirrors.sohu.com/php/php-7.0.4.tar.gz

### 解压源码
tar -zxvf php-7.0.4.tar.gz
cd php/

### 配置安装参数
./configure --prefix=/data/php --with-gdbm --with-fpm-group=www --with-fpm-user=www --with-gettext --with-pear --enable-pcntl --enable-ftp --enable-sysvsem --enable-shmop --enable-bcmath --enable-shared --disable-rpath --enable-debug --with-openssl --with-mhash --with-mcrypt --with-mysql-sock=/data/mysql/run/mysql.sock --with-config-file-path=/data/php/etc --mandir=/data/php/man --libdir=/data/php/lib --includedir=/data/php/include --sbindir=/data/php/sbin --bindir=/data/php/bin --with-gd --with-jpeg-dir --with-freetype-dir --enable-sockets --enable-fpm --enable-mbstring --enable-soap --with-iconv-dir --with-png-dir --with-zlib --with-libxml-dir --with-curl --enable-gd-native-ttf --with-xmlrpc --enable-zip --enable-mysqlnd --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-bz2 --with-xsl --with-xpm-dir

### 安装 
make clean && make && make test && make install && make clean 


# 配置php

### 设置php目录及权限
mkdir /log/php
mkdir /data/php/session
mkdir /data/php/run
##### 如果在安装Nginx时已经添加过,忽略这一步
groupadd -g 80 www
useradd www -u 80 -g 80 -d /nonexistent -s /sbin/nologin

### 复制php.ini
cp php.ini-production /data/php/etc/php.ini

### 复制php-fpm, 从php5.3开始自带fpm，使用自带的管理脚本
cp sapi/fpm/init.d.php-fpm /data/php/etc/php-fpm

### 配置php-fpm.conf
cd /data/php/etc/
chmod 755 php-fpm
cp php-fpm.conf.default php-fpm.conf
vi php-fpm.conf

### 权限
chown -R www:www /data/php
chown -R www:www /log/php

### 配置php.ini
vi php.ini

### 配置www.conf
cp /data/php/etc/php-fpm.d/www.conf.default /data/php/etc/php-fpm.d/www.conf
vi /data/php/etc/php-fpm.d/www.conf

### 配置php-fpm
vi /data/php/etc/php-fpm


# 启动php
/data/php/etc/php-fpm start