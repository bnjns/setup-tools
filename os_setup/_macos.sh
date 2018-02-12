#!/usr/bin/env bash

# Ensure xcode command line tools are installed
xcode-select --install

# Install Ruby
rvm install ruby
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
brew install rbenv

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Tap repositories
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/php
brew tap homebrew/apache
brew tap homebrew/services
brew tap caskroom/cask

# Verify homebrew install
brew doctor
brew update
brew upgrade

# Install tools
brew install wget
brew install git
brew install openssl
brew install cmake
brew install duti
brew install python
brew install dnsmasq
mkdir -p /usr/local/etc
sudo mkdir -p /etc/resolver
sudo sh -c 'echo "address=/.dev/127.0.0.1" > /usr/local/etc/dnsmasq.conf'
sudo sh -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
sudo brew services start dnsmasq
brew install mas
mas signin ben.jones27@gmail.com
wget -O ~/MacTeX.pkg http://tug.org/cgi-bin/mactex-download/MacTeX.pkg
sudo installer -pkg ~/MacTex.pkg -target /
rm ~/MacTeX.pkg
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Software
brew cask install alfred
brew cask install bartender
mas install 836505650 # Battery Monitor
brew cask install discord
brew cask install google-chrome
brew cask install google-backup-and-sync
brew cask install firefox
brew cask install hazel
brew cask install iterm2
brew cask install latexdraw
brew cask install little-snitch
mas install 441258766 # Magnet
brew cask install microsoft-office
mas install 1295203466 # Remote Desktop
mas install 1055273043 # PDF Expert
brew cask install jetbrains-toolbox
brew cask install https://raw.githubusercontent.com/caskroom/homebrew-cask/9e48616f20a9f9bf87015edd644876f9f9619115/Casks/qlab.rb
brew cask install sequel-pro
brew cask install spotify
brew cask install spotify-notifications
brew cask install texpad
brew cask install textmate
brew cask install the-clock
brew cask install the-unarchiver
brew cask install tunnelblick
brew cask install vlc
brew cask install wavebox

# Install web software
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
brew install nginx
brew install mariadb
brew install php55 --with-libmysql php55-mcrypt php55-xdebug
brew install -s php55-imagick
brew unlink php55
brew install php56 --with-libmysql php56-mcrypt php56-xdebug
brew install -s php56-imagick
brew unlink php56
brew install php70 php70-mcrypt php70-opcache php70-apcu php70-xdebug
brew install -s php70-imagick
brew unlink php70 &> /dev/null
brew install php71 php71-mcrypt php71-opcache php71-apcu php71-xdebug
brew install -s php71-imagick
brew install php72 php72-mcrypt php72-opcache php72-apcu php72-xdebug
brew install -s php72-imagick
brew install xdebug-osx
xdebug-toggle off --no-server-restart
brew install node
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit
brew install composer

# Configuring web software
cp $(brew --prefix mariadb)/support-files/my-large.cnf /usr/local/etc/my.cnf
mysql.server start
sudo brew services start mariadb
$(brew --prefix mariadb)/bin/mysql_secure_installation
mysql -u root -p <<EOF
use mysql;
CREATE USER 'bnjns'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'bnjns'@'localhost' WITH GRANT OPTION;
EOF
mkdir -p /usr/local/var/run/php
chmod -R ug+w /usr/local/Cellar/php55/5.5*/lib/php
chmod -R ug+w /usr/local/Cellar/php56/5.6*/lib/php
chmod -R ug+w /usr/local/Cellar/php70/7.0*/lib/php
chmod -R ug+w /usr/local/Cellar/php71/7.1*/lib/php
chmod -R ug+w /usr/local/Cellar/php72/7.2*/lib/php
ln -s /usr/local/opt/php55/bin/php /usr/local/bin/php55
ln -s /usr/local/opt/php56/bin/php /usr/local/bin/php56
ln -s /usr/local/opt/php70/bin/php /usr/local/bin/php70
ln -s /usr/local/opt/php72/bin/php /usr/local/bin/php72
brew services start php55
brew services start php56
brew services start php70
brew services start php71
brew services start php72
sudo brew services start nginx

# Enable pip as a direct command
echo 'alias pip="python2 -m pip"' >> ~/.bashrc

# Set the default apps
{ cat <<eof
cx.c3.theunarchiver:gz
cx.c3.theunarchiver:rar
cx.c3.theunarchiver:tar
cx.c3.theunarchiver:zip
com.macromates.TextMate:txt
com.macromates.TextMate:xml
com.macromates.TextMate:sh
com.macromates.TextMate:php
com.readdle.PDFExpert-Mac:pdf
com.vallettaventures.Texpad:tex
eof
} | grep . |
while IFS=$':' read bundle_id extension ; do
  /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump | grep $bundle_id > /dev/null
  status=$?
  if test $status -eq 1 ; then
    exit
  else
    duti -s $bundle_id .$extension all
  fi
done

# Clean up
brew cleanup -s
brew prune