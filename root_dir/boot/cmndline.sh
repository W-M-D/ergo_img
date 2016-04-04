#!/bin/bash

ELUCID_LABS_MAC=(54 2F 89 00 00 00)
MAC_ADDR_NAME="smsc95xx.macaddr"
UNIT_ID=$(cat /etc/ERGO/unit_id)

UNIT_ID_HEX=$(printf '%x\n' $UNIT_ID)

ELUCID_LABS_MAC[4]=$(echo $UNIT_ID_HEX | cut -c1-2)
ELUCID_LABS_MAC[5]=$(echo $UNIT_ID_HEX | cut -c3-4)
final_mac_string=""
loop_iter=0;
for i in ${ELUCID_LABS_MAC[@]};do
	let loop_iter+=1
	final_mac_string+=${i}
	if [[ $loop_iter<${#ELUCID_LABS_MAC[@]} ]]; 
		then
			final_mac_string+=':'	

	fi
done
mac_string=($MAC_ADDR_NAME"="$final_mac_string)

echo $mac_string >> /boot/cmdline.txt

