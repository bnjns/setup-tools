#!/bin/bash
source config.sh

if [ -z "$1" ]; then
    read -p "Enter the domain name: " DOMAIN
else
    DOMAIN=$1
fi

OS=$(getOS)
case "$OS" in
    LINUX* ) DIR=/etc;;
    OSX* )   DIR=/usr/local/etc;;
    * )
        echo -e $COLOUR_TEXT_RED"ERROR: Operating system '$OS' not supported."$COLOUR_RESET
        exit 1
esac

start "Creating $DIR/openssl/certs/$DOMAIN.crt"

mkdir -p "$DIR/openssl"
mkdir -p "$DIR/openssl/certs"
cat > $DIR/openssl/openssl_tmp.cnf <<-EOF
  [req]
  distinguished_name = req_distinguished_name
  x509_extensions = v3_req
  prompt = no
  [req_distinguished_name]
  CN = *.$DOMAIN
  [v3_req]
  keyUsage = keyEncipherment, dataEncipherment
  extendedKeyUsage = serverAuth
  subjectAltName = @alt_names
  [alt_names]
  DNS.1 = *.$DOMAIN
  DNS.2 = $DOMAIN
EOF

openssl req \
  -new \
  -newkey rsa:2048 \
  -sha1 \
  -days 3650 \
  -nodes \
  -x509 \
  -keyout $DIR/openssl/certs/$DOMAIN.key \
  -out $DIR/openssl/certs/$DOMAIN.crt \
  -config $DIR/openssl/openssl_tmp.cnf &> /dev/null
  
rm $DIR/openssl/openssl_tmp.cnf

success