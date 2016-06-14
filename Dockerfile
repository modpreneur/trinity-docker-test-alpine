FROM php:7.0-alpine

MAINTAINER Barbora Čápová <capova@modpreneur.com>

RUN apk add --update \
    sqlite \
    curl \
    wget \
    git \
    nano \
    gcc \
    make \
    autoconf \
    libc-dev

RUN docker-php-ext-install curl zip mbstring opcache pdo_sqlite bcmath \
#    && docker-php-ext-configure bcmath \
    && curl -sS https://getcomposer.org/installer | php \
    && cp composer.phar /usr/bin/composer \
    && echo "alias composer=\"php -n -d extenstdodion=mbstring.so -d extension=zip.so -d extension=bcmath.so /usr/bin/composer\"" >> /etc/bash.bashrc


ADD docker/php.ini /usr/local/etc/php/

RUN pecl install apcu \
 && echo "extension=apcu.so" >> /usr/local/etc/php/php.ini

RUN wget https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

ENV TERM xterm