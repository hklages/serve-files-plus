'use strict'

/** 
 * Shows directory content. Enables user to drill down directory structure, view/download files
 * and copy the file link (standard browser functionality).
 * 
 * ENV variables
 * - CONTENT_DIRECTORY: location of served content, default is /opt/public
 * - STYLE: If set and equal to "style_original" the original files from serve-index are being used.
 * - DOCKER: to run non-Docker NodeJS use 'n', default ist 'y'

 * 
 * credits to: https://www.npmjs.com/package/serve-index
*/

const express = require('express')
const serveIndex = require('serve-index')

const app = express()

const CONTENT_DIRECTORY = process.env.CONTENT_DIRECTORY || '/opt/public'
const STYLE = process.env.STYLE || 'style_0'
const PORT = process.env.PORT || 3000

const DOCKER = process.env.DOCKER || 'y'

// set the path - docker production or non-docker development
let templatePath = '/opt/serve-files-plus/src/templates/' 
if (DOCKER === 'n') {
  templatePath = './src/templates/'
}

// default - my data
let options = {
  'icons': true,
  'template': `${templatePath}directory.html`,
  'stylesheet': `${templatePath}style.css`
}
// option to use the original definitions from serve-index
if (['style_original'].includes(STYLE)) {
  options = {
    'icons': true,
    'template': `${templatePath}directory_original.html`,
    'stylesheet': `${templatePath}style_original.css`
  }
}
console.log(`Using template ${options.template} and stylesheet ${options.stylesheet}`)

app.use('/', express.static(CONTENT_DIRECTORY), serveIndex(CONTENT_DIRECTORY, options))
app.listen(PORT, function () {
  console.log('listening on port ' + PORT)
})