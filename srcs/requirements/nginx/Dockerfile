# Setting OS
FROM debian:buster

# Update and upgrade packages
RUN apt update -y
RUN apt upgrade -y

# Install NGINX
RUN apt install nginx -y

# Install vim to edit container files
RUN apt install nano -y

# Create folder to store certificate and key
RUN mkdir -p /etc/nginx/ssl

# Install SSL Certificate tool
RUN apt install openssl -y

# Create a SSL Certificate
## 'req' Requests a certificate in PKCS#10 format
## '-x509' Certificate type
## '-nodes' Create key without password
## '-out' Indicates where to save the certificate
## '-keyout' Indicates where to save the key
## '-subj' Certificate information
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=BR/ST=SP/L=Sao Paulo/O=Ecole 42/OU=42/CN=harndt.42.fr/UID=harndt"

# Create folder to store NGINX files and copy nginx.conf file
RUN mkdir -p /var/run/nginx
COPY conf/nginx.conf etc/nginx/nginx.conf

# Define privileges
RUN chmod 755 /var/www/html
run chown -R www-data:www-data /var/www/html

# Launch NGINX in the background
CMD ["nginx", "-g", "daemon off;"]