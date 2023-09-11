# Setting up MySQL
service mysql start;

# Create table
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Create user
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

# Grant user permissions
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Modify 'root user'
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Flush MySQL
mysql -e "FLUSH PRIVILEGES"

# Restarting MySQL
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# Launch with the recommended command
exec mysqld_safe