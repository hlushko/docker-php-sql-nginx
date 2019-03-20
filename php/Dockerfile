FROM php:7.2-fpm

RUN apt-get update && apt-get install -y \
        git \
        mc \
        netcat \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        zip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        zip \
        bcmath \
        pdo_mysql \
        gd \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
        libssh2-1-dev libssh2-1 \
    && pecl install ssh2-1.1.2 \
    && docker-php-ext-enable ssh2 \
    && rm -rf /var/lib/apt/lists/*

# intl installation block start
ARG ICU_ARCHIVE
RUN curl -sS -o /tmp/icu.tar.gz -L $ICU_ARCHIVE \
    && tar -zxf /tmp/icu.tar.gz -C /tmp \
    && cd /tmp/icu/source \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && rm -rf /tmp/icu*

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN docker-php-ext-configure intl --with-icu-dir=/usr/local \
    && docker-php-ext-install intl \
    && rm -rf /var/lib/apt/lists/*
# intl installation block end

RUN curl -Ss https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY php.ini "$PHP_INI_DIR"/
COPY app.conf /usr/local/etc/php-fpm.d/

RUN mkdir -p /root/.ssh \
    && echo "\tHost *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# cron
# Add crontab file in the cron directory
ADD crontab /etc/cron.d/php-cron
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/php-cron
# Create the log file to be able to run tail
RUN touch /var/log/cron.log
# install
RUN apt-get update \
    && apt-get install -y \
        cron \
    && rm -rf /var/lib/apt/lists/*

ARG USER_ID
ENV USER_ID $USER_ID
ARG GROUP_ID
ENV GROUP_ID $GROUP_ID

RUN [ -z $(getent group $GROUP_ID | cut -d: -f1) ] && groupmod -g $GROUP_ID www-data || true
RUN usermod -u $USER_ID -g $GROUP_ID www-data

WORKDIR /var/www

EXPOSE 9001

COPY docker-entrypoint.sh /
COPY docker-php-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /docker-php-entrypoint.sh

RUN chown www-data:www-data /var/log/cron.log

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
