#! /bin/sh

# PURPOSE: May create a user and use that to start node app. 
# Enables you to start node as non-root.
#
# PREREQ: The node image provides a node user in group node. 
# The node user is used to create the app.
# 
# METHOD: This script checks the existing of env UID. 
# IF UID exist and is not 0/1000 then a user "fileowner" is created.
# user fileowner is added to group node and being used to start node
# - otherwise root or node is being used to start node
# 
# Env variable UID should not existent, 0 or equal, above 1000 and
# be the uid of the owner of the mounted directory.
#
# WHY: To be able to mount a directory and start node as non-root.
# Docker mounts have permission user: rwx but none for group, others.
# So only the user and root can access the files.
#
# Author: heklages, 2022-04-13, Version 1.0

echo "starting script $0"

if [ -z ${UID+x}  ]; then 
  echo "UID is unset -> starting Node.js at user root"
  node  /opt/serve-files-plus/src/server.js
elif [ $UID -eq 0 ]; then
  echo "UID is 0 (root) -> starting Node.js as user root"
  node  /opt/serve-files-plus/src/server.js
elif [ $UID -lt 1000 ]; then
  echo "UID is in range 1 to 999 -> stopped"
elif [ $UID -eq 1000 ]; then
  echo "UID is 1000 -> starting Node.js existing user node"
  su -p node -c "node  /opt/serve-files-plus/src/server.js"
else 
  echo "Using UID to create user usrserve with uid $UID, adding to group node"
  adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "node" \
    --no-create-home \
    --uid "$UID" usrserve
  echo "starting Node.js with new user usrserve"
  su -p usrserve -c "node  /opt/serve-files-plus/src/server.js"
fi