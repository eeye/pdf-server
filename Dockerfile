FROM ubuntu:14.04
MAINTAINER Sharoon Thomas <sharoon.thomas@openlabs.co.in>

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Download and install wkhtmltopdf
RUN apt-get install -y build-essential xorg libssl-dev libxrender-dev wget gdebi
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
RUN gdebi --n wkhtmltox-0.12.2.1_linux-trusty-amd64.deb

RUN apt-get update && apt-get install -y --no-install-recommends \
		apache2 \
		software-properties-common \
		supervisor \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y --no-install-recommends \
                libapache2-mod-php5.6 \
                php5.6 \
                php5.6-cli \
                php5.6-curl \
                php5.6-dev \
                php5.6-gd \
                php5.6-imap \
                php5.6-mbstring \
                php5.6-mcrypt \
                php5.6-mysql \
                php5.6-pgsql \
                php5.6-pspell \
                php5.6-xml \
                php5.6-xmlrpc \
                php-apcu \
                php-memcached \
                php-pear \
                php-redis \
        && apt-get clean \
        && rm -fr /var/lib/apt/lists/*

RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY run.sh /run.sh
RUN chmod 755 /run.sh

COPY config /config


EXPOSE 80
CMD ["/run.sh"]

