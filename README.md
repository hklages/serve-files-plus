
# serve-files-plus

Serves files or shows directory index in a given directory and its subdirectory.

 Should only be used in local network!
 It is based on serve-index, NodeJS 17, Bootstrap 5

## Docker command

```Docker
 sudo docker run -itd \
-p "8080:3000" \
-v "/volume1/MultiMedia/others:/srv:ro" \
-e "NODE_ENV=production" \
-e "COL=4" \
 -- <your container name> \
  <your image name>
```

## Exposes

- Data mount point (Volume): /srv
- ENV variable PORT, the internal port, with default 3000
- ENV variable COL, the number of columns in directory listing, with default 5

## Internal setup

- code location: /usr/src/serve-files-plus
- uses server.js
- Official NodeJS image based on alpine
