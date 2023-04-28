# syis/php-nginx:tagname

FROM php:8.1-fpm-alpine3.17

MAINTAINER fabrizio@fubelli.org

# Nginx stable: https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine/Dockerfile
RUN apk --update add linux-headers bash curl nginx openssl autoconf \
    dpkg-dev dpkg file g++ gcc libc-dev make re2c

# Install the required PHP extensions
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

ARG composer_hash='55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae'

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '${composer_hash}') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN mkdir -p /run/nginx

# Set application name
ENV HOST_NAME=localhost

# Set xdebug params
ENV XDEBUG_ENABLED=true
ENV XDEBUG_REMOTE_HOST=host.docker.internal
ENV PHP_IDE_CONFIG="serverName=Docker"

COPY nginx/default.conf /etc/nginx/conf.d/
COPY php-fpm/ /usr/local/etc/php-fpm.d/
COPY php/conf.d/ /usr/local/etc/php/conf.d/
COPY start-php-fpm-nginx.sh /usr/local/bin/start-php-fpm-nginx

EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD start-php-fpm-nginx
