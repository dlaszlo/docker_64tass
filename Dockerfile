# ==========================
# Build C64 tools
# ==========================
FROM ubuntu:latest as c64tools

COPY tools /build

RUN TZ=Europe/Budapest &&\
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apt-get -y update && apt-get -y upgrade &&\
    apt-get -y install cmake gcc g++ unzip curl openjdk-11-jdk-headless &&\
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
    rm -rf /build                  &&\
    cd /usr/lib/jvm/java-11-openjdk-amd64/bin &&\
    ./jlink --add-modules jdk.unsupported,jdk.compiler,java.base,java.desktop,java.naming,java.management,java.instrument,java.security.jgss \
            --verbose --compress 2 --no-header-files --no-man-pages --output /opt/java11

# ==========================
# Build 64TASS image
# ==========================
FROM ubuntu:latest

COPY --from=c64tools /tools /tools
COPY --from=c64tools /opt/java11 /opt/java11

RUN TZ=Europe/Budapest &&\
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apt-get -y update && apt-get -y upgrade &&\
    apt-get -y install make unzip curl python3 python3-pip nodejs npm

ENV JAVA_HOME="/opt/java11"
ENV PATH="/tools:/opt/java11/bin:${PATH}"

WORKDIR /source

CMD make
