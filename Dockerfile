FROM alpine:3.6

LABEL maintainer="liukangxu <liukangxu1996@gmail.com>"

ARG TZ='Asia/Shanghai'

ENV TZ $TZ
ENV SS_LIBEV_VERSION 3.0.8

RUN apk upgrade --update \
    && apk add bash tzdata libsodium nodejs \
    && apk add --virtual .build-deps \
        autoconf \
        automake \
        asciidoc \
        xmlto \
        build-base \
        curl \
        libev-dev \
        libtool \
        linux-headers \
        udns-dev \
        libsodium-dev \
        mbedtls-dev \
        pcre-dev \
        udns-dev \
        tar \
        git \
        nodejs-npm \
    && npm i -g shadowsocks-manager \
    && curl -sSLO https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_LIBEV_VERSION/shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz \
    && tar -zxf shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz \
    && (cd shadowsocks-libev-$SS_LIBEV_VERSION \
    && ./configure --prefix=/usr --disable-documentation \
    && make install ) \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* /usr/bin/ssmgr \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
        )" \
    && apk add --no-cache --virtual .run-deps $runDeps \
    && apk del .build-deps \
    && rm -rf \
        shadowsocks-libev-$SS_LIBEV_VERSION.tar.gz \
        shadowsocks-libev-$SS_LIBEV_VERSION \
        /var/cache/apk/*

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
