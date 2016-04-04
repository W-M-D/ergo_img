#!/bin/bash

ELUCID_LABS_MAC=(54 2F 89)
MAC_ADDR_NAME="smsc95xx.macaddr"
UNIT_ID=$(cat /etc/ERGO/unit_id)

UNIT_ID_HEX=$(printf '0%x\n' $UNIT_ID)
echo $UNIT_ID_HEX
echo ${ELUCID_LABS_MAC[*]}
