# Setting OS
FROM debian:buster

# Update and upgrade packages
RUN apt update -y
RUN apt upgrade -y

# Install MariaDB
RUN apt-get install mariadb-server -y

# Install vim to edit container files
RUN apt install nano -y

# Copy '50-server-cnf' file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT ["/run.sh"]