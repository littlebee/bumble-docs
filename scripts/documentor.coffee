#!/usr/bin/env coffee

HELP = """
  
  ************************************************************************************
  For debugging only. This script and it's output file are not currently used by the 
  build or by the online docs. 
  ************************************************************************************
  
  This script walks a tree of coffeescript and pulls out any ### comments and
  associates them with the next indent level out and up.  A .js file containing
  an array with the structure below is produced.

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
      this block comment gets associated with the constructor method.  putting it after
      the defaulting of options makes the options self documenting no?
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
  From the root directory:
  ```
    scripts/documentor.coffee ./src
  ```

  generates documentorData.js file in current directory that contains:
  ```javascript
    var documentorData = [
      {
        "moduleName": "optional name given when running documentor or the path given to document",
        // both files and classes only have information in here if they are documented (have ###
        // comments at the same indentation level
    ...
  ```
  the output js file can then be loaded for a documentation page and a notjs script can pick it up and spit out the
  API documentation (see index.html in notjs root)

  

  Developer's note:  I really wanted to generate JSON data and pull that in from the script on the page,
  but then the documentation would only be viewable if served up remotely and I'd really like people to be
  able to view the API docs locally via a file:// url


"""

###

  Generates docs/documentorData.js  

###
utils = require('./lib/util')

options = require('commander')
  .version('0.0.1')
  .option('-o --outputFile [path]', 'output path and file name of file to generate [./documentorData.js]', './documentorData.js')
  .option('-n --name [name]', 'name to add to module in documentor data. defaults to src file path')
  .option('-c --allClasses)', 'add undocumented classes to documentorData')
  .option('-m --allMethods)', 'add undocumented methods to documentorData')
  .option('-v --verbose', 'I like lots of output')
  .on('--help', () -> console.log HELP)

srcDir = null
options.command('*')
  .description('source dir')
  .action (arg) =>
    srcDir = arg
    # console.log 'arg = "%s"', arg
options.parse(process.argv)

unless srcDir
  console.log "fail: This script requires one parameter, the src dir, use --help for more information"
  process.exit(1);

_ = require('underscore')
fs = require('fs')
path = require('path')
glob = require('glob')

debugger


# filters out classes without comments (block comment) and methods without comment
filterDocumentorData = (moduleData) =>
  unless options.allClasses
    moduleData.classes = _.filter moduleData.classes, (c) -> c.comment.length > 0
  
  for klass in moduleData.classes
    unless options.allMethods
      klass.methods = _.filter klass.methods, (m) -> m.comment.length > 0
      
            
createOutputFile = (moduleData) =>
  filterDocumentorData(moduleData)
  console.log "creating #{options.outputFile}"
  
  output = "base = (typeof moduleData !== 'undefined' && moduleData.exports) ? root : window\n" +
           "base.documentorData = #{JSON.stringify(moduleData, null, "  ")};\n"
  fs.writeFileSync options.outputFile, output


console.log """
For debugging only. This script and it's output file are not currently used by the 
build or by the online docs.  

See src/docs/api/documentor.coffee for the common class used by this cli tool and 
scripts/buildApiDocs.coffee which builds the online docs
"""
utils.pressAnyKeyToContinue ->

  moduleData = {name: "react-datum"};

  Documentor = require('../src/docs/api/documentor')
  documentor = new Documentor(verbose: options.verbose)
  moduleData = documentor.processFiles(srcDir, moduleData)
  createOutputFile(moduleData)
  process.exit 0
  
  
  

