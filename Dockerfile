FROM node:9-alpine

ENV GOSU_VERSION 1.10
RUN set -ex \
    && apk add --no-cache --virtual .gosu-deps dpkg gnupg openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
# verify the signature
#    && export GNUPGHOME="$(mktemp -d)" \
#    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
#    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
# verify and cleanup
    && gosu nobody true \
    && apk del .gosu-deps

# Use edge packages
RUN set -ex \
    && sed -i -e 's/v3\.\d/edge/g' /etc/apk/repositories \
    && apk add --update --no-cache git python make musl-dev gcc

# Environment user
RUN set -x \
    && mkdir -p /app \
    && mkdir -p /docker-entrypoint.d \
    && chown node.node -R /app \
    && npm config set -g cache /app/.cache \
    && npm config set -g progress false \
    && npm config set -g jobs 2 \
    && npm config set -g color false \
    && npm config set -g loglevel http

ENV LANG=C.UTF-8 \
    LC_COLLATE=C \
    PATH=/app/node_modules/.bin:${PATH}

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

COPY docker-entrypoint.sh /sbin/docker-entrypoint.sh

WORKDIR /app

CMD ["node"]
