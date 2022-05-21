#!/bin/sh

HOST_IP=$3
HOST_PORT=16110
TIMEOUT_SEC=3

set -e

kaspactl -a -s $HOST_IP:$HOST_PORT -t $TIMEOUT_SEC GetBlockTemplate kaspa:qpjc562lcm96a0vsx7nn52zrzwvnxfjcs0daf9798wpxjydheke2kt8q65p3s ' ' 2>/dev/null | /bin/grep -qE '"isSynced": *true'

