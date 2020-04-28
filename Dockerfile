FROM node:lts-alpine

RUN apk add --no-cache bash sed git
RUN npm install -g standard-version

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]
