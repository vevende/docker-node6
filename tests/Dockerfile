FROM vevende/node6:latest

COPY package.json /app
RUN gosu node npm install --silent

COPY entrypoint.* /docker-entrypoint.d/
COPY test.js /app

CMD ["mocha"]