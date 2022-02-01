#!/bin/sh

VERSION=$1
PUSH=$2

set -e

if [ -z "$VERSION" ]; then
  echo "Usage ${0} <kaspad-version> [<push>]"
  echo "Example: ${0} v0.11.11"
  exit 1
fi

docker build --pull --build-arg VERSION=${VERSION} -t supertypo/kaspad_loadbalancer:${VERSION} $(dirname $0)
docker tag supertypo/kaspad_loadbalancer:${VERSION} supertypo/kaspad_loadbalancer:latest

if [ "$PUSH" = "push" ]; then
  docker push supertypo/kaspad_loadbalancer:${VERSION}
  docker push supertypo/kaspad_loadbalancer:latest
fi

