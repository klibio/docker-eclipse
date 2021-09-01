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
DATE=$(date +'%Y.%m.%d-%H.%M.%S')
IMAGE="klibio/eclipse"
VERSION=`cat version.txt`
echo "# launching docker build for image $IMAGE:$VERSION.$DATE"
docker build \
  --no-cache \
  --progress=plain \
  --build-arg BUILD_DATE=$DATE \
  --build-arg VCS_REF=$(git rev-list -1 HEAD) \
  --build-arg VERSION=$VERSION \
  -t "$IMAGE:$VERSION.$DATE" \
  -t "$IMAGE:latest" \
  .

echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "$IMAGE:$VERSION.$DATE"
echo "# successfully pushed $IMAGE:$VERSION.$DATE to DockerHub https://hub.docker.com/r/$IMAGE"
if [ "$BRANCH" = "main" ]; then
  docker push "$IMAGE:latest"
  echo "# successfully updated $IMAGE:latest image on DockerHub https://hub.docker.com/r/$IMAGE"
#else
#  docker push "$IMAGE:next"
#  echo "# successfully updated $IMAGE:next image on DockerHub https://hub.docker.com/r/$IMAGE"
fi
exit 0
