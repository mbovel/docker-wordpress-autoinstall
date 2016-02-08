FROM php:5
MAINTAINER Matthieu Bovel <matthieu@bovel.net>

# install the PHP extensions we need
RUN apt-get update \
 && apt-get install -y libpng12-dev libjpeg-dev less \
 && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
 && docker-php-ext-install gd mysqli opcache

# Install WP-CLI (http://wp-cli.org)
RUN curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x /bin/wp

# Install dockerize (https://github.com/jwilder/dockerize)
ENV DOCKERIZE_RELEASE v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz
RUN curl -sL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_RELEASE} \
  | tar -C /usr/bin -xzvf -

# Clean up
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a directory for the WordPress installation
RUN mkdir wp
WORKDIR wp

# Create a user to run wp-cli commands (running as root is strongly discouraged)
# @see https://github.com/wp-cli/wp-cli/pull/973#issuecomment-35842969
RUN useradd -d /wp -s /bin/bash wp \
 && chown -R wp .
USER wp

# WordPress version can be changed at build time using `docker build --build-arg WORDPRESS_VERSION=4.4.2 .`
ARG WORDPRESS_VERSION=4.4.2
# TODO: add support for 'latest', Problem: doesn't work with `wp core verify-checksums`

# Download WordPress and verify the checksum
RUN wp core download --version=${WORDPRESS_VERSION} \
 && wp core verify-checksums --version=${WORDPRESS_VERSION}

EXPOSE 8080

# Configure and install WordPress
CMD wp core config \
    --dbhost=${MYSQL_HOST:-db}:${MYSQL_PORT:-3306} \
    --dbuser=${MYSQL_USER:-root} \
    --dbpass=${MYSQL_PASSWORD:-root} \
    --dbname=${MYSQL_DATABASE:-wp} \
    --skip-check \
 # Wait for the database to be ready
 && echo tcp://${MYSQL_HOST:-db}:{MYSQL_PORT:-3306} \
 && dockerize -wait tcp://${MYSQL_HOST:-db}:${MYSQL_PORT:-3306} -timeout 30s \
 && wp core install \
    --url=${WORDPRESS_URL:-localhost} \
    --title=${WORDPRESS_TITLE:-'WordPress site'} \
    --admin_user=${WORDPRESS_ADMIN_USER:-admin} \
    --admin_password=${WORDPRESS_ADMIN_PASSWORD:-admin} \
    --admin_email=${WORDPRESS_ADMIN_MAIL:-admin@example.com} \
 && wp option update permalink_structure '/%year%/%monthnum%/%day%/%postname%/' \
 && wp server --host=0.0.0.0:8080
# 0.0.0.0: accepts connexions from everywhere
# @see http://stackoverflow.com/questions/25591413/docker-with-php-built-in-server

# TODO: an apache version, Problem: root needed to start apache