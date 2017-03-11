FROM node:6-slim

RUN buildDeps='wget ca-certificates' \
    && set -x \
    && apt-get update -y \
    && apt-get install -q -y --no-install-recommends python $buildDeps \
    && wget -O /sbin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
    && chmod +x /sbin/gosu \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && rm -rf /usr/share/{man,doc}/ \
    && rm -rf /var/log/* \
    && rm -rf /tmp/*

WORKDIR /app

COPY docker-entrypoint.sh /sbin/docker-entrypoint.sh
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]

RUN set -x \
    && mkdir -p /app \
    && chown node.node -R /app

ENV LANG=C.UTF-8 \
    LC_COLLATE=C \
    APP_USER=node \
    PATH=/app/node_modules/.bin:${PATH}

RUN set -x \
    && npm config set -g cache /app/.cache \
    && npm config set -g progress false \
    && npm config set -g jobs 2 \
    && npm config set -g color false \
    && npm config set -g loglevel http
