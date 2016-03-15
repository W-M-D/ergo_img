#!/bin/sh

chmod 700 /etc/init.d/expand_fs_init
chmod 700 /etc/init.d/install_ergo

update-rc.d install_ergo defaults
update-rc.d expand_fs_init defaults
