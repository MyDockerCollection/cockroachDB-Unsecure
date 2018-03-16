#!/bin/bash

echo "About to install Cockroach.  With the host of $HOST_IPADDRESS"
change_hostname=$ADVERTISE_HOST
user_bin=0
current_hostname=$(cat /etc/hostname)
node=$(echo ${master}| cut -d'_' -f 1)

if [ $STORE_ID -eq 0  ]; then
    change_hostname=node${node}
    echo ${change_hostname} > /etc/hostname
    sed "s/${current_hostname}/${change_hostname}/" /etc/hosts > /etc/hosts
    else
    change_hostname=node${node}
    echo ${change_hostname} > /etc/hostname
    sed "s/${current_hostname}/${change_hostname}/" /etc/hosts > /etc/hosts
fi
echo ${current_hostname} && echo ${change_hostname}
cat /etc/hosts
cat /etc/hostname

cockroach start --insecure --host=$HOST_IPADDRESS --advertise-host=$ADVERTISE_HOST

# User Creation to be done on master node only

