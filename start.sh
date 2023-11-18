#!/usr/bin/env bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo ".env file not found"
    exit 1
fi

## MySQL
## 
## Port: 3306
## ====================================================================
mkdir -p "$(pwd)/mysql/data/"
MYSQL_DATA_DIR="$(pwd)/mysql/data/"

mysqld \
    --datadir="${MYSQL_DATA_DIR}" \
    --pid-file="${MYSQL_DATA_DIR}mysqld.pid" \
    --socket="${MYSQL_DATA_DIR}mysqld.sock" \
    --bind-address=127.0.0.1 \
    --port=3306 \
    --skip-grant-tables &

## Redis
##
## Port: 6379
## ====================================================================
mkdir -p "$(pwd)/redis/data/"
mkdir -p "$(pwd)/redis/log/"

redis-server ./redis/redis.conf &

## PHP-FPM
##
## Port: 9000
## ====================================================================
mkdir -p "$(pwd)/php-fpm/log/"

export PHP_FPM_CONF_PATH="$(pwd)/php-fpm"
envsubst '${PHP_FPM_CONF_PATH}' < php-fpm/php-fpm.conf.template > php-fpm/php-fpm.conf

php-fpm -y ./php-fpm/php-fpm.conf &

## Nginx
#
# Port: 80
## ====================================================================
mkdir -p "$(pwd)/nginx/run/"
mkdir -p "$(pwd)/nginx/log/"
mkdir -p "$(pwd)/nginx/temp/"

export NGINX_PID_PATH="$(pwd)/nginx/run"
export NGINX_LOG_PATH="$(pwd)/nginx/log"
export NGINX_TEMP_PATH="$(pwd)/nginx/temp"

# envsubst will replace the variables in the template file with the values. In order for
# it to ignore the variables that are not defined, we need to set them as
# __VARIABLE_NAME__ in the template file. Then we use sed to replace the __VARIABLE_NAME__
# with the actual variable name.
envsubst '${NGINX_PID_PATH},${NGINX_LOG_PATH},${NGINX_TEMP_PATH},${NGINX_ROOT_PATH}' < nginx/nginx.conf.template > nginx/nginx.conf
sed -i'' -e 's|__DOCUMENT_ROOT____FASTCGI_SCRIPT_NAME__|\$document_root\$fastcgi_script_name|' nginx/nginx.conf
sed -i'' -e 's|__URI__|\$uri|g' nginx/nginx.conf
sed -i'' -e 's|__QUERY_STRING__|\$query_string|g' nginx/nginx.conf

nginx -c "$(pwd)/nginx/nginx.conf" &


