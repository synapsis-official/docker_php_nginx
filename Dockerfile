# syis/php-nginx:tagname

FROM php:7.4-fpm-alpine3.12

MAINTAINER fabrizio@fubelli.org

# Nginx stable: https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine/Dockerfile
RUN apk --update add nginx
RUN mkdir -p /run/nginx

cp nginx/conf.d/ /etc/nginx/conf.d/

EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
