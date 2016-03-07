FROM alpine:3.3
MAINTAINER Corey Butler

ENV PATH /letsencrypt/venv/bin:$PATH

WORKDIR /letsencrypt

RUN export BUILD_DEPS="git \
                build-base \
                libffi-dev \
                linux-headers \
                openssl-dev \
                py-pip \
                python-dev" \
    && apk add -U dialog \
                python \
                augeas-libs \
                ${BUILD_DEPS} \
    && pip --no-cache-dir install virtualenv \
    && git clone https://github.com/letsencrypt/letsencrypt /letsencrypt/src \
    && /letsencrypt/src/letsencrypt-auto-source/letsencrypt-auto --os-packages-only \
    && virtualenv --no-site-packages -p python2 /letsencrypt/venv \
    && sed -i '/^BIO \*BIO_new_mem_buf(const void \*buf, int len);/ d' /usr/include/openssl/bio.h \
    && /letsencrypt/venv/bin/pip install \
                -e /letsencrypt/src/acme \
                -e /letsencrypt/src \
                -e /letsencrypt/src/letsencrypt-apache \
                -e /letsencrypt/src/letsencrypt-nginx \
	&& apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/*

EXPOSE 80 443
VOLUME /etc/letsencrypt/


ENTRYPOINT ["letsencrypt"]
