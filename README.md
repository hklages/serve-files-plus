## serve-files-plus

This container serves files or shows directory index in a given directory and its subdirectory.  It is based on serve-index, standard NodeJS 17 alpine image, Bootstrap 5 and should only be used in a local network (http).

### Purpose

My Synology NAS acts as primary data server for multimedia, videos but also invoices, manuals and notification. `server-files-plus` is installed on Synology Docker and being used to make these data available to other applications such as Node-RED or grocy supporting http links.

Just mount the data read only to the container, assign a free port and use any browser to select the files, copy the link and insert that link into other application. Tested for mp3 files (notifications), pdf, jpg, png, odt (documents) files.

### Docker command

```Docker
 sudo docker run -itd \
-p "8080:3000" \
-v "/volume1/MultiMedia/others:/srv:ro" \
-e "NODE_ENV=production" \
-e "COL=4" \
 -- <your container name> \
  <your image name>
```

### Exposes

- Data mount point (Volume): /srv
- ENV variable PORT, the internal port, with default 3000
- ENV variable COL, the number of columns in directory listing, with default 5

### Internal setup

- code location: /usr/src/serve-files-plus
- uses server.js
- Official NodeJS image based on alpine
