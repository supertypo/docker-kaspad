#!/bin/sh

if echo "$@" | grep -qE "^(/app/)?kaspad( |$)" && ! echo "$@" | grep -qE "\--externalip(=| )"; then
  listenPort=$(echo "$@" | grep -oP "\--listen(=| )\S+:\K\d+( |$)" | tail -1)
  if [ -n "$listenPort" ]; then
    listenPort=":$listenPort"
  fi
  externalIp4=$(dig -4 TXT +short +nocomments +timeout=2 +tries=3 o-o.myaddr.l.google.com @ns1.google.com | sed 's/;;.*//' | sed 's/"//g')
  externalIp6=$(dig -6 TXT +short +nocomments +timeout=2 +tries=3 o-o.myaddr.l.google.com @ns1.google.com | sed 's/;;.*//' | sed 's/"//g')
  if [ -n "$externalIp4" ]; then
    echo "Public ipv4 address resolved to: $externalIp4"
    externalIpArgs="--externalip=$externalIp4$listenPort"
  else
    echo "Public ipv4 address not found"
  fi
  if [ -n "$externalIp6" ]; then
    echo "Public ipv6 address resolved to: $externalIp6"
    externalIpArgs="$externalIpArgs --externalip=$externalIp6$listenPort"
  else
    echo "Public ipv6 address not found"
  fi
fi

echo "Setting owner on $KASPA_HOME to $KASPA_USER"
chown $KASPA_USER:$KASPA_USER $KASPA_HOME
echo "Executing: $@ $externalIpArgs"
exec su-exec $KASPA_USER "$@" $externalIpArgs

