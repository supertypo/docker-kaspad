#!/bin/sh

DOCKER_REPO="supertypo/kaspad_loadbalancer"
KASPAD_DOCKER_REPO="supertypo/kaspad"
KCHECK_DOCKER_REPO="supertypo/kcheck"
KCHECK_VERSION="nightly"
ARCHES="linux/amd64 linux/arm64"

BUILD_DIR="$(dirname $0)"
PUSH=$1
VERSION=${2:-nightly}

set -e

docker=docker
id -nG $USER | grep -qw docker || docker="sudo $docker"

plain_build() {
  echo
  echo "===================================================="
  echo " Running current arch build"
  echo "===================================================="
  dockerRepo="${DOCKER_REPO}"

  $docker build --pull \
    --build-arg KASPAD_DOCKER_REPO="$KASPAD_DOCKER_REPO" \
    --build-arg KASPA_VERSION="$VERSION" \
    --build-arg KCHECK_DOCKER_REPO="$KCHECK_DOCKER_REPO" \
    --build-arg KCHECK_VERSION="$KCHECK_VERSION" \
    --tag $dockerRepo:$VERSION "$BUILD_DIR"

  if [ "$VERSION" != "nightly" ]; then
     $docker tag $dockerRepo:$VERSION $dockerRepo:nightly
     echo Tagged $dockerRepo:nightly
     $docker tag $dockerRepo:$VERSION $dockerRepo:latest
     echo Tagged $dockerRepo:latest
  fi

  if [ "$PUSH" = "push" ]; then
    $docker push $dockerRepo:$VERSION
    if [ "$VERSION" != "nightly" ]; then
      $docker push $dockerRepo:nightly
      $docker push $dockerRepo:latest
    fi
  fi
  echo "===================================================="
  echo " Completed current arch build"
  echo "===================================================="
}

multi_arch_build() {
  echo
  echo "===================================================="
  echo " Running multi arch build"
  echo "===================================================="
  dockerRepo="${DOCKER_REPO}"
  dockerRepoArgs=
  if [ "$PUSH" = "push" ]; then
    dockerRepoArgs="$dockerRepoArgs --push"
  fi
  if [ "$VERSION" != "nightly" ]; then
    dockerRepoArgs="$dockerRepoArgs --tag $dockerRepo:$VERSION"
    dockerRepoArgs="$dockerRepoArgs --tag $dockerRepo:nightly"
    dockerRepoArgs="$dockerRepoArgs --tag $dockerRepo:latest"
  fi
  $docker buildx build --pull --platform=$(echo $ARCHES | sed 's/ /,/g') $dockerRepoArgs \
    --build-arg KASPAD_DOCKER_REPO="$KASPAD_DOCKER_REPO" \
    --build-arg KASPA_VERSION="$VERSION" \
    --build-arg KCHECK_DOCKER_REPO="$KCHECK_DOCKER_REPO" \
    --build-arg KCHECK_VERSION="$KCHECK_VERSION" \
    --tag $dockerRepo:$VERSION "$BUILD_DIR"
  echo "===================================================="
  echo " Completed multi arch build"
  echo "===================================================="
}

if [ "$PUSH" = "push" ]; then
  echo
  echo "===================================================="
  echo " Setup multi arch build ($ARCHES)"
  echo "===================================================="
  if $docker buildx create --name=mybuilder --append --node=mybuilder0 --platform=$(echo $ARCHES | sed 's/ /,/g') --bootstrap --use 1>/dev/null 2>&1; then
    echo "SUCCESS - doing multi arch build"
    multi_arch_build
  else
    echo "FAILED - building on current arch"
    plain_build
  fi
else
  plain_build
fi

