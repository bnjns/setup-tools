#!/bin/bash
source /etc/lsb-release
EXTENSION_TMP_DIR=/home/$USERNAME/gnome-extensions
EXTENSION_DIR=/home/$USERNAME/.local/share/gnome-shell/extensions/

# Ensure that the DNS resolver is installed
sudo apt install -y resolvconf
sudo dpkg-reconfigure resolvconf
sudo systemctl restart network-manager.service
sleep 15

# Add any additional repos
sudo wget -qO - https://wavebox.io/dl/client/repo/archive.key | sudo apt-key add -
sudo sh -c "echo 'deb https://wavebox.io/dl/client/repo/ x86_64/' > /etc/apt/sources.list.d/wavebox.list"
sudo wget -qO - https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo sh -c "echo 'deb https://downloads.plex.tv/repo/deb/ public main' > /etc/apt/sources.list.d/plex.list"
sudo apt-add-repository -y ppa:ondrej/php
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386] http://mirrors.coreix.net/mariadb/repo/10.2/ubuntu zesty main'
sudo add-apt-repository -y ppa:serge-rider/dbeaver-ce
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
sudo sh -c "echo 'deb http://repository.spotify.com stable non-free' > /etc/apt/sources.list.d/spotify.list"
sudo add-apt-repository universe
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo wget -qO - "https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_$DISTRIB_RELEASE/Release.key" | sudo apt-key add -
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$DISTRIB_RELEASE/ /' > /etc/apt/sources.list.d/albert.list"
sudo wget -qO - https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian $DISTRIB_CODENAME contrib' > /etc/apt/sources.list.d/virtualbox.list"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/chrome.list'

# Update the system
sudo apt update
sudo apt upgrade -y

# Drivers and tools
sudo apt install -y exfat-utils exfat-fuse
sudo apt install -y software-properties-common
sudo apt install -y curl
sudo apt install -y git
sudo apt install -y dnsmasq
sudo sh -c 'echo "address=/.dev/127.0.0.1" > /etc/dnsmasq.conf'
sudo sh -c 'echo "nameserver 127.0.0.1" > /etc/resolv.conf'
sudo systemctl restart dnsmasq
sudo apt install -y guake
sudo apt install -y ttf-mscorefonts-installer
sudo apt install -y libnss3-tools

# Software
sudo apt install -y firefox
sudo apt install -y google-chrome-stable
sudo apt install -y wavebox
sudo apt install -y plexmediaserver
sudo apt install -y filezilla
sudo apt install -y dbeaver-ce
sudo apt install -y spotify-client
sudo apt install -y vlc
sudo apt install -y openvpn
sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret libfreerdp-plugins-standard
sudo apt install -y albert
sudo apt install -y virtualbox-5.2
sudo apt install -y texmaker
sudo apt install -y gparted
wget -qO - https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.6.2914.tar.gz | tar -C ~/Downloads/ --strip-components=1 -xz -f -
~/Downloads/jetbrains-toolbox
rm ~/Downloads/jetbrains-toolbox

# Web server
sudo apt install -y nginx
sudo apt install -y mariadb-server
mysql -u root -p <<EOF
use mysql;
CREATE USER 'bnjns'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'bnjns'@'localhost' WITH GRANT OPTION;
EOF
sudo apt install -y php7.2 php7.2-cli php7.2-common php7.2-json php7.2-opcache php7.2-mysql php7.2-mbstring               php7.2-zip php7.2-fpm php7.2-xml
sudo apt install -y php7.1 php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-mysql php7.1-mbstring php7.1-mcrypt php7.1-zip php7.1-fpm php7.1-xml
sudo apt install -y php7.0 php7.0-cli php7.0-common php7.0-json php7.0-opcache php7.0-mysql php7.0-mbstring php7.0-mcrypt php7.0-zip php7.0-fpm php7.0-xml
sudo apt install -y php5.6 php5.6-cli php5.6-common php5.6-json php5.6-opcache php5.6-mysql php5.6-mbstring php5.6-mcrypt php5.6-zip php5.6-fpm php5.6-xml
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y build-essential
sudo systemctl start nginx.service
sudo systemctl start mysql.service
sudo systemctl start php7.2-fpm.service
sudo systemctl start php7.1-fpm.service
sudo systemctl start php7.0-fpm.service
sudo systemctl start php5.6-fpm.service

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
sudo apt remove -y gnome-sudoku
sudo apt remove -y gnome-shell-extension-ubuntu-dock
sudo apt clean
sudo apt autoremove

# Add the necessary startup applications
sudo mkdir -p /mnt/plex
sudo mkdir -p /mnt/Data

# Let plex see the drive
sudo usermod -aG bnjns plex
sudo chmod -R 775 /mnt/plex

# Enable auto mounting of the desktop drives
#sudo sh -c 'echo "/dev/disk/by-uuid/0073B0C03D070BC8 /mnt/Data ntfs  rw,auto,user,fmask=0111,dmask=0000,nofail 0 0" >> /etc/fstab'
#sudo sh -c 'echo "/dev/disk/by-uuid/57D5-2763        /mnt/plex exfat rw,auto,user,fmask=0111,dmask=0000,nofail 0 0" >> /etc/fstab'
# Enable auto mounting of the laptop drives
#sudo sh -c 'echo "/dev/disk/by-uuid/5A50-DDC5        /mnt/Data exfat rw,nosuid,nodev,relatime,user_id=0,group_id=0,default_permissions,allow_other,blksize=4096,uhelper=udisks2,nofail 0 0" >> /etc/fstab'

# Install various GNOME extensions
#mkdir -p $EXTENSION_TMP_DIR
mkdir -p $EXTENSION_DIR
sh $DIR_BASE/gnome-extension-manager --install --extension-id 964
sh $DIR_BASE/gnome-extension-manager --install --extension-id 1253
sh $DIR_BASE/gnome-extension-manager --install --extension-id 545
sh $DIR_BASE/gnome-extension-manager --install --extension-id 7
sh $DIR_BASE/gnome-extension-manager --install --extension-id 937

# Set up the SSL database
mkdir -p ~/.pki && mkdir -p ~/.pki/nssdb
certutil -d sql:$HOME/.pki/nssdb -N