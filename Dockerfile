# syis/php-nginx:tagname

FROM php:7.4-fpm-alpine3.12

MAINTAINER fabrizio@fubelli.org

# Nginx stable: https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine/Dockerfile
RUN apk --update add bash curl nginx openssl autoconf \
    dpkg-dev dpkg file g++ gcc libc-dev make re2c

# Install the required PHP extensions
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

ARG composer_hash='756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3'

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
