#!/bin/sh

# Set shell script directives:
# - e: exits with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe

# If database isn't already configured
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    # Initializes the MariaDB data directory and creates the system tables that it contains.
    # This step necessary for the creation and setup of /var/lib/mysql,
    # a directory used by the MySQL daemon will use later on.
    mysql_install_db

    # Initializes MySQL dameon
    /etc/init.d/mysql start

    # Replicates the mysql_secure_installation's behavior
    # This script allows you to improve the security of your MariaDB installation by letting you:
    # - Set a password for root accounts
    mysql -e "SET old_passwords=0; UPDATE mysql.user SET Password=PASSWORD('$DB_ROOT_USER') WHERE User='$DB_ROOT_PASS';"

    # - Remove anonymous-user accounts
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DELETE FROM mysql.user WHERE User='';"

    # - Remove root accounts that are accessible from outside the local host
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

    # - Remove the test database, which by default can be accessed by anonymous users
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DROP DATABASE IF EXISTS test;"
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

    # Creates a new DB with the name specified on the .env file, if it doesn't exist
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME"

    # Grants all privileges on all databases tables to the root user
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_ROOT_USER'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"

    # Grants all privileges on WordPress' DB to the common user, and set it's password
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER_USER'@'%' IDENTIFIED BY '$DB_USER_PASS';"

    # Update MariaDB's privileges table with the newly made changes
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "FLUSH PRIVILEGES;"

    # Imports the DB backup from the dump file, generated previously with all configurations already set
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -hlocalhost $DB_NAME < /tmp/dump.sql

    # Terminates MySQL daemon
    # Using good practices, the daemon will be started again in the exec line
    mysqladmin -u$DB_ROOT_USER -p$DB_ROOT_PASS shutdown
fi

# Execute any command given to the container
# Defaults to command present in Dockerfile
# mysqld --bin-address=0.0.0.0
exec "$@"