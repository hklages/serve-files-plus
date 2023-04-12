#! /bin/sh

# PURPOSE: Serves directories and files given in a linked volume (read only)
# via web server (defined in server.js). With ENV UID you can define the 
# UID to be used to run the webserver. 
# 
# CHALLENGE: 
# Docker mounts have permission user: rwx but none for group, others.
# So only the user and root can access the files.
# The webserver should not have root permission but the served files 
# should be accessable (read). Best way is to have one uid to own all served files and
# provide that uid via ENV UID. A user with that uid is being created, added to group node
# and used to launch the webserver. Alternatively: omit UID and use root.  
#
# INFO: default alpine node image provides user/group node to launch nodeJS.
# UID is 1000. 
# 
# ENV UID should be omitted or the UID of the file owner (>=1000)
# IF UID omitted root is used
# - UID = 1000: is used to launch the webserver
# - otherwise
#   a user "usrx" is being created, added to node group and the 
#   permission of source files is modified to enable start of server.
#   Webserver is started as user usrx!
#
# Author: H. Klages, 2023-04-12, Version 2.0
#
echo "starting script $0"

if [ -z ${UID+x} ]; then 
  echo "UID is not set -> starting Node.js at user root"
  node  /opt/serve-files-plus/src/server.js
elif [ $UID -lt 1000 ]; then
  echo "UID is in range 1 to 999 -> stopped"
elif [ $UID -eq 1000 ]; then
  echo "UID is 1000 -> starting Node.js existing user node UID = 1000 - must have access to files!"
  su -p node -c "node  /opt/serve-files-plus/src/server.js"
else 
  echo "Using UID to create user usrx with uid $UID, adding to group node, allow read"
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