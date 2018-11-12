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
        jq \
        php7.2 \
        php-xdebug\
        php7.2-mysql \
        php7.2-curl \
        php-apcu \
        php7.2-gd \
        php7.2-intl \
        php7.2-imap \
        php7.2-cli \
        php7.2-soap \
        php7.2-sqlite \
        php7.2-opcache \
        php7.2-ldap \
        php7.2-mbstring \
        php7.2-json \
        php7.2-xml \
        php7.2-zip \
        php7.2-bcmath \
        php7.2-pspell \
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

RUN php --version && curl -sS https://getcomposer.org/installer | php && \
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
    chmod +x /usr/local/bin/docker-compose && \
    composer config -g github-oauth.github.com 32070f30709e862ac3cceb7731a98a091438a113

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh
COPY gitconfig /home/jenkins/.gitconfig

