FROM alpine:3.10

RUN apk -U upgrade && echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies \
    autoconf \
    automake \
    freetype-dev \
    g++ \
    gcc \
    jpeg-dev \
    lcms2-dev \
    libffi-dev \
    libpng-dev \
    libwebp-dev \
    linux-headers \
    make \
    openjpeg-dev \
    openssl-dev \
    python2-dev \
    tiff-dev \
    zlib-dev && \
    echo "**** install runtime packages ****" && \
    apk add --no-cache \
    ca-certificates \
    curl \
    freetype \
    git \
    lcms2 \
    libjpeg-turbo \
    libwebp \
    openjpeg \
    openssl \
    p7zip \
    py2-lxml \
    py2-openssl \
    py2-pip \
    py-libxml2 \
    py2-lxml \
    python \
    tar \
    tiff \
    tzdata \
    unrar \
    unzip \
    vnstat \
    wget \
    xz \
    zlib
RUN echo "**** install python packages ****" && \
    pip install \
    comictagger \
    configparser \
    tzlocal \
    pyopenssl  && echo "**** clean up ****" && \
    apk del --purge \
    build-dependencies && \
    rm -rf /root/.cache /tmp/* && \
    \
    adduser -u 1001 -S media -G users && \
    mkdir /data /comics && \
    chown -R media:users /data/ /comics/ && \
    \
    git clone -b development --depth=1 https://github.com/evilhero/mylar /mylar && \
    chown -R media:users /mylar/

EXPOSE 8090

USER media

VOLUME ["/data", "/comics"]

WORKDIR /mylar

CMD ["/usr/bin/python", "/mylar/Mylar.py", "--datadir=/data", "--config=/data/config.ini", "--nolaunch"]
