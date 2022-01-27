#!/bin/sh

VERSION=$1
PUSH=$2

if [ -z "$VERSION" ]; then
  echo "Usage ${0} <kaspad-version> [<push>]"
  echo "Example: ${0} v0.11.11"
  exit 1
fi

docker build --pull --build-arg VERSION=${VERSION} -t supertypo/kaspad:${VERSION} .
docker tag supertypo/kaspad:${VERSION} supertypo/kaspad:latest

if [ "$PUSH" = "push" ]; then
  docker push supertypo/kaspad:${VERSION}
  docker push supertypo/kaspad:latest
fi

