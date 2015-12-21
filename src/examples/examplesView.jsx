
var Rd = ReactDatum
var Tilegrid = ReactTilegrid

// This is the source for the left-right iframe viewer used to
// view examples on our github.io pages like http://zulily.github.io/react-datum/docs/examples
//
// this file is created by bumble-docs if it doesn't exist in the docs/examples dir

// EXAMPLES_METADATA is loaded by the index.html from ./examplesMetadata.js which is generated
// by bumble-docs/scripts/buildExamples.coffee
var examplesCollection = new Backbone.Collection(EXAMPLES_METADATA.demos)


// Each of the demos are wrapped in their own .html which is generated using /src/docs/exampleFile.tpl  
// It makes each of them individually debuggable.  

var DemoIframe = React.createClass({
  propTypes: {
    model: React.PropTypes.instanceOf(Backbone.Model)
  }, 
  contextTypes: {
    model: React.PropTypes.instanceOf(Backbone.Model)
  },
  render: function() {
    var model = this.getModel()
    var srcPath = model.get('path')
    var htmlPath = srcPath.replace(/(.*)(\.jsx|\.js|\.coffee|\.cjsx)/, "$1.html")
    return <iframe src={htmlPath}/>
  },
  
  getModel: function() {
    return this.props.model || this.context.model
  },
})


var ExamplesView = React.createClass({
  render: function() {
    return (
      <div id="examplesView">
        <Rd.Collection collection={examplesCollection}>
          <Rd.Tilegrid>
            <Rd.LazyPhoto attr="thumbnailUrl"/>
            <h4><Rd.Text attr="name"/></h4>
            <div><Rd.Text attr="description" ellipsizeAt={false} displayAsHtml/></div>
          </Rd.Tilegrid>
          <div className="content-pane">
            <Rd.SelectedModel placeholder="Select a demo from the list on the left">
              <DemoIframe/>  
            </Rd.SelectedModel>
          </div>
        </Rd.Collection>
      </div>
    )
  },
  componentDidMount: function() {
    if( window && window.location && window.location.hash ){
      var idToSelect = window.location.hash.slice(1)
      _.delay(function(){examplesCollection.selectModelById(idToSelect)}, 1000)
    }
    examplesCollection.on('selectionsChanged', function(){
      var model = examplesCollection.getSelectedModels()[0]
      window.location.hash = model && model.id || ""
    })

  }
  
})

if( window )
  window.Demo = ExamplesView
else if ( module )
  module.exports = ExamplesView
