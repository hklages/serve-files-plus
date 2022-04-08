'use strict'

/** 
 * Serves files or shows directory index in a given directory and its subdirectory.
 * 
 * ENV variables are required
 * - CONTENT_DIRECTORY: full path to directory
 * - PORT: available port such as 8080, ...
 * - COL: number of columns in directory listing, 4 to 10
 * 
 * - DOCKER: default is y - to run in non-Docker environment use 'n'
 * 
 * from: https://www.npmjs.com/package/serve-index
*/

const http = require('http')
const finalHandler = require('finalhandler')
const serveIndex = require('serve-index')
const serveStatic = require('serve-static')

const CONTENT_DIRECTORY = process.env.CONTENT_DIR || '/srv'
const PORT = process.env.PORT || 3000
const DOCKER = process.env.DOCKER || 'y'
const COL = process.env.COL || '6'

// Serve directory index
if (['4', '5', '6', '7', '8', '9', '10'].indexOf(COL) < 0) {
  console.log('Invalid env value for COL (4 to 10) >' + COL)

} else {
 
  let options
  if (DOCKER === 'y') {
    options = {
      'icons': true,
      'template': '/usr/src/serve-files-plus/templates/directory.html',
      'stylesheet': `/usr/src/serve-files-plus/templates/style${COL}.css`
    }
  } else {
    options = {
      'icons': true,
      'template': './templates/directory.html',
      'stylesheet': `./templates/style${COL}.css`
    }
  }
  const index = serveIndex(CONTENT_DIRECTORY, options)
   
  // Serve files in directory
  const serve = serveStatic(CONTENT_DIRECTORY)
   
  // Create server and respond
  const server = http.createServer(function onRequest (req, res) {
    console.log('Request received >' + req.url)
    const done = finalHandler(req, res)
    serve(req, res, function onNext (err) {
      
      if (err) {
        console.log(JSON.stringify(err))
        return done(err)
      }
      index(req, res, done)
    })
  })
   
  // Listen
  server.listen(PORT)
  console.log('Now listening on port >' + PORT)
} 
  
