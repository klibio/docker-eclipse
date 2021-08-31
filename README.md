# Docker Instructions

## Build
```bash
#!/bin/bash
docker build \
  --no-cache \
  --progress=plain \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VCS_REF=$(git rev-list -1 HEAD) \
    -t io.klib.docker.eclipse:latest \
    .
```

## Run
From within the root project directory run 
```bash
#!/bin/bash
docker container run \
    -d \
    --mount type=bind,source="$(pwd)"/workspace,target=/data/eclipse-workspace \
    -p 5800:5800 \
    io.klib.docker.eclipse:latest

docker container run \
    --name eclipse \
    --rm \
    -i -t io.klib.docker.eclipse \
    bash
```

