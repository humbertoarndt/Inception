# Setting OS
FROM debian:buster

# Update packages and install NGINX
RUN apt update && apt install nginx -y

# Create folder to store certificate and key
RUN mkdir -p /etc/nginx/ssl

# Install SSL Certificate tool
RUN apt install OpenSSL -y

# Create a SSL Certificate
## 'req' Requests a certificate in PKCS#10 format
## '-x509' Certificate type
## '-nodes' Create key without password
## '-out' Indicates where to save the certificate
## '-keyout' Indicates where to save the key
RUN open req - x509 -out /etc/nginx/ssl/inception.crt -keyout etc/nginx/ssl/inception.key \
    -subj "/C=BR/ST=SP/L=Sao Paulo/O=Ecole 42/OU=42/CN=harndt.42.fr/UID=harndt"