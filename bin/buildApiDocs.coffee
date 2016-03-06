#!/usr/bin/env coffee
OUTPUT_FILE = "docs/api/index.html"

util = require('../src/lib/util')
app = require('../src/lib/app')

unless app.configFile?
  console.log "./bumbleDocs.(js|coffee) not found.  Skipping api docs generation and build.  See https://github.com/littlebee/bumble-docs"
  process.exit(0)
  

unless app.configFile.apiDocs?
  console.log "`apiDocs:` section not found in ./bumbleDocs.(js|coffee).  Skipping api docs generation and build."
  process.exit(0)
  


HELP = """
  This script walks a tree of coffeescript & cjsx and pulls out any ### comments and
  associates them with the next class or method.  
    
  For classes, it will also pull out the following React declarations: propTypes, 
  defaultProps and contextTypes. 
  
  For methods, it will also detect the pattern of specifying defaults using underscore
  or lowdash _.defaults and associate those with the defaultOptions.
  
  By default the output is an html file created at #{OUTPUT_FILE}
  
  Example  (src/somefile.coffee):
  ```coffeescript  
  ###
    This block comment gets associated with the class
  ###
  class myAwesomeClass extends myAwesomeBaseClass
    
    @propTypes:
      # additional css classes (space seperated) to add to wrapper div
      className: React.PropTypes.string
      # can also accept model instance as context var. prop has precendence
      model: React.PropTypes.oneOfType([
        React.PropTypes.instanceOf(Backbone.Model)
        React.PropTypes.object
      ])
        
    
    @defaultProps:   
      # ellipsizeAt is defaulted to prevent really long strings from breaking layouts
      ellipsizeAt: 35
    
    ###
      this block comment gets associated with the constructor method. 
    ###
    constructor: (options={}) =>
      @options = _.defaults options,
        # everything from this comment down will be associated with the constructor 
        # method as "defaultOptions"
        beAwesome: true                   # will this instance be awesome?
        extendAwesomeness: true           # push awesomeness outward
        forcedAwesome: false              # can we fake it if all else fails?
        awesomeIcon: "/img/awesome.icon"
  ```
  From your project root directory:
  ```
    node_modules/bumble-docs/scripts/buildApiDocs.coffee ./src
  ```
  
"""
options = require('commander')
  .version(app.ourNpmPackage.version)
  .option('-o --outputFile [path]', 
    'output path and file name of file to generate relative to your project root',  OUTPUT_FILE)
  .option('-c --allClasses', 'TODO: add undocumented classes to documentorData')
  .option('-m --allMethods', 'TODO: add undocumented methods to documentorData')
  .option('-v --verbose', 'I like lots of console output')
  .on('--help', () -> console.log HELP)
options.parse(process.argv)

React = require('react')
ReactDOMServer = require('react-dom/server')

fs = require('fs')
path = require('path')
_ = require('underscore')
marked = require('marked')
nsh = require('node-syntaxhighlighter')
language =  require('jsx-syntaxhighlighter')
strHelp = require('bumble-strings')

Layout = require('../src/layout')

# marked is a markdown to html converter
marked.setOptions(
  highlight: (code) ->
    nsh.highlight(code, language) 
)

Documentor = require('../src/api/documentor')
ApiDocs = require('../src/api/apiDocs')
Layout = require('../src/layout')

debugger

app.initDocsDir()

documentor = new Documentor(options)

sections = app.configFile.apiDocs.sections
for section in sections
  section.documentorData = documentor.processFiles(section.path)

indexHtml = ReactDOMServer.renderToStaticMarkup React.createElement Layout,  
  relativeRoot: '../..'
  selectedTab: '/docs/api'
  npmPackage: app.userNpmPackage
  configFile: app.configFile
  innerHtml: ReactDOMServer.renderToStaticMarkup(
    React.createElement(ApiDocs, sections: sections)
  )
  bodyClass: 'api-index'

console.log "creating #{OUTPUT_FILE}"
fs.writeFileSync OUTPUT_FILE, indexHtml

