#!/bin/bash

TUNNELZONE="$(ssh -q core@$1 -t -- /opt/bin/midonet-cli -e tunnel-zone list | awk '{print $2;}')"

for HOST in $(ssh -q core@$1 -t -- /opt/bin/midonet-cli -e host list | awk '{print $2 "::::" $4 "::::" $8;}'); do
  IPADDRESS="$(echo "$HOST" | awk -F'192.168.9.' '{print "192.168.9." $2;}' | awk -F',' '{print $1;}')"
  UUID="$(echo "$HOST" | awk -F'::::' '{print $1;}')"

  echo
  echo "$TUNNELZONE:$UUID:$IPADDRESS ($HOST)"
  echo

  ssh -q core@$1 -t -- /opt/bin/midonet-cli -e tunnel-zone $TUNNELZONE member list | grep "zone $TUNNELZONE host $UUID" || \
    ssh -q core@$1 -t -- /opt/bin/midonet-cli -e tunnel-zone $TUNNELZONE add member host $UUID address $IPADDRESS

done

echo
echo "### RESULT ###"
echo

ssh -q core@$1 -t -- /opt/bin/midonet-cli -e tunnel-zone $TUNNELZONE member list

exit 0

