#!/bin/sh

VERSION=$1
KASPAD_VERSION=$(echo $VERSION | grep -oP ".*(?=_.+)")
PUSH=$2
REPO_URL=${3:-https://github.com/kaspanet/kaspad}

set -e

if [ -z "$VERSION" -o -z "$KASPAD_VERSION" ]; then
  echo "Usage ${0} <kaspad-version_buildnr> [push] [kaspad_repo_url]"
  echo "Example: ${0} v0.11.11_1"
  exit 1
fi

docker build --pull --build-arg KASPAD_VERSION=${KASPAD_VERSION} --build-arg REPO_URL=${REPO_URL} -t supertypo/kaspad_loadbalancer:${VERSION} $(dirname $0)
docker tag supertypo/kaspad_loadbalancer:${VERSION} supertypo/kaspad_loadbalancer:latest

if [ "$PUSH" = "push" ]; then
  docker push supertypo/kaspad_loadbalancer:${VERSION}
  docker push supertypo/kaspad_loadbalancer:latest
fi

