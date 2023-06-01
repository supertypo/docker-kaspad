#!/bin/sh

REPO_URL_STABLE=https://github.com/kaspanet/kaspad

VERSION=$1
KASPAD_VERSION=$(echo $VERSION | grep -oP ".*(?=_.+)")
PUSH=$2
REPO_URL=${3:-$REPO_URL_STABLE}

set -e

if [ -z "$VERSION" -o -z "$KASPAD_VERSION" ]; then
  echo "Usage ${0} <kaspad-version_buildnr> [push] [kaspad_repo_url]"
  echo "Example: ${0} v0.12.13_1"
  exit 1
fi

docker build --pull --build-arg KASPAD_VERSION=${KASPAD_VERSION} --build-arg REPO_URL=${REPO_URL} -t supertypo/kaspawallet:${VERSION} $(dirname $0)
docker tag supertypo/kaspawallet:${VERSION} supertypo/kaspawallet:latest

if [ "$PUSH" = "push" ]; then
  docker push supertypo/kaspawallet:${VERSION}
  if [ "$REPO_URL" = "$REPO_URL_STABLE" ]; then
    docker push supertypo/kaspawallet:latest    
  fi
fi

