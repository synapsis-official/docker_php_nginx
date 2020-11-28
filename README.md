# Nginx with PHP-FPM and Composer

Official Docker Image of Synaps.is

## Example

```dockerfile
FROM syis/php-nginx:alpine-7.4

RUN mkdir -p /var/www/app
WORKDIR /var/www/app

COPY composer.json ./
COPY composer.lock ./

RUN composer install --no-scripts --no-autoloader --no-interaction --no-progress

COPY . ./

RUN composer dump-autoload --optimize

# Copy nginx default virtual host
COPY docker/nginx/default.conf /etc/nginx/conf.d/

EXPOSE 80
```

## Links

- [Docker Hub](https://hub.docker.com/r/syis/php-nginx)

## Tags

- [alpine-7.4](https://github.com/synapsis-official/docker_php_nginx/tree/alpine-7.4)
