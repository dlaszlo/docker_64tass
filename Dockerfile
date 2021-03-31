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
    unzip 64tass-1.55.2200-src.zip &&\
    cd /build/64tass-1.55.2200-src &&\
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

FROM alpine:latest

COPY --from=c64tools /tools /tools

RUN apk add --no-cache --update make unzip curl python3 py3-pip nodejs npm &&\
    apk add --no-cache --update openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

ENV PATH="/tools:${PATH}"

WORKDIR /source

CMD make
