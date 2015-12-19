
React = require('react')

Util = require('../lib/util')

module.exports = class exampleFile extends React.Component
  
  render: ->
    <div className="example">
      <div className="demo-pane">
        <button className="more btn btn-primary" data-which="demo">Show More Demo!</button>
        <h3>The Demo:</h3> 
        <div id="demo">
          
        </div>
      </div>
      <div className='code-pane'>
        <button className="more btn btn-primary" data-which="code">Show More Code!</button>
        <h3>The Code:</h3> 
        <div dangerouslySetInnerHTML={{__html: @props.sourceCode}}/>
      </div>
      <script src={@props.sourceFile}/>
      <script src="#{@props.relativeRoot}/docs/examples/loadExample.js"/>
    </div>
    
