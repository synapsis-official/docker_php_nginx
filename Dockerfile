# syis/php-nginx:tagname

FROM php:7.4-fpm-alpine3.12

MAINTAINER fabrizio@fubelli.org

# Nginx stable: https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine/Dockerfile
RUN apk --update add bash \
    curl \
    nginx \
    openssl \
    libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

RUN mkdir -p /run/nginx && mkdir /run/php

COPY nginx/conf.d/ /etc/nginx/conf.d/
COPY php-fpm/ /usr/local/etc/php-fpm.d/
COPY entrypoint.sh /usr/local/bin/

EXPOSE 80 443

STOPSIGNAL SIGQUIT

# TODO: fix php-fpm
# ENTRYPOINT "/usr/local/bin/entrypoint.sh"
# CMD ["docker-php-entrypoint", "php-fpm", "-D"]
# CMD ["nginx", "-g", "daemon off;"]
CMD ["/usr/local/bin/entrypoint.sh"]
