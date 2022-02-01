#!/bin/sh

VERSION=$1
PUSH=$2

set -e

if [ -z "$VERSION" ]; then
  echo "Usage ${0} <kaspad-version> [<push>]"
  echo "Example: ${0} v0.11.11"
  exit 1
fi

echo
echo "========================="
echo " Building Kaspad"
echo "========================="
echo
./kaspad/build.sh $1 $2

echo
echo "========================="
echo " Building Loadbalancer"
echo "========================="
echo
./kaspad_loadbalancer/build.sh $1 $2

echo
echo "========================="
echo " Done"
echo "========================="
echo
