#!/bin/sh

# Set shell script directives:
# - e: exit with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe

# If database isn't already configured
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    # Initializes the MariaDB data directory and creates the system tables that it contains.
    # This step is necessary for the creation and setup of /var/lib/mysql,
    # a directory that the MySQL dameon will need to access later on.
    mysql_install_db

    # Initializes MySQL dameon
    /etc/init.d/mysql start

    # Replicate the behavior of mysql_secure_installation
    # This script allows you to improve the security of your MariaDB installation by letting you:
    # - Set a password for root accounts;
    mysql -e "SET old_passwords=0; UPDATE mysql.user SET Password=PASSWORD('$DB_ROOT_USER') WHERE User='$DB_ROOT_PASS';"
    
    # - Remove anonymous-user accounts;
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DELETE FROM mysql.user WHERE User='';"
    
    # - Remove root accounts that are accessible from outside the local host;
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    
    # - Remove the test database, which by default can be accessed by anonymous users.
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DROP DATABASE IF EXISTS test;"
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

    # Creates a new database with the name specified in the .env file, if it doesn't already exists
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    
    # Grants all privileges on all databases and tables to the root user
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_ROOT_USER'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"
    
    # Grants all privileges on WordPress' database to the common user, and set it's password
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER_USER'@'%' IDENTIFIED BY '$DB_USER_PASS';"
    
    # Udate MariaDB's privilege table with the newly made changes
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "FLUSH PRIVILEGES;"

    # Imports the database backup from the dump file, generated previously with all configurations already set
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -hlocalhost $DB_NAME < /tmp/dump.sql
    
    # Terminates MySQL daemon
    # This step is more of a good practice, the daemon will be started again in the exec line, anyways
    mysqladmin -u$DB_ROOT_USER -p$DB_ROOT_PASS shutdown
fi

# Execute any commands given to the container
# Defaults to command present in Dockerfile:
# mysqld --bind-address=0.0.0.0
exec "$@"
