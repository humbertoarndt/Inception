# Setting OS
FROM debian:buster

# Update packages
RUN apt-get update -y

# Install packages:
# - mariadb-* - required, mariadb itself
RUN apt-get install -y mariadb-server mariadb-client

# Create necessary directory
# - /var/un/mysqld: is needed by MySQL daemon to run
# Grant permissions to be accessible by MySQL
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# Copy setup script to /local/bin directory
COPY ./tools/setup.sh /usr/local/bin

# Grant permission to execute setup script
# - +x: makes it executable
RUN chmod +x /usr/local/bin/setup.sh

# Copy databse dump file into a temporary directory
COPY ./conf/dump.sql /temp

# Expose port 3306 for communication between containers
EXPOSE 3306

# Set entrypoint to be the setup script
ENTRYPOINT ["setup.sh"]

# Run MySQL daemon using addres 0.0.0.0*
CMD ["mysql", "--bind-address=0.0.0.0"]

# *The --bind-address option specifies the IP address to which the server should bind to. 
# Setting it to 0.0.0.0 means that the server will listen on all available network interfaces, 
# which is useful for exposing the MySQL server to other containers.