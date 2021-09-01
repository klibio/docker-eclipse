#!/bin/bash
set -eux && SCRIPT_DIR="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"

# this script downloads and prepares the java runtime
cd $SCRIPT_DIR
JAVA_URL=https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jre_x64_linux_hotspot_11.0.11_9.tar.gz
JAVA_ARCHIVE=$(echo "${JAVA_URL}" | sed "s/.*\///")
mkdir $SCRIPT_DIR/jre
curl -LfsSo ${JAVA_ARCHIVE} ${JAVA_URL} && tar -xvzf ${JAVA_ARCHIVE} --strip-components=1 -C $SCRIPT_DIR/jre
rm -rf $JAVA_ARCHIVE
