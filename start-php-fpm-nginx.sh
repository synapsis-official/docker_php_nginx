#!/bin/bash

docker-php-entrypoint php-fpm -D
nginx -g 'daemon off;'
