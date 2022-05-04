#!/bin/bash
# program
# 本地创建nginx文件夹和php文件夹，检查docker和docker-compose程序，检查端口80和3306 开启交换空间

# set new mysql password
new_password="this_is_password"
old_password="this_is_password"
sed -i "s/${old_password}/${new_password}}/g" ./install_web.sh
sed -i "s/${old_password}/${new_password}}/g" ./docker-compose.yaml
sed -i "s/${old_password}/${new_password}}/g" ./podman-compose.yaml
old_password=new_password

mkdir ~/php 
mkdir ~/nginx
mkdir ~/mysql
mkdir -p /var/cache/swap/ &&\
dd if=/dev/zero of=/var/cache/swap/swap0 bs=64M count=64 &&\
chmod 0600 /var/cache/swap/swap0 &&\
mkswap /var/cache/swap/swap0 && \
swapon /var/cache/swap/swap0 && \
swapon -s || echo "swap has error maybe false when installing php"