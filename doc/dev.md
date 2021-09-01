# Development

## Java installation

`jq '.'` is used for "pretty-print" formatting

```bash
#!/bin/bash
curl -L 'https://api.adoptopenjdk.net/v2/info/releases/openjdk11?openjdk_impl=hotspot&os=linux&arch=x64&release=latest&type=jdk' | jq '. | .binaries[0].binary_link'
 ```
 
