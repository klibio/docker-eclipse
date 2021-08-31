# docker-eclipse

This images provides a browser based [Eclipse IDE - https://download.eclipse.org/eclipse/downloads/](https://download.eclipse.org/eclipse/downloads/).
Installation of eclipse IDE is done via Eclipse OSGi starterkit.

## container
[![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/klibio/eclipse/latest)](https://hub.docker.com/r/klibio/eclipse)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/klibio/eclipse/latest)](https://hub.docker.com/r/klibio/eclipse)
[![GitHub](https://img.shields.io/github/license/klibio/docker-eclipse)](https://raw.githubusercontent.com/klibio/docker-eclipse/main/LICENSE)

## liveliness
[![build and docker publish](https://github.com/klibio/docker-eclipse/actions/workflows/actions_build.yml/badge.svg)](https://github.com/klibio/docker-eclipse/actions/workflows/actions_build.yml?query=branch%3Amain)
[![Docker Pulls](https://img.shields.io/docker/pulls/klibio/eclipse)](https://hub.docker.com/repository/docker/klibio/eclipse)
[![OpenIssues](https://img.shields.io/github/issues-raw/klibio/docker-eclipse)](https://github.com/klibio/docker-eclipse/issues?q=is%3Aopen+is%3Aissue)
[![OpenPullRequests](https://img.shields.io/github/issues-pr-raw/klibio/docker-eclipse)](https://github.com/klibio/docker-eclipse/pulls?q=is%3Aopen+is%3Apr)

## run docker image
From within the root project directory run 
```bash
#!/bin/bash
docker container run -d \
  --mount type=bind,source="$(pwd)"/workspace,target=/data/workspace \
  -p 5858:5800 \
  klibio/eclipse:latest
```

Access the desktop via [WebBrowser - http://localhost:5858](http://localhost:5858)

## building
```bash
#!/bin/bash
docker build \
  --no-cache \
  --progress=plain \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VCS_REF=$(git rev-list -1 HEAD) \
  --build-arg VERSION=`cat version.txt` \
  -t klibio/eclipse:latest \
  .
```



