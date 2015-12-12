#!/usr/bin/env coffee

fs = require('fs')
path = require('path')
_ = require('underscore')
marked = require('marked')
nsh = require('node-syntaxhighlighter')
language =  require('jsx-syntaxhighlighter')

# marked is a markdown to html converter
marked.setOptions(
  highlight: (code) ->
    nsh.highlight(code, language) 
)

### 
  This script generates the docs/index.html file
###

DOCS_SRC_DIR = 'src/docs'
DOCS_TARGET_DIR = 'docs'

indexTemplate = _.template(fs.readFileSync('src/docs/index.tpl').toString())
headerTemplate = _.template(fs.readFileSync('src/docs/header.tpl').toString())

demoTemplate = _.template """
  <div id="<%= whichDemo %>Demo" class="inline-demo"></div>
  <script>
    $(function() {
      ReactDOM.render(React.createElement(<%= demoClass %>), $('#<%= whichDemo %>Demo')[0]);
    })
  </script>
  <em> go ahead, you know you want to try it </em>
"""

unless 'grunt' in process.argv
  throw "You should probably use `grunt docs` instead"

readmeHtml = marked(fs.readFileSync('README.md').toString())

# we can do better than static images when running on github.io pages :)
readmeHtml = readmeHtml.replace /\<img.*model.*\.png.*\/\>/g,
  demoTemplate(whichDemo: 'model', demoClass: 'KittenCard')
readmeHtml = readmeHtml.replace /\<img.*form.*\.png.*\/\>/g, 
  demoTemplate(whichDemo: 'form', demoClass: 'KittenForm')

headerHtml = headerTemplate(relativeRoot: '..', selectedItem: 0)

indexHtml = indexTemplate(
  relativeRoot: '..'
  header: headerHtml
  content: readmeHtml
  bodyClass: 'docs-index'
)

outPath = path.join(DOCS_TARGET_DIR, 'index.html')

console.log "creating #{outPath}"
fs.writeFileSync outPath, indexHtml


