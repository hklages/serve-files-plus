'use strict'

/** 
 * Serves files or shows directory index in a given directory and its subdirectory.
 * 
 * ENV variables
 * - COL: number of columns in directory listing, '4' to '10', default is '4'
 * 
 * For testing purposes only: 
 * - DOCKER: to run non-Docker NodeJS use 'n', default ist 'y'
 * - CONTENT_DIRECTORY: location of served content, default is /opt/public
 * 
 * credits to: https://www.npmjs.com/package/serve-index
*/

const express = require('express')
const serveIndex = require('serve-index')

const app = express()

const CONTENT_DIRECTORY = process.env.CONTENT_DIRECTORY || '/opt/public'
const DOCKER = process.env.DOCKER || 'y'
const STYLE = process.env.STYLE || 'style_0'
const PORT = process.env.PORT || 3000

// set the path - docker production or non-docker development
let templatePath = '/opt/serve-files-plus/src/templates/' 
if (DOCKER === 'n') {
  templatePath = './src/templates/'
}

// default are serve-index examples
let options = {
  'icons': true,
  'template': `${templatePath}directory_original.html`,
  'stylesheet': `${templatePath}style_original.css`
}

// Serve directory index - enable different number of columns
if (['style_0', 'style_c4', 'style_c6', 'style_col8',  'style_col10'].indexOf(STYLE) >= 0) {
  options = {
    'icons': true,
    'template': `${templatePath}directory_bootstrap.html`,
    'stylesheet': `${templatePath}${STYLE}.css`
  }
}

app.use('/', express.static(CONTENT_DIRECTORY), serveIndex(CONTENT_DIRECTORY, options))
app.listen(PORT, function () {
  console.log('listening on port ' + PORT)
})