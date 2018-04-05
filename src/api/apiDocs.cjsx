    
React = require('react')

Toc = require('./toc')
DocContent = require('./docContent')

    
module.exports = class ApiDocs  extends React.Component 
  render: ->
    <div className='api-docs'>
      <Toc {...@props}/>
      <DocContent {...@props}/>
    </div>
    
  proptypes: ->
    return 
      
    
    