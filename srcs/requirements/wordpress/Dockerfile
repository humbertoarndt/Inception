# # Setting OS
# FROM debian:buster

# # Update and upgrade packages
# RUN apt update -y
# RUN apt upgrade -y

# # Install WGET, PHP and its dependencies, MariaDB Client
# RUN apt-get install -y \
#     wget \
#     php7.3 \
#     php-fpm \
#     php-mysql \
#     mariadb-client \
#     nano

# # Install WordPress
# RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www

# # De-tar WordPress and remove '.tar'
# RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz

# # Grant root privilege
# RUN chown -R root:root /var/www/wordpress

# # Copy '50-server-cnf' file
# # COPY conf/wp-setting.php /var/www/wordpress/wp-setting.php

################################
FROM debian:buster

RUN apt update && apt install -y \
	php7.3-fpm\
	php7.3-mysqli \
	mariadb-client \
	wget \
	curl \
	unzip

# Dowload wp cli para realizar comandos wordpress via linha de comando
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /bin/wp && wp cli update

# Criando a pasta do wordpress
RUN mkdir -p var/www/html/wordpress

# Mudando as permissoes, users e grupos
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# Dowload do wordpress pelo wp cli.
RUN wp core download --allow-root --path=/var/www/html/wordpress

# Colocando o PHP-FPM pra rodar na porta 9000
RUN sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 0.0.0.0:9000/' /etc/php/7.3/fpm/pool.d/www.conf

# Criando o diretorio aonde vai rodar o PHP-FPM
RUN mkdir -p /run/php && chmod 755 /var/run/php

#copiando o script que vai criar a base de dados e users.
COPY tools/wp-config.php /var/www/html/wordpress
# COPY tools/wpconfig.sh ./script.sh

# Alterando as permissoes pata o docker conseguir executar
# RUN chmod 755 script.sh

# expondo a porta e chamando o script
EXPOSE 9000
# CMD ["bash", "./script.sh"]