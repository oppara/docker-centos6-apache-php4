FROM centos:6.9

RUN cp -p /usr/share/zoneinfo/Japan /etc/localtime \
    && echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock \
    && echo 'UTC="false"' >> /etc/sysconfig/clock  \
    && source /etc/sysconfig/clock \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum --setopt=tsflags=nodocs -y install \
    gcc \
    gcc-c++ \
    git \
    flex \
    wget \
    httpd-devel \
    mod_ssl \
    libxml2-devel \
    openssl-devel \
    bzip2-devel \
    libcurl-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    freetype-devel \
    libicu-devel \
    postgresql-devel \
    readline-devel \
    libxslt-devel \
    && yum clean all

COPY src /src
WORKDIR /src
RUN tar xvf php-4.4.9.tar.bz2 && \
    cp -f openssl.c php-4.4.9/ext/openssl/openssl.c

WORKDIR /src/php-4.4.9/
RUN sed -i 's|$i/lib/|$i/lib64/|g' configure && \
    ./configure \
    --with-config-file-path=/etc \
    --with-config-file-scan-dir=/etc/php.d \
    --with-apxs2=/usr/sbin/apxs \
    --with-pgsql=/usr/lib64/pgsql \
    --enable-mbstring \
    --enable-pcntl \
    --enable-mbregex \
    --enable-mbstr-enc-trans \
    --with-mysql \
    --with-gd \
    --with-dom \
    --with-zlib-dir=/usr \
    --enable-gd-native-ttf \
    --with-freetype-dir=/usr \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    --with-iconv \
    --with-curl \
    --enable-versioning \
    --enable-dbx \
    --with-emoji \
    --with-authcheck \
    --enable-ftp \
    --with-libdir=lib64 \
    --with-openssl=shared \
    --enable-zip && \
    make && make install && \
    cp -f php.ini-dist /etc/php.ini

RUN rm -rf /src

RUN sed -i -e 's/memory_limit = 8M/memory_limit = 64M/g' -e 's/post_max_size = 8M/post_max_size = 24M/g' -e 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g' /etc/php.ini

COPY etc/httpd-php.conf /etc/httpd/conf.d/php.conf
EXPOSE 80 443

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]

WORKDIR /var/www/html
