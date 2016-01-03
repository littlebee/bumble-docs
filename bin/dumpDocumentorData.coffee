#!/usr/bin/env coffee

util = require('../src/lib/util')
app = require('../src/lib/app')

HELP = """
  This script shows the data collected by the documentor on your source in JSON format  
  
  See also bumble-docs/bin/buildApiDocs script.
"""
options = require('commander')
  .version(app.ourNpmPackage.version)
  .option('-c --allClasses', 'TODO: add undocumented classes to documentorData')
  .option('-m --allMethods', 'TODO: add undocumented methods to documentorData')
  .option('-v --verbose', 'I like lots of console output')
  .on('--help', () -> console.log HELP)
options.parse(process.argv)

Documentor = require('../src/api/documentor')

debugger

app.initDocsDir()   # so we can get access to user's bumbleDocs.coffee config
documentor = new Documentor(options)

sections = app.configFile.apiDocs.sections
for section in sections
  documentorData = documentor.processFiles(section.path)
  console.log JSON.stringify(documentorData, null, " ")
  

