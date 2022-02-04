#!/bin/sh

VERSION=$1
KASPAD_VERSION=$(echo $VERSION | grep -oP ".*(?=_.+)")
PUSH=$2

set -e

if [ -z "$VERSION" -o -z "$KASPAD_VERSION" ]; then
  echo "Usage ${0} <kaspad-version_buildnr> [push]"
  echo "Example: ${0} v0.11.11_1"
  exit 1
fi

docker build --pull --build-arg KASPAD_VERSION=${KASPAD_VERSION} -t supertypo/kaspad:${VERSION} $(dirname $0)
docker tag supertypo/kaspad:${VERSION} supertypo/kaspad:latest

if [ "$PUSH" = "push" ]; then
  docker push supertypo/kaspad:${VERSION}
  docker push supertypo/kaspad:latest
fi

