#!/bin/sh

VERSION=$1
PUSH=$2

set -e

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
