## The Chain: From Code to Run in Docker or native NodeJS

### Developing on laptop-win11

Use VScode to edit data in `<user>.\development\serve-files-plus` directory and publish to github.

- CAUTION: When editing directory.html and eslint enabled the line with the style is incorrect and has to be corrected (1 line)

Use github as repository.

### Test the app in NodeJS on laptop-win11

Use VScode - terminal and paste:

`$ENV:PORT='8080'; $ENV:CONTENT_DIRECTORY='.'; $ENV:DOCKER='n'; node .\src\server.js`

You can verify that ENV are set with `dir env:` (windows or `printenv` in linux)

You should see the page in any browser at address `localhost:3000`

Using the same terminal session, you can restart the app with

`node .\src\server.js`

### Build the Docker image and push it to the Docker hub on laptop-win11

Use laptop - docker

```Docker
docker build -t heklages/serve-files-plus:<version> -f Dockerfile .
docker login
docker push heklages/serve-files-plus:<version>
docker logout
```

All images:
`docker images`

### Run container at NAS (use the docker add on)

Use synology build in up or via command line

```Docker
docker run -itd \
-p "8080:3000" \
-v "/volume1/MultiMedia/others:/opt/public:ro" \
-e "NODE_ENV=production" \
-e "COL=4" \
--name serve-files-plus \
heklages/server-files-plus 
```

### Use case

In any browser: `hhNas.fritz.box:8080`

Use the directory index to select and copy the http-link for that file Make that file available in Grocy user fields, link with title for relevant invoices and device manuals.

- TODO how to use the node user and avoid root
- TODO create tag latest
- TODO issue with portainer and manifests
- TODO hidden file on/off via ENV?
- TODO resize columns via http request?
