#!/bin/bash

ssh core@$1 -t <<EOF
echo disable | sudo tee /sys/firmware/acpi/interrupts/gpe6F

sudo mkdir -pv /etc/conf.d
sudo tee /etc/conf.d/k8s-worker <<EOX
LOCAL_IP=$1
OST_CONTROLLER=$2
K8S_CONTROLLER=$3
EOX

/usr/bin/docker pull midonet/agent
/usr/bin/docker pull midonet/kubelet

curl https://docs.midonet.org/docs/kuryr/tech-preview-release/en/install-guide/_downloads/cloud-config-k8s-worker.yaml | sudo coreos-cloudinit --from-file /dev/stdin

EOF

exit 0

