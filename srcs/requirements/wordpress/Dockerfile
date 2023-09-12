# Setting OS
FROM debian:buster

# Setting the working directory to /var/www/html, whic is WordPress' default
WORKDIR /var/www/html

# Update  packages
RUN apt-get update -y

# Install packages:
# - php*: PHP to run WordPress
# - wget: retrieve content from web servers
# - tar: file copressor
# - php-redis:
RUN apt-get install -y php-fpm php-mysql wget tar

# Create necessary directories
# - /run/php: used by php-form to run the PHP service
RUN mkdir -p /run/php

# Install wp-cli:
# - Commando Line Interface to manage WordPress installation
# - Allows operation such as update plugins and themes, manage user, perfmor backups, etc
RUN https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	mc wp-cli.phar /usr/local/bin/wp && \
	chmod +x /usr/local/bin/wp

# Alter PHP configuration file to listen on port 9000
RUN echo "\nlisten = 0.0.0.0:9000" >> /etc/php/7.3/fpm/pool.d/www.conf

# Copy setup script to local bin directory
COPY ./tools/setup.sh /usr/local/bin

# Making the setup script an executable
RUN chmod +x /usr/local/bin/setup.sh

# Expose port 9000 for communication between containers
EXPOSE 9000

# Setting setup script as entrypoint
ENTRYPOINT ["setup.sh"]

# Run php-fpm with -F option*
CMD ["php-fpm7.3", "-F"]

# *-F: makes php-fpm7.3 run in the background so log messages will show