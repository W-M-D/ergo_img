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
# Everything below will go to the file 'log.out':

do_start
{
PASSWORD="a_password"
UNIT_ID="a_id" 


mv /root/sources.list /etc/apt/sources.list
wget -O -  http://packages.ergotelescope.org/ergo.gpg.key | apt-key add - 

apt-get update
apt-get upgrade -y
apt-get install -y ergo-telescope 

echo -e "$PASSWORD_$UNIT_ID\n$PASSWORD_$UNIT_ID" |(passwd pi)
echo "$UNIT_ID" > /etc/ERGO/unit_id

mkdir -p /home/pi/.ssh
#adds a key for admins. 
cat /root/master_key >> /home/pi/.ssh/authorized_keys

}
