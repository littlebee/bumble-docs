
React = require('react')
_ = require('underscore')
Str = require('bumble-strings')
Util = require('../lib/util')

Markdown = require './markdown'


class Method extends React.Component 
  render: ->
    className = "method" 
    className += @props.className if @props.className?
    label = @props.method.signature.replace(/(^\s*|\s*\=\>|\s*\:\s*|\-\>|\@)/g, '').replace()
    <div id={@props.id} className={className}>
      <h5 className="method-name">{label}</h5>
      <Markdown className="no-gutter" content={@props.method.comment}/>
    </div>
    
    
  renderDefaultOptions: ->
    defaultOptions = @props.method.defaultOptions?.slice(1).join('\n')
    return null unless defaultOptions?
  
    <h4>Default Options:</h4>
    <pre>
      {defaultOptions}
    </pre>
    
      
###
  renders all documented class methods
  if @props.allMethods == true then returns undocumented methods too
###
class Methods extends React.Component
  render: ->
    return null unless @props.methods?.length > 0
    <div className={@props.className}>
      <h4>{@props.label}</h4>
      { @renderMethods() }
    </div>
    
  renderMethods: ()->
    renderedMethods = for method, index in @props.methods
      id = @props.klass.name + "_" + method.name.replace(/^\s*(\@|this\.)/, '')
      key = id + '-' + index
      <Method id={id} method={method} key={key}/>
    return renderedMethods
    

class ClassMethods extends React.Component
  render: ->
    <Methods classMethods 
      klass={@props.klass} 
      methods={Util.getClassMethods(@props.klass.methods, @props.allMethods)}
      className="class-methods" 
      label="#{@props.klass.name} Class Methods:" 
      allMethods={@props.allMethods}
    />
    
    
class InstanceMethods extends React.Component
  render: ->
    <Methods 
      klass={@props.klass} 
      methods={Util.getInstanceMethods(@props.klass.methods, @props.allMethods)}
      className="instance-methods" 
      label="#{@props.klass.name} Instance Methods:" 
      allMethods={@props.allMethods}
    />
    
    
class module.exports extends React.Component
  render: ->
    <div className="methods">
      <ClassMethods klass={@props.klass}/>
      <InstanceMethods klass={@props.klass}/>
    </div>
    
  
    
    