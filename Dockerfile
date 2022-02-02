# ==========================
# Build C64 tools
# ==========================
FROM alpine:latest as c64tools 

COPY tools /build

RUN apk add --no-cache --update build-base curl make unzip &&\
    mkdir /source                  &&\
    mkdir /tools                   &&\
    mkdir /build/exomizer          &&\
    cd /build/exomizer             &&\
    unzip ../exomizer-3.1.0.zip    &&\
    cd /build                      &&\
    unzip b2.zip                   &&\
    unzip 64tass-1.56.2625-src.zip &&\
    cd /build/64tass-1.56.2625-src &&\
    make                           &&\
    mv 64tass /tools               &&\
    cd /build/exomizer/src         &&\
    make                           &&\
    mv exobasic /tools             &&\
    mv exomizer /tools             &&\
    cd /build/b2                   &&\
    make                           &&\
    mv b2.exe /tools/b2            &&\
    rm -rf /build

# ==========================
# Repack JAVA11
# ==========================
FROM alpine:latest as javabuild

RUN apk add --no-cache --update openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community &&\
    cd /usr/lib/jvm/java-11-openjdk/bin &&\
    ./jlink --add-modules jdk.unsupported,jdk.compiler,java.base,java.desktop,java.naming,java.management,java.instrument,java.security.jgss \
            --verbose --compress 2 --no-header-files --no-man-pages --output /opt/java11

# ==========================
# Build 64TASS image
# ==========================
FROM alpine:latest

COPY --from=c64tools /tools /tools
COPY --from=javabuild /opt/java11 /opt/java11

RUN apk add --no-cache --update build-base make unzip curl python3 py3-pip nodejs npm

ENV JAVA_HOME="/opt/java11"
ENV PATH="/tools:/opt/java11/bin:${PATH}"

WORKDIR /source

CMD make
