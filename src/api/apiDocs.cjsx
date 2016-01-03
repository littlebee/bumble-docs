    
React = require('react')

Toc = require('./toc')
DocContent = require('./docContent')

    
module.exports = ApiDocs = React.createClass 
  render: ->
    <div className='api-docs'>
      <Toc {...@props}/>
      <DocContent {...@props}/>
    </div>
    
  proptypes: ->
    return 
      
    
    