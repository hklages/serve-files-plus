#! /bin/sh

# PURPOSE: Selects the user/uid depending on ENV UID and starts the webserver
# with that uid. See Dockerfile to understand the challenge and best practice
# 
# IF UID omitted root is used
# - UID = 1000: that used to launch the webserver
# - otherwise
#   a user "usrx" is being created, added to node group and the 
#   permission of source files is modified to enable start of server.
#   Webserver is started as user usrx!
#
# Author: H. Klages, 2023-04-13, Version 2.1
#
echo "starting script $0"

if [ -z ${UID+x} ]; then 
  echo "UID is not set -> starting Node.js at user root. That may be a risk."
  node  /opt/serve-files-plus/src/server.js
elif [ $UID -lt 1000 ]; then
  echo "UID is in range 1 to 999 - that is not allowed -> stopped"
elif [ $UID -eq 1000 ]; then
  echo "UID is 1000 -> starting Node.js at existing user node - must have access to files!"
  su -p node -c "node  /opt/serve-files-plus/src/server.js"
else 
  echo "Create user usrx with uid $UID, adding that to group node, start NodeJS with this user."
  adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "node" \
    --no-create-home \
    --uid "$UID" usrx
  # give new user access to copied files
  chmod -R g=r  /opt/serve-files-plus/src/
  chmod g=rx    /opt/serve-files-plus/src/server.js
  chmod g=rx    /opt/serve-files-plus/src
  chmod g=rx    /opt/serve-files-plus/src/templates

  echo "starting Node.js with new user usrx"
  su -p usrx -c "node  /opt/serve-files-plus/src/server.js"
fi