#!/bin/bash

LOCAL_IP="$1"

ssh core@$LOCAL_IP -t <<EOF
echo disable | sudo tee /sys/firmware/acpi/interrupts/gpe6F

sudo mkdir -pv /etc/conf.d
sudo tee /etc/conf.d/k8s-controller <<EOX
LOCAL_IP=$LOCAL_IP
OST_CONTROLLER=$2
EOX

sudo systemctl restart etcd

systemctl status etcd | grep 'Active: active (running)' || exit 1

curl https://docs.midonet.org/docs/kuryr/tech-preview-release/en/install-guide/_downloads/cloud-config-k8s-controller.yaml | sudo coreos-cloudinit --from-file /dev/stdin

EOF

exit 0

