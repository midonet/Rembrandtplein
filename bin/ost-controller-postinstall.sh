#!/bin/bash

ssh core@$1 -t <<EOF
echo disable | sudo tee /sys/firmware/acpi/interrupts/gpe6F

/opt/bin/midonet-setup

/opt/bin/create_uplink

sudo /opt/bin/link_raven_network

EOF

exit 0

