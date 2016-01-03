React = require('react')
_ = require('underscore')
Str = require('bumble-strings')

marked = require('marked')
nsh = require('node-syntaxhighlighter')
language =  require('jsx-syntaxhighlighter')

# marked is a markdown to html converter
marked.setOptions
  highlight: (code) ->
    nsh.highlight(code, language) 
  sanitize: false
  pedantic: true


module.exports = Markdown = React.createClass
  render: ->
    contents = @getContents()
    return null unless contents?
    label = if @props.label then <h4>{@props.label}</h4> else null
    markdown = <span dangerouslySetInnerHTML={{__html: marked(contents)}}/>
    
    return (
      className = "markdown " + @props.className
      <div id={@props.id} className={className}>
        {label}
        {markdown}
      </div>
    )
    
    
  getContents: () ->
    contents = if _.isArray(@props.content) then @props.content else [@props.content]
    return contents.join("\n") 
      

    
    
    
