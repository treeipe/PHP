FROM php:5.6.40-fpm

LABEL maintainer='André Vitor Cuba de Miranda <avandrevitor@gmail.com>'

RUN apt-get update --yes && apt-get install --yes \
 apt-utils \
 autoconf \
 bzip2 \
 curl \
 gettext \
 git \
 g++ \
 firebird-dev \
 freetds-bin \
 freetds-dev \
 freetds-common \
 iproute2 \
 make \
 libbz2-dev \
 libicu-dev \
 libfreetype6-dev \
 libgd-dev \
 libjpeg62-turbo-dev \
 libmcrypt-dev \
 libpng-dev \
 libpq-dev \
 libtidy-dev \
 libxslt-dev \
 libxml2-dev \
 subversion \
 tar \
 unzip \
 zlib1g-dev \
 libzip-dev \
 zip \
 && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
 && ln -s /usr/lib/x86_64-linux-gnu/libldap_r.so /usr/lib/libldap.so \
 && ln -s /usr/lib/x86_64-linux-gnu/libldap_r.a /usr/lib/libldap_r.a \
 && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
 && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so

# Install Extensions
RUN docker-php-ext-install \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  intl \
  interbase \
  mbstring \
  mcrypt \
  mysql \
  mysqli \
  pdo \
  pdo_firebird \
  pdo_mysql \
  pdo_pgsql \
  pdo_dblib \
  pgsql \
  soap \
  sockets \
  tidy \
  xmlrpc \
  xsl \
  zip

RUN docker-php-ext-configure hash --with-mhash
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure zip --with-libzip

# Time Zone && Memory Limit
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
    && echo "date.timezone=America/Sao_Paulo" > $PHP_INI_DIR/conf.d/date_timezone.ini

# SET timezone
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Composer Parallel
RUN composer global require hirak/prestissimo

# Install OpCache
RUN docker-php-ext-configure opcache && \
    docker-php-ext-install opcache

RUN echo "opcache.enable=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.validate_timestamps=0" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.max_accelerated_files=65406" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.memory_consumption=512" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.interned_strings_buffer=12" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.fast_shutdown=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.enable_file_override=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.error_log=php://stdout" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "realpath_cache_size=4096K" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "realpath_cache_ttl=7200" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini

# Install XDebug
RUN pecl install xdebug-2.5.0 \
  && docker-php-ext-enable xdebug \
  && echo "xdebug.default_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.coverage_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.file_link_format=PHPSTORM://%f@%l" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_cookie_expire_time=3600" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && /sbin/ip route|awk '/default/ { print $3 }' | xargs echo "xdebug.remote_host=$1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_mode=req" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port=9009" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Clean
RUN apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* \
    /tmp/* /var/tmp/* \
    /usr/share/doc/* \
    /var/cache/apt/archives/partial/* \
    /var/cache/apt/archives/* \
    /var/cache/apt/pkgcache.bin \
    /var/cache/apt/srcpkgcache.bin \
  && docker-php-source delete
