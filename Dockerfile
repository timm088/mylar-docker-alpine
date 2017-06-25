FROM alpine:3.6

ENV LANG='en_AU.UTF-8' \
    LANGUAGE='en_AU.UTF-8'

RUN apk -U upgrade && \
    apk add --no-cache \
      ca-certificates \
      openssl \
      git \
      python \
      py2-pip py2-openssl py-libxml2 py2-lxml && \
\
    pip install \
      comictagger \
      configparser \
      tzlocal \
      pyopenssl && \
    rm -rf /root/.cache /tmp/* && \
\
    addgroup -S media && adduser -S media -G media && \
    mkdir /data /comics && \
    chown -R media:media /data/ /comics/ && \
\
    git clone -b development https://github.com/evilhero/mylar /mylar && \
    chown -R media:media /mylar/

EXPOSE 8090

USER media

VOLUME ["/data", "/comics"]

CMD ["/usr/bin/python", "/mylar/Mylar.py", "--datadir=/data", "--config=/data/config.ini", "--nolaunch"]
