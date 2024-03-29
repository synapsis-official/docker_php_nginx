# Nginx with PHP-FPM and Composer

Official Docker Image of [Synaps.is](https://synaps.is)

## Docker Image content

- [Alpine Linux](https://alpinelinux.org)
- [PHP FPM](https://www.php.net/)
- [Nginx](https://www.nginx.com/)
- [Composer](https://getcomposer.org/)

## Dockerfile Example

```dockerfile
FROM syis/php-nginx:7.4-alpine

# Install necessary packages
RUN apk --update add \
    libzip-dev gmp-dev libsodium-dev openssl-dev \
    npm mongo-c-driver

# Install the required PHP extensions
RUN docker-php-ext-configure zip \
    && docker-php-ext-install -j$(grep -c ^processor /proc/cpuinfo 2> /dev/null || 1) \
        zip gmp \
    && docker-php-ext-install sodium \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-source delete \
    && rm -rf /tmp/* /var/cache/apk/* \
    && pecl config-set php_ini /etc/php.ini

RUN mkdir -p /var/www/app
WORKDIR /var/www/app

# Install composer packages
COPY composer.json ./
COPY composer.lock ./
# Install npm packages
COPY package.json ./
COPY package-lock.json ./

RUN composer install --no-scripts --no-autoloader --no-interaction --no-progress
RUN npm install

# Copy application files
COPY . ./

RUN composer dump-autoload --optimize
RUN npm run prod

# Copy nginx default virtual host
COPY docker/nginx/default.conf /etc/nginx/conf.d/

# Expose ports listened by your "default.conf"
EXPOSE 80
```

## Build

```shell
docker build . -t syis/php-nginx:8.1-alpine
docker push syis/php-nginx:8.1-alpine
```

## Links

- [Docker Hub](https://hub.docker.com/r/syis/php-nginx)

## Tags

- [7.4-alpine](https://github.com/synapsis-official/docker_php_nginx/tree/alpine-7.4)
- [7.4-alpine-dev](https://github.com/synapsis-official/docker_php_nginx/tree/alpine-7.4-dev)
- [8.1-alpine](https://github.com/synapsis-official/docker_php_nginx/tree/8.1-alpine)
- [8.1-alpine-dev](https://github.com/synapsis-official/docker_php_nginx/tree/8.1-alpine-dev)
