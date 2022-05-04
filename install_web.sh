#!/bin/bash
# progrem:
#   install pcre zlib openssl sqlite3 nginx php wordpress
password="this_is_password"
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
function printf() {
    if [ $1 == '1' ];then
        echo "pcre has installed"
    elif [ $1 == '2' ]; then
        echo "pcre and zlib has installed"
    elif [ $1 == '3' ]; then
        echo "pcre  zlib and sqlite3 has installed"
    elif [ $1 == '4' ]; then
        echo "pcre zlib sqlite3 and openssl has installed"
    elif [ $1 == '5' ]; then
        echo "pcre zlib sqlite3 openssl and nginx has installed"
    elif [ $1 == '6' ]; then
        echo "pcre zlib sqlite3 openssl nginx and php has installed" 
    fi
}
function install(){
    cd /var/local/pcre || echo "pcre file error"  exit 0
    ./configure || echo "pcre configure error" exit 0
    make || echo "pcre make error" exit 0
    make install || echo "pcre install error" exit 0
    cd /var/local/zlib || echo "zlib file error" printf 1  exit 0
    ./configure || echo "zlib configure error"  printf 1  exit 0
    make || echo "zlib make error" printf 1  exit 0
    make install || echo "zlib make install" printf 1  exit 0
    cd /var/local/sqlite3 || echo "sqlite3 file error" printf 2  exit 0
    ./configure || echo "sqlite3 configure error" printf 2  exit 0
    make || echo "sqlite3 make error" printf 2  exit 0
    make install || echo "sqlite3 make install" printf 2  exit 0
    cd /var/local/openssl || echo "openssl file error" printf 3  exit 0
    ./config || echo "openssl configure error" printf 3  exit 0
    make || echo " openssl make error" printf 3 exit 0
    make install || echo " openssl make install error" printf 3   exit 0
    cd /var/local/nginx || echo "nginx file error" printf 4  exit 0
    ./configure --with-openssl=/usr/local/ssl \
     --conf-path=/root/nginx/nginx.conf \
     --error-log-path=/root/nginx/logs/error.log \
     --user=www-data \
     --group=www-data || echo "nginx configure error" printf 4  exit 0
    make || echo " nginx make error" printf 4  exit 0
    make install || echo " nginx make install error" printf 4  exit 0
    cd /var/local/php || echo "php file error" printf 5  exit 0
    ./configure \
     --enable-fpm \
     --with-mysqli --with-zlib \
     --prefix=/usr/local/php \
     --with-config-file-path=/root/php/config/ \
     --with-openssl || echo "php configure error" printf 5  exit 0
    make || echo " php make error(maybe memroy is not enougth)" printf 5  exit 0
    make install || echo " php make install error" printf 5  exit 0
    printf 6 
    ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
    ln -s /usr/local/php/bin/phpize /usr/bin/phpize
    ln -s /usr/local/php/bin/php /usr/bin/php
    ln -s /usr/local/php/sbin/php-fpm /usr/bin/php-fpm
    
    echo "all app has installed"

}
function write_config()
{   #echo "ok"
    # php.ini
    [ -e /root/php/ ] || mkdir /root/php/
    mkdir /root/php/log 
    mkdir /root/php/config && \
    cp /var/local/php/php.ini-production /root/php/config/php.ini
    sed -i "s/;error_log = php_errors.log/error_log = \/root\/php\/log\/error_log/g" /root/php/config/php.ini
    # nginx.conf
    # ok
    sed -i "s/#user  nobody;/user  www-data;/g" /root/nginx/nginx.conf
    # ok
    sed -i "65,71s/\#/ /g" /root/nginx/nginx.conf
    # ok
    sed -i "s/SCRIPT_FILENAME  \/scripts/SCRIPT_FILENAME  \$document_root/1" /root/nginx/nginx.conf
    sed -i "44s/html/\/var\/www\/html\/wordpress\//1" /root/nginx/nginx.conf
    sed -i "66s/html/\/var\/www\/html\/wordpress\//1" /root/nginx/nginx.conf
    sed -i "45s/index.html/index.html index.php/1" /root/nginx/nginx.conf

    # php-fom.conf
    
    cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
    sed -i "s/;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/g" /usr/local/php/etc/php-fpm.conf
    sed -i "s/;error_log = log\/php-fpm.log/error_log = \/root\/php\/log\/php-fpm.log/g" /usr/local/php/etc/php-fpm.conf
    cp /usr/local/php/etc/php-fpm.conf /root/php/config/php-fpm.conf
    # www-data.conf
    cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
    # ok
    sed -i "s/user = nobody/user = www-data/g" /usr/local/php/etc/php-fpm.d/www.conf
    # ok
    sed -i "s/group = nobody/group = www-data/g" /usr/local/php/etc/php-fpm.d/www.conf
    # ok
    sed -i "s/;slowlog = log\/\$pool.log.slow/slowlog = \/root\/php\/log\/\$pool.log.slow/g" /usr/local/php/etc/php-fpm.d/www.conf
    # ok
    sed -i "s/;request_slowlog_timeout = 0/request_slowlog_timeout = 5/g" /usr/local/php/etc/php-fpm.d/www.conf
    # wordpress
    mkdir /var/www
    mkdir /var/www/html
    cp -r /var/local/wordpress/ /var/www/html/
    cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php &&\
    sed -i "s/database_name_here/wordpress/1" /var/www/html/wordpress/wp-config.php && \
    sed -i "s/username_here/root/1" /var/www/html/wordpress/wp-config.php && \
    sed -i "s/password_here/${password}/1" /var/www/html/wordpress/wp-config.php &&\
    sed -i "s/localhost/mysql/1" /var/www/html/wordpress/wp-config.php || echo "wordpress config is error"

}

install
write_config && echo "All server configed" || echo "Some server has error" 
php-fpm -y /root/php/config/php-fpm.conf && nginx && echo "All server has running" || echo "some server not running"