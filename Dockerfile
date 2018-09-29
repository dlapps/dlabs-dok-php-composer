FROM debian:latest

# Noninteractive installs
RUN apt-get clean && \
    apt-get update && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# System environment setup
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive

# Configure common tools
RUN apt-get install -y \
        vim \
        curl \
        wget \
        unzip \
        git;

# PHP
RUN apt-get install -y apt-transport-https lsb-release ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y php7.2-cli php7.2-zip php7.2-xml php7.2-mbstring;

ADD composer.sh /root/composer.sh

RUN /root/composer.sh && \
mv composer.phar /usr/local/bin/composer;