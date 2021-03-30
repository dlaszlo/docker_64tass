FROM alpine:latest

COPY tools /tools

RUN apk add --no-cache --update build-base curl make unzip python3 py3-pip nodejs npm &&\
    apk add --no-cache --update openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

RUN mkdir /source                  &&\
    mkdir /tools/exomizer          &&\
    cd /tools/exomizer             &&\
    unzip ../exomizer-3.1.0.zip    &&\
    cd /tools                      &&\
    unzip b2.zip                   &&\
    unzip 64tass-1.55.2200-src.zip &&\
    cd /tools/64tass-1.55.2200-src &&\
    make                           &&\
    mv 64tass /bin                 &&\
    cd /tools/exomizer/src         &&\
    make                           &&\
    mv exobasic /bin               &&\
    mv exomizer /bin               &&\
    cd /tools/b2                   &&\
    make                           &&\
    mv b2.exe /bin/b2              &&\
    cd /                           &&\
    rm -rf tools

WORKDIR /source

CMD make
