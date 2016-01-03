
###
  utils for node.js scripts, cake tasks, grunt tasks

###


child_process = require "child_process"
path = require 'path'
fs = require 'fs'
_ = require 'underscore'
moment = require 'moment'

Str = require 'bumble-strings'


HOME_DIR = process.env.HOME

module.exports = class Util

  @parseJsonFile = (file) ->
    return JSON.parse(fs.readFileSync(file))

    
  @urlJoin = (paths...) ->
    paths.join('/').replace('//', '/')


  @isClassMethod: (method) =>
    Str.startsWith(method.name, ["@", "this."])

  # allMethods=true - return undocumented methods
  @getClassMethods: (methods, allMethods=false)->
    _.filter methods, (method) =>
      isClassy = @isClassMethod(method)
      truthy = isClassy && (method.comment?.length > 0 || allMethods)
      return truthy
      
  
  # allMethods=true - return undocumented methods
  @getInstanceMethods: (methods, allMethods=false)->
    _.filter methods, (method) =>
      isClassy = @isClassMethod(method)
      truthy = !isClassy && (method.comment?.length > 0 || allMethods)
      return truthy
      
  

