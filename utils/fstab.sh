#!/usr/bin/env bash

cat >> /etc/fstab <<EOF

# Plex
UUID=efc1b45b-2630-43f8-aa64-31adfcd34b2c        /mnt/plex_01   ext4     defaults                                         0 2
UUID=ca4c422f-4fb0-4cbb-8ea5-9b3bededb087        /mnt/plex_02   ext4     defaults                                         0 2
UUID=18c9ec05-86a4-4579-b7d2-1c080ad84665        /mnt/plex_03   ext4     defaults                                         0 2

EOF


