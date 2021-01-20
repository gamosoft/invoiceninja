FROM debian:stretch-20191014

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get --assume-yes update && apt-get --assume-yes upgrade
RUN apt-get --assume-yes install apt-utils
RUN apt-get --assume-yes install git procps vim unzip wget dialog
RUN apt-get --assume-yes install mysql-server dos2unix
RUN apt-get --assume-yes install nginx
RUN apt-get --assume-yes install php7.0 php7.0-fpm php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-mysql php7.0-xml php7.0-mcrypt php7.0-mbstring
 
RUN wget https://download.invoiceninja.com/ -O /tmp/invoice-ninja.zip && \
    unzip /tmp/invoice-ninja.zip -d /var/www/html/

RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && \
    ~/.bash_it/install.sh -s

# This takes a while
RUN chown -R www-data: /var/www/html/ninja

ENV MYSQL_ROOT_PASSWORD=somep@ssw0rdForSQL

COPY create_ninja.sql /docker-entrypoint-initdb.d/
RUN /etc/init.d/mysql start && mysql < /docker-entrypoint-initdb.d/create_ninja.sql

# Overwite app environment so we don't need to do setup
COPY .env /var/www/html/ninja/
RUN chown www-data:www-data /var/www/html/ninja/.env

# Overwrite nginx default configuration
COPY default /etc/nginx/sites-enabled/
# Start all 3 services
COPY services.sh /services.sh
# For rpi, need to enable run permissions
RUN chmod +x services.sh
# Remove non-unix line endings
RUN dos2unix services.sh

CMD ["/services.sh"]
