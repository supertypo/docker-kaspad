#!/bin/sh

# Arguments: [push|nopush] [version] [git-repo]

REPO_URL_MAIN="https://github.com/kaspanet/kaspad"
DOCKER_REPO="supertypo/kaspad"
ARCHES="linux/amd64 linux/arm64"

BUILD_DIR="$(dirname $0)"
PUSH=$1
VERSION=$2
TAG=${3:-master}
REPO_URL=${4:-$REPO_URL_MAIN}
REPO_DIR="work/$(echo $REPO_URL | sed -E 's/[^a-zA-Z0-9]+/_/g')"

set -e

if [ ! -d "$BUILD_DIR/$REPO_DIR" ]; then
  git clone "$REPO_URL" "$BUILD_DIR/$REPO_DIR"
fi

echo "===================================================="
echo " Pulling $REPO_URL"
echo "===================================================="
(cd "$BUILD_DIR/$REPO_DIR" && git fetch && git checkout $TAG && (git pull 2>/dev/null | true))

tag=$(cd "$BUILD_DIR/$REPO_DIR" && git log -n1 --format="%cs.%h")

docker=docker
id -nG $USER | grep -qw docker || docker="sudo $docker"

plain_build() {
  echo
  echo "===================================================="
  echo " Running current arch build"
  echo "===================================================="
  dockerRepo="${DOCKER_REPO}"

  $docker build --pull \
    --build-arg REPO_URL=$REPO_URL \
    --build-arg REPO_DIR="$REPO_DIR" \
    --build-arg KASPA_VERSION="$tag" \
    --tag $dockerRepo:$tag "$BUILD_DIR"

  $docker tag $dockerRepo:$tag $dockerRepo:nightly
  echo Tagged $dockerRepo:nightly

  if [ -n "$VERSION" ]; then
     $docker tag $dockerRepo:$tag $dockerRepo:$VERSION
     echo Tagged $dockerRepo:$VERSION
     if [ "$REPO_URL" = "$REPO_URL_MAIN" ]; then
       $docker tag $dockerRepo:$tag $dockerRepo:latest
       echo Tagged $dockerRepo:latest
     fi
  fi

  if [ "$PUSH" = "push" ]; then
    $docker push $dockerRepo:$tag
    if [ -n "$VERSION" ]; then
      $docker push $dockerRepo:$VERSION
    fi
    if [ "$REPO_URL" = "$REPO_URL_MAIN" ]; then
      $docker push $dockerRepo:nightly
      if [ -n "$VERSION" ]; then
        $docker push $dockerRepo:latest
      fi
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
  if [ -n "$VERSION" ]; then
    dockerRepoArgs="$dockerRepoArgs --tag $dockerRepo:$VERSION"
  fi
  if [ "$REPO_URL" = "$REPO_URL_MAIN" ]; then
    if [ -n "$VERSION" ]; then
      dockerRepoArgs="$dockerRepoArgs --tag $dockerRepo:latest"
    else
      dockerRepoArgs="$dockerRepoArgs --tag $dockerRepo:nightly"
    fi
  fi
  $docker buildx build --pull --platform=$(echo $ARCHES | sed 's/ /,/g') $dockerRepoArgs \
    --build-arg REPO_URL=$REPO_URL \
    --build-arg REPO_DIR="$REPO_DIR" \
    --build-arg KASPA_VERSION="$tag" \
    --tag $dockerRepo:$tag "$BUILD_DIR"
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

