# Setting current penultimate stable version from Debian
FROM debian:bullseye

ARG DB_ROOT_USER
ARG DB_ROOT_PASS
ARG DB_NAME
ARG DB_USER_USER
ARG DB_USER_PASS

# Install packages:
# - mariadb-* - required, mariadb itself
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client

# Create necessary directories:
# - /var/run/mysqld: needed by the MySQL daemon to run, it stores the socket file
# Change it's owner and permissions to be accessible by MySQL under any circumstance
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

RUN touch /var/run/mysqld/mysqld.sock /var/run/mysqld/mysqld.pid && \
    chown -R mysql:mysql /var/run/mysqld/mysqld.sock && \
    chown -R mysql:mysql /var/run/mysqld/mysqld.sock && \
    chmod -R 644 /var/run/mysqld/mysqld.sock

# Copy setup script to local bin directory
COPY ./tools/setup.sh /usr/local/bin

# Change setup script permissions so it becomes executable
RUN chmod +x /usr/local/bin/setup.sh

# Copy database dump file to temporary directory, since it will only be used once
COPY ./conf/dump.sql /tmp

#RUN service mariadb start

# Expose port 3306 for communication with other containers
EXPOSE 3306

COPY ./conf/my.cnf /etc/mysql/my.cnf

# Set entrypoint to be setup script
RUN ./usr/local/bin/setup.sh

# Run MySQL daemon with address binding to 0.0.0.0*
CMD ["mysqld_safe"]
# *The --bind-address option specifies the IP address to which the server should bind to. 
# Setting it to 0.0.0.0 means that the server will listen on all available network interfaces, 
# which is useful for exposing the MySQL server to other containers.