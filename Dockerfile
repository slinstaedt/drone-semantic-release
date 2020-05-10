FROM node:lts-alpine

COPY --from=kamalook/drone-plugin-base /usr/local/bin/* /usr/local/bin/
RUN apk add --no-cache git openssh-client
RUN npm install -g standard-version

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]
