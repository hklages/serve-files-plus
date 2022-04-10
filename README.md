## serve-files-plus

This container serves files or shows directory index in a given directory and its subdirectory.
It is based on serve-index, standard NodeJS 17 alpine image, Bootstrap 5 and should only be used in a local network (http).

### Purpose

My Synology NAS acts as primary data server for multimedia, videos but also invoices, manuals and notification. `server-files-plus` is installed on Synology Docker and makes the data available to other applications supporting http links (in my case Node-RED, grocy).

Just mount the data read only to the container, assign a free port and use any browser to select the files, copy the link and insert that link into any other application.

Tested on Synology NAS for mp3 files (notifications), pdf, jpg, png, odt (documents) files.

The message "internal server error" may occur if the content file/directory is not accessible"

### Docker command

```Docker
 sudo docker run -itd \
-p "8080:3000" \
-v "/volume1/MultiMedia/others:/opt/public:ro" \
-e "COL=4" \
 -- <your container name> \
  <your image name>
```

### Exposes

- Port 3000
- Data mount point (Volume): /opt/public
- ENV CONTENT_DIRECTORY: location of served content, default is /opt/public
- ENV COL: the number of columns in directory listing, with default 4

### Internal setup

- code location: /opt/serve-files-plus/server.js
- Official NodeJS image based on alpine
