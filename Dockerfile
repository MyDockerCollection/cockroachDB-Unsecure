FROM debian:stretch-slim

# TLM base cockroachDB custom build
# created by oyoshi

RUN mkdir /opt/cockroach /opt/cockroach/ssl /opt/cockroach/tmp /opt/cockroachDB /opt/cockroachDB/data /opt/ssl /opt/ssl/certs /opt/ssl/ca /opt/cockroach/data

COPY ./cockroach/cockroach /opt/cockroach/cockroach
#ADD https://binaries.cockroachdb.com/cockroach-v1.0.6.linux-amd64.tgz /opt/
#RUN cd /opt/ && tar -xzf cockroach-v1.0.6.linux-amd64.tgz && mv /opt/cockroach-v1.0.6.linux-amd64/cockroach  /opt/cockroach/cockroach && rm -rf /opt/cockroach-v1.0.6.linux-amd64/  && rm cockroach-v1.0.6.linux-amd64.tgz
RUN apt-get update && \
    apt-get install -y zssh iputils-ping && \
    apt-get clean && \
   	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ADD ./ssh/ /root/.ssh/
ADD ./bash/* /opt/

RUN ln /opt/cockroach/cockroach /usr/local/bin/cockroach  && \
    chmod +x /opt/cockroach/cockroach && \
    chmod +x /opt/cockroach_start.sh && \
    chmod +x /opt/entry_point.sh && \
    chmod +x /opt/cockroach_users.sh && \
    chmod +x /opt/entry_cockroach.sh && \
    chmod +x /opt/unsecure.sh && \
    chmod +x /opt/main.sh

RUN /bin/chmod 600 /root/.ssh/id_rsa && \
    /bin/chmod 600 /root/.ssh/config

ENV LOAD_WAIT=45 \
    COCKROACHDB_SECURE=False \
    COCKROACH_SKIP_ENABLING_DIAGNOSTIC_REPORTING=true \
    COCKROACH_CA_KEY=/opt/ssl/ca/ca.key \
    COCKROACH_CERTS_DIR=/opt/ssl/certs/ \
    COCKROACH_SKIP_KEY_PERMISSION_CHECK=true \
    HOST_IPADDRESS=0.0.0.0 \
    HOST_PORT=8080 \
    STORE_ID=0 \
    ADVERTISE_HOST=0.0.0.0 \
    COCKROACH_MASTERNODE_IP=0.0.0.0 \
    NODE_MASTER=True \
    NODE_ADDITION=False \
    DATASTORE_PATH=/opt/cockroachDB/data \
    NODE_KEYS=2 \
    USER_KEYS=3 \
    ROOT_KEYS=2 \
    KEYSTORE=""

EXPOSE 26257 8080
ENTRYPOINT ["/bin/bash"]
CMD ["/opt/main.sh"]
