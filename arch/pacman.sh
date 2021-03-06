#!/usr/bin/env bash

# Dependencies
sudo pacman -Syu
sudo pacman -S binutils make gcc fakeroot pkg-config expac yajl git --noconfirm --needed

mkdir -p /tmp/pacaur_install
cd /tmp/pacaur_install

# Install "cower" from AUR
if [ ! -n "$(pacman -Qs cower)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
  makepkg PKGBUILD --skippgpcheck --install --needed
fi

# Install "pacaur" from AUR
if [ ! -n "$(pacman -Qs pacaur)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
  makepkg PKGBUILD --install --needed
fi

# Clean up...
cd ~
rm -rf /tmp/pacaur_install
