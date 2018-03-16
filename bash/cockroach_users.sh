#!/bin/bash

cert="/opt/ssl/certs/certs"
master=$(cat ${cert}/nodes.txt)
current_hostname=$(cat /etc/hostname)
node=$(echo ${master}| cut -d'_' -f 1)

# User Creation to be done on master node only
echo "#################################################################"
if [ $NODE_MASTER == True ] && [ ${node} -eq 0 ]; then
        sleep 3
        users_list=$(cat ${cert}/users.txt)
        amount=$(cat ${cert}/users.txt | wc -l )
        num=$(expr ${amount} - 1)
        counter=1
        while [ $counter -le $num ]; do
            username=$(echo ${users_list}| cut -d' ' -f $counter)
            echo "#################################################################"
            echo "Adding user $username to Cockroach"
            echo "#################################################################"
            cockroach user set $username --certs-dir=$COCKROACH_CERTS_DIR --host=node${node}
        counter=$(expr $counter + 1)
        done
fi

if [ $NODE_MASTER == False ]; then
        sleep 9
        users_list=$(cat ${cert}/users.txt)
        amount=$(cat ${cert}/users.txt | wc -l )
        num=$(expr ${amount} - 1)
        cp ${cert}/client.root.crt $COCKROACH_CERTS_DIR/client.root.crt
        cp ${cert}/client.root.key $COCKROACH_CERTS_DIR/client.root.key
        counter=1
        while [ $counter -le $num ]; do
            username=$(echo ${users_list}| cut -d' ' -f $counter)
            echo "#################################################################"
            echo "Adding user Certs $username"
            echo "#################################################################"
            cp ${cert}/client.${username}.crt $COCKROACH_CERTS_DIR/client.${username}.crt
            cp ${cert}/client.${username}.key $COCKROACH_CERTS_DIR/client.${username}.key

        counter=$(expr $counter + 1)
        done
fi
