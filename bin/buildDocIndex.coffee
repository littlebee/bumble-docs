#!/usr/bin/env coffee
fs = require('fs')
path = require('path')
_ = require('underscore')
marked = require('marked')
nsh = require('node-syntaxhighlighter')
language =  require('jsx-syntaxhighlighter')

app = require('../src/lib/app')

React = require('react')
ReactDOMServer = require('react-dom/server')
Layout = require('../src/layout')


OUTPUT_FILE = "docs/index.html"
DOCS_TARGET_DIR = 'docs'
OUR_ROOT = path.join('node_modules', 'bumble-docs')
SRC_DIR = path.join(OUR_ROOT, 'src')


HELP = """
  This script creates the docs/index.html - the main static html file.  Your project's root 
  README.md file is converted to html and embedded int he generated html for display under 
  the Introduction and Getting Started tab of the documentation.
  
  From your project root directory:
  ```
    node_modules/bumble-docs/scripts/buildDocIndex.coffee 
  ```
  
"""
options = require('commander')
  .version(app.ourNpmPackage.version)
  .option('-o --outputFile [path]', 
    'output path and file name of file to generate relative to your project root',  OUTPUT_FILE)
  .option('-v --verbose', 'I like lots of console output')
  .on('--help', () -> console.log HELP)
options.parse(process.argv)

app.initDocsDir()

# marked is a markdown to html converter
marked.setOptions(
  highlight: (code) ->
    nsh.highlight(code, language) 
)

readmeHtml = marked(fs.readFileSync('README.md').toString())

indexHtml = ReactDOMServer.renderToStaticMarkup React.createElement Layout,  
  relativeRoot: '..' 
  selectedTab: '/docs'
  npmPackage: app.userNpmPackage
  configFile: app.configFile
  innerHtml: readmeHtml
  bodyClass: 'docs-index'

console.log "creating #{options.outputFile}"
fs.writeFileSync options.outputFile, "<!DOCTYPE html>\n" + indexHtml


