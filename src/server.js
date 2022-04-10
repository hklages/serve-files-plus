'use strict'

/** 
 * Serves files or shows directory index in a given directory and its subdirectory.
 * 
 * ENV variables
 * - COL: number of columns in directory listing, '4' to '10', default is '4'
 * 
 * - DOCKER: to run non-Docker NodeJS use 'n', default ist 'y'
 * - CONTENT_DIRECTORY: location of served content, default is /opt/public
 * The last to are only used for testing on native NodeJS (not in container) 
 * 
 * from: https://www.npmjs.com/package/serve-index
*/

const http = require('http')
const finalHandler = require('finalhandler')
const serveIndex = require('serve-index')
const serveStatic = require('serve-static')

const CONTENT_DIRECTORY = process.env.CONTENT_DIRECTORY || '/opt/public'
const DOCKER = process.env.DOCKER || 'y'
const COL = process.env.COL || '4'

const PORT = 3000

// Serve directory index - enable different number of columns
if (['4', '5', '6', '7', '8', '9', '10'].indexOf(COL) < 0) {
  console.log('Invalid env value for COL (4 to 10) >' + COL)

} else {
 
  let options
  if (DOCKER === 'y') {
    options = {
      'icons': true,
      'template': '/opt/serve-files-plus/src/templates/directory.html',
      'stylesheet': `/opt/serve-files-plus/src/templates/style${COL}.css`
    }
  } else { // for NodeJS test environment
    options = {
      'icons': true,
      'template': './src/templates/directory.html',
      'stylesheet': `./src/templates/style${COL}.css`
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
  
