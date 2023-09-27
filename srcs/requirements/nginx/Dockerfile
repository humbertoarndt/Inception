FROM debian:buster

# Install packages:
# - nginx - required, nginx itself
# - openssl - used to create self-signed SSL certificates
RUN apt-get update && \
    apt-get install -y nginx openssl

# Create necessary directories:
# - /etc/nginx/ssl: directory where the certificates will be stored on
RUN mkdir -p /etc/nginx/ssl

# Generate the self-signed SSL certificates using openssl:
# - req: command used to process certificate;
# - -x509: option to create a X.509 certificate, which is a standard format for digital certificates;
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
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=BR/ST=SP/L=Indaiatuba/O=42SP/CN=harndt.42.fr"

# Copy the nginx configuration file to nginx's default configuration directory
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 443 for communication with the web and other containers
EXPOSE 443

# Run nginx without daemon*
CMD ["nginx", "-g", "daemon off;"]

# *The `daemon off` option is used to prevent nginx from running in the background as a daemon.
# Instead, it runs in the foreground and logs messages to the standard output and error streams normally.