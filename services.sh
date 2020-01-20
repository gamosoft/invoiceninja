#!/bin/bash

/etc/init.d/mysql start
service php7.0-fpm start
service nginx restart

echo "All services started"
while sleep 3600; do # if the script dies, the container closes!
  ps aux
done