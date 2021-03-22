

FROM php:7.3.0-apache

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y wget
RUN apt-get install --fix-missing -y libpq-dev
RUN apt-get install --no-install-recommends -y libpq-dev
RUN apt-get install -y libxml2-dev libbz2-dev zlib1g-dev
RUN apt-get -y install libsqlite3-dev libsqlite3-0 mariadb-client curl exif ftp
RUN docker-php-ext-install intl
RUN apt-get -y install --fix-missing zip unzip

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN composer self-update

COPY ./data/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY data/ci-news ci-news

RUN chmod -R 0777 ci-news/writable

RUN apt-get clean \
    && rm -r /var/lib/apt/lists/*
    
VOLUME /var/www/html

RUN get_latest_release() { wget -qO- "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/';} && DD_LATEST_PHP_VERSION="$(get_latest_release DataDog/dd-trace-php)" &&  wget -q https://github.com/DataDog/dd-trace-php/releases/download/${DD_LATEST_PHP_VERSION}/datadog-php-tracer_${DD_LATEST_PHP_VERSION}_amd64.deb && dpkg -i datadog-php-tracer_${DD_LATEST_PHP_VERSION}_amd64.deb