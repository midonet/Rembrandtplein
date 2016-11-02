#!/bin/bash

for SERVER in $*; do
	ssh -t core@$SERVER -- sudo reboot
done

exit 0

