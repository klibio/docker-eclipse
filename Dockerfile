# GOLANG BUILD CONTAINER for easy-novnc
#   build easy-novnc server
FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

# APPLICATION RUNTIME container
FROM debian:buster-slim

ARG VERSION=NOT-SET
ARG BUILD_DATE=NOT-SET
ARG VCS_REF=NOT-SET

LABEL org.opencontainers.image.authors="dev@klib.io" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$VERSION.$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/klibio/docker-osgi-starterkit" \
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
        procps \
        \
        lxterminal wget openssh-client rsync ca-certificates jq xdg-utils htop tar xzip gzip bzip2 zip unzip \
        tzdata curl ca-certificates && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY resources/etc /etc

EXPOSE 8080

#add unix user and group with specific home dir ~
RUN groupadd --gid 1000 app && \
    useradd --home-dir /data --shell /bin/bash --uid 1000 --gid 1000 app && \
    usermod -a -G tty app && \
    mkdir -p /data && \
    echo $VERSION.$BUILD_DATE > /data/build_$VERSION.$BUILD_DATE.txt

ADD --chown=app:app resources/data /data/
RUN cd /data && \
    ./setup_01_java.sh && \
    ./setup_02_osgi-starterkit.sh && \
    ./setup_03_eclipse.sh
ENV JAVA_HOME=/data/jdk
ENV PATH=/data/jdk/bin:$PATH

ENTRYPOINT [ "sh", "-c", "gosu app supervisord" ]
