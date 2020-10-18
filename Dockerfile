FROM php:7.1-fpm

#COPY conf/php.ini /etc/php/7.1/fpm/conf.d/40-custom.ini
COPY conf/php.ini /usr/local/etc/php/conf.d/custom.ini

RUN chmod o+r /etc/resolv.conf

# Install required packages
RUN apt-get update && \
    apt-get install -y wget git zip sendmail libpng-dev libjpeg62-turbo-dev mariadb-client

# Install phpunit
RUN wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

# Install PHP mbstring extention
RUN docker-php-ext-install mbstring

# Install the PHP gd library
RUN docker-php-ext-configure gd \
    --with-jpeg-dir=/usr/include && \
    docker-php-ext-install gd

# Install PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql bcmath sockets zip

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug