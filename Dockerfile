FROM alpine:latest

RUN set -x \
 && apk update \
 && apk add --no-cache alpine-sdk automake autoconf \
 && git clone https://github.com/Parchive/par2cmdline.git /root/par2 \
 && cd /root/par2 && ./automake.sh && ./configure && make && make install \
 && apk del --purge alpine-sdk automake autoconf \
 && cd /root && rm -rf /root/par2 \
 && apk add --no-cache \
        ca-certificates \
        duplicity \
        openssh \
        openssl \
        py-crypto \
        py-pip \
        py-paramiko \
        py-setuptools \
        rsync \
 && update-ca-certificates \
 && pip install pydrive \
 && pip install pexpect \
 && apk del --purge py-pip \
 && adduser -D -u 1896 duplicity \
 && mkdir -p /home/duplicity/.cache/duplicity \
 && mkdir -p /home/duplicity/.gnupg \
 && chmod -R go+rwx /home/duplicity/

ENV HOME=/home/duplicity

VOLUME ["/home/duplicity/.cache/duplicity", "/home/duplicity/.gnupg"]

USER duplicity
 
CMD ["duplicity"]
