FROM ubuntu:14.04
MAINTAINER "Almond Joseph Mendoza" <almondmendoza@gmail.com>

VOLUME ["/var/www"]

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    LANG=C.UTF-8 add-apt-repository ppa:ondrej/php5-5.6 && \
    apt-get update

RUN apt-get install -y apache2


RUN apt-get install -y debhelper build-essential autoconf automake1.9 libtool flex bison binutils-gold git automake shtool  php5-dev


RUN apt-get install -y php5 \
      php5-cli \
      libapache2-mod-php5

RUN apt-get install -y php5-apcu \
      php5-gd \
      php5-curl \
      php5-json \
      php5-intl \
      php5-imagick \
      php5-gmp \
      php5-ldap \
      php5-mcrypt \
      php5-memcache \
      php5-memcached \
      php5-mysqlnd \
      php5-oauth \
      php5-pgsql \
      php5-sqlite \
      php5-ssh2 \
      php5-xmlrpc \
      php-calendar

RUN apt-get install -y nodejs npm

# apc
COPY docker/get_igbinary /usr/local/bin/get_igbinary
RUN chmod +x /usr/local/bin/get_igbinary
RUN /usr/local/bin/get_igbinary
COPY docker/apc.ini /etc/php5/apache2/conf.d/apc.ini

# apache config
COPY docker/apache_default /etc/apache2/sites-available/000-default.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# php reporting
COPY docker/run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

# index.php
ADD www/. /var/www/html

RUN a2enmod rewrite
RUN php5enmod opcache
RUN service apache2 restart

EXPOSE 80
CMD ["/usr/local/bin/run"]

