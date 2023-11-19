#!/usr/bin/env bash

echo "Stopping all services"
pkill -9 mysqld
pkill -9 redis-server
pkill -9 php-fpm
pkill -9 nginx

echo "Running nc to verify that they are stopped..."
echo -e "\n\033[36mTesting MySQL\033[0m"
nc -zv 127.0.0.1 3306
echo -e "\n\033[36mTesting Redis\033[0m"
nc -zv 127.0.0.1 6379
echo -e "\n\033[36mTesting PHP-FPM\033[0m"
nc -zv 127.0.0.1 9000
echo -e "\n\033[36mTesting Nginx\033[0m"
nc -zv 127.0.0.1 80
