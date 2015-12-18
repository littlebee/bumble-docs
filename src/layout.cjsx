
React = require('react')
_ = require('underscore')

Util = require('./lib/util')
Header = require('./header')
Str = require('bumble-strings')

# this is the base set, page props at render add to these depending on the page
# being rendered


module.exports = class Layout extends React.Component
  # styles sheets can also be added to by the @props or via user bumbleDocs.js config file
  # in @props.configFile.
  styleSheets: [{
    path: "/docs/css/react-datum.css"
  },{
    path: "/docs/css/bootstrap-light.css"
  },{
    path: "/docs/css/syntaxHighlight.css"
  },{
    path: "/docs/css/docs.css"
    media: "screen"
  },{
    path: "/docs/css/example.css"
    media: "screen"
  },{
    path: "/docs/css/print.css"
    media: "print"
  }]  

  # additional scripts can also be added to by the @props or via user bumbleDocs.js config file
  # in @props.configFile.
  # scripts can can also include type.  type is assumed to be "text/javascript" if not specified
  scripts: [{
    path:     "/docs/vendor/jquery.min.js"
  },{
    path:     "/docs/vendor/underscore-min.js"
  },{
    path:     "/docs/vendor/backbone-min.js"
  },{
    path:     "/docs/vendor/react.min.js"
  },{
    path:     "/docs/vendor/react-dom.min.js"
  },{
    path:     "/docs/vendor/react-datum.min.js"
  },{
    path:     "/docs/examples/examplesMetadata.js"
  }]
  
  render: ->
    <html>
      <head>
        <meta charSet='utf-8'/>
        <meta httpEquiv="X-UA-Compatible" content="chrome=1"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
        
        {@renderStyleSheets()}
        <title>react-datum</title>
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
    things = things.concat(@props[type]) if @props[type]?

    # load any user style sheets or scripts last so they get final word up
    configFileThings = @props.configFile?[type] || []
    things = things.concat(configFileThings)

    return things
      
