
React = require('react')
_ = require('underscore')

App = require('./lib/app')
Util = require('./lib/util')
Header = require('./header')
Str = require('bumble-strings')
Glob = require('glob')

# this is the base set, page props at render add to these depending on the page
# being rendered
vendorScripts = App.ourRequiredPageVendorScripts

module.exports = class Layout extends React.Component
  # styles sheets can also be added to by the @props or via user bumbleDocs.js config file
  # in @props.configFile.
  styleSheets: [
    {path: "/docs/css/react-datum.css"}
    {path: "/docs/css/bootstrap-light.css"}
    {path: "/docs/css/syntaxHighlight.css"}
    {path: "/docs/css/docs.css"}
    {path: "/docs/css/example.css", media: "screen"}
    {path: "/docs/css/print.css",   media: "print"}
  ]  

  # additional scripts can also be added to by the @props or via user bumbleDocs.js config file
  # in @props.configFile.
  # scripts can can also include type.  type is assumed to be "text/javascript" if not specified
  scripts: _.map(vendorScripts, (scriptMeta) -> {path: '/' + scriptMeta.dest}).concat [
    # examplesMetadata.js is generated from the examples section of the users bumbleDocs 
    # config file
    {path:     "/docs/examples/examplesMetadata.js"}
  ]
  
  constructor: ->
    super

  
  render: ->
    <html>
      <head>
        <meta charSet='utf-8'/>
        <meta httpEquiv="X-UA-Compatible" content="chrome=1"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
        
        {@renderStyleSheets()}
        <title>{@props.npmPackage.name}</title>
      </head>
      
      <body className={@props.bodyClass}>
        {@renderScripts()}
        {@renderHeader()}
        {@renderContent()}
      </body>
    </html>
        
  
  renderHeader: ->
    return null if @props.headless
    <Header {...@props}/>
  
  
  renderContent: ->
    return if @props.innerHtml?
      <div className="main-content" dangerouslySetInnerHTML={{__html: @props.innerHtml}}/>
    else
      <div className="main-content">
        {@props.children}
      </div>

      
  renderStyleSheets: ->
    elements = for stylesheetObj,index in @getStyleSheets()
      fullRelativePath = Util.urlJoin(@props.relativeRoot, stylesheetObj.path) 
      media = stylesheetObj.media
      <link rel="stylesheet" type="text/css" href={fullRelativePath} media={media} key="script-#{index}"/>
    return elements


  renderScripts: ->
    elements = for scriptObj,index in @getScripts()
      fullRelativePath = Util.urlJoin(@props.relativeRoot, scriptObj.path)
      type = scriptObj.type || "text/javascript" 
      <script type={type} src={fullRelativePath} key="script-#{index}"/>
    return elements
    
    
  getStyleSheets: ->
    return @_getAllOf('styleSheets')

      
  getScripts: ->
    return @_getAllOf('scripts')
    
    
  # type should be "scripts" or "styleSheets"
  _getAllOf: (type) ->
    things = @[type]
    things = things.concat @props.configFile?[type] || []
    
    # examples view and load script need to load last
    things = things.concat(@props[type]) if @props[type]?

    
    return things
      
