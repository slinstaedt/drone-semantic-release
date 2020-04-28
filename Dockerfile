FROM node:lts-alpine

RUN apk add --no-cache git
RUN npm install -g standard-version

ENTRYPOINT [ "standard-version" ]
