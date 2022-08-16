#!/bin/sh

HOST_IP=$3
HOST_PORT=16110
TIMEOUT_SEC=7

set -e

kaspactl -a -s $HOST_IP:$HOST_PORT -t $TIMEOUT_SEC GetInfo 2>/dev/null | /bin/grep -qE '"isSynced": *true'

