## The Chain: From Code to Run in Docker or native NodeJS

### Coding on laptop-win11

VScode to edit data in `<user>.\development\serve-files-plus` directory and publish to github repository hklages serve-files-plus

- CAUTION: When editing directory.html and eslint enabled the line with the style is incorrect and has to be corrected (1 line)

Change things such the

- bootstrap version in .\src\template\directory.html
- the dependencies in package.json (and do the npm update in that directory)
- the overall experience in the style sheets or directory.html
- the code in server.js
- ...

### Testing app in Node.js on laptop-win11

Use VScode - terminal and paste:

`$ENV:PORT='8080'; $ENV:CONTENT_DIRECTORY='.'; $ENV:DOCKER='n'; node .\src\server.js`

You can verify that ENV are set with `dir env:` (`printenv` in linux)

You should see the page in any browser at address `localhost:8080`
(the default is 3000)

Using the same terminal session, restart it with `node .\src\server.js`

### Update the Dockerfile

VScode to edit the Dockerfile and change things such the Alpine image version, Node version (must)

### Build Docker image and push it to Docker hub on laptop-win11

Notice that heklages is being used as that is the user on DockerHub - adjust the version!
Docker for Windows: `docker build -t heklages/serve-files-plus:0.2.7 -f Dockerfile .`

Copy the files from Windows Development to NAS Development\DockerBuildImage. Sometimes dockerignore causes error messages.
Use Docker on NAS:Copy from Windows to /Development/BuildDockerImage and go that directory

`sudo docker build -t heklages/serve-files-plus:0.2.7 -f Dockerfile .`

Then push it to Docker Hub - do it twice for version and tag latest.

```Docker
sudo docker login
sudo docker push heklages/serve-files-plus:<version>
sudo docker logout
```

Tag as latest:
`sudo docker tag heklages/serve-files-plus:0.2.6 heklages/serve-files-plus:latest`

List of images:
`docker images`

### Run container at NAS (using the Synology Docker package)

Use the Docker package or Bitwise SSH client:

Caution: UID should be set to 1026 - change last 2 lines

```Docker
sudo docker run -itd --init \
-m "300M" --memory-swap "1G" \
-p "8080:3000" \
-v "/volume1/MultiMedia/others:/opt/public:ro" \
-e "NODE_ENV=production" \
-e "COL=4" \
-e "UID=1026" \
--name serve-files-plus-7 \
heklages/serve-files-plus:0.2.7 
```

On Windows Docker environment:

```Docker
docker run -itd --init -m "300M" --memory-swap "1G" -p "8081:3000" -v "C:\Intel:/opt/public:ro" -e "NODE_ENV=production" -e "COL=4" -e "UID=1000" --name  hbeta serve-files-plus:test 
```

docker run -itd --init -p "8081:3000" -v "C:\Intel:/opt/public:ro" -e "NODE_ENV=production" -e "COL=4" --name  hbeta serve-files-plus:test

### Starting

Use the directory index to select and copy the http-link for that file Make that file available in Grocy user fields, link with title for relevant invoices and device manuals.

In any browser: `hhNas.fritz.box:8080`

You can enter terminal mod with \bin\sh and inspect the container

### Open issues

- TODO UID=1026 - check why not working
- TODO catch internal server error in case of missing permissions
- TODO issue with portainer and manifests
- TODO remove eslint, etc from image, also yarn!
- TODO improve bootstrap definitions
- TODO hidden file on/off via ENV?
- TODO use git actions
- TODO docker-compose instead of run commands
- TODO resize columns via http request?

# Buildx instead of build

[original from here](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/)

```Docker
docker buildx create --use
docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64  --tag heklages/serve-files-plus:<version> .
```
