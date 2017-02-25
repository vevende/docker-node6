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
    && chown node.node -R /app \
    && gosu node npm config set cache /app/.cache

ENV PATH="/app/node_modules/.bin:${PATH}"

ONBUILD COPY package.json /app
ONBUILD RUN cd /app \
        && gosu node npm install \
        && gosu node npm cache clean
