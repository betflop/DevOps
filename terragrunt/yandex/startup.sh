#!/bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- "s/nginx/Yandex Cloud - ${HOSTNAME}/" /var/www/html/index.nginx-debian.html
EOF 
