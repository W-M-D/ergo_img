#!/bin/bash

PASSWORD="a_password"
UNIT_ID="a_id" 
WGET_TIMER_MAX="50"

#changes the password for the unit with the format password unit_id 
# eg password555
echo -e "$PASSWORD$UNIT_ID\n$PASSWORD$UNIT_ID" |(passwd pi)
mkdir -p /etc/ERGO/
echo "$UNIT_ID" > /etc/ERGO/unit_id

#adds a key for local admins so i don't have to rember the unit id for every mac addr. 
mkdir -p /home/pi/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCy73F6b2D/BdSiWAVnTUnnhEYS1gohg1HdwKdUG30HPThfcAXPr/tcfQ6yBi4Hv1jecElyYhooSI8Tp0jI3UU1xoIl//ND8e0kzV0KPIJ3pwwzL4SEeLZ/OeXVivna19Rj0VjjpveYIIEVWMi4m6RyKT3rK6JGfnqhjVTcYu/4JiEPkWmsLUjdWani+CH2TmF1peGPvRuyjMQ0qAKdhNOBeb/RxOxJ1kUPz+UEvyiYE4EyLrz4N6YoonN+gKje8+vaeu/BgJToLYQu1qIz1mI3wws/ECOpir5ltSn/xsz4oATKKZPhcVdNnc4/BuFA86f5oVz7mUZ5faSagx+Z0Bz+eoWFY+K0puPqhDIh0xmZ3d642BXVQsagjq0bLF2tn2TbR4NB+BocYj/d4Zcj91G2yW1zNq8lCalkpaU500Oqf5AzBxtwR6RU1d49NdBv9gyrSWTCkGl8/sPyNBmldviIDKNfhXAJu1oqUq0Oi695m+pXgCARtPzlJ3d7jIHG5wmchMHwxgEAV3feFFjWye2OZiLUoFpHj1bfWnM7dYeUs/O1SMgz2OCxd2jysl+0UmffKgSjPEpHBDuPtdjGEqfIwO4eY+ePL2lmSyKudQx/0PkIHnH41qnOWWdisdcNo3tNozQpwvh6d4vO4aYwSVYpZgVfztTd4Wmrfq7WQtIopQ== 555' > /home/pi/.ssh/authorized_keys

#change the hostname
NEW_HOSTNAME="ergo$UNIT_ID"
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
echo $NEW_HOSTNAME > /etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts

#sets up apt sources
while ! wget -O -  http://packages.ergotelescope.org/ergo.gpg.key  ; do
        WGET_TIMER=$RANDOM
        let "WGET_TIMER %= $WGET_TIMER_MAX"
        sleep $WGET_TIMER
done
wget -O - http://packages.ergotelescope.org/ergo.gpg.key | apt-key add - &&

#sets up ergo and unattended-upgrades
apt-get update  
apt-get install -y ergo-telescope unattended-upgrades apt-listchanges || exit;
apt-get -fy install ergo-telescope  
apt-get update || exit;

mv /etc/apt/apt.conf.d/50unattended-upgrades.new /etc/apt/apt.conf.d/50unattended-upgrades  

chmod 600 /etc/init.d/install_ergo_init
update-rc.d install_ergo_init remove
sudo reboot
