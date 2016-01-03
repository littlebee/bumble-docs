
React = require('react')
_ = require('underscore')

Markdown = require('./markdown')
Methods = require('./methods')

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
            <Methods klass={klass}/>
          </div>
        </div>      
      )
    return contents
      

module.exports = DocContent = React.createClass 
  render: ->
    <div className='doc-content'>
      {@renderSections()}
    </div>
    
  renderSections: () ->
    sections = for section,index in @props.sections
      <DocSection key={"docsection-" + index} label={section.label} listComponents={section.documentorData?.classes}/> 
    return sections