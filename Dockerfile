FROM php:7.1-alpine

MAINTAINER Martin Kolek <kolek@modpreneur.com>

RUN apk add --update \
    sqlite-dev \
    curl-dev \
    bzip2-dev \
    libmcrypt-dev \
    wget \
    git \
    nano \
    gcc \
    make \
    autoconf \
    libc-dev \
    nano \
    fish

RUN docker-php-ext-install curl json mbstring opcache zip bz2 mcrypt bcmath pdo_sqlite

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer \
    && touch /usr/local/etc/php/php.ini \
    && echo "memory_limit = 2048M" >> /usr/local/etc/php/php.ini \
    && mkdir -p /root/.config/fish/functions \
    && echo "alias codecept=\"php /var/app/vendor/codeception/codeception/codecept\"" >> /root/.config/fish/functions/codecept.fish

RUN pecl install -o -f apcu-5.1.8 apcu_bc-beta \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini \
    && echo "extension=apc.so" >> /usr/local/etc/php/conf.d/apcu.ini

RUN wget https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.profiler_output_dir=/var/app/var/xdebug/" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/php.ini \
    && echo "alias composer=\"php -n -d memory_limit=2048M -d extension=bcmath.so -d extension=zip.so /usr/bin/composer\"" >> /root/.config/fish/functions/composer.fish

ENV TERM fish