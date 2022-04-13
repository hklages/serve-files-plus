# inspired by https://github.com/BretFisher/node-docker-good-defaults/blob/main/Dockerfile
ARG NODE_VERSION=17.8.0
ARG OS=alpine3.15

FROM node:${NODE_VERSION}-${OS}

LABEL AUTHOR heklages <nrcsplus@gmail.com>
LABEL created 2022-04-12

# defaults to production
ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV

# latest npm for speed and fixes
RUN npm i npm@latest -g
# node user is 1000:1000 - but in this case useless because of ro mounted volume
RUN mkdir /opt/serve-files-plus && chown node:node opt/serve-files-plus
WORKDIR /opt/serve-files-plus

# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user

USER node
COPY --chown=node:node package.json package-lock.json* ./
RUN npm ci --production && npm cache clean --force
ENV PATH=/opt/serve-files-plus/node_modules/.bin:$PATH

#copy app server.js and template directory
COPY --chown=node:node ./src/ /opt/serve-files-plus/src/

# default to port 3000 for node
ENV PORT=3000
EXPOSE $PORT

# Volume, read only
# Permission is inherited from host with user: drwx but for group and others: ---
# As it is read only we can not change permission
VOLUME /opt/public

# root necessary to use as default and be able to add user
# if env UID exist su to UID in script.
USER root
ENTRYPOINT ["sh", "./src/start_node_with_uid.sh"]
