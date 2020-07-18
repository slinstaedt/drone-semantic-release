FROM dronee/git-ssh

RUN apk add --no-cache npm
RUN npm install -g standard-version

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]
