#!/bin/bash

# PURPOSE
# Shell Script to Build Docker Image and Start the Container.
# Existing images, container are deleted if exist.
# Container must be running otherwise it is not detected.

# HOW TO USE A BASH FILE: 
# File extension must be: sh
# Protection: $ sudo chmod +x <filename>
# Run it: $ bash <filename> within directory of Dockerfile

# CUSTOMIZE
# port 8080 to container port 3000
# mounts volume "/volume1/docker/MultiMedia/others" to container /srv, read only
# defines the following names for container and image
container_name="serve-files-plus"
image_name="serve-files-plus:latest" 

# remove existing image and build new 
result=$( sudo docker images -q $image_name )
if [[ -n "$result" ]]; then
echo "image exists - is being removed"
sudo docker rmi -f $image_name
else
echo "No such image"
fi
sudo docker build -t $image_name -f Dockerfile .

# remove old container and start new
result=$( sudo docker ps -q -f name=$container_name )
if [[ $? -eq 0 ]]; then
echo "Container exists"
sudo docker container rm -f $container_name
echo "Deleted the existing docker container"
else
echo "No such container"
fi

sudo docker run -itd \
-p "8080:3000" \
-v "/volume1/MultiMedia/others:/srv:ro" \
-e "NODE_ENV=production" \
-e "COL=4" \
--name $container_name \
$image_name 
# end of docker run command