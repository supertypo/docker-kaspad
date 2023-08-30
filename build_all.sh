#!/bin/sh

set -e

echo
echo "========================="
echo " Building Kaspad"
echo "========================="
echo
./kaspad/build.sh $@

echo
echo "========================="
echo " Building Loadbalancer"
echo "========================="
echo
./kaspad_loadbalancer/build.sh $@

#echo
#echo "========================="
#echo " Building Kaspawallet"
#echo "========================="
#echo
#./kaspawallet/build.sh $@

echo
echo "========================="
echo " Done"
echo "========================="
echo
