FROM vevende/node6:latest

COPY entrypoint.js /docker-entrypoint.d/
COPY entrypoint.sh /docker-entrypoint.d/
COPY package.json /app
COPY test.js /app

CMD ["mocha"]