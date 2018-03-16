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

master=$(cat ${cert}/nodes.txt)
current_hostname=$(cat /etc/hostname)
node=$(echo ${master}| cut -d'_' -f 1)

if [ ${node} -eq 0  ]; then
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



if [ $NODE_MASTER == True ] && [ $node -eq 0 ]; then
    cp ${cert}/${node}_node.key ${COCKROACH_CERTS_DIR}/node.key
    cp ${cert}/${node}_node.crt ${COCKROACH_CERTS_DIR}/node.crt

    if [ $COCKROACHDB_SECURE == True ]; then
        cockroach start --certs-dir=$COCKROACH_CERTS_DIR --host=$HOST_IPADDRESS --advertise-host=$ADVERTISE_HOST
    else
        cockroach start --insecure --host=$HOST_IPADDRESS --advertise-host=$ADVERTISE_HOST
    fi

fi

echo "########################################################"
echo "######## Node $node Hostname ${change_hostname} ########"
echo "########################################################"

port=$((${node}+26257))
http_port=$(($STORE_ID+8080))

if [ $NODE_ADDITION == True ] && [ $node -ge 1 ]; then
    cp ${cert}/${node}_node.key ${COCKROACH_CERTS_DIR}/node.key
    cp ${cert}/${node}_node.crt ${COCKROACH_CERTS_DIR}/node.crt
    ls ${cert}/
    if [ $COCKROACHDB_SECURE == True ]; then
    echo "Nunquam prensionem vigil."
    cockroach start --certs-dir=${cert} --host=$HOST_IPADDRESS --store=node-0$STORE_ID --join=$COCKROACH_MASTERNODE_IP:26257  --http-port=808$STORE_ID
    cockroach start --certs-dir=${cert} --store=node-0$STORE_ID --host=$HOST_IPADDRESS --port=${port} --http-port=${http_port} --http-host=$ADVERTISE_HOST --join=$COCKROACH_MASTERNODE_IP:26257
    else
    cockroach start --insecure --host=$HOST_IPADDRESS --store=node-0$STORE_ID --join=$COCKROACH_MASTERNODE_IP:26257  --http-port=808$STORE_ID
       cockroach start --insecure --host=$HOST_IPADDRESS --advertise-host=$ADVERTISE_HOST
    fi

fi
