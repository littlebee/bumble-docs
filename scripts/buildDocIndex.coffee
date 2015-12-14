#!/usr/bin/env coffee

#!/usr/bin/env coffee
OUTPUT_FILE = "docs/index.html"

app = require('../src/lib/app')

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

fs = require('fs')
path = require('path')
_ = require('underscore')
marked = require('marked')
nsh = require('node-syntaxhighlighter')
language =  require('jsx-syntaxhighlighter')

# script expects to be 
DOCS_TARGET_DIR = 'docs'
OUR_ROOT = path.join('node_modules', 'bumble-docs')
SRC_DIR = path.join(OUR_ROOT, 'src')

# marked is a markdown to html converter
marked.setOptions(
  highlight: (code) ->
    nsh.highlight(code, language) 
)

indexTemplate = app.loadTemplate('index.tpl')
headerTemplate = app.loadTemplate('header.tpl')

readmeHtml = marked(fs.readFileSync('README.md').toString())

headerHtml = headerTemplate
  relativeRoot: '..' 
  selectedItem: 0
  npmPackage: app.userNpmPackage
  configFile: app.configFile
    
indexHtml = indexTemplate
  relativeRoot: '..'
  header: headerHtml
  content: readmeHtml
  bodyClass: 'docs-index'

console.log "creating #{options.outputFile}"
fs.writeFileSync options.outputFile, indexHtml


