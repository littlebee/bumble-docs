_ = require('underscore')
fs = require('fs')
path = require('path')
glob = require('glob')
Str = require('bumble-strings')

module.exports = class Documentor 
  # comments get handled first, if we are in a comment, then 
  commentRegex: /\#\#\#/g
  closedCommentRegex: /\#\#\#.*\#\#\#/g
  pragmaRegex: /\#\#\#\s*\!pragma.*\#\#\#/g
  methodRegex: /^\s*((this\.|\@)*[\w\.]*)\s*[\:\=]\s*\(?(.*)\)?\s*[\-\=]\>.*/
  classRegex: /^.*class\s+([\w\.]+)\s*(extends(.*))?\s*$/
  propTypesRegex: /^(\s*)[^\#]*[\@\.]propTypes.*$/
  contextTypesRegex: /^(\s*)[^\#]*[\@\.]contextTypes.*$/
  defaultPropsRegex: /^(\s*)[^\#]*[\@\.]defaultProps.*$/
  defaultOptionsRegex: /^.*\_\.defaults.*options.*$/
  

  constructor: (options={}) ->
    @options = _.defaults options,
      verbose: false


  processFiles: (srcDirs, moduleData) ->
    srcDirs = [srcDirs] unless _.isArray srcDirs
    for srcDir in srcDirs
      isGlob = Str.has(srcDir, "*")
      unless isGlob 
        if fs.existsSync(srcDir) && fs.lstatSync(srcDir).isDirectory()
          srcDir = path.join(srcDir, "**/(*.coffee|*.cjsx)")
          isGlob = true
      
      if isGlob
        files = glob.sync(srcDir, nodir: true)
        for file in files
          moduleData = @processFile(file, moduleData)
      else
        moduleData = @processFile(srcDir, moduleData)
      
    return moduleData

  
  processFile: (file, moduleData) =>
    @reset()  

    console.log "Processing #{file}..." if @options.verbose
    @moduleData = _.extend {}, @_getDefaultModuleData(), moduleData
    
    @handleSideFileComments(file)
    
    lines = fs.readFileSync(file).toString().split("\n");
    for line, lineNumber in lines
      continue unless line? && Str.trim(line, {all: true}).length > 0
      continue if @handlePropTypes(line)
      continue if @handleDefaultProps(line)
      continue if @handleContextTypes(line)
      continue if @handleComment(line)
      continue if @handleClass(line, lineNumber, file)
      continue if @handleMethod(line, lineNumber, file)
      continue if @handleDefaultOptions(line)
      
    return @moduleData
  
  reset: ->
    @currentFile = null
    @currentClass = null

    @lastClassIndex = null
    @lastMethodIndex = null
    
    @inComment = false
    @lastComments = []
    
    @inBlock = null  # whould be which block by name
    
  ###
        IMPLEMENTATION
  ###
  
  
  # returns the last unclaimed comment found
  claimComment: () =>
    comments = @lastComments
    @lastComments = []
    return comments
    
    
  # the first class comment in file can be pulled in from a file of the same
  # name with the .md extension
  handleSideFileComments: (file) =>
    ext = path.extname(file)
    mdFile = file.slice(0, -1 * ext.length) + ".md"
    if fs.existsSync(mdFile)
      console.log("found sidefile comments: #{mdFile}") if @options.verbose
      @lastComments = fs.readFileSync(mdFile).toString().split("\n")
      
      
  handleComment: (line) =>
    matches = !@pragmaRegex.test(line) && @commentRegex.test(line)
    # if matches
    #   console.log 'matches', matches, line,  !@pragmaRegex.test(line)
      
    if @inComment
      unless @inCode 
        # otherwise Marked will treat it as code
        line = Str.trim(line)
      
      @inCode ^= /^\s*\`\`\`/.test(line)
      
      if matches
        @inComment = false
      else
        @lastComments.push line
      return true
    else if matches
      if @closedCommentRegex.test line
        @lastComments.push line.replace(/\#\#\#/g, '')
      else
        @inComment = true
        @inCode = false

      return true
      
    return false
    
      
  handlePropTypes: (line) =>
    if @currentClass 
      return @_handleBlockType(line, @propTypesRegex, @currentClass, 'propTypes')
    return false
    
    
  handleDefaultProps: (line) =>
    if @currentClass 
      return @_handleBlockType(line, @defaultPropsRegex, @currentClass, 'defaultProps')
    return false
    
    
  handleContextTypes: (line) =>
    if @currentClass 
      return @_handleBlockType(line, @contextTypesRegex, @currentClass, 'contextTypes')
    return false
    
    
  handleDefaultOptions: (line) =>
    if @currentMethod 
      return @_handleBlockType(line, @defaultOptionsRegex, @currentMethod, 'defaultOptions')
    return false
    
    
    
  _handleBlockType: (line, regex, storageObj, type) =>
    # console.log '_handleBlockType', line, regex, type, @inblock
    
    if @inBlock == type
      matches = line.match /^(\s*).*$/
      return true unless matches?.length > 1
      whitespace = matches[1]
      if whitespace.length == 0 || whitespace.length > (@currentWhiteSpace?.length || 0)
        storageObj[type] ||= []
        storageObj[type].push line
      else
        @inBlock = null
        @currentWhitespace = null
        return false
        
      return true;
    
    else 
      matches = line.match(regex)
      if matches?.length > 0
        @inBlock = type
        @currentWhiteSpace = matches[1]
        storageObj[type] ||= []
        storageObj[type].push line
        return true
    
    return false
    
    
  handleClass: (line, lineNumber, file) =>
    matches = line.match(@classRegex)
    return false unless matches?.length > 0
    comment = @claimComment()
    @createClassRecord(matches[1], matches[3], comment, line, lineNumber, file)
    
    
  handleMethod: (line, lineNumber, file) =>
    matches = line.match(@methodRegex)
    name = matches?[1]
    return false unless matches?.length > 0 && name[0] != '_' 
    comment = @claimComment()
    @createMethodRecord(name, comment, line, lineNumber, file)
    

  createClassRecord: (name, superClass, comment, line, lineNumber, file) =>
    @currentClass =
      id: _.uniqueId("dd_")
      name:    name
      comment: comment
      lineNumber: lineNumber
      file: file
      signature: line
      superClass: superClass
      methods: []
    @moduleData.classes.push @currentClass


  createMethodRecord: (name, comment, line, lineNumber, file) =>
    @currentMethod =
      id: _.uniqueId("dd_")
      name: name
      comment: comment
      lineNumber: lineNumber
      file: file
      signature: line
      
    if @currentClass
      @currentClass.methods.push @currentMethod
    else 
      @moduleData.methods.push @currentMethod


  _getDefaultModuleData: (moduleName) => 
    "id": _.uniqueId("dd_")
    "files": []
    "classes": []
    "methods": []

  


