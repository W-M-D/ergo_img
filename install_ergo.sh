#!/bin/sh
### BEGIN INIT INFO
# Provides: install_ergo
# Required-Start:
# Required-Stop:
# Default-Start: 3 
# Default-Stop:
# Short-Description: grabs keys and installs ergo
# Description:
### END INIT INFO
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/var/log/ergo_install.log 2>&1

do_start
{
PASSWORD="a_password"
UNIT_ID="a_id" 

#sets up apt sources
mv /root/sources.list /etc/apt/sources.list
wget -O -  http://packages.ergotelescope.org/ergo.gpg.key | apt-key add - 

#sets up ergo and unattended-upgrades
apt-get update;
apt-get upgrade -y;
apt-get install -y ergo-telescope unattended-upgrades apt-listchanges;
cp /root/50unattended-upgrades /etc/apt/apt.conf.d/ ;
apt-get update;

#changes the password for the unit with the format password_unit id 
# eg password_555
echo -e "$PASSWORD_$UNIT_ID\n$PASSWORD_$UNIT_ID" |(passwd pi)
echo "$UNIT_ID" > /etc/ERGO/unit_id

#adds a key for admins. 
mkdir -p /home/pi/.ssh
cat /root/master_key >> /home/pi/.ssh/authorized_keys

}
