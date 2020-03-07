FROM python:3.8-alpine

RUN echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies \
    g++ \
    gcc \
    libffi-dev \
    make \
    musl-dev
RUN echo "**** install runtime packages ****" && \
    apk add --no-cache \
    ca-certificates \
    curl \
    git \
    freetype \
    jpeg-dev \
    lcms2 \
    libwebp \
    openssl \
    p7zip \
    tar \
    tiff \
    tzdata \
    unrar \
    unzip \
    vnstat \
    wget \
    xz \
    zlib-dev
RUN echo "**** install python packages ****" && \
    adduser -u 1001 -S media -G users && \
    mkdir /data /comics && \
    chown -R media:users /data/ /comics/ && \
    \
    git clone -b master --depth=1 https://github.com/mylar3/mylar3 /mylar && \
    pip install -r /mylar/requirements.txt && \
    chown -R media:users /mylar/ && \
    \
    echo "**** clean up ****" && \
    apk del --purge \
    build-dependencies && \
    rm -rf /root/.cache /tmp/*

EXPOSE 8090

USER media

VOLUME ["/data", "/comics"]

WORKDIR /mylar

CMD ["python3", "/mylar/Mylar.py", "--datadir=/data", "--config=/data/config.ini", "--nolaunch"]
