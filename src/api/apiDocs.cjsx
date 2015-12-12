    
React = require('react')
_ = require('underscore')

marked = require('marked')
nsh = require('node-syntaxhighlighter')
language =  require('jsx-syntaxhighlighter')

# marked is a markdown to html converter
marked.setOptions(
  highlight: (code) ->
    nsh.highlight(code, language) 
)


    
TocListItems = React.createClass
  render: ->
    lis = []
    for klass in @props.listComponents
      lis.push <li key={klass.id}>
        <a href={'#' + klass.name}>{klass.name}</a>
      </li>
    
    return (
      <ul>
        {lis}
      </ul>
    )
    
TocSection = React.createClass
  render: ->
    return null unless @props.listComponents?.length > 0
    <section>
      <h4>{@props.label}</h4>
      <TocListItems {...@props}/>
    </section>
    
    
Toc = React.createClass 
  render: ->
    <div className="toc no-print">
      <TocSection label="Datum Components" listComponents={@props.datumClasses}/>
      <TocSection label="Contextual Components" listComponents={@props.otherClasses}/>
    </div>


Markdown = React.createClass
  render: ->
    content = @props.content
    return null unless content?
    content = @props.content.join("\n") if _.isArray(@props.content)
    label = if @props.label then <h4>{@props.label}</h4> else null
    markdown = <span dangerouslySetInnerHTML={{__html: marked(content)}}/>
    
    return (
      className = "markdown " + @props.className
      <div id={@props.id} className={className}>
        {label}
        {markdown}
      </div>
    )
    
    
ClassVariable = React.createClass
  render: ->
    code = @props.klass[@props.attr]
    return null unless code?.length > 0
    
    <div id="#{@props.klass.name}-#{@props.attr}">
        <h4>{@props.klass.name} {@props.attr}:</h4>
        {@renderLinks(code, @props.attr)}
        <Markdown className="no-gutter" content={code.slice(1)} />
    </div>
    
  renderLinks: (code, attr)->
    # pull out any extends to show "see also link to other api doc"
    matches = code[0].match(/^[^\:]*\:\s*(\_\.extend[^\,]*\,\s*([^\,]*)?\,?\s*([^\,]*)?\,?\s*([^\,]*))?/)
    links = []
    for extendedClassVar, index in matches.slice(2) 
      if extendedClassVar?.length > 0
        links.push <a href="##{extendedClassVar.replace('.', '-')}" key="#{attr}-#{index}">{extendedClassVar}</a>
    
    return null unless links.length > 0
    
    <div className='classvar-reference'>
      <label>See Also: </label>
      {links}
    </div>
    
    
DocSection = React.createClass
  render: ->
    <section>
      <h2>{@props.label}</h2>
      {@renderComponentDocs()}
    </section>
    
  renderComponentDocs: ->
    return null unless @props.listComponents?.length > 0
    contents = []
    for klass in @props.listComponents
      contents.push( 
        <div className="component-doc" id={klass.name} key={klass.id}>
          <div className="signature">{klass.signature}</div>
          <h3>{klass.name}</h3>
          <div className="content">
            <Markdown content={klass.comment}/>
            <ClassVariable klass={klass} attr="propTypes"/>
            <ClassVariable klass={klass} attr="defaultProps"/>
            <ClassVariable klass={klass} attr="contextTypes"/>
          </div>
        </div>      
      )
    return contents
      

DocContent = React.createClass 
  render: ->
    <div className='doc-content'>
      <DocSection label="Datum Components" listComponents={@props.datumClasses}/> 
      <DocSection label="Contextual Components" listComponents={@props.otherClasses}/>
    </div>

    
module.exports = ApiDocs = React.createClass 
  render: ->
    <div className='api-docs'>
      <Toc {...@props}/>
      <DocContent {...@props}/>
    </div>