FROM jenkins/jnlp-slave
USER root
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        lsb-release \
        ca-certificates \
    && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        jq \
        php7.1 \
        php-xdebug\
        php7.1-mysql \
        php7.1-curl \
        php-apcu \
        php7.1-gd \
        php7.1-intl \
        php7.1-imap \
        php7.1-cli \
        php7.1-mcrypt \
        php7.1-soap \
        php7.1-sqlite \
        php7.1-opcache \
        php7.1-ldap \
        php7.1-mbstring \
        php7.1-json \
        php7.1-xml \
        php7.1-zip \
        php7.1-bcmath \
        php7.1-pspell \
        mysql-client \
        curl \
        inetutils-ping \
        host \
		build-essential \
		inetutils-ping \
        host \
        curl \
        unzip \
        git \
        ca-certificates \
	&& \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer
USER jenkins