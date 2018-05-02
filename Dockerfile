FROM jenkins/jnlp-slave
USER root

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ=Europe/London
ENV DOCKER_CHANNEL edge
ENV DOCKER_VERSION 18.04.0-ce
ENV DOCKER_ARCH x86_64

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
	apt-get clean

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install Docker from Docker Inc. repositories.
RUN set -ex; \
    if ! curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz"; then \
        echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${DOCKER_ARCH}'"; \
        exit 1; \
    fi; \
    \
    tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /usr/local/bin/ \
    ; \
    rm docker.tgz; \
    \
    dockerd -v; \
    docker -v
COPY modprobe.sh /usr/local/bin/modprobe
COPY docker-entrypoint.sh /usr/local/bin/

RUN curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash"]

