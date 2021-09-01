#!/bin/bash
# this script downloads and prepares the java runtime
set -eux && SCRIPT_DIR="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )" && cd $SCRIPT_DIR

# AdoptOpenJDK API - https://api.adoptopenjdk.net/README
QUERY_URL="https://api.adoptopenjdk.net/v2/info/releases/openjdk11?openjdk_impl=hotspot&os=linux&arch=x64&release=latest&type=jdk"

# jq - https://stedolan.github.io/jq/tutorial/
JAVA_URL=$(curl -L ${QUERY_URL} | jq '. | .binaries[0].binary_link') && JAVA_URL=${JAVA_URL%\"} && JAVA_URL=${JAVA_URL#\"}
JAVA_ARCHIVE=$(echo $JAVA_URL | sed "s/.*\///")
JAVA_DIR=$SCRIPT_DIR/jdk
mkdir -p $JAVA_DIR
echo "downloading and extract into $JAVA_DIR from $JAVA_URL"
curl -LfsSo $JAVA_ARCHIVE $JAVA_URL && tar -xvzf $JAVA_ARCHIVE --strip-components=1 -C $JAVA_DIR
rm -rf $JAVA_ARCHIVE
