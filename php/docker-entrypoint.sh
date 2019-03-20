#!/bin/sh
set -e

printenv | grep -v "no_proxy" >> /etc/environment

cron -f &
docker-php-entrypoint php-fpm
