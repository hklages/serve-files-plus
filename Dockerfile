# PRINCIPLE: 
# Only user root, node and those being in node group have permission to launch Node.JS
# 
# Volume is mounted read only for safety. Permission is inherited from host with user: drwx 
# but for group and others: ---. As it is read only we can not change permission.
#
# That means: best is to create a new user with the same uid as the host user owning the files
# and add that user to group node and make all files accessable for group node user (directories
# and shell with x, all with in group). That is done also in the start script because it is not 
# necessary if you choose root or user with uid=1000 owns the host files.  
#
# inspired by https://github.com/BretFisher/node-docker-good-defaults/blob/main/Dockerfile
# check availability of combination at https://hub.docker.com/_/node/
ARG NODE_VERSION=19
ARG OS=alpine3.17

FROM node:${NODE_VERSION}-${OS}

LABEL AUTHOR heklages <nrcsplus@gmail.com>
LABEL created 2023-04-11

# defaults to production
ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV

# latest npm for speed and fixes
RUN npm i npm@latest -g

# create the workdir with owner node, being able to run Node.JS
RUN mkdir /opt/serve-files-plus && chown node:node /opt/serve-files-plus
WORKDIR /opt/serve-files-plus

# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user
# user node and group node
USER node
COPY --chown=node:node package.json package-lock.json* ./
RUN npm i --production && npm cache clean --force
ENV PATH=/opt/serve-files-plus/node_modules/.bin:$PATH

#copy my app server.js and template directory
COPY --chown=node:node ./src/ ./src/

# default to port 3000 for node
ENV PORT=3000
EXPOSE $PORT

# Volume, read only
# Permission is inherited from host with user: drwx but for group and others: ---
# As it is read only we can not change permission
VOLUME /opt/public

# use root as default or specify a uid (should be the owner of the served files)
# if env UID exist (recommended!) it is used instead of root
USER root
ENTRYPOINT ["sh", "./src/start_node_with_uid.sh"]
