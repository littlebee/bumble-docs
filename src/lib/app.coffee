
# utilities specific to this package only (like where things are and stuff)

fs = require 'fs-extra'
path = require 'path'
glob = require 'glob'
_ = require 'underscore'

require('coffee-react/register') #  jit compile .coffee and .cjsx on require

OUR_TEMPLATE_DIR = 'node_modules/bumble-docs/src/'

util = require './util'

configFileFound = false

# node.js will not allow us to require something from the user app's dir, so
# copy it to bumble-docs root 
for confFile in ["bumbleDocs.coffee", "bumbleDocs.js"]
  if fs.existsSync(confFile)
    fs.copySync(confFile, path.join("node_modules", "bumble-docs", confFile))
    configFileFound = true


# ... and require it from there
if configFileFound
  configFile = require('../../bumbleDocs') # copied from the user app's root dir

module.exports = class App 

  @bumbleRelativeRoot: './node_modules/bumble-docs/'
  @ourNpmPackage:  util.parseJsonFile('node_modules/bumble-docs/package.json')
  @userNpmPackage: util.parseJsonFile('package.json')
  @configFile: configFile
  
  # these are the vendor scripts that get loaded when the doc pages load in the browser
  # they are in dependency order
  @ourRequiredPageVendorScripts: [
    { src: "node_modules/react/umd/react.development.js",           dest: "docs/vendor/react.js"}
    { src: "node_modules/react-dom/umd/react-dom.development.js",   dest: "docs/vendor/react-dom.js"}
    { src: "node_modules/prop-types/prop-types.js",                 dest: "docs/vendor/prop-types.js"}
    { src: "node_modules/jquery/dist/jquery.min.js",                dest: "docs/vendor/jquery.js"}
    { src: "node_modules/underscore/underscore-min.js",             dest: "docs/vendor/underscrore.js"}
    { src: "node_modules/backbone/backbone-min.js",                 dest: "docs/vendor/backbone.js"}
    { src: "node_modules/react-datum/dist/react-datum.js",          dest: "docs/vendor/react-datum.js"}
    { src: "node_modules/tilegrid/dist/tilegrid.js",                dest: "docs/vendor/tilegrid.js"}
  ]
  
  
  @loadTemplate: (templateFile) ->
    return _.template(fs.readFileSync(path.join(OUR_TEMPLATE_DIR, templateFile)).toString())
    
    
  # creates docs/ dir in application using us's root. Adds files that are missing 
  @initDocsDir: () ->
    return false unless configFile?
    
    for dir in ['./docs', './docs/api', './docs/css', './docs/examples', './docs/img']
      fs.mkdirSync(dir) unless fs.existsSync(dir)

    # for now, no vendor js is shipped with this repo and if it is, it should be copied 
    #  from node_modules the way that react-datum Gruntfile does it
    for fileSpec in ["css/*.css"]   # , "vendor/*.js"]     
      files = glob.sync(@bumbleRelativeRoot + fileSpec)
      [dir] = fileSpec.split('/')
      for file in files
        target = "./docs/#{dir}/" + path.basename(file)
        fs.copySync(file, target, clobber: true)
    if configFile.examples?
      for fileSpec in ["src/examples/loadExample.js", 'src/examples/loadExamplesView.js']
        fs.copySync(@bumbleRelativeRoot + fileSpec, "docs/examples/" + path.basename(fileSpec))
    
  