# Setting OS
FROM debian:buster

# Update packages
RUN apt-get update -y

# Install packages:
# - nginx - web server
# - openssl - self-signed SSL certificates generator
RUN apt-get install -y nginx openssl

# Create directory to store SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generatre SSL trough openssl
# - req: command used to process certificate;
# - -x509: option to create a X.509 certificate, a standard format for digital certificates;
# - -nodes: option to not encrypt the private key, useful for development because won't require user input;
# - -days 365: option to set the period of validity of the self-signed certificate;
# - -newkey rsa:2048: option to set the type of the key, in this case, a RSA key with 2048 bits;
# - -keyout: option to set the path where the key will be stored;
# - -out: otpion to set the path where the certificate will be stored;
# - -subj: option to set the certificate's subject specifications, such as:
#   - C: specify country;
#   - ST: specify state;
#   - L: specify locale;
#   - O: specify organization;
#   - CN: specify commom name, A.K.A. domain name.
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/harndt.key                   \
    -out /etc/nginx/ssl/harndt.crt                      \
    -subj "/C=BR/ST=SP/L=Sao Paulo/O=42SP/CN=harndt.42.fr/"

# Copy the nginx configuration file to nginx's default configuration directory
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 443 for communication between containers
EXPOSE 443

# Run nginx without daemon, m
CMD ["nginx", "-g", "daemon off;"]