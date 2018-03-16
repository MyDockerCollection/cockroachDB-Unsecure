#!/bin/bash
master=$1
if [ ${master} == m ]; then
docker run -i -p 26257:26257 -p 82:8080 -h nodemaster -v data:/opt/cockroachDB/data \
    -e COCKROACHDB_SECURE=False \
    -e COCKROACH_SKIP_ENABLING_DIAGNOSTIC_REPORTING=true \
    -e COCKROACH_CA_KEY=/opt/ssl/ca/ca.key \
    -e COCKROACH_CERTS_DIR=/opt/ssl/certs/ \
    -e COCKROACH_SKIP_KEY_PERMISSION_CHECK=true \
    -e HOST_IPADDRESS=nodemaster \
    -e HOST_PORT=8080 \
    -e STORE_ID=0 \
    -e ADVERTISE_HOST=172.14.0.4 \
    -e COCKROACH_MASTERNODE_IP=172.17.0.4 \
    -e NODE_MASTER=True \
    -e NODE_ADDITION=False \
    -e DATASTORE_PATH=/opt/cockroachDB/data \
    -e NODE_KEYS=2 \
    -e KEYSTORE=172.17.0.3 \
    cockroach /opt/cockroach_start.sh
fi

if [ ${master} == n ]; then
docker run -it -p 8000:26258 -p 8082:8081 -h node1 -v data2:/opt/cockroachDB/data \
    -e COCKROACHDB_SECURE=False \
    -e COCKROACH_SKIP_ENABLING_DIAGNOSTIC_REPORTING=true \
    -e COCKROACH_CA_KEY=/opt/ssl/ca/ca.key \
    -e COCKROACH_CERTS_DIR=/opt/ssl/certs/ \
    -e COCKROACH_SKIP_KEY_PERMISSION_CHECK=true \
    -e HOST_IPADDRESS=node1 \
    -e HOST_PORT=8081 \
    -e STORE_ID=1 \
    -e ADVERTISE_HOST=node1 \
    -e COCKROACH_MASTERNODE_IP=172.17.0.4 \
    -e NODE_MASTER=False \
    -e NODE_ADDITION=True \
    -e DATASTORE_PATH=/opt/cockroachDB/data \
    -e NODE_KEYS=2 \
    -e KEYSTORE=172.17.0.3 \
    cockroach
fi