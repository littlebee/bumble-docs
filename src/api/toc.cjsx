React = require('react')
Str = require('bumble-strings')
Util = require('../lib/util')
_ = require('underscore')

# builds the table of contents for the apiDocs
    
class TocListItems extends React.Component
  render: ->
    lis = []
    for klass in @props.listComponents
      lis.push <li key={klass.id}>
        <a href={'#' + klass.name}><h5>{klass.name}</h5></a>
        {@renderClassVariable(klass, 'propTypes', 'Properties', force: true)}
        {@renderClassVariable(klass, 'defaultProps', 'Default Properties')}
        {@renderClassVariable(klass, 'contextTypes', 'Context Variables')}
        {@renderClassMethods(klass)}
        {@renderInstanceMethods(klass)}
      </li>
    
    return (
      <ul>
        {lis}
      </ul>
    )
  
  renderClassVariable: (klass, attr, label, options={}) ->
    options = _.defaults options,
      force: false
      
    return null unless options.force || klass[attr]? 
    
    labelLink = "##{klass.name}-#{attr}"
    <ul>
      <a href={labelLink}>{label}</a>
    </ul>
    
    
  renderClassMethods: (klass) ->
    return null unless klass.methods?.length > 0
    methods = Util.getClassMethods(klass.methods, @props.allMethods)
    return null unless methods.length > 0
    
    <ul>
      <strong>Class Methods</strong>
      {@renderMethodLis(klass, methods)}
    </ul>
    
    
  renderInstanceMethods: (klass) ->
    return null unless klass.methods?.length > 0
    methods = Util.getInstanceMethods(klass.methods, @props.allMethods)
    return null unless methods.length > 0
    
    <ul>
      <strong>Instance Methods</strong>
      {@renderMethodLis(klass, methods)}
    </ul>
    
    
  renderMethodLis: (klass, methods) ->
    return null unless methods?.length > 0
    lisOut = for method, index in methods
      name = method.name.replace(/^\s*(this.|@)/, '')
      href = "##{klass.name}_#{name}"
      <li key={index}><a href={href}>{name}</a></li>
      
    return lisOut
    
  

    
class TocSection extends React.Component
  render: ->
    return null unless @props.listComponents?.length > 0
    <section>
      <h4>{@props.label}</h4>
      <TocListItems {...@props}/>
    </section>
    
    
module.exports = class Toc extends React.Component 
  render: ->
    <div className="toc no-print">
      {@renderTocSections()}
    </div>
    
  renderTocSections: ->
    sections = for section, index in @props.sections
      <TocSection key={"tocsection-" + index} label={section.label} listComponents={section.documentorData?.classes}/>
    return sections