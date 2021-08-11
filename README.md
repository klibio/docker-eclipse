# Docker Instructions

## Build
```
docker build \
    --no-cache \
    --progress=plain \
    --build-arg BUILD-DATE=today \
    --build-arg VCS_REF=feature \
    -t io.klib.docker.eclipse \
    .
```

## Run
From within the root project directory run 
```
docker container run \
    -d \
    --mount type=bind,source="$(pwd)"/workspace,target=/data/eclipse-workspace
    -p 5800:5800
    <image_name>
```

