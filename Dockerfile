FROM node:9-alpine

ENV GOSU_VERSION 1.10

# Use edge packages
RUN set -ex; \
    sed -i -e 's/v3\.\d/edge/g' /etc/apk/repositories; \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    apk add --upgrade --no-cache apk-tools; \
    apk add --update --no-cache gosu@testing; \
    apk add --update --no-cache git python make musl-dev gcc wget ca-certificates

# Environment user
RUN set -ex \
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
