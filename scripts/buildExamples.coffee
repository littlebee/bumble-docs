#!/usr/bin/env coffee

app = require('../src/lib/app')

OUTPUT_DIR = "docs/examples"

HELP = """
  This script generates a small HTML wrapper around each example in 
  the examples attribute of bumbleDocs config file that will show the 
  source left and the result of executing the example on the right

  Results are written to directory specifified in outputDir option
  #{OUTPUT_DIR} 
  
  This script also creates the example viewer app in docs/examples/index.html

  From your project root directory:
  ```
    node_modules/bumble-docs/scripts/buildExamples.coffee 
  ```
  
"""
options = require('commander')
  .version(app.ourNpmPackage.version)
  .option('-o --outputDir [path]', 
    'output path where to generate example content',  OUTPUT_DIR)
  .option('-v --verbose', 'I like lots of console output')
  .on('--help', () -> console.log HELP)
options.parse(process.argv)

app.initDocsDir()


glob = require('glob')
fs = require('fs-extra')
path = require('path')
nsh = require('node-syntaxhighlighter')
language =  require('jsx-syntaxhighlighter')
_ = require('underscore')
moment = require('moment')

coffeeReact = require('coffee-react')
jsxTransform = require('coffee-react/lib/js-syntax-transform')

debugger

exampleTemplate = app.loadTemplate('exampleFile.tpl')
indexTemplate = app.loadTemplate('index.tpl')
headerTemplate = app.loadTemplate('header.tpl')
contentTemplate = app.loadTemplate('examplesContent.tpl')

headerHtml = headerTemplate
  relativeRoot: '../..'
  selectedItem: 1
  npmPackage: app.userNpmPackage
  configFile: app.configFile

contentHtml = contentTemplate()

indexHtml = indexTemplate(
  relativeRoot: '../..'
  header: headerHtml
  content: contentHtml
  bodyClass: 'examples-index'
)

indexFile = path.join(options.outputDir, 'index.html')
metadataFile = path.join(options.outputDir, 'examplesMetadata.js')
fs.ensureDirSync(options.outputDir)

console.log "creating #{indexFile}"
fs.writeFileSync(indexFile, indexHtml)

console.log "creating #{metadataFile}"
fs.writeFileSync metadataFile, "window.EXAMPLES_METADATA = #{JSON.stringify(app.configFile.examples)}"

exampleRoot = app.configFile.exampleRoot
examples = app.configFile.examples

# don't add it to the metadata above / don't show it in the example viewer, but go ahead and treat
# the viewer itself as an example (react-datum shows the example viewer as a demo)
examples.push 
  id: "examplesView"
  path: "examplesView.jsx"
  

for example in app.configFile.examples
  file = example.path
  ext = path.extname(file)
  simpleName = path.basename(file, ext)
  relativePath = path.dirname(file)
  fullPathAndFile = if example.id == "examplesView" 
    "node_modules/bumble-docs/src/examples/examplesView.jsx"
  else
    path.join(exampleRoot, file)
  
  relativeRoot = ".."
  relativeRoot += "/.." for dir in relativePath.split('/')

  return unless ext in [".coffee", ".js", ".jsx", ".cjsx"]
  
  fs.ensureDirSync(path.join(options.outputDir, relativePath))
  rawSource = fs.readFileSync(fullPathAndFile).toString()

  # console.log rawSource
  highlightedSource = nsh.highlight(rawSource, language) || rawSource
  
  templateArgs =
    sourceCode: highlightedSource
    # the example source compile from src/examples into respective
    # directories in docs/examples.   The compiled .js should already be there
    # as compiled there by `grunt`
    sourceFile: simpleName + '.js'
    relativeFile: file
    simpleName: simpleName
    relativeRoot: relativeRoot
    

  htmlOutputFile = path.join(options.outputDir, relativePath, simpleName + '.html')
  jsOutputFile = path.join(options.outputDir, relativePath, simpleName + '.js')
  console.log "processing file: " + file
  
  fs.writeFileSync htmlOutputFile, exampleTemplate(templateArgs)
  
  compiledJs = switch
    when ext == '.js' then rawSource
    when ext in ['.coffee', '.cjsx'] then coffeeReact.compile(rawSource) 
    when ext in ['.jsx'] then jsxTransform(rawSource)
    
  fs.writeFileSync jsOutputFile, compiledJs
  
    



