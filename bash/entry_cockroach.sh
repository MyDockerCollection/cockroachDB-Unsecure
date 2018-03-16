#!/bin/bash

echo "This is the wright one.  With the host of $HOST_IPADDRESS"
sleep $LOAD_WAIT
cert="/opt/ssl/certs/certs"
change_hostname=""

if [ $COCKROACHDB_SECURE == True ]; then
    scp -r $KEYSTORE:/opt/ssl/certs /opt/ssl/
    sed '1d' ${cert}/nodes.txt > ${cert}/nodes_lst.txt
    scp ${cert}/nodes_lst.txt $KEYSTORE:${cert}/nodes.txt
    users_list=$(cat ${cert}/users.txt)
    amount=$(cat ${cert}/users.txt | wc -l )
    num=$(expr ${amount} - 1)
    cp ${cert}/client.root.crt $COCKROACH_CERTS_DIR/client.root.crt
    cp ${cert}/client.root.key $COCKROACH_CERTS_DIR/client.root.key
    counter=1
    while [ $counter -le $num ]; do
        username=$(echo ${users_list}| cut -d' ' -f $counter)
        echo "#################################################################"
        echo "Moving user $username cert to Local Keystore"
        echo "#################################################################"
        cp ${cert}/client.${username}.crt $COCKROACH_CERTS_DIR/client.${username}.crt
        cp ${cert}/client.${username}.key $COCKROACH_CERTS_DIR/client.${username}.key
    counter=$(expr $counter + 1)
    done

fi
