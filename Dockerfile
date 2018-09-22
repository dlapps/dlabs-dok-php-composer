FROM debian:latest

# Noninteractive installs
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y locales && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    locale-gen en_US.UTF-8

# System environment setup
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    HOME=/root \
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

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer;