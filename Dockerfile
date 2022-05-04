FROM ubuntu
MAINTAINER libestor
EXPOSE 80


WORKDIR /var/local/
COPY pcre pcre
COPY zlib zlib
COPY nginx nginx
COPY sqlite3 sqlite3
COPY openssl openssl
COPY php php
COPY wordpress wordpress
COPY install_web.sh .
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list  && \
    apt-get update && apt install -y make && \
    apt-get install -y g++ && apt-get install -y vim &&\
    apt-get install -y gcc && apt-get install -y  pkg-config && \
    apt-get install -y libxml2-dev &&\
    apt-get install -y libssl-dev &&\
    chmod +x /var/local/install_web.sh 
RUN bash /var/local/install_web.sh && apt-get remove g++ 
CMD php-fpm -y /root/php/config/php-fpm.conf && nginx
