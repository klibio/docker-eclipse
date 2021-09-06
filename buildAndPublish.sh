#!/bin/bash

# env validation
printf "\n# validate mandatory environment configuration variables\n\n"
if [[ -z "$DOCKER_USERNAME" || -z "$DOCKER_TOKEN" ]]; 
  then echo "  missing ENV var DOCKER_USER and DOCKER_TOKEN"; exit 1; 
  else echo "  found mandatory env vars for DOCKER_USER=$DOCKER_USERNAME and DOCKER_TOKEN=<hidden>"; 
fi
# activate bash checks for unset vars, pipe fails
set -eauo pipefail

BRANCH=$(git rev-parse --abbrev-ref HEAD)
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
IMAGE="klibio/eclipse"
VERSION=`cat version.txt`
echo "# launching docker build for image $IMAGE"
docker build \
  --no-cache \
  --progress=plain \
  --build-arg BUILD_DATE=$DATE \
  --build-arg VCS_REF=$(git rev-list -1 HEAD) \
  --build-arg VERSION=$VERSION \
  -t $IMAGE \
  .

echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "# docker image tag $IMAGE $IMAGE:$VERSION.$DATE"
docker image tag $IMAGE $IMAGE:$VERSION.$DATE

echo "# docker image tag $IMAGE $IMAGE:${BRANCH/\//-}"
docker image tag $IMAGE $IMAGE:${BRANCH/\//-}

if [ "$BRANCH" = "main" ]; then
  docker image tag $IMAGE $IMAGE:latest
  echo "# docker image tag $IMAGE $IMAGE:latest"
else
  docker image tag $IMAGE $IMAGE:next
  echo "# docker image tag $IMAGE $IMAGE:next"
fi
docker image push --all-tags $IMAGE
exit 0
