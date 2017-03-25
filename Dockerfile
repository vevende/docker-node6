FROM node:6-alpine

# Use edge packages
RUN set -ex \
    && sed -i -e 's/v3\.5/edge/g' /etc/apk/repositories \
    && apk add --update --no-cache git python make

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
