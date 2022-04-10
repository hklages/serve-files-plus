# inspired by https://github.com/BretFisher/node-docker-good-defaults/blob/main/Dockerfile
ARG NODE_VERSION=17
ARG OS=alpine
FROM node:${NODE_VERSION}-${OS}

LABEL AUTHOR heklages <nrcsplus@gmail.com>
LABEL created 2022-04-09T1603

# defaults to production
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

# latest npm for speed and fixes
RUN npm i npm@latest -g

# install dependencies first, in a different location for easier app bind mounting for local development
# due to default /opt permissions we have to create the dir with root and change perms

RUN mkdir /opt/serve-files-plus && chown node:node opt/serve-files-plus
WORKDIR /opt/serve-files-plus
# the official node image provides an unprivileged user as a security best practice
# but we have to manually enable it. We put it here so npm installs dependencies as the same
# user who runs the app.
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user

USER node

COPY --chown=node:node package.json package-lock.json* ./
RUN npm install ci --no-optional && npm cache clean --force
ENV PATH /opt/serve-files-plus/node_modules/.bin:$PATH

#copy app server.js and template directory
COPY --chown=node:node ./src/ /opt/serve-files-plus/src/

# default to port 3000 for node
ENV PORT=3000
EXPOSE $PORT
VOLUME  /opt/public

# still need root as mountpoint has owner root
USER root
ENTRYPOINT ["node", "/opt/serve-files-plus/src/server.js"]