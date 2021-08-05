# Docker Instructions

## Build
```
docker build \
    --no-cache \
    --progress=plain \
    --build-arg BUILD-DATE=today \
    --build-arg VCS_REF=feature \
    -t test \
    .
```

## Run
```
docker container run \
    -d \
    --mount type=bind,source="$(pwd)"/workspace,target=eclipse-workspace
    -p 5800:5800 
```

