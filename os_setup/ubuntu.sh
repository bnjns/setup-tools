#!/bin/bash
source /etc/lsb-release

# Ensure that the DNS resolver is installed
sudo apt install -y resolvconf
sudo dpkg-reconfigure resolvconf
sudo systemctl restart network-manager.service

# Add any additional repos
sudo wget -qO - https://wavebox.io/dl/client/repo/archive.key | sudo apt-key add -
wget https://downloads.plex.tv/plex-keys/PlexSign.key -O - | sudo apt-key add -
echo "deb https://wavebox.io/dl/client/repo/ x86_64/" | sudo tee --append /etc/apt/sources.list.d/repo.list
echo "deb https://downloads.plex.tv/repo/deb ./public main" | sudo tee -a /etc/apt/sources.list.d/plex.list
sudo apt-add-repository -y ppa:ondrej/php
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386] http://mirrors.coreix.net/mariadb/repo/10.2/ubuntu zesty main'
sudo add-apt-repository ppa:serge-rider/dbeaver-ce
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo add-apt-repository universe
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$DISTRIB_RELEASE/ /' > /etc/apt/sources.list.d/albert.list"
wget -nv https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_17.10/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo rm Release.key

# Update the system
sudo apt update
sudo apt upgrade

# Drivers and tools
sudo apt install -y exfat-utils exfat-fuse
sudo apt install -y software-properties-common
sudo apt install -y curl
sudo apt install -y git
sudo apt install -y dnsmasq
sudo sh -c 'echo "address=/.dev/127.0.0.1" > /etc/dnsmasq.conf'
sudo sh -c 'echo "nameserver 127.0.0.1" > /etc/resolv.conf'
sudo systemctl start dnsmasq
sudo apt install -y guake

# Software
sudo apt install -y firefox
sudo apt install -y chromium-browser
sudo apt install -y wavebox
sudo apt install -y plexmediaserver
sudo apt install -y filezilla
sudo apt install -y dbeaver-ce
sudo apt install -y spotify-client
sudo apt install -y vlc
sudo apt install -y openvpn
modprobe tun
sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret libfreerdp-plugins-standard
sudo apt install -y albert

# Let plex see the folders
sudo usermod -aG bnjns plex
sudo chmod -R 775 /media/bnjns

# Web server
sudo apt install -y nginx
sudo apt install -y mariadb-server
mysql -u root -p <<EOF
use mysql;
CREATE USER 'bnjns'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'bnjns'@'localhost' WITH GRANT OPTION;
EOF
sudo apt install -y php7.2 php7.2-cli php7.2-common php7.2-json php7.2-opcache php7.2-mysql php7.2-mbstring               php7.2-zip php7.2-fpm
sudo apt install -y php7.1 php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-mysql php7.1-mbstring php7.1-mcrypt php7.1-zip php7.1-fpm
sudo apt install -y php7.0 php7.0-cli php7.0-common php7.0-json php7.0-opcache php7.0-mysql php7.0-mbstring php7.0-mcrypt php7.0-zip php7.0-fpm
sudo apt install -y php5.6 php5.6-cli php5.6-common php5.6-json php5.6-opcache php5.6-mysql php5.6-mbstring php5.6-mcrypt php5.6-zip php5.6-fpm
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y build-essential
sudo systemctl start nginx.service
sudo systemctl start mysql.service
sudo systemctl start php7.2-fpm.service
sudo systemctl start php7.1-fpm.service
sudo systemctl start php7.0-fpm.service
sudo systemctl start php5.6-fpm.service

# SSH key
mkdir -p /home/$USERNAME/.ssh
ssh-keygen -t rsa -C "email@address.invalid" -f /home/$USERNAME/.ssh/id_rsa
ssh-add /home/$USERNAME/.ssh/id_rsa

echo "PS1=\"\\h:\\w \\\\$ \"" >> /home/$USERNAME/.bashrc

# Tidy up default packages
sudo apt remove -y rhythmbox
sudo apt remove -y caffeine
sudo apt remove -y aisleriot
sudo apt remove -y budgie-welcome
sudo apt remove -y cheese
sudo apt remove -y geary
sudo apt remove -y gnome-mpv
sudo apt remove -y gthumb
sudo apt remove -y libreoffice*
sudo apt remove -y gnome-mahjongg
sudo apt remove -y transmission*
sudo apt remove -y tilix
sudo apt remove -y simple-scan
sudo apt remove -y gnome-mines
sudo apt remove -y gnome-calendar
sudo apt clean
sudo apt autoremove