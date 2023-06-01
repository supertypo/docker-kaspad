#!/bin/sh

HOST_IP=$3
HOST_PORT=$4
TIMEOUT_SEC=4

if /usr/bin/expr "$PATH" : '\d*$' >/dev/null; then
  HOST_PORT=$PATH # Allow override using the external-check path option
elif [ -z "$4" -o "$4" = "0" ]; then
  HOST_PORT=16110 # Default to mainnet
  case "$HAPROXY_PROXY_NAME" in
    *test*)
      HOST_PORT=16210 # Assume testnet for backends with the name test in them
      ;;
  esac
fi

${PWD}/kaspactl -a -s $HOST_IP:$HOST_PORT -t $TIMEOUT_SEC GetInfo 2>/dev/null | /bin/grep -qE '"isSynced": *true'

