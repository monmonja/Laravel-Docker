*********************
REQUIREMENTS
*********************
nodejs
docker (see below)
curl
unzip

*********************
DOWNLOAD LARAVEL, INSTALL BOWER, GULP
*********************
    ./create_app.sh

# world permission is okay for development purpose
    sudo chmod -R 777 www
    sudo chmod -R guo+w www/storage

*********************
INSTALL DOCKER
*********************
download and install https://github.com/boot2docker/osx-installer/releases/tag/v1.5.0
open terminal execute these
     mkdir ~/.boot2docker
     echo 'ISOURL="https://github.com/boot2docker/boot2docker/releases/download/v1.5.0/boot2docker.iso"' > ~/.boot2docker/profile
     boot2docker init
     boot2docker start
     boot2docker shellinit



******************
CREATE IMAGE
******************
    cd <this folder>
    docker build -t apache_php .


******************
RUN IMAGE
******************
    eval "$(boot2docker shellinit)"
    docker run -v "$(pwd)/www":/var/www/html --name apache_php-test -e PHP_ERROR_REPORTING='E_ALL & ~E_STRICT' -d -p 80:80 apache_php
    open http://$(boot2docker ip 2>/dev/null)/

# -e PHP_ERROR_REPORTING='E_ALL & ~E_STRICT'

*********************
REMOVE RUNNING IMAGE
*********************
    docker stop apache_php-test && docker rm apache_php-test


************************
CLEAN UP LOCAL CACHE
************************
# Delete all containers
    docker rm -f $(docker ps -a -q)
# Delete all images
    docker rmi -f $(docker images -q)


************************
SSH TO RUNNING IMAGE
************************
docker exec -it $(docker ps -q  2>&1 | (head -n1 )) /bin/bash

************************
SSH TO CONTAINER
************************
docker run -i -t apache_php /bin/bash



# not enabled extension
/etc/php-5.6.d/20-mssql.ini
/etc/php-5.6.d/30-wddx.ini


# check error log
login to running image (see above)
    tail -f /var/log/apache2/error.log