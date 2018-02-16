#!/usr/bin/env bash
source config.sh

if [ -z "$1" ]; then
    read -p "Enter the domain name: " DOMAIN
else
    DOMAIN=$1
fi

start "Creating SSL certificate and key"

mkdir -p "$DIR_ETC/openssl"
mkdir -p "$DIR_ETC/openssl/certs"
cat > $DIR_ETC/openssl/openssl_tmp.cnf <<-EOF
  [req]
  distinguished_name = req_distinguished_name
  x509_extensions = v3_req
  prompt = no
  [req_distinguished_name]
  CN = *.$DOMAIN
  [v3_req]
  basicConstraints = CA:FALSE
  keyUsage = nonRepudiation, digitalSignature, keyEncipherment
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
  -keyout $DIR_ETC/openssl/certs/$DOMAIN.key \
  -out $DIR_ETC/openssl/certs/$DOMAIN.crt \
  -config $DIR_ETC/openssl/openssl_tmp.cnf &> /dev/null
  
rm $DIR_ETC/openssl/openssl_tmp.cnf

success
echo "      > $DIR_ETC/openssl/certs/$DOMAIN.crt"
echo "      > $DIR_ETC/openssl/certs/$DOMAIN.key"

if [ $OS="LINUX" ]; then
	start "Adding to database"
	certutil -d sql:$HOME/.pki/nssdb -A -t "Pu,," -n $DOMAIN -i "$DIR_ETC/openssl/certs/$DOMAIN.crt" &> /dev/null   
	success
fi