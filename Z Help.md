## Process from code to running docker

### Developing on LaptopWin11

Use VScode to edit data in `.\development\serve-files-plus` directory and publish to github.
Data is on laptop (no mount).

Push each change to the github repository (inside vscode)!

### Test the app in NodeJS on LaptopWin11

Use VScode - terminal and paste:

`$ENV:PORT='8080'; $ENV:CONTENT_DIR='..'; $ENV:TEST_CASE='yes'; $ENV:DOCKER='n'; node .\server.js`

You can verify that ENV are set with `dir env:`

You should see the page in any browser at address `localhost:8080`

Using the same terminal session, you can restart the app with

`node .\server.js`

### Build the Docker image and push it to the Docker hub on LaptopWin11

Use laptop - docker

```Docker
docker build -t heklages/serve-files-plus:0.1.1 -f Dockerfile .
docker login
docker push heklages/serve-files-plus:0.1.1
docker logout
```

All images:
`docker images`

Retag an image
`docker tag 6e0959951283 heklages/serve-files-plus:0.1.1`

### Run container at NAS (use the docker add on)

Use synology build in up or via command line

```Docker
docker run -itd \
-p "8080:3000" \
-v "/volume1/MultiMedia/others:/srv:ro" \
-e "NODE_ENV=production" \
-e "COL=4" \
--name serve-files-plus \
heklages/server-files-plus 
```

### Use case

In any browser: `hhNas.fritz.box:8080`

Use the directory index to select and copy the http-link for that file Make that file available in Grocy user fields, link with title for relevant invoices and device manuals.

TODO:

- handle the tags
- hidden file on/off via ENV?
- resize columns via http request?
- improve directory structure
