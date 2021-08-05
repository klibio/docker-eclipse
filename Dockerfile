# GOLANG BUILD CONTAINER for easy-novnc
#   build easy-novnc server
FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

# APPLICATION RUNTIME container
FROM debian:buster

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.authors="dev@klib.io" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/klibio/example.bnd.rcp" \
      org.label-schema.vcs-ref=$VCS_REF
# Workaround https://unix.stackexchange.com/questions/2544/how-to-work-around-release-file-expired-problem-on-a-local-mirror
RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        openbox \
        tigervnc-standalone-server \
        supervisor \
        gosu \
        \
        libxext6 \
        libxtst6 \
        \
        pcmanfm \
        xarchiver \
        nano \
        geany \
        procps && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends lxterminal wget openssh-client rsync ca-certificates xdg-utils htop tar xzip gzip bzip2 zip unzip && \
    rm -rf /var/lib/apt/lists

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY menu.xml /etc/xdg/openbox/
COPY supervisord.conf /etc/

EXPOSE 8080

#add unix user and group with specific home dir ~
RUN groupadd --gid 1000 app && \
    useradd --home-dir /data --shell /bin/bash --uid 1000 --gid 1000 app && \
    mkdir -p /data
VOLUME /data

ARG Java11URL=https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
ARG Java8URL=https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u302b08.tar.gz

SHELL [ "/bin/bash", "-c"]
RUN cd /data && \
    wget -q -O - ${Java11URL} | tar -xvz && \
    JavaURLdecoded=$(echo "$Java11URL" | sed "s/%2B/+/") \
    extractJava11Dir=`expr "${JavaURLdecoded}" : '.*/\(.*\)/.*'` && mv ${extractJava11Dir} jdk11 && \
    export JAVA_HOME=/data/jre/${extractJavaDir} && \
    export PATH="${JAVA_HOME}/bin:$PATH"

# Download and unpack Java8 binaries
SHELL [ "/bin/bash", "-c"]
RUN cd /data && \
    wget -q -O - ${Java8URL} | tar -xvz && \
    extractJava8Dir=`expr "${Java8URL}" : '.*/\(.*\)/.*'` && mv ${extractJava8Dir} jdk8

# Download and unpack eclipse for Java Devs (version 2021-06)
ARG EclipseURL=https://ftp.fau.de/eclipse/technology/epp/downloads/release/2021-06/R/eclipse-java-2021-06-R-linux-gtk-x86_64.tar.gz
SHELL [ "/bin/bash", "-c"]
RUN cd /data && \
    wget -q -O - ${EclipseURL} | tar -xvz

COPY environment /etc/environment

CMD ["sh", "-c", "chown app:app /data /dev/stdout && exec gosu app supervisord"]
