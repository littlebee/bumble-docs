
React = require('react')
_ = require('underscore')

Markdown = require('./markdown')
Methods = require('./methods')

ClassVariable = React.createClass
  render: ->
    code = @props.klass[@props.attr]
    return null unless @props.force || code?.length > 0 
    
    links = @renderLinks()
    markdown = @renderMarkdown()
    return null unless links? or markdown?
    
    # console.log "debug @props.klass", @props.klass
    <div id="#{@props.klass.name}-#{@props.attr}">
        <h4>{@props.klass.name} {@props.attr}:</h4>
        {links}
        {markdown}
    </div>
    

  # pull out any extends to show "see also link to other api doc"
  renderLinks: ()->
    matches = @props.klass.signature.match(/^.*\s*extends\s*(.*)/)
    extendedClassName = matches?[1]
    return null if !extendedClassName? || extendedClassName == 'React.Component'
    
    <div className='classvar-reference'>
      <label>See Also: </label>
      <a href="##{extendedClassName}-#{@props.attr}">{extendedClassName} {@props.attr}</a>
    </div>

    
  renderMarkdown: ->
    code = @props.klass[@props.attr]
    return null unless code?
    <Markdown className="no-gutter" content={code.slice(1)} />
    
    
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
            <ClassVariable klass={klass} attr="propTypes" force={true}/>
            <ClassVariable klass={klass} attr="defaultProps" force={true}/>
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