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
  . \

# tagging and pushing docker image

echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

# docker images are tagged with multiple tags depending on branch
# all images are tagged with version and date
# main branch will update the latest tag
# feature/bugfix branches will get a tag with there branch name (replacing slash with dash)

echo "# docker image tag $IMAGE $IMAGE:$VERSION.$DATE"
docker image tag $IMAGE $IMAGE:$VERSION.$DATE

if [ "$BRANCH" = "main" ]; then
  echo "# docker image tag $IMAGE $IMAGE:latest"
  docker image tag $IMAGE $IMAGE:latest
else
  echo "# docker image tag $IMAGE $IMAGE:${BRANCH/\//-}"
  docker image tag $IMAGE $IMAGE:${BRANCH/\//-}

  echo "# docker image tag $IMAGE $IMAGE:next"
  docker image tag $IMAGE $IMAGE:next
fi
docker image push --all-tags $IMAGE
exit 0
