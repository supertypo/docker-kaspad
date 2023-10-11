#!/bin/sh

IPV4=$(dig -4 TXT +short +nocomments +timeout=2 +tries=3 o-o.myaddr.l.google.com @ns1.google.com | sed 's/;;.*//' | sed 's/"//g')
IPV6=$(dig -4 TXT +short +nocomments +timeout=2 +tries=3 o-o.myaddr.l.google.com @ns1.google.com | sed 's/;;.*//' | sed 's/"//g')

if [ "${IPV4}x" != "x" ]; then
  export EXTERNAL_IP=$IPV4
elif [ "${IPV4}x" != "x" ]; then
  export EXTERNAL_IP=$IPV6
fi

if [ -n "$EXTERNAL_IP" ]; then
  case "$@" in
    *externalip*) exec dumb-init -- "$@" ;;
    *)            exec dumb-init -- "$@" --externalip=$EXTERNAL_IP ;;
  esac
else
  exec dumb-init -- "$@"
fi

