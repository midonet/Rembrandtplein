#!/bin/bash

LOCAL_IP=$1

ssh core@$LOCAL_IP -t <<EOF
echo disable | sudo tee /sys/firmware/acpi/interrupts/gpe6F

sudo mkdir -pv /etc/conf.d
sudo tee /etc/conf.d/ost-controller <<EOX
LOCAL_IP=$LOCAL_IP
DB_HOST=$LOCAL_IP
OS_AUTH_URL=http://$LOCAL_IP:35357/v2.0
OS_AUTH_URI=http://$LOCAL_IP:5000/v2.0
OS_NEUTRON_URL=http://$LOCAL_IP:9696
RB_HOST=$LOCAL_IP
MN_CLUSTER_URL=http://$LOCAL_IP:8181/midonet-api
ZK_QUORUM="$LOCAL_IP:1"
ZK_CLUSTER="$LOCAL_IP:2181"
C_SERVERS="$LOCAL_IP"
EOX

/usr/bin/docker pull midonet/agent
/usr/bin/docker pull midonet/cluster

curl https://docs.midonet.org/docs/kuryr/tech-preview-release/en/install-guide/_downloads/cloud-config-ost-controller.yaml | sudo coreos-cloudinit --from-file /dev/stdin

/opt/bin/keystone-provisioning.sh

EOF

exit 0

