# ergo_img
Patches to a raspberry pi img to include ergo code / updates / extra config


#   expand_fs_init
A simple init script that can be added to a sd card in the /etc/init.d/ dir and then activated by running the command "update-rc.d expand_fs_init defaults" this command can be run under qemu and then when moved to a raspberry pi it will auto expand to the full size of the sd card!

