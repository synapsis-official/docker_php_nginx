# Nginx with PHP-FPM

Official Docker Image of Synaps.is

## Example

```dockerfile
FROM syis/php-nginx:alpine-7.4

COPY docker/ngnx/cond.d/ /etc/nginx/conf.d/

EXPOSE 8080
```

## Links

- [Docker Hub](https://hub.docker.com/r/syis/php-nginx)

## Tags

- [alpine-7.4](https://github.com/synapsis-official/docker_php_nginx/tree/alpine-7.4)
