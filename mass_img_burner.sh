#!/bin/bash


IMG_NAME="$1"
CURRENT_USER=$(whoami) 
UNIT_ID=""
DISK_INFO=""
DISK_PATHS=""

select_disks ()
{

echo "$IMG_NAME"
DISK_INFO=$(parted -l 2>&1 |grep -Po "Disk\s(\/dev\/sd[^abc])\:\s\d++\.\d+GB") 
DISK_PATHS=$(echo $DISK_INFO |grep -Po "(\/dev\/sd[^abc])")
NUM_DISKS=$(echo "$DISK_INFO" | wc -l)

if [ -z "$DISK_INFO" ]
 then
  printf "No disks please try again.\n"
  exit 1
fi

while true; do
    perl -e 'print "*"x50;print "\n"'
    echo "$DISK_INFO"
    perl -e 'print "*"x50;print "\n\n"'
    read -p "There are $NUM_DISKS ready. Do these disks look correct?  WARNING SELECTING THE WRONG DISKS CAN RESULT IN SERIOUS DAMMAGE : " yn
    case $yn in
        [Yy]* ) write_img; break;;
        [Nn]* ) select_disks; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

}

write_img ()
{
for PATH in $DISK_PATHS;
do (/bin/dd if=/dev/zero | /usr/bin/pv | dd bs=1M of=$PATH &&  /bin/dd if=$IMG_NAME | /usr/bin/pv |dd bs=1M  of=$PATH ; ) &  
done
}

select_disks
