
# utilities specific to this package only (like where things are and stuff)

fs = require 'fs-extra'
path = require 'path'
glob = require 'glob'
_ = require 'underscore'

require('coffee-react/register') #  jit compile .coffee and .cjsx on require

OUR_TEMPLATE_DIR = 'node_modules/bumble-docs/src/'

util = require './util'

# node.js will not allow us to require something from the user app's dir, so
# copy it to bumble-docs root 
for confFile in ["bumbleDocs.coffee", "bumbleDocs.js"]
  if fs.existsSync(confFile)
    fs.copySync(confFile, "node_modules/bumble-docs/" + confFile)

# ... and require it from there
configFile = require('../../bumbleDocs') # copied from the user app's root dir

module.exports = class App 
  
  @loadTemplate: (templateFile) ->
    return _.template(fs.readFileSync(path.join(OUR_TEMPLATE_DIR, templateFile)).toString())
    
    
  # creates docs/ dir in application using us's root. Adds files that are missing 
  @initDocsDir: () ->
    for dir in ['./docs', './docs/api', './docs/css', './docs/examples', './docs/img']
      fs.mkdirSync(dir) unless fs.existsSync(dir)

    for fileSpec in ["css/*.css", "vendor/*.js"]
      files = glob.sync('./node_modules/bumble-docs/' + fileSpec)
      [dir] = fileSpec.split('/')
      for file in files
        target = "./docs/#{dir}/" + path.basename(file)
        fs.copySync(file, target, clobber: true)
    
  @ourNpmPackage:  util.parseJsonFile('node_modules/bumble-docs/package.json')
  
  @userNpmPackage: util.parseJsonFile('package.json')
  
  @configFile: configFile

    
  