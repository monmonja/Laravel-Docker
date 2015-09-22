FROM ubuntu:14.04
MAINTAINER "Almond Joseph Mendoza" <almondmendoza@gmail.com>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add image configuration and scripts
ADD docker/start-apache2.sh /start-apache2.sh
ADD docker/start-mysqld.sh /start-mysqld.sh
ADD docker/run.sh /run.sh
RUN chmod 755 /*.sh
ADD docker/my.cnf /etc/mysql/conf.d/my.cnf
ADD docker/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD docker/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD docker/create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# config to enable .htaccess
ADD docker/apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN php5enmod opcache
RUN php5enmod mcrypt

# Configure /app folder with sample app
COPY www /var/www/html

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80 3306
CMD ["/run.sh"]