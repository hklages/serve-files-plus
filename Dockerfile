
ARG NODE_VERSION=17
ARG OS=alpine

FROM node:${NODE_VERSION}-${OS}

ENV PORT=3000

# create app with dependencies and templates
WORKDIR /usr/src/serve-files-plus
COPY package*.json ./
RUN npm ci --only=production
# - app
COPY server.js ./
# - special designed templates
WORKDIR /usr/src/serve-files-plus/templates
COPY ./templates/* ./

# Data mount point
RUN mkdir -p "/srv" 
VOLUME /srv

EXPOSE $PORT

ENTRYPOINT ["node", "/usr/src/serve-files-plus/server.js"]

LABEL AUTHOR heklages <nrcsplus@gmail.com>
LABEL created 2022-04-08T0844