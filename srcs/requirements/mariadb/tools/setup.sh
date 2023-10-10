#!/bin/sh

# Set shell script directives:
# - e: exit with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe
service mariadb start

mysql -u root -p"${DB_ROOT_PASS}" << EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
GRANT ALL ON ${DB_NAME}.* TO '${DB_USER_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -D ${DB_NAME}  < /tmp/dump.sql