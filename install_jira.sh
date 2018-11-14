#!/usr/bin/env bash

if [[ $OSTYPE != *"linux"* ]]; then
	echo "Only linux is supported."
	exit 1;
else
	. /etc/lsb-release
	if [[ $(echo $DISTRIB_ID | tr '[:lower:]' '[:upper:]') != "ubuntu" ]]; then
		echo "Only ubuntu is supported.";
	fi
fi

if (( UID != 0 )); then exec sudo -E "$0" ${1+"$@"}; fi

echo -ne "Enter the domain name: "
read -s DOMAIN
echo

echo -ne "Enter the db password: "
read -s DB_PASS
echo

# Install JDK
apt update && apt upgrade
apt install openjdk-8-jdk

# Download Jira
cd /tmp
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.12.3-x64.bin
wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz
chmod a+x atlassian-jira-software-7.12.3-x64.bin
tar -xvzf mysql-connector-java-5.1.39.tar.gz

# Set up MySQL database
apt install mariadb-server
mysql_secure_installation
mysql <<EOF
use mysql;
CREATE DATABASE jira CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL ON jira.* to 'jira'@'localhost' IDENTIFIED BY '$DB_PASS';
FLUSH PRIVILEGES;
EOF

# Set up Jira
./atlassian-jira-software-7.12.3-x64.bin
service jira stop
cp /tmp/mysql-connector-java-5.1.39/*.jar /opt/atlassian/jira/lib

# Install HTTPs certificate
apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install certbot
certbot certonly --standalone -d $DOMAIN

cat << EOF | sudo tee /etc/nginx/sites-available/jira.conf
server {
 listen 443 ssl;
 server_name $DOMAIN;
 keepalive_timeout 70;
 ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
 ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
 ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
 ssl_ciphers HIGH:!aNULL:!MD5;
 ssl_session_cache shared:SSL:10m;
 ssl_session_timeout 1d;
 large_client_header_buffers 4 32k;
 gzip on;
 gzip_min_length 10240;
 gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml;
 location / {
 proxy_pass http://localhost:8080;
 proxy_set_header X-Forwarded-Host \$host;
 proxy_set_header X-Forwarded-Server \$host;
 proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
 client_max_body_size 30M;
 proxy_connect_timeout 300;
 proxy_send_timeout 300;
 proxy_read_timeout 300;
 send_timeout 300;
 }
}
EOF
ln -s /etc/nginx/sites-available/jira.conf /etc/nginx/sites-enabled/jira.conf
service nginx stop
service nginx start

service jira stop
service jira start