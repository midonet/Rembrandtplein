#!/bin/bash

ssh core@$1 hostname || exit 1
ssh core@$1 hostname -f || exit 1
ssh core@$1 hostname -i || exit 1

echo OK

exit 0

